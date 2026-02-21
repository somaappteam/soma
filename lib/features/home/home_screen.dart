import 'dart:math';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../core/services/haptics_service.dart';
import 'package:soma/l10n/gen/app_localizations.dart';
import '../../core/widgets/glass.dart';
import '../../core/widgets/neon_button.dart';
import '../../core/widgets/pressable_scale.dart';
import '../../core/widgets/staggered_in.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../models/solo_course.dart';
import '../solo/solo_course_detail_screen.dart';
import '../solo/add_course_screen.dart';
import '../social/notifications/notifications_screen.dart';
import '../../data/profile_store.dart';
import '../../data/courses_repository.dart';
import '../../data/notifications_repository.dart';
import '../../data/notifications_store.dart';
import '../../data/auth_repository.dart';
import '../../data/settings_repository.dart';
import '../../data/social_repository.dart';
import '../../data/presence_repository.dart';
import '../../data/profile_repository.dart';
import '../../core/theme/motion.dart';
import '../../core/widgets/responsive.dart';
import '../../core/theme/spacing.dart';
import '../../core/theme/layout_tokens.dart';
import '../../core/widgets/premium_screen_scaffold.dart';
import '../profile/profile_screen.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}



class _HomeScreenState extends State<HomeScreen> {
  // We'll load courses via StreamBuilder
  late Stream<List<SoloCourse>> _coursesStream;
  bool _isEditingCourses = false;

  @override
  void initState() {
    super.initState();
    // Load profile data
    profileStore.load();
    _loadWelcomeState();
    _initCoursesStream();
  }

  void _initCoursesStream() {
    _coursesStream = coursesRepository.getUserCoursesStream();
  }

  void _reloadCourses() {
    // No-op or force refresh if needed, but stream covers most cases
    setState(() {
       _coursesStream = coursesRepository.getUserCoursesStream();
    });
  }

  Future<void> _loadWelcomeState() async {
    if (authRepository.currentUser == null) return;
    final settings = await settingsRepository.getSettings();
    final hasSeenHome = settings['has_seen_home'] == true;
    if (!mounted) return;
    if (!hasSeenHome) {
      await settingsRepository.updateSetting('has_seen_home', true);
    }
  }

  // _syncCoursesIfNeeded removed as stream handles updates

