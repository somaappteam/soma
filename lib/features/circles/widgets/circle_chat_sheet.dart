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
  final Map<String, Map<String, dynamic>> _profiles = {};
  bool _loadingProfiles = false;

  @override
  void initState() {
    super.initState();
    _messagesStream = circleChatRepository.getMessagesStream(widget.circleId);
  }

  @override
  void dispose() {
    _controller.dispose();
    _scroll.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    _controller.clear();

    try {
      await circleChatRepository.sendMessage(
        circleId: widget.circleId,
        content: text,
      );
      _scrollToBottom();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
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

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Material(
      color: const Color(0xFF0E0F1A),
      child: SafeArea(
        child: Column(
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
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close_rounded, color: Colors.white),
                  ),
                ],
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

                      // Mark as read if it's not me and I haven't read it yet
                      if (!isMe && widget.meId != null && !readBy.contains(widget.meId)) {
                        circleChatRepository.markRead(id);
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
                              CircleChatBubble(
                                text: content,
                                isMe: isMe,
                                isRead: readBy.length > 1, // Assumes sender is always in read_by
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
                        onSubmitted: (_) => _send(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  PressableScale(
                    onTap: _send,
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
          color: isMe 
              ? Colors.white.withValues(alpha: 0.0) 
              : Colors.white.withValues(alpha: 0.1),
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
