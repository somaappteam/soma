import 'package:flutter/material.dart';
import 'package:soma/l10n/gen/app_localizations.dart';
import '../../core/widgets/glass.dart';
import '../../core/widgets/neon_button.dart';
import '../../core/widgets/reward_sparkle.dart';
import 'settings_screen.dart';
import '../../core/theme/tokens.dart';
import '../../core/theme/motion.dart';
import '../../data/auth_repository.dart';
import '../../data/profile_repository.dart';
import '../../data/profile_store.dart';
import '../../data/social_repository.dart';
import '../../data/stats_repository.dart';
import '../../data/achievements_repository.dart';
import '../../models/user_profile.dart';
import '../../models/user_stats.dart';
import '../../models/achievement.dart';
import '../auth/sign_in_screen.dart';
import '../auth/sign_up_screen.dart';
import '../leaderboard/leaderboard_screen.dart';
import '../social/friends_screen.dart';
import '../social/dm_chat_screen.dart';

class ProfileScreen extends StatefulWidget {
  final String? userId;

  const ProfileScreen({super.key, this.userId});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  UserProfile? _profile;
  bool _isLoading = true;
  bool _isRequestSending = false;
  bool _requestSent = false;
  Future<UserStats>? _statsFuture;
  Future<List<Achievement>>? _achievementsFuture;

  bool get _isGuest => authRepository.currentUser == null;
  String? get _viewerId => authRepository.currentUser?.id;
  String? get _viewedUserId => widget.userId ?? _viewerId;
  bool get _isVisitorView => widget.userId != null && widget.userId != _viewerId;

  @override
  void initState() {
    super.initState();
    if (_isGuest) {
      _isLoading = false;
    } else {
      _loadProfile();
      _statsFuture = statsRepository.getStats(userId: _viewedUserId);
      _achievementsFuture = achievementsRepository.getAchievements();
    }
  }

  Future<void> _loadProfile() async {
    final p = await profileRepository.fetchProfile(userId: _viewedUserId);
    if (mounted) {
      setState(() {
        _profile = p;
        _isLoading = false;
      });
    }
  }

