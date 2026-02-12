import 'package:flutter/material.dart';

import '../../core/widgets/glass.dart';
import '../../data/chat_repository.dart';
import '../../data/settings_repository.dart';
import 'dm_chat_screen.dart';
import 'select_friend_screen.dart';
import 'package:soma/l10n/gen/app_localizations.dart';

class InboxScreen extends StatefulWidget {
  const InboxScreen({super.key});

  @override
  State<InboxScreen> createState() => _InboxScreenState();
}

class _InboxScreenState extends State<InboxScreen> {
  String query = "";
  late final Stream<List<Map<String, dynamic>>> _threadsStream;
  final Set<String> _archivedThreadIds = <String>{};
  final Set<String> _pinnedThreadIds = <String>{};
  final Set<String> _mutedThreadIds = <String>{};
  bool _showArchivedOnly = false;

  @override
  void initState() {
    super.initState();
    _threadsStream = _inboxThreadsStream();
    _loadThreadPrefs();
  }

  Future<void> _loadThreadPrefs() async {
    final settings = await settingsRepository.getSettings();
    final raw = settings[_threadPrefsKey];
    if (raw is! Map<String, dynamic>) return;

    if (!mounted) return;
    setState(() {
      _archivedThreadIds
        ..clear()
        ..addAll((raw['archived'] as List?)?.map((e) => e.toString()) ?? const []);
      _pinnedThreadIds
        ..clear()
        ..addAll((raw['pinned'] as List?)?.map((e) => e.toString()) ?? const []);
      _mutedThreadIds
        ..clear()
        ..addAll((raw['muted'] as List?)?.map((e) => e.toString()) ?? const []);
    });
  }

  Future<void> _saveThreadPrefs() async {
    await settingsRepository.updateSetting(_threadPrefsKey, {
      'archived': _archivedThreadIds.toList(),
      'pinned': _pinnedThreadIds.toList(),
      'muted': _mutedThreadIds.toList(),
    });
  }

  Stream<List<Map<String, dynamic>>> _inboxThreadsStream() async* {
    yield await chatRepository.getInboxThreads();
    yield* Stream.periodic(const Duration(seconds: 1)).asyncMap(
      (_) => chatRepository.getInboxThreads(),
    );
  }

  void _syncServerPrefs(List<Map<String, dynamic>> threads) {
    for (final t in threads) {
      final otherId = t['otherId']?.toString();
      if (otherId == null || otherId.isEmpty) continue;

      if (t['isPinned'] == true) {
        _pinnedThreadIds.add(otherId);
      }
      if (t['isMuted'] == true) {
        _mutedThreadIds.add(otherId);
      }
      if (t['isArchived'] == true) {
        _archivedThreadIds.add(otherId);
      }
    }
  }

