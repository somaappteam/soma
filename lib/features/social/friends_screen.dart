import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:soma/core/widgets/glass.dart';
import 'package:soma/data/auth_repository.dart';
import 'package:soma/data/presence_repository.dart';
import 'package:soma/data/settings_repository.dart';
import 'package:soma/data/social_repository.dart';
import 'package:soma/features/profile/profile_screen.dart';
import 'package:soma/features/social/add_friend_screen.dart';
import 'package:soma/features/social/dm_chat_screen.dart';
import 'package:soma/l10n/gen/app_localizations.dart';
import 'package:soma/models/friend.dart';

class FriendsScreen extends StatefulWidget {
  const FriendsScreen({super.key});

  @override
  State<FriendsScreen> createState() => _FriendsScreenState();
}

enum FriendViewFilter { all, online, requests }
enum FriendSortOption { recent, onlineFirst, name }



class _FriendsScreenState extends State<FriendsScreen> {
  String query = '';
  FriendViewFilter _filter = FriendViewFilter.all;
  FriendSortOption _sort = FriendSortOption.recent;
  Set<String> _favoriteFriendIds = <String>{};
  Map<String, bool> _onlineStatuses = {};
  StreamSubscription? _onlineSub;
  List<String> _currentFriendIds = [];

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  @override
  void dispose() {
    _onlineSub?.cancel();
    super.dispose();
  }

  void _updateOnlineSubscription(final List<String> ids) {
    if (listEquals(ids, _currentFriendIds)) return;
    _currentFriendIds = ids;
    _onlineSub?.cancel();
    _onlineSub = presenceRepository.streamMultipleOnlineStatuses(ids).listen((final statuses) {
      if (!mounted) return;
      setState(() => _onlineStatuses = statuses);
    });
  }

  Future<void> _loadFavorites() async {
    final settings = await settingsRepository.getSettings();
    final ids = (settings['favorite_friend_ids'] as List?)
            ?.map((final e) => e.toString())
            .where((final e) => e.isNotEmpty)
            .toSet() ??
        <String>{};
    if (!mounted) return;
    setState(() => _favoriteFriendIds = ids);
  }

  Future<void> _toggleFavorite(final String friendId) async {
    final next = Set<String>.from(_favoriteFriendIds);
    if (next.contains(friendId)) {
      next.remove(friendId);
    } else {
      next.add(friendId);
    }
    setState(() => _favoriteFriendIds = next);
    await settingsRepository.updateSetting('favorite_friend_ids', next.toList());
    _trackUiEvent('favorite_toggle', {'friendId': friendId, 'favorited': next.contains(friendId)});
  }

  void _trackUiEvent(final String event, [final Map<String, dynamic>? extras]) {
    debugPrint('[friends_ui] $event ${extras ?? const <String, dynamic>{}}');
  }

  // Simplified handling for mapping friendship ID
  Future<void> _accept(final String friendshipId) async {
    await socialRepository.acceptFriendRequest(friendshipId);
  }

  Future<void> _decline(final String friendshipId) async {
    await socialRepository.declineFriendRequest(friendshipId);
  }

