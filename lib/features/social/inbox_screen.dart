import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/widgets/glass.dart';
import '../../data/auth_repository.dart';
import '../../data/chat_repository.dart';
import '../../data/experiment_repository.dart';
import '../../data/presence_repository.dart';
import '../../data/settings_repository.dart';
import 'dm_chat_screen.dart';
import 'select_friend_screen.dart';
import 'package:soma/l10n/gen/app_localizations.dart';

enum _InboxFilter { all, priority, unread, friends, requests, groups, muted, archived }
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
  bool _showArchivedOnly = false;
  _InboxFilter _filter = _InboxFilter.all;
  String _onboardingPrompt = 'Start with a quick hello to a friend.';
  int _refreshNonce = 0;
  _InboxSort _sort = _InboxSort.latest;
  final Map<String, DateTime> _snoozedUntil = <String, DateTime>{};
  final Set<String> _hiddenPreviewThreadIds = <String>{};
  bool _showSearchBar = false;

  @override
  void initState() {
    super.initState();
    _threadsStream = _inboxThreadsStream();
    _loadExperimentPrompt();
    _loadInboxPremiumSettings();
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


  Future<void> _loadInboxPremiumSettings() async {
    try {
      final settings = await settingsRepository.getSettings();
      final rawSnooze = (settings['inbox_snoozed_until'] as Map?)?.cast<String, dynamic>() ?? const {};
      final nextSnoozed = <String, DateTime>{};
      for (final entry in rawSnooze.entries) {
        final dt = DateTime.tryParse(entry.value.toString());
        if (dt != null && dt.isAfter(DateTime.now())) {
          nextSnoozed[entry.key] = dt;
        }
      }
      final hidden = <String>{};
      for (final key in settings.keys) {
        if (key.startsWith('dm_hide_preview_') && settings[key] == true) {
          hidden.add(key.replaceFirst('dm_hide_preview_', ''));
        }
      }
      if (!mounted) return;
      setState(() {
        _snoozedUntil
          ..clear()
          ..addAll(nextSnoozed);
        _hiddenPreviewThreadIds
          ..clear()
          ..addAll(hidden);
        _showSearchBar = settings['inbox_search_expanded'] == true;
      });
    } catch (_) {}
  }

  Future<void> _setSnooze(String otherId, Duration? duration) async {
    setState(() {
      if (duration == null) {
        _snoozedUntil.remove(otherId);
      } else {
        _snoozedUntil[otherId] = DateTime.now().add(duration);
      }
    });
    await settingsRepository.updateSetting(
      'inbox_snoozed_until',
      {for (final e in _snoozedUntil.entries) e.key: e.value.toIso8601String()},
    );
  }

  Future<void> _showSnoozeSheet(String otherId) async {
    final selected = await showModalBottomSheet<Duration?>(
      context: context,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(title: const Text('Snooze 1 hour'), onTap: () => Navigator.pop(context, const Duration(hours: 1))),
            ListTile(title: const Text('Snooze until tonight'), onTap: () => Navigator.pop(context, Duration(hours: (21 - DateTime.now().hour).clamp(1, 12)))),
            ListTile(title: const Text('Snooze until tomorrow'), onTap: () => Navigator.pop(context, const Duration(hours: 24))),
            ListTile(title: const Text('Remove snooze'), onTap: () => Navigator.pop(context, null)),
          ],
        ),
      ),
    );
    if (!mounted) return;
    await _setSnooze(otherId, selected);
  }



  Future<void> _toggleSearchBar() async {
    HapticFeedback.selectionClick();
    final next = !_showSearchBar;
    setState(() {
      _showSearchBar = next;
      if (!next) query = '';
    });
    await settingsRepository.updateSetting('inbox_search_expanded', next);
  }



  int get _activeViewOptionCount {
    var count = 0;
    if (_filter != _InboxFilter.all) count++;
    if (_sort != _InboxSort.latest) count++;
    return count;
  }

  Future<void> _setSort(_InboxSort next) async {
    if (_sort == next) return;
    HapticFeedback.selectionClick();
    setState(() => _sort = next);
  }

  void _resetViewOptions() {
    HapticFeedback.selectionClick();
    setState(() {
      _filter = _InboxFilter.all;
      _showArchivedOnly = false;
      _sort = _InboxSort.latest;
    });
  }

  bool _isPriorityThread(Map<String, dynamic> t) {
    final unread = (t['unreadCount'] as int?) ?? 0;
    final isFriend = t['isFriend'] == true;
    final isPinned = _pinnedThreadIds.contains(t['otherId']?.toString() ?? '');
    final time = t['time'] is DateTime ? t['time'] as DateTime : DateTime.now();
    final recent = DateTime.now().difference(time).inHours <= 48;
    final learningSignal = t['hasChallengePending'] == true ||
        t['hasCorrectionUnread'] == true ||
        t['hasVoiceFeedback'] == true;
    return unread > 0 || isPinned || learningSignal || (isFriend && recent);
  }

  bool _isGroupThread(Map<String, dynamic> t) {
    final name = (t['otherName']?.toString() ?? '').toLowerCase();
    return name.contains('group') || name.contains('&') || name.contains(',');
  }

  Future<void> _refreshInbox() async {
    // Force restart the stream to fetch fresh data
    setState(() {
      _threadsStream = _inboxThreadsStream();
      _refreshNonce++;
    });
  }




  Stream<List<Map<String, dynamic>>> _inboxThreadsStream() {
    return chatRepository.getInboxThreadsStream();
  }

  void _syncServerPrefs(List<Map<String, dynamic>> threads) {
    for (final t in threads) {
      final otherId = t['otherId']?.toString();
      if (otherId == null || otherId.isEmpty) continue;

      if (t['isPinned'] == true) {
        _pinnedThreadIds.add(otherId);
      } else {
        _pinnedThreadIds.remove(otherId);
      }

      if (t['isMuted'] == true) {
        _mutedThreadIds.add(otherId);
      } else {
        _mutedThreadIds.remove(otherId);
      }

      if (t['isArchived'] == true) {
        _archivedThreadIds.add(otherId);
      } else {
        _archivedThreadIds.remove(otherId);
      }
    }
  }



  /*
  Future<void> _unarchiveThread(String otherId) async {
    setState(() {
      _archivedThreadIds.remove(otherId);
    });
    await chatRepository.setConversationPreference(otherId, archived: false);
  }
  */

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



  /*
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
  */

  String _sortLabel(_InboxSort sort) {
    switch (sort) {
      case _InboxSort.unreadFirst:
        return 'Unread first';
      case _InboxSort.name:
        return 'Name';
      case _InboxSort.latest:
        return 'Latest';
    }
  }

  String _filterLabel(_InboxFilter filter) {
    switch (filter) {
      case _InboxFilter.all:
        return 'All';
      case _InboxFilter.priority:
        return 'Priority';
      case _InboxFilter.unread:
        return 'Unread';
      case _InboxFilter.friends:
        return 'Friends';
      case _InboxFilter.requests:
        return 'Requests';
      case _InboxFilter.groups:
        return 'Groups';
      case _InboxFilter.muted:
        return 'Muted';
      case _InboxFilter.archived:
        return 'Archived';
    }
  }

  void _setFilter(_InboxFilter next) {
    if (_filter == next && _showArchivedOnly == (next == _InboxFilter.archived)) return;
    HapticFeedback.selectionClick();
    setState(() {
      _filter = next;
      _showArchivedOnly = next == _InboxFilter.archived;
    });
  }

  void _applyPreset(String preset) {
    HapticFeedback.selectionClick();
    setState(() {
      switch (preset) {
        case 'focus':
          _filter = _InboxFilter.priority;
          _showArchivedOnly = false;
          _sort = _InboxSort.unreadFirst;
          break;
        case 'catchup':
          _filter = _InboxFilter.unread;
          _showArchivedOnly = false;
          _sort = _InboxSort.unreadFirst;
          break;
        case 'friends':
          _filter = _InboxFilter.friends;
          _showArchivedOnly = false;
          _sort = _InboxSort.latest;
          break;
      }
    });
  }

  Future<void> _showViewOptionsSheet() async {
    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) {
        final options = [
          _InboxFilter.all,
          _InboxFilter.priority,
          _InboxFilter.unread,
          _InboxFilter.friends,
          _InboxFilter.requests,
          _InboxFilter.groups,
          _InboxFilter.muted,
          _InboxFilter.archived,
        ];
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'View options',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontWeight: FontWeight.w900,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Smart presets',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _OptionChip(
                      label: 'Focus',
                      selected: _filter == _InboxFilter.priority && _sort == _InboxSort.unreadFirst,
                      onTap: () => _applyPreset('focus'),
                    ),
                    _OptionChip(
                      label: 'Catch-up',
                      selected: _filter == _InboxFilter.unread && _sort == _InboxSort.unreadFirst,
                      onTap: () => _applyPreset('catchup'),
                    ),
                    _OptionChip(
                      label: 'Friends-only',
                      selected: _filter == _InboxFilter.friends && _sort == _InboxSort.latest,
                      onTap: () => _applyPreset('friends'),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Text(
                  'Sort',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _OptionChip(
                      label: 'Latest',
                      selected: _sort == _InboxSort.latest,
                      onTap: () => _setSort(_InboxSort.latest),
                    ),
                    _OptionChip(
                      label: 'Unread first',
                      selected: _sort == _InboxSort.unreadFirst,
                      onTap: () => _setSort(_InboxSort.unreadFirst),
                    ),
                    _OptionChip(
                      label: 'Name',
                      selected: _sort == _InboxSort.name,
                      onTap: () => _setSort(_InboxSort.name),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Text(
                  'Filter',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final option in options)
                      _FilterPill(
                        label: _filterLabel(option),
                        selected: _filter == option,
                        onTap: () {
                          _setFilter(option);
                        },
                      ),
                  ],
                ),

                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Done'),
                  ),
                ),
              ],
            ),
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
                    icon: Icons.tune_rounded,
                    onTap: _showViewOptionsSheet,
                    badgeCount: _activeViewOptionCount,
                  ),
                  const SizedBox(width: 8),
                  _IconGlass(
                    icon: _showSearchBar ? Icons.search_off_rounded : Icons.search_rounded,
                    onTap: _toggleSearchBar,
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
                ],
              ),
              const SizedBox(height: 8),
              // Removed digest summary card
              if (_filter != _InboxFilter.all || _sort != _InboxSort.latest) ...[
                Row(
                  children: [
                    _StatusChip(label: 'Filter: ${_filterLabel(_filter)}'),
                    const SizedBox(width: 8),
                    _StatusChip(label: 'Sort: ${_sortLabel(_sort)}'),
                    const Spacer(),
                    TextButton(
                      onPressed: _resetViewOptions,
                      child: const Text('Reset'),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
              ],
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 180),
                child: _showSearchBar
                    ? Glass(
                        key: const ValueKey('search-open'),
                        radius: BorderRadius.circular(20),
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        child: Row(
                          children: [
                            Icon(Icons.search_rounded, color: scheme.onSurface.withValues(alpha: 0.7)),
                            const SizedBox(width: 10),
                            Expanded(
                              child: TextField(
                                autofocus: true,
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
                                onTap: () => setState(() => query = ''),
                                child: Icon(Icons.close_rounded, color: scheme.onSurface.withValues(alpha: 0.7)),
                              ),
                          ],
                        ),
                      )
                    : Align(
                        key: const ValueKey('search-closed'),
                        alignment: Alignment.centerLeft,
                        child: OutlinedButton.icon(
                          onPressed: _toggleSearchBar,
                          icon: const Icon(Icons.search_rounded),
                          label: const Text('Search chats'),
                        ),
                      ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: _refreshInbox,
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
                      final snoozedUntil = _snoozedUntil[otherId];
                      if (snoozedUntil != null && snoozedUntil.isAfter(DateTime.now())) return false;
                      if (_filter == _InboxFilter.priority && !_isPriorityThread(t)) return false;
                      if (_filter == _InboxFilter.unread && unreadCount <= 0) return false;
                      if (_filter == _InboxFilter.friends && t['isFriend'] != true) return false;
                      if (_filter == _InboxFilter.requests &&
                          t['hasIncomingRequest'] != true &&
                          t['hasOutgoingRequest'] != true) {
                        return false;
                      }
                      if (_filter == _InboxFilter.groups && !_isGroupThread(t)) return false;
                      if (_filter == _InboxFilter.muted && !_mutedThreadIds.contains(otherId)) {
                        return false;
                      }
                      if (_filter == _InboxFilter.archived && !isArchived) return false;
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

                    final participantIds = visibleThreads.map((t) => t['otherId']?.toString() ?? '').where((id) => id.isNotEmpty).toList();
                    final vipThreads = visibleThreads.where((t) => _pinnedThreadIds.contains(t['otherId']?.toString() ?? '')).take(8).toList();
                    return Glass(
                      radius: BorderRadius.circular(22),
                      padding: const EdgeInsets.all(10),
                      child: StreamBuilder<Map<String, bool>>(
                        stream: presenceRepository.streamMultipleOnlineStatuses(participantIds),
                        builder: (context, presenceSnapshot) {
                          final onlineStatuses = presenceSnapshot.data ?? {};
                          return Column(
                            children: [
                              if (vipThreads.isNotEmpty)
                                _VipPinnedRow(
                                  threads: vipThreads,
                                ),
                              Expanded(
                                child: AnimatedSwitcher(
                                  duration: const Duration(milliseconds: 160),
                                  switchInCurve: Curves.easeOut,
                                  switchOutCurve: Curves.easeIn,
                                  transitionBuilder: (child, animation) {
                                    final slide = Tween<Offset>(
                                      begin: const Offset(0, 0.04),
                                      end: Offset.zero,
                                    ).animate(animation);
                                    return FadeTransition(
                                      opacity: animation,
                                      child: SlideTransition(position: slide, child: child),
                                    );
                                  },
                                  child: ListView.separated(
                                    key: ValueKey('threads-${_filter.name}-${_sort.name}-${query.toLowerCase()}-$_showArchivedOnly'),
                                    physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
                                    itemCount: visibleThreads.length,
                                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                                    itemBuilder: (context, index) {
                                      final t = visibleThreads[index];
                                      final otherId = t['otherId']?.toString() ?? '';
                                      final isPinned = _pinnedThreadIds.contains(otherId);
                                      final isMuted = _mutedThreadIds.contains(otherId);
                                      final unreadCount = t['unreadCount'] ?? 0;
                                      final hidePreview = _hiddenPreviewThreadIds.contains(otherId);
                                      final trustScore = (((t['isFriend'] == true ? 60 : 35) + ((unreadCount as int) > 0 ? 10 : 0) + (t['hasIncomingRequest'] == true ? 5 : 0)).clamp(0, 99) as num).toInt();

                                      return Dismissible(
                              key: ValueKey('thread-$otherId'),
                              direction: DismissDirection.horizontal,
                              confirmDismiss: (direction) async {
                                if (direction == DismissDirection.startToEnd) {
                                  await _togglePinnedThread(otherId, next: !isPinned);
                                } else {
                                  await _showSnoozeSheet(otherId);
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
                                icon: Icons.snooze_rounded,
                                label: 'Snooze',
                              ),
                                        child: _ThreadRow(
                                otherId: otherId,
                                name: t['otherName'] ?? l10n.unknown,
                                lastText: hidePreview ? 'Preview hidden for privacy' : (t['lastMsg'] ?? ''),
                                summary: t['summary']?.toString(),
                                time: _fmtTime(context, t['time'] as DateTime),
                                unreadCount: unreadCount,
                                showOnlineIndicator: onlineStatuses[otherId] == true,
                                avatarUrl: t['avatar_url']?.toString(),
                                pinned: isPinned,
                                muted: isMuted,
                                hasIncomingRequest: t['hasIncomingRequest'] == true,
                                hasOutgoingRequest: t['hasOutgoingRequest'] == true,
                                trustScore: trustScore,
                                practiceStreakAtRisk: t['practiceStreakAtRisk'] == true,
                                hasChallengePending: t['hasChallengePending'] == true,
                                hasCorrectionUnread: t['hasCorrectionUnread'] == true,
                                hasVoiceFeedback: t['hasVoiceFeedback'] == true,
                                partnerQuality: (t['partnerQuality'] as num?)?.toInt(),
                                reliabilityScore: (t['reliabilityScore'] as num?)?.toInt(),
                                correctionHelpfulnessScore: (t['correctionHelpfulnessScore'] as num?)?.toInt(),
                                voiceFeedbackScore: (t['voiceFeedbackScore'] as num?)?.toInt(),
                                verifiedSeriousLearner: t['verifiedSeriousLearner'] == true,
                                onTap: () async {
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => DmChatScreen(
                                        meId: authRepository.currentUser?.id ?? "me",
                                        otherId: otherId,
                                        otherName: t['otherName'] ?? l10n.unknown,
                                      ),
                                    ),
                                  );
                                  if (mounted) setState(() => _refreshNonce++);
                                },
                                ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ],
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




class _VipPinnedRow extends StatelessWidget {
  final List<Map<String, dynamic>> threads;

  const _VipPinnedRow({required this.threads});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 58,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.only(bottom: 8),
        itemBuilder: (context, i) {
          final t = threads[i];
          final name = (t['otherName']?.toString() ?? 'U').trim();
          return Glass(
            radius: BorderRadius.circular(999),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _Avatar(
                  showOnlineIndicator: t['isOnline'] == true,
                  avatarUrl: t['avatar_url']?.toString(),
                  name: name,
                ),
                const SizedBox(width: 6),
                Text(
                  name.split(' ').first,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontWeight: FontWeight.w800,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          );
        },
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemCount: threads.length,
      ),
    );
  }
}




class _StatusChip extends StatelessWidget {
  final String label;

  const _StatusChip({required this.label});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        color: scheme.onSurface.withValues(alpha: 0.08),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: scheme.onSurface.withValues(alpha: 0.78),
          fontWeight: FontWeight.w700,
          fontSize: 11,
        ),
      ),
    );
  }
}

class _OptionChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _OptionChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return InkWell(
      borderRadius: BorderRadius.circular(999),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: selected
                ? scheme.primary.withValues(alpha: 0.55)
                : scheme.onSurface.withValues(alpha: 0.14),
          ),
          color: selected
              ? scheme.primary.withValues(alpha: 0.22)
              : Colors.transparent,
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected
                ? scheme.primary
                : scheme.onSurface.withValues(alpha: 0.8),
            fontWeight: FontWeight.w800,
            fontSize: 12,
          ),
        ),
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
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
  final int badgeCount;

  const _IconGlass({
    required this.icon,
    required this.onTap,
    this.badgeCount = 0,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Glass(
            radius: BorderRadius.circular(16),
            padding: const EdgeInsets.all(10),
            child: Icon(icon, color: scheme.onSurface.withValues(alpha: 0.92)),
          ),
          if (badgeCount > 0)
            Positioned(
              right: -4,
              top: -4,
              child: Container(
                constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                padding: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  color: scheme.primary,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Center(
                  child: Text(
                    '$badgeCount',
                    style: TextStyle(
                      color: scheme.onPrimary,
                      fontWeight: FontWeight.w900,
                      fontSize: 10,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _ThreadRow extends StatelessWidget {
  final String otherId;
  final String name;
  final String lastText;
  final String? summary;
  final String time;
  final int unreadCount;
  final bool showOnlineIndicator;
  final String? avatarUrl;
  final bool pinned;
  final bool muted;
  final bool hasIncomingRequest;
  final bool hasOutgoingRequest;
  final int trustScore;
  final bool practiceStreakAtRisk;
  final bool hasChallengePending;
  final bool hasCorrectionUnread;
  final bool hasVoiceFeedback;
  final int? partnerQuality;
  final int? reliabilityScore;
  final int? correctionHelpfulnessScore;
  final int? voiceFeedbackScore;
  final bool verifiedSeriousLearner;
  final VoidCallback onTap;

  const _ThreadRow({
    required this.otherId,
    required this.name,
    required this.lastText,
    required this.summary,
    required this.time,
    required this.unreadCount,
    required this.showOnlineIndicator,
    required this.avatarUrl,
    required this.pinned,
    required this.muted,
    required this.hasIncomingRequest,
    required this.hasOutgoingRequest,
    required this.trustScore,
    required this.practiceStreakAtRisk,
    required this.hasChallengePending,
    required this.hasCorrectionUnread,
    required this.hasVoiceFeedback,
    required this.partnerQuality,
    required this.reliabilityScore,
    required this.correctionHelpfulnessScore,
    required this.voiceFeedbackScore,
    required this.verifiedSeriousLearner,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final highlight = unreadCount > 0;
    final scheme = Theme.of(context).colorScheme;

    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          color: highlight
              ? scheme.onSurface.withValues(alpha: 0.10)
              : scheme.onSurface.withValues(alpha: 0.06),
          border: Border.all(
            color: highlight
                ? scheme.onSurface.withValues(alpha: 0.24)
                : scheme.onSurface.withValues(alpha: 0.14),
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
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
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
                          ),
                          if (!isTyping && summary != null && summary!.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: 3),
                              child: Text(
                                summary!,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: TextStyle(
                                  color: scheme.primary.withValues(alpha: 0.9),
                                  fontWeight: FontWeight.w700,
                                  fontSize: 11,
                                ),
                              ),
                            ),

                          if (hasIncomingRequest || hasOutgoingRequest)
                            Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(999),
                                  color: hasIncomingRequest
                                      ? Colors.green.withValues(alpha: 0.15)
                                      : scheme.primary.withValues(alpha: 0.15),
                                  border: Border.all(
                                    color: hasIncomingRequest
                                        ? Colors.green.withValues(alpha: 0.4)
                                        : scheme.primary.withValues(alpha: 0.35),
                                  ),
                                ),
                                child: Text(
                                  hasIncomingRequest ? 'Request waiting' : 'Request sent',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w800,
                                    color: hasIncomingRequest ? Colors.green : scheme.primary,
                                  ),
                                ),
                              ),
                            ),

                        ],
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
                  Icon(Icons.chevron_right_rounded,
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
