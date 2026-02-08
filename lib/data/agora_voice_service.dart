import 'dart:convert';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/foundation.dart' show debugPrint, kIsWeb, defaultTargetPlatform, TargetPlatform;
import 'package:permission_handler/permission_handler.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../core/config/agora_config.dart';
import 'auth_repository.dart';
import 'circle_voice_service.dart';

class AgoraVoiceService {
  AgoraVoiceService._();

  static final AgoraVoiceService instance = AgoraVoiceService._();

  RtcEngine? _engine;
  String? _circleId;
  bool _joined = false;
  bool _muted = false;
  int? _uid;
  bool _lastSpeaking = false;
  ClientRoleType _role = ClientRoleType.clientRoleBroadcaster;
  bool _disconnecting = false;

  Future<void> connect({required String circleId, required bool asSpeaker}) async {
    if (AgoraConfig.appId.isEmpty) return;
    if (!await _ensurePermissions()) return;
    final userId = authRepository.currentUser?.id;
    if (userId == null) return;
    final credentials = await _fetchJoinCredentials(channelId: circleId);
    final agoraUid = credentials.uid ?? _mapUserIdToAgoraUid(userId);
    final token = credentials.token.isNotEmpty ? credentials.token : AgoraConfig.token;

    final role = asSpeaker
        ? ClientRoleType.clientRoleBroadcaster
        : ClientRoleType.clientRoleAudience;

    if (_engine == null) {
      _engine = createAgoraRtcEngine();
      await _engine!.initialize(const RtcEngineContext(
        appId: AgoraConfig.appId,
      ));
      await _engine!.enableAudio();
      await _engine!.setChannelProfile(ChannelProfileType.channelProfileLiveBroadcasting);
      await _engine!.enableAudioVolumeIndication(
        interval: 200,
        smooth: 3,
        reportVad: true,
      );

      _engine!.registerEventHandler(
        RtcEngineEventHandler(
          onJoinChannelSuccess: (connection, elapsed) {
            _uid = connection.localUid;
          },
          onAudioVolumeIndication: (connection, speakers, totalVolume, speakerNumber) {
            _handleAudioVolume(speakers);
          },
        ),
      );
    }

    final shouldRejoin =
        _circleId != circleId || _role != role || (_uid != null && _uid != agoraUid);
    if (shouldRejoin && _joined) {
      await _engine!.leaveChannel();
      _joined = false;
    }

    _circleId = circleId;
    _role = role;

    if (!_joined) {
      if (!asSpeaker) {
        _muted = true;
      }

      await _engine!.setClientRole(role: role);
      await _engine!.joinChannel(
        token: token,
        channelId: circleId,
        uid: agoraUid,
        options: ChannelMediaOptions(
          autoSubscribeAudio: true,
          publishMicrophoneTrack: asSpeaker && !_muted,
          clientRoleType: role,
          channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
        ),
      );
      _joined = true;
      await _engine!.muteLocalAudioStream(_muted || !asSpeaker);
      circleVoiceService.setMuted(_muted || !asSpeaker);
    }
  }

  Future<void> setMuted(bool muted) async {
    _muted = muted;
    if (_engine != null) {
      await _engine!.muteLocalAudioStream(muted);
    }
    circleVoiceService.setMuted(muted);
  }

  Future<void> toggleMuted() async {
    await setMuted(!_muted);
  }

  void _handleAudioVolume(List<AudioVolumeInfo> speakers) {
    int volume = 0;
    for (final speaker in speakers) {
      if (speaker.uid == 0 || (_uid != null && speaker.uid == _uid)) {
        volume = speaker.volume ?? 0;
        break;
      }
    }

    final speaking = volume > 5 && !_muted;
    if (speaking != _lastSpeaking) {
      _lastSpeaking = speaking;
      circleVoiceService.setSpeaking(speaking);
    }
  }

  int _mapUserIdToAgoraUid(String userId) {
    const int fnvOffset = 0x811c9dc5;
    const int fnvPrime = 0x01000193;
    var hash = fnvOffset;

    for (final byte in utf8.encode(userId)) {
      hash ^= byte;
      hash = (hash * fnvPrime) & 0xffffffff;
    }

    hash = hash & 0x7fffffff;
    return hash == 0 ? 1 : hash;
  }

  int? _parseUid(dynamic raw) {
    final value = raw is int ? raw : int.tryParse(raw?.toString() ?? '');
    if (value == null || value == 0) return null;
    return value;
  }

  Future<_AgoraJoinCredentials> _fetchJoinCredentials({required String channelId}) async {
    try {
      final response = await Supabase.instance.client.functions.invoke(
        'agora-token',
        body: {'channel': channelId},
      );
      final data = response.data;
      if (data is Map) {
        final map = Map<String, dynamic>.from(data);
        final token = map['token']?.toString() ?? '';
        final uid = _parseUid(map['uid']);
        return _AgoraJoinCredentials(token: token, uid: uid);
      }
    } catch (_) {}
    return const _AgoraJoinCredentials(token: '', uid: null);
  }

  Future<void> disconnectIfCircle(String? circleId) async {
    if (_engine == null || _circleId == null || circleId == null) return;
    if (_circleId != circleId) return;
    if (_disconnecting) return;

    try {
      _disconnecting = true;
      await _engine!.leaveChannel();
      await _engine!.release();
    } catch (e) {
      debugPrint('Agora disconnect error: $e');
    } finally {
      _engine = null;
      _circleId = null;
      _joined = false;
      _uid = null;
      _lastSpeaking = false;
      _disconnecting = false;
    }
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

class _AgoraJoinCredentials {
  final String token;
  final int? uid;

  const _AgoraJoinCredentials({required this.token, required this.uid});
}

final agoraVoiceService = AgoraVoiceService.instance;
