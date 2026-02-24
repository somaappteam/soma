import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart'
    show TargetPlatform, defaultTargetPlatform, kIsWeb;
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:soma/core/config/rtc_config.dart';
import 'package:soma/core/services/app_logger.dart';
import 'package:soma/data/auth_repository.dart';
import 'package:soma/data/circle_voice_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RtcVoiceService {
  RtcVoiceService._();

  static final RtcVoiceService instance = RtcVoiceService._();

  final SupabaseClient _client = Supabase.instance.client;

  final Map<String, RTCPeerConnection> _peers = {};
  final Map<String, RTCIceConnectionState> _peerIceStates = {};
  final Map<String, bool> _hasRemoteDescription = {};
  final Map<String, List<RTCIceCandidate>> _pendingCandidates = {};
  final Map<String, RTCVideoRenderer> _renderers = {};
  final StreamController<bool> _connectionStream =
      StreamController<bool>.broadcast();
  final StreamController<Map<String, dynamic>> _telemetryStream =
      StreamController<Map<String, dynamic>>.broadcast();

  RealtimeChannel? _signalChannel;
  MediaStream? _localStream;
  MediaStreamTrack? _localAudioTrack;

  String? _circleId;
  String? _userId;
  bool _joined = false;
  bool _muted = false;
  bool _lastSpeaking = false;
  bool _asSpeaker = true;
  bool _prioritySpeaker = false;

  String? _ephemeralTurnUrl;
  String? _ephemeralTurnUsername;
  String? _ephemeralTurnCredential;
  DateTime? _ephemeralTurnExpiresAt;

  int _connectAttempts = 0;
  int _candidateBufferedCount = 0;
  int _meshLimitSkips = 0;

  Stream<bool> get connectionStream => _connectionStream.stream;
  Stream<Map<String, dynamic>> get telemetryStream => _telemetryStream.stream;
  bool get isMuted => _muted;
  bool get isSpeakerEnabled => _asSpeaker;
  List<RTCVideoRenderer> get activeRenderers => _renderers.values.toList();

  Future<bool> connect({
    required final String circleId,
    required final bool asSpeaker,
    final bool prioritySpeaker = false,
  }) async {
    if (!await _ensurePermissions()) return false;

    final uid = authRepository.currentUser?.id;
    if (uid == null) return false;

    if (_joined && _circleId == circleId && _asSpeaker == asSpeaker) {
      return true;
    }

    await disconnectIfCircle(_circleId);

    _connectAttempts += 1;
    _emitTelemetry('connect_attempt');

    _circleId = circleId;
    _userId = uid;
    _asSpeaker = asSpeaker;
    _prioritySpeaker = prioritySpeaker;
    _muted = !asSpeaker;

    await _ensureLocalAudio();
    _applyMutedToTrack();

    _signalChannel = _client.channel(
      'voice_signal:$circleId',
      opts: const RealtimeChannelConfig(enabled: true),
    );
    _signalChannel!
        .onBroadcast(
          event: 'signal',
          callback: (final payload) => _onSignal(payload),
        )
        .subscribe();

    _joined = true;
    circleVoiceService.setMuted(_muted);
    _startMicLevelSampling();
    _emitConnectionState();

    _announceJoin();
    // Default to speakerphone for circles
    await setSpeakerphone(true);
    return true;
  }

  void _announceJoin() {
    final rng = Random();
    _sendSignal(null, {'type': 'join'});
    Future<void>.delayed(Duration(milliseconds: 300 + rng.nextInt(350)), () {
      if (_joined) {
        _sendSignal(null, {'type': 'join'});
      }
    });
    Future<void>.delayed(Duration(milliseconds: 1000 + rng.nextInt(600)), () {
      if (_joined) {
        _sendSignal(null, {'type': 'join'});
      }
    });
  }

  Future<void> _ensureLocalAudio() async {
    _localStream ??= await navigator.mediaDevices.getUserMedia({
      'audio': {
        'echoCancellation': true,
        'noiseSuppression': true,
        'autoGainControl': true,
        'sampleRate': RtcConfig.audioSampleRate,
        'channelCount': RtcConfig.audioChannelCount,
      },
      'video': false,
    });
    _localAudioTrack ??= _localStream?.getAudioTracks().isNotEmpty == true
        ? _localStream!.getAudioTracks().first
        : null;
  }

  Future<void> _onSignal(final dynamic rawPayload) async {
    final data = _extractSignalData(rawPayload);
    if (data == null) return;

    final to = data['to']?.toString();
    final from = data['from']?.toString();
    final type = data['type']?.toString();

    if (from == null || type == null) return;
    if (_userId == null || from == _userId) return;
    if (to != null && to.isNotEmpty && to != _userId) return;

    switch (type) {
      case 'join':
        if (!_peers.containsKey(from) &&
            _peers.length >= RtcConfig.maxMeshPeers) {
          _meshLimitSkips += 1;
          _emitTelemetry('mesh_limit_skip');
          return;
        }

        if (_asSpeaker &&
            !_prioritySpeaker &&
            !_muted &&
            _peers.length >= RtcConfig.maxActiveSpeakers) {
          await setMuted(true);
          _emitTelemetry('auto_demoted_speaker');
        }

        await _peerFor(from);
        if (_shouldCreateOffer(from)) {
          await _createAndSendOffer(from);
        }
        break;
      case 'leave':
        _closePeer(from);
        break;
      case 'offer':
        final pc = await _peerFor(from);
        final sdp = data['sdp']?.toString();
        if (sdp == null) return;
        await pc.setRemoteDescription(RTCSessionDescription(sdp, 'offer'));
        _hasRemoteDescription[from] = true;
        await _flushPendingCandidates(from, pc);
        final answer = await pc.createAnswer();
        await pc.setLocalDescription(answer);
        await _sendSignal(from, {
          'type': 'answer',
          'sdp': answer.sdp,
        });
        break;
      case 'answer':
        final pc = await _peerFor(from);
        final sdp = data['sdp']?.toString();
        if (sdp == null) return;
        await pc.setRemoteDescription(RTCSessionDescription(sdp, 'answer'));
        _hasRemoteDescription[from] = true;
        await _flushPendingCandidates(from, pc);
        break;
      case 'candidate':
        final pc = await _peerFor(from);
        final candidate = data['candidate']?.toString();
        final sdpMid = data['sdpMid']?.toString();
        final sdpMLineIndex = data['sdpMLineIndex'] is int
            ? data['sdpMLineIndex'] as int
            : int.tryParse('${data['sdpMLineIndex']}');
        if (candidate == null || sdpMid == null || sdpMLineIndex == null) {
          return;
        }
        final ice = RTCIceCandidate(candidate, sdpMid, sdpMLineIndex);
        if (_hasRemoteDescription[from] == true) {
          await pc.addCandidate(ice);
        } else {
          _candidateBufferedCount += 1;
          _pendingCandidates.putIfAbsent(from, () => []).add(ice);
          _emitTelemetry('candidate_buffered');
        }
        break;
    }
  }

  Future<void> _flushPendingCandidates(
    final String peerId,
    final RTCPeerConnection pc,
  ) async {
    final pending = _pendingCandidates.remove(peerId);
    if (pending == null || pending.isEmpty) return;
    for (final candidate in pending) {
      await pc.addCandidate(candidate);
    }
  }

  Map<String, dynamic>? _extractSignalData(final dynamic rawPayload) {
    if (rawPayload is Map<String, dynamic>) {
      if (rawPayload['payload'] is Map) {
        return Map<String, dynamic>.from(rawPayload['payload'] as Map);
      }
      return rawPayload;
    }

    if (rawPayload is Map) {
      final map = Map<String, dynamic>.from(rawPayload);
      if (map['payload'] is Map) {
        return Map<String, dynamic>.from(map['payload'] as Map);
      }
      return map;
    }

    return null;
  }

  bool _shouldCreateOffer(final String peerId) {
    final me = _userId;
    if (me == null) return false;
    return me.compareTo(peerId) < 0;
  }

  Future<RTCPeerConnection> _peerFor(final String peerId) async {
    if (_peers.containsKey(peerId)) {
      return _peers[peerId]!;
    }

    return _createPeer(peerId);
  }

  Future<void> _maybeRefreshEphemeralTurnCredentials() async {
    if (RtcConfig.turnCredentialsFunction.isEmpty) return;
    final now = DateTime.now();
    final expires = _ephemeralTurnExpiresAt;
    if (expires != null &&
        expires.isAfter(now.add(const Duration(seconds: 30)))) {
      return;
    }

    try {
      final response = await _client.functions.invoke(
        RtcConfig.turnCredentialsFunction,
      );
      final data = response.data;
      if (data is! Map) return;
      final map = Map<String, dynamic>.from(data);
      final url = map['url']?.toString() ?? '';
      final username = map['username']?.toString() ?? '';
      final credential = map['credential']?.toString() ?? '';
      final expiresInSeconds = map['expiresIn'] is int
          ? map['expiresIn'] as int
          : int.tryParse('${map['expiresIn']}') ?? 0;
      if (url.isEmpty || username.isEmpty || credential.isEmpty) return;

      _ephemeralTurnUrl = url;
      _ephemeralTurnUsername = username;
      _ephemeralTurnCredential = credential;
      if (expiresInSeconds > 0) {
        _ephemeralTurnExpiresAt = now.add(Duration(seconds: expiresInSeconds));
      }
      _emitTelemetry('turn_credentials_refreshed');
    } catch (_) {
      // Ignore and fallback to static TURN config.
    }
  }

  Future<List<Map<String, String>>> _iceServersFor() async {
    await _maybeRefreshEphemeralTurnCredentials();

    final ephemeralUrl = _ephemeralTurnUrl ?? '';
    if (ephemeralUrl.isNotEmpty) {
      return [
        ...RtcConfig.stunServers,
        {
          'urls': ephemeralUrl,
          if ((_ephemeralTurnUsername ?? '').isNotEmpty)
            'username': _ephemeralTurnUsername!,
          if ((_ephemeralTurnCredential ?? '').isNotEmpty)
            'credential': _ephemeralTurnCredential!,
        },
      ];
    }

    return RtcConfig.iceServers();
  }

  Future<RTCPeerConnection> _createPeer(final String peerId) async {
    final config = <String, dynamic>{
      'iceServers': await _iceServersFor(),
      'sdpSemantics': 'unified-plan',
    };

    final pc = await createPeerConnection(config);
    _peers[peerId] = pc;
    _hasRemoteDescription[peerId] = false;
    _peerIceStates[peerId] = RTCIceConnectionState.RTCIceConnectionStateNew;

    final track = _localAudioTrack;
    if (track != null && _localStream != null) {
      await pc.addTrack(track, _localStream!);
    }

    _emitTelemetry('peer_created');

    pc.onIceCandidate = (final candidate) async {
      if (candidate.candidate == null) return;
      await _sendSignal(peerId, {
        'type': 'candidate',
        'candidate': candidate.candidate,
        'sdpMid': candidate.sdpMid,
        'sdpMLineIndex': candidate.sdpMLineIndex,
      });
    };

    pc.onIceConnectionState = (final state) async {
      _peerIceStates[peerId] = state;
      _emitConnectionState();

      if ((state == RTCIceConnectionState.RTCIceConnectionStateConnected ||
          state == RTCIceConnectionState.RTCIceConnectionStateCompleted)) {
        // Connected!
      }
    };

    pc.onTrack = (final event) async {
      appLogger.debug('Voice track received from $peerId: ${event.track.kind}');
      if (event.streams.isNotEmpty) {
        final stream = event.streams[0];
        try {
          final renderer = RTCVideoRenderer();
          await renderer.initialize();
          renderer.srcObject = stream;
          _renderers[peerId] = renderer;
          appLogger.debug(
              'Successfully wired audio via RTCVideoRenderer for $peerId');
        } catch (e) {
          appLogger.debug('Failed to wire audio for $peerId: $e');
        }
      }
    };

    return pc;
  }

  Future<void> _createAndSendOffer(final String peerId) async {
    final pc = await _peerFor(peerId);
    final offer = await pc.createOffer({
      'offerToReceiveAudio': true,
      'offerToReceiveVideo': false,
    });
    await pc.setLocalDescription(offer);

    await _sendSignal(peerId, {
      'type': 'offer',
      'sdp': offer.sdp,
    });
  }

  Future<void> _sendSignal(
      final String? to, final Map<String, dynamic> payload) async {
    final channel = _signalChannel;
    final me = _userId;
    if (channel == null || me == null) return;

    await channel.sendBroadcastMessage(
      event: 'signal',
      payload: {
        'from': me,
        if (to != null) 'to': to,
        ...payload,
      },
    );
  }

  Future<void> setMuted(final bool muted) async {
    _muted = muted;
    _applyMutedToTrack();
    circleVoiceService.setMuted(muted);
  }

  Future<void> setSpeakerEnabled(final bool enabled) async {
    _asSpeaker = enabled;
    _applyMutedToTrack();
    // Note: We no longer force audio routing here.
    // Audio output (speaker/earpiece) should be controlled separately via setSpeakerphone.
  }

  Future<void> setSpeakerphone(final bool enabled) async {
    try {
      await Helper.setSpeakerphoneOn(enabled);
    } catch (e) {
      appLogger.debug('Failed to set speakerphone: $e');
    }
  }

  Future<void> toggleMuted() async {
    await setMuted(!_muted);
  }

  void _applyMutedToTrack() {
    final track = _localAudioTrack;
    if (track == null) return;
    track.enabled = !_muted && _asSpeaker;
  }

  Timer? _levelTimer;

  void _startMicLevelSampling() {
    _levelTimer?.cancel();
    _levelTimer = Timer.periodic(const Duration(milliseconds: 400), (final _) {
      final hasConnectedPeer = _peerIceStates.values.any(
        (final state) =>
            state == RTCIceConnectionState.RTCIceConnectionStateConnected ||
            state == RTCIceConnectionState.RTCIceConnectionStateCompleted,
      );
      final speaking = !_muted && _asSpeaker && hasConnectedPeer;
      if (speaking != _lastSpeaking) {
        _lastSpeaking = speaking;
        circleVoiceService.setSpeaking(speaking);
      }
    });
  }

  void _emitConnectionState() {
    final connected = _peerIceStates.values.any(
      (final state) =>
          state == RTCIceConnectionState.RTCIceConnectionStateConnected ||
          state == RTCIceConnectionState.RTCIceConnectionStateCompleted,
    );
    if (!_connectionStream.isClosed) {
      _connectionStream.add(connected);
    }
  }

  void _emitTelemetry(final String event) {
    if (_telemetryStream.isClosed) return;
    _telemetryStream.add({
      'event': event,
      'connectAttempts': _connectAttempts,
      'candidateBuffered': _candidateBufferedCount,
      'meshLimitSkips': _meshLimitSkips,
      'peerCount': _peers.length,
      'timestamp': DateTime.now().toIso8601String(),
    });
  }

  void _closePeer(final String peerId) {
    if (_renderers.containsKey(peerId)) {
      final renderer = _renderers.remove(peerId);
      renderer?.srcObject = null;
      renderer?.dispose();
    }
    _peers.remove(peerId)?.close();
    _peerIceStates.remove(peerId);
    _hasRemoteDescription.remove(peerId);
    _pendingCandidates.remove(peerId);
    _emitConnectionState();
  }

  Future<void> disconnect() async {
    await _sendSignal(null, {'type': 'leave'});

    _levelTimer?.cancel();
    _levelTimer = null;

    final channel = _signalChannel;
    if (channel != null) {
      await _client.removeChannel(channel);
      _signalChannel = null;
    }

    for (final peerId in _peers.keys.toList()) {
      _closePeer(peerId);
    }

    await _localAudioTrack?.stop();
    await _localStream?.dispose();
    _localAudioTrack = null;
    _localStream = null;

    _circleId = null;
    _joined = false;
    _asSpeaker = true;
    _prioritySpeaker = false;
    _lastSpeaking = false;
    circleVoiceService.setSpeaking(false);
    _emitConnectionState();
    _emitTelemetry('disconnect');
  }

  Future<void> disconnectIfCircle(final String? circleId) async {
    if (!_joined || _circleId == null || circleId == null) return;
    if (_circleId != circleId) return;
    await disconnect();
  }

  Future<bool> _ensurePermissions() async {
    if (kIsWeb) return true;

    if (defaultTargetPlatform != TargetPlatform.android &&
        defaultTargetPlatform != TargetPlatform.iOS &&
        defaultTargetPlatform != TargetPlatform.macOS) {
      return true;
    }

    final status = await Permission.microphone.request();
    return status.isGranted;
  }
}

final rtcVoiceService = RtcVoiceService.instance;