  Future<void> _confirmDeleteCourse(SoloCourse course) async {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    final result = await showDialog<bool>(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.55),
      builder: (ctx) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(horizontal: 24),
          child: Glass(
            radius: BorderRadius.circular(24),
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 18),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: LinearGradient(
                      colors: [
                        scheme.tertiary.withValues(alpha: 0.92),
                        scheme.error.withValues(alpha: 0.88),
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: scheme.error.withValues(alpha: 0.28),
                        blurRadius: 14,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: Icon(Icons.delete_forever_rounded, color: scheme.onError, size: 26),
                ),
                const SizedBox(height: 14),
                Text(
                  l10n.removeCourseTitle,
                  style: TextStyle(
                    color: scheme.onSurface,
                    fontWeight: FontWeight.w900,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.removeCourseBody(course.subtitle),
                  style: TextStyle(
                    color: scheme.onSurface.withValues(alpha: 0.78),
                    fontWeight: FontWeight.w600,
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(ctx, false),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: scheme.onSurface,
                          side: BorderSide(color: scheme.onSurface.withValues(alpha: 0.24)),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        ),
                        child: Text(l10n.cancel),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(ctx, true),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: scheme.error,
                          foregroundColor: scheme.onError,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          elevation: 0,
                        ),
                        child: Text(
                          l10n.remove,
                          style: const TextStyle(fontWeight: FontWeight.w800),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );

    if (result == true) {
      await coursesRepository.removeCourse(course.id);
      _reloadCourses();
    }
  }

  Widget _buildWelcomeRow({required bool editing}) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    return Row(
      children: [
        Expanded(
          child: Text(
            l10n.myCourses,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: scheme.onSurface,
                  fontWeight: FontWeight.w800,
                  fontSize: 19,
                ),
          ),
        ),
        InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () {
            hapticsService.selectionClick();
            setState(() => _isEditingCourses = !editing);
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: S.xs, vertical: S.xs),
            child: Text(
              editing ? l10n.done : l10n.editCourses,
              style: TextStyle(
                color: editing ? scheme.primary : scheme.onSurface.withValues(alpha: 0.8),
                fontWeight: FontWeight.w900,
                fontSize: 12.5,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCourseList(List<SoloCourse> courses, {required bool editing, required double listGap}) {
    final l10n = AppLocalizations.of(context);
    // If courses is empty, the ListView.separated below will correctly handle it
    // by rendering just the AddCourseButton (count = 0 + 1).

    return ListView.separated(
              physics: const BouncingScrollPhysics(),
              itemCount: editing ? courses.length : courses.length + 1,
              separatorBuilder: (_, __) => SizedBox(height: listGap),
              itemBuilder: (context, i) {
        if (!editing && i == courses.length) {
          return StaggeredIn(
            index: i,
            child: _AddCourseButton(
              onAdded: (newCourse) {
                _reloadCourses();
              },
            ),
          );
        }

        final c = courses[i];
        final parts = c.subtitle.split("→");
        final fallback = l10n.unknown;
        final fromLang = parts.isNotEmpty ? parts.first.trim() : fallback;
        final toLang = parts.length > 1 ? parts[1].trim() : fallback;
        final progress = _progressForCourse(c.xp);
        final timeLabel = _formatElapsed(c.lastAccessed);

        return StaggeredIn(
          index: i,
          child: CourseCard(
            fromLang: fromLang,
            toLang: toLang,
            xp: c.xp,
            time: timeLabel,
            progress: progress,
            heroTag: "course-card-${c.id}",
            onTap: editing
                ? null
                : () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => SoloCourseDetailScreen(course: c)),
                    );
                    _reloadCourses();
                  },
            onDelete: editing ? () => _confirmDeleteCourse(c) : null,
            showDelete: editing,
          ),
        );
      },
    );
  }

  double _progressForCourse(int xp) {
    const maxXp = 1000;
    return (xp / maxXp).clamp(0.0, 1.0);
  }

  String _formatElapsed(DateTime? lastAccessed) {
    if (lastAccessed == null) return "00:00:00";
    final diff = DateTime.now().difference(lastAccessed);
    final hours = diff.inHours;
    final minutes = diff.inMinutes.remainder(60);
    final seconds = diff.inSeconds.remainder(60);
    return "${hours.toString().padLeft(2, "0")}:${minutes.toString().padLeft(2, "0")}:${seconds.toString().padLeft(2, "0")}";
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isGuest = authRepository.currentUser == null;
    
    return PremiumScreenScaffold(
      body: ResponsiveFrame(
        child: Column(
          children: [
            // Header row
            Row(
                  children: [
                    // Profile Pic + Username
                    StreamBuilder<Map<String, bool>>(
                      stream: presenceRepository.streamMultipleOnlineStatuses([authRepository.currentUser?.id].whereType<String>().toList()),
                      builder: (context, presenceSnapshot) {
                        final isOnline = presenceSnapshot.data?[authRepository.currentUser?.id] ?? false;
                        
                        return AnimatedBuilder(
                          animation: profileStore,
                          builder: (context, _) {
                            final p = profileStore.profile;
                            final hasAvatar = p.avatarUrl != null && p.avatarUrl!.isNotEmpty;
                            final username = p.username.isNotEmpty ? p.username : l10n.guestUsername;
                            
                            return Row(
                              children: [
                                Stack(
                                  children: [
                                    Container(
                                      width: 42,
                                      height: 42,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Theme.of(context).colorScheme.surfaceContainerHighest,
                                        image: hasAvatar
                                            ? DecorationImage(
                                                image: CachedNetworkImageProvider(p.avatarUrl!),
                                                fit: BoxFit.cover,
                                              )
                                            : null,
                                        border: Border.all(
                                          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.16),
                                          width: 1.5,
                                        ),
                                      ),
                                      child: !hasAvatar
                                          ? Center(
                                              child: Text(
                                                username.isNotEmpty ? username[0].toUpperCase() : "?",
                                                style: TextStyle(
                                                  color: Theme.of(context).colorScheme.onSurface,
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 16,
                                                ),
                                              ),
                                            )
                                          : null,
                                    ),
                                    if (isOnline)
                                      Positioned(
                                        bottom: 0,
                                        right: 0,
                                        child: Container(
                                          width: 12,
                                          height: 12,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: const Color(0xFF58F7B6),
                                            border: Border.all(color: Theme.of(context).colorScheme.surface, width: 2.5),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  username,
                                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                        fontWeight: FontWeight.w800,
                                        fontSize: 17,
                                      ),
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                    const Spacer(),
                    if (isGuest)
                      AnimatedBuilder(
                        animation: notificationsStore,
                        builder: (context, _) {
                          final count = notificationsStore.items
                              .where((n) => !n.isRead && (n.type == NotifType.course || n.type == NotifType.system))
                              .length;
                          return _BellWithBadge(
                            count: count,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => const NotificationsScreen()),
                              );
                            },
                          );
                        },
                      )
                    else
                      StreamBuilder<List<Map<String, dynamic>>>(
                        stream: notificationsRepository.getNotificationsStream(),
                        builder: (context, snapshot) {
                          final count = snapshot.data?.where((n) => !(n['is_read'] as bool? ?? false)).length ?? 0;
                          return _BellWithBadge(
                            count: count,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => const NotificationsScreen()),
                              );
                            },
                          );
                        }
                      ),
                    const SizedBox(width: S.xs),
                  ],
                ),

                const SizedBox(height: SectionGap.xl),

                if (!isGuest) ...[
                  _ActiveFriendsStrip(),
                  const SizedBox(height: SectionGap.lg),
                ],

                // Welcome
                _buildWelcomeRow(editing: _isEditingCourses),
                const SizedBox(height: S.sm),


                // Course list
                Expanded(
                  child: StreamBuilder<List<SoloCourse>>(
                    stream: _coursesStream,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const _CoursesSkeleton();
                      }
                       
                      final courses = snapshot.data ?? [];
                      final density = PremiumLayout.densityForWidth(MediaQuery.of(context).size.width);
                      final listGap = PremiumLayout.listGap(density);
                      return _buildCourseList(courses, editing: _isEditingCourses, listGap: listGap);
                    },
                  ),
                ),
          ],
        ),
      ),
      padding: PremiumLayout.screenPadding(PremiumLayout.densityForWidth(MediaQuery.of(context).size.width)),
    );
  }
}


class _SmallIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _SmallIconButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Glass(
      radius: BorderRadius.circular(14),
      padding: EdgeInsets.zero,
      child: PressableScale(
        onTap: onTap,
        child: SizedBox(
          width: 44,
          height: 44,
          child: Center(
            child: Icon(icon, color: scheme.onSurface.withValues(alpha: 0.9), size: 22),
          ),
        ),
      ),
    );
  }
}



