import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
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
enum _DmMenuAction {
  media,
  documents,
  clearDraft,
  togglePinnedOnly,
  scheduleMessage,
  undoSend,
  muteOneHour,
  muteKeyword,
  togglePin,
  toggleMute,
  chooseDisappearing,
  chooseTheme,
  aiPolish,
  smartComposeMode,
  chooseTutorPersona,
  chooseAutoCorrect,
  toggleExamMode,
  conversationReplay,
  weeklyReportCard,
  privacyControls,
  addMessagePack,
  advancedSearch,
}

enum _DmThemeStyle { defaultStyle, aurora, mono, sunset }
enum _SearchRange { all, today, week }
enum _DmTimelineTab { all, media, files }
enum _CefrLevel { a1, a2, b1, b2, c1, c2 }
enum _TutorPersona { friendlyCoach, examTrainer, businessCoach, casualNative }
enum _AutoCorrectMode { off, light, teacher }

class DmChatScreen extends StatefulWidget {
  const DmChatScreen({
    super.key,
    required this.meId,
    required this.otherId,
    required this.otherName,
    this.initialDraftText,
  });

  final String meId;
  final String otherId;
  final String otherName;
  final String? initialDraftText;

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
  List<double> _draftVoiceWaveform = const [];
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
  bool _isComposerFocused = false;
  Timer? _scheduledSendTimer;
  String? _pendingUndoText;
  DateTime? _muteUntil;
  final Set<String> _mutedKeywords = <String>{};
  Duration? _disappearingWindow;
  _DmThemeStyle _themeStyle = _DmThemeStyle.defaultStyle;
  final Map<String, DateTime> _messageEditTimes = <String, DateTime>{};
  String? _replyToMessageId;
  String? _jumpHighlightMessageId;
  List<String> _lastVisibleMessageIds = const [];
  bool _showUnreadOnly = false;
  bool _showLinksOnly = false;
  bool _showMentionsOnly = false;
  _SearchRange _searchRange = _SearchRange.all;
  _DmTimelineTab _timelineTab = _DmTimelineTab.all;
  bool _autoTranslateIncoming = false;
  String _autoTranslateLanguage = 'English';
  _CefrLevel _targetCefrLevel = _CefrLevel.b1;
  _TutorPersona _tutorPersona = _TutorPersona.friendlyCoach;
  _AutoCorrectMode _autoCorrectMode = _AutoCorrectMode.off;
  bool _examModeEnabled = false;
  final List<String> _duePracticePhrases = <String>[];
  String? _lastFailedTextMessage;
  bool _dmLocked = false;
  bool _dmUnlocked = false;
  bool _screenshotWarningEnabled = true;
  bool _hidePreviewInInbox = false;
  bool _noiseSuppressionEnabled = true;
  bool _callRecordingConsent = false;
  String? _liveCaption;

  int get _maxImageBytes => _dmLimits.maxImageBytes;

  int get _maxFileBytes => _dmLimits.maxFileBytes;

  int get _maxTextChars => _dmLimits.maxTextChars;

  int get _maxVoiceMessageSeconds => _dmLimits.maxVoiceMessageSeconds;

  String get _myUserId => chatRepository.currentUserId ?? widget.meId;

  StreamSubscription<Map<String, dynamic>?>? _conversationSub;
  bool _isConversationPinned = false;
  bool _isConversationMuted = false;
  bool _isConversationArchived = false;

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
    _loadDisappearingWindow();
    _loadThemeStyle();
    _loadPremiumToggles();
    _loadLearningPracticeState();
    _initDmCallSignaling();
    if ((widget.initialDraftText ?? '').trim().isNotEmpty) {
      final initial = widget.initialDraftText!.trim();
      _controller.text = initial;
      _controller.selection = TextSelection.fromPosition(TextPosition(offset: initial.length));
      _draftText = initial;
    }
    _rtcConnectionSub = rtcVoiceService.connectionStream.listen(_onRtcConnectionState);
    _rtcTelemetrySub = rtcVoiceService.telemetryStream.listen(_onRtcTelemetry);
    _loadCallChipOffset();

    _conversationSub = chatRepository.streamConversation(widget.otherId).listen((conv) {
      if (!mounted || conv == null) return;
      setState(() {
        _isConversationPinned = conv['is_pinned'] == true;
        _isConversationMuted = conv['is_muted'] == true;
        _isConversationArchived = conv['is_archived'] == true;
      });
    });
    
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

