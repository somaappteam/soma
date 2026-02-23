import 'package:flutter/material.dart';
import 'package:soma/core/widgets/glass.dart';
import 'package:soma/data/presence_repository.dart';
import 'package:soma/data/social_repository.dart';
import 'package:soma/features/social/dm_chat_screen.dart';
import 'package:soma/l10n/gen/app_localizations.dart';
import 'package:soma/models/friend.dart';

class SelectFriendScreen extends StatefulWidget {
  const SelectFriendScreen({super.key});

  @override
  State<SelectFriendScreen> createState() => _SelectFriendScreenState();
}

class _SelectFriendScreenState extends State<SelectFriendScreen> {
  String query = '';
  List<Friend> _friends = [];
  bool _isLoading = true;
  bool _didLoad = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_didLoad) return;
    _didLoad = true;
    _loadFriends();
  }

  Future<void> _loadFriends() async {
    final l10n = AppLocalizations.of(context);
    final data = await socialRepository.getFriends();
    if (!mounted) return;
    setState(() {
      _friends = data.map((final d) => Friend(
        id: d['id'],
        username: d['username'] ?? l10n.userFallbackName,
        subtitle: d['location'], // or bio
        status: FriendStatus.friend,
      )).toList();
      _isLoading = false;
    });
  }

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final filtered = _friends.where((final f) {
      if (query.trim().isEmpty) return true;
      return f.username.toLowerCase().contains(query.toLowerCase());
    }).toList();

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
                      l10n.newMessageTitle,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 14),

                // Search
                Glass(
                  radius: BorderRadius.circular(20),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  child: Row(
                    children: [
                      Icon(Icons.search_rounded, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7)),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          onChanged: (final v) => setState(() => query = v),
                          style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontWeight: FontWeight.w700),
                          cursorColor: Theme.of(context).colorScheme.primary,
                          decoration: InputDecoration(
                            hintText: l10n.searchFriendsHint,
                            hintStyle: TextStyle(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.45)),
                            border: InputBorder.none,
                            isDense: true,
                          ),
                        ),
                      ),
                      if (query.isNotEmpty)
                        GestureDetector(
                          onTap: () => setState(() => query = ''),
                          child: Icon(Icons.close_rounded, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7)),
                        ),
                    ],
                  ),
                ),

                const SizedBox(height: 14),

                Expanded(
                  child: _isLoading 
                    ? const Center(child: CircularProgressIndicator(color: Color(0xFF2AFADF)))
                    : filtered.isEmpty
                      ? Glass(
                          radius: BorderRadius.circular(22),
                          padding: const EdgeInsets.all(16),
                          child: Text(
                            query.isEmpty ? l10n.friendsEmptyShort : l10n.noMatchForQuery(query),
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.75),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        )
                      : Glass(
                          radius: BorderRadius.circular(22),
                          padding: const EdgeInsets.all(12),
                          child: StreamBuilder<Map<String, bool>>(
                            stream: presenceRepository.streamMultipleOnlineStatuses(
                              filtered.map((final f) => f.id).toList(),
                            ),
                            builder: (final context, final presenceSnapshot) {
                              final onlineStatuses = presenceSnapshot.data ?? {};
                              return ListView(
                                physics: const BouncingScrollPhysics(),
                                children: filtered.map((final f) {
                                  return _PickRow(
                                    friend: f,
                                    isOnline: onlineStatuses[f.id] ?? false,
                                    onTap: () {
                                      // Start chat
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (final _) => DmChatScreen(
                                            meId: socialRepository.currentUserId ?? 'me',
                                            otherId: f.id,
                                            otherName: f.username,
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                }).toList(),
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
}

// ---------------- UI bits ----------------

class _IconGlass extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _IconGlass({required this.icon, required this.onTap});

  @override
  Widget build(final BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Glass(
        radius: BorderRadius.circular(16),
        padding: const EdgeInsets.all(10),
        child: Icon(icon, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.92)),
      ),
    );
  }
}

class _PickRow extends StatelessWidget {
  final Friend friend;
  final bool isOnline;
  final VoidCallback onTap;

  const _PickRow({
    required this.friend,
    required this.isOnline,
    required this.onTap,
  });

  @override
  Widget build(final BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            color: scheme.onSurface.withValues(alpha: 0.06),
            border: Border.all(color: scheme.onSurface.withValues(alpha: 0.14)),
          ),
          child: Row(
            children: [
              _AvatarDot(online: isOnline),
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
              Icon(Icons.chevron_right_rounded, color: scheme.onSurface.withValues(alpha: 0.5)),
            ],
          ),
        ),
      ),
    );
  }
}

class _AvatarDot extends StatelessWidget {
  final bool online;
  const _AvatarDot({required this.online});

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
              '🙂',
              style: TextStyle(fontSize: 18, color: scheme.onSurface.withValues(alpha: 0.9)),
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
                color: online ? const Color(0xFF58F7B6) : scheme.onSurface.withValues(alpha: 0.25),
                border: Border.all(color: scheme.surface, width: 2), // border matches bg
              ),
            ),
          ),
        ],
      ),
    );
  }
}
