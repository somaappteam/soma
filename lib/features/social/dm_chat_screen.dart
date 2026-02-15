import 'dart:async';
import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/theme/motion.dart';

import '../../core/widgets/glass.dart';
import '../../core/widgets/staggered_in.dart';
import '../../core/services/haptics_service.dart';
import '../../data/rtc_voice_service.dart';
import '../../data/chat_repository.dart';
import '../../data/presence_repository.dart';
import '../../data/profile_repository.dart';
import '../../data/settings_repository.dart';
import '../../data/soma_plus_repository.dart';
import '../../data/user_report_repository.dart';
import '../../models/user_profile.dart';
import '../profile/profile_screen.dart';
import 'package:soma/l10n/gen/app_localizations.dart';

enum DmCallState { idle, ringingOutgoing, ringingIncoming, connecting, connected }
enum _DmMenuAction { media, documents, clearDraft, togglePinnedOnly }

class DmChatScreen extends StatefulWidget {
  const DmChatScreen({
    super.key,
    required this.meId,
    required this.otherId,
    required this.otherName,
  });

  final String meId;
  final String otherId;
  final String otherName;

  @override
  State<DmChatScreen> createState() => _DmChatScreenState();
}

class _DmChatScreenState extends State<DmChatScreen> {
  static const int _freeDailyVoiceMessages = 5;
  static const int _freeDailyImages = 5;
  static const int _freeDailyFiles = 5;
  static const int _freeDailyVoiceCalls = 3;

  final _controller = TextEditingController();
  final _scroll = ScrollController();
  final _imagePicker = ImagePicker();
  late Stream<List<Map<String, dynamic>>> _messagesStream;
  late Stream<bool> _onlineStream;
  bool _showOnlineIndicator = true;
  bool _readSyncInFlight = false;
  DmCallState _callState = DmCallState.idle;
  bool _isRecordingVoiceMessage = false;
  int _voiceRecordElapsedSeconds = 0;
  Timer? _voiceRecordTimer;
  Timer? _callTimer;
  Timer? _callSetupTimeoutTimer;
  Timer? _outgoingRingTimer;
  int _callElapsedSeconds = 0;
  RealtimeChannel? _dmCallChannel;
  StreamSubscription<bool>? _rtcConnectionSub;
  StreamSubscription<Map<String, dynamic>>? _rtcTelemetrySub;
  String? _replyPreview;
  UserProfile? _otherProfile;
  SomaSubscriptionTier _planTier = SomaSubscriptionTier.free;

  DmPlanLimits get _dmLimits => SomaPlusRepository.dmLimitsForTier(_planTier);
  bool _showSearch = false;
  String _searchQuery = '';
  String _draftText = '';
  bool _showPinnedOnly = false;
  bool _callPanelMinimized = false;
  bool _isMicMuted = false;
  bool _isSpeakerOn = true;
  bool _isRtcConnected = false;
  Offset _floatingChipOffset = Offset.zero;
  int _callQualityScore = 78;
  int _smoothedCallQualityScore = 78;
  Set<String> _pinnedMessageIds = <String>{};
  // NEW: Track block status
  StreamSubscription? _settingsSub;
  bool _isOtherBlocked = false;
  bool _canChat = true;
  String? _dmGateReason;
  String? _sentRequestStatus;
  String? _incomingRequestStatus;
  late Stream<bool> _typingStream;
  Timer? _typingDebounce;
  bool _typingStateSent = false;

  int get _maxImageBytes => _dmLimits.maxImageBytes;

  int get _maxFileBytes => _dmLimits.maxFileBytes;

  int get _maxTextChars => _dmLimits.maxTextChars;

  int get _maxVoiceMessageSeconds => _dmLimits.maxVoiceMessageSeconds;

  String get _myUserId => chatRepository.currentUserId ?? widget.meId;

  @override
  void initState() {
    super.initState();
    _messagesStream = chatRepository.getMessagesStream(widget.otherId);
    _onlineStream = presenceRepository.streamOnlineStatus(widget.otherId);
    _loadOnlineVisibility();
    _loadOtherProfile();
    _loadCostTier();
    _markConversationAsRead();
    _typingStream = chatRepository.typingStream(widget.otherId);
    _loadDmGate();
    _loadDraft();
    _loadPinnedMessages();
    _initDmCallSignaling();
    _rtcConnectionSub = rtcVoiceService.connectionStream.listen(_onRtcConnectionState);
    _rtcTelemetrySub = rtcVoiceService.telemetryStream.listen(_onRtcTelemetry);
    _loadCallChipOffset();
    
    // NEW: Listen to settings for block updates
    _settingsSub = settingsRepository.getSettingsStream().listen((settings) {
      if (!mounted) return;
      final blocked = (settings['blocked_user_ids'] as List?)
          ?.map((e) => e.toString())
          .contains(widget.otherId) ?? false;
      if (blocked != _isOtherBlocked) {
        setState(() => _isOtherBlocked = blocked);
      }
    });
  }

  @override
  void dispose() {
    if (_isCallActive) {
      rtcVoiceService.disconnect();
    }
    final callChannel = _dmCallChannel;
    if (callChannel != null) {
      Supabase.instance.client.removeChannel(callChannel);
      _dmCallChannel = null;
    }
    _voiceRecordTimer?.cancel();
    _callTimer?.cancel();
    _callSetupTimeoutTimer?.cancel();
    _outgoingRingTimer?.cancel();
    _rtcConnectionSub?.cancel();
    _rtcTelemetrySub?.cancel();
    _settingsSub?.cancel(); // NEW
    _typingDebounce?.cancel();
    _setTypingState(false, immediate: true);
    _saveDraft(_controller.text);
    _controller.dispose();
    _scroll.dispose();
    super.dispose();
  }


  Future<void> _markConversationAsRead() async {
    if (_readSyncInFlight) return;
    _readSyncInFlight = true;
    try {
      await chatRepository.markConversationAsRead(widget.otherId);
    } catch (_) {
      // ignore read mark failures
    } finally {
      _readSyncInFlight = false;
    }
  }

  void _send() {
    if (!_canChat) return;
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    if (text.length > _maxTextChars) {
      final allowed = _maxTextChars;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Message too long. Keep it under $allowed characters.')),
      );
      return;
    }

    final payload = <String, dynamic>{
      'type': 'text',
      'text': text,
      if (_replyPreview != null) 'reply_to': _replyPreview,
    };
    chatRepository.sendMessage(widget.otherId, jsonEncode(payload));
    _setTypingState(false, immediate: true);
    _controller.clear();
    _saveDraft('');
    setState(() => _replyPreview = null);

    // Optional: Optimistic UI or wait for stream update
    // Stream will handle UI update.