  void _openMessage(UserProfile profile) {
    final l10n = AppLocalizations.of(context);
    final meId = _viewerId;
    final otherId = profile.id ?? _viewedUserId;
    if (meId == null || otherId == null) {
      _showSnack(l10n.profileSignInToMessage);
      return;
    }
    if (meId == otherId) {
      _showSnack(l10n.profileThatsYourProfile);
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DmChatScreen(
          meId: meId,
          otherId: otherId,
          otherName: profile.displayName.isNotEmpty ? profile.displayName : profile.username,
        ),
      ),
    );
  }

  Future<void> _sendFriendRequest(UserProfile profile) async {
    final l10n = AppLocalizations.of(context);
    if (_isRequestSending || _requestSent) return;
    final meId = _viewerId;
    final otherId = profile.id ?? _viewedUserId;
    if (meId == null || otherId == null) {
      _showSnack(l10n.profileSignInToAddFriends);
      return;
    }
    if (meId == otherId) {
      _showSnack(l10n.profileCantAddYourself);
      return;
    }

    setState(() => _isRequestSending = true);
    try {
      await socialRepository.sendFriendRequest(otherId);
      if (!mounted) return;
      setState(() {
        _isRequestSending = false;
        _requestSent = true;
      });
      _showSnack(l10n.profileRequestSent(profile.username));
    } catch (e) {
      if (!mounted) return;
      setState(() => _isRequestSending = false);
      _showSnack(l10n.profileRequestFailed);
    }
  }

  void _showSnack(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (_isGuest) {
      return _GuestProfileView(
        profile: profileStore.profile,
        onSettings: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const SettingsScreen()),
          );
        },
        onSignIn: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const SignInScreen()),
          );
        },
        onSignUp: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const SignUpScreen()),
          );
        },
      );
    }
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: T.bg0,
        body: Center(child: CircularProgressIndicator(color: T.neonB)),
      );
    }
    
    // Default or fetched profile
    final profile = _profile ?? UserProfile(
      id: _viewedUserId,
      displayName: l10n.profileDefaultDisplayName,
      username: "user_${DateTime.now().millisecondsSinceEpoch % 10000}",
      bio: l10n.profileDefaultBio,
      location: l10n.profileDefaultLocation,
      dailyGoalMinutes: 15,
    );

    return Scaffold(
      body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 18),
            child: Column(
              children: [
                _TopBar(
                  title: l10n.profileTitle,
                  onBack: _isVisitorView && Navigator.canPop(context)
                      ? () => Navigator.pop(context)
                      : null,
                  onSettings: _isVisitorView
                      ? null
                      : () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const SettingsScreen()),
                          );
                        },
                ),

                const SizedBox(height: 14),

                Expanded(
                  child: ListView(
                    physics: const BouncingScrollPhysics(),
                    children: [
                      _HeaderCard(profile: profile),
                      const SizedBox(height: 14),
                      if (_isVisitorView) ...[
                        _VisitorActionsCard(
                          isSending: _isRequestSending,
                          requestSent: _requestSent,
                          onMessage: () => _openMessage(profile),
                          onAddFriend: () => _sendFriendRequest(profile),
                        ),
                        const SizedBox(height: 14),
                        _VisitorStatsCard(profile: profile),
                      ] else ...[
                        FutureBuilder<UserStats>(
                          future: _statsFuture,
                          builder: (context, snapshot) {
                            final stats = snapshot.data ?? UserStats.empty();
                            return _StatsRow(wins: stats.totalWins, streak: stats.streakDays);
                          },
                        ),
                        const SizedBox(height: 14),
                        const _FriendsCard(),
                        const SizedBox(height: 14),
                        FutureBuilder<List<Achievement>>(
                          future: _achievementsFuture,
                          builder: (context, snapshot) {
                            final items = snapshot.data ?? const <Achievement>[];
                            return _AchievementsCard(achievements: items);
                          },
                        ),
                      ],
                      const SizedBox(height: 14),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
  }
}

class _TopBar extends StatelessWidget {
  final VoidCallback? onSettings;
  final VoidCallback? onBack;
  final String title;
  const _TopBar({this.onSettings, this.onBack, this.title = ""});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final resolvedTitle = title.isEmpty ? l10n.profileTitle : title;
    return Row(
      children: [
        if (onBack != null) ...[
          _IconGlassButton(
            icon: Icons.arrow_back_ios_new_rounded,
            onTap: onBack!,
          ),
          const SizedBox(width: 10),
        ],
        Text(
          resolvedTitle,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.w800,
            height: 1.1,
          ),
        ),
        const Spacer(),
        if (onSettings != null)
          _IconGlassButton(
            icon: Icons.settings_rounded,
            onTap: onSettings!,
          ),
      ],
    );
  }
}

class _GuestProfileView extends StatelessWidget {
  final UserProfile profile;
  final VoidCallback onSettings;
  final VoidCallback onSignIn;
  final VoidCallback onSignUp;

