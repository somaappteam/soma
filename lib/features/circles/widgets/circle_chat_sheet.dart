import 'dart:async';
import 'package:flutter/material.dart';
import 'package:soma/core/theme/motion.dart';
import 'package:soma/core/theme/tokens.dart';
import 'package:soma/core/widgets/glass.dart';
import 'package:soma/core/widgets/pressable_scale.dart';
import 'package:soma/data/circle_chat_repository.dart';
import 'package:soma/data/profile_repository.dart';
import 'package:soma/l10n/gen/app_localizations.dart';

class CircleChatSheet extends StatefulWidget {
  const CircleChatSheet({
    super.key,
    required this.circleId,
    required this.meId,
  });

  final String circleId;
  final String? meId;

  @override
  State<CircleChatSheet> createState() => _CircleChatSheetState();
}

class _CircleChatSheetState extends State<CircleChatSheet> {
  final _controller = TextEditingController();
  final _scroll = ScrollController();
  late final Stream<List<Map<String, dynamic>>> _messagesStream;
  late final Stream<Map<String, dynamic>?> _chatConfigStream;
  final Map<String, Map<String, dynamic>> _profiles = {};
  final Set<String> _pendingReadIds = <String>{};
  Timer? _readDebounce;
  bool _loadingProfiles = false;
  DateTime? _lastSentAt;

  @override
  void initState() {
    super.initState();
    _messagesStream = circleChatRepository.getMessagesStream(widget.circleId);
    _chatConfigStream = circleChatRepository.streamCircleChatConfig(widget.circleId);
  }

  @override
  void dispose() {
    _readDebounce?.cancel();
    _controller.dispose();
    _scroll.dispose();
    super.dispose();
  }