class _CoursesSkeleton extends StatelessWidget {
  const _CoursesSkeleton();

  @override
  Widget build(BuildContext context) {
    final density = PremiumLayout.densityForWidth(MediaQuery.of(context).size.width);
    final listGap = PremiumLayout.listGap(density);
    return ListView.separated(
      physics: const BouncingScrollPhysics(),
      itemCount: 3,
      separatorBuilder: (_, __) => SizedBox(height: listGap),
      itemBuilder: (context, index) => const _SkeletonCard(),
    );
  }
}

class _SkeletonCard extends StatelessWidget {
  const _SkeletonCard();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.3, end: 0.7),
      duration: const Duration(milliseconds: 900),
      curve: Curves.easeInOut,
      builder: (context, value, child) {
        final base = scheme.onSurface.withValues(alpha: 0.08 + (0.06 * value));
        return Container(
          height: 96,
          decoration: BoxDecoration(
            color: base,
            borderRadius: BorderRadius.circular(22),
          ),
          padding: const EdgeInsets.all(S.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _SkeletonLine(width: 120, color: base.withValues(alpha: 0.9)),
              const SizedBox(height: S.xs),
              _SkeletonLine(width: 200, color: base.withValues(alpha: 0.8)),
              const Spacer(),
              _SkeletonLine(width: 80, color: base.withValues(alpha: 0.7)),
            ],
          ),
        );
      },
    );
  }
}

class _SkeletonLine extends StatelessWidget {
  final double width;
  final Color color;