  const _GuestProfileView({
    required this.profile,
    required this.onSettings,
    required this.onSignIn,
    required this.onSignUp,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final displayName = profile.displayName.isNotEmpty ? profile.displayName : l10n.guestDisplayName;
    final username = profile.username.isNotEmpty ? profile.username : l10n.guestUsername;

    return Scaffold(
      body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 18),
            child: Column(
              children: [
                _TopBar(onSettings: onSettings, title: l10n.profileTitle),
                const SizedBox(height: 14),
                Expanded(
                  child: ListView(
                    physics: const BouncingScrollPhysics(),
                    children: [
                      Glass(
                        radius: BorderRadius.circular(22),
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                        child: Row(
                          children: [
                            _AvatarGlow(
                              size: 64,
                              image: const AssetImage("assets/avatar/avatar_1.png"),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    displayName,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "@$username • ${l10n.guestSessionLabel}",
                                    style: TextStyle(
                                      color: Colors.white.withValues(alpha: 0.65),
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  if (profile.bio.isNotEmpty) ...[
                                    const SizedBox(height: 6),
                                    Text(
                                      profile.bio,
                                      style: TextStyle(
                                        color: Colors.white.withValues(alpha: 0.6),
                                        fontSize: 12.5,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 14),
                      Glass(
                        radius: BorderRadius.circular(22),
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l10n.unlockFullProfile,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            const SizedBox(height: 10),
                            _GuestInfoRow(
                              icon: Icons.cloud_done_rounded,
                              text: l10n.guestBenefitSync,
                            ),
                            const SizedBox(height: 8),
                            _GuestInfoRow(
                              icon: Icons.public_rounded,
                              text: l10n.guestBenefitCircles,
                            ),
                            const SizedBox(height: 8),
                            _GuestInfoRow(
                              icon: Icons.notifications_active_rounded,
                              text: l10n.guestBenefitNotifications,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 18),
                      NeonButton(
                        label: l10n.authCreateAccount,
                        onTap: onSignUp,
                      ),
                      const SizedBox(height: 12),
                      Glass(
                        radius: BorderRadius.circular(999),
                        padding: EdgeInsets.zero,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(999),
                          onTap: onSignIn,
                          child: SizedBox(
                            height: 56,
                            child: Center(
                              child: Text(
                                l10n.signIn,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Center(
                        child: Text(
                          l10n.progressStaysOnDevice,
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.55),
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
  }
}

class _GuestInfoRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const _GuestInfoRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFF2AFADF), size: 18),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.75),
              fontWeight: FontWeight.w700,
              fontSize: 12.5,
            ),
          ),
        ),
      ],
    );
  }
}

class _HeaderCard extends StatelessWidget {
  final UserProfile profile;
  const _HeaderCard({required this.profile});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final heroTag = profile.id != null && profile.id!.isNotEmpty
        ? "profile-avatar-${profile.id}"
        : "profile-avatar-${profile.username}";
    return Glass(
      radius: BorderRadius.circular(22),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      child: Column(
        children: [
          Row(
            children: [
              Hero(
                tag: heroTag,
                child: _AvatarGlow(
                  size: 64,
                  image: (profile.avatarUrl?.isNotEmpty == true)
                      ? NetworkImage(profile.avatarUrl!) as ImageProvider
                      : const AssetImage("assets/avatar/avatar_1.png"),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      profile.displayName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "@${profile.username} • ${profile.bio}",
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.65),
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              _Pill(
                text: l10n.profileGoalLabel(profile.dailyGoalMinutes),
                icon: Icons.timer_rounded,
              ),
            ],
          ),
          const SizedBox(height: 14),

          // XP Progress
          GestureDetector(
            onTap: () {
               Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const LeaderboardScreen()),
              );
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      l10n.profileXpProgress,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.75),
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        TweenAnimationBuilder<double>(
                          tween: Tween(begin: 0.98, end: 1.0),
                          duration: MotionTokens.short,
                          curve: MotionTokens.standardCurve,
                          builder: (context, value, child) {
                            return Transform.scale(scale: value, child: child);
                          },
                          child: Text(
                            l10n.profileXpValue(profile.totalXp),
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.75),
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        RewardSparkle(show: profile.totalXp > 0, size: 14),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                // XP Progress Bar - arbitrary max for now, say 1000 for next level
                _NeonProgressBar(value: (profile.totalXp % 1000) / 1000),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatsRow extends StatelessWidget {
  final int wins;
  final int streak;

  const _StatsRow({required this.wins, required this.streak});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Row(
      children: [
        Expanded(child: _StatTile(title: l10n.profileWins, value: "$wins", icon: Icons.emoji_events_rounded)),
        const SizedBox(width: 12),
        Expanded(child: _StatTile(title: l10n.profileStreak, value: "$streak", icon: Icons.local_fire_department_rounded)),
      ],
    );
  }
}

class _StatTile extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const _StatTile({
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Glass(
      radius: BorderRadius.circular(20),
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
            ),
            child: Icon(icon, color: Colors.white.withValues(alpha: 0.85)),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.65),
                  fontSize: 12.5,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _FriendsCard extends StatelessWidget {
  const _FriendsCard();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Glass(
      radius: BorderRadius.circular(22),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                l10n.profileFriendsTitle,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const FriendsScreen()),
                  );
                },
                child: Text(
                  l10n.profileViewAll,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.70),
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    decoration: TextDecoration.underline,
                    decorationColor: Colors.white.withValues(alpha: 0.45),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: const [
              _MiniAvatar(asset: "assets/avatar/avatar_2.png"),
              SizedBox(width: 10),
              _MiniAvatar(asset: "assets/avatar/avatar_3.png"),
              SizedBox(width: 10),
              _MiniAvatar(asset: "assets/avatar/avatar_4.png"),
              SizedBox(width: 10),
              _MiniAvatar(asset: "assets/avatar/avatar_5.png"),
              SizedBox(width: 10),
              _MiniAvatarPlus(),
            ],
          ),
        ],
      ),
    );
  }
}

class _AchievementsCard extends StatelessWidget {
  final List<Achievement> achievements;

  const _AchievementsCard({required this.achievements});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Glass(
      radius: BorderRadius.circular(22),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.profileAchievementsTitle,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 12),
          if (achievements.isEmpty)
            Text(
              l10n.profileNoAchievements,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.7),
                fontWeight: FontWeight.w700,
              ),
            )
          else
            GridView.count(
              crossAxisCount: 3,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 1.05,
              children: achievements.map((a) {
                return _BadgeTile(
                  icon: _iconForAchievement(a.id),
                  title: a.title,
                  unlocked: a.unlocked,
                );
              }).toList(),
            ),
        ],
      ),
    );
  }

  IconData _iconForAchievement(String id) {
    switch (id) {
      case 'top3':
        return Icons.emoji_events_rounded;
      case 'fast':
        return Icons.flash_on_rounded;
      case 'level_up':
        return Icons.star_rounded;
      case 'social':
        return Icons.group_rounded;
      case 'study':
        return Icons.school_rounded;
      case 'voice':
        return Icons.mic_rounded;
      default:
        return Icons.badge_rounded;
    }
  }
}

class _VisitorActionsCard extends StatelessWidget {
  final VoidCallback onMessage;
  final VoidCallback onAddFriend;
  final bool isSending;
  final bool requestSent;

