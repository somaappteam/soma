import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/theme/motion.dart';

import '../../core/widgets/glass.dart';
import '../../core/widgets/staggered_in.dart';
import '../../data/agora_voice_service.dart';
import '../../data/chat_repository.dart';
import '../../data/presence_repository.dart';
import '../../data/profile_repository.dart';
import 'package:soma/l10n/gen/app_localizations.dart';

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
  static const int _maxImageBytes = 2 * 1024 * 1024; // 2 MB
  static const int _maxTextChars = 1200;

  final _controller = TextEditingController();
  final _scroll = ScrollController();
  final _imagePicker = ImagePicker();
  late Stream<List<Map<String, dynamic>>> _messagesStream;
  late Stream<bool> _onlineStream;
  bool _showOnlineIndicator = true;
  bool _readSyncInFlight = false;
  bool _inVoiceCall = false;
  bool _isRecordingVoiceMessage = false;
  int _voiceRecordElapsedSeconds = 0;
  Timer? _voiceRecordTimer;
  Timer? _callTimer;
  int _callElapsedSeconds = 0;
  String? _replyPreview;

  String get _myUserId => chatRepository.currentUserId ?? widget.meId;

  @override
  void initState() {
    super.initState();
    _messagesStream = chatRepository.getMessagesStream(widget.otherId);
    _onlineStream = presenceRepository.streamOnlineStatus(widget.otherId);
    _loadOnlineVisibility();
    _markConversationAsRead();
    // Auto-scroll on new messages can be handled in builder or listener,
    // but simplified approach: just builder.
  }

  @override
  void dispose() {
    if (_inVoiceCall) {
      agoraVoiceService.disconnect();
    }
    _voiceRecordTimer?.cancel();
    _callTimer?.cancel();
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
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    if (text.length > _maxTextChars) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Message too long. Keep it under 1200 characters.')),
      );
      return;
    }

    final payload = <String, dynamic>{
      'type': 'text',
      'text': text,
      if (_replyPreview != null) 'reply_to': _replyPreview,
    };
    chatRepository.sendMessage(widget.otherId, jsonEncode(payload));
    _controller.clear();
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

  Future<void> _loadOnlineVisibility() async {
    try {
      final data = await profileRepository.fetchProfile(userId: widget.otherId);
      if (!mounted || data == null) return;
      setState(() => _showOnlineIndicator = data.showOnlineStatus);
    } catch (_) {
      // ignore
    }
  }

  String _dmVoiceChannelId() {
    final ids = [_myUserId, widget.otherId]..sort();
    return 'dm_${ids[0]}_${ids[1]}';
  }

  Future<void> _toggleVoiceCall() async {
    final l10n = AppLocalizations.of(context);
    if (_inVoiceCall) {
      await agoraVoiceService.disconnect();
      if (!mounted) return;
      _callTimer?.cancel();
      setState(() => _inVoiceCall = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Voice call ended')),
      );
      return;
    }

    try {
      await agoraVoiceService.connect(circleId: _dmVoiceChannelId(), asSpeaker: true);
      if (!mounted) return;
      _callTimer?.cancel();
      setState(() {
        _inVoiceCall = true;
        _callElapsedSeconds = 0;
      });
      _callTimer = Timer.periodic(const Duration(seconds: 1), (_) {
        if (!mounted || !_inVoiceCall) return;
        setState(() => _callElapsedSeconds += 1);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Connecting voice call...')),
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.chatCallLater)),
      );
    }
  }

  Future<void> _sendVoiceMessage(int durationSeconds) async {
    final clampedDuration = durationSeconds.clamp(1, 60);
    final mm = (clampedDuration ~/ 60).toString().padLeft(2, '0');
    final ss = (clampedDuration % 60).toString().padLeft(2, '0');
    await chatRepository.sendMessage(
      widget.otherId,
      jsonEncode({'type': 'voice', 'duration': clampedDuration, 'label': '$mm:$ss'}),
    );
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Voice message sent')),
    );
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
      if (nextValue >= 60) {
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
        const SnackBar(content: Text('Voice messages are limited to 1 minute.')),
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
        maxWidth: 1440,
      );
      if (picked == null || !mounted) return;

      final bytes = await picked.readAsBytes();
      if (bytes.length > _maxImageBytes) {
        if (!mounted) return;
        final mb = (bytes.length / (1024 * 1024)).toStringAsFixed(1);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Image is ${mb}MB. Max allowed is 2MB.')),
        );
        return;
      }

      final path = 'chat_media/$uid/${DateTime.now().millisecondsSinceEpoch}.jpg';
      final storage = Supabase.instance.client.storage.from('avatars');
      await storage.uploadBinary(
        path,
        bytes,
        fileOptions: const FileOptions(contentType: 'image/jpeg', upsert: true),
      );
      final publicUrl = storage.getPublicUrl(path);
      await chatRepository.sendMessage(
        widget.otherId,
        jsonEncode({'type': 'image', 'url': publicUrl}),
      );

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

  Future<void> _showMessageActions(_ChatMessage msg) async {
    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.reply_rounded),
              title: const Text('Reply'),
              onTap: () {
                Navigator.pop(context);
                setState(() => _replyPreview = msg.previewText);
              },
            ),
            if (msg.isMine)
              ListTile(
                leading: const Icon(Icons.delete_outline_rounded),
                title: const Text('Unsend'),
                onTap: () async {
                  Navigator.pop(context);
                  await chatRepository.deleteMessageById(msg.id);
                },
              )
            else
              ListTile(
                leading: const Icon(Icons.flag_outlined),
                title: const Text('Report'),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Report submitted')),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
            children: [
              _showOnlineIndicator
                  ? StreamBuilder<bool>(
                      stream: _onlineStream,
                      builder: (context, snapshot) {
                        return _TopBar(
                          title: widget.otherName,
                          showOnlineIndicator: snapshot.data == true,
                          onBack: () => Navigator.pop(context),
                          onCall: _toggleVoiceCall,
                          isInCall: _inVoiceCall,
                          callDuration: _callElapsedSeconds,
                        );
                      },
                    )
                  : _TopBar(
                      title: widget.otherName,
                      showOnlineIndicator: false,
                      onBack: () => Navigator.pop(context),
                      onCall: _toggleVoiceCall,
                      isInCall: _inVoiceCall,
                      callDuration: _callElapsedSeconds,
                    ),
              const SizedBox(height: 8),
              Expanded(
                child: StreamBuilder<List<Map<String, dynamic>>>(
                    stream: _messagesStream,
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Center(
                            child: Text("Error: ${snapshot.error}",
                                style: TextStyle(color: Theme.of(context).colorScheme.onSurface)));
                      }
                      if (!snapshot.hasData) {
                        return const Center(
                            child: CircularProgressIndicator(
                                color: Color(0xFF2AFADF)));
                      }

                      final msgs = snapshot.data!;
                      final hasUnread = msgs.any((m) => m['receiver_id'] == _myUserId && (m['is_read'] != true && m['is_read'] != 1));
                      if (hasUnread) {
                        _markConversationAsRead();
                      }
                      if (msgs.isEmpty) {
                        return Center(
                            child: Text("Say hi to ${widget.otherName}! 👋",
                                style: TextStyle(
                                    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5))));
                      }

                      return ListView.builder(
                        controller: _scroll,
                        padding: const EdgeInsets.fromLTRB(14, 10, 14, 10),
                        itemCount: msgs.length,
                        itemBuilder: (context, i) {
                          final m = msgs[i];
                          final senderId = m['sender_id'];
                          final isMe = senderId == _myUserId;
                          final parsed = _ChatMessage.fromRow(m, isMe: isMe);
                          // Supabase returns ISO string
                          final created =
                              DateTime.parse(m['created_at']).toLocal();

                          // Time logic can look at previous message
                          bool showTime = i == 0;
                          if (i > 0) {
                            final prev =
                                DateTime.parse(msgs[i - 1]['created_at'])
                                    .toLocal();
                            if (created.difference(prev).inMinutes.abs() > 10) {
                              showTime = true;
                            }
                          }

                          return StaggeredIn(
                            index: i,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                if (showTime) ...[
                                  const SizedBox(height: 6),
                                  Align(
                                    alignment: Alignment.center,
                                    child: _TimeChip(time: _fmtTime(created)),
                                  ),
                                  const SizedBox(height: 8),
                                ],
                                Align(
                                  alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                                  child: _Bubble(
                                    text: parsed.previewText,
                                    rawContent: parsed.rawContent,
                                    isMe: isMe,
                                    isRead: m['is_read'] == true || m['is_read'] == 1,
                                    onLongPress: () => _showMessageActions(parsed),
                                  ),
                                ),
                                const SizedBox(height: 10),
                              ],
                            ),
                          );
                        },
                      );
                    }),
              ),
              if (_replyPreview != null)
                Padding(
                  padding: const EdgeInsets.fromLTRB(14, 0, 14, 6),
                  child: Glass(
                    radius: BorderRadius.circular(12),
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Replying to: $_replyPreview',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.8),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () => setState(() => _replyPreview = null),
                          child: const Icon(Icons.close_rounded, size: 18),
                        ),
                      ],
                    ),
                  ),
                ),
              _InputBar(
                controller: _controller,
                onSend: _send,
                onVoiceMessage: () {
                  _handleVoiceMessageTap();
                },
                onSendImage: _pickAndSendImage,
                isRecordingVoiceMessage: _isRecordingVoiceMessage,
                recordingSeconds: _voiceRecordElapsedSeconds,
              ),
            ],
          ),
      ),
    );
  }

  String _fmtTime(DateTime dt) {
    final hh = dt.hour.toString().padLeft(2, '0');
    final mm = dt.minute.toString().padLeft(2, '0');
    return "$hh:$mm";
  }
}