  Future<void> _deleteThread(String otherId) async {
    await chatRepository.deleteConversation(otherId);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Conversation deleted')),
    );
    setState(() {
      _archivedThreadIds.remove(otherId);
      _pinnedThreadIds.remove(otherId);
      _mutedThreadIds.remove(otherId);
    });
  }

  Future<void> _archiveThread(String otherId) async {
    setState(() {
      _archivedThreadIds.add(otherId);
    });
    await chatRepository.setConversationPreference(otherId, archived: true);

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Chat archived'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            if (!mounted) return;
            setState(() => _archivedThreadIds.remove(otherId));
            chatRepository.setConversationPreference(otherId, archived: false);
          },
        ),
      ),
    );
  }

  Future<bool?> _confirmDelete() {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete conversation?'),
        content: const Text('This will remove all messages in this chat.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  Future<void> _showThreadOptions(Map<String, dynamic> thread) async {
    final otherId = thread['otherId']?.toString();
    if (otherId == null) return;

    final isPinned = _pinnedThreadIds.contains(otherId);
    final isMuted = _mutedThreadIds.contains(otherId);
    final unreadCount = (thread['unreadCount'] as int?) ?? 0;

    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(isPinned ? Icons.push_pin : Icons.push_pin_outlined),
                title: Text(isPinned ? 'Unpin chat' : 'Pin chat'),
                onTap: () {
                  Navigator.pop(context);
                  setState(() {
                    if (isPinned) {
                      _pinnedThreadIds.remove(otherId);
                    } else {
                      _pinnedThreadIds.add(otherId);
                    }
                  });
                  chatRepository.setConversationPreference(otherId, pinned: !isPinned);
                },
              ),
              ListTile(
                leading: Icon(isMuted ? Icons.notifications_active_outlined : Icons.notifications_off_outlined),
                title: Text(isMuted ? 'Unmute notifications' : 'Mute notifications'),
                onTap: () {
                  Navigator.pop(context);
                  setState(() {
                    if (isMuted) {
                      _mutedThreadIds.remove(otherId);
                    } else {
                      _mutedThreadIds.add(otherId);
                    }
                  });
                  chatRepository.setConversationPreference(otherId, muted: !isMuted);
                },
              ),
              ListTile(
                leading: Icon(unreadCount > 0 ? Icons.mark_chat_read_outlined : Icons.mark_chat_unread_outlined),
                title: Text(unreadCount > 0 ? 'Mark as read' : 'Mark as unread'),
                onTap: () async {
                  Navigator.pop(context);
                  if (unreadCount > 0) {
                    await chatRepository.markConversationAsRead(otherId);
                  } else {
                    await chatRepository.markConversationAsUnread(otherId);
                  }
                  if (mounted) setState(() {});
                },
              ),
              ListTile(
                leading: const Icon(Icons.archive_outlined),
                title: const Text('Archive chat'),
                onTap: () {
                  Navigator.pop(context);
                  _archiveThread(otherId);
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete_outline_rounded),
                title: const Text('Delete conversation'),
                onTap: () async {
                  Navigator.pop(context);
                  final shouldDelete = await _confirmDelete();
                  if (shouldDelete == true) {
                    await _deleteThread(otherId);
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 18),
          child: Column(
            children: [
              Row(
                children: [
                  _IconGlass(
                    icon: Icons.arrow_back_ios_new_rounded,
                    onTap: () => Navigator.pop(context),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    l10n.inboxTitle,
                    style: TextStyle(
                      color: scheme.onSurface,
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const Spacer(),
                  _IconGlass(
                    icon: _showArchivedOnly ? Icons.archive : Icons.archive_outlined,
                    onTap: () => setState(() => _showArchivedOnly = !_showArchivedOnly),
                  ),
                  const SizedBox(width: 8),
                  _IconGlass(
                    icon: Icons.edit_rounded,
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const SelectFriendScreen()),
                      );
                      if (mounted) setState(() {});
                    },
                  ),
                ],
              ),

              const SizedBox(height: 14),

              Glass(
                radius: BorderRadius.circular(20),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                child: Row(
                  children: [
                    Icon(Icons.search_rounded, color: scheme.onSurface.withValues(alpha: 0.7)),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        onChanged: (v) => setState(() => query = v),
                        style: TextStyle(color: scheme.onSurface, fontWeight: FontWeight.w700),
                        cursorColor: scheme.onSurface,
                        decoration: InputDecoration(
                          hintText: l10n.searchChatsHint,
                          hintStyle: TextStyle(color: scheme.onSurface.withValues(alpha: 0.45)),
                          border: InputBorder.none,
                          isDense: true,
                        ),
                      ),
                    ),
                    if (query.isNotEmpty)
                      GestureDetector(
                        onTap: () => setState(() => query = ""),
                        child: Icon(Icons.close_rounded, color: scheme.onSurface.withValues(alpha: 0.7)),
                      ),
                  ],
                ),
              ),

              const SizedBox(height: 14),

              Expanded(
                child: StreamBuilder<List<Map<String, dynamic>>>(
                  stream: _threadsStream,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator(color: Color(0xFF2AFADF)));
                    }

                    final all = snapshot.data ?? [];
                    _syncServerPrefs(all);
                    final visibleThreads = all.where((t) {
                      final otherId = t['otherId']?.toString();
                      if (otherId == null) return false;

                      final isArchived = _archivedThreadIds.contains(otherId);
                      if (_showArchivedOnly && !isArchived) return false;
                      if (!_showArchivedOnly && isArchived) return false;

                      if (query.trim().isEmpty) return true;
                      final name = (t['otherName'] as String?) ?? '';
                      return name.toLowerCase().contains(query.toLowerCase());
                    }).toList();

                    visibleThreads.sort((a, b) {
                      final aId = a['otherId']?.toString() ?? '';
                      final bId = b['otherId']?.toString() ?? '';
                      final aPinned = _pinnedThreadIds.contains(aId);
                      final bPinned = _pinnedThreadIds.contains(bId);
                      if (aPinned != bPinned) return aPinned ? -1 : 1;

                      final at = a['time'] as DateTime? ?? DateTime.fromMillisecondsSinceEpoch(0);
                      final bt = b['time'] as DateTime? ?? DateTime.fromMillisecondsSinceEpoch(0);
                      return bt.compareTo(at);
                    });

                    if (visibleThreads.isEmpty) {
                      return Glass(
                        radius: BorderRadius.circular(22),
                        padding: const EdgeInsets.all(16),
                        child: Text(
                          query.isEmpty
                              ? (_showArchivedOnly ? 'No archived chats yet.' : l10n.inboxEmptyState)
                              : l10n.noMatchForQuery(query),
                          style: TextStyle(
                            color: scheme.onSurface.withValues(alpha: 0.75),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      );
                    }

                    return Glass(
                      radius: BorderRadius.circular(22),
                      padding: const EdgeInsets.all(12),
                      child: ListView.separated(
                        itemCount: visibleThreads.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 10),
                        itemBuilder: (context, index) {
                          final t = visibleThreads[index];
                          final otherId = t['otherId']?.toString() ?? '';
                          final isPinned = _pinnedThreadIds.contains(otherId);
                          final isMuted = _mutedThreadIds.contains(otherId);

                          return Dismissible(
                            key: ValueKey('thread-$otherId'),
                            direction: DismissDirection.horizontal,
                            background: _SwipeActionBackground(
                              icon: Icons.archive_outlined,
                              label: 'Archive',
                              alignment: Alignment.centerLeft,
                              color: const Color(0xFF5D7CFF),
                            ),
                            secondaryBackground: _SwipeActionBackground(
                              icon: Icons.delete_outline_rounded,
                              label: 'Delete',
                              alignment: Alignment.centerRight,
                              color: const Color(0xFFEF5350),
                            ),
                            confirmDismiss: (direction) async {
                              if (direction == DismissDirection.startToEnd) {
                                await _archiveThread(otherId);
                                return true;
                              }
                              final shouldDelete = await _confirmDelete();
                              if (shouldDelete == true) {
                                await _deleteThread(otherId);
                                return true;
                              }
                              return false;
                            },
                            child: _ThreadRow(
                              name: t['otherName'] ?? l10n.unknown,
                              lastText: t['lastMsg'] ?? '',
                              time: _fmtTime(t['time'] as DateTime),
                              unreadCount: t['unreadCount'] ?? 0,
                              showOnlineIndicator: t['isOnline'] == true,
                              pinned: isPinned,
                              muted: isMuted,
                              onLongPress: () => _showThreadOptions(t),
                              onTap: () async {
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => DmChatScreen(
                                      meId: chatRepository.currentUserId ?? "me",
                                      otherId: t['otherId'],
                                      otherName: t['otherName'] ?? l10n.genericUser,
                                    ),
                                  ),
                                );
                                if (mounted) setState(() {});
                              },
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
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

class _IconGlass extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _IconGlass({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Glass(
        radius: BorderRadius.circular(16),
        padding: const EdgeInsets.all(10),
        child: Icon(icon, color: scheme.onSurface.withValues(alpha: 0.92)),
      ),
    );
  }
}

class _SwipeActionBackground extends StatelessWidget {
  final IconData icon;
  final String label;
  final Alignment alignment;
  final Color color;

  const _SwipeActionBackground({
    required this.icon,
    required this.label,
    required this.alignment,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: alignment,
      padding: const EdgeInsets.symmetric(horizontal: 18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: color.withValues(alpha: 0.22),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (alignment == Alignment.centerRight)
            Text(
              label,
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800),
            ),
          const SizedBox(width: 8),
          Icon(icon, color: Colors.white),
          if (alignment == Alignment.centerLeft) ...[
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800),
            ),
          ],
        ],
      ),
    );
  }
}

class _ThreadRow extends StatelessWidget {
  final String name;
  final String lastText;
  final String time;
  final int unreadCount;
  final bool showOnlineIndicator;
  final bool pinned;
  final bool muted;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  const _ThreadRow({
    required this.name,
    required this.lastText,
    required this.time,
    required this.unreadCount,
    required this.showOnlineIndicator,
    required this.pinned,
    required this.muted,
    required this.onTap,
    required this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final highlight = unreadCount > 0;
    final scheme = Theme.of(context).colorScheme;

    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          color: highlight ? scheme.onSurface.withValues(alpha: 0.10) : scheme.onSurface.withValues(alpha: 0.06),
          border: Border.all(
            color: highlight ? scheme.onSurface.withValues(alpha: 0.24) : scheme.onSurface.withValues(alpha: 0.14),
          ),
        ),
        child: Row(
          children: [
            _Avatar(showOnlineIndicator: showOnlineIndicator),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          name,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: scheme.onSurface,
                            fontWeight: FontWeight.w900,
                            fontSize: 14.5,
                          ),
                        ),
                      ),
                      if (pinned)
                        Icon(Icons.push_pin_rounded, size: 14, color: scheme.primary.withValues(alpha: 0.9)),
                      if (showOnlineIndicator) ...[
                        const SizedBox(width: 6),
                        const _ActiveNowPill(),
                      ],
                      if (muted) ...[
                        const SizedBox(width: 6),
                        Icon(Icons.notifications_off_rounded,
                            size: 14, color: scheme.onSurface.withValues(alpha: 0.7)),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    lastText,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: TextStyle(
                      color: scheme.onSurface.withValues(alpha: 0.65),
                      fontWeight: FontWeight.w700,
                      fontSize: 12.5,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  time,
                  style: TextStyle(
                    color: scheme.onSurface.withValues(alpha: 0.55),
                    fontWeight: FontWeight.w800,
                    fontSize: 11.5,
                  ),
                ),
                const SizedBox(height: 6),
                if (unreadCount > 0)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(999),
                      color: scheme.primary.withValues(alpha: 0.16),
                      border: Border.all(color: scheme.primary.withValues(alpha: 0.22)),
                    ),
                    child: Text(
                      unreadCount.toString(),
                      style: TextStyle(
                        color: scheme.primary,
                        fontWeight: FontWeight.w900,
                        fontSize: 11,
                      ),
                    ),
                  )
                else
                  Icon(Icons.chevron_right_rounded, color: scheme.onSurface.withValues(alpha: 0.45)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  final bool showOnlineIndicator;

  const _Avatar({required this.showOnlineIndicator});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: scheme.onSurface.withValues(alpha: 0.10),
        border: Border.all(
          color: showOnlineIndicator
              ? const Color(0xFF58F7B6).withValues(alpha: 0.65)
              : scheme.onSurface.withValues(alpha: 0.16),
        ),
        boxShadow: showOnlineIndicator
            ? [
                BoxShadow(
                  color: const Color(0xFF58F7B6).withValues(alpha: 0.35),
                  blurRadius: 12,
                  spreadRadius: 1,
                ),
              ]
            : null,
      ),
      child: Stack(
        children: [
          Center(
            child: Text(
              "🙂",
              style: TextStyle(fontSize: 18, color: scheme.onSurface.withValues(alpha: 0.9)),
            ),
          ),
          if (showOnlineIndicator)
            Positioned(
              bottom: 2,
              right: 2,
              child: Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF58F7B6),
                  border: Border.all(color: scheme.surface.withValues(alpha: 0.7), width: 2),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _ActiveNowPill extends StatelessWidget {
  const _ActiveNowPill();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        color: const Color(0xFF58F7B6).withValues(alpha: 0.15),
        border: Border.all(color: const Color(0xFF58F7B6).withValues(alpha: 0.45)),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.circle, size: 7, color: Color(0xFF58F7B6)),
          SizedBox(width: 4),
          Text(
            'Active',
            style: TextStyle(
              color: Color(0xFF58F7B6),
              fontSize: 9.5,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}