  const _SkeletonLine({required this.width, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: 10,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(999),
      ),
    );
  }
}

class CourseCard extends StatelessWidget {
  final String fromLang;
  final String toLang;
  final int xp;
  final String time;
  final double progress;
  final String? heroTag;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;
  final bool showDelete;

  const CourseCard({
    super.key,
    required this.fromLang,
    required this.toLang,
    required this.xp,
    required this.time,
    required this.progress,
    this.heroTag,
    this.onTap,
    this.onDelete,
    this.showDelete = false,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final card = Glass(
      radius: BorderRadius.circular(24),
      padding: EdgeInsets.zero,
      child: PressableScale(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
          child: Column(
            children: [
              Row(
                children: [
                  _FlagDot(),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      "$fromLang  →  $toLang",
                      style: textTheme.titleMedium?.copyWith(
                        color: scheme.onSurface,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  if (showDelete)
                    InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: onDelete,
                      child: Padding(
                        padding: const EdgeInsets.all(6),
                        child: Icon(Icons.delete_rounded,
                            color: scheme.tertiary.withValues(alpha: 0.9), size: 18),
                      ),
                    )
                  else
                    Icon(Icons.chevron_right_rounded, color: scheme.onSurface.withValues(alpha: 0.65)),
                ],
              ),
              const SizedBox(height: 12),

              // progress bar glow style
              Container(
                height: 10,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(999),
                  color: scheme.onSurface.withValues(alpha: 0.08),
              border: Border.all(color: scheme.onSurface.withValues(alpha: 0.12)),
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: FractionallySizedBox(
                    widthFactor: progress,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(999),
                        gradient: const LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [
                            Color(0xFF2AFADF),
                            Color(0xFF7C7CFF),
                            Color(0xFFFF4ECD),
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: scheme.primary.withValues(alpha: 0.35),
                            blurRadius: 18,
                            spreadRadius: 2, // Reverted to original as BorderRadius is not compatible here
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              Row(
                children: [
                  _Pill(icon: Icons.bolt_rounded, label: "+$xp"),
                  const Spacer(),
                  _Pill(icon: Icons.timer_rounded, label: time),
                ],
              ),
            ],
          ),
        ),
      ),
    );
    if (heroTag == null) return card;
    return Hero(
      tag: heroTag!,
      child: Material(
        type: MaterialType.transparency,
        child: card,
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  final IconData icon;
  final String label;

  const _Pill({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        color: scheme.surfaceContainerHighest.withValues(alpha: 0.7),
        border: Border.all(color: scheme.onSurface.withValues(alpha: 0.12)),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: icon == Icons.bolt_rounded
              ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.9)
              : Theme.of(context).colorScheme.tertiary.withValues(alpha: 0.85)),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: scheme.onSurface.withValues(alpha: 0.92),
              fontWeight: FontWeight.w800,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}

class _FlagDot extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 18,
      height: 18,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(
          colors: [Color(0xFF2AFADF), Color(0xFFFF4ECD)],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF7C7CFF).withValues(alpha: 0.35),
            blurRadius: 14,
            spreadRadius: 1,
          ),
        ],
      ),
    );
  }
}



class _AddCourseButton extends StatelessWidget {
  final void Function(SoloCourse newCourse) onAdded;

  const _AddCourseButton({required this.onAdded});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    return NeonButton(
      label: l10n.addCourse,
      onTap: () async {
        final created = await Navigator.push<SoloCourse>(
          context,
          MaterialPageRoute(builder: (_) => const AddCourseScreen()),
        );

        if (created != null) {
          final existingCourses = await coursesRepository.getUserCourses();
          final duplicate = existingCourses.any((course) => _isSameCourse(course, created));
          if (duplicate) {
            if (!context.mounted) return;
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text(
                    'You already have ${created.subtitle}. Duplicate course was not added.',
                  ),
                ),
              );
            return;
          }

          await coursesRepository.addCustomCourse(created);
          onAdded(created);
        }
      },
    );
  }

  bool _isSameCourse(SoloCourse a, SoloCourse b) {
    if (a.id == b.id) return true;
    final aPair = _coursePairKey(a);
    final bPair = _coursePairKey(b);
    return aPair != null && aPair == bPair;
  }

  String? _coursePairKey(SoloCourse course) {
    final idMatch = RegExp(r'^solo_([a-z]{2,})_([a-z]{2,})(?:_\d+)?$').firstMatch(
      course.id.toLowerCase(),
    );
    if (idMatch != null) {
      return '${idMatch.group(1)}->${idMatch.group(2)}';
    }

    final subtitleMatch = RegExp(r'^\s*(.*?)\s*→\s*(.*?)\s*$').firstMatch(course.subtitle);
    if (subtitleMatch != null) {
      final src = subtitleMatch.group(1)?.trim().toLowerCase();
      final dst = subtitleMatch.group(2)?.trim().toLowerCase();
      if ((src ?? '').isNotEmpty && (dst ?? '').isNotEmpty) {
        return '$src->$dst';
      }
    }

    return null;
  }
}

