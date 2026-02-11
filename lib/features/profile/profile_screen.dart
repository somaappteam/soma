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
import '../../data/user_report_repository.dart';
import '../../data/achievements_repository.dart';
import '../../data/presence_repository.dart';
import '../../models/user_profile.dart';
import '../../models/user_stats.dart';
import '../../models/achievement.dart';
import '../auth/sign_in_screen.dart';
import '../auth/sign_up_screen.dart';
import '../leaderboard/leaderboard_screen.dart';
import '../social/friends_screen.dart';
import '../social/dm_chat_screen.dart';
import '../../core/theme/spacing.dart';

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
  bool _isBlocked = false;
  bool _isReported = false;
  bool _isReportSubmitting = false;
  String? _pendingFriendshipId;
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
    String? pendingId;
    var isBlocked = false;
    var isReported = false;
    if (_isVisitorView && _viewerId != null && _viewedUserId != null) {
      pendingId = await socialRepository.getOutgoingPendingRequestId(_viewedUserId!);
      final settings = await settingsRepository.getSettings();
      final blockedIds = _parseBlockedIds(settings['blocked_user_ids']);
      isBlocked = blockedIds.contains(_viewedUserId);
      isReported = await userReportRepository.hasReported(_viewedUserId!);
    }
    if (mounted) {
      setState(() {
        _profile = p;
        _pendingFriendshipId = pendingId;
        _requestSent = pendingId != null;
        _isBlocked = isBlocked;
        _isReported = isReported;
        _isLoading = false;
      });
    }
  }

  List<String> _parseBlockedIds(dynamic rawValue) {
    if (rawValue is List) {
      return rawValue.map((e) => e.toString()).where((e) => e.isNotEmpty).toList();
    }
    return const [];
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
    if (_isBlocked) {
      _showSnack('Unblock this user to send a message.');
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DmChatScreen(
          meId: meId,
          otherId: otherId,
          otherName: profile.username,
        ),
      ),
    );
  }

  Future<void> _sendFriendRequest(UserProfile profile) async {
    final l10n = AppLocalizations.of(context);
    if (_isRequestSending) return;
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
    if (_isBlocked) {
      _showSnack('Unblock this user to send a friend request.');
      return;
    }

    setState(() => _isRequestSending = true);
    try {
      await socialRepository.sendFriendRequest(otherId);
      if (!mounted) return;
      final pendingId = await socialRepository.getOutgoingPendingRequestId(otherId);
      if (!mounted) return;
      setState(() {
        _isRequestSending = false;
        _requestSent = true;
        _pendingFriendshipId = pendingId;
      });
      _showSnack(l10n.profileRequestSent(profile.username));
    } catch (e) {
      if (!mounted) return;
      setState(() => _isRequestSending = false);
      _showSnack(l10n.profileRequestFailed);
    }
  }

  Future<void> _cancelFriendRequest(UserProfile profile) async {
    if (_isRequestSending) return;
    final otherId = profile.id ?? _viewedUserId;
    if (otherId == null) return;

    setState(() => _isRequestSending = true);
    try {
      if (_pendingFriendshipId != null) {
        await socialRepository.cancelFriendRequest(_pendingFriendshipId!);
      } else {
        await socialRepository.cancelFriendRequestToUser(otherId);
      }
      if (!mounted) return;
      setState(() {
        _isRequestSending = false;
        _requestSent = false;
        _pendingFriendshipId = null;
      });
      _showSnack('Friend request canceled.');
    } catch (e) {
      if (!mounted) return;
      setState(() => _isRequestSending = false);
      _showSnack(AppLocalizations.of(context).profileRequestFailed);
    }
  }

  Future<void> _toggleBlocked(UserProfile profile) async {
    final otherId = profile.id ?? _viewedUserId;
    if (otherId == null || otherId.isEmpty) {
      _showSnack('Unable to update block list right now.');
      return;
    }

    final shouldBlock = !_isBlocked;
    final confirmed = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(shouldBlock ? 'Block user?' : 'Unblock user?'),
            content: Text(
              shouldBlock
                  ? 'You will no longer be able to message or friend this user until you unblock them.'
                  : 'You can message and friend this user again after unblocking.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text(AppLocalizations.of(context).cancel),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text(shouldBlock ? 'Block' : 'Unblock'),
              ),
            ],
          ),
        ) ??
        false;

    if (!confirmed) return;

    final settings = await settingsRepository.getSettings();
    final blockedIds = _parseBlockedIds(settings['blocked_user_ids']);
    final nextIds = shouldBlock
        ? <String>{...blockedIds, otherId}.toList()
        : blockedIds.where((id) => id != otherId).toList();

    await settingsRepository.updateSetting('blocked_user_ids', nextIds);
    if (!mounted) return;
    setState(() {
      _isBlocked = shouldBlock;
      if (shouldBlock) {
        _requestSent = false;
        _pendingFriendshipId = null;
      }
    });
    _showSnack(shouldBlock ? 'User blocked.' : 'User unblocked.');
  }

  Future<void> _toggleReported(UserProfile profile) async {
    final otherId = profile.id ?? _viewedUserId;
    if (otherId == null || otherId.isEmpty) {
      _showSnack('Unable to submit report right now.');
      return;
    }

    final shouldReport = !_isReported;
    final confirmed = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(shouldReport ? 'Report user?' : 'Remove report?'),
            content: Text(
              shouldReport
                  ? 'This report will be reviewed by our moderation team.'
                  : 'This will remove your previous report for this user.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text(AppLocalizations.of(context).cancel),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text(shouldReport ? 'Report' : 'Remove'),
              ),
            ],
          ),
        ) ??
        false;

    if (!confirmed) return;

    setState(() => _isReportSubmitting = true);
    try {
      if (shouldReport) {
        await userReportRepository.reportUser(otherId);
      } else {
        await userReportRepository.removeReport(otherId);
      }
      if (!mounted) return;
      setState(() {
        _isReported = shouldReport;
        _isReportSubmitting = false;
      });
      _showSnack(shouldReport ? 'User reported.' : 'Report removed.');
    } catch (_) {
      if (!mounted) return;
      setState(() => _isReportSubmitting = false);
      _showSnack('Unable to submit report right now.');
    }
  }


  String _resolveFallbackUsername(AppLocalizations l10n) {
    final current = authRepository.currentUser;
    final metadataName = current?.userMetadata?['username']?.toString();
    if (metadataName != null && metadataName.isNotEmpty) return metadataName;
    final email = current?.email;
    if (email != null && email.contains('@')) {
      final prefix = email.split('@').first.trim();
      if (prefix.isNotEmpty) return prefix;
    }
    return l10n.genericUser;
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
      final scheme = Theme.of(context).colorScheme;
      return Scaffold(
        backgroundColor: scheme.background,
        body: Center(
          child: CircularProgressIndicator(color: scheme.primary),
        ),
      );
    }
    
    // Default or fetched profile
    final profile = _profile ?? UserProfile(
      id: _viewedUserId,
      displayName: l10n.profileDefaultDisplayName,
      username: _resolveFallbackUsername(l10n),
      bio: l10n.profileDefaultBio,
      location: l10n.profileDefaultLocation,
      dailyGoalMinutes: 15,
    );

    return Scaffold(
      body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(S.md, S.md, S.md, S.lg),
            child: Column(
              children: [
                _TopBar(
                  title: l10n.profileTitle,
                  onBack: _isVisitorView && Navigator.canPop(context)
                      ? () => Navigator.pop(context)
                      : null,
                  onLeaderboard: _isVisitorView
                      ? null
                      : () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const LeaderboardScreen()),
                          );
                        },
                  onSettings: _isVisitorView
                      ? null
                      : () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const SettingsScreen()),
                          );
                        },
                ),

                const SizedBox(height: S.sm),

                Expanded(
                  child: ListView(
                    physics: const BouncingScrollPhysics(),
                    children: [
                      profile.showOnlineStatus && profile.id != null && profile.id!.isNotEmpty
                          ? StreamBuilder<bool>(
                              stream: presenceRepository.streamOnlineStatus(profile.id!),
                              builder: (context, snapshot) => _HeaderCard(
                                profile: profile,
                                showOnlineIndicator: snapshot.data == true,
                              ),
                            )
                          : _HeaderCard(profile: profile, showOnlineIndicator: false),
                      const SizedBox(height: S.sm),
                      _ProfileSpotlightCard(profile: profile),
                      const SizedBox(height: S.sm),
                      if (_isVisitorView) ...[
                        _VisitorActionsCard(
                          isSending: _isRequestSending,
                          requestSent: _requestSent,
                          isBlocked: _isBlocked,
                          isReported: _isReported,
                          isReportSubmitting: _isReportSubmitting,
                          onMessage: () => _openMessage(profile),
                          onAddFriend: () => _requestSent
                              ? _cancelFriendRequest(profile)
                              : _sendFriendRequest(profile),
                          onToggleBlocked: () => _toggleBlocked(profile),
                          onToggleReported: () => _toggleReported(profile),
                        ),
                        const SizedBox(height: S.sm),
                        _VisitorStatsCard(profile: profile),
                      ] else ...[
                        FutureBuilder<UserStats>(
                          future: _statsFuture,
                          builder: (context, snapshot) {
                            return AnimatedSwitcher(
                              duration: MotionTokens.short,
                              child: snapshot.connectionState == ConnectionState.waiting
                                  ? const _StatsSkeleton()
                                  : _StatsRow(
                                      wins: (snapshot.data ?? UserStats.empty()).totalWins,
                                      streak: (snapshot.data ?? UserStats.empty()).streakDays,
                                    ),
                            );
                          },
                        ),
                        const SizedBox(height: S.sm),
                        const _FriendsCard(),
                        const SizedBox(height: S.sm),
                        FutureBuilder<List<Achievement>>(
                          future: _achievementsFuture,
                          builder: (context, snapshot) {
                            return AnimatedSwitcher(
                              duration: MotionTokens.short,
                              child: snapshot.connectionState == ConnectionState.waiting
                                  ? const _AchievementsSkeleton()
                                  : _AchievementsCard(
                                      achievements: snapshot.data ?? const <Achievement>[],
                                    ),
                            );
                          },
                        ),
                      ],
                      const SizedBox(height: S.sm),
                      const SizedBox(height: S.xl),
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
  final VoidCallback? onLeaderboard;
  final String title;
  const _TopBar({
    this.onSettings,
    this.onBack,
    this.onLeaderboard,
    this.title = "",
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final resolvedTitle = title.isEmpty ? l10n.profileTitle : title;
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Row(
      children: [
        if (onBack != null) ...[
          _IconGlassButton(
            icon: Icons.arrow_back_ios_new_rounded,
            onTap: onBack!,
          ),
          const SizedBox(width: S.xs),
        ],
        Text(
          resolvedTitle,
          style: textTheme.headlineMedium?.copyWith(
            color: scheme.onSurface,
            fontWeight: FontWeight.w800,
            height: 1.1,
          ),
        ),
        const Spacer(),
        if (onLeaderboard != null) ...[
          _LeaderboardButton(onTap: onLeaderboard!),
          const SizedBox(width: S.xs),
        ],
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
    final username = profile.username.isNotEmpty ? profile.username : l10n.guestUsername;
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(S.md, S.md, S.md, S.lg),
            child: Column(
              children: [
                _TopBar(
                  onSettings: onSettings,
                  title: l10n.profileTitle,
                ),
                const SizedBox(height: S.sm),
                Expanded(
                  child: ListView(
                    physics: const BouncingScrollPhysics(),
                    children: [
                      Glass(
                        radius: BorderRadius.circular(22),
                        padding: const EdgeInsets.fromLTRB(S.md, S.md, S.md, S.md),
                        child: Row(
                          children: [
                            _AvatarGlow(
                              size: 64,
                              image: const AssetImage("assets/avatar/avatar_1.png"),
                              showOnlineIndicator: false,
                            ),
                            const SizedBox(width: S.sm),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "@$username • ${l10n.guestSessionLabel}",
                                    style: textTheme.bodySmall?.copyWith(
                                      color: scheme.onSurface.withValues(alpha: 0.65),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  if (profile.bio.isNotEmpty) ...[
                                    const SizedBox(height: S.xs),
                                    Text(
                                      profile.bio,
                                      style: textTheme.bodySmall?.copyWith(
                                        color: scheme.onSurface.withValues(alpha: 0.6),
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
                      const SizedBox(height: S.sm),
                      Glass(
                        radius: BorderRadius.circular(22),
                        padding: const EdgeInsets.fromLTRB(S.md, S.md, S.md, S.md),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l10n.unlockFullProfile,
                              style: textTheme.titleMedium?.copyWith(
                                color: scheme.onSurface,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            const SizedBox(height: S.xs),
                            _GuestInfoRow(
                              icon: Icons.cloud_done_rounded,
                              text: l10n.guestBenefitSync,
                            ),
                            const SizedBox(height: S.xs),
                            _GuestInfoRow(
                              icon: Icons.public_rounded,
                              text: l10n.guestBenefitCircles,
                            ),
                            const SizedBox(height: S.xs),
                            _GuestInfoRow(
                              icon: Icons.notifications_active_rounded,
                              text: l10n.guestBenefitNotifications,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: S.lg),
                      NeonButton(
                        label: l10n.authCreateAccount,
                        onTap: onSignUp,
                      ),
                      const SizedBox(height: S.sm),
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
                                style: textTheme.titleMedium?.copyWith(
                                  color: scheme.onSurface,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: S.xs),
                      Center(
                        child: Text(
                          l10n.progressStaysOnDevice,
                          style: textTheme.bodySmall?.copyWith(
                            color: scheme.onSurface.withValues(alpha: 0.55),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(height: S.xs),
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
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Row(
      children: [
        Icon(icon, color: scheme.secondary, size: 18),
        const SizedBox(width: S.xs),
        Expanded(
          child: Text(
            text,
            style: textTheme.bodySmall?.copyWith(
              color: scheme.onSurface.withValues(alpha: 0.75),
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}

class _HeaderCard extends StatelessWidget {
  final UserProfile profile;
  final bool showOnlineIndicator;

  const _HeaderCard({required this.profile, required this.showOnlineIndicator});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final heroTag = profile.id != null && profile.id!.isNotEmpty
        ? "profile-avatar-${profile.id}"
        : "profile-avatar-${profile.username}";
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Glass(
      radius: BorderRadius.circular(22),
      padding: const EdgeInsets.fromLTRB(S.md, S.md, S.md, S.md),
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
                  showOnlineIndicator: showOnlineIndicator,
                ),
              ),
              const SizedBox(width: S.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "@${profile.username}${profile.bio.isNotEmpty ? " • ${profile.bio}" : ""}",
                      style: textTheme.bodySmall?.copyWith(
                        color: scheme.onSurface.withValues(alpha: 0.65),
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
          const SizedBox(height: S.sm),

          // XP Progress
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    l10n.profileXpProgress,
                    style: textTheme.bodySmall?.copyWith(
                      color: scheme.onSurface.withValues(alpha: 0.75),
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
                          style: textTheme.bodySmall?.copyWith(
                            color: scheme.onSurface.withValues(alpha: 0.75),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const SizedBox(width: S.xs),
                      RewardSparkle(show: profile.totalXp > 0, size: 14),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: S.xs),
              // XP Progress Bar - arbitrary max for now, say 1000 for next level
              _NeonProgressBar(value: (profile.totalXp % 1000) / 1000),
            ],
          ),
        ],
      ),
    );
  }
}

class _ProfileSpotlightCard extends StatelessWidget {
  final UserProfile profile;
  const _ProfileSpotlightCard({required this.profile});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final bio = profile.bio.isNotEmpty ? profile.bio : l10n.profileBioHidden;
    return Glass(
      radius: BorderRadius.circular(22),
      padding: const EdgeInsets.all(S.md),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(
                colors: [
                  scheme.primary.withValues(alpha: 0.9),
                  scheme.tertiary.withValues(alpha: 0.9),
                ],
              ),
            ),
            child: Icon(Icons.info_outline_rounded, color: scheme.onPrimary, size: 22),
          ),
          const SizedBox(width: S.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.editProfileBioLabel,
                  style: textTheme.bodySmall?.copyWith(
                    color: scheme.onSurface.withValues(alpha: 0.65),
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: S.xxs),
                Text(
                  bio,
                  style: textTheme.titleMedium?.copyWith(
                    color: scheme.onSurface,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatsSkeleton extends StatelessWidget {
  const _StatsSkeleton();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final base = scheme.onSurface.withValues(alpha: 0.08);
    return Row(
      children: [
        Expanded(child: _SkeletonTile(base: base)),
        const SizedBox(width: S.sm),
        Expanded(child: _SkeletonTile(base: base)),
      ],
    );
  }
}

class _SkeletonTile extends StatelessWidget {
  final Color base;
  const _SkeletonTile({required this.base});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(S.sm),
      decoration: BoxDecoration(
        color: base,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: base.withValues(alpha: 0.9),
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          const SizedBox(width: S.sm),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 60,
                height: 10,
                decoration: BoxDecoration(
                  color: base.withValues(alpha: 0.9),
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
              const SizedBox(height: S.xs),
              Container(
                width: 40,
                height: 12,
                decoration: BoxDecoration(
                  color: base.withValues(alpha: 0.8),
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AchievementsSkeleton extends StatelessWidget {
  const _AchievementsSkeleton();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final base = scheme.onSurface.withValues(alpha: 0.08);
    return Glass(
      radius: BorderRadius.circular(22),
      padding: const EdgeInsets.fromLTRB(S.md, S.md, S.md, S.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 120,
            height: 12,
            decoration: BoxDecoration(
              color: base.withValues(alpha: 0.9),
              borderRadius: BorderRadius.circular(999),
            ),
          ),
          const SizedBox(height: S.sm),
          GridView.count(
            crossAxisCount: 3,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: S.xs,
            crossAxisSpacing: S.xs,
            childAspectRatio: 1.05,
            children: List.generate(
              6,
              (_) => Container(
                decoration: BoxDecoration(
                  color: base.withValues(alpha: 0.9),
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
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
        const SizedBox(width: S.sm),
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
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Glass(
      radius: BorderRadius.circular(20),
      padding: const EdgeInsets.fromLTRB(S.sm, S.sm, S.sm, S.sm),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: scheme.surfaceContainerHighest.withValues(alpha: 0.6),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: scheme.onSurface.withValues(alpha: 0.12)),
            ),
            child: Icon(icon, color: scheme.onSurface.withValues(alpha: 0.85), size: 20),
          ),
          const SizedBox(width: S.sm),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: textTheme.bodySmall?.copyWith(
                  color: scheme.onSurface.withValues(alpha: 0.65),
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: S.xxs),
              Text(
                value,
                style: textTheme.titleLarge?.copyWith(
                  color: scheme.onSurface,
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
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Glass(
      radius: BorderRadius.circular(22),
      padding: const EdgeInsets.fromLTRB(S.md, S.md, S.md, S.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                l10n.profileFriendsTitle,
                style: textTheme.titleMedium?.copyWith(
                  color: scheme.onSurface,
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
                  style: textTheme.bodySmall?.copyWith(
                    color: scheme.onSurface.withValues(alpha: 0.70),
                    fontWeight: FontWeight.w700,
                    decoration: TextDecoration.underline,
                    decorationColor: scheme.onSurface.withValues(alpha: 0.45),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: S.sm),
          Row(
            children: const [
              _MiniAvatar(asset: "assets/avatar/avatar_2.png"),
              SizedBox(width: S.xs),
              _MiniAvatar(asset: "assets/avatar/avatar_3.png"),
              SizedBox(width: S.xs),
              _MiniAvatar(asset: "assets/avatar/avatar_4.png"),
              SizedBox(width: S.xs),
              _MiniAvatar(asset: "assets/avatar/avatar_5.png"),
              SizedBox(width: S.xs),
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
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Glass(
      radius: BorderRadius.circular(22),
      padding: const EdgeInsets.fromLTRB(S.md, S.md, S.md, S.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.profileAchievementsTitle,
            style: textTheme.titleMedium?.copyWith(
              color: scheme.onSurface,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: S.sm),
          if (achievements.isEmpty)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.profileNoAchievements,
                  style: textTheme.bodyMedium?.copyWith(
                    color: scheme.onSurface.withValues(alpha: 0.7),
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: S.xxs),
                Text(
                  "Complete lessons to earn your first badge.",
                  style: textTheme.bodySmall?.copyWith(
                    color: scheme.onSurface.withValues(alpha: 0.55),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            )
          else
            GridView.count(
              crossAxisCount: 3,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: S.xs,
              crossAxisSpacing: S.xs,
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
  final VoidCallback onToggleBlocked;
  final VoidCallback onToggleReported;
  final bool isSending;
  final bool requestSent;
  final bool isBlocked;
  final bool isReported;
  final bool isReportSubmitting;

  const _VisitorActionsCard({
    required this.onMessage,
    required this.onAddFriend,
    required this.onToggleBlocked,
    required this.onToggleReported,
    required this.isSending,
    required this.requestSent,
    required this.isBlocked,
    required this.isReported,
    required this.isReportSubmitting,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final friendLabel = requestSent
        ? l10n.cancel
        : isSending
            ? l10n.profileSending
            : l10n.profileAddFriend;

    return Glass(
      radius: BorderRadius.circular(22),
      padding: const EdgeInsets.fromLTRB(S.md, S.md, S.md, S.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.profileConnectTitle,
            style: textTheme.titleMedium?.copyWith(
              color: scheme.onSurface,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: S.sm),
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
              const SizedBox(width: S.xs),
              Expanded(
                child: _ActionButton(
                  icon: requestSent ? Icons.undo_rounded : Icons.person_add_alt_1_rounded,
                  label: friendLabel,
                  onTap: isSending || isBlocked ? null : onAddFriend,
                ),
              ),
            ],
          ),
          const SizedBox(height: S.xs),
          _ActionButton(
            icon: isBlocked ? Icons.lock_open_rounded : Icons.block_rounded,
            label: isBlocked ? 'Unblock user' : 'Block user',
            onTap: onToggleBlocked,
          ),
          const SizedBox(height: S.xs),
          _ActionButton(
            icon: isReported ? Icons.flag_outlined : Icons.flag_rounded,
            label: isReported ? 'Remove report' : 'Report user',
            onTap: isReportSubmitting ? null : onToggleReported,
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
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final enabled = onTap != null;
    final base = Container(
      height: 52,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: primary ? T.neonGradient : null,
        color: primary ? null : scheme.surfaceContainerHighest.withValues(alpha: 0.7),
        border: Border.all(
          color: scheme.onSurface.withValues(alpha: primary ? 0.18 : 0.14),
        ),
        boxShadow: primary
            ? [
                BoxShadow(
                  color: scheme.primary.withValues(alpha: 0.28),
                  blurRadius: 18,
                  spreadRadius: 1,
                ),
              ]
            : null,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: (primary ? scheme.onPrimary : scheme.onSurface).withValues(alpha: primary ? 0.98 : 0.9),
            size: 18,
          ),
          const SizedBox(width: S.xs),
          Text(
            label,
            style: textTheme.bodyMedium?.copyWith(
              color: (primary ? scheme.onPrimary : scheme.onSurface).withValues(alpha: primary ? 0.98 : 0.9),
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
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Glass(
      radius: BorderRadius.circular(22),
      padding: const EdgeInsets.fromLTRB(S.md, S.md, S.md, S.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.profileSnapshot,
            style: textTheme.titleMedium?.copyWith(
              color: scheme.onSurface,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: S.xs),
          _MetaRow(icon: Icons.info_outline_rounded, label: bio),
          const SizedBox(height: S.xs),
          _MetaRow(icon: Icons.place_rounded, label: location),
          const SizedBox(height: S.xs),
          _MetaRow(icon: Icons.auto_graph_rounded, label: l10n.profileXpValue(profile.totalXp)),
          const SizedBox(height: S.xs),
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
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Row(
      children: [
        Icon(icon, color: scheme.onSurface.withValues(alpha: 0.7), size: 16),
        const SizedBox(width: S.xs),
        Expanded(
          child: Text(
            label,
            style: textTheme.bodySmall?.copyWith(
              color: scheme.onSurface.withValues(alpha: 0.75),
              fontWeight: FontWeight.w700,
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
    final scheme = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: Glass(
        radius: BorderRadius.circular(16),
        padding: const EdgeInsets.all(S.xs),
        child: Icon(icon, color: scheme.onSurface.withValues(alpha: 0.9)),
      ),
    );
  }
}

class _LeaderboardButton extends StatelessWidget {
  final VoidCallback onTap;
  const _LeaderboardButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Glass(
        radius: BorderRadius.circular(18),
        padding: const EdgeInsets.symmetric(horizontal: S.sm, vertical: S.xs),
        child: Row(
          children: [
            Icon(Icons.emoji_events_rounded, color: scheme.onSurface, size: 18),
            const SizedBox(width: 6),
            Text(
              l10n.leaderboardGlobalTitle,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: scheme.onSurface,
                    fontWeight: FontWeight.w800,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AvatarGlow extends StatelessWidget {
  final double size;
  final ImageProvider image;
  final bool showOnlineIndicator;

  const _AvatarGlow({
    required this.size,
    required this.image,
    required this.showOnlineIndicator,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: scheme.primary.withValues(alpha: 0.45),
            blurRadius: 30,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Stack(
        children: [
          ClipOval(
            child: Image(image: image, fit: BoxFit.cover),
          ),
          if (showOnlineIndicator)
            Positioned(
              bottom: 2,
              right: 2,
              child: Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF58F7B6),
                  border: Border.all(color: scheme.surface.withValues(alpha: 0.7), width: 2),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _MiniAvatar extends StatelessWidget {
  final String asset;
  const _MiniAvatar({required this.asset});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      width: 38,
      height: 38,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: scheme.onSurface.withValues(alpha: 0.18)),
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
    final scheme = Theme.of(context).colorScheme;
    return Container(
      width: 38,
      height: 38,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: scheme.surfaceContainerHighest.withValues(alpha: 0.6),
        border: Border.all(color: scheme.onSurface.withValues(alpha: 0.18)),
      ),
      child: Icon(Icons.add_rounded, color: scheme.onSurface.withValues(alpha: 0.85)),
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
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final opacity = unlocked ? 1.0 : 0.45;
    return Glass(
      radius: BorderRadius.circular(18),
      padding: const EdgeInsets.all(S.xs),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: scheme.onSurface.withValues(alpha: 0.90 * opacity), size: 26),
          const SizedBox(height: S.xs),
          Text(
            title,
            textAlign: TextAlign.center,
            style: textTheme.bodySmall?.copyWith(
              color: scheme.onSurface.withValues(alpha: 0.75 * opacity),
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
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: S.sm, vertical: S.xs),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: scheme.onSurface.withValues(alpha: 0.14)),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: scheme.onSurface.withValues(alpha: 0.9)),
          const SizedBox(width: S.xs),
          Text(
            text,
            style: textTheme.bodySmall?.copyWith(
              color: scheme.onSurface,
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
    final scheme = Theme.of(context).colorScheme;
    return Container(
      height: 12,
      decoration: BoxDecoration(
        color: scheme.onSurface.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: scheme.onSurface.withValues(alpha: 0.12)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(999),
        child: Align(
          alignment: Alignment.centerLeft,
          child: FractionallySizedBox(
            widthFactor: value.clamp(0.0, 1.0),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    scheme.primary,
                    scheme.secondary,
                    scheme.tertiary,
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
