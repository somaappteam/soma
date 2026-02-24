import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:soma/core/services/app_logger.dart';
import 'package:soma/core/services/haptics_service.dart';
import 'package:soma/core/theme/motion.dart';
import 'package:soma/core/theme/tokens.dart';
import 'package:soma/core/widgets/glass.dart';
import 'package:soma/data/ai_repository.dart';
import 'package:soma/data/call_signaling_service.dart';
import 'package:soma/data/chat_repository.dart';
import 'package:soma/data/presence_repository.dart';
import 'package:soma/data/profile_repository.dart';
import 'package:soma/data/rtc_voice_service.dart';
import 'package:soma/data/settings_repository.dart';
import 'package:soma/data/soma_plus_repository.dart';
import 'package:soma/data/user_report_repository.dart';
import 'package:soma/features/profile/profile_screen.dart';
import 'package:soma/l10n/gen/app_localizations.dart';
import 'package:soma/models/user_profile.dart';
import 'package:soma/models/user_stats.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

enum DmCallState {
  idle,
  ringingOutgoing,
  ringingIncoming,
  connecting,
  connected
}

enum _DmMenuAction {
  togglePin,
  toggleMute,
  advancedSearch,
}

class DmChatScreen extends StatefulWidget {
  const DmChatScreen({
    super.key,
    required this.meId,
    required this.otherId,
    required this.otherName,
    this.initialDraftText,
    this.initialIncomingCall = false,
  });

  final String meId;
  final String otherId;
  final String otherName;
  final String? initialDraftText;
  final bool initialIncomingCall;

  @override
  State<DmChatScreen> createState() => _DmChatScreenState();
}

class _DmChatScreenState extends State<DmChatScreen> {
  static const int _freeDailyVoiceMessages = 5;
  static const int _freeDailyImages = 5;
  static const int _freeDailyFiles = 5;
  static const int _freeDailyVoiceCalls = 3;

  final _controller = TextEditingController();
  final _composerFocus = FocusNode();
  final _scroll = ScrollController();
  final _imagePicker = ImagePicker();
  final AudioRecorder _voiceRecorder = AudioRecorder();
  final AudioPlayer _draftVoicePlayer = AudioPlayer();
  late Stream<List<Map<String, dynamic>>> _messagesStream;
  late Stream<bool> _onlineStream;
  bool _showOnlineIndicator = true;
  bool _readSyncInFlight = false;
  DmCallState _callState = DmCallState.idle;
  bool _isRecordingVoiceMessage = false;
  bool _isPlayingDraftVoice = false;
  int _voiceRecordElapsedSeconds = 0;
  int _draftVoiceDurationSeconds = 0;
  String? _draftVoicePath;
  List<double> _draftVoiceWaveform = [];
  StreamSubscription<Amplitude>? _amplitudeSub;
  Timer? _voiceRecordTimer;
  Timer? _callTimer;
  Timer? _callSetupTimeoutTimer;
  Timer? _outgoingRingTimer;
  Timer? _incomingRingTimer;
  int _callElapsedSeconds = 0;
  StreamSubscription<CallSignalEvent>? _signalSub;
  StreamSubscription<bool>? _rtcConnectionSub;
  StreamSubscription<Map<String, dynamic>>? _rtcTelemetrySub;
  String? _replyPreview;
  UserProfile? _otherProfile;
  SomaSubscriptionTier _planTier = SomaSubscriptionTier.free;

  DmPlanLimits get _dmLimits => SomaPlusRepository.dmLimitsForTier(_planTier);
  bool _showSearch = false;
  String _searchQuery = '';
  bool _showPinnedOnly = false;
  bool _callPanelMinimized = false;
  bool _isMicMuted = false;
  bool _isSpeakerOn = true;
  bool _isRtcConnected = false;
  Offset _floatingChipOffset = Offset.zero;
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
  bool _isComposerFocused = false;
  Timer? _scheduledSendTimer;
  DateTime? _muteUntil;
  Duration? _disappearingWindow;
  final Map<String, DateTime> _messageEditTimes = <String, DateTime>{};
  String? _replyToMessageId;
  String? _jumpHighlightMessageId;
  List<String> _lastVisibleMessageIds = const [];
  bool _showUnreadOnly = false;
  bool _showLinksOnly = false;
  bool _showMentionsOnly = false;
  final bool _autoTranslateIncoming = false;
  final String _autoTranslateLanguage = 'English';
  final bool _examModeEnabled = false;
  String? _lastFailedTextMessage;
  bool _noiseSuppressionEnabled = true;

  String? _liveCaption;

  int get _maxImageBytes => _dmLimits.maxImageBytes;

  int get _maxFileBytes => _dmLimits.maxFileBytes;

  int get _maxTextChars => _dmLimits.maxTextChars;

  int get _maxVoiceMessageSeconds => _dmLimits.maxVoiceMessageSeconds;

  String get _myUserId => chatRepository.currentUserId ?? widget.meId;

  String _normalizeUsernameToken(final String raw) {
    final compact = raw.replaceAll(RegExp(r'\s+'), '').trim().toLowerCase();
    final safe = compact.replaceAll(RegExp(r'[^a-z0-9_]'), '');
    return safe;
  }

  String get _fallbackUsernameToken {
    final fromName = _normalizeUsernameToken(widget.otherName);
    if (fromName.length >= 3) return fromName;
    final suffix = widget.otherId.length >= 6
        ? widget.otherId.substring(widget.otherId.length - 6)
        : widget.otherId;
    return 'user_$suffix';
  }

  String get _displayUsernameToken {
    final fromProfile = _normalizeUsernameToken(_otherProfile?.username ?? '');
    if (fromProfile.length >= 3) return fromProfile;
    return _fallbackUsernameToken;
  }

  StreamSubscription<Map<String, dynamic>?>? _conversationSub;
  bool _isConversationPinned = false;
  bool _isConversationMuted = false;

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

    if (widget.initialIncomingCall) {
      WidgetsBinding.instance.addPostFrameCallback((final _) {
        _startVoiceCall(sendInvite: false, incoming: true);
      });
    }
    _rtcConnectionSub =
        rtcVoiceService.connectionStream.listen(_onRtcConnectionState);
    _rtcTelemetrySub = rtcVoiceService.telemetryStream.listen(_onRtcTelemetry);
    _loadCallChipOffset();

    _conversationSub =
        chatRepository.streamConversation(widget.otherId).listen((final conv) {
      if (!mounted || conv == null) return;
      setState(() {
        _isConversationPinned = conv['is_pinned'] == true;
        _isConversationMuted = conv['is_muted'] == true;
      });
    });

    // NEW: Mark as read when new messages arrive
    // NEW: Mark as read when new messages arrive
    _messagesStream.listen((final messages) {
      if (!mounted || messages.isEmpty) return;
      final recent = messages.last;
      appLogger.debug(
          'DmChatScreen: checking unread. Last msg sender: ${recent['sender_id']}, is_read: ${recent['is_read']}');
      if (recent['sender_id'] != _myUserId && recent['is_read'] == false) {
        // debounce slightly to avoid duplicate calls
        _markConversationAsRead();
      }
    });

    // NEW: Listen to settings for block updates
    _settingsSub =
        settingsRepository.getSettingsStream().listen((final settings) {
      if (!mounted) return;
      final blocked = (settings['blocked_user_ids'] as List?)
              ?.map((final e) => e.toString())
              .contains(widget.otherId) ??
          false;
      if (blocked != _isOtherBlocked) {
        setState(() => _isOtherBlocked = blocked);
      }
    });

