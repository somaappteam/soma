import 'dart:async';
import 'package:flutter/material.dart';
import 'package:soma/l10n/gen/app_localizations.dart';

import '../../core/widgets/glass.dart';
import '../../core/widgets/pressable_scale.dart';
import '../../core/widgets/staggered_in.dart';
import '../../data/leaderboard_repository.dart';
import '../../data/presence_repository.dart';
import '../profile/profile_screen.dart';

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  late Future<List<Map<String, dynamic>>> _leaderboardFuture;
  final TextEditingController _searchController = TextEditingController();
  String _query = "";
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _fetchLeaderboard();
  }

  void _fetchLeaderboard() {
    setState(() {
      if (_query.isEmpty) {
        _leaderboardFuture = leaderboardRepository.getGlobalLeaderboard(limit: 50);
      } else {
        _leaderboardFuture = _searchAndRank(_query);
      }
    });
  }

  Future<List<Map<String, dynamic>>> _searchAndRank(String query) async {
    final users = await leaderboardRepository.searchUsers(query);
    final results = await Future.wait(users.map((u) async {
      final rank = await leaderboardRepository.getUserRank(u['xp'] ?? 0);
      return {...u, 'rank': rank};
    }));
    return results;
  }

  void _onSearchChanged(String value) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (mounted) {
        _query = value;
        _fetchLeaderboard();
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
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
                    l10n.leaderboardGlobalTitle,
                    style: TextStyle(
                      color: scheme.onSurface,
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Search Box
              Glass(
                radius: BorderRadius.circular(20),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                child: Row(
                  children: [
                    Icon(Icons.search_rounded, color: scheme.onSurface.withValues(alpha: 0.7)),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        onChanged: _onSearchChanged,
                        style: TextStyle(color: scheme.onSurface, fontWeight: FontWeight.w700),
                        cursorColor: scheme.onSurface,
                        decoration: InputDecoration(
                          hintText: "Search players (username)...",
                          hintStyle: TextStyle(color: scheme.onSurface.withValues(alpha: 0.45)),
                          border: InputBorder.none,
                          isDense: true,
                        ),
                      ),
                    ),
                    if (_searchController.text.isNotEmpty)
                      GestureDetector(
                        onTap: () {
                          _searchController.clear();
                          _onSearchChanged("");
                          setState(() {});
                        },
                        child: Icon(Icons.close_rounded, color: scheme.onSurface.withValues(alpha: 0.7)),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: FutureBuilder<List<Map<String, dynamic>>>(
                  future: _leaderboardFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(color: scheme.primary),
                      );
                    }
                    if (snapshot.hasError) {
                      return Center(child: Text("Error searching users"));
                    }
                    final data = snapshot.data ?? [];
                    if (data.isEmpty) {
                      return Center(
                        child: Text(
                          _query.isEmpty ? l10n.leaderboardEmpty : "No players found matching \"$_query\"",
                          style: TextStyle(
                            color: scheme.onSurface.withValues(alpha: 0.62),
                          ),
                        ),
                      );
                    }

                    final userIds = data
                        .map((u) => (u['id'] ?? u['user_id'])?.toString())
                        .whereType<String>()
                        .toList();

                    return StreamBuilder<Map<String, bool>>(
                      stream: presenceRepository.streamMultipleOnlineStatuses(userIds),
                      builder: (context, presenceSnapshot) {
                        final onlineStatuses = presenceSnapshot.data ?? {};

                        return ListView.separated(
                          physics: const BouncingScrollPhysics(),
                          itemCount: data.length,
                          separatorBuilder: (_, __) => const SizedBox(height: 10),
                          itemBuilder: (context, index) {
                            final user = data[index];
                            final rank = user['rank'] ?? (index + 1);
                            final isTop3 = rank <= 3;
                            final avatarUrl = user['avatar_url']?.toString();
                            final displayName = user['display_name']?.toString();
                            final username = user['username']?.toString();
                            final userId = user['id']?.toString() ?? user['user_id']?.toString();
                            final name = (displayName != null && displayName.trim().isNotEmpty)
                                ? displayName
                                : (username?.isNotEmpty == true ? username! : l10n.userFallbackName);
                            final isOnline = onlineStatuses[userId] == true;

                            return StaggeredIn(
                              index: index,
                              child: PressableScale(
                                onTap: userId == null
                                    ? null
                                    : () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (_) => ProfileScreen(userId: userId)),
                                        );
                                      },
                                child: Glass(
                                  radius: BorderRadius.circular(18),
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: 42,
                                        child: Text(
                                          "#$rank",
                                          style: TextStyle(
                                            color: isTop3 ? scheme.primary : scheme.onSurface.withValues(alpha: 0.52),
                                            fontWeight: FontWeight.w900,
                                            fontSize: 15,
                                          ),
                                        ),
                                      ),
                                      Hero(
                                        tag: userId == null ? "leader-avatar-$rank" : "profile-avatar-$userId",
                                        child: Stack(
                                          children: [
                                            Container(
                                              width: 40,
                                              height: 40,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: scheme.onSurface.withValues(alpha: 0.08),
                                              ),
                                              child: (avatarUrl != null && avatarUrl.trim().isNotEmpty)
                                                  ? ClipOval(
                                                      child: Image.network(
                                                        avatarUrl,
                                                        width: 40,
                                                        height: 40,
                                                        fit: BoxFit.cover,
                                                        errorBuilder: (_, __, ___) => Icon(
                                                          Icons.person,
                                                          color: scheme.onSurface,
                                                        ),
                                                      ),
                                                    )
                                                  : Icon(Icons.person, color: scheme.onSurface),
                                            ),
                                            if (isOnline)
                                              Positioned(
                                                bottom: 1,
                                                right: 1,
                                                child: Container(
                                                  width: 10,
                                                  height: 10,
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: const Color(0xFF58F7B6),
                                                    border: Border.all(color: scheme.surface, width: 2),
                                                  ),
                                                ),
                                              ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Text(
                                          name,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            color: scheme.onSurface,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        l10n.profileXpValue(user['xp'] ?? 0),
                                        style: TextStyle(
                                          color: scheme.onSurface.withValues(alpha: 0.9),
                                          fontWeight: FontWeight.w800,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
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
