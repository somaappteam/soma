import 'package:flutter/material.dart';

import '../../core/widgets/glass.dart';
import '../../core/widgets/premium_dialog.dart';
import '../../data/chat_repository.dart';
import '../../data/experiment_repository.dart';
import 'dm_chat_screen.dart';
import 'select_friend_screen.dart';
import 'package:soma/l10n/gen/app_localizations.dart';

enum _InboxFilter { all, unread, mentions }
enum _InboxSort { latest, unreadFirst, name }

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
  int _refreshNonce = 0;
  _InboxSort _sort = _InboxSort.latest;

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

  Future<void> _refreshInbox() async {
    await chatRepository.getInboxThreads();
    if (!mounted) return;
    setState(() => _refreshNonce++);
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

  Future<void> _togglePinnedThread(String otherId, {required bool next}) async {
    setState(() {
      if (next) {
        _pinnedThreadIds.add(otherId);
      } else {
        _pinnedThreadIds.remove(otherId);
      }
    });
    await chatRepository.setConversationPreference(otherId, pinned: next);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(next ? 'Chat pinned' : 'Chat unpinned')),
    );
  }

  Future<void> _toggleMutedThread(String otherId, {required bool next}) async {
    setState(() {
      if (next) {
        _mutedThreadIds.add(otherId);
      } else {
        _mutedThreadIds.remove(otherId);
      }
    });
    await chatRepository.setConversationPreference(otherId, muted: next);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(next ? 'Chat muted' : 'Chat unmuted')),
    );
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

  String _sortLabel(_InboxSort sort) {
    switch (sort) {
      case _InboxSort.unreadFirst:
        return 'Unread first';
      case _InboxSort.name:
        return 'Name';
      case _InboxSort.latest:
      default:
        return 'Latest';
    }
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
                  PopupMenuButton<_InboxSort>(
                    onSelected: (value) => setState(() => _sort = value),
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: _InboxSort.latest,
                        child: Text('Sort: Latest'),
                      ),
                      const PopupMenuItem(
                        value: _InboxSort.unreadFirst,
                        child: Text('Sort: Unread first'),
                      ),
                      const PopupMenuItem(
                        value: _InboxSort.name,
                        child: Text('Sort: Name'),
                      ),
                    ],
                    child: Glass(
                      radius: BorderRadius.circular(16),
                      padding: const EdgeInsets.all(10),
                      child: Icon(
                        Icons.tune_rounded,
                        color: scheme.onSurface.withValues(alpha: 0.92),
                      ),
                    ),
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
                  _SectionTitle(_showArchivedOnly ? 'Archived chats' : 'Recent chats'),
                  const Spacer(),
                  if (_selectionMode && _selectedThreadIds.isNotEmpty)
                    Text(
                      '${_selectedThreadIds.length} selected',
                      style: TextStyle(
                        color: scheme.onSurface.withValues(alpha: 0.72),
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              Glass(
                radius: BorderRadius.circular(20),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: _FilterPill(
                        label: 'All',
                        selected: _filter == _InboxFilter.all,
                        onTap: () => setState(() => _filter = _InboxFilter.all),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: _FilterPill(
                        label: 'Unread',
                        selected: _filter == _InboxFilter.unread,
                        onTap: () => setState(() => _filter = _InboxFilter.unread),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: _FilterPill(
                        label: 'Mentions',
                        selected: _filter == _InboxFilter.mentions,
                        onTap: () => setState(() => _filter = _InboxFilter.mentions),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(999),
                      color: scheme.onSurface.withValues(alpha: 0.08),
                    ),
                    child: Text(
                      'Sort: ${_sortLabel(_sort)}',
                      style: TextStyle(
                        color: scheme.onSurface.withValues(alpha: 0.78),
                        fontWeight: FontWeight.w700,
                        fontSize: 11,
                      ),
                    ),
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
                child: RefreshIndicator(
                  onRefresh: _refreshInbox,
                  child: StreamBuilder<List<Map<String, dynamic>>>(
                  key: ValueKey('inbox-stream-$_refreshNonce'),
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

                      if (_sort == _InboxSort.unreadFirst) {
                        final au = (a['unreadCount'] as int?) ?? 0;
                        final bu = (b['unreadCount'] as int?) ?? 0;
                        if ((au > 0) != (bu > 0)) return au > 0 ? -1 : 1;
                      }

                      if (_sort == _InboxSort.name) {
                        final an = (a['otherName']?.toString() ?? '').toLowerCase();
                        final bn = (b['otherName']?.toString() ?? '').toLowerCase();
                        final cmp = an.compareTo(bn);
                        if (cmp != 0) return cmp;
                      }

                      final at = a['time'] as DateTime? ?? DateTime.fromMillisecondsSinceEpoch(0);
                      final bt = b['time'] as DateTime? ?? DateTime.fromMillisecondsSinceEpoch(0);
                      return bt.compareTo(at);
                    });

                    if (visibleThreads.isEmpty) {
                      return Center(
                        child: Glass(
                          radius: BorderRadius.circular(20),
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.mark_chat_read_rounded,
                                color: scheme.primary,
                                size: 28,
                              ),
                              const SizedBox(height: 10),
                              Text(
                                query.isNotEmpty ? l10n.noMatchForQuery(query) : l10n.inboxEmptyState,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: scheme.onSurface,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              if (query.isEmpty) ...[
                                const SizedBox(height: 6),
                                Text(
                                  _onboardingPrompt,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: scheme.onSurface.withValues(alpha: 0.65),
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    OutlinedButton.icon(
                                      onPressed: () async {
                                        await Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (_) => const SelectFriendScreen()),
                                        );
                                        if (mounted) setState(() => _refreshNonce++);
                                      },
                                      icon: const Icon(Icons.edit_rounded, size: 16),
                                      label: const Text('New chat'),
                                    ),
                                  ],
                                ),
                              ],
                            ],
                          ),
                        ),
                      );
                    }

                    return Glass(
                      radius: BorderRadius.circular(22),
                      padding: const EdgeInsets.all(10),
                      child: ListView.separated(
                        physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
                      itemCount: visibleThreads.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        final t = visibleThreads[index];
                        final otherId = t['otherId']?.toString() ?? '';
                        final isPinned = _pinnedThreadIds.contains(otherId);
                        final isMuted = _mutedThreadIds.contains(otherId);
                        final unreadCount = t['unreadCount'] ?? 0;
                        final selected = _selectedThreadIds.contains(otherId);

                        return Dismissible(
                          key: ValueKey('thread-$otherId'),
                          direction: _selectionMode ? DismissDirection.none : DismissDirection.horizontal,
                          confirmDismiss: (direction) async {
                            if (direction == DismissDirection.startToEnd) {
                              await _togglePinnedThread(otherId, next: !isPinned);
                            } else {
                              await _toggleMutedThread(otherId, next: !isMuted);
                            }
                            return false;
                          },
                          background: _SwipeActionBackground(
                            alignment: Alignment.centerLeft,
                            icon: isPinned ? Icons.push_pin_outlined : Icons.push_pin_rounded,
                            label: isPinned ? 'Unpin' : 'Pin',
                          ),
                          secondaryBackground: _SwipeActionBackground(
                            alignment: Alignment.centerRight,
                            icon: isMuted ? Icons.notifications_active_rounded : Icons.notifications_off_rounded,
                            label: isMuted ? 'Unmute' : 'Mute',
                          ),
                          child: _ThreadRow(
                            otherId: otherId,
                            name: t['otherName'] ?? l10n.unknown,
                            lastText: t['lastMsg'] ?? '',
                            time: _fmtTime(context, t['time'] as DateTime),
                            unreadCount: unreadCount,
                            showOnlineIndicator: t['isOnline'] == true,
                            avatarUrl: t['avatar_url']?.toString(),
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
                          ),
                        );
                      },
                    ),
                    );
                  },
                ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _fmtTime(BuildContext context, DateTime dt) {
    final l10n = AppLocalizations.of(context);
    final now = DateTime.now();
    final diff = now.difference(dt);
    if (diff.inMinutes < 1) return l10n.timeShortMinutes(1);
    if (diff.inMinutes < 60) return l10n.timeShortMinutes(diff.inMinutes);
    if (diff.inHours < 24) return l10n.timeShortHours(diff.inHours);
    return l10n.timeShortDays(diff.inDays);
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;

  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Text(
      text,
      style: TextStyle(
        color: scheme.onSurface.withValues(alpha: 0.85),
        fontSize: 14,
        fontWeight: FontWeight.w900,
      ),
    );
  }
}

