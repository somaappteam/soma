import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:soma/l10n/gen/app_localizations.dart';
import '../../core/widgets/glass.dart';
import '../../models/solo_course.dart';
import '../solo/solo_course_detail_screen.dart';
import '../solo/add_course_screen.dart';
import '../social/notifications/notifications_screen.dart';
import '../../data/profile_store.dart';
import '../../data/courses_repository.dart';
import '../../data/notifications_repository.dart';
import '../../data/notifications_store.dart';
import '../../data/auth_repository.dart';
import '../../core/widgets/responsive.dart';
import '../../core/widgets/soma_background.dart';

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
    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1C1C1C),
          title: Text(l10n.removeCourseTitle, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900)),
          content: Text(
            l10n.removeCourseBody(course.subtitle),
            style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontWeight: FontWeight.w600),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: Text(l10n.cancel, style: TextStyle(color: Colors.white.withValues(alpha: 0.8))),
            ),
            TextButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: Text(l10n.remove, style: const TextStyle(color: Color(0xFFFF4ECD), fontWeight: FontWeight.w800)),
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
    return Row(
      children: [
        Expanded(
          child: AnimatedBuilder(
            animation: profileStore,
            builder: (_, __) {
              return Text(
                l10n.welcomeBack(profileStore.profile.displayName),
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                    ),
              );
            },
          ),
        ),
        InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () => setState(() => _isEditingCourses = !editing),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            child: Text(
              editing ? l10n.done : l10n.editCourses,
              style: TextStyle(
                color: editing ? const Color(0xFF2AFADF) : Colors.white.withValues(alpha: 0.85),
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
    if (courses.isEmpty) {
      if (editing) {
        return Center(
          child: Text(
            l10n.noCoursesToEdit,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.6),
              fontWeight: FontWeight.w700,
            ),
          ),
        );
      }

      return ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          _AddCourseButton(
            onAdded: (newCourse) {
              _reloadCourses();
            },
          ),
        ],
      );
    }

    return ListView.separated(
      physics: const BouncingScrollPhysics(),
      itemCount: editing ? courses.length : courses.length + 1,
      separatorBuilder: (_, __) => const SizedBox(height: 14),
      itemBuilder: (context, i) {
        if (!editing && i == courses.length) {
          return _AddCourseButton(
            onAdded: (newCourse) {
              _reloadCourses();
            },
          );
        }

        final c = courses[i];
        final parts = c.subtitle.split("→");
        final fallback = l10n.unknown;
        final fromLang = parts.isNotEmpty ? parts.first.trim() : fallback;
        final toLang = parts.length > 1 ? parts[1].trim() : fallback;

        return CourseCard(
          fromLang: fromLang,
          toLang: toLang,
          xp: c.xp,
          time: "00:00:00",
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
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isGuest = authRepository.currentUser == null;
    _syncCoursesIfNeeded();
    return SomaBackground(
      child: SafeArea(
        child: ResponsiveFrame(
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 14, 18, 12),
                child: Column(
                  children: [
                // Header row
                Row(
                  children: [
                    Text(
                      l10n.appTitle,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1.8,
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
                    const SizedBox(width: 10),
                  ],
                ),

                const SizedBox(height: 18),

                // Welcome
                _buildWelcomeRow(editing: false),
                const SizedBox(height: 12),

                // Course list
                Expanded(
                  child: FutureBuilder<List<SoloCourse>>(
                    future: _coursesFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator(color: Color(0xFF2AFADF)));
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
                    padding: const EdgeInsets.fromLTRB(18, 14, 18, 12),
                    child: Column(
                      children: [
                        const SizedBox(height: 62),
                        _buildWelcomeRow(editing: true),
                        const SizedBox(height: 12),
                        Expanded(
                          child: FutureBuilder<List<SoloCourse>>(
                            future: _coursesFuture,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return const Center(
                                  child: CircularProgressIndicator(color: Color(0xFF2AFADF)),
                                );
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
    final l10n = AppLocalizations.of(context);
    return Glass(
      radius: BorderRadius.circular(14),
      padding: EdgeInsets.zero,
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: SizedBox(
          width: 44,
          height: 44,
          child: Center(
            child: Icon(icon, color: Colors.white.withValues(alpha: 0.9), size: 22),
          ),
        ),
      ),
    );
  }
}

class CourseCard extends StatelessWidget {
  final String fromLang;
  final String toLang;
  final int xp;
  final String time;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;
  final bool showDelete;

  const CourseCard({
    super.key,
    required this.fromLang,
    required this.toLang,
    required this.xp,
    required this.time,
    this.onTap,
    this.onDelete,
    this.showDelete = false,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Glass(
      radius: BorderRadius.circular(24),
      padding: EdgeInsets.zero,
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
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
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                  ),
                ),
              ),
              if (showDelete)
                InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: onDelete,
                  child: Padding(
                    padding: const EdgeInsets.all(6),
                    child: Icon(Icons.delete_rounded, color: const Color(0xFFFF4ECD).withValues(alpha: 0.9), size: 18),
                  ),
                )
              else
                Icon(Icons.chevron_right_rounded, color: Colors.white.withValues(alpha: 0.75)),
            ],
          ),
          const SizedBox(height: 12),

          // progress bar glow style
          Container(
            height: 10,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(999),
              color: Colors.white.withValues(alpha: 0.08),
              border: Border.all(color: Colors.white.withValues(alpha: 0.10)),
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
                        color: const Color(0xFF7C7CFF).withValues(alpha: 0.35),
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
  }
}

class _Pill extends StatelessWidget {
  final IconData icon;
  final String label;

  const _Pill({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        color: Colors.black.withValues(alpha: 0.16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.white.withValues(alpha: 0.9)),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.92),
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
    return Glass(
      radius: BorderRadius.circular(26),
      padding: EdgeInsets.zero,
      child: InkWell(
        borderRadius: BorderRadius.circular(26),
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
        child: SizedBox(
          height: 56,
          child: Center(
            child: Text(
              l10n.addCourse,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _BellWithBadge extends StatelessWidget {
  final int count;
  final VoidCallback onTap;

  const _BellWithBadge({required this.count, required this.onTap});

  @override
  Widget build(BuildContext context) {
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
                color: const Color(0xFFFF4ECD).withValues(alpha: 0.95),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF7C7CFF).withValues(alpha: 0.35),
                    blurRadius: 14,
                    spreadRadius: 1,
                  ),
                ],
                border: Border.all(color: Colors.white.withValues(alpha: 0.20)),
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
