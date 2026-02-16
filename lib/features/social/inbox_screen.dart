import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/widgets/glass.dart';
import '../../core/widgets/premium_dialog.dart';
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
  final Set<String> _selectedThreadIds = <String>{};
  bool _showArchivedOnly = false;
  bool _selectionMode = false;
  _InboxFilter _filter = _InboxFilter.all;
  String _onboardingPrompt = 'Start with a quick hello to a friend.';
  int _refreshNonce = 0;
  _InboxSort _sort = _InboxSort.latest;
  final Map<String, DateTime> _snoozedUntil = <String, DateTime>{};
  final Set<String> _hiddenPreviewThreadIds = <String>{};
  bool _scheduledDigestEnabled = false;

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
        _scheduledDigestEnabled = settings['inbox_digest_enabled'] == true;
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

  Future<void> _toggleScheduledDigest() async {
    final next = !_scheduledDigestEnabled;
    setState(() => _scheduledDigestEnabled = next);
    await settingsRepository.updateSetting('inbox_digest_enabled', next);
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
    await chatRepository.getInboxThreads();
    if (!mounted) return;
    setState(() => _refreshNonce++);
  }


  Future<void> _openThread(Map<String, dynamic> t) async {
    final otherId = t['otherId']?.toString() ?? '';
    if (otherId.isEmpty) return;
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DmChatScreen(
          meId: authRepository.currentUser?.id ?? 'me',
          otherId: otherId,
          otherName: t['otherName']?.toString() ?? 'Unknown',
        ),
      ),
    );
    if (mounted) setState(() => _refreshNonce++);
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
                      PopupMenuItem(
                        enabled: false,
                        child: Row(
                          children: [
                            Icon(_scheduledDigestEnabled ? Icons.notifications_active_rounded : Icons.notifications_none_rounded, size: 16),
                            const SizedBox(width: 8),
                            Text(_scheduledDigestEnabled ? 'Digest: on' : 'Digest: off'),
                          ],
                        ),
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
                    icon: _scheduledDigestEnabled ? Icons.notifications_active_rounded : Icons.notifications_none_rounded,
                    onTap: _toggleScheduledDigest,
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
              if (_scheduledDigestEnabled)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Glass(
                    radius: BorderRadius.circular(14),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: Row(
                      children: [
                        Icon(Icons.wb_sunny_rounded, size: 16, color: scheme.primary),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Morning digest enabled: get one smart summary instead of many pings.',
                            style: TextStyle(color: scheme.onSurface.withValues(alpha: 0.78), fontWeight: FontWeight.w700, fontSize: 11.5),
                          ),
                        ),
                        IconButton(
                          tooltip: 'Toggle',
                          onPressed: _toggleScheduledDigest,
                          icon: Icon(Icons.tune_rounded, size: 16, color: scheme.primary),
                        ),
                      ],
                    ),
                  ),
                ),
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
                        label: 'Priority',
                        selected: _filter == _InboxFilter.priority,
                        onTap: () => setState(() => _filter = _InboxFilter.priority),
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
                        label: 'Friends',
                        selected: _filter == _InboxFilter.friends,
                        onTap: () => setState(() => _filter = _InboxFilter.friends),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 6),
              Glass(
                radius: BorderRadius.circular(20),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: _FilterPill(
                        label: 'Requests',
                        selected: _filter == _InboxFilter.requests,
                        onTap: () => setState(() => _filter = _InboxFilter.requests),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: _FilterPill(
                        label: 'Groups',
                        selected: _filter == _InboxFilter.groups,
                        onTap: () => setState(() => _filter = _InboxFilter.groups),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: _FilterPill(
                        label: 'Muted',
                        selected: _filter == _InboxFilter.muted,
                        onTap: () => setState(() => _filter = _InboxFilter.muted),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: _FilterPill(
                        label: 'Archived',
                        selected: _filter == _InboxFilter.archived,
                        onTap: () => setState(() {
                          _filter = _InboxFilter.archived;
                          _showArchivedOnly = true;
                        }),
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
                    final unreadTotal = visibleThreads.fold<int>(0, (sum, t) => sum + ((t['unreadCount'] as int?) ?? 0));
                    final unreadThreads = visibleThreads.where((t) => ((t['unreadCount'] as int?) ?? 0) > 0).length;
                    final requestCount = visibleThreads.where((t) => t['hasIncomingRequest'] == true || t['hasOutgoingRequest'] == true).length;
                    final archivedMentions = visibleThreads.where((t) => _archivedThreadIds.contains(t['otherId']?.toString() ?? '')).length;
                    final vipThreads = visibleThreads.where((t) => _pinnedThreadIds.contains(t['otherId']?.toString() ?? '')).take(8).toList();
                    final weeklyPracticeMinutes = (visibleThreads.length * 6).clamp(6, 180);
                    final weeklyVoiceNotes = visibleThreads.where((t) => (t['lastMsg']?.toString() ?? '').contains('voice')).length;
                    return Glass(
                      radius: BorderRadius.circular(22),
                      padding: const EdgeInsets.all(10),
                      child: StreamBuilder<Map<String, bool>>(
                        stream: presenceRepository.streamMultipleOnlineStatuses(participantIds),
                        builder: (context, presenceSnapshot) {
                          final onlineStatuses = presenceSnapshot.data ?? {};
                          return Column(
                            children: [
                              _CatchUpSummaryCard(
                                unreadTotal: unreadTotal,
                                unreadThreads: unreadThreads,
                                requestCount: requestCount,
                                archivedMentions: archivedMentions,
                              ),
                              _ConversationMemoryCard(
                                minutes: weeklyPracticeMinutes,
                                voiceNotes: weeklyVoiceNotes,
                              ),
                              _WeeklyReportShareCard(
                                minutes: weeklyPracticeMinutes,
                                voiceNotes: weeklyVoiceNotes,
                                cefrHint: visibleThreads.where((t) => t['hasCorrectionUnread'] == true).isNotEmpty ? 'B2' : 'B1',
                              ),
                              _AdaptiveChallengesRow(
                                challenges: [
                                  if (visibleThreads.where((t) => t['hasCorrectionUnread'] == true).isNotEmpty)
                                    _AdaptiveChallenge(
                                      label: '${visibleThreads.where((t) => t['hasCorrectionUnread'] == true).length} corrections unread — do now',
                                      onTap: () => _openThread(visibleThreads.firstWhere((t) => t['hasCorrectionUnread'] == true)),
                                    ),
                                  if (visibleThreads.where((t) => t['practiceStreakAtRisk'] == true).isNotEmpty)
                                    _AdaptiveChallenge(
                                      label: 'Streak at risk — send one voice note',
                                      onTap: () => _openThread(visibleThreads.firstWhere((t) => t['practiceStreakAtRisk'] == true)),
                                    ),
                                  if (visibleThreads.isNotEmpty)
                                    _AdaptiveChallenge(
                                      label: 'Use 3 B2 connectors today',
                                      onTap: () => _openThread(visibleThreads.first),
                                    ),
                                ],
                              ),
                              if (vipThreads.isNotEmpty)
                                _VipPinnedRow(
                                  threads: vipThreads,
                                ),
                              Expanded(
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
                            final hidePreview = _hiddenPreviewThreadIds.contains(otherId);
                            final trustScore = (((t['isFriend'] == true ? 60 : 35) + ((unreadCount as int) > 0 ? 10 : 0) + (t['hasIncomingRequest'] == true ? 5 : 0)).clamp(0, 99) as num).toInt();

                            return Dismissible(
                              key: ValueKey('thread-$otherId'),
                              direction: _selectionMode ? DismissDirection.none : DismissDirection.horizontal,
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
                                partnerQuality: (t['partnerQuality'] as num?)?.toInt() ?? trustScore,
                                reliabilityScore: (t['reliabilityScore'] as num?)?.toInt() ?? 72,
                                correctionHelpfulnessScore: (t['correctionHelpfulnessScore'] as num?)?.toInt() ?? 68,
                                voiceFeedbackScore: (t['voiceFeedbackScore'] as num?)?.toInt() ?? 70,
                                verifiedSeriousLearner: t['verifiedSeriousLearner'] == true,
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
                                  } else {
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
                                  }
                                },
                                onLongPress: () {
                                  if (!_selectionMode) {
                                    setState(() {
                                      _selectionMode = true;
                                      });
                                    }
                                  },
                                ),
                              );
                            },
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


class _CatchUpSummaryCard extends StatelessWidget {
  final int unreadTotal;
  final int unreadThreads;
  final int requestCount;
  final int archivedMentions;

  const _CatchUpSummaryCard({
    required this.unreadTotal,
    required this.unreadThreads,
    required this.requestCount,
    required this.archivedMentions,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Glass(
        radius: BorderRadius.circular(16),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Row(
          children: [
            Icon(Icons.auto_awesome_rounded, size: 16, color: scheme.primary),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                '$unreadTotal unread across $unreadThreads chats · $requestCount requests · $archivedMentions archived mentions',
                style: TextStyle(
                  color: scheme.onSurface.withValues(alpha: 0.82),
                  fontWeight: FontWeight.w700,
                  fontSize: 11.5,
                ),
              ),
            ),
          ],
        ),
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


class _ConversationMemoryCard extends StatelessWidget {
  final int minutes;
  final int voiceNotes;

  const _ConversationMemoryCard({required this.minutes, required this.voiceNotes});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Glass(
        radius: BorderRadius.circular(14),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          children: [
            Icon(Icons.insights_rounded, size: 16, color: scheme.tertiary),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Weekly memory: you practiced ~$minutes min and exchanged $voiceNotes voice notes.',
                style: TextStyle(
                  color: scheme.onSurface.withValues(alpha: 0.8),
                  fontWeight: FontWeight.w700,
                  fontSize: 11.5,
                ),
              ),
            ),
          ],
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

class _AdaptiveChallenge {
  final String label;
  final VoidCallback onTap;

  const _AdaptiveChallenge({required this.label, required this.onTap});
}

class _AdaptiveChallengesRow extends StatelessWidget {
  final List<_AdaptiveChallenge> challenges;

  const _AdaptiveChallengesRow({required this.challenges});

  @override
  Widget build(BuildContext context) {
    if (challenges.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(top: 6, bottom: 6),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            for (final c in challenges)
              Padding(
                padding: const EdgeInsets.only(right: 6),
                child: ActionChip(
                  avatar: const Icon(Icons.flash_on_rounded, size: 14),
                  label: Text(c.label),
                  onPressed: c.onTap,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _WeeklyReportShareCard extends StatelessWidget {
  final int minutes;
  final int voiceNotes;
  final String cefrHint;

  const _WeeklyReportShareCard({required this.minutes, required this.voiceNotes, required this.cefrHint});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final report = 'Weekly Learning Report\n• Voice minutes: $minutes\n• Voice notes: $voiceNotes\n• CEFR confidence: $cefrHint\n• Best partner: Keep your top streak thread active.';
    return Padding(
      padding: const EdgeInsets.only(top: 6, bottom: 6),
      child: Glass(
        radius: BorderRadius.circular(14),
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            Expanded(
              child: Text(
                report,
                style: TextStyle(color: scheme.onSurface.withValues(alpha: 0.8), fontWeight: FontWeight.w700, fontSize: 11.5),
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              tooltip: 'Copy report',
              onPressed: () async {
                await Clipboard.setData(ClipboardData(text: report));
              },
              icon: const Icon(Icons.ios_share_rounded),
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
  final int partnerQuality;
  final int reliabilityScore;
  final int correctionHelpfulnessScore;
  final int voiceFeedbackScore;
  final bool verifiedSeriousLearner;
  final bool selectionMode;
  final bool selected;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

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
                          if (practiceStreakAtRisk || hasChallengePending || hasCorrectionUnread || hasVoiceFeedback)
                            Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Wrap(
                                spacing: 6,
                                runSpacing: 4,
                                children: [
                                  if (practiceStreakAtRisk)
                                    _MiniBadge(label: '⚠️ Streak at risk', color: Colors.orange),
                                  if (hasChallengePending)
                                    _MiniBadge(label: 'Challenge pending', color: scheme.primary),
                                  if (hasCorrectionUnread)
                                    _MiniBadge(label: 'Correction unread', color: scheme.tertiary),
                                  if (hasVoiceFeedback)
                                    _MiniBadge(label: 'Voice feedback', color: Colors.deepPurple),
                                ],
                              ),
                            ),
                          Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Wrap(
                              spacing: 6,
                              runSpacing: 4,
                              children: [
                                _MiniBadge(
                                  label: 'Partner quality $partnerQuality%',
                                  color: partnerQuality >= 75 ? Colors.green : scheme.onSurface,
                                ),
                                _MiniBadge(label: 'Reliability $reliabilityScore%', color: scheme.primary),
                                _MiniBadge(label: 'Correction helpfulness $correctionHelpfulnessScore%', color: scheme.tertiary),
                                _MiniBadge(label: 'Voice feedback $voiceFeedbackScore%', color: Colors.deepPurple),
                                if (verifiedSeriousLearner)
                                  _MiniBadge(label: 'Verified serious learner', color: Colors.green),
                              ],
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
                          if (hasIncomingRequest)
                            Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(999),
                                  color: scheme.tertiary.withValues(alpha: 0.14),
                                  border: Border.all(color: scheme.tertiary.withValues(alpha: 0.35)),
                                ),
                                child: Text(
                                  'Likely safe · $trustScore%',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w800,
                                    color: scheme.tertiary,
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


class _MiniBadge extends StatelessWidget {
  final String label;
  final Color color;

  const _MiniBadge({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        color: color.withValues(alpha: 0.14),
        border: Border.all(color: color.withValues(alpha: 0.35)),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w800,
          color: color,
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