  Future<void> _cancelOutgoing(final String friendshipId) async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (final ctx) => AlertDialog(
        title: Text('Cancel request?'),
        content: Text('You can send a new friend request later.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(l10n.cancel)),
          TextButton(onPressed: () => Navigator.pop(ctx, true), child: Text(l10n.decline)),
        ],
      ),
    );
    if (confirmed != true) return;
    await socialRepository.cancelFriendRequest(friendshipId);
  }

  Future<void> _removeFriend(final String friendUserId) async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (final ctx) => AlertDialog(
        title: Text('Remove friend?'),
        content: Text("You will no longer appear in each other's friends list."),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(l10n.cancel)),
          TextButton(onPressed: () => Navigator.pop(ctx, true), child: Text(l10n.leave)),
        ],
      ),
    );
    if (confirmed != true) return;
    await socialRepository.removeFriend(friendUserId);
  }

  Future<void> _acceptAll(final List<Friend> incoming) async {
    for (final f in incoming) {
      await _accept(f.id);
    }
    _trackUiEvent('accept_all', {'count': incoming.length});
  }

  Future<void> _declineAll(final List<Friend> incoming) async {
    for (final f in incoming) {
      await _decline(f.id);
    }
    _trackUiEvent('decline_all', {'count': incoming.length});
  }

  Future<void> _copyInviteLink() async {
    final uid = authRepository.currentUser?.id ?? 'guest';
    await Clipboard.setData(ClipboardData(text: 'https://soma.app/invite/$uid'));
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Invite link copied')),
    );
    _trackUiEvent('invite_link_copy');
  }

  @override
  Widget build(final BuildContext context) {
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
                      l10n.friendsTitle,
                      style: TextStyle(
                        color: scheme.onSurface,
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const Spacer(),
                    _IconGlass(
                      icon: Icons.person_add_alt_1_rounded,
                      onTap: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (final _) => const AddFriendScreen()),
                        );
                        if (!mounted) return;
                      },
                    ),
                  ],
                ),

                const SizedBox(height: 14),

                // Search
                Glass(
                  radius: BorderRadius.circular(20),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  child: Row(
                    children: [
                      Icon(Icons.search_rounded,
                          color: scheme.onSurface.withValues(alpha: 0.7)),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          onChanged: (final v) => setState(() => query = v),
                          style: TextStyle(
                              color: scheme.onSurface, fontWeight: FontWeight.w700),
                          cursorColor: scheme.onSurface,
                          decoration: InputDecoration(
                            hintText: l10n.searchFriendsHint,
                            hintStyle: TextStyle(
                                color: scheme.onSurface.withValues(alpha: 0.45)),
                            border: InputBorder.none,
                            isDense: true,
                          ),
                        ),
                      ),
                      if (query.isNotEmpty)
                        GestureDetector(
                          onTap: () => setState(() => query = ''),
                          child: Icon(Icons.close_rounded,
                              color: scheme.onSurface.withValues(alpha: 0.7)),
                        ),
                    ],
                  ),
                ),

                const SizedBox(height: 14),

                Expanded(
                  child: StreamBuilder<List<Map<String, dynamic>>>(
                    stream: socialRepository.getFriendsStream(),
                    builder: (final context, final friendsSnapshot) {
                      return StreamBuilder<List<Map<String, dynamic>>>(
                        stream: socialRepository.getIncomingRequestsStream(),
                        builder: (final context, final incomingSnapshot) {
                          return StreamBuilder<List<Map<String, dynamic>>>(
                            stream:
                                socialRepository.getOutgoingRequestsStream(),
                            builder: (final context, final outgoingSnapshot) {
                              if (friendsSnapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                    child: CircularProgressIndicator(
                                        color: Color(0xFF2AFADF)));
                              }

                              final friendsData = friendsSnapshot.data ?? [];
                              final incomingData = incomingSnapshot.data ?? [];
                              final outgoingData = outgoingSnapshot.data ?? [];

                              final friends = friendsData
                                  .map((final data) => Friend(
                                        id: data['id'],
                                        username: data['username'] ?? l10n.genericUser,
                                        subtitle:
                                            data['location'] ?? l10n.somaLearnerSubtitle,
                                        status: FriendStatus.friend,
                                      ))
                                  .toList();
                              
                              _updateOnlineSubscription(friends.map((final f) => f.id).toList());

                              final incoming = incomingData.map((final data) {
                                final requester = data['requester'] ?? {};
                                return Friend(
                                  id: data['id'].toString(),
                                  username: requester['username'] ?? l10n.genericUser,
                                  subtitle: l10n.friendIncomingRequestLabel,
                                  status: FriendStatus.incomingRequest,
                                );
                              }).toList();

                              final outgoing = outgoingData.map((final data) {
                                final addressee = data['addressee'] ?? {};
                                return Friend(
                                  id: data['id'].toString(),
                                  username: addressee['username'] ?? l10n.genericUser,
                                  subtitle: l10n.friendRequestSentLabel,
                                  status: FriendStatus.outgoingRequest,
                                );
                              }).toList();

                              final filtered = friends.where((final f) {
                                final q = query.trim().toLowerCase();
                                if (q.isEmpty) return true;
                                return f.username.toLowerCase().contains(q) ||
                                    (f.subtitle ?? '').toLowerCase().contains(q);
                              }).toList();

                              filtered.sort((final a, final b) {
                                final q = query.trim().toLowerCase();
                                final aFav = _favoriteFriendIds.contains(a.id) ? 0 : 1;
                                final bFav = _favoriteFriendIds.contains(b.id) ? 0 : 1;
                                if (aFav != bFav) return aFav.compareTo(bFav);

                                if (_sort == FriendSortOption.onlineFirst) {
                                  final aOnline = _onlineStatuses[a.id] == true;
                                  final bOnline = _onlineStatuses[b.id] == true;
                                  final onlineCmp = (bOnline ? 1 : 0).compareTo(aOnline ? 1 : 0);
                                  if (onlineCmp != 0) return onlineCmp;
                                }

                                if (_sort == FriendSortOption.name) {
                                  return a.username.toLowerCase().compareTo(b.username.toLowerCase());
                                }

                                if (q.isNotEmpty) {
                                  final aStarts = a.username.toLowerCase().startsWith(q) ? 0 : 1;
                                  final bStarts = b.username.toLowerCase().startsWith(q) ? 0 : 1;
                                  if (aStarts != bStarts) return aStarts.compareTo(bStarts);
                                }

                                return a.username.toLowerCase().compareTo(b.username.toLowerCase());
                              });

                              final visibleFriends = filtered.where((final f) {
                                final isOnline = _onlineStatuses[f.id] == true;
                                return switch (_filter) {
                                  FriendViewFilter.all => true,
                                  FriendViewFilter.online => isOnline,
                                  FriendViewFilter.requests => false,
                                };
                              }).toList();

                              final totalRequests = incoming.length + outgoing.length;

                              return ListView(
                                physics: const BouncingScrollPhysics(),
                                children: [
                                  _FriendsOverviewCard(
                                    friendsCount: friends.length,
                                    onlineCount: friends.where((final f) => _onlineStatuses[f.id] == true).length,
                                    requestsCount: totalRequests,
                                  ),
                                  const SizedBox(height: 12),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: _FilterChip(
                                          label: 'All',
                                          selected: _filter == FriendViewFilter.all,
                                          onTap: () {
                                            _trackUiEvent('filter_all');
                                            setState(() => _filter = FriendViewFilter.all);
                                          },
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: _FilterChip(
                                          label: 'Online',
                                          selected: _filter == FriendViewFilter.online,
                                          onTap: () {
                                            _trackUiEvent('filter_online');
                                            setState(() => _filter = FriendViewFilter.online);
                                          },
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: _FilterChip(
                                          label: 'Requests',
                                          selected: _filter == FriendViewFilter.requests,
                                          onTap: () {
                                            _trackUiEvent('filter_requests');
                                            setState(() => _filter = FriendViewFilter.requests);
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: PopupMenuButton<FriendSortOption>(
                                      initialValue: _sort,
                                      onSelected: (final next) {
                                        _trackUiEvent('sort_change', {'value': next.name});
                                        setState(() => _sort = next);
                                      },
                                      itemBuilder: (final _) => const [
                                        PopupMenuItem(
                                          value: FriendSortOption.recent,
                                          child: Text('Sort: Recent activity'),
                                        ),
                                        PopupMenuItem(
                                          value: FriendSortOption.onlineFirst,
                                          child: Text('Sort: Online first'),
                                        ),
                                        PopupMenuItem(
                                          value: FriendSortOption.name,
                                          child: Text('Sort: Name A-Z'),
                                        ),
                                      ],
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(12),
                                          color: scheme.onSurface.withValues(alpha: 0.08),
                                          border: Border.all(color: scheme.onSurface.withValues(alpha: 0.12)),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(Icons.swap_vert_rounded, size: 16, color: scheme.onSurface.withValues(alpha: 0.86)),
                                            const SizedBox(width: 6),
                                            Text(
                                              _sort == FriendSortOption.recent
                                                  ? 'Recent'
                                                  : _sort == FriendSortOption.onlineFirst
                                                      ? 'Online first'
                                                      : 'A-Z',
                                              style: TextStyle(
                                                color: scheme.onSurface.withValues(alpha: 0.86),
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 14),
                                  if (_filter != FriendViewFilter.online && incoming.isNotEmpty) ...[
                                    _SectionTitle(l10n.friendRequestsSection),
                                    const SizedBox(height: 10),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: TextButton.icon(
                                            onPressed: () => _acceptAll(incoming),
                                            icon: const Icon(Icons.done_all_rounded),
                                            label: const Text('Accept all'),
                                          ),
                                        ),
                                        Expanded(
                                          child: TextButton.icon(
                                            onPressed: () => _declineAll(incoming),
                                            icon: const Icon(Icons.close_rounded),
                                            label: const Text('Decline all'),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Glass(
                                      radius: BorderRadius.circular(22),
                                      padding: const EdgeInsets.all(12),
                                      child: Column(
                                        children: incoming.map((final f) {
                                          return _RequestRow(
                                            friend: f,
                                            onAccept: () => _accept(f.id),
                                            onDecline: () => _decline(f.id),
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                  ],
                                  if (_filter != FriendViewFilter.online && outgoing.isNotEmpty) ...[
                                    _SectionTitle(l10n.friendPendingSection),
                                    const SizedBox(height: 10),
                                    Glass(
                                      radius: BorderRadius.circular(22),
                                      padding: const EdgeInsets.all(12),
                                      child: Column(
                                        children: outgoing.map((final f) {
                                          return _PendingRow(
                                            friend: f,
                                            onCancel: () =>
                                                _cancelOutgoing(f.id),
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                  ],
                                  if (_filter != FriendViewFilter.requests) ...[
                                    _SectionTitle('Active now'),
                                    const SizedBox(height: 10),
                                  ],
                                  if (_filter == FriendViewFilter.requests && incoming.isEmpty && outgoing.isEmpty)
                                    Glass(
                                      radius: BorderRadius.circular(22),
                                      padding: const EdgeInsets.all(16),
                                      child: Text(
                                        'No pending requests right now.',
                                        style: TextStyle(
                                          color: scheme.onSurface.withValues(alpha: 0.75),
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    )
                                  else if (_filter != FriendViewFilter.requests && visibleFriends.isEmpty)
                                    Glass(
                                      radius: BorderRadius.circular(22),
                                      padding: const EdgeInsets.all(16),
                                      child: Text(
                                        query.isEmpty
                                            ? l10n.friendsEmptyState
                                            : l10n.noMatchForQuery(query),
                                        style: TextStyle(
                                          color: scheme.onSurface.withValues(alpha: 0.75),
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    )
                                  else if (_filter != FriendViewFilter.requests)
                                    Glass(
                                      radius: BorderRadius.circular(22),
                                      padding: const EdgeInsets.all(12),
                                      child: Column(
                                        children: visibleFriends.where((final f) => _onlineStatuses[f.id] == true).map((final f) {
                                          return _FriendRow(
                                            friend: f,
                                            isFavorite: _favoriteFriendIds.contains(f.id),
                                            onToggleFavorite: () => _toggleFavorite(f.id),
                                            onOpenProfile: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (final _) => ProfileScreen(userId: f.id),
                                                ),
                                              );
                                            },
                                            onMessage: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (final _) => DmChatScreen(
                                            meId: socialRepository.currentUserId ?? 
                                                        authRepository.currentUser?.id ??
                                                        'me',
                                                    otherId: f.id,
                                                    otherName: f.username,
                                                  ),
                                                ),
                                              );
                                            },
                                            onRemove: () => _removeFriend(f.id),
                                            isOnline: true,
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                   if (_filter != FriendViewFilter.requests && visibleFriends.any((final f) => _onlineStatuses[f.id] != true)) ...[
                                     const SizedBox(height: 14),
                                     _SectionTitle('Recently active'),
                                     const SizedBox(height: 10),
                                     Glass(
                                       radius: BorderRadius.circular(22),
                                       padding: const EdgeInsets.all(12),
                                       child: Column(
                                         children: visibleFriends.where((final f) => _onlineStatuses[f.id] != true).map((final f) {
                                           return _FriendRow(
                                             friend: f,
                                             isFavorite: _favoriteFriendIds.contains(f.id),
                                             onToggleFavorite: () => _toggleFavorite(f.id),
                                             onOpenProfile: () {
                                               Navigator.push(
                                                 context,
                                                 MaterialPageRoute(
                                                   builder: (final _) => ProfileScreen(userId: f.id),
                                                 ),
                                               );
                                             },
                                             onMessage: () {
                                               Navigator.push(
                                                 context,
                                                 MaterialPageRoute(
                                                   builder: (final _) => DmChatScreen(
                                                     meId: socialRepository.currentUserId ?? authRepository.currentUser?.id ?? 'me',
                                                     otherId: f.id,
                                                     otherName: f.username,
                                                   ),
                                                 ),
                                               );
                                             },
                                             onRemove: () => _removeFriend(f.id),
                                             isOnline: false,
                                           );
                                         }).toList(),
                                       ),
                                     ),
                                   ],
                                ],
                              );
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
}

// ---------------- UI rows ----------------

class _FriendsOverviewCard extends StatelessWidget {
  final int friendsCount;
  final int onlineCount;
  final int requestsCount;

  const _FriendsOverviewCard({
    required this.friendsCount,
    required this.onlineCount,
    required this.requestsCount,
  });

  @override
  Widget build(final BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Glass(
      radius: BorderRadius.circular(22),
      padding: const EdgeInsets.all(14),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _OverviewMetric(
                  label: 'Friends',
                  value: '$friendsCount',
                  icon: Icons.group_rounded,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _OverviewMetric(
                  label: 'Online',
                  value: '$onlineCount',
                  icon: Icons.circle_rounded,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _OverviewMetric(
                  label: 'Requests',
                  value: '$requestsCount',
                  icon: Icons.mark_email_unread_rounded,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _OverviewMetric extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _OverviewMetric({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(final BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: scheme.onSurface.withValues(alpha: 0.08),
        border: Border.all(color: scheme.onSurface.withValues(alpha: 0.14)),
      ),
      child: Column(
        children: [
          Icon(icon, size: 16, color: scheme.onSurface.withValues(alpha: 0.9)),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              color: scheme.onSurface,
              fontWeight: FontWeight.w900,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              color: scheme.onSurface.withValues(alpha: 0.7),
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(final BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Container(
        height: 38,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: selected
              ? scheme.primary.withValues(alpha: 0.18)
              : scheme.onSurface.withValues(alpha: 0.06),
          border: Border.all(
            color: selected
                ? scheme.primary.withValues(alpha: 0.45)
                : scheme.onSurface.withValues(alpha: 0.14),
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            color: scheme.onSurface,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);

  @override
  Widget build(final BuildContext context) {
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


class _IconGlass extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _IconGlass({required this.icon, required this.onTap});

  @override
  Widget build(final BuildContext context) {
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

class _AvatarDot extends StatelessWidget {
  final bool online;
  final String username;
  const _AvatarDot({required this.online, required this.username});

  @override
  Widget build(final BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: scheme.onSurface.withValues(alpha: 0.10),
        border: Border.all(color: scheme.onSurface.withValues(alpha: 0.16)),
      ),
      child: Stack(
        children: [
          Center(
            child: Text(
              username.trim().isEmpty ? '?' : username.trim().substring(0, 1).toUpperCase(),
              style:
                  TextStyle(fontSize: 18, color: scheme.onSurface.withValues(alpha: 0.9)),
            ),
          ),
          Positioned(
            bottom: 3,
            right: 3,
            child: Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: online
                    ? const Color(0xFF58F7B6)
                    : scheme.onSurface.withValues(alpha: 0.25),
                border:
                    Border.all(color: scheme.surface.withValues(alpha: 0.35), width: 2), // border matches bg
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FriendRow extends StatelessWidget {
  final Friend friend;
  final bool isFavorite;
  final VoidCallback onToggleFavorite;
  final VoidCallback onOpenProfile;
  final VoidCallback onMessage;
  final VoidCallback onRemove;
  final bool isOnline;

  const _FriendRow({
    required this.friend,
    required this.isFavorite,
    required this.onToggleFavorite,
    required this.onOpenProfile,
    required this.onMessage,
    required this.onRemove,
    required this.isOnline,
  });

  @override
  Widget build(final BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          color: scheme.onSurface.withValues(alpha: 0.06),
          border: Border.all(color: scheme.onSurface.withValues(alpha: 0.14)),
        ),
        child: Row(
          children: [
            GestureDetector(
              onTap: onOpenProfile,
              onLongPress: onOpenProfile,
              child: _AvatarDot(online: isOnline, username: friend.username),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        friend.username,
                        style: TextStyle(
                            color: scheme.onSurface,
                            fontSize: 15,
                            fontWeight: FontWeight.w900),
                      ),
                      if (isOnline) ...[
                        const SizedBox(width: 6),
                        Container(
                          width: 7,
                          height: 7,
                          decoration: const BoxDecoration(
                            color: Color(0xFF58F7B6),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ],
                    ],
                  ),
                  Text(
                    isOnline ? 'Online' : (friend.subtitle ?? 'Learning'),
                    style: TextStyle(
                        color: isOnline
                            ? const Color(0xFF58F7B6)
                            : scheme.onSurface.withValues(alpha: 0.65),
                        fontSize: 11,
                        fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            _MiniAction(
              icon: isFavorite ? Icons.star_rounded : Icons.star_border_rounded,
              onTap: onToggleFavorite,
            ),
            const SizedBox(width: 8),
            _MiniAction(icon: Icons.chat_bubble_rounded, onTap: onMessage),
            const SizedBox(width: 8),
            _MiniAction(icon: Icons.person_remove_rounded, onTap: onRemove),
          ],
        ),
      ),
    );
  }
}

class _RequestRow extends StatelessWidget {
  final Friend friend;
  final VoidCallback onAccept;
  final VoidCallback onDecline;

  const _RequestRow({
    required this.friend,
    required this.onAccept,
    required this.onDecline,
  });

  @override
  Widget build(final BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          color: scheme.onSurface.withValues(alpha: 0.06),
          border: Border.all(color: scheme.onSurface.withValues(alpha: 0.14)),
        ),
        child: Row(
          children: [
            _AvatarDot(online: false, username: friend.username),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                friend.username,
                style: TextStyle(
                  color: scheme.onSurface,
                  fontWeight: FontWeight.w900,
                  fontSize: 14.5,
                ),
              ),
            ),
            _MiniAction(icon: Icons.close_rounded, onTap: onDecline),
            const SizedBox(width: 8),
            _MiniAction(icon: Icons.check_rounded, onTap: onAccept),
          ],
        ),
      ),
    );
  }
}

class _PendingRow extends StatelessWidget {
  final Friend friend;
  final VoidCallback onCancel;

  const _PendingRow({required this.friend, required this.onCancel});

  @override
  Widget build(final BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          color: scheme.onSurface.withValues(alpha: 0.06),
          border: Border.all(color: scheme.onSurface.withValues(alpha: 0.14)),
        ),
        child: Row(
          children: [
            _AvatarDot(online: false, username: friend.username),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    friend.username,
                    style: TextStyle(
                      color: scheme.onSurface,
                      fontWeight: FontWeight.w900,
                      fontSize: 14.5,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    'Request sent',
                    style: TextStyle(
                      color: scheme.onSurface.withValues(alpha: 0.60),
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            _MiniAction(icon: Icons.undo_rounded, onTap: onCancel),
          ],
        ),
      ),
    );
  }
}

class _MiniAction extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _MiniAction({required this.icon, required this.onTap});

  @override
  Widget build(final BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: scheme.onSurface.withValues(alpha: 0.08),
          border: Border.all(color: scheme.onSurface.withValues(alpha: 0.14)),
        ),
        child: Icon(icon, color: scheme.onSurface.withValues(alpha: 0.92), size: 20),
      ),
    );
  }
}