  const _VisitorActionsCard({
    required this.onMessage,
    required this.onAddFriend,
    required this.isSending,
    required this.requestSent,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final friendLabel = requestSent
        ? l10n.profileRequested
        : isSending
            ? l10n.profileSending
            : l10n.profileAddFriend;

    return Glass(
      radius: BorderRadius.circular(22),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.profileConnectTitle,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _ActionButton(
                  icon: Icons.chat_bubble_rounded,
                  label: l10n.profileMessage,
                  primary: true,
                  onTap: onMessage,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _ActionButton(
                  icon: Icons.person_add_alt_1_rounded,
                  label: friendLabel,
                  onTap: requestSent || isSending ? null : onAddFriend,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback? onTap;
  final bool primary;

  const _ActionButton({
    required this.label,
    required this.icon,
    required this.onTap,
    this.primary = false,
  });

  @override
  Widget build(BuildContext context) {
    final enabled = onTap != null;
    final base = Container(
      height: 52,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: primary ? T.neonGradient : null,
        color: primary ? null : Colors.white.withValues(alpha: 0.08),
        border: Border.all(color: Colors.white.withValues(alpha: primary ? 0.18 : 0.14)),
        boxShadow: primary
            ? [
                BoxShadow(
                  color: T.neonA.withValues(alpha: 0.28),
                  blurRadius: 18,
                  spreadRadius: 1,
                ),
              ]
            : null,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.white.withValues(alpha: primary ? 0.98 : 0.9), size: 18),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withValues(alpha: primary ? 0.98 : 0.9),
              fontSize: 13.5,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );

    return Opacity(
      opacity: enabled ? 1 : 0.6,
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: base,
      ),
    );
  }
}

class _VisitorStatsCard extends StatelessWidget {
  final UserProfile profile;
  const _VisitorStatsCard({required this.profile});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final location = profile.location.isNotEmpty ? profile.location : l10n.profileLocationHidden;
    final bio = profile.bio.isNotEmpty ? profile.bio : l10n.profileBioHidden;

    return Glass(
      radius: BorderRadius.circular(22),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.profileSnapshot,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 10),
          _MetaRow(icon: Icons.info_outline_rounded, label: bio),
          const SizedBox(height: 8),
          _MetaRow(icon: Icons.place_rounded, label: location),
          const SizedBox(height: 8),
          _MetaRow(icon: Icons.auto_graph_rounded, label: l10n.profileXpValue(profile.totalXp)),
          const SizedBox(height: 8),
          _MetaRow(icon: Icons.timer_rounded, label: l10n.profileDailyGoal(profile.dailyGoalMinutes)),
        ],
      ),
    );
  }
}