// ---------------- UI pieces ----------------

class _TopBar extends StatelessWidget {
  final String title;
  final bool showOnlineIndicator;
  final VoidCallback onBack;
  final VoidCallback onCall;
  final bool isInCall;
  final int callDuration;

  const _TopBar({
    required this.title,
    required this.showOnlineIndicator,
    required this.onBack,
    required this.onCall,
    required this.isInCall,
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                if (isInCall)
                  Text(
                    'In call ${_fmtCallDuration(callDuration)}',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
              ],
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

class _TimeChip extends StatelessWidget {
  final String time;
  const _TimeChip({required this.time});

  @override
  Widget build(BuildContext context) {
    return Glass(
      radius: BorderRadius.circular(999),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Text(
        time,
        style: TextStyle(
          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.70),
          fontSize: 12,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class _Bubble extends StatelessWidget {
  final String text;
  final String rawContent;
  final bool isMe;
  final bool isRead;
  final VoidCallback? onLongPress;

  const _Bubble({
    required this.text,
    required this.rawContent,
    required this.isMe,
    required this.isRead,
    this.onLongPress,
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

    return Column(
      crossAxisAlignment: align,
      children: [
        GestureDetector(
          onLongPress: onLongPress,
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
        if (isMe)
          Padding(
            padding: const EdgeInsets.only(top: 4, right: 4),
            child: Icon(
              isRead ? Icons.done_all_rounded : Icons.done_rounded,
              size: 14,
              color: isRead ? const Color(0xFF58F7B6) : scheme.onSurface.withValues(alpha: 0.5),
            ),
          ),
      ],
    );
  }
}

class _MessagePayload {
  final String type;
  final String? text;
  final String? url;
  final int? duration;

  const _MessagePayload({required this.type, this.text, this.url, this.duration});

  static _MessagePayload parse(String raw) {
    try {
      final map = jsonDecode(raw);
      if (map is Map<String, dynamic>) {
        return _MessagePayload(
          type: map['type']?.toString() ?? 'text',
          text: map['text']?.toString() ?? map['label']?.toString(),
          url: map['url']?.toString(),
          duration: map['duration'] is int ? map['duration'] as int : int.tryParse('${map['duration']}'),
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

  const _ChatMessage({
    required this.id,
    required this.isMine,
    required this.previewText,
    required this.rawContent,
  });

  factory _ChatMessage.fromRow(Map<String, dynamic> row, {required bool isMe}) {
    final raw = row['content']?.toString() ?? '';
    final payload = _MessagePayload.parse(raw);
    final preview = switch (payload.type) {
      'image' => 'Photo',
      'voice' => 'Voice message ${payload.text ?? ''}'.trim(),
      _ => payload.text ?? raw,
    };

    return _ChatMessage(
      id: row['id']?.toString() ?? '',
      isMine: isMe,
      previewText: preview,
      rawContent: raw,
    );
  }
}

class _InputBar extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSend;
  final VoidCallback onVoiceMessage;
  final VoidCallback onSendImage;
  final bool isRecordingVoiceMessage;
  final int recordingSeconds;

  const _InputBar({
    required this.controller,
    required this.onSend,
    required this.onVoiceMessage,
    required this.onSendImage,
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
