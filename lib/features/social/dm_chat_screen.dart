import 'package:flutter/material.dart';
import '../../core/theme/motion.dart';

import '../../core/widgets/glass.dart';
import '../../core/widgets/staggered_in.dart';
import '../../data/chat_repository.dart';
import '../../data/presence_repository.dart';
import '../../data/profile_repository.dart';

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
  final _controller = TextEditingController();
  final _scroll = ScrollController();
  late Stream<List<Map<String, dynamic>>> _messagesStream;
  late Stream<bool> _onlineStream;
  bool _showOnlineIndicator = true;

  @override
  void initState() {
    super.initState();
    _messagesStream = chatRepository.getMessagesStream(widget.otherId);
    _onlineStream = presenceRepository.streamOnlineStatus(widget.otherId);
    _loadOnlineVisibility();
    // Auto-scroll on new messages can be handled in builder or listener,
    // but simplified approach: just builder.
  }

  @override
  void dispose() {
    _controller.dispose();
    _scroll.dispose();
    super.dispose();
  }

  void _send() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    chatRepository.sendMessage(widget.otherId, text);
    _controller.clear();

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
                          onCall: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content:
                                      Text("Voice call later (Circle voice is next)")),
                            );
                          },
                        );
                      },
                    )
                  : _TopBar(
                      title: widget.otherName,
                      showOnlineIndicator: false,
                      onBack: () => Navigator.pop(context),
                      onCall: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content:
                                  Text("Voice call later (Circle voice is next)")),
                        );
                      },
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
                          final isMe = senderId == widget.meId;
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
                              children: [
                                if (showTime) ...[
                                  const SizedBox(height: 6),
                                  _TimeChip(time: _fmtTime(created)),
                                  const SizedBox(height: 8),
                                ],
                                _Bubble(
                                  text: m['content'] ?? "",
                                  isMe: isMe,
                                ),
                                const SizedBox(height: 10),
                              ],
                            ),
                          );
                        },
                      );
                    }),
              ),
              _InputBar(
                controller: _controller,
                onSend: _send,
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

  const _TopBar({
    required this.title,
    required this.showOnlineIndicator,
    required this.onBack,
    required this.onCall,
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
            child: Text(
              title,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface,
                fontSize: 18,
                fontWeight: FontWeight.w900,
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
          _IconGlass(icon: Icons.call_rounded, onTap: onCall),
        ],
      ),
    );
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
  final bool isMe;

  const _Bubble({
    required this.text,
    required this.isMe,
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
    return Column(
      crossAxisAlignment: align,
      children: [
        Container(
          constraints: const BoxConstraints(maxWidth: 320),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
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
          child: Text(
            text,
            style: TextStyle(
              color: scheme.onSurface.withValues(alpha: 0.92),
              fontWeight: FontWeight.w700,
              height: 1.25,
              fontSize: 14.5,
            ),
          ),
        ),
      ],
    );
  }
}

class _InputBar extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSend;

  const _InputBar({
    required this.controller,
    required this.onSend,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
      child: Glass(
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