class _MetaRow extends StatelessWidget {
  final IconData icon;
  final String label;
  const _MetaRow({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: Colors.white.withValues(alpha: 0.7), size: 16),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.75),
              fontWeight: FontWeight.w700,
              fontSize: 12.5,
            ),
          ),
        ),
      ],
    );
  }
}

// ----------------------- UI PARTS -----------------------

class _IconGlassButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _IconGlassButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Glass(
        radius: BorderRadius.circular(16),
        padding: const EdgeInsets.all(10),
        child: Icon(icon, color: Colors.white.withValues(alpha: 0.9)),
      ),
    );
  }
}

class _AvatarGlow extends StatelessWidget {
  final double size;
  final ImageProvider image;

  const _AvatarGlow({required this.size, required this.image});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF7D5CFF).withValues(alpha: 0.45),
            blurRadius: 30,
            spreadRadius: 2,
          ),
        ],
      ),
      child: ClipOval(
        child: Image(image: image, fit: BoxFit.cover),
      ),
    );
  }
}

class _MiniAvatar extends StatelessWidget {
  final String asset;
  const _MiniAvatar({required this.asset});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 38,
      height: 38,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white.withValues(alpha: 0.18)),
      ),
      child: ClipOval(
        child: Image.asset(asset, fit: BoxFit.cover),
      ),
    );
  }
}

class _MiniAvatarPlus extends StatelessWidget {
  const _MiniAvatarPlus();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 38,
      height: 38,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withValues(alpha: 0.07),
        border: Border.all(color: Colors.white.withValues(alpha: 0.18)),
      ),
      child: Icon(Icons.add_rounded, color: Colors.white.withValues(alpha: 0.85)),
    );
  }
}

class _BadgeTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool unlocked;
  const _BadgeTile({required this.icon, required this.title, required this.unlocked});

  @override
  Widget build(BuildContext context) {
    final opacity = unlocked ? 1.0 : 0.45;
    return Glass(
      radius: BorderRadius.circular(18),
      padding: const EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.white.withValues(alpha: 0.90 * opacity), size: 26),
          const SizedBox(height: 8),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.75 * opacity),
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  final String text;
  final IconData icon;
  const _Pill({required this.text, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white.withValues(alpha: 0.14)),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.white.withValues(alpha: 0.9)),
          const SizedBox(width: 6),
          Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12.5,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _NeonProgressBar extends StatelessWidget {
  final double value;
  const _NeonProgressBar({required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 12,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(999),
        child: Align(
          alignment: Alignment.centerLeft,
          child: FractionallySizedBox(
            widthFactor: value.clamp(0.0, 1.0),
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF33D6FF),
                    Color(0xFF7D5CFF),
                    Color(0xFFFF4BD8),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