class _BellWithBadge extends StatelessWidget {
  final int count;
  final VoidCallback onTap;

  const _BellWithBadge({required this.count, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Stack(
      clipBehavior: Clip.none,
      children: [
        _SmallIconButton(icon: Icons.notifications_none_rounded, onTap: onTap),
        if (count > 0)
          Positioned(
            right: -2,
            top: -2,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(999),
                color: scheme.tertiary.withValues(alpha: 0.95),
                boxShadow: [
                  BoxShadow(
                    color: scheme.primary.withValues(alpha: 0.35),
                    blurRadius: 14,
                    spreadRadius: 1,
                  ),
                ],
                border: Border.all(color: scheme.onSurface.withValues(alpha: 0.2)),
              ),
              child: Text(
                count > 99 ? "99+" : "$count",
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  fontSize: 11,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _ActiveFriendsStrip extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;

    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: socialRepository.getFriendsStream(),
      builder: (context, friendsSnapshot) {
        final friends = friendsSnapshot.data ?? [];
        if (friends.isEmpty) return const SizedBox.shrink();

        final friendIds = friends
            .map((f) => f['id']?.toString())
            .whereType<String>()
            .toList();

        return StreamBuilder<Map<String, bool>>(
          stream: presenceRepository.streamMultipleOnlineStatuses(friendIds),
          builder: (context, presenceSnapshot) {
            final onlineStatuses = presenceSnapshot.data ?? {};
            final onlineFriends = friends.where((f) => onlineStatuses[f['id']?.toString()] == true).toList();

            if (onlineFriends.isEmpty) return const SizedBox.shrink();

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Text(
                    "Active Now",
                    style: TextStyle(
                      color: scheme.onSurface,
                      fontWeight: FontWeight.w900,
                      fontSize: 14,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                SizedBox(
                  height: 60,
                  child: ListView.separated(
                    padding: EdgeInsets.zero,
                    scrollDirection: Axis.horizontal,
                    itemCount: onlineFriends.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 14),
                    itemBuilder: (context, index) {
                      final f = onlineFriends[index];
                      final avatarUrl = f['avatar_url']?.toString();
                      final username = f['username']?.toString() ?? "";
                      final userId = f['id']?.toString();

                      return GestureDetector(
                        onTap: userId == null
                            ? null
                            : () => Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (_) => ProfileScreen(userId: userId)),
                                ),
                        child: Column(
                          children: [
                            Stack(
                              children: [
                                Container(
                                  width: 44,
                                  height: 44,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: scheme.primary.withValues(alpha: 0.4),
                                      width: 1.5,
                                    ),
                                    image: (avatarUrl != null && avatarUrl.isNotEmpty)
                                        ? DecorationImage(
                                            image: CachedNetworkImageProvider(avatarUrl),
                                            fit: BoxFit.cover,
                                          )
                                        : null,
                                  ),
                                  child: (avatarUrl == null || avatarUrl.isEmpty)
                                      ? Center(
                                          child: Text(
                                            username.isNotEmpty ? username[0].toUpperCase() : "?",
                                            style: TextStyle(
                                              color: scheme.onSurface,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        )
                                      : null,
                                ),
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: Container(
                                    width: 12,
                                    height: 12,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: const Color(0xFF58F7B6),
                                      border: Border.all(color: scheme.surface, width: 2),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