class _FilterPill extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _FilterPill({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: selected
              ? scheme.primary.withValues(alpha: 0.22)
              : Colors.transparent,
          border: Border.all(
            color: selected
                ? scheme.primary.withValues(alpha: 0.55)
                : scheme.onSurface.withValues(alpha: 0.12),
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: selected
                  ? scheme.primary
                  : scheme.onSurface.withValues(alpha: 0.78),
              fontWeight: FontWeight.w800,
              fontSize: 12.5,
            ),
          ),
        ),
      ),
    );
  }
}

class _SwipeActionBackground extends StatelessWidget {
  final Alignment alignment;
  final IconData icon;
  final String label;

  const _SwipeActionBackground({
    required this.alignment,
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: scheme.primary.withValues(alpha: 0.14),
        border: Border.all(color: scheme.primary.withValues(alpha: 0.25)),
      ),
      alignment: alignment,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: scheme.primary),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: scheme.primary,
              fontWeight: FontWeight.w900,
              fontSize: 12,
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
  final String? avatarUrl;
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
    required this.avatarUrl,
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
            _Avatar(
              showOnlineIndicator: showOnlineIndicator,
              avatarUrl: avatarUrl,
              name: name,
            ),
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
                  StreamBuilder<bool>(
                    stream: chatRepository.typingStream(otherId),
                    builder: (context, snapshot) {
                      final isTyping = snapshot.data == true;
                      return Text(
                        isTyping ? 'Typing…' : lastText,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: TextStyle(
                          color: isTyping
                              ? Colors.orange
                              : scheme.onSurface.withValues(alpha: 0.65),
                          fontWeight: FontWeight.w700,
                          fontSize: 12.5,
                        ),
                      );
                    },
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
  final String? avatarUrl;
  final String name;

  const _Avatar({
    required this.showOnlineIndicator,
    required this.avatarUrl,
    required this.name,
  });

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
      child: ClipOval(
        child: _buildAvatarContent(context),
      ),
    );
  }

  Widget _buildAvatarContent(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final url = avatarUrl?.trim() ?? '';
    if (url.isNotEmpty) {
      return Image.network(
        url,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _AvatarFallback(name: name),
      );
    }
    return _AvatarFallback(name: name);
  }
}

class _AvatarFallback extends StatelessWidget {
  final String name;
  const _AvatarFallback({required this.name});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final clean = name.trim();
    final parts = clean.split(RegExp(r'\s+')).where((e) => e.isNotEmpty).toList();
    final first = parts.isNotEmpty ? parts.first[0] : '?';
    final second = parts.length > 1 ? parts[1][0] : '';
    final initials = (first + second).toUpperCase();

    return Container(
      color: scheme.surfaceContainerHighest.withValues(alpha: 0.55),
      alignment: Alignment.center,
      child: Text(
        initials,
        style: TextStyle(
          color: scheme.onSurface.withValues(alpha: 0.92),
          fontSize: 12.5,
          fontWeight: FontWeight.w900,
          letterSpacing: 0.3,
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
