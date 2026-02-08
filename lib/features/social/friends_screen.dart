import 'package:flutter/material.dart';
import '../../core/widgets/soma_background.dart';
import '../../core/widgets/glass.dart';
import '../../models/friend.dart';
import '../../data/social_repository.dart';
import 'add_friend_screen.dart';
import 'dm_chat_screen.dart';

class FriendsScreen extends StatefulWidget {
  const FriendsScreen({super.key});

  @override
  State<FriendsScreen> createState() => _FriendsScreenState();
}

class _FriendsScreenState extends State<FriendsScreen> {
  String query = "";
  List<Friend> _friends = [];
  List<Friend> _incoming = [];
  List<Friend> _outgoing =
      []; // We might skip implementation if repo doesn't support it yet
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);

    // Fetch friends
    final friendsData = await socialRepository.getFriends();
    _friends = friendsData
        .map((data) => Friend(
              id: data['id'],
              username: data['username'] ?? 'User',
              subtitle: data['location'] ?? 'Soma Learner',
              status: FriendStatus.friend,
              // isOnline is not in profile, default false or implement realtime later
            ))
        .toList();

    // Fetch incoming
    final incomingData = await socialRepository.getIncomingRequests();
    _incoming = incomingData.map((data) {
      final requester = data['requester'] ?? {};
      return Friend(
        id: data['id'], // Set this to the FRIENDSHIP ID (bigint/string)
        username: requester['username'] ?? 'User',
        subtitle: 'Request',
        status: FriendStatus.incomingRequest,
      );
    }).toList();

    // Fetch outgoing
    final outgoingData = await socialRepository.getOutgoingRequests();
    _outgoing = outgoingData.map((data) {
      final addressee = data['addressee'] ?? {};
      return Friend(
        id: data['id'],
        username: addressee['username'] ?? 'User',
        subtitle: 'Request sent',
        status: FriendStatus.outgoingRequest,
      );
    }).toList();

    // Note: Our repository getIncomingRequests returns friendship rows with requester expanded.
    // We need to keep track of friendship ID to accept/decline.
    // For simplicity in this iteration, I might just reload data on action.

    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  // Simplified handling for mapping friendship ID
  Future<void> _accept(String friendshipId) async {
    await socialRepository.acceptFriendRequest(friendshipId);
    _loadData();
  }

  Future<void> _decline(String friendshipId) async {
    await socialRepository.declineFriendRequest(friendshipId);
    _loadData();
  }

  Future<void> _cancelOutgoing(String friendshipId) async {
    await socialRepository.cancelFriendRequest(friendshipId);
    _loadData();
  }

  Future<void> _removeFriend(String friendUserId) async {
    await socialRepository.removeFriend(friendUserId);
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    // Replace mock store with local state
    final allFriends = _friends;
    final incoming = _incoming;
    final outgoing = _outgoing;

    final filtered = allFriends.where((f) {
      if (query.trim().isEmpty) return true;
      return f.username.toLowerCase().contains(query.toLowerCase());
    }).toList();

    return Scaffold(
      body: SomaBackground(
        child: SafeArea(
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
                    const Text(
                      "Friends",
                      style: TextStyle(
                        color: Colors.white,
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
                        _loadData(); // Refresh on return
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
                          color: Colors.white.withOpacity(0.7)),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          onChanged: (v) => setState(() => query = v),
                          style: const TextStyle(
                              color: Colors.white, fontWeight: FontWeight.w700),
                          cursorColor: Colors.white,
                          decoration: InputDecoration(
                            hintText: "Search friends…",
                            hintStyle: TextStyle(
                                color: Colors.white.withOpacity(0.45)),
                            border: InputBorder.none,
                            isDense: true,
                          ),
                        ),
                      ),
                      if (query.isNotEmpty)
                        GestureDetector(
                          onTap: () => setState(() => query = ""),
                          child: Icon(Icons.close_rounded,
                              color: Colors.white.withOpacity(0.7)),
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
                                        username: data['username'] ?? 'User',
                                        subtitle:
                                            data['location'] ?? 'Soma Learner',
                                        status: FriendStatus.friend,
                                      ))
                                  .toList();

                              final incoming = incomingData.map((data) {
                                final requester = data['requester'] ?? {};
                                return Friend(
                                  id: data['id'].toString(),
                                  username: requester['username'] ?? 'User',
                                  subtitle: 'Incoming Request',
                                  status: FriendStatus.incomingRequest,
                                );
                              }).toList();

                              final outgoing = outgoingData.map((data) {
                                final addressee = data['addressee'] ?? {};
                                return Friend(
                                  id: data['id'].toString(),
                                  username: addressee['username'] ?? 'User',
                                  subtitle: 'Request sent',
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
                                    _SectionTitle("Requests"),
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
                                    _SectionTitle("Pending"),
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
                                  _SectionTitle("All Friends"),
                                  const SizedBox(height: 10),
                                  if (filtered.isEmpty)
                                    Glass(
                                      radius: BorderRadius.circular(22),
                                      padding: const EdgeInsets.all(16),
                                      child: Text(
                                        query.isEmpty
                                            ? "No friends yet. Add your first friend!"
                                            : "No match for \"$query\"",
                                        style: TextStyle(
                                          color: Colors.white.withOpacity(0.75),
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
    return Text(
      text,
      style: TextStyle(
        color: Colors.white.withOpacity(0.85),
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
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Glass(
        radius: BorderRadius.circular(16),
        padding: const EdgeInsets.all(10),
        child: Icon(icon, color: Colors.white.withOpacity(0.92)),
      ),
    );
  }
}

class _AvatarDot extends StatelessWidget {
  final bool online;
  const _AvatarDot({required this.online});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withOpacity(0.10),
        border: Border.all(color: Colors.white.withOpacity(0.16)),
      ),
      child: Stack(
        children: [
          Center(
            child: Text(
              "🙂",
              style:
                  TextStyle(fontSize: 18, color: Colors.white.withOpacity(0.9)),
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
                    : Colors.white.withOpacity(0.25),
                border:
                    Border.all(color: Colors.black.withOpacity(0.35), width: 2),
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
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          color: Colors.white.withOpacity(0.06),
          border: Border.all(color: Colors.white.withOpacity(0.14)),
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
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      fontSize: 14.5,
                    ),
                  ),
                  if (friend.subtitle != null) ...[
                    const SizedBox(height: 3),
                    Text(
                      friend.subtitle!,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.60),
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
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          color: Colors.white.withOpacity(0.06),
          border: Border.all(color: Colors.white.withOpacity(0.14)),
        ),
        child: Row(
          children: [
            const _AvatarDot(online: false),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                friend.username,
                style: const TextStyle(
                  color: Colors.white,
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
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          color: Colors.white.withOpacity(0.06),
          border: Border.all(color: Colors.white.withOpacity(0.14)),
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
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      fontSize: 14.5,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    "Request sent",
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.60),
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
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: Colors.white.withOpacity(0.08),
          border: Border.all(color: Colors.white.withOpacity(0.14)),
        ),
        child: Icon(icon, color: Colors.white.withOpacity(0.92), size: 20),
      ),
    );
  }
}