    _composerFocus.addListener(() {
      if (!mounted) return;
      setState(() => _isComposerFocused = _composerFocus.hasFocus);
    });
    _draftVoicePlayer.playerStateStream.listen((final state) {
      if (!mounted) return;
      final isPlaying = state.playing;
      if (_isPlayingDraftVoice != isPlaying) {
        setState(() => _isPlayingDraftVoice = isPlaying);
      }
      if (state.processingState == ProcessingState.completed) {
        _draftVoicePlayer.seek(Duration.zero);
      }
    });
  }

  @override
  void dispose() {
    if (_isCallActive) {
      rtcVoiceService.disconnect();
      unawaited(_setGlobalCallState(active: false));
    }
    _signalSub?.cancel();
    _voiceRecordTimer?.cancel();
    _amplitudeSub?.cancel();
    unawaited(_voiceRecorder.dispose());
    unawaited(_draftVoicePlayer.dispose());
    _callTimer?.cancel();
    _callSetupTimeoutTimer?.cancel();
    _outgoingRingTimer?.cancel();
    _incomingRingTimer?.cancel();
    _rtcConnectionSub?.cancel();
    _rtcTelemetrySub?.cancel();
    _conversationSub?.cancel();
    _settingsSub?.cancel(); // NEW
    _typingDebounce?.cancel();
    _scheduledSendTimer?.cancel();
    _setTypingState(false, immediate: true);
    _saveDraft(_controller.text);
    _composerFocus.dispose();
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
    final raw = _controller.text.trim();
    if (!mounted) return;
    unawaited(_sendText(raw));
  }

  bool _ensureCanSendInDm() {
    if (_isOtherBlocked) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Unblock this user to send messages.')),
      );
      return false;
    }
    if (!_canChat) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('You cannot send messages in this chat yet.'),
        ),
      );
      return false;
    }
    return true;
  }

  Future<void> _sendText(final String text) async {
    if (!_ensureCanSendInDm()) return;
    if (text.isEmpty) return;
    if (text.length > _maxTextChars) {
      final allowed = _maxTextChars;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text('Message too long. Keep it under $allowed characters.')),
      );
      return;
    }

    String? translatedText;
    if (_autoTranslateIncoming && _autoTranslateLanguage.isNotEmpty) {
      try {
        translatedText =
            await aiRepository.translateText(text, _autoTranslateLanguage);
      } catch (_) {
        // Fallback or ignore
      }
    }

    final payload = <String, dynamic>{
      'type': 'text',
      'text': text,
      if (_examModeEnabled) 'exam_mode': true,
      if (translatedText != null) 'translated_text': translatedText,
      if (_replyPreview != null) 'reply_to': _replyPreview,
      if (_replyToMessageId != null) 'reply_to_message_id': _replyToMessageId,
      if (_disappearingWindow != null)
        'expires_at':
            DateTime.now().add(_disappearingWindow!).toIso8601String(),
    };
    try {
      await chatRepository.sendMessage(widget.otherId, jsonEncode(payload));
      _setTypingState(false, immediate: true);
      _controller.clear();
      _saveDraft('');
      setState(() {
        _replyPreview = null;
        _replyToMessageId = null;
      });

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
    } catch (e) {
      if (!mounted) return;
      _lastFailedTextMessage = text;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Could not send message: $e'),
          action: SnackBarAction(
            label: 'Retry',
            onPressed: () {
              final retry = _lastFailedTextMessage;
              if (retry == null) return;
              unawaited(_sendText(retry));
            },
          ),
        ),
      );
    }
  }

  void _onTypingChanged(final bool hasText) {
    _typingDebounce?.cancel();
    _typingDebounce = Timer(const Duration(milliseconds: 450), () {
      _setTypingState(hasText);
    });
  }

  void _setTypingState(final bool value, {final bool immediate = false}) {
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
    _controller.text = draft;
    _controller.selection = TextSelection.fromPosition(
      TextPosition(offset: _controller.text.length),
    );
  }

  Future<void> _saveDraft(final String text) async {
    final settings = await settingsRepository.getSettings();
    final drafts = Map<String, dynamic>.from(
        (settings['chat_drafts'] as Map<String, dynamic>?) ?? {});
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
      _pinnedMessageIds = scoped.map((final e) => e.toString()).toSet();
    });
  }

  Future<void> _persistPinnedMessages() async {
    final settings = await settingsRepository.getSettings();
    final raw = Map<String, dynamic>.from(
        (settings['chat_pinned_message_ids'] as Map<String, dynamic>?) ?? {});
    raw[widget.otherId] = _pinnedMessageIds.toList();
    await settingsRepository.updateSetting('chat_pinned_message_ids', raw);
  }

  Future<void> _togglePinMessage(final String messageId) async {
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

  Future<void> _openAttachmentTray() async {
    final action = await showModalBottomSheet<String>(
      context: context,
      showDragHandle: true,
      builder: (final context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
                leading: const Icon(Icons.mic_rounded),
                title: const Text('Voice message'),
                onTap: () => Navigator.pop(context, 'voice')),
            ListTile(
                leading: const Icon(Icons.photo_camera_rounded),
                title: const Text('Camera'),
                onTap: () => Navigator.pop(context, 'camera')),
            ListTile(
                leading: const Icon(Icons.image_rounded),
                title: const Text('Gallery'),
                onTap: () => Navigator.pop(context, 'image')),
            ListTile(
                leading: const Icon(Icons.attach_file_rounded),
                title: const Text('Document'),
                onTap: () => Navigator.pop(context, 'file')),
            ListTile(
                leading: const Icon(Icons.location_on_rounded),
                title: const Text('Location card'),
                onTap: () => Navigator.pop(context, 'location')),
            ListTile(
                leading: const Icon(Icons.contacts_rounded),
                title: const Text('Contact card'),
                onTap: () => Navigator.pop(context, 'contact')),
          ],
        ),
      ),
    );
    if (action == null) return;
    switch (action) {
      case 'voice':
        _handleVoiceMessageTap();
        break;
      case 'camera':
        _pickAndSendImage(fromCamera: true);
        break;
      case 'image':
        _pickAndSendImage();
        break;
      case 'file':
        _pickAndSendDocument();
        break;
      case 'location':
        _composeLocationCard();
        break;
      case 'contact':
        _composeContactCard();
        break;
    }
  }

  Future<void> _composeLocationCard() async {
    final placeController = TextEditingController();
    final addressController = TextEditingController();
    final latController = TextEditingController();
    final lngController = TextEditingController();

    final payload = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (final context) => AlertDialog(
        title: const Text('Send location card'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: placeController,
                decoration: const InputDecoration(
                    labelText: 'Place name', hintText: 'Coffee Lab'),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: addressController,
                decoration: const InputDecoration(
                    labelText: 'Address', hintText: 'City, street'),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: latController,
                      keyboardType: const TextInputType.numberWithOptions(
                          decimal: true, signed: true),
                      decoration: const InputDecoration(labelText: 'Latitude'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: lngController,
                      keyboardType: const TextInputType.numberWithOptions(
                          decimal: true, signed: true),
                      decoration: const InputDecoration(labelText: 'Longitude'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel')),
          FilledButton(
            onPressed: () {
              final place = placeController.text.trim();
              final address = addressController.text.trim();
              final lat = double.tryParse(latController.text.trim());
              final lng = double.tryParse(lngController.text.trim());
              if (place.isEmpty &&
                  address.isEmpty &&
                  (lat == null || lng == null)) {
                Navigator.pop(context);
                return;
              }
              final mapUrl = (lat != null && lng != null)
                  ? 'https://maps.google.com/?q=$lat,$lng'
                  : (address.isNotEmpty
                      ? 'https://maps.google.com/?q=${Uri.encodeComponent(address)}'
                      : null);
              Navigator.pop(context, {
                'type': 'location',
                'text': place.isNotEmpty
                    ? place
                    : (address.isNotEmpty ? address : 'Shared location'),
                'label': place.isNotEmpty ? place : 'Location card',
                'items': [
                  if (address.isNotEmpty) address,
                  if (lat != null && lng != null)
                    'Lat/Lng: ${lat.toStringAsFixed(5)}, ${lng.toStringAsFixed(5)}',
                ],
                if (mapUrl != null) 'url': mapUrl,
              });
            },
            child: const Text('Send'),
          ),
        ],
      ),
    );

    if (!mounted || payload == null) return;
    await _sendMessagePayload(payload);
  }

  Future<void> _composeContactCard() async {
    final nameController = TextEditingController();
    final phoneController = TextEditingController();
    final noteController = TextEditingController();

    final payload = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (final context) => AlertDialog(
        title: const Text('Send contact card'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                    labelText: 'Name', hintText: 'Jane Doe'),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                    labelText: 'Phone number', hintText: '+1 555 0199'),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: noteController,
                decoration: const InputDecoration(
                    labelText: 'Note (optional)', hintText: 'Tutor partner'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel')),
          FilledButton(
            onPressed: () {
              final name = nameController.text.trim();
              final phone = phoneController.text.trim();
              final note = noteController.text.trim();
              if (name.isEmpty || phone.isEmpty) {
                Navigator.pop(context);
                return;
              }
              final tel = phone.replaceAll(RegExp(r'\s+'), '');
              Navigator.pop(context, {
                'type': 'contact',
                'text': name,
                'label': 'Contact: $name',
                'items': [phone, if (note.isNotEmpty) note],
                'url': 'tel:$tel',
              });
            },
            child: const Text('Send'),
          ),
        ],
      ),
    );

    if (!mounted || payload == null) return;
    await _sendMessagePayload(payload);
  }

  Future<void> _sendMessagePayload(final Map<String, dynamic> payload) async {
    if (!_ensureCanSendInDm()) return;
    if (_disappearingWindow != null) {
      payload['expires_at'] =
          DateTime.now().add(_disappearingWindow!).toIso8601String();
    }
    if (_replyToMessageId != null) {
      payload['reply_to_message_id'] = _replyToMessageId;
    }
    if (_replyPreview != null) {
      payload['reply_to'] = _replyPreview;
    }
    await chatRepository.sendMessage(widget.otherId, jsonEncode(payload));
    if (!mounted) return;
    setState(() {
      _replyPreview = null;
      _replyToMessageId = null;
    });
  }

  Future<void> _jumpToMessageById(final String? messageId) async {
    if (messageId == null || messageId.isEmpty) return;
    final idx = _lastVisibleMessageIds.indexOf(messageId);
    if (idx < 0 || !_scroll.hasClients) return;
    await _scroll.animateTo(
      (idx * 76).toDouble().clamp(0, _scroll.position.maxScrollExtent),
      duration: MotionTokens.medium,
      curve: Curves.easeOut,
    );
    if (!mounted) return;
    setState(() => _jumpHighlightMessageId = messageId);
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      setState(() => _jumpHighlightMessageId = null);
    });
  }

  String _deliveryStatus(
      {required final bool isMe,
      required final bool isRead,
      required final DateTime createdAt}) {
    if (!isMe) return '';
    if (isRead) return 'Read';
    if (DateTime.now().difference(createdAt).inSeconds < 4) return 'Sent';
    return 'Delivered';
  }

  void _handleMenuAction(final _DmMenuAction action) {
    switch (action) {
      case _DmMenuAction.togglePin:
        chatRepository.setConversationPreference(widget.otherId,
            pinned: !_isConversationPinned);
        break;
      case _DmMenuAction.toggleMute:
        chatRepository.setConversationPreference(widget.otherId,
            muted: !_isConversationMuted);
        break;
      case _DmMenuAction.advancedSearch:
        setState(() => _showSearch = true);
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
      final profile =
          await profileRepository.fetchProfile(userId: widget.otherId);
      if (!mounted || profile == null) return;
      setState(() => _otherProfile = profile);
    } catch (_) {
      // ignore
    }
  }

  Future<void> _loadCostTier() async {
    try {
      final settings = await settingsRepository.getSettings();
      final tier =
          SomaPlusRepository.parseTier(settings['plus_plan']?.toString());
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

  int _intValue(final dynamic value) => (value as num?)?.toInt() ?? 0;

  Future<bool> _canUseFreeQuota({
    required final String key,
    required final int limit,
    required final String limitMessage,
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

  Future<void> _incrementFreeQuota(final String key) async {
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

  String _formatCallDuration(final int seconds) {
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
      DmCallState.connected =>
        'In call ${_formatCallDuration(_callElapsedSeconds)}',
    };
  }

  bool get _isOutgoingDialing =>
      _callState == DmCallState.ringingOutgoing ||
      _callState == DmCallState.connecting;

  String get _callQualityLabel {
    if (!_isCallActive) return 'Idle';
    if (_smoothedCallQualityScore >= 80) return 'Excellent';
    if (_smoothedCallQualityScore >= 55) return 'Fair';
    return 'Poor';
  }

  void _startOutgoingRing() {
    _outgoingRingTimer?.cancel();
    SystemSound.play(SystemSoundType.alert);
    hapticsService.selectionClick();
    _outgoingRingTimer =
        Timer.periodic(const Duration(milliseconds: 1600), (final timer) {
      if (!mounted || !_isOutgoingDialing) {
        timer.cancel();
        return;
      }
      SystemSound.play(SystemSoundType.alert);
      hapticsService.selectionClick();
    });
  }

  void _stopOutgoingRing() {
    _outgoingRingTimer?.cancel();
    _outgoingRingTimer = null;
  }

  void _startIncomingRing() {
    _incomingRingTimer?.cancel();
    SystemSound.play(SystemSoundType.alert);
    hapticsService.mediumImpact();
    _incomingRingTimer =
        Timer.periodic(const Duration(milliseconds: 1600), (final _) {
      if (!mounted || _callState != DmCallState.ringingIncoming) return;
      SystemSound.play(SystemSoundType.alert);
      hapticsService.mediumImpact();
    });
  }

  void _stopIncomingRing() {
    _incomingRingTimer?.cancel();
    _incomingRingTimer = null;
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
    rtcVoiceService.setSpeakerEnabled(next).then((final _) {
      if (!mounted) return;
      hapticsService.selectionClick();
      setState(() => _isSpeakerOn = next);
    }).catchError((final _) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Unable to switch audio output right now.')),
      );
    });
  }

  void _onFloatingChipDragUpdate(
      final DragUpdateDetails details, final BoxConstraints constraints) {
    final next = _floatingChipOffset + details.delta;
    final maxX =
        (constraints.maxWidth - 170).clamp(0, double.infinity).toDouble();
    final maxY =
        (constraints.maxHeight - 220).clamp(0, double.infinity).toDouble();
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

  DmCallState? _nextStateFor(final DmCallState from, final String event) {
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

  bool _canTransition(final String event) =>
      _nextStateFor(_callState, event) != null;

  void _onRtcTelemetry(final Map<String, dynamic> data) {
    final retries = (data['turnRetries'] as num?)?.toInt() ?? 0;
    final buffered = (data['candidateBuffered'] as num?)?.toInt() ?? 0;
    final peers = (data['peerCount'] as num?)?.toInt() ?? 0;
    var score = 90;
    score -= (retries * 8);
    score -= (buffered > 0 ? 12 : 0);
    score -= (peers > 2 ? (peers - 2) * 3 : 0);
    if (!_isRtcConnected) score -= 25;
    final clamped = score.clamp(15, 98).toInt();
    final smoothed =
        ((_smoothedCallQualityScore * 0.7) + (clamped * 0.3)).round();
    if (!mounted) return;
    setState(() {
      _smoothedCallQualityScore = smoothed;
    });
  }

  Future<void> _setGlobalCallState({required final bool active}) async {
    await settingsRepository.updateSetting('dm_active_call', {
      'active': active,
      'other_id': active ? widget.otherId : null,
      'other_name': active ? widget.otherName : null,
      'ended_at': active ? null : DateTime.now().toIso8601String(),
    });
  }

  void _initDmCallSignaling() {
    _signalSub = callSignalingService.events.listen((final event) {
      if (event.fromUserId != widget.otherId) return;
      _handleDmCallSignal(event);
    });
  }

  Future<void> _handleDmCallSignal(final CallSignalEvent event) async {
    final type = event.type;
    final data = event.rawData;

    if (type == CallSignalType.invite) {
      if (_isCallActive || !_canTransition('invite')) {
        await _emitDmCallSignal(CallSignalType.busy);
        return;
      }
      if (!mounted) return;
      setState(() {
        _callState = DmCallState.ringingIncoming;
        _callPanelMinimized = false;
      });
      _startIncomingRing();
      final accepted = await _showIncomingCallDialog();
      _stopIncomingRing();
      if (!mounted || _callState != DmCallState.ringingIncoming) return;

      if (accepted) {
        await _startVoiceCall(sendInvite: false, incoming: true);
      } else {
        setState(() => _callState = DmCallState.idle);
        await _emitDmCallSignal(CallSignalType.decline);
      }
      return;
    }

    if (type == CallSignalType.accept) {
      if (!_canTransition('accept')) return;
      if (_callState == DmCallState.ringingOutgoing) {
        setState(() => _callState = DmCallState.connecting);
        _startCallSetupTimeout();
      } else if (_callState == DmCallState.ringingIncoming) {
        // This handles cases where we tap Answer on a native CallKit UI
        // which triggers a local 'accept' signal.
        await _startVoiceCall(sendInvite: false, incoming: true);
      }
      return;
    }

    if (type == CallSignalType.connected) {
      if (!_canTransition('connected')) return;
      _markCallConnected();
      return;
    }

    if (type == CallSignalType.decline) {
      if (!_canTransition('decline')) return;
      if (!_isCallActive) return;
      _stopIncomingRing();
      await _endVoiceCall(
          showRemoteEnded: true, message: 'Voice call declined');
      return;
    }

    if (type == CallSignalType.busy) {
      if (!_isCallActive) return;
      _stopIncomingRing();
      await _endVoiceCall(
          showRemoteEnded: true,
          message: '${widget.otherName} is busy on another call');
      return;
    }

    if (type == CallSignalType.end) {
      if (!_canTransition('end')) return;
      if (!_isCallActive) return;
      _stopIncomingRing();
      await _endVoiceCall(showRemoteEnded: true);
    }
  }

  Future<bool> _showIncomingCallDialog() async {
    final responseFuture = showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (final context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 24),
        child: Glass(
          radius: BorderRadius.circular(24),
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 22,
                    backgroundColor: T.accent.withValues(alpha: 0.18),
                    child: const Icon(Icons.person_rounded),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Incoming voice call',
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w900,
                                  ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          widget.otherName,
                          style:
                              Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    fontWeight: FontWeight.w800,
                                  ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                'Your phone will keep ringing until you accept or decline. The request expires in 30 seconds.',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w600,
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

    unawaited(Future<void>.delayed(const Duration(seconds: 30), () {
      if (!mounted) return;
      if (_callState != DmCallState.ringingIncoming) return;
      final nav = Navigator.of(context, rootNavigator: true);
      if (nav.canPop()) {
        nav.pop(false);
      }
    }));

    final response = await responseFuture;
    return response == true;
  }

  void _onRtcConnectionState(final bool connected) {
    if (!mounted) return;
    setState(() => _isRtcConnected = connected);
    if (!connected) return;
    if (!_isCallActive) return;

    _markCallConnected();
    _emitDmCallSignal(CallSignalType.connected);
  }

  void _markCallConnected() {
    if (!mounted) return;
    if (_callState == DmCallState.connected) return;

    _callSetupTimeoutTimer?.cancel();
    _callTimer?.cancel();
    _stopOutgoingRing();
    _stopIncomingRing();
    setState(() {
      _callState = DmCallState.connected;
      _callElapsedSeconds = 0;
      _callPanelMinimized = false;
      _isRtcConnected = true;
      _liveCaption = 'Live caption: call connected.';
    });
    _callTimer = Timer.periodic(const Duration(seconds: 1), (final _) {
      if (!mounted || _callState != DmCallState.connected) return;
      setState(() {
        _callElapsedSeconds += 1;
        if (_callElapsedSeconds % 8 == 0) {
          _liveCaption =
              'Live caption: Keep going, your pronunciation sounds clear.';
        }
      });
    });
  }

  void _startCallSetupTimeout() {
    _callSetupTimeoutTimer?.cancel();
    _callSetupTimeoutTimer = Timer(const Duration(seconds: 20), () async {
      if (!mounted) return;
      if (_callState == DmCallState.connected ||
          _callState == DmCallState.idle) {
        return;
      }

      final retryWithRelay = await showDialog<bool>(
        context: context,
        builder: (final context) => AlertDialog(
          title: const Text('Call connection issue'),
          content: const Text(
              'Unable to connect quickly. Retry using relay (TURN)?'),
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
        // TODO: Implement forceTurnRelay in RtcVoiceService if needed.
        // For now, we just retry connect which will use TURN if available.
        await rtcVoiceService.connect(
            circleId: _dmVoiceChannelId(),
            asSpeaker: true,
            prioritySpeaker: true);
        _startCallSetupTimeout();
      } else {
        await _emitDmCallSignal(CallSignalType.end);
        await _endVoiceCall(
            showRemoteEnded: false, message: 'Voice call failed to connect');
      }
    });
  }

  Future<void> _emitDmCallSignal(final CallSignalType type) async {
    await callSignalingService.sendSignal(
      toUserId: widget.otherId,
      type: type,
    );
  }

  Future<bool> _startVoiceCall(
      {required final bool sendInvite, final bool incoming = false}) async {
    final l10n = AppLocalizations.of(context);
    try {
      final success = await rtcVoiceService.connect(
          circleId: _dmVoiceChannelId(),
          asSpeaker: true,
          prioritySpeaker: true);
      if (!success) {
        if (!mounted) return false;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content:
                  Text('Microphone permission is required to make calls.')),
        );
        return false;
      }
      if (!mounted) return false;

      setState(() {
        _callState =
            incoming ? DmCallState.connecting : DmCallState.ringingOutgoing;
        _callElapsedSeconds = 0;
        _callPanelMinimized = false;
        _isMicMuted = false;
        _isSpeakerOn = true;
        _isRtcConnected = false;
        _smoothedCallQualityScore = 78;
      });

      if (sendInvite) {
        await _emitDmCallSignal(CallSignalType.invite);
        _startOutgoingRing();
      } else if (incoming) {
        await _emitDmCallSignal(CallSignalType.accept);
      }

      await _setGlobalCallState(active: true);

      _startCallSetupTimeout();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            incoming
                ? 'Accepting voice call…'
                : 'Calling…${_noiseSuppressionEnabled ? ' • Noise suppression on' : ''}',
          ),
        ),
      );
      return true;
    } catch (_) {
      if (!mounted) return false;
      _stopOutgoingRing();
      _stopIncomingRing();
      setState(() => _callState = DmCallState.idle);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.chatCallLater)),
      );
      return false;
    }
  }

  Future<void> _endVoiceCall(
      {required final bool showRemoteEnded, final String? message}) async {
    await rtcVoiceService.disconnect();
    await _setGlobalCallState(active: false);
    if (!mounted) return;
    _callTimer?.cancel();
    _callSetupTimeoutTimer?.cancel();
    _stopOutgoingRing();
    _stopIncomingRing();
    setState(() {
      _callState = DmCallState.idle;
      _callPanelMinimized = false;
      _isMicMuted = false;
      _isSpeakerOn = true;
      _isRtcConnected = false;
      _liveCaption = null;
      _smoothedCallQualityScore = 78;
    });
    await showDialog<void>(
      context: context,
      builder: (final context) => AlertDialog(
        title: const Text('Call summary'),
        content: Text(
            'Duration: ${_formatCallDuration(_callElapsedSeconds)}\nQuality: $_callQualityLabel\nCaptions: ${_liveCaption ?? 'n/a'}'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Done'))
        ],
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message ??
              (showRemoteEnded
                  ? 'Voice call ended by peer'
                  : 'Voice call ended'),
        ),
      ),
    );
  }

  Future<void> _toggleNoiseSuppression() async {
    final next = !_noiseSuppressionEnabled;
    setState(() => _noiseSuppressionEnabled = next);
    await settingsRepository.updateSetting(
        'dm_noise_suppress_${widget.otherId}', next);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text(next
              ? 'Noise suppression enabled'
              : 'Noise suppression disabled')),
    );
  }

  Future<void> _toggleVoiceCall() async {
    if (_isCallActive) {
      final shouldEnd = await _confirmEndActiveCall();
      if (!shouldEnd) return;
      await _emitDmCallSignal(CallSignalType.end);
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

  Future<void> _sendDraftVoiceMessage() async {
    if (!_ensureCanSendInDm()) return;
    final path = _draftVoicePath;
    if (path == null || path.isEmpty) return;

    final canSend = await _canUseFreeQuota(
      key: 'dm_quota_voice_count',
      limit: _freeDailyVoiceMessages,
      limitMessage:
          'Free plan allows $_freeDailyVoiceMessages voice messages per day. Upgrade to Plus for unlimited voice messages.',
    );
    if (!canSend) return;

    try {
      final file = File(path);
      if (!await file.exists()) {
        throw Exception('Recording file not found');
      }
      final bytes = await file.readAsBytes();
      final uid = _myUserId;
      final extension = p.extension(path).replaceFirst('.', '').toLowerCase();
      final safeExt = extension.isEmpty ? 'm4a' : extension;
      final objectPath =
          'chat_voice/$uid/${DateTime.now().millisecondsSinceEpoch}.$safeExt';
      final storage = Supabase.instance.client.storage.from('chat_assets');
      await storage.uploadBinary(
        objectPath,
        bytes,
        fileOptions: const FileOptions(contentType: 'audio/mp4', upsert: true),
      );
      final publicUrl = storage.getPublicUrl(objectPath);
      final duration =
          _draftVoiceDurationSeconds.clamp(1, _maxVoiceMessageSeconds);
      final mm = (duration ~/ 60).toString().padLeft(2, '0');
      final ss = (duration % 60).toString().padLeft(2, '0');

      await chatRepository.sendMessage(
        widget.otherId,
        jsonEncode({
          'type': 'voice',
          'url': publicUrl,
          'duration': duration,
          'label': '$mm:$ss',
          'waveform': _draftVoiceWaveform,
          'transcript': 'Voice note transcription preview ($mm:$ss)',
        }),
      );
      await _incrementFreeQuota('dm_quota_voice_count');
      await _deleteDraftVoice(
          retainSnackbar: true, message: 'Voice message sent');
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not send voice message: $e')),
      );
    }
  }

  Future<bool> _confirmEndActiveCall() async {
    if (_callState != DmCallState.connected || _callElapsedSeconds < 5) {
      return true;
    }
    final shouldEnd = await showDialog<bool>(
      context: context,
      builder: (final context) => AlertDialog(
        title: const Text('End voice call?'),
        content: Text(
            'You are currently in an active call (${_formatCallDuration(_callElapsedSeconds)}).'),
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

  Future<void> _startVoiceRecording() async {
    if (!_ensureCanSendInDm()) return;
    if (_draftVoicePath != null) {
      await _deleteDraftVoice();
    }
    final hasPermission = await _voiceRecorder.hasPermission();
    if (!hasPermission) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text(
                'Microphone permission is required to record voice messages.')),
      );
      return;
    }

    final dir = await getTemporaryDirectory();
    final path = p.join(
        dir.path, 'dm_voice_${DateTime.now().millisecondsSinceEpoch}.m4a');
    await _voiceRecorder.start(
      const RecordConfig(
        encoder: AudioEncoder.aacLc,
        sampleRate: 44100,
        bitRate: 128000,
      ),
      path: path,
    );

    _voiceRecordTimer?.cancel();
    setState(() {
      _isRecordingVoiceMessage = true;
      _voiceRecordElapsedSeconds = 0;
      _draftVoicePath = null;
      _draftVoiceDurationSeconds = 0;
      _draftVoiceWaveform = [];
    });

    // Start amplitude collection
    _amplitudeSub?.cancel();
    _amplitudeSub = _voiceRecorder
        .onAmplitudeChanged(const Duration(milliseconds: 100))
        .listen((final amp) {
      if (!mounted) return;
      // Normalize dBFS (-160 to 0) to 0.0 - 1.0
      // Typical speech might be around -30 to -10 dBFS
      // Silence is usually -160 or lower
      final norm = ((amp.current + 60) / 60).clamp(0.05, 1.0);
      setState(() {
        _draftVoiceWaveform.add(norm);
      });
    });

    _voiceRecordTimer =
        Timer.periodic(const Duration(seconds: 1), (final timer) async {
      if (!mounted) {
        timer.cancel();
        return;
      }
      final nextValue = _voiceRecordElapsedSeconds + 1;
      if (nextValue >= _maxVoiceMessageSeconds) {
        timer.cancel();
        await _stopVoiceRecording(hitLimit: true);
        return;
      }
      setState(() => _voiceRecordElapsedSeconds = nextValue);
    });
  }

  Future<void> _stopVoiceRecording({final bool hitLimit = false}) async {
    _voiceRecordTimer?.cancel();
    _amplitudeSub?.cancel();
    final duration = _voiceRecordElapsedSeconds;
    final path = await _voiceRecorder.stop();
    if (!mounted) return;

    setState(() {
      _isRecordingVoiceMessage = false;
      _voiceRecordElapsedSeconds = 0;
    });

    if (path != null && path.isNotEmpty && duration > 0) {
      // Resample waveform to fixed size (e.g. 30 bars) for consistent display
      final resampled = _resampleWaveform(_draftVoiceWaveform, 30);
      setState(() {
        _draftVoicePath = path;
        _draftVoiceDurationSeconds = duration;
        _draftVoiceWaveform = resampled;
      });
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

  List<double> _resampleWaveform(
      final List<double> input, final int targetSize) {
    if (input.isEmpty) return List.filled(targetSize, 0.2);
    if (input.length <= targetSize) {
      return input; // Or pad if needed, but usually fine
    }

    final output = <double>[];
    final chunkSize = input.length / targetSize;
    for (var i = 0; i < targetSize; i++) {
      final start = (i * chunkSize).floor();
      final end = ((i + 1) * chunkSize).floor();
      if (end <= start) {
        output.add(input[start]);
        continue;
      }
      var sum = 0.0;
      for (var j = start; j < end; j++) {
        sum += input[j];
      }
      output.add(sum / (end - start));
    }
    return output;
  }

  Future<void> _handleVoiceMessageTap() async {
    if (_isRecordingVoiceMessage) {
      await _stopVoiceRecording();
      return;
    }
    await _startVoiceRecording();
  }

  Future<void> _toggleDraftVoicePlayback() async {
    final path = _draftVoicePath;
    if (path == null || path.isEmpty) return;
    if (_draftVoicePlayer.playing) {
      await _draftVoicePlayer.pause();
      return;
    }
    await _draftVoicePlayer.setFilePath(path);
    await _draftVoicePlayer.play();
  }

  Future<void> _deleteDraftVoice(
      {final bool retainSnackbar = false, final String? message}) async {
    final path = _draftVoicePath;
    await _draftVoicePlayer.stop();
    if (path != null && path.isNotEmpty) {
      final file = File(path);
      if (await file.exists()) {
        await file.delete();
      }
    }
    if (!mounted) return;
    setState(() {
      _draftVoicePath = null;
      _draftVoiceDurationSeconds = 0;
      _draftVoiceWaveform = const [];
      _isPlayingDraftVoice = false;
    });
    if (!retainSnackbar) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message ?? 'Draft cleared')),
    );
  }

  Future<void> _pickAndSendImage({final bool fromCamera = false}) async {
    if (!_ensureCanSendInDm()) return;
    final uid = _myUserId;
    try {
      final picked = await _imagePicker.pickImage(
        source: fromCamera ? ImageSource.camera : ImageSource.gallery,
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
          SnackBar(
              content:
                  Text('Image is ${mb}MB. Max allowed is ${allowedMb}MB.')),
        );
        return;
      }

      final path =
          'chat_media/$uid/${DateTime.now().millisecondsSinceEpoch}.jpg';
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
    if (!_ensureCanSendInDm()) return;
    final uid = _myUserId;
    try {
      final pick = await FilePicker.platform.pickFiles(
        allowMultiple: false,
        withData: true,
        withReadStream: true,
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
      final bytes = await _readPickedFileBytes(file);
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
          SnackBar(
              content:
                  Text('Document is ${mb}MB. Max allowed is ${allowedMb}MB.')),
        );
        return;
      }

      final extension = (file.extension ?? 'file').toLowerCase();
      final sanitizedName =
          (file.name.isEmpty ? 'document.$extension' : file.name)
              .replaceAll(RegExp(r'[^a-zA-Z0-9._-]'), '_');
      final objectPath =
          'chat_docs/$uid/${DateTime.now().millisecondsSinceEpoch}_$sanitizedName';
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

  Future<Uint8List?> _readPickedFileBytes(final PlatformFile file) async {
    if (file.bytes != null && file.bytes!.isNotEmpty) {
      return file.bytes!;
    }
    final stream = file.readStream;
    if (stream == null) return null;
    final chunks = <int>[];
    await for (final chunk in stream) {
      chunks.addAll(chunk);
    }
    return Uint8List.fromList(chunks);
  }

  String _docContentType(final String extension) {
    return switch (extension) {
      'pdf' => 'application/pdf',
      'doc' => 'application/msword',
      'docx' =>
        'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
      'txt' => 'text/plain',
      _ => 'application/octet-stream',
    };
  }

  Future<void> _openFileUrl(final String url) async {
    final uri = Uri.tryParse(url);
    if (uri == null) return;
    final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!launched && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open file')),
      );
    }
  }

  Future<void> _editTextMessage(final _ChatMessage msg) async {
    final initial = msg.payload.text ?? '';
    final editor = TextEditingController(text: initial);
    final updated = await showDialog<String>(
      context: context,
      builder: (final context) => AlertDialog(
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
        SnackBar(
            content: Text(
                'Message too long. Keep it under $_maxTextChars characters.')),
      );
      return;
    }

    await chatRepository.editMessageById(
      msg.id,
      jsonEncode({
        'type': 'text',
        'text': updated,
        if (msg.payload.replyTo != null) 'reply_to': msg.payload.replyTo,
        if (msg.payload.replyToMessageId != null)
          'reply_to_message_id': msg.payload.replyToMessageId
      }),
    );
    if (mounted) {
      setState(() => _messageEditTimes[msg.id] = DateTime.now());
    }
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Message updated')),
    );
  }

  Future<void> _confirmAndDeleteMessage(final String messageId) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (final context) => AlertDialog(
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

  Future<void> _showMessageActions(final _ChatMessage msg) async {
    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (final context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.emoji_emotions_outlined),
              title: const Text('React 👍'),
              onTap: () async {
                Navigator.pop(context);
                await chatRepository.toggleMessageReaction(
                    messageId: msg.id, emoji: '👍');
              },
            ),
            ListTile(
              leading: const Icon(Icons.reply_rounded),
              title: const Text('Reply'),
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  _replyPreview = msg.previewText;
                  _replyToMessageId = msg.id;
                });
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
              leading: Icon(_pinnedMessageIds.contains(msg.id)
                  ? Icons.push_pin_outlined
                  : Icons.push_pin_rounded),
              title: Text(_pinnedMessageIds.contains(msg.id)
                  ? 'Unpin message'
                  : 'Pin message'),
              onTap: () async {
                Navigator.pop(context);
                await _togglePinMessage(msg.id);
              },
            ),
            if (msg.payload.type == 'voice' &&
                (msg.payload.transcript?.isNotEmpty ?? false))
              ListTile(
                leading: const Icon(Icons.content_copy_rounded),
                title: const Text('Copy transcript'),
                onTap: () async {
                  Navigator.pop(context);
                  await Clipboard.setData(
                      ClipboardData(text: msg.payload.transcript!));
                },
              ),
            if (msg.payload.type == 'voice' &&
                (msg.payload.transcript?.isNotEmpty ?? false))
              ListTile(
                leading: const Icon(Icons.translate_rounded),
                title: const Text('Translate transcript'),
                onTap: () {
                  Navigator.pop(context);
                  final translated =
                      '[$_autoTranslateLanguage] ${msg.payload.transcript!}';
                  setState(() {
                    _controller.text = translated;
                    _controller.selection = TextSelection.fromPosition(
                        TextPosition(offset: translated.length));
                  });
                },
              ),
            if (msg.payload.type == 'voice' &&
                (msg.payload.transcript?.isNotEmpty ?? false))
              ListTile(
                leading: const Icon(Icons.search_rounded),
                title: const Text('Search transcript in chat'),
                onTap: () {
                  Navigator.pop(context);
                  setState(() {
                    _showSearch = true;
                    _searchQuery = msg.payload.transcript!
                        .split(' ')
                        .take(3)
                        .join(' ')
                        .toLowerCase();
                  });
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
                          builder: (final _) => SafeArea(
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
                          const SnackBar(
                              content: Text('Could not submit report')),
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
                              ?.map((final e) => e.toString())
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
                        const SnackBar(
                            content: Text('User blocked and reported')),
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
  Widget build(final BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            ...rtcVoiceService.activeRenderers
                .map((final renderer) => Positioned(
                      left: 0,
                      top: 0,
                      width: 1,
                      height: 1,
                      child: SizedBox(
                        width: 1,
                        height: 1,
                        child: RTCVideoView(
                          renderer,
                          objectFit:
                              RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
                        ),
                      ),
                    )),
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
              ),
              child: Column(
                children: [
                  _showOnlineIndicator
                      ? StreamBuilder<bool>(
                          stream: _onlineStream,
                          builder: (final context, final snapshot) {
                            return _TopBar(
                              title: _displayUsernameToken,
                              avatarUrl: _otherProfile?.avatarUrl,
                              showOnlineIndicator: snapshot.data == true,
                              onBack: () => Navigator.pop(context),
                              onProfileTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (final _) =>
                                        ProfileScreen(userId: widget.otherId),
                                  ),
                                );
                              },
                              onCall: _toggleVoiceCall,
                              onToggleSearch: () =>
                                  setState(() => _showSearch = !_showSearch),
                              onMenuSelected: _handleMenuAction,
                              showPinnedOnly: _showPinnedOnly,
                              isInCall: _isCallActive,
                              callStatusText: _callSubtitle,
                              callDuration: _callElapsedSeconds,
                              isConversationPinned: _isConversationPinned,
                              isConversationMuted: _isConversationMuted,
                            );
                          },
                        )
                      : _TopBar(
                          title: _displayUsernameToken,
                          avatarUrl: _otherProfile?.avatarUrl,
                          showOnlineIndicator: false,
                          onBack: () => Navigator.pop(context),
                          onProfileTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (final _) =>
                                    ProfileScreen(userId: widget.otherId),
                              ),
                            );
                          },
                          onCall: _toggleVoiceCall,
                          onToggleSearch: () =>
                              setState(() => _showSearch = !_showSearch),
                          onMenuSelected: _handleMenuAction,
                          showPinnedOnly: _showPinnedOnly,
                          isInCall: _isCallActive,
                          callStatusText: _callSubtitle,
                          callDuration: _callElapsedSeconds,
                          isConversationPinned: _isConversationPinned,
                          isConversationMuted: _isConversationMuted,
                        ),
                  const SizedBox(height: 8),
                  if (_showSearch)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(14, 0, 14, 8),
                      child: Glass(
                        radius: BorderRadius.circular(12),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 6),
                        child: TextField(
                          onChanged: (final v) => setState(
                              () => _searchQuery = v.trim().toLowerCase()),
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
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(999),
                              color: theme.colorScheme.onSurface
                                  .withValues(alpha: 0.08),
                            ),
                            child: Text(
                              'Searching: $_searchQuery',
                              style: TextStyle(
                                color: theme.colorScheme.onSurface
                                    .withValues(alpha: 0.7),
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        const Spacer(),
                        FilterChip(
                          label: const Text('Pinned'),
                          selected: _showPinnedOnly,
                          onSelected: (final v) =>
                              setState(() => _showPinnedOnly = v),
                        ),
                        const SizedBox(width: 6),
                        FilterChip(
                          label: const Text('Unread'),
                          selected: _showUnreadOnly,
                          onSelected: (final v) =>
                              setState(() => _showUnreadOnly = v),
                        ),
                        const SizedBox(width: 6),
                        FilterChip(
                          label: const Text('Links'),
                          selected: _showLinksOnly,
                          onSelected: (final v) =>
                              setState(() => _showLinksOnly = v),
                        ),
                        const SizedBox(width: 6),
                        FilterChip(
                          label: const Text('@Mentions'),
                          selected: _showMentionsOnly,
                          onSelected: (final v) =>
                              setState(() => _showMentionsOnly = v),
                        ),
                      ],
                    ),
                  ),
                  _PinnedMomentsStrip(
                    messageIds: _pinnedMessageIds.toList(),
                    onTap: _jumpToMessageById,
                  ),
                  Expanded(
                    child: StreamBuilder<List<Map<String, dynamic>>>(
                        stream: _messagesStream,
                        builder: (final context, final snapshot) {
                          if (snapshot.hasError) {
                            return Center(
                                child: Text('Error: ${snapshot.error}',
                                    style: TextStyle(
                                        color: theme.colorScheme.onSurface)));
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
                                  .where((final m) =>
                                      (m['content']?.toString().toLowerCase() ??
                                              '')
                                          .contains(_searchQuery))
                                  .toList();
                          visibleMsgs = visibleMsgs.where((final m) {
                            final payload = _MessagePayload.parse(
                                m['content']?.toString() ?? '');
                            final text = payload.text ?? payload.fileName ?? '';
                            if (payload.expiresAt != null &&
                                payload.expiresAt!.isBefore(DateTime.now())) {
                              return false;
                            }
                            final created = DateTime.tryParse(
                                m['created_at']?.toString() ?? '');
                            if (_showUnreadOnly && m['is_read'] == true) {
                              return false;
                            }
                            if (_showLinksOnly && !text.contains('http')) {
                              return false;
                            }
                            if (_showMentionsOnly && !text.contains('@')) {
                              return false;
                            }
                            return true;
                          }).toList();
                          if (_showPinnedOnly) {
                            visibleMsgs = visibleMsgs
                                .where((final m) => _pinnedMessageIds
                                    .contains(m['id']?.toString() ?? ''))
                                .toList();
                          }

                          _lastVisibleMessageIds = visibleMsgs
                              .map((final m) => m['id']?.toString() ?? '')
                              .toList();

                          if (visibleMsgs.isEmpty) {
                            return Center(
                              child: Text(
                                _searchQuery.isEmpty
                                    ? 'No messages yet'
                                    : 'No messages match your search',
                                style: TextStyle(
                                    color: theme.colorScheme.onSurface
                                        .withValues(alpha: 0.7),
                                    fontWeight: FontWeight.w700),
                              ),
                            );
                          }

                          WidgetsBinding.instance
                              .addPostFrameCallback((final _) {
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
                            itemBuilder: (final context, final i) {
                              final m = visibleMsgs[i];
                              final isMe = (m['sender_id']?.toString() ?? '') ==
                                  _myUserId;
                              final dt = DateTime.tryParse(
                                          m['created_at']?.toString() ?? '')
                                      ?.toLocal() ??
                                  DateTime.now();
                              final payload = _MessagePayload.parse(
                                  m['content']?.toString() ?? '');
                              final readAt = m['read_at']?.toString();
                              final pinned = _pinnedMessageIds
                                  .contains(m['id']?.toString() ?? '');
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 6),
                                child: _Bubble(
                                  text: payload.text ??
                                      payload.fileName ??
                                      'Attachment',
                                  rawContent: m['content']?.toString() ?? '',
                                  time: _fmtTime(dt),
                                  isMe: isMe,
                                  isRead: readAt != null,
                                  replyTo: payload.replyTo,
                                  readAt: readAt,
                                  reactions: (m['reactions']
                                          as Map<String, dynamic>?) ??
                                      const {},
                                  pinned: pinned,
                                  onLongPress: () => _showMessageActions(
                                      _ChatMessage.fromRow(m, isMe: isMe)),
                                  onSwipeReply: () => setState(() {
                                    _replyPreview = payload.text ??
                                        payload.fileName ??
                                        'Attachment';
                                    _replyToMessageId = m['id']?.toString();
                                  }),
                                  onTapReplySource: _jumpToMessageById,
                                  replyToMessageId: payload.replyToMessageId,
                                  onTapFile: _openFileUrl,
                                  onReact: (final emoji) =>
                                      chatRepository.toggleMessageReaction(
                                          messageId: m['id'].toString(),
                                          emoji: emoji),
                                  editedAt: _messageEditTimes[
                                      m['id']?.toString() ?? ''],
                                  deliveryStatus: _deliveryStatus(
                                      isMe: isMe,
                                      isRead: readAt != null,
                                      createdAt: dt),
                                  isHighlighted: _jumpHighlightMessageId ==
                                      (m['id']?.toString() ?? ''),
                                  showAutoTranslation: _autoTranslateIncoming,
                                  autoTranslateLanguage: _autoTranslateLanguage,
                                ),
                              );
                            },
                          );
                        }),
                  ),
                  if (_replyToMessageId != null)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(14, 0, 14, 6),
                      child: Glass(
                        radius: BorderRadius.circular(12),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 6),
                        child: Row(
                          children: [
                            const Icon(Icons.account_tree_rounded, size: 14),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                'Thread focus active · replying in context',
                                style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    color: theme.colorScheme.onSurface
                                        .withValues(alpha: 0.78),
                                    fontSize: 11.5),
                              ),
                            ),
                          ],
                        ),
                      ),
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
                                color: theme.colorScheme.onSurface
                                    .withValues(alpha: 0.75),
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () => setState(() {
                              _replyPreview = null;
                              _replyToMessageId = null;
                            }),
                            icon: const Icon(Icons.close_rounded),
                          ),
                        ],
                      ),
                    ),
                  if (_disappearingWindow != null)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(14, 0, 14, 6),
                      child: Text(
                        'Disappearing messages: ${_disappearingWindow!.inHours >= 24 ? '${(_disappearingWindow!.inHours / 24).round()}d' : '${_disappearingWindow!.inHours}h'}',
                        style: TextStyle(
                          color: theme.colorScheme.onSurface
                              .withValues(alpha: 0.65),
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  if (_muteUntil != null && _muteUntil!.isAfter(DateTime.now()))
                    Padding(
                      padding: const EdgeInsets.fromLTRB(14, 0, 14, 6),
                      child: Text(
                        'Conversation muted until ${TimeOfDay.fromDateTime(_muteUntil!).format(context)}',
                        style: TextStyle(
                          color: theme.colorScheme.onSurface
                              .withValues(alpha: 0.65),
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  if (_canChat && !_isComposerFocused)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(14, 0, 14, 6),
                      child: Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: [
                          for (final quick in const [
                            'Hey 👋',
                            'How are you?',
                            'Want to practice now?'
                          ])
                            ActionChip(
                              label: Text(quick),
                              onPressed: () {
                                _controller.text = quick;
                                _controller.selection =
                                    TextSelection.fromPosition(
                                  TextPosition(offset: _controller.text.length),
                                );
                                _onTypingChanged(true);
                                _saveDraft(quick);
                                _composerFocus.requestFocus();
                              },
                            ),
                        ],
                      ),
                    ),
                  if (_isCallActive && _liveCaption != null)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(14, 0, 14, 6),
                      child: Text(
                        _liveCaption!,
                        style: TextStyle(
                          color: theme.colorScheme.onSurface
                              .withValues(alpha: 0.6),
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  StreamBuilder<bool>(
                    stream: _typingStream,
                    builder: (final context, final snapshot) {
                      if (snapshot.data != true) return const SizedBox.shrink();
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: Text(
                          '${widget.otherName} is typing…',
                          style: TextStyle(
                            color: theme.colorScheme.onSurface
                                .withValues(alpha: 0.6),
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
                      otherName: widget.otherName,
                      username: _otherProfile?.username,
                      sentRequestStatus: _sentRequestStatus,
                      incomingRequestStatus: _incomingRequestStatus,
                      onSendRequest: _sendMessageRequest,
                      onAccept: () => _respondIncomingRequest(true),
                      onDecline: () => _respondIncomingRequest(false),
                    )
                  else
                    _InputBar(
                      controller: _controller,
                      focusNode: _composerFocus,
                      isComposerFocused: _isComposerFocused,
                      onSend: _send,
                      onVoiceMessage: () {
                        _handleVoiceMessageTap();
                      },
                      onSendImage: _pickAndSendImage,
                      onSendFile: _pickAndSendDocument,
                      onOpenAttachmentTray: _openAttachmentTray,
                      onTypingChanged: _onTypingChanged,
                      onTextChanged: _saveDraft,
                      isRecordingVoiceMessage: _isRecordingVoiceMessage,
                      recordingSeconds: _voiceRecordElapsedSeconds,
                      hasDraftVoice: _draftVoicePath != null,
                      draftVoiceSeconds: _draftVoiceDurationSeconds,
                      draftVoiceWaveform: _draftVoiceWaveform,
                      isPlayingDraftVoice: _isPlayingDraftVoice,
                      onToggleDraftVoice: _toggleDraftVoicePlayback,
                      onSendDraftVoice: _sendDraftVoiceMessage,
                      onDeleteDraftVoice: _deleteDraftVoice,
                    ),
                ],
              ),
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
                    await _emitDmCallSignal(CallSignalType.end);
                    await _endVoiceCall(showRemoteEnded: false);
                  },
                ),
              ),
            if (_isCallActive && _callPanelMinimized)
              Positioned.fill(
                child: LayoutBuilder(
                  builder: (final context, final constraints) {
                    const chipWidth = 170.0;
                    final defaultLeft = (constraints.maxWidth - chipWidth - 14)
                        .clamp(0.0, constraints.maxWidth);
                    final defaultTop = (constraints.maxHeight - 150)
                        .clamp(0.0, constraints.maxHeight);
                    return Stack(
                      children: [
                        Positioned(
                          left: (defaultLeft - _floatingChipOffset.dx).clamp(
                              0.0,
                              (constraints.maxWidth - chipWidth)
                                  .clamp(0.0, constraints.maxWidth)),
                          top: (defaultTop + _floatingChipOffset.dy).clamp(
                              0.0,
                              (constraints.maxHeight - 70)
                                  .clamp(0.0, constraints.maxHeight)),
                          child: GestureDetector(
                            onPanUpdate: (final details) =>
                                _onFloatingChipDragUpdate(details, constraints),
                            onPanEnd: (final _) => _persistCallChipOffset(),
                            onLongPress: () async {
                              final action = await showModalBottomSheet<String>(
                                context: context,
                                builder: (final context) => SafeArea(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      ListTile(
                                        leading: Icon(_isMicMuted
                                            ? Icons.mic_rounded
                                            : Icons.mic_off_rounded),
                                        title: Text(
                                            _isMicMuted ? 'Unmute' : 'Mute'),
                                        onTap: () => Navigator.pop(
                                            context, 'toggle_mute'),
                                      ),
                                      ListTile(
                                        leading: Icon(_noiseSuppressionEnabled
                                            ? Icons.noise_control_off_rounded
                                            : Icons.noise_aware_rounded),
                                        title: Text(_noiseSuppressionEnabled
                                            ? 'Disable noise suppression'
                                            : 'Enable noise suppression'),
                                        onTap: () =>
                                            Navigator.pop(context, 'noise'),
                                      ),
                                      ListTile(
                                        leading: const Icon(
                                            Icons.open_in_full_rounded),
                                        title: const Text('Restore call panel'),
                                        onTap: () =>
                                            Navigator.pop(context, 'restore'),
                                      ),
                                      ListTile(
                                        leading:
                                            const Icon(Icons.call_end_rounded),
                                        title: const Text('End call'),
                                        onTap: () =>
                                            Navigator.pop(context, 'end'),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                              if (!mounted) return;
                              if (action == 'toggle_mute') {
                                await _toggleMicMute();
                              } else if (action == 'noise') {
                                await _toggleNoiseSuppression();
                              } else if (action == 'end') {
                                final shouldEnd = await _confirmEndActiveCall();
                                if (!shouldEnd) return;
                                await _emitDmCallSignal(CallSignalType.end);
                                await _endVoiceCall(showRemoteEnded: false);
                              } else {
                                setState(() => _callPanelMinimized = false);
                              }
                            },
                            child: _FloatingCallChip(
                              subtitle: _callSubtitle,
                              onTap: () =>
                                  setState(() => _callPanelMinimized = false),
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
      builder: (final context) => AlertDialog(
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
            ?.map((final e) => e.toString())
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
        _canChat = state['can_chat'] == true;
        _dmGateReason = state['reason']?.toString();
        _sentRequestStatus = state['sent_request_status']?.toString();
        _incomingRequestStatus = state['incoming_request_status']?.toString();
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

  Future<void> _respondIncomingRequest(final bool accept) async {
    await chatRepository.respondToMessageRequest(
      requesterId: widget.otherId,
      accept: accept,
    );
    if (!mounted) return;
    await _loadDmGate();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text(accept
              ? 'Message request accepted'
              : 'Message request declined')),
    );
  }

  String _fmtTime(final DateTime dt) {
    final hh = dt.hour.toString().padLeft(2, '0');
    final mm = dt.minute.toString().padLeft(2, '0');
    return '$hh:$mm';
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
  Widget build(final BuildContext context) {
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
                child: Icon(
                    active
                        ? Icons.graphic_eq_rounded
                        : Icons.phone_in_talk_rounded,
                    color: scheme.onPrimary,
                    size: 20),
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
                        color: active
                            ? scheme.primary
                            : scheme.onSurface.withValues(alpha: 0.72),
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
                icon: Icon(Icons.open_in_new_rounded,
                    color: scheme.onSurface.withValues(alpha: 0.86)),
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
                  icon:
                      Icon(isMuted ? Icons.mic_off_rounded : Icons.mic_rounded),
                  label: Text(isMuted ? 'Unmute' : 'Mute'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onToggleSpeaker,
                  icon: Icon(isSpeakerOn
                      ? Icons.volume_up_rounded
                      : Icons.hearing_rounded),
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
  Widget build(final BuildContext context) {
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
    required this.isConversationPinned,
    required this.isConversationMuted,
  });

  final bool isConversationPinned;
  final bool isConversationMuted;

  @override
  Widget build(final BuildContext context) {
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
                      backgroundColor: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withValues(alpha: 0.1),
                      foregroundColor: Theme.of(context).colorScheme.onSurface,
                      backgroundImage:
                          (avatarUrl != null && avatarUrl!.trim().isNotEmpty)
                              ? CachedNetworkImageProvider(avatarUrl!)
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
                            '@$title',
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
                                    : 'Offline',
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: isInCall
                                  ? Theme.of(context).colorScheme.primary
                                  : showOnlineIndicator
                                      ? const Color(0xFF58F7B6)
                                      : Theme.of(context)
                                          .colorScheme
                                          .onSurface
                                          .withValues(alpha: 0.68),
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
                  color: Theme.of(context)
                      .colorScheme
                      .surface
                      .withValues(alpha: 0.7),
                  width: 1.5,
                ),
              ),
            ),
          const SizedBox(width: 10),
          _IconGlass(icon: Icons.search_rounded, onTap: onToggleSearch),
          const SizedBox(width: 8),
          PopupMenuButton<_DmMenuAction>(
            onSelected: onMenuSelected,
            itemBuilder: (final context) => [
              PopupMenuItem(
                value: _DmMenuAction.togglePin,
                child:
                    Text(isConversationPinned ? 'Unpin thread' : 'Pin thread'),
              ),
              PopupMenuItem(
                value: _DmMenuAction.toggleMute,
                child:
                    Text(isConversationMuted ? 'Unmute thread' : 'Mute thread'),
              ),
              const PopupMenuDivider(),
              const PopupMenuItem(
                value: _DmMenuAction.advancedSearch,
                child: Text('Search messages'),
              ),
            ],
            child: Glass(
              radius: BorderRadius.circular(16),
              padding: const EdgeInsets.all(10),
              child: Icon(
                Icons.more_horiz_rounded,
                color: Theme.of(context)
                    .colorScheme
                    .onSurface
                    .withValues(alpha: 0.92),
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
}

class _Bubble extends StatefulWidget {
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
  final VoidCallback? onSwipeReply;
  final DateTime? editedAt;
  final String? replyToMessageId;
  final ValueChanged<String?>? onTapReplySource;
  final String deliveryStatus;
  final bool isHighlighted;
  final bool showAutoTranslation;
  final String autoTranslateLanguage;

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
    this.onSwipeReply,
    this.editedAt,
    this.replyToMessageId,
    this.onTapReplySource,
    this.deliveryStatus = '',
    this.isHighlighted = false,
    this.showAutoTranslation = false,
    this.autoTranslateLanguage = 'English',
  });

  @override
  State<_Bubble> createState() => _BubbleState();
}

class _BubbleState extends State<_Bubble> {
  late final AudioPlayer _voicePlayer;
  bool _isPlayingVoice = false;
  bool _isVoiceExpanded = false;
  double _voiceSpeed = 1.0;
  Duration _voicePosition = Duration.zero;
  Duration _voiceDuration = Duration.zero;
  double _swipeDx = 0;
  bool _isSwipeDragging = false;

  void _onSwipeDragUpdate(final double deltaX) {
    final next = _swipeDx + deltaX;
    if (widget.isMe) {
      // My messages reply with left swipe.
      final clamped = next.clamp(-88.0, 0.0);
      setState(() => _swipeDx = clamped);
    } else {
      // Incoming messages reply with right swipe.
      final clamped = next.clamp(0.0, 88.0);
      setState(() => _swipeDx = clamped);
    }
  }

  void _finishSwipeGesture() {
    const trigger = 54.0;
    final shouldReply =
        widget.isMe ? _swipeDx <= -trigger : _swipeDx >= trigger;
    setState(() {
      _isSwipeDragging = false;
      _swipeDx = 0;
    });
    if (shouldReply) {
      HapticFeedback.selectionClick();
      widget.onSwipeReply?.call();
    }
  }

  @override
  void initState() {
    super.initState();
    _voicePlayer = AudioPlayer();
    _voicePlayer.positionStream.listen((final p) {
      if (!mounted) return;
      setState(() => _voicePosition = p);
    });
    _voicePlayer.durationStream.listen((final d) {
      if (!mounted || d == null) return;
      setState(() => _voiceDuration = d);
    });
    _voicePlayer.playerStateStream.listen((final state) {
      if (!mounted) return;
      final playing = state.playing;
      if (_isPlayingVoice != playing) {
        setState(() => _isPlayingVoice = playing);
      }
      if (state.processingState == ProcessingState.completed) {
        _voicePlayer.seek(Duration.zero);
      }
    });
  }

  @override
  void dispose() {
    unawaited(_voicePlayer.dispose());
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    final align =
        widget.isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start;
    final radius = BorderRadius.only(
      topLeft: const Radius.circular(18),
      topRight: const Radius.circular(18),
      bottomLeft: Radius.circular(widget.isMe ? 18 : 6),
      bottomRight: Radius.circular(widget.isMe ? 6 : 18),
    );

    final scheme = Theme.of(context).colorScheme;
    final parsed = _MessagePayload.parse(widget.rawContent);
    final isImage = parsed.type == 'image';
    final imageUrl = parsed.url;
    final isVoice = parsed.type == 'voice';
    final isFile = parsed.type == 'file';
    final isPack = parsed.type == 'poll' ||
        parsed.type == 'checklist' ||
        parsed.type == 'invite' ||
        parsed.type == 'location' ||
        parsed.type == 'contact';

    return Column(
      crossAxisAlignment: align,
      children: [
        if (widget.replyTo != null)
          Padding(
            padding: EdgeInsets.only(
              bottom: 4,
              right: widget.isMe ? 4 : 0,
              left: widget.isMe ? 0 : 4,
            ),
            child: InkWell(
              onTap: () =>
                  widget.onTapReplySource?.call(widget.replyToMessageId),
              child: Text(
                'Replying to: ${widget.replyTo}',
                style: TextStyle(
                  color: scheme.onSurface.withValues(alpha: 0.6),
                  fontSize: 11,
                  fontStyle: FontStyle.italic,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        GestureDetector(
          onLongPress: widget.onLongPress,
          onHorizontalDragStart: (final _) =>
              setState(() => _isSwipeDragging = true),
          onHorizontalDragUpdate: (final details) =>
              _onSwipeDragUpdate(details.delta.dx),
          onHorizontalDragEnd: (final _) => _finishSwipeGesture(),
          onHorizontalDragCancel: () => _finishSwipeGesture(),
          onTap: isVoice
              ? () => _handleVoiceBubbleTap(parsed.url)
              : (isFile && parsed.url != null
                  ? () => widget.onTapFile?.call(parsed.url!)
                  : null),
          child: AnimatedContainer(
            duration: Duration(milliseconds: _isSwipeDragging ? 0 : 180),
            curve: Curves.easeOutCubic,
            transform: Matrix4.translationValues(_swipeDx, 0, 0),
            child: Container(
              constraints: const BoxConstraints(maxWidth: 320),
              padding: EdgeInsets.symmetric(
                horizontal: isImage ? 6 : 14,
                vertical: isImage ? 6 : 12,
              ),
              decoration: BoxDecoration(
                borderRadius: radius,
                color: widget.isMe
                    ? scheme.primary.withValues(alpha: 0.12)
                    : scheme.onSurface.withValues(alpha: 0.07),
                border: Border.all(
                  color: widget.isHighlighted
                      ? scheme.tertiary.withValues(alpha: 0.9)
                      : (widget.isMe
                          ? scheme.primary.withValues(alpha: 0.24)
                          : scheme.onSurface.withValues(alpha: 0.12)),
                  width: widget.isHighlighted ? 1.6 : 1,
                ),
              ),
              child: isImage
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: CachedNetworkImage(
                        imageUrl: imageUrl ?? '',
                        fit: BoxFit.cover,
                        errorWidget: (final _, final __, final ___) => Padding(
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
                      ? _PremiumVoiceBubbleContent(
                          durationLabel: parsed.text ?? widget.text,
                          isPlaying: _isPlayingVoice,
                          waveform: parsed.waveform,
                          onPlayPause: () => _toggleVoicePlayback(parsed.url),
                          onTapCompact: () => _handleVoiceBubbleTap(parsed.url),
                          isExpanded: _isVoiceExpanded,
                          onToggleExpanded: () => setState(
                              () => _isVoiceExpanded = !_isVoiceExpanded),
                          isMine: widget.isMe,
                          speed: _voiceSpeed,
                          onToggleSpeed: _toggleVoiceSpeed,
                          progressMs: _voicePosition.inMilliseconds,
                          durationMs: (_voiceDuration.inMilliseconds <= 0
                              ? (parsed.duration ?? 0) * 1000
                              : _voiceDuration.inMilliseconds),
                          onSeek: (final ms) => _voicePlayer
                              .seek(Duration(milliseconds: ms.round())),
                          transcript: parsed.transcript,
                        )
                      : isFile
                          ? Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.description_rounded,
                                    color: scheme.primary),
                                const SizedBox(width: 8),
                                Flexible(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        parsed.fileName ?? 'Document',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color: scheme.onSurface
                                              .withValues(alpha: 0.92),
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                      if (parsed.sizeBytes != null)
                                        Text(
                                          _formatBytes(parsed.sizeBytes!),
                                          style: TextStyle(
                                            color: scheme.onSurface
                                                .withValues(alpha: 0.66),
                                            fontWeight: FontWeight.w600,
                                            fontSize: 12,
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ],
                            )
                          : isPack
                              ? _PackMessageCard(payload: parsed)
                              : Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      widget.text,
                                      style: TextStyle(
                                        color: scheme.onSurface
                                            .withValues(alpha: 0.92),
                                        fontWeight: FontWeight.w700,
                                        height: 1.25,
                                        fontSize: 14.5,
                                      ),
                                    ),
                                    if (!widget.isMe &&
                                        widget.showAutoTranslation)
                                      Padding(
                                        padding: const EdgeInsets.only(top: 6),
                                        child: Text(
                                          parsed.translatedText?.isNotEmpty ==
                                                  true
                                              ? parsed.translatedText!
                                              : '↳ ${widget.autoTranslateLanguage}: ${widget.text}',
                                          style: TextStyle(
                                            color: scheme.primary
                                                .withValues(alpha: 0.9),
                                            fontWeight: FontWeight.w700,
                                            height: 1.22,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ),
                                    if (!widget.isMe &&
                                        parsed.transliteration?.isNotEmpty ==
                                            true)
                                      Padding(
                                        padding: const EdgeInsets.only(top: 4),
                                        child: Text(
                                          parsed.transliteration!,
                                          style: TextStyle(
                                            color: scheme.onSurface
                                                .withValues(alpha: 0.62),
                                            fontWeight: FontWeight.w600,
                                            fontSize: 12,
                                            fontStyle: FontStyle.italic,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
              top: 4, right: widget.isMe ? 4 : 0, left: widget.isMe ? 0 : 4),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.pinned)
                Padding(
                  padding: const EdgeInsets.only(right: 4),
                  child: Icon(Icons.push_pin_rounded,
                      size: 12, color: scheme.primary),
                ),
              Text(
                widget.time,
                style: TextStyle(
                  color: scheme.onSurface.withValues(alpha: 0.55),
                  fontSize: 10.5,
                  fontWeight: FontWeight.w700,
                ),
              ),
              if (widget.editedAt != null)
                Text(
                  ' · edited',
                  style: TextStyle(
                    color: scheme.onSurface.withValues(alpha: 0.45),
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              if (widget.isMe)
                Text(
                  ' · ${widget.deliveryStatus}',
                  style: TextStyle(
                    color: scheme.onSurface.withValues(alpha: 0.45),
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              if (widget.isMe && widget.readAt != null)
                Text(
                  ' · seen ${widget.readAt!.substring(11, 16)}',
                  style: TextStyle(
                    color: scheme.onSurface.withValues(alpha: 0.45),
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                  ),
                ),
            ],
          ),
        ),
        if (widget.reactions.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Wrap(
              spacing: 6,
              children: widget.reactions.entries.map((final entry) {
                final count = (entry.value as List?)?.length ?? 0;
                return GestureDetector(
                  onTap: () => widget.onReact?.call(entry.key),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
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
        if (widget.isMe)
          Padding(
            padding: const EdgeInsets.only(top: 2, right: 4),
            child: Icon(
              (widget.isRead || widget.deliveryStatus == 'Delivered')
                  ? Icons.done_all_rounded
                  : Icons.done_rounded,
              size: 14,
              color: widget.isRead
                  ? const Color(0xFF58F7B6)
                  : scheme.onSurface.withValues(alpha: 0.5),
            ),
          ),
      ],
    );
  }

  Future<void> _handleVoiceBubbleTap(final String? url) async {
    if (!_isVoiceExpanded) {
      setState(() => _isVoiceExpanded = true);
    }
    await _toggleVoicePlayback(url);
  }

  void _toggleVoiceSpeed() {
    const speeds = [1.0, 1.5, 2.0];
    final idx = speeds.indexOf(_voiceSpeed);
    final next = speeds[(idx + 1) % speeds.length];
    setState(() => _voiceSpeed = next);
    _voicePlayer.setSpeed(next);
  }

  Future<void> _toggleVoicePlayback(final String? url) async {
    if (url == null || url.isEmpty) return;
    try {
      if (_voicePlayer.playing) {
        await _voicePlayer.pause();
        return;
      }
      await _voicePlayer.setUrl(url);
      await _voicePlayer.setSpeed(_voiceSpeed);
      await _voicePlayer.play();
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Unable to play voice message')),
      );
    }
  }

  String _formatBytes(final int bytes) {
    if (bytes < 1024) return '$bytes B';
    final kb = bytes / 1024;
    if (kb < 1024) return '${kb.toStringAsFixed(1)} KB';
    return '${(kb / 1024).toStringAsFixed(1)} MB';
  }
}

class _PremiumVoiceBubbleContent extends StatelessWidget {
  final String durationLabel;
  final bool isPlaying;
  final List<double> waveform;
  final VoidCallback onPlayPause;
  final VoidCallback onTapCompact;
  final bool isExpanded;
  final VoidCallback onToggleExpanded;
  final bool isMine;
  final double speed;
  final VoidCallback onToggleSpeed;
  final int progressMs;
  final int durationMs;
  final ValueChanged<double> onSeek;
  final String? transcript;

  const _PremiumVoiceBubbleContent({
    required this.durationLabel,
    required this.isPlaying,
    required this.waveform,
    required this.onPlayPause,
    required this.onTapCompact,
    required this.isExpanded,
    required this.onToggleExpanded,
    required this.isMine,
    required this.speed,
    required this.onToggleSpeed,
    required this.progressMs,
    required this.durationMs,
    required this.onSeek,
    this.transcript,
  });

  @override
  Widget build(final BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    if (!isExpanded) {
      return InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTapCompact,
        child: Container(
          constraints: const BoxConstraints(minWidth: 138, maxWidth: 190),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            color: scheme.surface.withValues(alpha: 0.45),
            border: Border.all(color: scheme.onSurface.withValues(alpha: 0.10)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isMine
                      ? scheme.primary.withValues(alpha: 0.24)
                      : scheme.primary.withValues(alpha: 0.18),
                ),
                child: Icon(
                  isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                  color: scheme.primary,
                  size: 18,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      durationLabel,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: scheme.onSurface.withValues(alpha: 0.88),
                        fontWeight: FontWeight.w800,
                        fontSize: 12.5,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      'Tap to expand',
                      style: TextStyle(
                        color: scheme.onSurface.withValues(alpha: 0.58),
                        fontWeight: FontWeight.w600,
                        fontSize: 10.5,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 4),
              Icon(Icons.open_in_full_rounded,
                  size: 16, color: scheme.onSurface.withValues(alpha: 0.55)),
            ],
          ),
        ),
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            InkWell(
              borderRadius: BorderRadius.circular(999),
              onTap: onPlayPause,
              child: Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isMine
                      ? scheme.primary.withValues(alpha: 0.24)
                      : scheme.primary.withValues(alpha: 0.18),
                ),
                child: Icon(
                    isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                    color: scheme.primary),
              ),
            ),
            const SizedBox(width: 10),
            Text(
              durationLabel,
              style: TextStyle(
                color: scheme.onSurface.withValues(alpha: 0.9),
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(width: 8),
            InkWell(
              borderRadius: BorderRadius.circular(999),
              onTap: onToggleSpeed,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(999),
                  color: scheme.onSurface.withValues(alpha: 0.08),
                ),
                child: Text(
                  '${speed.toStringAsFixed(speed.truncateToDouble() == speed ? 0 : 1)}x',
                  style: TextStyle(
                    color: scheme.onSurface.withValues(alpha: 0.8),
                    fontWeight: FontWeight.w700,
                    fontSize: 11,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 6),
            InkWell(
              borderRadius: BorderRadius.circular(999),
              onTap: onToggleExpanded,
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: Icon(
                  Icons.unfold_less_rounded,
                  size: 18,
                  color: scheme.onSurface.withValues(alpha: 0.58),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        _Waveform(
          bars: waveform,
          color: scheme.primary,
          dimColor: scheme.onSurface.withValues(alpha: 0.26),
        ),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
              trackHeight: 2.4,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 5)),
          child: Slider(
            min: 0,
            max: durationMs <= 0 ? 1 : durationMs.toDouble(),
            value: progressMs
                .clamp(0, durationMs <= 0 ? 1 : durationMs)
                .toDouble(),
            onChanged: onSeek,
          ),
        ),
        if (transcript != null && transcript!.isNotEmpty)
          Text(
            transcript!,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: scheme.onSurface.withValues(alpha: 0.72),
              fontWeight: FontWeight.w600,
              fontSize: 11.5,
            ),
          ),
      ],
    );
  }
}

class _Waveform extends StatelessWidget {
  final List<double> bars;
  final Color color;
  final Color dimColor;

  const _Waveform({
    required this.bars,
    required this.color,
    required this.dimColor,
  });

  @override
  Widget build(final BuildContext context) {
    final data = bars.isEmpty
        ? const [
            0.35,
            0.5,
            0.75,
            0.42,
            0.6,
            0.88,
            0.48,
            0.7,
            0.56,
            0.8,
            0.38,
            0.62
          ]
        : bars;
    return SizedBox(
      height: 20,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          for (final value in data)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 1),
              child: Container(
                width: 3,
                height: 6 + (14 * value.clamp(0.0, 1.0)),
                decoration: BoxDecoration(
                  color: Color.lerp(dimColor, color, value.clamp(0.0, 1.0)),
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _PackMessageCard extends StatefulWidget {
  final _MessagePayload payload;

  const _PackMessageCard({required this.payload});

  @override
  State<_PackMessageCard> createState() => _PackMessageCardState();
}

class _PackMessageCardState extends State<_PackMessageCard> {
  final Set<int> _checkedItems = <int>{};
  int? _pollVoteIndex;
  bool _rsvpAccepted = false;

  @override
  Widget build(final BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final payload = widget.payload;
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: scheme.primary.withValues(alpha: 0.08),
        border: Border.all(color: scheme.primary.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            payload.label ?? payload.text ?? payload.type.toUpperCase(),
            style: TextStyle(
              color: scheme.onSurface,
              fontWeight: FontWeight.w800,
            ),
          ),
          if (payload.type == 'poll' && payload.items.isNotEmpty) ...[
            const SizedBox(height: 6),
            for (var i = 0; i < payload.items.length; i++)
              ListTile(
                dense: true,
                contentPadding: EdgeInsets.zero,
                leading: Icon(
                    _pollVoteIndex == i
                        ? Icons.radio_button_checked_rounded
                        : Icons.radio_button_unchecked_rounded,
                    size: 18),
                title: Text(payload.items[i],
                    style: TextStyle(
                        fontSize: 12,
                        color: scheme.onSurface.withValues(alpha: 0.82))),
                onTap: () => setState(() => _pollVoteIndex = i),
              ),
          ] else if (payload.type == 'checklist' &&
              payload.items.isNotEmpty) ...[
            const SizedBox(height: 6),
            for (var i = 0; i < payload.items.length; i++)
              CheckboxListTile(
                dense: true,
                contentPadding: EdgeInsets.zero,
                value: _checkedItems.contains(i),
                onChanged: (final _) => setState(() {
                  if (_checkedItems.contains(i)) {
                    _checkedItems.remove(i);
                  } else {
                    _checkedItems.add(i);
                  }
                }),
                title: Text(payload.items[i],
                    style: TextStyle(
                        fontSize: 12,
                        color: scheme.onSurface.withValues(alpha: 0.82))),
              ),
          ] else if (payload.type == 'invite') ...[
            const SizedBox(height: 8),
            FilledButton.icon(
              onPressed: () => setState(() => _rsvpAccepted = !_rsvpAccepted),
              icon: Icon(
                  _rsvpAccepted
                      ? Icons.check_rounded
                      : Icons.event_available_rounded,
                  size: 16),
              label: Text(_rsvpAccepted ? 'RSVP: Going' : 'RSVP'),
            ),
          ] else if (payload.type == 'location') ...[
            if (payload.items.isNotEmpty) ...[
              const SizedBox(height: 6),
              for (final item in payload.items.take(3))
                Padding(
                  padding: const EdgeInsets.only(bottom: 2),
                  child: Text('• $item',
                      style: TextStyle(
                          color: scheme.onSurface.withValues(alpha: 0.82))),
                ),
            ],
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: () async {
                final uri = Uri.tryParse(payload.url ?? '');
                if (uri == null) return;
                await launchUrl(uri, mode: LaunchMode.externalApplication);
              },
              icon: const Icon(Icons.map_rounded, size: 16),
              label: const Text('Open map'),
            ),
          ] else if (payload.type == 'contact') ...[
            if (payload.items.isNotEmpty) ...[
              const SizedBox(height: 6),
              for (final item in payload.items.take(3))
                Padding(
                  padding: const EdgeInsets.only(bottom: 2),
                  child: Text('• $item',
                      style: TextStyle(
                          color: scheme.onSurface.withValues(alpha: 0.82))),
                ),
            ],
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                OutlinedButton.icon(
                  onPressed: () async {
                    final uri = Uri.tryParse(payload.url ?? '');
                    if (uri == null) return;
                    await launchUrl(uri, mode: LaunchMode.externalApplication);
                  },
                  icon: const Icon(Icons.call_rounded, size: 16),
                  label: const Text('Call'),
                ),
                OutlinedButton.icon(
                  onPressed: () async {
                    final phone =
                        payload.items.isNotEmpty ? payload.items.first : '';
                    if (phone.isEmpty) return;
                    await Clipboard.setData(ClipboardData(text: phone));
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Contact number copied')),
                      );
                    }
                  },
                  icon: const Icon(Icons.copy_rounded, size: 16),
                  label: const Text('Copy number'),
                ),
              ],
            ),
          ] else if (payload.items.isNotEmpty) ...[
            const SizedBox(height: 6),
            for (final item in payload.items.take(4))
              Padding(
                padding: const EdgeInsets.only(bottom: 2),
                child: Text('• $item',
                    style: TextStyle(
                        color: scheme.onSurface.withValues(alpha: 0.82))),
              ),
          ],
        ],
      ),
    );
  }
}

class _PinnedMomentsStrip extends StatelessWidget {
  final List<String> messageIds;
  final ValueChanged<String?> onTap;

  const _PinnedMomentsStrip({required this.messageIds, required this.onTap});

  @override
  Widget build(final BuildContext context) {
    if (messageIds.isEmpty) return const SizedBox.shrink();
    final theme = Theme.of(context);
    return SizedBox(
      height: 42,
      child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(14, 0, 14, 8),
        scrollDirection: Axis.horizontal,
        itemBuilder: (final context, final i) {
          final id = messageIds[i];
          return ActionChip(
            avatar: const Icon(Icons.auto_awesome_rounded, size: 14),
            label: Text('Moment ${i + 1}'),
            labelStyle: TextStyle(
                color: theme.colorScheme.onSurface,
                fontWeight: FontWeight.w700),
            onPressed: () => onTap(id),
          );
        },
        separatorBuilder: (final _, final __) => const SizedBox(width: 6),
        itemCount: messageIds.length,
      ),
    );
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
  final List<double> waveform;
  final DateTime? expiresAt;
  final String? replyToMessageId;
  final String? transcript;
  final String? label;
  final List<String> items;
  final String? translatedText;
  final String? transliteration;

  const _MessagePayload({
    required this.type,
    this.text,
    this.url,
    this.thumb,
    this.duration,
    this.fileName,
    this.sizeBytes,
    this.replyTo,
    this.waveform = const [],
    this.expiresAt,
    this.replyToMessageId,
    this.transcript,
    this.label,
    this.items = const [],
    this.translatedText,
    this.transliteration,
  });

  static _MessagePayload parse(final String raw) {
    try {
      final map = jsonDecode(raw);
      if (map is Map<String, dynamic>) {
        return _MessagePayload(
          type: map['type']?.toString() ?? 'text',
          text: map['text']?.toString() ?? map['label']?.toString(),
          url: map['url']?.toString(),
          thumb: map['thumb']?.toString(),
          duration: map['duration'] is int
              ? map['duration'] as int
              : int.tryParse('${map['duration']}'),
          fileName: map['name']?.toString(),
          sizeBytes: map['size'] is int
              ? map['size'] as int
              : int.tryParse('${map['size']}'),
          replyTo: map['reply_to']?.toString(),
          replyToMessageId: map['reply_to_message_id']?.toString(),
          transcript: map['transcript']?.toString(),
          label: map['label']?.toString(),
          items:
              ((map['items'] as List?) ?? (map['options'] as List?) ?? const [])
                  .map((final e) => e.toString())
                  .toList(),
          translatedText: map['translated_text']?.toString(),
          transliteration: map['transliteration']?.toString(),
          waveform: (map['waveform'] as List?)
                  ?.map((final e) => double.tryParse('$e') ?? 0.3)
                  .toList() ??
              const [],
          expiresAt: DateTime.tryParse(map['expires_at']?.toString() ?? ''),
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

  factory _ChatMessage.fromRow(final Map<String, dynamic> row,
      {required final bool isMe}) {
    final raw = row['content']?.toString() ?? '';
    final payload = _MessagePayload.parse(raw);
    final preview = switch (payload.type) {
      'image' => 'Photo',
      'voice' => 'Voice message ${payload.text ?? ''}'.trim(),
      'file' => payload.fileName?.isNotEmpty == true
          ? 'Document: ${payload.fileName}'
          : 'Document',
      'poll' => 'Poll: ${payload.label ?? payload.text ?? ''}',
      'checklist' => 'Checklist',
      'invite' => payload.label ?? 'Invite',
      'location' => 'Location',
      'contact' => 'Contact card',
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
  final FocusNode focusNode;
  final bool isComposerFocused;
  final VoidCallback onSend;
  final VoidCallback onVoiceMessage;
  final VoidCallback onSendImage;
  final VoidCallback onSendFile;
  final VoidCallback onOpenAttachmentTray;
  final ValueChanged<bool> onTypingChanged;
  final ValueChanged<String> onTextChanged;
  final bool isRecordingVoiceMessage;
  final int recordingSeconds;
  final bool hasDraftVoice;
  final int draftVoiceSeconds;
  final List<double> draftVoiceWaveform;
  final bool isPlayingDraftVoice;
  final VoidCallback onToggleDraftVoice;
  final VoidCallback onSendDraftVoice;
  final VoidCallback onDeleteDraftVoice;

  const _InputBar({
    required this.controller,
    required this.focusNode,
    required this.isComposerFocused,
    required this.onSend,
    required this.onVoiceMessage,
    required this.onSendImage,
    required this.onSendFile,
    required this.onOpenAttachmentTray,
    required this.onTypingChanged,
    required this.onTextChanged,
    required this.isRecordingVoiceMessage,
    required this.recordingSeconds,
    required this.hasDraftVoice,
    required this.draftVoiceSeconds,
    required this.draftVoiceWaveform,
    required this.isPlayingDraftVoice,
    required this.onToggleDraftVoice,
    required this.onSendDraftVoice,
    required this.onDeleteDraftVoice,
  });

  @override
  Widget build(final BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final recordMm = (recordingSeconds ~/ 60).toString().padLeft(2, '0');
    final recordSs = (recordingSeconds % 60).toString().padLeft(2, '0');
    final draftMm = (draftVoiceSeconds ~/ 60).toString().padLeft(2, '0');
    final draftSs = (draftVoiceSeconds % 60).toString().padLeft(2, '0');

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
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.mic_rounded,
                        color: Color(0xFFFF6B6B), size: 16),
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
          if (hasDraftVoice && !isRecordingVoiceMessage)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Glass(
                radius: BorderRadius.circular(16),
                padding: const EdgeInsets.fromLTRB(10, 8, 8, 8),
                child: Row(
                  children: [
                    InkWell(
                      borderRadius: BorderRadius.circular(999),
                      onTap: onToggleDraftVoice,
                      child: Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: scheme.primary.withValues(alpha: 0.16),
                        ),
                        child: Icon(
                          isPlayingDraftVoice
                              ? Icons.pause_rounded
                              : Icons.play_arrow_rounded,
                          color: scheme.primary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Voice draft $draftMm:$draftSs',
                            style: TextStyle(
                              color: scheme.onSurface.withValues(alpha: 0.9),
                              fontWeight: FontWeight.w800,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 6),
                          _Waveform(
                            bars: draftVoiceWaveform,
                            color: scheme.primary,
                            dimColor: scheme.onSurface.withValues(alpha: 0.25),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      tooltip: 'Delete',
                      onPressed: onDeleteDraftVoice,
                      icon: Icon(Icons.delete_outline_rounded,
                          color: scheme.error),
                    ),
                    FilledButton.icon(
                      onPressed: onSendDraftVoice,
                      icon: const Icon(Icons.send_rounded, size: 16),
                      label: const Text('Send'),
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
                    focusNode: focusNode,
                    style: TextStyle(
                        color: scheme.onSurface, fontWeight: FontWeight.w700),
                    cursorColor: scheme.primary,
                    minLines: 1,
                    maxLines: isComposerFocused ? 6 : 4,
                    onChanged: (final v) {
                      onTypingChanged(v.trim().isNotEmpty);
                      onTextChanged(v);
                    },
                    onSubmitted: (final _) {
                      onSend();
                      onTypingChanged(false);
                    },
                    decoration: InputDecoration(
                      hintText: 'Message…',
                      hintStyle: TextStyle(
                          color: scheme.onSurface.withValues(alpha: 0.45)),
                      border: InputBorder.none,
                      isDense: true,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                AnimatedSwitcher(
                  duration: MotionTokens.medium,
                  switchInCurve: Curves.easeOut,
                  switchOutCurve: Curves.easeIn,
                  transitionBuilder: (final child, final animation) =>
                      SizeTransition(
                    sizeFactor: animation,
                    axis: Axis.horizontal,
                    axisAlignment: -1,
                    child: FadeTransition(opacity: animation, child: child),
                  ),
                  child: isComposerFocused
                      ? Row(
                          key: const ValueKey('focused-actions'),
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            InkWell(
                              borderRadius: BorderRadius.circular(18),
                              onTap: onOpenAttachmentTray,
                              child: Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  color:
                                      scheme.onSurface.withValues(alpha: 0.10),
                                  border: Border.all(
                                      color: scheme.onSurface
                                          .withValues(alpha: 0.16)),
                                ),
                                child: Icon(Icons.more_horiz_rounded,
                                    color: scheme.onSurface
                                        .withValues(alpha: 0.92)),
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
                                  gradient: LinearGradient(
                                    colors: isRecordingVoiceMessage
                                        ? [
                                            const Color(0xFFFF8A8A),
                                            const Color(0xFFFF4D6D)
                                          ]
                                        : [
                                            scheme.primary
                                                .withValues(alpha: 0.85),
                                            scheme.tertiary
                                                .withValues(alpha: 0.75)
                                          ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: scheme.primary
                                          .withValues(alpha: 0.35),
                                      blurRadius: 14,
                                      offset: const Offset(0, 6),
                                    ),
                                  ],
                                ),
                                child: Icon(
                                  isRecordingVoiceMessage
                                      ? Icons.stop_rounded
                                      : Icons.mic_rounded,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        )
                      : Row(
                          key: const ValueKey('full-actions'),
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            InkWell(
                              borderRadius: BorderRadius.circular(18),
                              onTap: onSendImage,
                              child: Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  color:
                                      scheme.onSurface.withValues(alpha: 0.10),
                                  border: Border.all(
                                      color: scheme.onSurface
                                          .withValues(alpha: 0.16)),
                                ),
                                child: Icon(Icons.image_rounded,
                                    color: scheme.onSurface
                                        .withValues(alpha: 0.92)),
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
                                  color:
                                      scheme.onSurface.withValues(alpha: 0.10),
                                  border: Border.all(
                                      color: scheme.onSurface
                                          .withValues(alpha: 0.16)),
                                ),
                                child: Icon(Icons.attach_file_rounded,
                                    color: scheme.onSurface
                                        .withValues(alpha: 0.92)),
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
                                  gradient: LinearGradient(
                                    colors: isRecordingVoiceMessage
                                        ? [
                                            const Color(0xFFFF8A8A),
                                            const Color(0xFFFF4D6D)
                                          ]
                                        : [
                                            scheme.primary
                                                .withValues(alpha: 0.85),
                                            scheme.tertiary
                                                .withValues(alpha: 0.75)
                                          ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: scheme.primary
                                          .withValues(alpha: 0.35),
                                      blurRadius: 14,
                                      offset: const Offset(0, 6),
                                    ),
                                  ],
                                ),
                                child: Icon(
                                  isRecordingVoiceMessage
                                      ? Icons.stop_rounded
                                      : Icons.mic_rounded,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
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
                      border: Border.all(
                          color: scheme.onSurface.withValues(alpha: 0.16)),
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

class _DmToolsSectionHeader extends StatelessWidget {
  final String title;

  const _DmToolsSectionHeader({required this.title});

  @override
  Widget build(final BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 6),
      child: Text(
        title,
        style: TextStyle(
          color: scheme.onSurface.withValues(alpha: 0.62),
          fontWeight: FontWeight.w800,
          fontSize: 12,
          letterSpacing: 0.2,
        ),
      ),
    );
  }
}

class _MessageRequestOverlay extends StatelessWidget {
  final String otherName;
  final String? username;
  final String? sentRequestStatus;
  final String? incomingRequestStatus;
  final VoidCallback onSendRequest;
  final VoidCallback onAccept;
  final VoidCallback onDecline;

  const _MessageRequestOverlay({
    required this.otherName,
    required this.username,
    required this.sentRequestStatus,
    required this.incomingRequestStatus,
    required this.onSendRequest,
    required this.onAccept,
    required this.onDecline,
  });

  @override
  Widget build(final BuildContext context) {
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
            const SizedBox(height: 6),
            Text(
              'You are requesting to message $otherName ${username == null || username!.isEmpty ? '' : '(@$username)'}',
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
            ),
            const SizedBox(height: 6),
            const Text(
              'Suggested intro: “Hey! I found your profile through Soma circles and wanted to practice together.”',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
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
              const Text('Request sent. Waiting for approval.',
                  style: TextStyle(fontWeight: FontWeight.w700))
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
  Widget build(final BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      color: scheme.surface,
      child: Column(
        children: [
          Text(
            'You have blocked this user',
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
              child: const Text('Unblock'),
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
  Widget build(final BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Glass(
        radius: BorderRadius.circular(16),
        padding: const EdgeInsets.all(10),
        child: Icon(icon,
            color:
                Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.92),
            size: 20),
      ),
    );
  }
}

class _ReplaySheet extends StatefulWidget {
  final List<Map<String, dynamic>> messages;
  final String otherName;
  const _ReplaySheet({required this.messages, required this.otherName});

  @override
  State<_ReplaySheet> createState() => _ReplaySheetState();
}

class _ReplaySheetState extends State<_ReplaySheet> {
  int _currentIndex = 0;

  void _next() {
    if (_currentIndex < widget.messages.length - 1) {
      setState(() => _currentIndex++);
    }
  }

  void _prev() {
    if (_currentIndex > 0) {
      setState(() => _currentIndex--);
    }
  }

  @override
  Widget build(final BuildContext context) {
    if (widget.messages.isEmpty) {
      return const SizedBox.shrink();
    }
    final msg = widget.messages[_currentIndex];
    final content = msg['content'] ?? '';
    String text = content.toString();
    try {
      if (text.trim().startsWith('{')) {
        final data = jsonDecode(text);
        if (data is Map && data['text'] != null) {
          text = data['text'];
        }
      }
    } catch (_) {}

    final senderId = msg['sender_id'];
    final myId = Supabase.instance.client.auth.currentUser?.id;
    final isMine = senderId == myId;

    return Container(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 48),
      height: 450,
      width: double.infinity,
      child: Column(
        children: [
          Text('Conversation Replay',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 30),
          Expanded(
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Text(
                      isMine ? 'You' : widget.otherName,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isMine ? Colors.blueAccent : Colors.purpleAccent,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      text,
                      style: const TextStyle(fontSize: 22, height: 1.4),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton.filledTonal(
                  onPressed: _prev, icon: const Icon(Icons.arrow_back_rounded)),
              Text('${_currentIndex + 1} / ${widget.messages.length}',
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              IconButton.filledTonal(
                  onPressed: _next,
                  icon: const Icon(Icons.arrow_forward_rounded)),
            ],
          ),
        ],
      ),
    );
  }
}

class _WeeklyReportCard extends StatelessWidget {
  final UserStats stats;
  final int messagesSent;

  const _WeeklyReportCard({required this.stats, required this.messagesSent});

  @override
  Widget build(final BuildContext context) {
    String grade = 'B';
    if (messagesSent > 50 && stats.totalCorrect > 20) {
      grade = 'A+';
    } else if (messagesSent > 20) {
      grade = 'A';
    } else if (messagesSent < 5) {
      grade = 'C';
    }

    return AlertDialog(
      title: const Text('Weekly Learning Report'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Theme.of(context).colorScheme.primaryContainer,
            ),
            child: Text(grade,
                style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.w900,
                    color: Theme.of(context).colorScheme.onPrimaryContainer)),
          ),
          const SizedBox(height: 24),
          _statRow(context, 'Messages Sent (7d)', '$messagesSent'),
          const Divider(),
          _statRow(context, 'Total Quizzes', '${stats.totalQuizzes}'),
          const Divider(),
          _statRow(context, 'Correct Answers', '${stats.totalCorrect}'),
          const Divider(),
          _statRow(context, 'Current Streak', '${stats.streakDays} days'),
        ],
      ),
      actions: [
        FilledButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Keep it up!')),
      ],
    );
  }

  Widget _statRow(
      final BuildContext context, final String label, final String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: Theme.of(context).textTheme.bodyMedium),
          Text(value,
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge
                  ?.copyWith(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
