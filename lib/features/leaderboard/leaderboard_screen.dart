import 'package:flutter/material.dart';
import 'package:soma/l10n/gen/app_localizations.dart';

import '../../core/widgets/glass.dart';
import '../../core/widgets/pressable_scale.dart';
import '../../core/widgets/staggered_in.dart';
import '../../data/leaderboard_repository.dart';
import '../profile/profile_screen.dart';

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  late Future<List<Map<String, dynamic>>> _leaderboardFuture;

  @override
  void initState() {
    super.initState();
    _leaderboardFuture = leaderboardRepository.getGlobalLeaderboard(limit: 50);
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
                      final data = snapshot.data ?? [];
                      if (data.isEmpty) {
                        return Center(
                          child: Text(
                            l10n.leaderboardEmpty,
                            style: TextStyle(
                              color: scheme.onSurface.withValues(alpha: 0.62),
                            ),
                          ),
                        );
                      }

                      return ListView.separated(
                        physics: const BouncingScrollPhysics(),
                        itemCount: data.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 10),
                        itemBuilder: (context, index) {
                          final user = data[index];
                          final rank = index + 1;
                          final isTop3 = rank <= 3;
                          final avatarUrl = user['avatar_url']?.toString();
                          final displayName = user['display_name']?.toString();
                          final username = user['username']?.toString();
                          final userId = user['id']?.toString() ?? user['user_id']?.toString();
                          final name = (displayName != null && displayName.trim().isNotEmpty)
                              ? displayName
                              : (username?.isNotEmpty == true ? username! : l10n.userFallbackName);
                          
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
                                      width: 30,
                                      child: Text(
                                        "#$rank",
                                        style: TextStyle(
                                          color: isTop3
                                              ? scheme.primary
                                              : scheme.onSurface.withValues(alpha: 0.52),
                                          fontWeight: FontWeight.w900,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                    Hero(
                                      tag: userId == null ? "leader-avatar-$rank" : "profile-avatar-$userId",
                                      child: Container(
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
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        name,
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