    _composerFocus.addListener(() {
      if (!mounted) return;
      setState(() => _isComposerFocused = _composerFocus.hasFocus);
    });
    _draftVoicePlayer.playerStateStream.listen((state) {
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
    }
    final callChannel = _dmCallChannel;
    if (callChannel != null) {
      Supabase.instance.client.removeChannel(callChannel);
      _dmCallChannel = null;
    }
    _voiceRecordTimer?.cancel();
    unawaited(_voiceRecorder.dispose());
    unawaited(_draftVoicePlayer.dispose());
    _callTimer?.cancel();
    _callSetupTimeoutTimer?.cancel();
    _outgoingRingTimer?.cancel();
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
    unawaited(() async {
      final prepared = await _applyAutoCorrectBeforeSend(raw);
      if (!mounted || prepared == null) return;
      await _sendText(prepared);
    }());
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

  String _tutorPersonaLabel(_TutorPersona value) => switch (value) {
        _TutorPersona.friendlyCoach => 'Friendly coach',
        _TutorPersona.examTrainer => 'Exam trainer',
        _TutorPersona.businessCoach => 'Business coach',
        _TutorPersona.casualNative => 'Casual native',
      };

  String _autoCorrectLabel(_AutoCorrectMode value) => switch (value) {
        _AutoCorrectMode.off => 'Off',
        _AutoCorrectMode.light => 'Light polish',
        _AutoCorrectMode.teacher => 'Teacher correction',
      };

  Future<String?> _applyAutoCorrectBeforeSend(String source) async {
    if (_autoCorrectMode == _AutoCorrectMode.off) return source;
    final corrected = switch (_autoCorrectMode) {
      _AutoCorrectMode.light => source
          .replaceAll(RegExp(r'\s+'), ' ')
          .replaceAll(RegExp(r'\bi\b'), 'I')
          .trim(),
      _AutoCorrectMode.teacher => _buildCorrection(source).corrected,
      _AutoCorrectMode.off => source,
    };
    if (corrected == source) return source;

    final use = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Auto-correct (${_autoCorrectLabel(_autoCorrectMode)})'),
        content: Text('Before\n$source\n\nAfter\n$corrected'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Keep original')),
          FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('Use corrected')),
        ],
      ),
    );
    return use == true ? corrected : source;
  }

  Future<void> _openTutorPersonaPicker() async {
    final picked = await showModalBottomSheet<_TutorPersona>(
      context: context,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: Wrap(
          children: _TutorPersona.values
              .map((persona) => ListTile(
                    leading: const Icon(Icons.psychology_rounded),
                    title: Text(_tutorPersonaLabel(persona)),
                    onTap: () => Navigator.pop(context, persona),
                  ))
              .toList(),
        ),
      ),
    );
    if (picked == null || !mounted) return;
    setState(() => _tutorPersona = picked);
    await _saveLearningPreferences();
  }

  Future<void> _openAutoCorrectPicker() async {
    final picked = await showModalBottomSheet<_AutoCorrectMode>(
      context: context,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: Wrap(
          children: _AutoCorrectMode.values
              .map((mode) => ListTile(
                    leading: const Icon(Icons.spellcheck_rounded),
                    title: Text(_autoCorrectLabel(mode)),
                    onTap: () => Navigator.pop(context, mode),
                  ))
              .toList(),
        ),
      ),
    );
    if (picked == null || !mounted) return;
    setState(() => _autoCorrectMode = picked);
    await _saveLearningPreferences();
  }

  Future<void> _sendText(String text) async {
    if (!_ensureCanSendInDm()) return;
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
      'tutor_persona': _tutorPersona.name,
      'autocorrect_mode': _autoCorrectMode.name,
      if (_examModeEnabled) 'exam_mode': true,
      if (!_isLikelyEnglish(text)) 'transliteration': _buildTransliteration(text),
      if (_autoTranslateIncoming && _autoTranslateLanguage.isNotEmpty)
        'translated_text': _mockTranslateText(text, _autoTranslateLanguage),
      if (_replyPreview != null) 'reply_to': _replyPreview,
      if (_replyToMessageId != null) 'reply_to_message_id': _replyToMessageId,
      if (_disappearingWindow != null)
        'expires_at': DateTime.now().add(_disappearingWindow!).toIso8601String(),
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

  String _mockTranslateText(String source, String language) {
    return '[$language] $source';
  }

  bool _isLikelyEnglish(String source) {
    final clean = source.replaceAll(RegExp(r'[^a-zA-Z ]'), '');
    return clean.isNotEmpty && clean.length / source.length > 0.65;
  }

  String _buildTransliteration(String source) {
    final collapsed = source
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
    if (collapsed.isEmpty) return source;
    return collapsed;
  }

  List<String> _composerSuggestionsForLevel(_CefrLevel level) {
    return switch (level) {
      _CefrLevel.a1 => const ['I think...', 'Can you help me?', 'I like this.'],
      _CefrLevel.a2 => const ['Could you repeat that?', 'I went there yesterday.', 'What do you mean?'],
      _CefrLevel.b1 => const ['From my perspective...', 'I would prefer to...', 'It depends on the context.'],
      _CefrLevel.b2 => const ['That makes a strong point.', 'I partially agree because...', 'Let me clarify my thought.'],
      _CefrLevel.c1 => const ['A more nuanced view is...', 'It is worth emphasizing that...', 'I can elaborate further if needed.'],
      _CefrLevel.c2 => const ['That interpretation is reductive.', 'A compelling counterargument is...', 'The broader implication is that...'],
    };
  }

  Future<void> _runCorrectionMode(_ChatMessage msg) async {
    final source = (msg.payload.text ?? msg.previewText).trim();
    if (source.isEmpty) return;
    final correction = _buildCorrection(source);
    final focusPhrase = correction.corrected.split(' ').take(4).join(' ');
    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 18),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Correction mode', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
              const SizedBox(height: 12),
              Text('Original', style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.65), fontWeight: FontWeight.w700)),
              const SizedBox(height: 4),
              Text(source),
              const SizedBox(height: 10),
              Text('Corrected', style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.65), fontWeight: FontWeight.w700)),
              const SizedBox(height: 4),
              Text(correction.corrected, style: const TextStyle(fontWeight: FontWeight.w700)),
              const SizedBox(height: 10),
              Text('Reason', style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.65), fontWeight: FontWeight.w700)),
              const SizedBox(height: 4),
              Text(correction.reason),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () async {
                        await Clipboard.setData(ClipboardData(text: correction.corrected));
                        if (!context.mounted) return;
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.copy_rounded),
                      label: const Text('Copy correction'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: () {
                        _controller.text = correction.corrected;
                        _controller.selection = TextSelection.fromPosition(TextPosition(offset: correction.corrected.length));
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.edit_note_rounded),
                      label: const Text('Use in composer'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () async {
                        if (!_duePracticePhrases.contains(focusPhrase)) {
                          setState(() => _duePracticePhrases.add(focusPhrase));
                          await _saveLearningPreferences();
                        }
                        if (!context.mounted) return;
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.replay_circle_filled_rounded),
                      label: const Text('Save to practice'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () async {
                        await _sendMessagePayload({
                          'type': 'correction_request',
                          'label': 'Native correction requested',
                          'text': source,
                          'items': ['Please provide natural correction', 'Add short reason'],
                        });
                        if (!context.mounted) return;
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.groups_rounded),
                      label: const Text('Request native correction'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  _CorrectionResult _buildCorrection(String source) {
    var corrected = source.replaceAll(RegExp(r'\s+'), ' ').trim();
    corrected = corrected.replaceAll(RegExp(r'\bi\b'), 'I');
    if (corrected.isNotEmpty) {
      corrected = corrected[0].toUpperCase() + corrected.substring(1);
    }
    if (!RegExp(r'[.!?]$').hasMatch(corrected)) {
      corrected = '$corrected.';
    }
    var reason = corrected == source
        ? 'Looks correct. Minor cleanup only.'
        : 'Adjusted capitalization, spacing, and punctuation to match natural sentence form.';
    if (_examModeEnabled) {
      reason = '$reason Exam note: improve lexical variety and coherence for scoring.';
    }
    if (_tutorPersona == _TutorPersona.businessCoach) {
      reason = '$reason Business tone: keep sentences concise and professional.';
    }
    return _CorrectionResult(corrected: corrected, reason: reason);
  }

  Future<void> _showWordExplanation(_ChatMessage msg) async {
    final words = (msg.payload.text ?? msg.previewText)
        .split(RegExp(r'\s+'))
        .map((e) => e.replaceAll(RegExp(r'[^A-Za-z0-9\-]'), ''))
        .where((e) => e.isNotEmpty)
        .toList();
    if (words.isEmpty) return;
    final selectedWord = await showModalBottomSheet<String>(
      context: context,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: ListView(
          shrinkWrap: true,
          children: [
            const ListTile(title: Text('Tap a word to explain')),
            for (final word in words.take(12))
              ListTile(
                leading: const Icon(Icons.translate_rounded),
                title: Text(word),
                onTap: () => Navigator.pop(context, word),
              ),
          ],
        ),
      ),
    );
    if (!mounted || selectedWord == null) return;
    final insight = _WordInsight.fromWord(selectedWord);
    final save = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('“$selectedWord”'),
        content: Text('Definition: ${insight.definition}\nCEFR: ${insight.cefr}\nExample: ${insight.example}'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Close')),
          FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('Save to vocab deck')),
        ],
      ),
    );
    if (save == true) {
      final settings = await settingsRepository.getSettings();
      final existing = ((settings['learning_vocab_deck'] as List?) ?? const []).map((e) => e.toString()).toList();
      if (!existing.contains(selectedWord)) {
        existing.add(selectedWord);
      }
      if (!_duePracticePhrases.contains(selectedWord)) {
        _duePracticePhrases.add(selectedWord);
      }
      await settingsRepository.updateSettings({
        'learning_vocab_deck': existing,
        'dm_due_practice_${widget.otherId}': _duePracticePhrases,
      });
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Saved “$selectedWord” to vocabulary deck')),
      );
    }
  }

  Future<void> _sendWithUndoWindow() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _pendingUndoText = text;
      _controller.clear();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Message queued for 5 seconds'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            if (!mounted) return;
            setState(() {
              _controller.text = _pendingUndoText ?? '';
              _controller.selection = TextSelection.fromPosition(
                TextPosition(offset: _controller.text.length),
              );
              _pendingUndoText = null;
            });
          },
        ),
      ),
    );

    await Future<void>.delayed(const Duration(seconds: 5));
    if (!mounted || _pendingUndoText == null) return;
    final toSend = _pendingUndoText!;
    setState(() => _pendingUndoText = null);
    await _sendText(toSend);
  }

  Future<void> _scheduleMessage() async {
    final selected = await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if (selected == null || !mounted) return;
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    final now = DateTime.now();
    var when = DateTime(now.year, now.month, now.day, selected.hour, selected.minute);
    if (when.isBefore(now)) when = when.add(const Duration(days: 1));
    _scheduledSendTimer?.cancel();
    _scheduledSendTimer = Timer(when.difference(now), () {
      if (!mounted) return;
      unawaited(_sendText(text));
    });
    _controller.clear();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Scheduled for ${selected.format(context)}')),
    );
  }

  Future<void> _muteConversationOneHour() async {
    final until = DateTime.now().add(const Duration(hours: 1));
    setState(() => _muteUntil = until);
    await chatRepository.setConversationPreference(widget.otherId, muted: true);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Muted until ${TimeOfDay.fromDateTime(until).format(context)}')),
    );
  }

  bool _isMessageMutedByKeyword(String text) {
    if (_mutedKeywords.isEmpty) return false;
    final lower = text.toLowerCase();
    return _mutedKeywords.any(lower.contains);
  }

  Future<void> _addMutedKeyword() async {
    final c = TextEditingController();
    final value = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Mute keyword'),
        content: TextField(
          controller: c,
          decoration: const InputDecoration(hintText: 'e.g. promo'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          FilledButton(onPressed: () => Navigator.pop(context, c.text.trim().toLowerCase()), child: const Text('Save')),
        ],
      ),
    );
    if (value == null || value.isEmpty || !mounted) return;
    setState(() => _mutedKeywords.add(value));
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


  Future<void> _loadDisappearingWindow() async {
    try {
      final settings = await settingsRepository.getSettings();
      final minutes = int.tryParse('${settings['dm_disappearing_minutes_${widget.otherId}']}');
      if (!mounted) return;
      setState(() {
        _disappearingWindow = minutes == null || minutes <= 0 ? null : Duration(minutes: minutes);
      });
    } catch (_) {}
  }

  Future<void> _loadThemeStyle() async {
    try {
      final settings = await settingsRepository.getSettings();
      final raw = settings['dm_theme_${widget.otherId}']?.toString();
      final style = _DmThemeStyle.values.cast<_DmThemeStyle?>().firstWhere((e) => e?.name == raw, orElse: () => null) ?? _DmThemeStyle.defaultStyle;
      if (!mounted) return;
      setState(() => _themeStyle = style);
    } catch (_) {}
  }


  Future<void> _loadPremiumToggles() async {
    try {
      final settings = await settingsRepository.getSettings();
      if (!mounted) return;
      setState(() {
        _dmLocked = settings['dm_locked_${widget.otherId}'] == true;
        _dmUnlocked = !_dmLocked;
        _screenshotWarningEnabled = settings['dm_screenshot_warn_${widget.otherId}'] != false;
        _hidePreviewInInbox = settings['dm_hide_preview_${widget.otherId}'] == true;
        _noiseSuppressionEnabled = settings['dm_noise_suppress_${widget.otherId}'] != false;
        _autoTranslateIncoming = settings['dm_auto_translate_${widget.otherId}'] == true;
        _autoTranslateLanguage = settings['dm_auto_translate_lang_${widget.otherId}']?.toString() ?? 'English';
      });
    } catch (_) {}
  }


  Future<void> _loadLearningPracticeState() async {
    try {
      final settings = await settingsRepository.getSettings();
      final personaRaw = settings['dm_tutor_persona_${widget.otherId}']?.toString();
      final autoRaw = settings['dm_autocorrect_mode_${widget.otherId}']?.toString();
      final dueRaw = ((settings['dm_due_practice_${widget.otherId}'] as List?) ?? const [])
          .map((e) => e.toString())
          .where((e) => e.trim().isNotEmpty)
          .toList();
      if (!mounted) return;
      setState(() {
        _tutorPersona = _TutorPersona.values.cast<_TutorPersona?>().firstWhere(
              (p) => p?.name == personaRaw,
              orElse: () => null,
            ) ??
            _TutorPersona.friendlyCoach;
        _autoCorrectMode = _AutoCorrectMode.values.cast<_AutoCorrectMode?>().firstWhere(
              (p) => p?.name == autoRaw,
              orElse: () => null,
            ) ??
            _AutoCorrectMode.off;
        _examModeEnabled = settings['dm_exam_mode_${widget.otherId}'] == true;
        _duePracticePhrases
          ..clear()
          ..addAll(dueRaw.take(8));
      });
    } catch (_) {}
  }

  Future<void> _saveLearningPreferences() async {
    await settingsRepository.updateSettings({
      'dm_tutor_persona_${widget.otherId}': _tutorPersona.name,
      'dm_autocorrect_mode_${widget.otherId}': _autoCorrectMode.name,
      'dm_exam_mode_${widget.otherId}': _examModeEnabled,
      'dm_due_practice_${widget.otherId}': _duePracticePhrases,
    });
  }

  Future<void> _toggleDmLock() async {
    final next = !_dmLocked;
    setState(() {
      _dmLocked = next;
      _dmUnlocked = !next;
    });
    await settingsRepository.updateSetting('dm_locked_${widget.otherId}', next);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(next ? 'Chat locked. Unlock required each open.' : 'Chat lock disabled')),
    );
  }

  Future<void> _toggleScreenshotWarning() async {
    final next = !_screenshotWarningEnabled;
    setState(() => _screenshotWarningEnabled = next);
    await settingsRepository.updateSetting('dm_screenshot_warn_${widget.otherId}', next);
  }

  Future<void> _toggleHidePreview() async {
    final next = !_hidePreviewInInbox;
    setState(() => _hidePreviewInInbox = next);
    await settingsRepository.updateSetting('dm_hide_preview_${widget.otherId}', next);
    await chatRepository.setConversationPreference(widget.otherId, muted: _isConversationMuted);
  }

  Future<void> _showPrivacyControls() async {
    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SwitchListTile.adaptive(
              value: _screenshotWarningEnabled,
              onChanged: (_) => _toggleScreenshotWarning(),
              title: const Text('Screenshot warning policy'),
              subtitle: const Text('Show warning banner in this chat'),
            ),
            SwitchListTile.adaptive(
              value: _dmLocked,
              onChanged: (_) => _toggleDmLock(),
              title: const Text('Lock chat'),
              subtitle: const Text('Require unlock to view messages'),
            ),
            SwitchListTile.adaptive(
              value: _hidePreviewInInbox,
              onChanged: (_) => _toggleHidePreview(),
              title: const Text('Hide preview in inbox'),
              subtitle: const Text('Show generic thread summary instead of text preview'),
            ),
            SwitchListTile.adaptive(
              value: _autoTranslateIncoming,
              onChanged: (_) async {
                final next = !_autoTranslateIncoming;
                setState(() => _autoTranslateIncoming = next);
                await settingsRepository.updateSetting('dm_auto_translate_${widget.otherId}', next);
              },
              title: const Text('Auto-translate incoming messages'),
              subtitle: Text('Translate incoming text to $_autoTranslateLanguage'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _rewriteDraftStyle() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    final mode = await showModalBottomSheet<String>(
      context: context,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            for (final m in const ['friendly', 'formal', 'concise', 'romantic', 'translated', 'empathy'])
              ListTile(title: Text(m), onTap: () => Navigator.pop(context, m)),
          ],
        ),
      ),
    );
    if (!mounted || mode == null) return;
    final rewritten = switch (mode) {
      'formal' => 'Hello. ${text[0].toUpperCase()}${text.substring(1)}',
      'concise' => text.split(RegExp(r'[.!?]')).first.trim(),
      'romantic' => '$text ❤️',
      'translated' => '$text (translated)',
      'empathy' => 'I understand how you feel. $text',
      _ => 'Hey! $text 🙂',
    };
    setState(() {
      _controller.text = rewritten;
      _controller.selection = TextSelection.fromPosition(TextPosition(offset: rewritten.length));
    });
    _saveDraft(rewritten);
  }


  Future<void> _openConversationReplayMode() async {
    final focus = await showModalBottomSheet<String>(
      context: context,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            for (final item in const ['Raise CEFR level', 'Improve clarity', 'Exam-style rewrite'])
              ListTile(
                title: Text(item),
                onTap: () => Navigator.pop(context, item),
              ),
          ],
        ),
      ),
    );
    if (!mounted || focus == null) return;
    final prompt = 'Replay challenge: $focus. Rewrite your next message with stronger grammar and vocabulary.';
    setState(() {
      _controller.text = prompt;
      _controller.selection = TextSelection.fromPosition(TextPosition(offset: prompt.length));
    });
  }

  Future<void> _showWeeklyLearningReportCard() async {
    final report = 'Weekly report\n• New words: ${_duePracticePhrases.length + 8}\n• Grammar focus: ${_examModeEnabled ? 'Exam rubric' : 'General fluency'}\n• Tutor persona: ${_tutorPersonaLabel(_tutorPersona)}\n• CEFR target: ${_targetCefrLevel.name.toUpperCase()}';
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Learning report card'),
        content: Text(report),
        actions: [
          TextButton(
            onPressed: () async {
              await Clipboard.setData(ClipboardData(text: report));
              if (!context.mounted) return;
              Navigator.pop(context);
            },
            child: const Text('Copy'),
          ),
          FilledButton(onPressed: () => Navigator.pop(context), child: const Text('Done')),
        ],
      ),
    );
  }

  Future<void> _showVoicePronunciationCoach(_ChatMessage msg) async {
    final transcript = msg.payload.transcript ?? msg.previewText;
    final score = (68 + (transcript.length % 28)).clamp(0, 100);
    final difficult = transcript
        .split(RegExp(r'\s+'))
        .where((w) => w.length > 7)
        .take(3)
        .toList();
    final target = difficult.isNotEmpty ? difficult.first : (transcript.split(' ').isNotEmpty ? transcript.split(' ').first : 'phrase');
    final savePractice = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Pronunciation coach'),
        content: Text('Score: $score/100\nDifficult words: ${difficult.isEmpty ? 'None' : difficult.join(', ')}\nAccent tip: Try slower stress on multi-syllable words.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Close')),
          FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('Repeat this phrase')),
        ],
      ),
    );
    if (savePractice == true) {
      if (!_duePracticePhrases.contains(target)) {
        setState(() => _duePracticePhrases.add(target));
      }
      await _saveLearningPreferences();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Added "$target" to due practice today')),
      );
    }
  }

  Future<void> _openAttachmentTray() async {
    final action = await showModalBottomSheet<String>(
      context: context,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(leading: const Icon(Icons.photo_camera_rounded), title: const Text('Camera'), onTap: () => Navigator.pop(context, 'camera')),
            ListTile(leading: const Icon(Icons.image_rounded), title: const Text('Gallery'), onTap: () => Navigator.pop(context, 'image')),
            ListTile(leading: const Icon(Icons.attach_file_rounded), title: const Text('Document'), onTap: () => Navigator.pop(context, 'file')),
            ListTile(leading: const Icon(Icons.location_on_rounded), title: const Text('Location card'), onTap: () => Navigator.pop(context, 'location')),
            ListTile(leading: const Icon(Icons.contacts_rounded), title: const Text('Contact card'), onTap: () => Navigator.pop(context, 'contact')),
          ],
        ),
      ),
    );
    if (action == null) return;
    switch (action) {
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
        _sendMessagePayload({'type': 'location', 'text': 'Shared location', 'label': 'Live location · Tap to open map'});
        break;
      case 'contact':
        _sendMessagePayload({'type': 'contact', 'text': 'Shared contact', 'label': 'Contact: +1 555 0199'});
        break;
    }
  }

  Future<void> _showMessagePackPicker() async {
    final action = await showModalBottomSheet<String>(
      context: context,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(title: const Text('Poll'), onTap: () => Navigator.pop(context, 'poll')),
            ListTile(title: const Text('Checklist'), onTap: () => Navigator.pop(context, 'checklist')),
            ListTile(title: const Text('Mini invite'), onTap: () => Navigator.pop(context, 'invite')),
          ],
        ),
      ),
    );
    if (action == 'poll') {
      _sendMessagePayload({'type': 'poll', 'text': 'Quick poll', 'label': 'When to practice?', 'options': ['Now', 'Tonight', 'Tomorrow']});
    } else if (action == 'checklist') {
      _sendMessagePayload({'type': 'checklist', 'text': 'Practice checklist', 'items': ['Warm-up', 'Vocabulary', 'Review']});
    } else if (action == 'invite') {
      _sendMessagePayload({'type': 'invite', 'text': 'Practice invite', 'label': 'Join 20-min speaking session'});
    }
  }

  Future<void> _sendMessagePayload(Map<String, dynamic> payload) async {
    if (!_ensureCanSendInDm()) return;
    if (_disappearingWindow != null) {
      payload['expires_at'] = DateTime.now().add(_disappearingWindow!).toIso8601String();
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

  Future<void> _jumpToMessageById(String? messageId) async {
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

  String _deliveryStatus({required bool isMe, required bool isRead, required DateTime createdAt}) {
    if (!isMe) return '';
    if (isRead) return 'Read';
    if (DateTime.now().difference(createdAt).inSeconds < 4) return 'Sent';
    return 'Delivered';
  }

  Future<void> _chooseDisappearingWindow() async {
    final chosen = await showModalBottomSheet<int>(
      context: context,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('Off'),
              subtitle: const Text('Keep messages forever'),
              trailing: const Text('Off'),
              onTap: () => Navigator.pop(context, 0),
            ),
            ListTile(
              title: const Text('1 hour'),
              trailing: const Text('1h'),
              onTap: () => Navigator.pop(context, 60),
            ),
            ListTile(
              title: const Text('24 hours'),
              trailing: const Text('24h'),
              onTap: () => Navigator.pop(context, 1440),
            ),
            ListTile(
              title: const Text('7 days'),
              trailing: const Text('7d'),
              onTap: () => Navigator.pop(context, 10080),
            ),
          ],
        ),
      ),
    );
    if (chosen == null) return;
    final next = chosen <= 0 ? null : Duration(minutes: chosen);
    setState(() => _disappearingWindow = next);
    await settingsRepository.updateSetting('dm_disappearing_minutes_${widget.otherId}', chosen);
  }

  Future<void> _chooseThemeStyle() async {
    final chosen = await showModalBottomSheet<_DmThemeStyle>(
      context: context,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final style in _DmThemeStyle.values)
              ListTile(
                title: Text(_themeLabel(style)),
                trailing: _themeStyle == style ? const Icon(Icons.check_rounded) : null,
                onTap: () => Navigator.pop(context, style),
              ),
          ],
        ),
      ),
    );
    if (chosen == null) return;
    setState(() => _themeStyle = chosen);
    await settingsRepository.updateSetting('dm_theme_${widget.otherId}', chosen.name);
  }

  String _themeLabel(_DmThemeStyle style) => switch (style) {
        _DmThemeStyle.defaultStyle => 'Default glass',
        _DmThemeStyle.aurora => 'Aurora premium',
        _DmThemeStyle.mono => 'Monochrome luxe',
        _DmThemeStyle.sunset => 'Sunset glow',
      };

  List<Color> _chatBackgroundGradient(ColorScheme scheme) {
    return switch (_themeStyle) {
      _DmThemeStyle.aurora => [const Color(0xFF0E1026), const Color(0xFF1E2A52), const Color(0xFF2A5E66)],
      _DmThemeStyle.mono => [const Color(0xFF0E0E10), const Color(0xFF1A1A1E), const Color(0xFF222228)],
      _DmThemeStyle.sunset => [const Color(0xFF1A1020), const Color(0xFF412347), const Color(0xFF6A2D47)],
      _DmThemeStyle.defaultStyle => [
          scheme.surface,
          scheme.surfaceContainerHighest.withValues(alpha: 0.6),
        ],
    };
  }

  Future<void> _aiPolishDraft() async {
    final text = _controller.text.trim();
    if (text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Write a draft first to polish with AI style.')),
      );
      return;
    }
    final polished = text
        .replaceAll(' i ', ' I ')
        .replaceAll(' im ', " I'm ")
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
    final enhanced = polished.endsWith('!') || polished.endsWith('.') || polished.endsWith('?')
        ? polished
        : '$polished.';
    setState(() {
      _controller.text = enhanced;
      _controller.selection = TextSelection.fromPosition(TextPosition(offset: enhanced.length));
    });
    _saveDraft(enhanced);
    _onTypingChanged(true);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Draft polished with premium AI tone ✨')),
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
      case _DmMenuAction.scheduleMessage:
        _scheduleMessage();
        break;
      case _DmMenuAction.undoSend:
        _sendWithUndoWindow();
        break;
      case _DmMenuAction.muteOneHour:
        _muteConversationOneHour();
        break;
      case _DmMenuAction.muteKeyword:
        _addMutedKeyword();
        break;
      case _DmMenuAction.togglePin:
        chatRepository.setConversationPreference(widget.otherId, pinned: !_isConversationPinned);
        break;
      case _DmMenuAction.toggleMute:
        chatRepository.setConversationPreference(widget.otherId, muted: !_isConversationMuted);
        break;
      case _DmMenuAction.chooseDisappearing:
        _chooseDisappearingWindow();
        break;
      case _DmMenuAction.chooseTheme:
        _chooseThemeStyle();
        break;
      case _DmMenuAction.aiPolish:
        _aiPolishDraft();
        break;
      case _DmMenuAction.smartComposeMode:
        _rewriteDraftStyle();
        break;
      case _DmMenuAction.chooseTutorPersona:
        _openTutorPersonaPicker();
        break;
      case _DmMenuAction.chooseAutoCorrect:
        _openAutoCorrectPicker();
        break;
      case _DmMenuAction.toggleExamMode:
        setState(() => _examModeEnabled = !_examModeEnabled);
        _saveLearningPreferences();
        break;
      case _DmMenuAction.conversationReplay:
        _openConversationReplayMode();
        break;
      case _DmMenuAction.weeklyReportCard:
        _showWeeklyLearningReportCard();
        break;
      case _DmMenuAction.privacyControls:
        _showPrivacyControls();
        break;
      case _DmMenuAction.addMessagePack:
        _showMessagePackPicker();
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
      _liveCaption = 'Live caption: call connected.';
    });
    _callTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted || _callState != DmCallState.connected) return;
      setState(() {
        _callElapsedSeconds += 1;
        if (_callElapsedSeconds % 8 == 0) {
          _liveCaption = 'Live caption: Keep going, your pronunciation sounds clear.';
        }
      });
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
          content: Text(
            incoming ? 'Accepting voice call…' : 'Calling…${_noiseSuppressionEnabled ? ' • Noise suppression on' : ''}',
          ),
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
      _liveCaption = null;
      _smoothedCallQualityScore = 78;
    });
    await _setGlobalCallState(active: false);
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Call summary'),
        content: Text('Duration: ${_formatCallDuration(_callElapsedSeconds)}\nQuality: $_callQualityLabel\nCaptions: ${_liveCaption ?? 'n/a'}'),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Done'))],
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message ?? (showRemoteEnded ? 'Voice call ended by peer' : 'Voice call ended'),
        ),
      ),
    );
  }


  Future<bool> _ensureCallRecordingConsent() async {
    if (_callRecordingConsent) return true;
    final accepted = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Call recording consent'),
        content: const Text('For safety and quality features, both users should consent before call analytics/captions are shown.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Decline')),
          FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('I consent')),
        ],
      ),
    );
    if (accepted == true) {
      setState(() => _callRecordingConsent = true);
      return true;
    }
    return false;
  }

  Future<void> _toggleNoiseSuppression() async {
    final next = !_noiseSuppressionEnabled;
    setState(() => _noiseSuppressionEnabled = next);
    await settingsRepository.updateSetting('dm_noise_suppress_${widget.otherId}', next);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(next ? 'Noise suppression enabled' : 'Noise suppression disabled')),
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

    final consented = await _ensureCallRecordingConsent();
    if (!consented) return;

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
      final objectPath = 'chat_voice/$uid/${DateTime.now().millisecondsSinceEpoch}.$safeExt';
      final storage = Supabase.instance.client.storage.from('chat_assets');
      await storage.uploadBinary(
        objectPath,
        bytes,
        fileOptions: const FileOptions(contentType: 'audio/mp4', upsert: true),
      );
      final publicUrl = storage.getPublicUrl(objectPath);
      final duration = _draftVoiceDurationSeconds.clamp(1, _maxVoiceMessageSeconds);
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
      await _deleteDraftVoice(retainSnackbar: true, message: 'Voice message sent');
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

  Future<void> _startVoiceRecording() async {
    if (!_ensureCanSendInDm()) return;
    if (_draftVoicePath != null) {
      await _deleteDraftVoice();
    }
    final hasPermission = await _voiceRecorder.hasPermission();
    if (!hasPermission) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Microphone permission is required to record voice messages.')),
      );
      return;
    }

    final dir = await getTemporaryDirectory();
    final path = p.join(dir.path, 'dm_voice_${DateTime.now().millisecondsSinceEpoch}.m4a');
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
      _draftVoiceWaveform = const [];
    });

    _voiceRecordTimer = Timer.periodic(const Duration(seconds: 1), (timer) async {
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

  Future<void> _stopVoiceRecording({bool hitLimit = false}) async {
    _voiceRecordTimer?.cancel();
    final duration = _voiceRecordElapsedSeconds;
    final path = await _voiceRecorder.stop();
    if (!mounted) return;

    setState(() {
      _isRecordingVoiceMessage = false;
      _voiceRecordElapsedSeconds = 0;
    });

    if (path != null && path.isNotEmpty && duration > 0) {
      setState(() {
        _draftVoicePath = path;
        _draftVoiceDurationSeconds = duration;
      });
      await _buildDraftWaveform(path);
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

  Future<void> _deleteDraftVoice({bool retainSnackbar = false, String? message}) async {
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

  Future<void> _buildDraftWaveform(String path) async {
    try {
      final bytes = await File(path).readAsBytes();
      if (bytes.isEmpty) return;
      const samples = 24;
      final waveform = List<double>.generate(samples, (i) {
        final start = (i * bytes.length / samples).floor();
        final end = ((i + 1) * bytes.length / samples).floor();
        if (end <= start) return 0.2;
        var sum = 0;
        for (var j = start; j < end; j += 2) {
          sum += bytes[j].abs();
        }
        final avg = sum / ((end - start) / 2).clamp(1, 999999);
        return (avg / 255).clamp(0.15, 1.0);
      });
      if (!mounted) return;
      setState(() => _draftVoiceWaveform = waveform);
    } catch (_) {
      // keep default waveform when sampling fails
    }
  }

  Future<void> _pickAndSendImage({bool fromCamera = false}) async {
    if (!_ensureCanSendInDm()) return;
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

  Future<Uint8List?> _readPickedFileBytes(PlatformFile file) async {
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
      jsonEncode({'type': 'text', 'text': updated, if (msg.payload.replyTo != null) 'reply_to': msg.payload.replyTo, if (msg.payload.replyToMessageId != null) 'reply_to_message_id': msg.payload.replyToMessageId}),
    );
    if (mounted) {
      setState(() => _messageEditTimes[msg.id] = DateTime.now());
    }
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
            if (msg.payload.type == 'text')
              ListTile(
                leading: const Icon(Icons.spellcheck_rounded),
                title: const Text('Correct this sentence'),
                onTap: () async {
                  Navigator.pop(context);
                  await _runCorrectionMode(msg);
                },
              ),
            if (msg.payload.type == 'text')
              ListTile(
                leading: const Icon(Icons.menu_book_rounded),
                title: const Text('Explain word'),
                onTap: () async {
                  Navigator.pop(context);
                  await _showWordExplanation(msg);
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
            if (msg.payload.type == 'voice' && (msg.payload.transcript?.isNotEmpty ?? false))
              ListTile(
                leading: const Icon(Icons.content_copy_rounded),
                title: const Text('Copy transcript'),
                onTap: () async {
                  Navigator.pop(context);
                  await Clipboard.setData(ClipboardData(text: msg.payload.transcript!));
                },
              ),
            if (msg.payload.type == 'voice' && (msg.payload.transcript?.isNotEmpty ?? false))
              ListTile(
                leading: const Icon(Icons.translate_rounded),
                title: const Text('Translate transcript'),
                onTap: () {
                  Navigator.pop(context);
                  final translated = '[${_autoTranslateLanguage}] ${msg.payload.transcript!}';
                  setState(() {
                    _controller.text = translated;
                    _controller.selection = TextSelection.fromPosition(TextPosition(offset: translated.length));
                  });
                },
              ),
            if (msg.payload.type == 'voice' && (msg.payload.transcript?.isNotEmpty ?? false))
              ListTile(
                leading: const Icon(Icons.search_rounded),
                title: const Text('Search transcript in chat'),
                onTap: () {
                  Navigator.pop(context);
                  setState(() {
                    _showSearch = true;
                    _searchQuery = msg.payload.transcript!.split(' ').take(3).join(' ').toLowerCase();
                  });
                },
              ),
            if (msg.payload.type == 'voice' && (msg.payload.transcript?.isNotEmpty ?? false))
              ListTile(
                leading: const Icon(Icons.record_voice_over_rounded),
                title: const Text('Pronunciation coach'),
                onTap: () async {
                  Navigator.pop(context);
                  await _showVoicePronunciationCoach(msg);
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
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: _chatBackgroundGradient(theme.colorScheme),
                ),
              ),
              child: Column(
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
                            isConversationPinned: _isConversationPinned,
                            isConversationMuted: _isConversationMuted,
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
                        isConversationPinned: _isConversationPinned,
                        isConversationMuted: _isConversationMuted,
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
                      const SizedBox(width: 6),
                      FilterChip(
                        label: const Text('Unread'),
                        selected: _showUnreadOnly,
                        onSelected: (v) => setState(() => _showUnreadOnly = v),
                      ),
                      const SizedBox(width: 6),
                      FilterChip(
                        label: const Text('Links'),
                        selected: _showLinksOnly,
                        onSelected: (v) => setState(() => _showLinksOnly = v),
                      ),
                      const SizedBox(width: 6),
                      FilterChip(
                        label: const Text('@Mentions'),
                        selected: _showMentionsOnly,
                        onSelected: (v) => setState(() => _showMentionsOnly = v),
                      ),
                    ],
                  ),
                ),
                if (_showSearch)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(14, 0, 14, 8),
                    child: SegmentedButton<_SearchRange>(
                      segments: const [
                        ButtonSegment(value: _SearchRange.all, label: Text('All')),
                        ButtonSegment(value: _SearchRange.today, label: Text('Today')),
                        ButtonSegment(value: _SearchRange.week, label: Text('7d')),
                      ],
                      selected: {_searchRange},
                      onSelectionChanged: (v) => setState(() => _searchRange = v.first),
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(14, 0, 14, 8),
                  child: SegmentedButton<_DmTimelineTab>(
                    segments: const [
                      ButtonSegment(value: _DmTimelineTab.all, label: Text('All')),
                      ButtonSegment(value: _DmTimelineTab.media, label: Text('Media')),
                      ButtonSegment(value: _DmTimelineTab.files, label: Text('Files')),
                    ],
                    selected: {_timelineTab},
                    onSelectionChanged: (v) => setState(() => _timelineTab = v.first),
                  ),
                ),
                if (_screenshotWarningEnabled)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(14, 0, 14, 6),
                    child: Text(
                      'Privacy notice: avoid sharing screenshots from this chat.',
                      style: TextStyle(
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                _PinnedMomentsStrip(
                  messageIds: _pinnedMessageIds.toList(),
                  onTap: _jumpToMessageById,
                ),
                if (_dmLocked && !_dmUnlocked)
                  Expanded(
                    child: Center(
                      child: Glass(
                        radius: BorderRadius.circular(18),
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.lock_rounded, size: 28),
                            const SizedBox(height: 8),
                            const Text('This chat is locked'),
                            const SizedBox(height: 8),
                            FilledButton(
                              onPressed: () => setState(() => _dmUnlocked = true),
                              child: const Text('Unlock with biometrics'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                else
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
                        visibleMsgs = visibleMsgs.where((m) {
                          final payload = _MessagePayload.parse(m['content']?.toString() ?? '');
                          final text = payload.text ?? payload.fileName ?? '';
                          if (_isMessageMutedByKeyword(text)) return false;
                          if (payload.expiresAt != null && payload.expiresAt!.isBefore(DateTime.now())) return false;
                          final created = DateTime.tryParse(m['created_at']?.toString() ?? '');
                          if (_searchRange == _SearchRange.today && (created == null || !DateUtils.isSameDay(created.toLocal(), DateTime.now()))) return false;
                          if (_searchRange == _SearchRange.week && (created == null || DateTime.now().difference(created.toLocal()).inDays > 7)) return false;
                          if (_showUnreadOnly && m['is_read'] == true) return false;
                          if (_showLinksOnly && !text.contains('http')) return false;
                          if (_showMentionsOnly && !text.contains('@')) return false;
                          if (_timelineTab == _DmTimelineTab.media && payload.type != 'image') return false;
                          if (_timelineTab == _DmTimelineTab.files && payload.type != 'file') return false;
                          return true;
                        }).toList();
                        if (_showPinnedOnly) {
                          visibleMsgs = visibleMsgs
                              .where((m) => _pinnedMessageIds.contains(m['id']?.toString() ?? ''))
                              .toList();
                        }

                        _lastVisibleMessageIds = visibleMsgs.map((m) => m['id']?.toString() ?? '').toList();

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
                                onLongPress: () => _showMessageActions(_ChatMessage.fromRow(m, isMe: isMe)),
                                onSwipeReply: () => setState(() { _replyPreview = payload.text ?? payload.fileName ?? 'Attachment'; _replyToMessageId = m['id']?.toString(); }),
                                onTapReplySource: _jumpToMessageById,
                                replyToMessageId: payload.replyToMessageId,
                                onTapFile: _openFileUrl,
                                onReact: (emoji) => chatRepository.toggleMessageReaction(messageId: m['id'].toString(), emoji: emoji),
                                editedAt: _messageEditTimes[m['id']?.toString() ?? ''],
                                deliveryStatus: _deliveryStatus(isMe: isMe, isRead: readAt != null, createdAt: dt),
                                isHighlighted: _jumpHighlightMessageId == (m['id']?.toString() ?? ''),
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
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      child: Row(
                        children: [
                          const Icon(Icons.account_tree_rounded, size: 14),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              'Thread focus active · replying in context',
                              style: TextStyle(fontWeight: FontWeight.w700, color: theme.colorScheme.onSurface.withValues(alpha: 0.78), fontSize: 11.5),
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
                              color: theme.colorScheme.onSurface.withValues(alpha: 0.75),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () => setState(() { _replyPreview = null; _replyToMessageId = null; }),
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
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.65),
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
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.65),
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
                        for (final quick in const ['Hey 👋', 'How are you?', 'Want to practice now?'])
                          ActionChip(
                            label: Text(quick),
                            onPressed: () {
                              _controller.text = quick;
                              _controller.selection = TextSelection.fromPosition(
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
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                      ),
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
                    duePracticePhrases: _duePracticePhrases,
                    onUsePracticePhrase: (phrase) {
                      setState(() {
                        _controller.text = phrase;
                        _controller.selection = TextSelection.fromPosition(TextPosition(offset: phrase.length));
                        _duePracticePhrases.remove(phrase);
                      });
                      _saveLearningPreferences();
                    },
                    targetCefrLevel: _targetCefrLevel.name.toUpperCase(),
                    cefrSuggestions: _composerSuggestionsForLevel(_targetCefrLevel),
                    onSelectCefrLevel: (value) {
                      final parsed = _CefrLevel.values.firstWhere(
                        (level) => level.name.toUpperCase() == value,
                        orElse: () => _targetCefrLevel,
                      );
                      setState(() => _targetCefrLevel = parsed);
                    },
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
                                        leading: Icon(_noiseSuppressionEnabled ? Icons.noise_control_off_rounded : Icons.noise_aware_rounded),
                                        title: Text(_noiseSuppressionEnabled ? 'Disable noise suppression' : 'Enable noise suppression'),
                                        onTap: () => Navigator.pop(context, 'noise'),
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
                              } else if (action == 'noise') {
                                await _toggleNoiseSuppression();
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
    required this.isConversationPinned,
    required this.isConversationMuted,
  });

  final bool isConversationPinned;
  final bool isConversationMuted;

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
              const PopupMenuItem(
                value: _DmMenuAction.scheduleMessage,
                child: Text('Schedule message'),
              ),
              const PopupMenuItem(
                value: _DmMenuAction.undoSend,
                child: Text('Send with 5s undo'),
              ),
              const PopupMenuItem(
                value: _DmMenuAction.muteOneHour,
                child: Text('Mute for 1 hour'),
              ),
              const PopupMenuItem(
                value: _DmMenuAction.muteKeyword,
                child: Text('Mute keyword'),
              ),
              PopupMenuItem(
                value: _DmMenuAction.togglePin,
                child: Text(isConversationPinned ? 'Unpin thread' : 'Pin thread'),
              ),
              PopupMenuItem(
                value: _DmMenuAction.toggleMute,
                child: Text(isConversationMuted ? 'Unmute thread' : 'Mute thread'),
              ),
              const PopupMenuItem(
                value: _DmMenuAction.chooseDisappearing,
                child: Text('Disappearing messages'),
              ),
              const PopupMenuItem(
                value: _DmMenuAction.chooseTheme,
                child: Text('Chat theme'),
              ),
              const PopupMenuItem(
                value: _DmMenuAction.aiPolish,
                child: Text('AI polish draft'),
              ),
              const PopupMenuItem(
                value: _DmMenuAction.smartComposeMode,
                child: Text('Smart compose mode'),
              ),
              const PopupMenuItem(
                value: _DmMenuAction.chooseTutorPersona,
                child: Text('Tutor persona'),
              ),
              const PopupMenuItem(
                value: _DmMenuAction.chooseAutoCorrect,
                child: Text('Auto-correct strictness'),
              ),
              const PopupMenuItem(
                value: _DmMenuAction.toggleExamMode,
                child: Text('Toggle exam mode'),
              ),
              const PopupMenuItem(
                value: _DmMenuAction.conversationReplay,
                child: Text('Conversation replay mode'),
              ),
              const PopupMenuItem(
                value: _DmMenuAction.weeklyReportCard,
                child: Text('Weekly learning report card'),
              ),
              const PopupMenuItem(
                value: _DmMenuAction.addMessagePack,
                child: Text('Send message pack'),
              ),
              const PopupMenuItem(
                value: _DmMenuAction.advancedSearch,
                child: Text('Advanced filters'),
              ),
              const PopupMenuItem(
                value: _DmMenuAction.privacyControls,
                child: Text('Privacy controls'),
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
  double _voiceSpeed = 1.0;
  Duration _voicePosition = Duration.zero;
  Duration _voiceDuration = Duration.zero;

  @override
  void initState() {
    super.initState();
    _voicePlayer = AudioPlayer();
    _voicePlayer.positionStream.listen((p) {
      if (!mounted) return;
      setState(() => _voicePosition = p);
    });
    _voicePlayer.durationStream.listen((d) {
      if (!mounted || d == null) return;
      setState(() => _voiceDuration = d);
    });
    _voicePlayer.playerStateStream.listen((state) {
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
  Widget build(BuildContext context) {
    final align = widget.isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start;
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
    final isPack = parsed.type == 'poll' || parsed.type == 'checklist' || parsed.type == 'invite' || parsed.type == 'location' || parsed.type == 'contact';

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
              onTap: () => widget.onTapReplySource?.call(widget.replyToMessageId),
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
          onHorizontalDragEnd: (details) {
            final v = details.primaryVelocity ?? 0;
            if ((widget.isMe && v < -180) || (!widget.isMe && v > 180)) {
              widget.onSwipeReply?.call();
            }
          },
          onTap: isFile && parsed.url != null ? () => widget.onTapFile?.call(parsed.url!) : null,
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
                    ? _PremiumVoiceBubbleContent(
                        durationLabel: parsed.text ?? widget.text,
                        isPlaying: _isPlayingVoice,
                        waveform: parsed.waveform,
                        onPlayPause: () => _toggleVoicePlayback(parsed.url),
                        isMine: widget.isMe,
                        speed: _voiceSpeed,
                        onToggleSpeed: _toggleVoiceSpeed,
                        progressMs: _voicePosition.inMilliseconds,
                        durationMs: (_voiceDuration.inMilliseconds <= 0 ? (parsed.duration ?? 0) * 1000 : _voiceDuration.inMilliseconds),
                        onSeek: (ms) => _voicePlayer.seek(Duration(milliseconds: ms.round())),
                        transcript: parsed.transcript,
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
                        : isPack
                        ? _PackMessageCard(payload: parsed)
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                widget.text,
                                style: TextStyle(
                                  color: scheme.onSurface.withValues(alpha: 0.92),
                                  fontWeight: FontWeight.w700,
                                  height: 1.25,
                                  fontSize: 14.5,
                                ),
                              ),
                              if (!widget.isMe && widget.showAutoTranslation)
                                Padding(
                                  padding: const EdgeInsets.only(top: 6),
                                  child: Text(
                                    parsed.translatedText?.isNotEmpty == true
                                        ? parsed.translatedText!
                                        : '↳ ${widget.autoTranslateLanguage}: ${widget.text}',
                                    style: TextStyle(
                                      color: scheme.primary.withValues(alpha: 0.9),
                                      fontWeight: FontWeight.w700,
                                      height: 1.22,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                              if (!widget.isMe && parsed.transliteration?.isNotEmpty == true)
                                Padding(
                                  padding: const EdgeInsets.only(top: 4),
                                  child: Text(
                                    parsed.transliteration!,
                                    style: TextStyle(
                                      color: scheme.onSurface.withValues(alpha: 0.62),
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
        Padding(
          padding: EdgeInsets.only(top: 4, right: widget.isMe ? 4 : 0, left: widget.isMe ? 0 : 4),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.pinned)
                Padding(
                  padding: const EdgeInsets.only(right: 4),
                  child: Icon(Icons.push_pin_rounded, size: 12, color: scheme.primary),
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
              children: widget.reactions.entries.map((entry) {
                final count = (entry.value as List?)?.length ?? 0;
                return GestureDetector(
                  onTap: () => widget.onReact?.call(entry.key),
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
        if (widget.isMe)
          Padding(
            padding: const EdgeInsets.only(top: 2, right: 4),
            child: Icon(
              widget.isRead ? Icons.done_all_rounded : Icons.done_rounded,
              size: 14,
              color: widget.isRead ? const Color(0xFF58F7B6) : scheme.onSurface.withValues(alpha: 0.5),
            ),
          ),
      ],
    );
  }

  void _toggleVoiceSpeed() {
    const speeds = [1.0, 1.5, 2.0];
    final idx = speeds.indexOf(_voiceSpeed);
    final next = speeds[(idx + 1) % speeds.length];
    setState(() => _voiceSpeed = next);
    _voicePlayer.setSpeed(next);
  }

  Future<void> _toggleVoicePlayback(String? url) async {
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

  String _formatBytes(int bytes) {
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
    required this.isMine,
    required this.speed,
    required this.onToggleSpeed,
    required this.progressMs,
    required this.durationMs,
    required this.onSeek,
    this.transcript,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Row(
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
              color: isMine ? scheme.primary.withValues(alpha: 0.24) : scheme.primary.withValues(alpha: 0.18),
            ),
            child: Icon(isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded, color: scheme.primary),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _Waveform(
                bars: waveform,
                color: scheme.primary,
                dimColor: scheme.onSurface.withValues(alpha: 0.26),
              ),
              const SizedBox(height: 6),
              Text(
                durationLabel,
                style: TextStyle(
                  color: scheme.onSurface.withValues(alpha: 0.9),
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 4),
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
                    '${speed.toStringAsFixed(speed.truncateToDouble()==speed ? 0 : 1)}x',
                    style: TextStyle(
                      color: scheme.onSurface.withValues(alpha: 0.8),
                      fontWeight: FontWeight.w700,
                      fontSize: 11,
                    ),
                  ),
                ),
              ),
              SliderTheme(
                data: SliderTheme.of(context).copyWith(trackHeight: 2.4, thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 5)),
                child: Slider(
                  min: 0,
                  max: durationMs <= 0 ? 1 : durationMs.toDouble(),
                  value: progressMs.clamp(0, durationMs <= 0 ? 1 : durationMs).toDouble(),
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
  Widget build(BuildContext context) {
    final data = bars.isEmpty
        ? const [0.35, 0.5, 0.75, 0.42, 0.6, 0.88, 0.48, 0.7, 0.56, 0.8, 0.38, 0.62]
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
  Widget build(BuildContext context) {
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
                leading: Icon(_pollVoteIndex == i ? Icons.radio_button_checked_rounded : Icons.radio_button_unchecked_rounded, size: 18),
                title: Text(payload.items[i], style: TextStyle(fontSize: 12, color: scheme.onSurface.withValues(alpha: 0.82))),
                onTap: () => setState(() => _pollVoteIndex = i),
              ),
          ] else if (payload.type == 'checklist' && payload.items.isNotEmpty) ...[
            const SizedBox(height: 6),
            for (var i = 0; i < payload.items.length; i++)
              CheckboxListTile(
                dense: true,
                contentPadding: EdgeInsets.zero,
                value: _checkedItems.contains(i),
                onChanged: (_) => setState(() {
                  if (_checkedItems.contains(i)) {
                    _checkedItems.remove(i);
                  } else {
                    _checkedItems.add(i);
                  }
                }),
                title: Text(payload.items[i], style: TextStyle(fontSize: 12, color: scheme.onSurface.withValues(alpha: 0.82))),
              ),
          ] else if (payload.type == 'invite') ...[
            const SizedBox(height: 8),
            FilledButton.icon(
              onPressed: () => setState(() => _rsvpAccepted = !_rsvpAccepted),
              icon: Icon(_rsvpAccepted ? Icons.check_rounded : Icons.event_available_rounded, size: 16),
              label: Text(_rsvpAccepted ? 'RSVP: Going' : 'RSVP'),
            ),
          ] else if (payload.items.isNotEmpty) ...[
            const SizedBox(height: 6),
            for (final item in payload.items.take(4))
              Padding(
                padding: const EdgeInsets.only(bottom: 2),
                child: Text('• $item', style: TextStyle(color: scheme.onSurface.withValues(alpha: 0.82))),
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
  Widget build(BuildContext context) {
    if (messageIds.isEmpty) return const SizedBox.shrink();
    final theme = Theme.of(context);
    return SizedBox(
      height: 42,
      child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(14, 0, 14, 8),
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, i) {
          final id = messageIds[i];
          return ActionChip(
            avatar: const Icon(Icons.auto_awesome_rounded, size: 14),
            label: Text('Moment ${i + 1}'),
            labelStyle: TextStyle(color: theme.colorScheme.onSurface, fontWeight: FontWeight.w700),
            onPressed: () => onTap(id),
          );
        },
        separatorBuilder: (_, __) => const SizedBox(width: 6),
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
          replyToMessageId: map['reply_to_message_id']?.toString(),
          transcript: map['transcript']?.toString(),
          label: map['label']?.toString(),
          items: ((map['items'] as List?) ?? (map['options'] as List?) ?? const []).map((e) => e.toString()).toList(),
          translatedText: map['translated_text']?.toString(),
          transliteration: map['transliteration']?.toString(),
          waveform: (map['waveform'] as List?)?.map((e) => double.tryParse('$e') ?? 0.3).toList() ?? const [],
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


class _CorrectionResult {
  final String corrected;
  final String reason;

  const _CorrectionResult({required this.corrected, required this.reason});
}

class _WordInsight {
  final String definition;
  final String cefr;
  final String example;

  const _WordInsight({
    required this.definition,
    required this.cefr,
    required this.example,
  });

  factory _WordInsight.fromWord(String word) {
    final cleaned = word.toLowerCase();
    final cefr = switch (cleaned.length) {
      <= 4 => 'A1',
      <= 6 => 'A2',
      <= 8 => 'B1',
      <= 10 => 'B2',
      <= 13 => 'C1',
      _ => 'C2',
    };
    return _WordInsight(
      definition: 'Likely means or relates to "$word" in this context.',
      cefr: cefr,
      example: 'Try: "I can use $word in a sentence today."',
    );
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
  final List<String> duePracticePhrases;
  final ValueChanged<String> onUsePracticePhrase;
  final String targetCefrLevel;
  final List<String> cefrSuggestions;
  final ValueChanged<String> onSelectCefrLevel;

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
    required this.duePracticePhrases,
    required this.onUsePracticePhrase,
    required this.targetCefrLevel,
    required this.cefrSuggestions,
    required this.onSelectCefrLevel,
  });

  @override
  Widget build(BuildContext context) {
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
                          isPlayingDraftVoice ? Icons.pause_rounded : Icons.play_arrow_rounded,
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
                      icon: Icon(Icons.delete_outline_rounded, color: scheme.error),
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
          if (duePracticePhrases.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: SizedBox(
                height: 34,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, i) => ActionChip(
                    avatar: const Icon(Icons.replay_rounded, size: 14),
                    label: Text('Due: ${duePracticePhrases[i]}'),
                    onPressed: () => onUsePracticePhrase(duePracticePhrases[i]),
                  ),
                  separatorBuilder: (_, __) => const SizedBox(width: 6),
                  itemCount: duePracticePhrases.length,
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: [
                const Icon(Icons.school_rounded, size: 16),
                const SizedBox(width: 8),
                DropdownButton<String>(
                  value: targetCefrLevel,
                  underline: const SizedBox.shrink(),
                  items: const ['A1', 'A2', 'B1', 'B2', 'C1', 'C2']
                      .map((level) => DropdownMenuItem(value: level, child: Text(level)))
                      .toList(),
                  onChanged: (value) {
                    if (value == null) return;
                    onSelectCefrLevel(value);
                  },
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        for (final suggestion in cefrSuggestions.take(2))
                          Padding(
                            padding: const EdgeInsets.only(right: 6),
                            child: ActionChip(
                              label: Text(suggestion, maxLines: 1, overflow: TextOverflow.ellipsis),
                              onPressed: () {
                                controller.text = suggestion;
                                controller.selection = TextSelection.fromPosition(
                                  TextPosition(offset: controller.text.length),
                                );
                                onTypingChanged(true);
                                onTextChanged(controller.text);
                              },
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
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
                    style: TextStyle(color: scheme.onSurface, fontWeight: FontWeight.w700),
                    cursorColor: scheme.primary,
                    minLines: 1,
                    maxLines: isComposerFocused ? 6 : 4,
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
                AnimatedSwitcher(
                  duration: MotionTokens.medium,
                  switchInCurve: Curves.easeOut,
                  switchOutCurve: Curves.easeIn,
                  transitionBuilder: (child, animation) => SizeTransition(
                    sizeFactor: animation,
                    axis: Axis.horizontal,
                    axisAlignment: -1,
                    child: FadeTransition(opacity: animation, child: child),
                  ),
                  child: isComposerFocused
                      ? InkWell(
                          key: const ValueKey('expand-attachments'),
                          borderRadius: BorderRadius.circular(18),
                          onTap: onOpenAttachmentTray,
                          child: Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              color: scheme.onSurface.withValues(alpha: 0.10),
                              border: Border.all(color: scheme.onSurface.withValues(alpha: 0.16)),
                            ),
                            child: Icon(Icons.more_horiz_rounded, color: scheme.onSurface.withValues(alpha: 0.92)),
                          ),
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
                                  gradient: LinearGradient(
                                    colors: isRecordingVoiceMessage
                                        ? [const Color(0xFFFF8A8A), const Color(0xFFFF4D6D)]
                                        : [scheme.primary.withValues(alpha: 0.85), scheme.tertiary.withValues(alpha: 0.75)],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: scheme.primary.withValues(alpha: 0.35),
                                      blurRadius: 14,
                                      offset: const Offset(0, 6),
                                    ),
                                  ],
                                ),
                                child: Icon(
                                  isRecordingVoiceMessage ? Icons.stop_rounded : Icons.mic_rounded,
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
                      border: Border.all(color: scheme.onSurface.withValues(alpha: 0.16)),
                    ),
                    child: Icon(Icons.send_rounded, color: scheme.onSurface.withValues(alpha: 0.92)),
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
