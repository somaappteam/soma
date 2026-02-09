import 'package:flutter/material.dart';

import '../../core/widgets/glass.dart';
import '../../models/friend.dart';
import '../../data/social_repository.dart';
import 'add_friend_screen.dart';
import 'dm_chat_screen.dart';
import 'package:soma/l10n/gen/app_localizations.dart';

class FriendsScreen extends StatefulWidget {
  const FriendsScreen({super.key});

  @override
  State<FriendsScreen> createState() => _FriendsScreenState();
}



class _FriendsScreenState extends State<FriendsScreen> {
  String query = "";

  @override
  void initState() {
    super.initState();
  }

  // Simplified handling for mapping friendship ID
  Future<void> _accept(String friendshipId) async {
    await socialRepository.acceptFriendRequest(friendshipId);
  }

  Future<void> _decline(String friendshipId) async {
    await socialRepository.declineFriendRequest(friendshipId);
  }

  Future<void> _cancelOutgoing(String friendshipId) async {
    await socialRepository.cancelFriendRequest(friendshipId);
  }

  Future<void> _removeFriend(String friendUserId) async {
    await socialRepository.removeFriend(friendUserId);
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
                              builder: (_) => const AddFriendScreen()),
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
                          onChanged: (v) => setState(() => query = v),
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
                          onTap: () => setState(() => query = ""),
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
                    builder: (context, friendsSnapshot) {
                      return StreamBuilder<List<Map<String, dynamic>>>(
                        stream: socialRepository.getIncomingRequestsStream(),
                        builder: (context, incomingSnapshot) {
                          return StreamBuilder<List<Map<String, dynamic>>>(
                            stream:
                                socialRepository.getOutgoingRequestsStream(),
                            builder: (context, outgoingSnapshot) {
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
                                  .map((data) => Friend(
                                        id: data['id'],
                                        username: data['username'] ?? l10n.genericUser,
                                        subtitle:
                                            data['location'] ?? l10n.somaLearnerSubtitle,
                                        status: FriendStatus.friend,
                                      ))
                                  .toList();

                              final incoming = incomingData.map((data) {
                                final requester = data['requester'] ?? {};
                                return Friend(
                                  id: data['id'].toString(),
                                  username: requester['username'] ?? l10n.genericUser,
                                  subtitle: l10n.friendIncomingRequestLabel,
                                  status: FriendStatus.incomingRequest,
                                );
                              }).toList();

                              final outgoing = outgoingData.map((data) {
                                final addressee = data['addressee'] ?? {};
                                return Friend(
                                  id: data['id'].toString(),
                                  username: addressee['username'] ?? l10n.genericUser,
                                  subtitle: l10n.friendRequestSentLabel,
                                  status: FriendStatus.outgoingRequest,
                                );
                              }).toList();

                              final filtered = friends.where((f) {
                                if (query.trim().isEmpty) return true;
                                return f.username
                                    .toLowerCase()
                                    .contains(query.toLowerCase());
                              }).toList();

                              return ListView(
                                physics: const BouncingScrollPhysics(),
                                children: [
                                  if (incoming.isNotEmpty) ...[
                                    _SectionTitle(l10n.friendRequestsSection),
                                    const SizedBox(height: 10),
                                    Glass(
                                      radius: BorderRadius.circular(22),
                                      padding: const EdgeInsets.all(12),
                                      child: Column(
                                        children: incoming.map((f) {
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
                                  if (outgoing.isNotEmpty) ...[
                                    _SectionTitle(l10n.friendPendingSection),
                                    const SizedBox(height: 10),
                                    Glass(
                                      radius: BorderRadius.circular(22),
                                      padding: const EdgeInsets.all(12),
                                      child: Column(
                                        children: outgoing.map((f) {
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
                                  _SectionTitle(l10n.friendAllSection),
                                  const SizedBox(height: 10),
                                  if (filtered.isEmpty)
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
                                  else
                                    Glass(
                                      radius: BorderRadius.circular(22),
                                      padding: const EdgeInsets.all(12),
                                      child: Column(
                                        children: filtered.map((f) {
                                          return _FriendRow(
                                            friend: f,
                                            onMessage: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (_) => DmChatScreen(
                                                    meId: socialRepository
                                                            .currentUserId ??
                                                        "me",
                                                    otherId: f.id,
                                                    otherName: f.username,
                                                  ),
                                                ),
                                              );
                                            },
                                            onRemove: () => _removeFriend(f.id),
                                          );
                                        }).toList(),
                                      ),
                                    ),
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

class _AvatarDot extends StatelessWidget {
  final bool online;
  const _AvatarDot({required this.online});

  @override
  Widget build(BuildContext context) {
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
              "🙂",
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
  final VoidCallback onMessage;
  final VoidCallback onRemove;

  const _FriendRow({
    required this.friend,
    required this.onMessage,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
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
            _AvatarDot(online: friend.isOnline),
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
                  if (friend.subtitle != null) ...[
                    const SizedBox(height: 3),
                    Text(
                      friend.subtitle!,
                      style: TextStyle(
                        color: scheme.onSurface.withValues(alpha: 0.60),
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 10),
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
  Widget build(BuildContext context) {
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
            const _AvatarDot(online: false),
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
  Widget build(BuildContext context) {
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
            const _AvatarDot(online: false),
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
                    "Request sent",
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
  Widget build(BuildContext context) {
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
