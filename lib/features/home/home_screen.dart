import 'dart:ui';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:soma/l10n/gen/app_localizations.dart';
import '../../core/widgets/glass.dart';
import '../../core/widgets/neon_button.dart';
import '../../core/widgets/pressable_scale.dart';
import '../../models/solo_course.dart';
import '../solo/solo_course_detail_screen.dart';
import '../solo/add_course_screen.dart';
import '../social/notifications/notifications_screen.dart';
import '../../data/profile_store.dart';
import '../../data/courses_repository.dart';
import '../../data/notifications_repository.dart';
import '../../data/notifications_store.dart';
import '../../data/auth_repository.dart';
import '../../core/theme/motion.dart';
import '../../core/widgets/responsive.dart';
import '../../core/theme/spacing.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}



class _HomeScreenState extends State<HomeScreen> {
  // We'll load courses via FutureBuilder instead of local list
  late Future<List<SoloCourse>> _coursesFuture;
  bool _isEditingCourses = false;
  int _coursesRevision = 0;

  @override
  void initState() {
    super.initState();
    // Load profile data
    profileStore.load();
    _coursesRevision = coursesRepository.revision;
    _reloadCourses();
  }

  void _reloadCourses() {
    setState(() {
      _coursesFuture = coursesRepository.getUserCourses();
    });
  }

  void _syncCoursesIfNeeded() {
    final rev = coursesRepository.revision;
    if (rev == _coursesRevision) return;
    _coursesRevision = rev;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _reloadCourses();
    });
  }

  Future<void> _confirmDeleteCourse(SoloCourse course) async {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: scheme.surface,
          title: Text(
            l10n.removeCourseTitle,
            style: TextStyle(color: scheme.onSurface, fontWeight: FontWeight.w900),
          ),
          content: Text(
            l10n.removeCourseBody(course.subtitle),
            style: TextStyle(color: scheme.onSurface.withValues(alpha: 0.8), fontWeight: FontWeight.w600),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: Text(l10n.cancel, style: TextStyle(color: scheme.onSurface.withValues(alpha: 0.8))),
            ),
            TextButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: Text(l10n.remove, style: TextStyle(color: scheme.tertiary, fontWeight: FontWeight.w800)),
            ),
          ],
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
          child: AnimatedBuilder(
            animation: profileStore,
            builder: (_, __) {
              return Text(
                l10n.welcomeBack(profileStore.profile.displayName),
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: scheme.onBackground,
                      fontWeight: FontWeight.w800,
                    ),
              );
            },
          ),
        ),
        InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () {
            HapticFeedback.selectionClick();
            setState(() => _isEditingCourses = !editing);
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: S.xs, vertical: S.xs),
            child: Text(
              editing ? l10n.done : l10n.editCourses,
              style: TextStyle(
                color: editing ? scheme.primary : scheme.onBackground.withValues(alpha: 0.8),
                fontWeight: FontWeight.w900,
                fontSize: 12.5,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCourseList(List<SoloCourse> courses, {required bool editing}) {
    final l10n = AppLocalizations.of(context);
    // If courses is empty, the ListView.separated below will correctly handle it
    // by rendering just the AddCourseButton (count = 0 + 1).

    return ListView.separated(
              physics: const BouncingScrollPhysics(),
              itemCount: editing ? courses.length : courses.length + 1,
              separatorBuilder: (_, __) => const SizedBox(height: S.sm),
              itemBuilder: (context, i) {
        if (!editing && i == courses.length) {
          return _StaggeredIn(
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

        return _StaggeredIn(
          index: i,
          child: CourseCard(
            fromLang: fromLang,
            toLang: toLang,
            xp: c.xp,
            time: "00:00:00",
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

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isGuest = authRepository.currentUser == null;
    _syncCoursesIfNeeded();
    return SafeArea(
        child: ResponsiveFrame(
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(S.lg, S.md, S.lg, S.sm),
                child: Column(
                  children: [
                // Header row
                Row(
                  children: [
                    Text(
                      l10n.appTitle,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1.4,
                          ),
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

                const SizedBox(height: S.lg),

                // Welcome
                _buildWelcomeRow(editing: false),
                const SizedBox(height: S.sm),


                // Course list
                Expanded(
                  child: FutureBuilder<List<SoloCourse>>(
                    future: _coursesFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const _CoursesSkeleton();
                      }
                       
                      final courses = snapshot.data ?? [];
                      return _buildCourseList(courses, editing: false);
                    },
                  ),
                ),
                  ],
                ),
              ),
              if (_isEditingCourses) ...[
                Positioned.fill(
                  child: AbsorbPointer(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Container(color: Colors.black.withValues(alpha: 0.35)),
                    ),
                  ),
                ),
                Positioned.fill(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(S.lg, S.md, S.lg, S.sm),
                    child: Column(
                      children: [
                        const SizedBox(height: 62),
                        _buildWelcomeRow(editing: true),
                        const SizedBox(height: S.sm),
                        Expanded(
                          child: FutureBuilder<List<SoloCourse>>(
                            future: _coursesFuture,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return const _CoursesSkeleton();
                              }

                              final courses = snapshot.data ?? [];
                              return _buildCourseList(courses, editing: true);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
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
    return ListView.separated(
      physics: const BouncingScrollPhysics(),
      itemCount: 3,
      separatorBuilder: (_, __) => const SizedBox(height: S.sm),
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
                    widthFactor: 0.62,
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
          Icon(icon, size: 16, color: scheme.onSurface.withValues(alpha: 0.9)),
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

class _StaggeredIn extends StatefulWidget {
  final int index;
  final Widget child;

  const _StaggeredIn({required this.index, required this.child});

  @override
  State<_StaggeredIn> createState() => _StaggeredInState();
}

class _StaggeredInState extends State<_StaggeredIn> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _opacity;
  late final Animation<Offset> _offset;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: MotionTokens.long);
    final curve = CurvedAnimation(parent: _controller, curve: MotionTokens.pageInCurve);
    _opacity = Tween<double>(begin: 0, end: 1).animate(curve);
    _offset = Tween<Offset>(begin: const Offset(0, 0.06), end: Offset.zero).animate(curve);
    final delayMs = min(widget.index * 60, 240);
    Future.delayed(Duration(milliseconds: delayMs), () {
      if (mounted) {
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacity,
      child: SlideTransition(
        position: _offset,
        child: widget.child,
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
          await coursesRepository.addCustomCourse(created);
          onAdded(created);
        }
      },
    );
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
