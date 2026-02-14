import 'package:flutter/material.dart';

import '../../core/widgets/glass.dart';
import '../../core/widgets/premium_dialog.dart';
import '../../data/chat_repository.dart';
import '../../data/experiment_repository.dart';
import 'dm_chat_screen.dart';
import 'select_friend_screen.dart';
import 'package:soma/l10n/gen/app_localizations.dart';

enum _InboxFilter { all, unread, mentions }

class InboxScreen extends StatefulWidget {
  const InboxScreen({super.key});

  @override
  State<InboxScreen> createState() => _InboxScreenState();
}

class _InboxScreenState extends State<InboxScreen> {
  String query = "";
  late final Stream<List<Map<String, dynamic>>> _threadsStream;
  final Set<String> _archivedThreadIds = <String>{};
  final Set<String> _deletedThreadIds = <String>{};
  final Set<String> _pinnedThreadIds = <String>{};
  final Set<String> _mutedThreadIds = <String>{};
  final Set<String> _selectedThreadIds = <String>{};
  bool _showArchivedOnly = false;
  bool _selectionMode = false;
  _InboxFilter _filter = _InboxFilter.all;
  String _onboardingPrompt = 'Start with a quick hello to a friend.';

  @override
  void initState() {
    super.initState();
    _threadsStream = _inboxThreadsStream();
    _loadExperimentPrompt();
  }


  Future<void> _loadExperimentPrompt() async {
    final v = await experimentRepository.variant('inbox_onboarding_prompt', buckets: const ['A', 'B']);
    if (!mounted) return;
    setState(() {
      _onboardingPrompt = v == 'B'
          ? 'Tip: pin your most important chats.'
          : 'Start with a quick hello to a friend.';
    });
  }

  Stream<List<Map<String, dynamic>>> _inboxThreadsStream() async* {
    yield await chatRepository.getInboxThreads();
    yield* chatRepository.inboxRefreshStream().asyncMap(
      (_) => chatRepository.getInboxThreads(),
    );
  }

  void _syncServerPrefs(List<Map<String, dynamic>> threads) {
    for (final t in threads) {
      final otherId = t['otherId']?.toString();
      if (otherId == null || otherId.isEmpty) continue;

      if (t['isPinned'] == true) _pinnedThreadIds.add(otherId);
      if (t['isMuted'] == true) _mutedThreadIds.add(otherId);
      if (t['isArchived'] == true) _archivedThreadIds.add(otherId);
    }
  }

  Future<void> _bulkMarkRead() async {
    final ids = _selectedThreadIds.toList();
    await chatRepository.markAllConversationsAsRead(ids);
    if (!mounted) return;
    setState(() {
      _selectionMode = false;
      _selectedThreadIds.clear();
    });
  }

  Future<void> _bulkArchive() async {
    final ids = _selectedThreadIds.toList();
    await chatRepository.archiveConversations(ids);
    if (!mounted) return;
    setState(() {
      _archivedThreadIds.addAll(ids);
      _selectionMode = false;
      _selectedThreadIds.clear();
    });
  }

  Future<void> _deleteThread(String otherId) async {
    setState(() {
      _deletedThreadIds.add(otherId);
      _archivedThreadIds.remove(otherId);
      _pinnedThreadIds.remove(otherId);
      _mutedThreadIds.remove(otherId);
    });

    await chatRepository.deleteConversation(otherId);

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Conversation deleted')),
    );
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

  Future<void> _unarchiveThread(String otherId) async {
    setState(() {
      _archivedThreadIds.remove(otherId);
    });
    await chatRepository.setConversationPreference(otherId, archived: false);
  }