  Future<void> _send({int slowModeSeconds = 0, Set<String> mutedIds = const <String>{}}) async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    if (widget.meId != null && mutedIds.contains(widget.meId)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Host muted your chat in this circle.')),
      );
      return;
    }
    if (_lastSentAt != null && slowModeSeconds > 0) {
      final elapsed = DateTime.now().difference(_lastSentAt!).inSeconds;
      if (elapsed < slowModeSeconds) {
        final wait = slowModeSeconds - elapsed;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Slow mode: wait ${wait}s before sending again.')),
        );
        return;
      }
    }

    _controller.clear();

    try {
      await circleChatRepository.sendMessage(
        circleId: widget.circleId,
        content: text,
      );
      _lastSentAt = DateTime.now();
      _scrollToBottom();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  void _queueRead(String messageId) {
    _pendingReadIds.add(messageId);
    _readDebounce?.cancel();
    _readDebounce = Timer(const Duration(milliseconds: 400), () async {
      final ids = _pendingReadIds.toList();
      _pendingReadIds.clear();
      await circleChatRepository.markReadBatch(ids);
    });
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !_scroll.hasClients) return;
      _scroll.animateTo(
        _scroll.position.maxScrollExtent + 80,
        duration: MotionTokens.short,
        curve: MotionTokens.standardCurve,
      );
    });
  }

  Future<void> _loadMissingProfiles(List<Map<String, dynamic>> messages) async {
    if (_loadingProfiles) return;
    final ids = messages
        .map((m) => m['sender_id']?.toString())
        .whereType<String>()
        .where((id) => !_profiles.containsKey(id))
        .toSet()
        .toList();
    if (ids.isEmpty) return;
    _loadingProfiles = true;
    try {
      final profiles = await profileRepository.getProfilesByIds(ids);
      if (!mounted) return;
      setState(() {
        for (final p in profiles) {
          final id = p['id']?.toString();
          if (id != null) _profiles[id] = p;
        }
      });
    } finally {
      _loadingProfiles = false;
    }
  }

  String _nameFor(String senderId) {
    final profile = _profiles[senderId];
    return profile?['username'] ?? profile?['display_name'] ?? 'User';
  }

  Future<void> _showMessageActions({
    required String messageId,
    required String senderId,
    required bool isHost,
    required bool isMe,
    required String content,
  }) async {
    await showModalBottomSheet<void>(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.emoji_emotions_outlined),
              title: const Text('React 👍'),
              onTap: () async {
                Navigator.pop(context);
                await circleChatRepository.toggleReaction(messageId: messageId, emoji: '👍');
              },
            ),
            ListTile(
              leading: const Icon(Icons.emoji_emotions_outlined),
              title: const Text('React 🔥'),
              onTap: () async {
                Navigator.pop(context);
                await circleChatRepository.toggleReaction(messageId: messageId, emoji: '🔥');
              },
            ),
            if (isHost)
              ListTile(
                leading: const Icon(Icons.push_pin_outlined),
                title: const Text('Pin as highlight'),
                onTap: () async {
                  Navigator.pop(context);
                  await circleChatRepository.pinHighlight(circleId: widget.circleId, message: content);
                },
              ),
            if (isHost && !isMe)
              ListTile(
                leading: const Icon(Icons.volume_off_outlined),
                title: const Text('Mute user chat'),
                onTap: () async {
                  Navigator.pop(context);
                  await circleChatRepository.setUserMutedInCircle(
                    circleId: widget.circleId,
                    targetUserId: senderId,
                    muted: true,
                  );
                },
              ),
            if (isMe)
              ListTile(
                leading: const Icon(Icons.delete_outline_rounded),
                title: const Text('Delete my message'),
                onTap: () async {
                  Navigator.pop(context);
                  await circleChatRepository.deleteMessage(messageId);
                },
              ),
            if (isHost)
              ListTile(
                leading: const Icon(Icons.gpp_bad_outlined),
                title: const Text('Delete message (host)'),
                onTap: () async {
                  Navigator.pop(context);
                  await circleChatRepository.hostDeleteMessage(messageId);
                },
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Material(
      color: const Color(0xFF0E0F1A),
      child: SafeArea(
        child: StreamBuilder<Map<String, dynamic>?>(
          stream: _chatConfigStream,
          builder: (context, configSnapshot) {
            final config = configSnapshot.data ?? const <String, dynamic>{};
            final hostId = config['host_id']?.toString();
            final isHost = hostId != null && hostId == widget.meId;
            final mutedIds = (config['chat_muted_user_ids'] as List?)
                    ?.map((e) => e.toString())
                    .toSet() ??
                <String>{};
            final slowModeSeconds = config['chat_slow_mode_seconds'] is int
                ? config['chat_slow_mode_seconds'] as int
                : int.tryParse(config['chat_slow_mode_seconds']?.toString() ?? '0') ?? 0;
            final highlighted = config['chat_highlight_text']?.toString() ?? '';

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          l10n.circlesLiveChatTitle,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                      if (isHost)
                        PopupMenuButton<int>(
                          icon: const Icon(Icons.tune_rounded, color: Colors.white),
                          onSelected: (value) async {
                            await circleChatRepository.setSlowMode(
                              circleId: widget.circleId,
                              seconds: value,
                            );
                          },
                          itemBuilder: (_) => const [
                            PopupMenuItem(value: 0, child: Text('Slow mode off')),
                            PopupMenuItem(value: 5, child: Text('Slow mode 5s')),
                            PopupMenuItem(value: 10, child: Text('Slow mode 10s')),
                          ],
                        ),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.close_rounded, color: Colors.white),
                      ),
                    ],
                  ),
                ),
                if (highlighted.trim().isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                    child: Glass(
                      radius: BorderRadius.circular(12),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      child: Row(
                        children: [
                          const Icon(Icons.push_pin_rounded, size: 16, color: Colors.white),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              highlighted,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                const Divider(height: 1, color: Color(0x1AFFFFFF)),
                Expanded(
                  child: StreamBuilder<List<Map<String, dynamic>>>(
                    stream: _messagesStream,
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Center(
                          child: Text(
                            snapshot.error.toString(),
                            style: const TextStyle(color: Colors.white70),
                          ),
                        );
                      }
                      if (!snapshot.hasData) {
                        return const Center(
                          child: CircularProgressIndicator(
                            color: Color(0xFF2AFADF),
                          ),
                        );
                      }
                      final messages = snapshot.data!;
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        _loadMissingProfiles(messages);
                        _scrollToBottom();
                      });

                      if (messages.isEmpty) {
                        return Center(
                          child: Text(
                            l10n.circlesLiveChatEmpty,
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.6),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        );
                      }

                      return ListView.builder(
                        controller: _scroll,
                        padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                        itemCount: messages.length,
                        itemBuilder: (context, index) {
                          final message = messages[index];
                          final id = message['id']?.toString() ?? '';
                          final senderId = message['sender_id']?.toString() ?? '';
                          final isMe = senderId.isNotEmpty && senderId == widget.meId;
                          final senderName = _nameFor(senderId);
                          final content = message['content']?.toString() ?? '';
                          final readBy = (message['read_by'] as List?)?.map((e) => e.toString()).toSet() ?? {};
                          final reactions = (message['reactions'] as Map<String, dynamic>?) ?? const {};

                          if (!isMe && widget.meId != null && !readBy.contains(widget.meId)) {
                            _queueRead(id);
                          }

                          return Align(
                            alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: Column(
                                crossAxisAlignment:
                                    isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                                children: [
                                  if (!isMe)
                                    Padding(
                                      padding: const EdgeInsets.only(bottom: 4),
                                      child: Text(
                                        senderName,
                                        style: TextStyle(
                                          color: Colors.white.withValues(alpha: 0.6),
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  GestureDetector(
                                    onLongPress: () => _showMessageActions(
                                      messageId: id,
                                      senderId: senderId,
                                      isHost: isHost,
                                      isMe: isMe,
                                      content: content,
                                    ),
                                    child: CircleChatBubble(
                                      text: content,
                                      isMe: isMe,
                                      isRead: readBy.length > 1,
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
                                            onTap: () => circleChatRepository.toggleReaction(
                                              messageId: id,
                                              emoji: entry.key,
                                            ),
                                            child: Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                              decoration: BoxDecoration(
                                                color: Colors.white.withValues(alpha: 0.1),
                                                borderRadius: BorderRadius.circular(12),
                                              ),
                                              child: Text('${entry.key} $count', style: const TextStyle(color: Colors.white)),
                                            ),
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
                if (slowModeSeconds > 0)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Text(
                      'Slow mode is on (${slowModeSeconds}s)',
                      style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontWeight: FontWeight.w600),
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 48,
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            color: T.fieldFill,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
                          ),
                          child: TextField(
                            controller: _controller,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                            cursorColor: Colors.white,
                            decoration: InputDecoration(
                              hintText: l10n.circlesLiveChatPlaceholder,
                              hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.5)),
                              border: InputBorder.none,
                            ),
                            textInputAction: TextInputAction.send,
                            onSubmitted: (_) => _send(
                              slowModeSeconds: slowModeSeconds,
                              mutedIds: mutedIds,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      PressableScale(
                        onTap: () => _send(
                          slowModeSeconds: slowModeSeconds,
                          mutedIds: mutedIds,
                        ),
                        child: Glass(
                          radius: BorderRadius.circular(16),
                          padding: const EdgeInsets.all(12),
                          child: Text(
                            l10n.send,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class CircleChatBubble extends StatelessWidget {
  const CircleChatBubble({
    super.key,
    required this.text,
    required this.isMe,
    this.isRead = false,
  });

  final String text;
  final bool isMe;
  final bool isRead;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.only(
      topLeft: const Radius.circular(18),
      topRight: const Radius.circular(18),
      bottomLeft: isMe ? const Radius.circular(18) : const Radius.circular(4),
      bottomRight: isMe ? const Radius.circular(4) : const Radius.circular(18),
    );

    return Container(
      padding: const EdgeInsets.fromLTRB(14, 10, 14, 10),
      constraints: const BoxConstraints(maxWidth: 280),
      decoration: BoxDecoration(
        color: isMe ? const Color(0xFF5A67FF) : Colors.white.withValues(alpha: 0.12),
        borderRadius: radius,
        border: Border.all(
          color: isMe ? Colors.white.withValues(alpha: 0.0) : Colors.white.withValues(alpha: 0.1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            text,
            style: TextStyle(
              color: isMe ? Colors.white : Colors.white.withValues(alpha: 0.95),
              fontWeight: FontWeight.w500,
              fontSize: 15,
              height: 1.3,
            ),
          ),
          if (isMe) ...[
            const SizedBox(height: 2),
            Icon(
              isRead ? Icons.done_all_rounded : Icons.check_rounded,
              size: 16,
              color: isRead ? const Color(0xFF4DE1F8) : Colors.white.withValues(alpha: 0.6),
            ),
          ],
        ],
      ),
    );
  }
}