    // Scroll to bottom after a bit
    Future.delayed(MotionTokens.delayShort, () {
      if (mounted && _scroll.hasClients) {
        _scroll.animateTo(
          _scroll.position.maxScrollExtent + 100,
          duration: MotionTokens.short,
          curve: MotionTokens.standardCurve,
        );
      }
    });
  }


  void _onTypingChanged(bool hasText) {
    _typingDebounce?.cancel();
    _typingDebounce = Timer(const Duration(milliseconds: 450), () {
      _setTypingState(hasText);
    });
  }

  void _setTypingState(bool value, {bool immediate = false}) {
    if (!immediate && _typingStateSent == value) return;
    _typingStateSent = value;
    chatRepository.setTypingState(otherUserId: widget.otherId, isTyping: value);
  }


  Future<void> _loadDraft() async {
    final settings = await settingsRepository.getSettings();
    final drafts = (settings['chat_drafts'] as Map<String, dynamic>?) ?? {};
    final key = widget.otherId;
    final draft = drafts[key]?.toString() ?? '';
    if (!mounted) return;
    _draftText = draft;
    _controller.text = draft;
    _controller.selection = TextSelection.fromPosition(
      TextPosition(offset: _controller.text.length),
    );
  }

  Future<void> _saveDraft(String text) async {
    final settings = await settingsRepository.getSettings();
    final drafts = Map<String, dynamic>.from((settings['chat_drafts'] as Map<String, dynamic>?) ?? {});
    if (text.trim().isEmpty) {
      drafts.remove(widget.otherId);
    } else {
      drafts[widget.otherId] = text;
    }
    await settingsRepository.updateSetting('chat_drafts', drafts);
  }

  Future<void> _loadPinnedMessages() async {
    final settings = await settingsRepository.getSettings();
    final raw = settings['chat_pinned_message_ids'];
    if (raw is! Map) return;
    final scoped = raw[widget.otherId];
    if (scoped is! List) return;
    if (!mounted) return;
    setState(() {
      _pinnedMessageIds = scoped.map((e) => e.toString()).toSet();
    });
  }

  Future<void> _persistPinnedMessages() async {
    final settings = await settingsRepository.getSettings();
    final raw = Map<String, dynamic>.from((settings['chat_pinned_message_ids'] as Map<String, dynamic>?) ?? {});
    raw[widget.otherId] = _pinnedMessageIds.toList();
    await settingsRepository.updateSetting('chat_pinned_message_ids', raw);
  }

  Future<void> _togglePinMessage(String messageId) async {
    setState(() {
      if (_pinnedMessageIds.contains(messageId)) {
        _pinnedMessageIds.remove(messageId);
      } else {
        _pinnedMessageIds.add(messageId);
      }
    });
    await _persistPinnedMessages();
    if (!mounted) return;
    final isPinned = _pinnedMessageIds.contains(messageId);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(isPinned ? 'Message pinned' : 'Message unpinned')),
    );
  }

  void _handleMenuAction(_DmMenuAction action) {
    switch (action) {
      case _DmMenuAction.media:
        setState(() {
          _showSearch = true;
          _searchQuery = '"type":"image"';
        });
        break;
      case _DmMenuAction.documents:
        setState(() {
          _showSearch = true;
          _searchQuery = '"type":"file"';
        });
        break;
      case _DmMenuAction.clearDraft:
        _controller.clear();
        _saveDraft('');
        _setTypingState(false, immediate: true);
        break;
      case _DmMenuAction.togglePinnedOnly:
        setState(() => _showPinnedOnly = !_showPinnedOnly);
        break;
    }
  }

  Future<void> _loadOnlineVisibility() async {
    try {
      final data = await profileRepository.fetchProfile(userId: widget.otherId);
      if (!mounted || data == null) return;
      setState(() => _showOnlineIndicator = data.showOnlineStatus);
    } catch (_) {
      // ignore
    }
  }

  Future<void> _loadOtherProfile() async {
    try {
      final profile = await profileRepository.fetchProfile(userId: widget.otherId);
      if (!mounted || profile == null) return;
      setState(() => _otherProfile = profile);
    } catch (_) {
      // ignore
    }
  }

  Future<void> _loadCostTier() async {
    try {
      final settings = await settingsRepository.getSettings();
      final tier = SomaPlusRepository.parseTier(settings['plus_plan']?.toString());
      if (!mounted) return;
      setState(() => _planTier = tier);
    } catch (_) {
      // keep free fallback
    }
  }

  Future<Map<String, dynamic>> _dailyQuotaState() async {
    final settings = await settingsRepository.getSettings();
    final today = DateTime.now().toIso8601String().split('T').first;
    final storedDate = settings['dm_quota_date']?.toString();
    if (storedDate == today) return settings;

    final reset = <String, dynamic>{
      'dm_quota_date': today,
      'dm_quota_voice_count': 0,
      'dm_quota_image_count': 0,
      'dm_quota_file_count': 0,
      'dm_quota_call_count': 0,
    };
    await settingsRepository.updateSettings(reset);
    return {...settings, ...reset};
  }

  int _intValue(dynamic value) => (value as num?)?.toInt() ?? 0;

  Future<bool> _canUseFreeQuota({
    required String key,
    required int limit,
    required String limitMessage,
  }) async {
    if (_planTier != SomaSubscriptionTier.free) return true;
    final state = await _dailyQuotaState();
    final count = _intValue(state[key]);
    if (count >= limit) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(limitMessage)),
        );
      }
      return false;
    }
    return true;
  }

  Future<void> _incrementFreeQuota(String key) async {
    if (_planTier != SomaSubscriptionTier.free) return;
    final state = await _dailyQuotaState();
    final count = _intValue(state[key]);
    await settingsRepository.updateSetting(key, count + 1);
  }

  String _dmVoiceChannelId() {
    final ids = [_myUserId, widget.otherId]..sort();
    return 'dm_${ids[0]}_${ids[1]}';
  }

  bool get _isCallActive => _callState != DmCallState.idle;

  String _formatCallDuration(int seconds) {
    final mm = (seconds ~/ 60).toString().padLeft(2, '0');
    final ss = (seconds % 60).toString().padLeft(2, '0');
    return '$mm:$ss';
  }

  String get _callSubtitle {
    return switch (_callState) {
      DmCallState.idle => '',
      DmCallState.ringingOutgoing => 'Calling…',
      DmCallState.ringingIncoming => 'Incoming call…',
      DmCallState.connecting => 'Connecting…',
      DmCallState.connected => 'In call ${_formatCallDuration(_callElapsedSeconds)}',
    };
  }

  bool get _isOutgoingDialing =>
      _callState == DmCallState.ringingOutgoing || _callState == DmCallState.connecting;

  String get _callQualityLabel {
    if (!_isCallActive) return 'Idle';
    if (_smoothedCallQualityScore >= 80) return 'Excellent';
    if (_smoothedCallQualityScore >= 55) return 'Fair';
    return 'Poor';
  }

  void _startOutgoingRing() {
    _outgoingRingTimer?.cancel();
    _outgoingRingTimer = Timer.periodic(const Duration(seconds: 2), (_) {
      if (!mounted || !_isOutgoingDialing) return;
      SystemSound.play(SystemSoundType.alert);
    });
  }

  void _stopOutgoingRing() {
    _outgoingRingTimer?.cancel();
    _outgoingRingTimer = null;
  }

  Future<void> _toggleMicMute() async {
    final next = !_isMicMuted;
    await rtcVoiceService.setMuted(next);
    if (!mounted) return;
    hapticsService.selectionClick();
    setState(() => _isMicMuted = next);
  }

  void _toggleSpeakerOutput() {
    final next = !_isSpeakerOn;
    rtcVoiceService.setSpeakerEnabled(next).then((_) {
      if (!mounted) return;
      hapticsService.selectionClick();
      setState(() => _isSpeakerOn = next);
    }).catchError((_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Unable to switch audio output right now.')),
      );
    });
  }

  void _onFloatingChipDragUpdate(DragUpdateDetails details, BoxConstraints constraints) {
    final next = _floatingChipOffset + details.delta;
    final maxX = (constraints.maxWidth - 170).clamp(0, double.infinity).toDouble();
    final maxY = (constraints.maxHeight - 220).clamp(0, double.infinity).toDouble();
    setState(() {
      _floatingChipOffset = Offset(
        next.dx.clamp(0.0, maxX),
        next.dy.clamp(0.0, maxY),
      );
    });
  }

  Future<void> _loadCallChipOffset() async {
    try {
      final settings = await settingsRepository.getSettings();
      final raw = settings['dm_call_chip_offset'];
      if (raw is Map) {
        final dx = double.tryParse('${raw['dx']}');
        final dy = double.tryParse('${raw['dy']}');
        if (dx != null && dy != null && mounted) {
          setState(() => _floatingChipOffset = Offset(dx, dy));
        }
      }
    } catch (_) {}
  }

  Future<void> _persistCallChipOffset() async {
    await settingsRepository.updateSetting('dm_call_chip_offset', {
      'dx': _floatingChipOffset.dx,
      'dy': _floatingChipOffset.dy,
    });
  }

  DmCallState? _nextStateFor(DmCallState from, String event) {
    switch (from) {
      case DmCallState.idle:
        return event == 'invite' ? DmCallState.ringingIncoming : null;
      case DmCallState.ringingOutgoing:
        if (event == 'accept') return DmCallState.connecting;
        if (event == 'end') return DmCallState.idle;
        return null;
      case DmCallState.ringingIncoming:
        if (event == 'accept') return DmCallState.connecting;
        if (event == 'decline' || event == 'end') return DmCallState.idle;
        return null;
      case DmCallState.connecting:
        if (event == 'connected') return DmCallState.connected;
        if (event == 'end' || event == 'decline') return DmCallState.idle;
        return null;
      case DmCallState.connected:
        if (event == 'end') return DmCallState.idle;
        return null;
    }
  }

  bool _canTransition(String event) => _nextStateFor(_callState, event) != null;

  void _onRtcTelemetry(Map<String, dynamic> data) {
    final retries = (data['turnRetries'] as num?)?.toInt() ?? 0;
    final buffered = (data['candidateBuffered'] as num?)?.toInt() ?? 0;
    final peers = (data['peerCount'] as num?)?.toInt() ?? 0;
    var score = 90;
    score -= (retries * 8);
    score -= (buffered > 0 ? 12 : 0);
    score -= (peers > 2 ? (peers - 2) * 3 : 0);
    if (!_isRtcConnected) score -= 25;
    final clamped = score.clamp(15, 98).toInt();
    final smoothed = ((_smoothedCallQualityScore * 0.7) + (clamped * 0.3)).round();
    if (!mounted) return;
    setState(() {
      _callQualityScore = clamped;
      _smoothedCallQualityScore = smoothed;
    });
  }

  Future<void> _setGlobalCallState({required bool active}) async {
    await settingsRepository.updateSetting('dm_active_call', {
      'active': active,
      'other_id': widget.otherId,
      'other_name': widget.otherName,
    });
  }

  void _initDmCallSignaling() {
    final channelId = _dmVoiceChannelId();
    final channel = Supabase.instance.client.channel(
      'dm_call:$channelId',
      opts: const RealtimeChannelConfig(enabled: true),
    );

    channel
        .onBroadcast(event: 'voice_call', callback: (payload) {
          _handleDmCallSignal(payload);
        })
        .subscribe();

    _dmCallChannel = channel;
  }

  Future<void> _handleDmCallSignal(dynamic payload) async {
    final map = payload is Map ? Map<String, dynamic>.from(payload) : null;
    if (map == null) return;

    final data = map['payload'] is Map
        ? Map<String, dynamic>.from(map['payload'] as Map)
        : map;

    final from = data['from']?.toString();
    if (from == null || from == _myUserId) return;
    final type = data['type']?.toString();

    if (type == 'call_invite') {
      if (!_canTransition('invite')) return;
      if (_isCallActive) return;
      if (!mounted) return;
      setState(() {
        _callState = DmCallState.ringingIncoming;
        _callPanelMinimized = false;
      });
      final accepted = await _showIncomingCallDialog();
      if (!mounted || _callState != DmCallState.ringingIncoming) return;

      if (accepted) {
        await _emitDmCallSignal('call_accept');
        await _startVoiceCall(sendInvite: false, incoming: true);
      } else {
        setState(() => _callState = DmCallState.idle);
        _stopOutgoingRing();
        await _emitDmCallSignal('call_decline');
      }
      return;
    }

    if (type == 'call_accept') {
      if (!_canTransition('accept')) return;
      if (_callState == DmCallState.ringingOutgoing) {
        setState(() => _callState = DmCallState.connecting);
        _startCallSetupTimeout();
      }
      return;
    }

    if (type == 'call_connected') {
      if (!_canTransition('connected')) return;
      _markCallConnected();
      return;
    }

    if (type == 'call_decline') {
      if (!_canTransition('decline')) return;
      if (!_isCallActive) return;
      await _endVoiceCall(showRemoteEnded: true, message: 'Voice call declined');
      return;
    }

    if (type == 'call_end') {
      if (!_canTransition('end')) return;
      if (!_isCallActive) return;
      await _endVoiceCall(showRemoteEnded: true);
    }
  }

  Future<bool> _showIncomingCallDialog() async {
    final response = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 24),
        child: Glass(
          radius: BorderRadius.circular(24),
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Incoming voice call',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w900,
                    ),
              ),
              const SizedBox(height: 6),
              Text(
                '${widget.otherName} is calling you.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => Navigator.of(context).pop(false),
                      icon: const Icon(Icons.call_end_rounded),
                      label: const Text('Decline'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: () => Navigator.of(context).pop(true),
                      icon: const Icon(Icons.call_rounded),
                      label: const Text('Accept'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );

    return response == true;
  }

  void _onRtcConnectionState(bool connected) {
    if (!mounted) return;
    setState(() => _isRtcConnected = connected);
    if (!connected) return;
    if (!_isCallActive) return;

    _markCallConnected();
    _emitDmCallSignal('call_connected');
  }

  void _markCallConnected() {
    if (!mounted) return;
    if (_callState == DmCallState.connected) return;

    _callSetupTimeoutTimer?.cancel();
    _callTimer?.cancel();
    _stopOutgoingRing();
    setState(() {
      _callState = DmCallState.connected;
      _callElapsedSeconds = 0;
      _callPanelMinimized = false;
      _isRtcConnected = true;
    });
    _callTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted || _callState != DmCallState.connected) return;
      setState(() => _callElapsedSeconds += 1);
    });
  }

  void _startCallSetupTimeout() {
    _callSetupTimeoutTimer?.cancel();
    _callSetupTimeoutTimer = Timer(const Duration(seconds: 20), () async {
      if (!mounted) return;
      if (_callState == DmCallState.connected || _callState == DmCallState.idle) return;

      final retryWithRelay = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Call connection issue'),
          content: const Text('Unable to connect quickly. Retry using relay (TURN)?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Retry with relay'),
            ),
          ],
        ),
      );

      if (retryWithRelay == true) {
        await rtcVoiceService.forceTurnRelay();
        _startCallSetupTimeout();
      } else {
        await _emitDmCallSignal('call_end');
        await _endVoiceCall(showRemoteEnded: false, message: 'Voice call failed to connect');
      }
    });
  }

  Future<void> _emitDmCallSignal(String type) async {
    final channel = _dmCallChannel;
    if (channel == null) return;

    await channel.sendBroadcastMessage(
      event: 'voice_call',
      payload: {
        'type': type,
        'from': _myUserId,
      },
    );
  }

  Future<bool> _startVoiceCall({required bool sendInvite, bool incoming = false}) async {
    final l10n = AppLocalizations.of(context);
    try {
      await rtcVoiceService.connect(circleId: _dmVoiceChannelId(), asSpeaker: true, prioritySpeaker: true);
      if (!mounted) return false;

      setState(() {
        _callState = incoming ? DmCallState.connecting : DmCallState.ringingOutgoing;
        _callElapsedSeconds = 0;
        _callPanelMinimized = false;
        _isMicMuted = false;
        _isSpeakerOn = true;
        _isRtcConnected = false;
        _callQualityScore = 78;
        _smoothedCallQualityScore = 78;
      });

      if (sendInvite) {
        await _emitDmCallSignal('call_invite');
        _startOutgoingRing();
      }

      await _setGlobalCallState(active: true);

      _startCallSetupTimeout();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(incoming ? 'Accepting voice call…' : 'Calling…'),
        ),
      );
      return true;
    } catch (_) {
      if (!mounted) return false;
      _stopOutgoingRing();
      setState(() => _callState = DmCallState.idle);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.chatCallLater)),
      );
      return false;
    }
  }

  Future<void> _endVoiceCall({required bool showRemoteEnded, String? message}) async {
    await rtcVoiceService.disconnect();
    if (!mounted) return;
    _callTimer?.cancel();
    _callSetupTimeoutTimer?.cancel();
    _stopOutgoingRing();
    setState(() {
      _callState = DmCallState.idle;
      _callPanelMinimized = false;
      _isMicMuted = false;
      _isSpeakerOn = true;
      _isRtcConnected = false;
      _callQualityScore = 78;
      _smoothedCallQualityScore = 78;
    });
    await _setGlobalCallState(active: false);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message ?? (showRemoteEnded ? 'Voice call ended by peer' : 'Voice call ended'),
        ),
      ),
    );
  }

  Future<void> _toggleVoiceCall() async {
    if (_isCallActive) {
      final shouldEnd = await _confirmEndActiveCall();
      if (!shouldEnd) return;
      await _emitDmCallSignal('call_end');
      await _endVoiceCall(showRemoteEnded: false);
      return;
    }

    final canCall = await _canUseFreeQuota(
      key: 'dm_quota_call_count',
      limit: _freeDailyVoiceCalls,
      limitMessage:
          'Free plan allows $_freeDailyVoiceCalls voice calls per day in DM. Upgrade to Plus for unlimited calls.',
    );
    if (!canCall) return;

    final started = await _startVoiceCall(sendInvite: true);
    if (started) {
      await _incrementFreeQuota('dm_quota_call_count');
    }
  }

  Future<void> _sendVoiceMessage(int durationSeconds) async {
    final canSend = await _canUseFreeQuota(
      key: 'dm_quota_voice_count',
      limit: _freeDailyVoiceMessages,
      limitMessage:
          'Free plan allows $_freeDailyVoiceMessages voice messages per day. Upgrade to Plus for unlimited voice messages.',
    );
    if (!canSend) return;

    final clampedDuration = durationSeconds.clamp(1, _maxVoiceMessageSeconds);
    final mm = (clampedDuration ~/ 60).toString().padLeft(2, '0');
    final ss = (clampedDuration % 60).toString().padLeft(2, '0');
    await chatRepository.sendMessage(
      widget.otherId,
      jsonEncode({'type': 'voice', 'duration': clampedDuration, 'label': '$mm:$ss'}),
    );
    await _incrementFreeQuota('dm_quota_voice_count');
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Voice message sent')),
    );
  }

  Future<bool> _confirmEndActiveCall() async {
    if (_callState != DmCallState.connected || _callElapsedSeconds < 5) {
      return true;
    }
    final shouldEnd = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('End voice call?'),
        content: Text('You are currently in an active call (${_formatCallDuration(_callElapsedSeconds)}).'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Keep call'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('End call'),
          ),
        ],
      ),
    );
    return shouldEnd == true;
  }

  void _startVoiceRecording() {
    _voiceRecordTimer?.cancel();
    setState(() {
      _isRecordingVoiceMessage = true;
      _voiceRecordElapsedSeconds = 0;
    });

    _voiceRecordTimer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      if (!mounted) {
        timer.cancel();
        return;
      }
      final nextValue = _voiceRecordElapsedSeconds + 1;
      if (nextValue >= _maxVoiceMessageSeconds) {
        timer.cancel();
        await _stopVoiceRecording(send: true, hitLimit: true);
        return;
      }
      setState(() => _voiceRecordElapsedSeconds = nextValue);
    });
  }

  Future<void> _stopVoiceRecording({required bool send, bool hitLimit = false}) async {
    _voiceRecordTimer?.cancel();
    final duration = _voiceRecordElapsedSeconds;
    if (!mounted) return;

    setState(() {
      _isRecordingVoiceMessage = false;
      _voiceRecordElapsedSeconds = 0;
    });

    if (send && duration > 0) {
      await _sendVoiceMessage(duration);
    }

    if (hitLimit && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Voice messages are limited to ${_maxVoiceMessageSeconds}s on your current plan.',
          ),
        ),
      );
    }
  }

  Future<void> _handleVoiceMessageTap() async {
    if (_isRecordingVoiceMessage) {
      await _stopVoiceRecording(send: true);
      return;
    }
    _startVoiceRecording();
  }

  Future<void> _pickAndSendImage() async {
    final uid = _myUserId;
    try {
      final picked = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
        maxWidth: _planTier == SomaSubscriptionTier.pro ? 1920 : 1280,
      );
      if (picked == null || !mounted) return;

      final canSendImage = await _canUseFreeQuota(
        key: 'dm_quota_image_count',
        limit: _freeDailyImages,
        limitMessage:
            'Free plan allows $_freeDailyImages photos per day. Upgrade to Plus for unlimited photos.',
      );
      if (!canSendImage) return;

      final bytes = await picked.readAsBytes();
      if (bytes.length > _maxImageBytes) {
        if (!mounted) return;
        final mb = (bytes.length / (1024 * 1024)).toStringAsFixed(1);
        final allowedMb = (_maxImageBytes / (1024 * 1024)).toStringAsFixed(0);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Image is ${mb}MB. Max allowed is ${allowedMb}MB.')),
        );
        return;
      }

      final path = 'chat_media/$uid/${DateTime.now().millisecondsSinceEpoch}.jpg';
      final storage = Supabase.instance.client.storage.from('chat_assets');
      await storage.uploadBinary(
        path,
        bytes,
        fileOptions: const FileOptions(contentType: 'image/jpeg', upsert: true),
      );
      final publicUrl = storage.getPublicUrl(path);
      await chatRepository.sendMessage(
        widget.otherId,
        jsonEncode({'type': 'image', 'url': publicUrl, 'thumb': publicUrl}),
      );
      await _incrementFreeQuota('dm_quota_image_count');

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Picture sent')),
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not send picture')),
      );
    }
  }



  Future<void> _pickAndSendDocument() async {
    final uid = _myUserId;
    try {
      final pick = await FilePicker.platform.pickFiles(
        allowMultiple: false,
        withData: true,
        type: FileType.custom,
        allowedExtensions: const ['pdf', 'doc', 'docx', 'txt'],
      );
      if (pick == null || pick.files.isEmpty || !mounted) return;

      final canSendFile = await _canUseFreeQuota(
        key: 'dm_quota_file_count',
        limit: _freeDailyFiles,
        limitMessage:
            'Free plan allows $_freeDailyFiles document sends per day. Upgrade to Plus for unlimited files.',
      );
      if (!canSendFile) return;

      final file = pick.files.single;
      final bytes = file.bytes;
      if (bytes == null || bytes.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not read selected document.')),
        );
        return;
      }

      if (bytes.length > _maxFileBytes) {
        final mb = (bytes.length / (1024 * 1024)).toStringAsFixed(1);
        final allowedMb = (_maxFileBytes / (1024 * 1024)).toStringAsFixed(0);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Document is ${mb}MB. Max allowed is ${allowedMb}MB.')),
        );
        return;
      }

      final extension = (file.extension ?? 'file').toLowerCase();
      final sanitizedName = (file.name.isEmpty ? 'document.$extension' : file.name)
          .replaceAll(RegExp(r'[^a-zA-Z0-9._-]'), '_');
      final objectPath = 'chat_docs/$uid/${DateTime.now().millisecondsSinceEpoch}_$sanitizedName';
      final storage = Supabase.instance.client.storage.from('chat_assets');
      await storage.uploadBinary(
        objectPath,
        bytes,
        fileOptions: FileOptions(
          contentType: _docContentType(extension),
          upsert: true,
        ),
      );
      final publicUrl = storage.getPublicUrl(objectPath);
      await chatRepository.sendMessage(
        widget.otherId,
        jsonEncode({
          'type': 'file',
          'url': publicUrl,
          'name': file.name,
          'size': bytes.length,
        }),
      );
      await _incrementFreeQuota('dm_quota_file_count');

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Document sent')),
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not send document')),
      );
    }
  }

  String _docContentType(String extension) {
    return switch (extension) {
      'pdf' => 'application/pdf',
      'doc' => 'application/msword',
      'docx' => 'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
      'txt' => 'text/plain',
      _ => 'application/octet-stream',
    };
  }

  Future<void> _openFileUrl(String url) async {
    final uri = Uri.tryParse(url);
    if (uri == null) return;
    final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!launched && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open file')),
      );
    }
  }

  Future<void> _editTextMessage(_ChatMessage msg) async {
    final initial = msg.payload.text ?? '';
    final editor = TextEditingController(text: initial);
    final updated = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit message'),
        content: TextField(
          controller: editor,
          maxLines: 4,
          autofocus: true,
          decoration: const InputDecoration(hintText: 'Update your message'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, editor.text.trim()),
            child: const Text('Save'),
          ),
        ],
      ),
    );

    if (!mounted || updated == null) return;
    if (updated.isEmpty || updated == initial.trim()) return;
    if (updated.length > _maxTextChars) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Message too long. Keep it under $_maxTextChars characters.')),
      );
      return;
    }

    await chatRepository.editMessageById(
      msg.id,
      jsonEncode({'type': 'text', 'text': updated}),
    );
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Message updated')),
    );
  }

  Future<void> _confirmAndDeleteMessage(String messageId) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Unsend message?'),
        content: const Text('This removes the message from the chat.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Unsend'),
          ),
        ],
      ),
    );
    if (shouldDelete != true) return;

    await chatRepository.deleteMessageById(messageId);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Message removed')),
    );
  }

  Future<void> _showMessageActions(_ChatMessage msg) async {
    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.emoji_emotions_outlined),
              title: const Text('React 👍'),
              onTap: () async {
                Navigator.pop(context);
                await chatRepository.toggleMessageReaction(messageId: msg.id, emoji: '👍');
              },
            ),
            ListTile(
              leading: const Icon(Icons.reply_rounded),
              title: const Text('Reply'),
              onTap: () {
                Navigator.pop(context);
                setState(() => _replyPreview = msg.previewText);
              },
            ),
            ListTile(
              leading: const Icon(Icons.copy_rounded),
              title: const Text('Copy text'),
              onTap: () async {
                Navigator.pop(context);
                await Clipboard.setData(ClipboardData(text: msg.previewText));
                if (!mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Copied to clipboard')),
                );
              },
            ),
            ListTile(
              leading: Icon(_pinnedMessageIds.contains(msg.id) ? Icons.push_pin_outlined : Icons.push_pin_rounded),
              title: Text(_pinnedMessageIds.contains(msg.id) ? 'Unpin message' : 'Pin message'),
              onTap: () async {
                Navigator.pop(context);
                await _togglePinMessage(msg.id);
              },
            ),
            if (msg.isMine && msg.payload.type == 'text')
              ListTile(
                leading: const Icon(Icons.edit_rounded),
                title: const Text('Edit'),
                onTap: () async {
                  Navigator.pop(context);
                  await _editTextMessage(msg);
                },
              ),
            if (msg.isMine)
              ListTile(
                leading: const Icon(Icons.delete_outline_rounded),
                title: const Text('Unsend'),
                onTap: () async {
                  Navigator.pop(context);
                  await _confirmAndDeleteMessage(msg.id);
                },
              )
            else
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    leading: const Icon(Icons.flag_outlined),
                    title: const Text('Report'),
                    onTap: () async {
                      Navigator.pop(context);
                      try {
                        final reason = await showModalBottomSheet<String>(
                          context: context,
                          builder: (_) => SafeArea(
                            child: Wrap(
                              children: [
                                for (final r in const [
                                  'spam',
                                  'harassment',
                                  'scam',
                                  'other'
                                ])
                                  ListTile(
                                    title: Text(r),
                                    onTap: () => Navigator.pop(context, r),
                                  ),
                              ],
                            ),
                          ),
                        );
                        if (!mounted || reason == null) return;
                        await userReportRepository.reportUser(widget.otherId);
                        await chatRepository.submitChatReport(
                          otherUserId: widget.otherId,
                          messageId: msg.id,
                          messagePreview: msg.previewText,
                          reason: reason,
                        );
                        if (!mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Report submitted: $reason')),
                        );
                      } catch (_) {
                        if (!mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Could not submit report')),
                        );
                      }
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.block_rounded),
                    title: const Text('Block and report'),
                    onTap: () async {
                      Navigator.pop(context);
                      final settings = await settingsRepository.getSettings();
                      final blockedIds = (settings['blocked_user_ids'] as List?)
                              ?.map((e) => e.toString())
                              .toList() ??
                          [];
                      if (!blockedIds.contains(widget.otherId)) {
                        blockedIds.add(widget.otherId);
                      }
                      await settingsRepository.updateSetting(
                        'blocked_user_ids',
                        blockedIds,
                      );
                      await userReportRepository.reportUser(widget.otherId);
                      if (!mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('User blocked and reported')),
                      );
                    },
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                _showOnlineIndicator
                    ? StreamBuilder<bool>(
                        stream: _onlineStream,
                        builder: (context, snapshot) {
                          return _TopBar(
                            title: _otherProfile?.displayName.isNotEmpty == true
                                ? _otherProfile!.displayName
                                : widget.otherName,
                            username: _otherProfile?.username,
                            avatarUrl: _otherProfile?.avatarUrl,
                            showOnlineIndicator: snapshot.data == true,
                            onBack: () => Navigator.pop(context),
                            onProfileTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => ProfileScreen(userId: widget.otherId),
                                ),
                              );
                            },
                            onCall: _toggleVoiceCall,
                            onToggleSearch: () => setState(() => _showSearch = !_showSearch),
                            onMenuSelected: _handleMenuAction,
                            showPinnedOnly: _showPinnedOnly,
                            isInCall: _isCallActive,
                            callStatusText: _callSubtitle,
                            callDuration: _callElapsedSeconds,
                          );
                        },
                      )
                    : _TopBar(
                        title: _otherProfile?.displayName.isNotEmpty == true
                            ? _otherProfile!.displayName
                            : widget.otherName,
                        username: _otherProfile?.username,
                        avatarUrl: _otherProfile?.avatarUrl,
                        showOnlineIndicator: false,
                        onBack: () => Navigator.pop(context),
                        onProfileTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ProfileScreen(userId: widget.otherId),
                            ),
                          );
                        },
                        onCall: _toggleVoiceCall,
                        onToggleSearch: () => setState(() => _showSearch = !_showSearch),
                        onMenuSelected: _handleMenuAction,
                        showPinnedOnly: _showPinnedOnly,
                        isInCall: _isCallActive,
                        callStatusText: _callSubtitle,
                        callDuration: _callElapsedSeconds,
                      ),
                const SizedBox(height: 8),
                if (_showSearch)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(14, 0, 14, 8),
                    child: Glass(
                      radius: BorderRadius.circular(12),
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      child: TextField(
                        onChanged: (v) => setState(() => _searchQuery = v.trim().toLowerCase()),
                        decoration: const InputDecoration(
                          isDense: true,
                          border: InputBorder.none,
                          hintText: 'Search in conversation',
                        ),
                      ),
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(14, 0, 14, 8),
                  child: Row(
                    children: [
                      if (_searchQuery.isNotEmpty)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(999),
                            color: theme.colorScheme.onSurface.withValues(alpha: 0.08),
                          ),
                          child: Text(
                            'Searching: $_searchQuery',
                            style: TextStyle(
                              color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      const Spacer(),
                      FilterChip(
                        label: const Text('Pinned'),
                        selected: _showPinnedOnly,
                        onSelected: (v) => setState(() => _showPinnedOnly = v),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: StreamBuilder<List<Map<String, dynamic>>>(
                      stream: _messagesStream,
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Center(
                              child: Text("Error: ${snapshot.error}",
                                  style: TextStyle(color: theme.colorScheme.onSurface)));
                        }
                        if (!snapshot.hasData) {
                          return const Center(
                              child: CircularProgressIndicator(
                                  color: Color(0xFF2AFADF)));
                        }

                        final msgs = snapshot.data!;
                        var visibleMsgs = _searchQuery.isEmpty
                            ? msgs
                            : msgs
                                .where((m) => (m['content']?.toString().toLowerCase() ?? '').contains(_searchQuery))
                                .toList();
                        if (_showPinnedOnly) {
                          visibleMsgs = visibleMsgs
                              .where((m) => _pinnedMessageIds.contains(m['id']?.toString() ?? ''))
                              .toList();
                        }

                        if (visibleMsgs.isEmpty) {
                          return Center(
                            child: Text(_searchQuery.isEmpty
                                ? 'No messages yet'
                                : 'No messages match your search',
                              style: TextStyle(color: theme.colorScheme.onSurface.withValues(alpha: 0.7), fontWeight: FontWeight.w700),
                            ),
                          );
                        }

                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          if (_scroll.hasClients) {
                            _scroll.animateTo(
                              _scroll.position.maxScrollExtent,
                              duration: MotionTokens.medium,
                              curve: Curves.easeOut,
                            );
                          }
                        });

                        return ListView.builder(
                          controller: _scroll,
                          padding: const EdgeInsets.fromLTRB(14, 0, 14, 8),
                          physics: const BouncingScrollPhysics(),
                          itemCount: visibleMsgs.length,
                          itemBuilder: (context, i) {
                            final m = visibleMsgs[i];
                            final isMe = (m['sender_id']?.toString() ?? '') == _myUserId;
                            final dt = DateTime.tryParse(m['created_at']?.toString() ?? '')?.toLocal() ?? DateTime.now();
                            final payload = _MessagePayload.parse(m['content']?.toString() ?? '');
                            final readAt = m['read_at']?.toString();
                            final pinned = _pinnedMessageIds.contains(m['id']?.toString() ?? '');
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 6),
                              child: _Bubble(
                                text: payload.text ?? payload.fileName ?? 'Attachment',
                                rawContent: m['content']?.toString() ?? '',
                                time: _fmtTime(dt),
                                isMe: isMe,
                                isRead: readAt != null,
                                replyTo: payload.replyTo,
                                readAt: readAt,
                                reactions: (m['reactions'] as Map<String, dynamic>?) ?? const {},
                                pinned: pinned,
                                onLongPress: () => _showMessageActions(m),
                                onTapFile: _openFileUrl,
                                onReact: (emoji) => chatRepository.toggleMessageReaction(messageId: m['id'].toString(), emoji: emoji),
                              ),
                            );
                          },
                        );
                      }),
                ),
                if (_replyPreview != null)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(14, 0, 14, 6),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Replying to: ${_replyPreview!}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: theme.colorScheme.onSurface.withValues(alpha: 0.75),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () => setState(() => _replyPreview = null),
                          icon: const Icon(Icons.close_rounded),
                        ),
                      ],
                    ),
                  ),
                if (!_canChat && _dmGateReason == null)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(14, 0, 14, 6),
                    child: Wrap(
                      spacing: 6,
                      children: [
                        for (final quick in const ['Hey 👋', 'How are you?', 'Want to practice now?'])
                          Padding(
                            padding: const EdgeInsets.only(bottom: 6),
                            child: ActionChip(
                              label: Text(quick),
                              onPressed: () {
                                _controller.text = quick;
                                _controller.selection = TextSelection.fromPosition(
                                  TextPosition(offset: _controller.text.length),
                                );
                                _onTypingChanged(true);
                                _saveDraft(quick);
                                setState(() {});
                              },
                            ),
                          ),
                      ],
                    ),
                  ),
                StreamBuilder<bool>(
                  stream: _typingStream,
                  builder: (context, snapshot) {
                    if (snapshot.data != true) return const SizedBox.shrink();
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Text(
                        '${widget.otherName} is typing…',
                        style: TextStyle(
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    );
                  },
                ),
                if (_isOtherBlocked)
                  _BlockedOverlay(
                    onUnblock: _unblockUser,
                  )
                else if (!_canChat && _dmGateReason == 'needs_request')
                  _MessageRequestOverlay(
                    sentRequestStatus: _sentRequestStatus,
                    incomingRequestStatus: _incomingRequestStatus,
                    onSendRequest: _sendMessageRequest,
                    onAccept: () => _respondIncomingRequest(true),
                    onDecline: () => _respondIncomingRequest(false),
                  )
                else
                  _InputBar(
                    controller: _controller,
                    onSend: _send,
                    onVoiceMessage: () {
                      _handleVoiceMessageTap();
                    },
                    onSendImage: _pickAndSendImage,
                    onSendFile: _pickAndSendDocument,
                    onTypingChanged: _onTypingChanged,
                    onTextChanged: _saveDraft,
                    isRecordingVoiceMessage: _isRecordingVoiceMessage,
                    recordingSeconds: _voiceRecordElapsedSeconds,
                  ),
              ],
            ),
            if (_isCallActive && !_callPanelMinimized)
              Positioned(
                left: 14,
                right: 14,
                bottom: 84,
                child: _VoiceCallPanel(
                  name: _otherProfile?.displayName.isNotEmpty == true
                      ? _otherProfile!.displayName
                      : widget.otherName,
                  status: _callSubtitle,
                  duration: _callElapsedSeconds,
                  quality: _callQualityLabel,
                  state: _callState,
                  onMinimize: () => setState(() => _callPanelMinimized = true),
                  onToggleMute: _toggleMicMute,
                  onToggleSpeaker: _toggleSpeakerOutput,
                  isMuted: _isMicMuted,
                  isSpeakerOn: _isSpeakerOn,
                  onHangup: () async {
                    final shouldEnd = await _confirmEndActiveCall();
                    if (!shouldEnd) return;
                    await _emitDmCallSignal('call_end');
                    await _endVoiceCall(showRemoteEnded: false);
                  },
                ),
              ),
            if (_isCallActive && _callPanelMinimized)
              Positioned.fill(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    const chipWidth = 170.0;
                    final defaultLeft = (constraints.maxWidth - chipWidth - 14).clamp(0.0, constraints.maxWidth);
                    final defaultTop = (constraints.maxHeight - 150).clamp(0.0, constraints.maxHeight);
                    return Stack(
                      children: [
                        Positioned(
                          left: (defaultLeft - _floatingChipOffset.dx)
                              .clamp(0.0, (constraints.maxWidth - chipWidth).clamp(0.0, constraints.maxWidth)),
                          top: (defaultTop + _floatingChipOffset.dy)
                              .clamp(0.0, (constraints.maxHeight - 70).clamp(0.0, constraints.maxHeight)),
                          child: GestureDetector(
                            onPanUpdate: (details) =>
                                _onFloatingChipDragUpdate(details, constraints),
                            onPanEnd: (_) => _persistCallChipOffset(),
                            onLongPress: () async {
                              final action = await showModalBottomSheet<String>(
                                context: context,
                                builder: (context) => SafeArea(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      ListTile(
                                        leading: Icon(_isMicMuted ? Icons.mic_rounded : Icons.mic_off_rounded),
                                        title: Text(_isMicMuted ? 'Unmute' : 'Mute'),
                                        onTap: () => Navigator.pop(context, 'toggle_mute'),
                                      ),
                                      ListTile(
                                        leading: const Icon(Icons.open_in_full_rounded),
                                        title: const Text('Restore call panel'),
                                        onTap: () => Navigator.pop(context, 'restore'),
                                      ),
                                      ListTile(
                                        leading: const Icon(Icons.call_end_rounded),
                                        title: const Text('End call'),
                                        onTap: () => Navigator.pop(context, 'end'),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                              if (!mounted) return;
                              if (action == 'toggle_mute') {
                                await _toggleMicMute();
                              } else if (action == 'end') {
                                final shouldEnd = await _confirmEndActiveCall();
                                if (!shouldEnd) return;
                                await _emitDmCallSignal('call_end');
                                await _endVoiceCall(showRemoteEnded: false);
                              } else {
                                setState(() => _callPanelMinimized = false);
                              }
                            },
                            child: _FloatingCallChip(
                              subtitle: _callSubtitle,
                              onTap: () => setState(() => _callPanelMinimized = false),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _unblockUser() async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Unblock user?'),
        content: const Text('You will be able to message this user again.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Unblock'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    final settings = await settingsRepository.getSettings();
    final blockedIds = (settings['blocked_user_ids'] as List?)
            ?.map((e) => e.toString())
            .toList() ??
        [];
    blockedIds.remove(widget.otherId);
    
    await settingsRepository.updateSetting('blocked_user_ids', blockedIds);
    // Stream listener in initState will update state
  }


  Future<void> _loadDmGate() async {
    try {
      final state = await chatRepository.getDmGateState(widget.otherId);
      if (!mounted) return;
      setState(() {
        _canChat = state['canChat'] == true;
        _dmGateReason = state['reason']?.toString();
        _sentRequestStatus = state['sentRequestStatus']?.toString();
        _incomingRequestStatus = state['incomingRequestStatus']?.toString();
      });
    } catch (_) {}
  }

  Future<void> _sendMessageRequest() async {
    await chatRepository.sendMessageRequest(widget.otherId);
    if (!mounted) return;
    await _loadDmGate();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Message request sent')),
    );
  }

  Future<void> _respondIncomingRequest(bool accept) async {
    await chatRepository.respondToMessageRequest(
      requesterId: widget.otherId,
      accept: accept,
    );
    if (!mounted) return;
    await _loadDmGate();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(accept ? 'Message request accepted' : 'Message request declined')),
    );
  }

  String _fmtTime(DateTime dt) {
    final hh = dt.hour.toString().padLeft(2, '0');
    final mm = dt.minute.toString().padLeft(2, '0');
    return "$hh:$mm";
  }
}

// ---------------- UI pieces ----------------

class _VoiceCallPanel extends StatelessWidget {
  final String name;
  final String status;
  final String quality;
  final int duration;
  final DmCallState state;
  final VoidCallback onMinimize;
  final VoidCallback onToggleMute;
  final VoidCallback onToggleSpeaker;
  final bool isMuted;
  final bool isSpeakerOn;
  final VoidCallback onHangup;

  const _VoiceCallPanel({
    required this.name,
    required this.status,
    required this.quality,
    required this.duration,
    required this.state,
    required this.onMinimize,
    required this.onToggleMute,
    required this.onToggleSpeaker,
    required this.isMuted,
    required this.isSpeakerOn,
    required this.onHangup,
  });

  String get _durationLabel {
    final mm = (duration ~/ 60).toString().padLeft(2, '0');
    final ss = (duration % 60).toString().padLeft(2, '0');
    return '$mm:$ss';
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final active = state == DmCallState.connected;

    return Glass(
      radius: BorderRadius.circular(24),
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(13),
                  gradient: LinearGradient(
                    colors: [
                      scheme.primary.withValues(alpha: 0.95),
                      scheme.tertiary.withValues(alpha: 0.92),
                    ],
                  ),
                ),
                child: Icon(active ? Icons.graphic_eq_rounded : Icons.phone_in_talk_rounded,
                    color: scheme.onPrimary, size: 20),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.titleMedium?.copyWith(
                        color: scheme.onSurface,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    Text(
                      active ? 'In call • $_durationLabel' : status,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.bodySmall?.copyWith(
                        color: active ? scheme.primary : scheme.onSurface.withValues(alpha: 0.72),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Row(
                      children: [
                        Icon(
                          quality == 'Excellent'
                              ? Icons.network_cell_rounded
                              : quality == 'Fair'
                                  ? Icons.network_wifi_2_bar_rounded
                                  : Icons.network_check_rounded,
                          size: 13,
                          color: quality == 'Excellent'
                              ? const Color(0xFF58F7B6)
                              : quality == 'Fair'
                                  ? const Color(0xFFFFD166)
                                  : const Color(0xFFFF6B6B),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Quality: $quality',
                          style: textTheme.labelSmall?.copyWith(
                            color: scheme.onSurface.withValues(alpha: 0.76),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: onMinimize,
                icon: Icon(Icons.open_in_new_rounded, color: scheme.onSurface.withValues(alpha: 0.86)),
                tooltip: 'Minimize',
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onToggleMute,
                  icon: Icon(isMuted ? Icons.mic_off_rounded : Icons.mic_rounded),
                  label: Text(isMuted ? 'Unmute' : 'Mute'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onToggleSpeaker,
                  icon: Icon(isSpeakerOn ? Icons.volume_up_rounded : Icons.hearing_rounded),
                  label: Text(isSpeakerOn ? 'Speaker' : 'Earpiece'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: FilledButton.icon(
                  onPressed: onHangup,
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFFFF4D6D),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  icon: const Icon(Icons.call_end_rounded),
                  label: const Text('End call'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _FloatingCallChip extends StatelessWidget {
  final String subtitle;
  final VoidCallback onTap;

  const _FloatingCallChip({required this.subtitle, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: Glass(
        radius: BorderRadius.circular(999),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.call_rounded, size: 18, color: scheme.primary),
            const SizedBox(width: 6),
            Text(
              subtitle,
              style: TextStyle(
                color: scheme.onSurface,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  final String title;
  final String? username;
  final String? avatarUrl;
  final bool showOnlineIndicator;
  final VoidCallback onBack;
  final VoidCallback onProfileTap;
  final VoidCallback onCall;
  final VoidCallback onToggleSearch;
  final ValueChanged<_DmMenuAction> onMenuSelected;
  final bool showPinnedOnly;
  final bool isInCall;
  final String callStatusText;
  final int callDuration;

  const _TopBar({
    required this.title,
    required this.username,
    required this.avatarUrl,
    required this.showOnlineIndicator,
    required this.onBack,
    required this.onProfileTap,
    required this.onCall,
    required this.onToggleSearch,
    required this.onMenuSelected,
    required this.showPinnedOnly,
    required this.isInCall,
    required this.callStatusText,
    required this.callDuration,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 10, 14, 0),
      child: Row(
        children: [
          _IconGlass(icon: Icons.arrow_back_ios_new_rounded, onTap: onBack),
          const SizedBox(width: 10),
          Expanded(
            child: InkWell(
              borderRadius: BorderRadius.circular(14),
              onTap: onProfileTap,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 16,
                      backgroundColor:
                          Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.1),
                      foregroundColor: Theme.of(context).colorScheme.onSurface,
                      backgroundImage:
                          (avatarUrl != null && avatarUrl!.trim().isNotEmpty)
                              ? NetworkImage(avatarUrl!)
                              : null,
                      child: (avatarUrl == null || avatarUrl!.trim().isEmpty)
                          ? const Icon(Icons.person_rounded, size: 16)
                          : null,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onSurface,
                              fontSize: 17,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          Text(
                            isInCall
                                ? callStatusText
                                : showOnlineIndicator
                                    ? '● Active now'
                                    : '@${(username == null || username!.isEmpty) ? title : username}',
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: isInCall
                                  ? Theme.of(context).colorScheme.primary
                                  : showOnlineIndicator
                                      ? const Color(0xFF58F7B6)
                                  : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.68),
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (showOnlineIndicator)
            Container(
              width: 8,
              height: 8,
              margin: const EdgeInsets.only(right: 8),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF58F7B6),
                border: Border.all(
                  color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.7),
                  width: 1.5,
                ),
              ),
            ),
          const SizedBox(width: 10),
          _IconGlass(icon: Icons.search_rounded, onTap: onToggleSearch),
          const SizedBox(width: 8),
          PopupMenuButton<_DmMenuAction>(
            onSelected: onMenuSelected,
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: _DmMenuAction.media,
                child: Text('Find photos & videos'),
              ),
              const PopupMenuItem(
                value: _DmMenuAction.documents,
                child: Text('Find documents'),
              ),
              PopupMenuItem(
                value: _DmMenuAction.togglePinnedOnly,
                child: Text(showPinnedOnly ? 'Show all messages' : 'Show pinned only'),
              ),
              const PopupMenuItem(
                value: _DmMenuAction.clearDraft,
                child: Text('Clear draft'),
              ),
            ],
            child: Glass(
              radius: BorderRadius.circular(16),
              padding: const EdgeInsets.all(10),
              child: Icon(
                Icons.more_horiz_rounded,
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.92),
                size: 20,
              ),
            ),
          ),
          const SizedBox(width: 8),
          _IconGlass(
            icon: isInCall ? Icons.call_end_rounded : Icons.call_rounded,
            onTap: onCall,
          ),
        ],
      ),
    );
  }

  String _fmtCallDuration(int seconds) {
    final mm = (seconds ~/ 60).toString().padLeft(2, '0');
    final ss = (seconds % 60).toString().padLeft(2, '0');
    return '$mm:$ss';
  }
}

class _Bubble extends StatelessWidget {
  final String text;
  final String rawContent;
  final String time;
  final bool isMe;
  final bool isRead;
  final String? replyTo;
  final String? readAt;
  final Map<String, dynamic> reactions;
  final VoidCallback? onLongPress;
  final ValueChanged<String>? onTapFile;
  final ValueChanged<String>? onReact;
  final bool pinned;

  const _Bubble({
    required this.text,
    required this.rawContent,
    required this.time,
    required this.isMe,
    required this.isRead,
    this.replyTo,
    this.readAt,
    this.reactions = const {},
    this.onLongPress,
    this.onTapFile,
    this.onReact,
    this.pinned = false,
  });

  @override
  Widget build(BuildContext context) {
    final align = isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start;
    final radius = BorderRadius.only(
      topLeft: const Radius.circular(18),
      topRight: const Radius.circular(18),
      bottomLeft: Radius.circular(isMe ? 18 : 6),
      bottomRight: Radius.circular(isMe ? 6 : 18),
    );

    final scheme = Theme.of(context).colorScheme;
    final parsed = _MessagePayload.parse(rawContent);
    final isImage = parsed.type == 'image';
    final imageUrl = parsed.url;
    final isVoice = parsed.type == 'voice';
    final isFile = parsed.type == 'file';


    return Column(
      crossAxisAlignment: align,
      children: [
        if (replyTo != null)
          Padding(
            padding: EdgeInsets.only(
              bottom: 4,
              right: isMe ? 4 : 0,
              left: isMe ? 0 : 4,
            ),
            child: Text(
              'Replying to: $replyTo',
              style: TextStyle(
                color: scheme.onSurface.withValues(alpha: 0.6),
                fontSize: 11,
                fontStyle: FontStyle.italic,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        GestureDetector(
          onLongPress: onLongPress,
          onTap: isFile && parsed.url != null ? () => onTapFile?.call(parsed.url!) : null,
          child: Container(
          constraints: const BoxConstraints(maxWidth: 320),
          padding: EdgeInsets.symmetric(
            horizontal: isImage ? 6 : 14,
            vertical: isImage ? 6 : 12,
          ),
          decoration: BoxDecoration(
            borderRadius: radius,
            color: isMe
                ? scheme.primary.withValues(alpha: 0.12)
                : scheme.onSurface.withValues(alpha: 0.07),
            border: Border.all(
              color: isMe
                  ? scheme.primary.withValues(alpha: 0.24)
                  : scheme.onSurface.withValues(alpha: 0.12),
            ),
          ),
          child: isImage
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    imageUrl ?? '',
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Padding(
                      padding: const EdgeInsets.all(10),
                      child: Text(
                        'Image unavailable',
                        style: TextStyle(
                          color: scheme.onSurface.withValues(alpha: 0.75),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                )
              : isVoice
                  ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.play_arrow_rounded, color: scheme.primary),
                        const SizedBox(width: 6),
                        Text(
                          text,
                          style: TextStyle(
                            color: scheme.onSurface.withValues(alpha: 0.92),
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    )
                  : isFile
                      ? Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.description_rounded, color: scheme.primary),
                            const SizedBox(width: 8),
                            Flexible(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    parsed.fileName ?? 'Document',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: scheme.onSurface.withValues(alpha: 0.92),
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                  if (parsed.sizeBytes != null)
                                    Text(
                                      _formatBytes(parsed.sizeBytes!),
                                      style: TextStyle(
                                        color: scheme.onSurface.withValues(alpha: 0.66),
                                        fontWeight: FontWeight.w600,
                                        fontSize: 12,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ],
                        )
                      : Text(
                          text,
                          style: TextStyle(
                            color: scheme.onSurface.withValues(alpha: 0.92),
                            fontWeight: FontWeight.w700,
                            height: 1.25,
                            fontSize: 14.5,
                          ),
                        ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 4, right: isMe ? 4 : 0, left: isMe ? 0 : 4),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (pinned)
                Padding(
                  padding: const EdgeInsets.only(right: 4),
                  child: Icon(Icons.push_pin_rounded, size: 12, color: scheme.primary),
                ),
              Text(
                time,
                style: TextStyle(
                  color: scheme.onSurface.withValues(alpha: 0.55),
                  fontSize: 10.5,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),

        if (reactions.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Wrap(
              spacing: 6,
              children: reactions.entries.map((entry) {
                final count = (entry.value as List?)?.length ?? 0;
                return GestureDetector(
                  onTap: () => onReact?.call(entry.key),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: scheme.onSurface.withValues(alpha: 0.08),
                    ),
                    child: Text('${entry.key} $count'),
                  ),
                );
              }).toList(),
            ),
          ),
        if (isMe)
          Padding(
            padding: const EdgeInsets.only(top: 2, right: 4),
            child: Icon(
              isRead ? Icons.done_all_rounded : Icons.done_rounded,
              size: 14,
              color: isRead ? const Color(0xFF58F7B6) : scheme.onSurface.withValues(alpha: 0.5),
            ),
          ),
      ],
    );
  }


  String _formatBytes(int bytes) {
    if (bytes < 1024) return '$bytes B';
    final kb = bytes / 1024;
    if (kb < 1024) return '${kb.toStringAsFixed(1)} KB';
    return '${(kb / 1024).toStringAsFixed(1)} MB';
  }
}

class _MessagePayload {
  final String type;
  final String? text;
  final String? url;
  final String? thumb;
  final int? duration;
  final String? fileName;
  final int? sizeBytes;
  final String? replyTo;

  const _MessagePayload({
    required this.type,
    this.text,
    this.url,
    this.thumb,
    this.duration,
    this.fileName,
    this.sizeBytes,
    this.replyTo,
  });

  static _MessagePayload parse(String raw) {
    try {
      final map = jsonDecode(raw);
      if (map is Map<String, dynamic>) {
        return _MessagePayload(
          type: map['type']?.toString() ?? 'text',
          text: map['text']?.toString() ?? map['label']?.toString(),
          url: map['url']?.toString(),
          thumb: map['thumb']?.toString(),
          duration: map['duration'] is int ? map['duration'] as int : int.tryParse('${map['duration']}'),
          fileName: map['name']?.toString(),

          sizeBytes: map['size'] is int ? map['size'] as int : int.tryParse('${map['size']}'),
          replyTo: map['reply_to']?.toString(),
        );
      }
    } catch (_) {
      // legacy plain text fallback
    }
    if (raw.startsWith('[img]')) {
      return _MessagePayload(type: 'image', url: raw.substring(5).trim());
    }
    return _MessagePayload(type: 'text', text: raw);
  }
}

class _ChatMessage {
  final String id;
  final bool isMine;
  final String previewText;
  final String rawContent;
  final _MessagePayload payload;

  const _ChatMessage({
    required this.id,
    required this.isMine,
    required this.previewText,
    required this.rawContent,
    required this.payload,
  });

  factory _ChatMessage.fromRow(Map<String, dynamic> row, {required bool isMe}) {
    final raw = row['content']?.toString() ?? '';
    final payload = _MessagePayload.parse(raw);
    final preview = switch (payload.type) {
      'image' => 'Photo',
      'voice' => 'Voice message ${payload.text ?? ''}'.trim(),
      'file' => payload.fileName?.isNotEmpty == true ? 'Document: ${payload.fileName}' : 'Document',
      _ => payload.text ?? raw,
    };

    return _ChatMessage(
      id: row['id']?.toString() ?? '',
      isMine: isMe,
      previewText: preview,
      rawContent: raw,
      payload: payload,
    );
  }
}


class _InputBar extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSend;
  final VoidCallback onVoiceMessage;
  final VoidCallback onSendImage;
  final VoidCallback onSendFile;
  final ValueChanged<bool> onTypingChanged;
  final ValueChanged<String> onTextChanged;
  final bool isRecordingVoiceMessage;
  final int recordingSeconds;

  const _InputBar({
    required this.controller,
    required this.onSend,
    required this.onVoiceMessage,
    required this.onSendImage,
    required this.onSendFile,
    required this.onTypingChanged,
    required this.onTextChanged,
    required this.isRecordingVoiceMessage,
    required this.recordingSeconds,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final recordMm = (recordingSeconds ~/ 60).toString().padLeft(2, '0');
    final recordSs = (recordingSeconds % 60).toString().padLeft(2, '0');

    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isRecordingVoiceMessage)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Glass(
                radius: BorderRadius.circular(999),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.mic_rounded, color: Color(0xFFFF6B6B), size: 16),
                    const SizedBox(width: 6),
                    Text(
                      'Recording $recordMm:$recordSs (max 01:00)',
                      style: TextStyle(
                        color: scheme.onSurface.withValues(alpha: 0.9),
                        fontWeight: FontWeight.w800,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          Glass(
            radius: BorderRadius.circular(22),
            padding: const EdgeInsets.fromLTRB(12, 10, 10, 10),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    style: TextStyle(
                        color: scheme.onSurface, fontWeight: FontWeight.w700),
                    cursorColor: scheme.primary,
                    minLines: 1,
                    maxLines: 4,
                    onChanged: (v) {
                      onTypingChanged(v.trim().isNotEmpty);
                      onTextChanged(v);
                    },
                    onSubmitted: (_) {
                      onSend();
                      onTypingChanged(false);
                    },
                    decoration: InputDecoration(
                      hintText: "Message…",
                      hintStyle: TextStyle(color: scheme.onSurface.withValues(alpha: 0.45)),
                      border: InputBorder.none,
                      isDense: true,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                InkWell(
                  borderRadius: BorderRadius.circular(18),
                  onTap: onSendImage,
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: scheme.onSurface.withValues(alpha: 0.10),
                      border: Border.all(color: scheme.onSurface.withValues(alpha: 0.16)),
                    ),
                    child: Icon(Icons.image_rounded, color: scheme.onSurface.withValues(alpha: 0.92)),
                  ),
                ),
                const SizedBox(width: 8),
                InkWell(
                  borderRadius: BorderRadius.circular(18),
                  onTap: onSendFile,
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: scheme.onSurface.withValues(alpha: 0.10),
                      border: Border.all(color: scheme.onSurface.withValues(alpha: 0.16)),
                    ),
                    child: Icon(Icons.attach_file_rounded, color: scheme.onSurface.withValues(alpha: 0.92)),
                  ),
                ),
                const SizedBox(width: 8),
                InkWell(
                  borderRadius: BorderRadius.circular(18),
                  onTap: onVoiceMessage,
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: isRecordingVoiceMessage
                          ? const Color(0xFFFF6B6B).withValues(alpha: 0.18)
                          : scheme.primary.withValues(alpha: 0.12),
                      border: Border.all(
                        color: isRecordingVoiceMessage
                            ? const Color(0xFFFF6B6B)
                            : scheme.primary.withValues(alpha: 0.22),
                      ),
                    ),
                    child: Icon(
                      isRecordingVoiceMessage ? Icons.stop_rounded : Icons.mic_rounded,
                      color: isRecordingVoiceMessage ? const Color(0xFFFF6B6B) : scheme.primary,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                InkWell(
                  borderRadius: BorderRadius.circular(18),
                  onTap: onSend,
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: scheme.onSurface.withValues(alpha: 0.10),
                      border: Border.all(color: scheme.onSurface.withValues(alpha: 0.16)),
                    ),
                    child: Icon(Icons.send_rounded,
                        color: scheme.onSurface.withValues(alpha: 0.92)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


class _MessageRequestOverlay extends StatelessWidget {
  final String? sentRequestStatus;
  final String? incomingRequestStatus;
  final VoidCallback onSendRequest;
  final VoidCallback onAccept;
  final VoidCallback onDecline;

  const _MessageRequestOverlay({
    required this.sentRequestStatus,
    required this.incomingRequestStatus,
    required this.onSendRequest,
    required this.onAccept,
    required this.onDecline,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
      child: Glass(
        radius: BorderRadius.circular(14),
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Messaging is restricted to friends. Send a message request to continue.',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            if (incomingRequestStatus == 'pending')
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: onDecline,
                      child: const Text('Decline'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: FilledButton(
                      onPressed: onAccept,
                      child: const Text('Accept request'),
                    ),
                  ),
                ],
              )
            else if (sentRequestStatus == 'pending')
              const Text('Request sent. Waiting for approval.', style: TextStyle(fontWeight: FontWeight.w700))
            else
              FilledButton.icon(
                onPressed: onSendRequest,
                icon: const Icon(Icons.send_rounded),
                label: const Text('Send message request'),
              ),
          ],
        ),
      ),
    );
  }
}

class _BlockedOverlay extends StatelessWidget {
  final VoidCallback onUnblock;
  
  const _BlockedOverlay({required this.onUnblock});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      color: scheme.surface,
      child: Column(
        children: [
          Text(
            "You have blocked this user",
             style: TextStyle(
              color: scheme.onSurface.withValues(alpha: 0.7),
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: onUnblock,
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: scheme.error),
                foregroundColor: scheme.error,
              ),
              child: const Text("Unblock"),
            ),
          ),
        ],
      ),
    );
  }
}

class _IconGlass extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _IconGlass({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Glass(
        radius: BorderRadius.circular(16),
        padding: const EdgeInsets.all(10),
        child: Icon(icon, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.92), size: 20),
      ),
    );
  }
}