  Future<bool?> _confirmDelete() {
    return showPremiumDialog(
      context: context,
      title: 'Delete conversation?',
      body: 'This will remove all messages in this chat.',
      confirmText: 'Delete',
      cancelText: 'Cancel',
      destructive: true,
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
                  if (_selectionMode) ...[
                    _IconGlass(icon: Icons.mark_chat_read_rounded, onTap: _bulkMarkRead),
                    const SizedBox(width: 8),
                    _IconGlass(icon: Icons.archive_rounded, onTap: _bulkArchive),
                    const SizedBox(width: 8),
                  ],
                  _IconGlass(
                    icon: _showArchivedOnly ? Icons.archive : Icons.archive_outlined,
                    onTap: () => setState(() => _showArchivedOnly = !_showArchivedOnly),
                  ),
                  const SizedBox(width: 8),
                  _IconGlass(
                    icon: _selectionMode ? Icons.close_rounded : Icons.checklist_rounded,
                    onTap: () => setState(() {
                      _selectionMode = !_selectionMode;
                      if (!_selectionMode) _selectedThreadIds.clear();
                    }),
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
              const SizedBox(height: 12),
              Row(
                children: [
                  ChoiceChip(
                    label: const Text('All'),
                    selected: _filter == _InboxFilter.all,
                    onSelected: (_) => setState(() => _filter = _InboxFilter.all),
                  ),
                  const SizedBox(width: 8),
                  ChoiceChip(
                    label: const Text('Unread'),
                    selected: _filter == _InboxFilter.unread,
                    onSelected: (_) => setState(() => _filter = _InboxFilter.unread),
                  ),
                  const SizedBox(width: 8),
                  ChoiceChip(
                    label: const Text('Mentions'),
                    selected: _filter == _InboxFilter.mentions,
                    onSelected: (_) => setState(() => _filter = _InboxFilter.mentions),
                  ),
                ],
              ),
              const SizedBox(height: 10),
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
              const SizedBox(height: 12),
              Expanded(
                child: StreamBuilder<List<Map<String, dynamic>>>(
                  stream: _threadsStream,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    final threads = snapshot.data!;
                    _syncServerPrefs(threads);

                    var visibleThreads = threads.where((t) {
                      final otherId = t['otherId']?.toString();
                      if (otherId == null || _deletedThreadIds.contains(otherId)) return false;

                      final isArchived = _archivedThreadIds.contains(otherId);
                      if (_showArchivedOnly != isArchived) return false;

                      final hay = '${t['otherName'] ?? ''} ${t['lastMsg'] ?? ''}'.toLowerCase();
                      if (query.isNotEmpty && !hay.contains(query.toLowerCase())) return false;

                      final unreadCount = (t['unreadCount'] as int?) ?? 0;
                      if (_filter == _InboxFilter.unread && unreadCount <= 0) return false;
                      if (_filter == _InboxFilter.mentions && !(t['lastMsg']?.toString().contains('@') ?? false)) {
                        return false;
                      }
                      return true;
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
                      return Center(
                        child: Text(
                          query.isNotEmpty ? l10n.noMatchForQuery(query) : '${l10n.inboxEmptyState}\n$_onboardingPrompt',
                        ),
                      );
                    }

                    return ListView.separated(
                      itemCount: visibleThreads.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        final t = visibleThreads[index];
                        final otherId = t['otherId']?.toString() ?? '';
                        final isPinned = _pinnedThreadIds.contains(otherId);
                        final isMuted = _mutedThreadIds.contains(otherId);
                        final unreadCount = t['unreadCount'] ?? 0;
                        final selected = _selectedThreadIds.contains(otherId);

                        return _ThreadRow(
                          otherId: otherId,
                          name: t['otherName'] ?? l10n.unknown,
                          lastText: t['lastMsg'] ?? '',
                          time: _fmtTime(t['time'] as DateTime),
                          unreadCount: unreadCount,
                          showOnlineIndicator: t['isOnline'] == true,
                          pinned: isPinned,
                          muted: isMuted,
                          selected: selected,
                          selectionMode: _selectionMode,
                          onTap: () async {
                            if (_selectionMode) {
                              setState(() {
                                if (selected) {
                                  _selectedThreadIds.remove(otherId);
                                } else {
                                  _selectedThreadIds.add(otherId);
                                }
                              });
                              return;
                            }
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
                          onLongPress: () async {
                            final shouldDelete = await _confirmDelete();
                            if (shouldDelete == true) {
                              await _deleteThread(otherId);
                            }
                          },
                        );
                      },
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

class _ThreadRow extends StatelessWidget {
  final String otherId;
  final String name;
  final String lastText;
  final String time;
  final int unreadCount;
  final bool showOnlineIndicator;
  final bool pinned;
  final bool muted;
  final bool selectionMode;
  final bool selected;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  const _ThreadRow({
    required this.otherId,
    required this.name,
    required this.lastText,
    required this.time,
    required this.unreadCount,
    required this.showOnlineIndicator,
    required this.pinned,
    required this.muted,
    required this.selectionMode,
    required this.selected,
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
          color: selected
              ? scheme.primary.withValues(alpha: 0.12)
              : (highlight
                  ? scheme.onSurface.withValues(alpha: 0.10)
                  : scheme.onSurface.withValues(alpha: 0.06)),
          border: Border.all(
            color: selected
                ? scheme.primary
                : (highlight
                    ? scheme.onSurface.withValues(alpha: 0.24)
                    : scheme.onSurface.withValues(alpha: 0.14)),
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
                      StreamBuilder<bool>(
                        stream: chatRepository.typingStream(otherId),
                        builder: (context, snapshot) {
                          if (snapshot.data != true) return const SizedBox.shrink();
                          return const Padding(
                            padding: EdgeInsets.only(left: 6),
                            child: _TypingPill(),
                          );
                        },
                      ),
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
                  Icon(selectionMode ? Icons.check_circle_outline : Icons.chevron_right_rounded,
                      color: scheme.onSurface.withValues(alpha: 0.45)),
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
      ),
      child: Center(
        child: Text(
          "🙂",
          style: TextStyle(fontSize: 18, color: scheme.onSurface.withValues(alpha: 0.9)),
        ),
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
      child: const Text(
        'Active',
        style: TextStyle(
          color: Color(0xFF58F7B6),
          fontSize: 9.5,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class _TypingPill extends StatelessWidget {
  const _TypingPill();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        color: Colors.orange.withValues(alpha: 0.15),
        border: Border.all(color: Colors.orange.withValues(alpha: 0.45)),
      ),
      child: const Text(
        'Typing…',
        style: TextStyle(fontSize: 9.5, fontWeight: FontWeight.w800, color: Colors.orange),
      ),
    );
  }
}
