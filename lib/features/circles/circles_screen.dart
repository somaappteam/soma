import 'package:flutter/material.dart';
import 'package:soma/l10n/gen/app_localizations.dart';
import '../../core/widgets/glass.dart';
import '../../core/widgets/neon_button.dart';
import '../social/friends_screen.dart';
import '../social/inbox_screen.dart';
import 'create_circle_screen.dart';
import 'circle_lobby_screen.dart';
import '../../core/theme/tokens.dart';
import '../solo/add_course_screen.dart';
import '../../data/circles_repository.dart';
import '../../data/courses_repository.dart';
import '../../data/languages.dart';
import '../../models/solo_course.dart';
import '../../core/widgets/responsive.dart';

class CirclesScreen extends StatefulWidget {
  const CirclesScreen({super.key});

  @override
  State<CirclesScreen> createState() => _CirclesScreenState();
}

class _CirclesScreenState extends State<CirclesScreen> {
  static const _courseAll = "__all__";
  static const _courseAdd = "__add__";
  static const _modeAll = "all";
  static const _levelAll = "all";

  String _selectedCourseId = _courseAll;
  String _selectedMode = _modeAll;
  String _selectedLevel = _levelAll;

  List<SoloCourse> _courses = [];
  int _coursesRevision = 0;
  late final Stream<List<Map<String, dynamic>>> _openCirclesStream;
  late final Stream<Map<String, CircleParticipantCounts>> _participantCountsStream;

  @override
  void initState() {
    super.initState();
    _openCirclesStream = circlesRepository.getOpenCircles();
    _participantCountsStream = circlesRepository.getOpenCircleParticipantCounts();
    _coursesRevision = coursesRepository.revision;
    _loadCourses();
    _cleanupGhostCircles();
  }

  Future<void> _cleanupGhostCircles() async {
    try {
      await circlesRepository.cleanupGhostCircles();
    } catch (e) {
      debugPrint("Cleanup failed: $e");
    }
  }

  Future<void> _loadCourses({String? selectCourseId}) async {
    final courses = await coursesRepository.getUserCourses();
    if (!mounted) return;

    final selectedExists = _selectedCourseId == _courseAll || courses.any((c) => c.id == _selectedCourseId);
    setState(() {
      _courses = courses;
      if (selectCourseId != null) {
        _selectedCourseId = selectCourseId;
      } else if (!selectedExists) {
        _selectedCourseId = _courseAll;
      }
    });
  }

  void _syncCoursesIfNeeded() {
    final rev = coursesRepository.revision;
    if (rev == _coursesRevision) return;
    _coursesRevision = rev;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _loadCourses();
    });
  }

  Future<void> _openAddCourse() async {
    final created = await Navigator.push<SoloCourse>(
      context,
      MaterialPageRoute(builder: (_) => const AddCourseScreen()),
    );

    if (created != null) {
      await coursesRepository.addCustomCourse(created);
      await _loadCourses(selectCourseId: created.id);
    }
  }

  List<_CourseOption> _buildCourseOptions() {
    final options = _courses.map(_CourseOption.fromCourse).toList();
    options.sort((a, b) => a.label.toLowerCase().compareTo(b.label.toLowerCase()));
    return options;
  }

  String _courseLabel(List<_CourseOption> options, AppLocalizations l10n) {
    if (_selectedCourseId == _courseAll) return l10n.circlesAllCourses;
    final match = options.where((o) => o.id == _selectedCourseId).toList();
    if (match.isEmpty) return l10n.circlesAllCourses;
    return match.first.label;
  }

  String _modeLabel(AppLocalizations l10n) {
    if (_selectedMode == _modeAll) return l10n.circlesAllModes;
    return _modeLabelForValue(l10n, _selectedMode);
  }

  String _levelLabel(AppLocalizations l10n) {
    if (_selectedLevel == _levelAll) return l10n.circlesAllLevels;
    return _levelLabelForValue(l10n, _selectedLevel);
  }

  String _modeLabelForValue(AppLocalizations l10n, String value) {
    if (value.toLowerCase() == "vocabulary") return l10n.soloModeVocabulary;
    if (value.toLowerCase() == "sentences") return l10n.soloModeSentences;
    if (value.toLowerCase() == "review") return l10n.soloModeReview;
    return value;
  }

  bool _matchesMode(String? mode) {
    if (_selectedMode == _modeAll) return true;
    if (mode == null) return false;
    return mode.toLowerCase() == _selectedMode.toLowerCase();
  }

  bool _matchesLevel(String? level) {
    if (_selectedLevel == _levelAll) return true;
    if (level == null) return false;
    final normalized = normalizeLevelCode(level);
    return normalized != null && normalized == _selectedLevel;
  }

  bool _matchesCourse(Map<String, dynamic> data, _CourseOption option) {
    final fromRaw = data['from_lang']?.toString() ?? "";
    final toRaw = data['to_lang']?.toString() ?? "";
    final fromCode = langCodeFromValue(fromRaw);
    final toCode = langCodeFromValue(toRaw);

    if (option.fromCode != null && option.toCode != null && fromCode != null && toCode != null) {
      return option.fromCode == fromCode && option.toCode == toCode;
    }

    final fromLabel = langLabel(fromRaw).toLowerCase();
    final toLabel = langLabel(toRaw).toLowerCase();
    return fromLabel == option.fromName.toLowerCase() && toLabel == option.toName.toLowerCase();
  }

  Future<void> _selectCourseFilter(List<_CourseOption> options) async {
    final l10n = AppLocalizations.of(context);
    final items = <_FilterOption>[
      _FilterOption(label: l10n.circlesAllCourses, value: _courseAll, icon: Icons.all_inclusive_rounded),
      ...options.map(
        (o) => _FilterOption(label: o.label, value: o.id, icon: Icons.translate_rounded),
      ),
      _FilterOption(
        label: l10n.circlesAddNewCourse,
        value: _courseAdd,
        icon: Icons.add_rounded,
        isAction: true,
      ),
    ];

    final result = await _pickFilterOption(
      context,
      title: l10n.circlesCoursesTitle,
      items: items,
      current: _selectedCourseId,
    );

    if (result == null) return;
    if (result == _courseAdd) {
      await _openAddCourse();
      return;
    }

    setState(() => _selectedCourseId = result);
  }

  Future<void> _selectModeFilter() async {
    final l10n = AppLocalizations.of(context);
    final items = <_FilterOption>[
      _FilterOption(label: l10n.circlesAllModes, value: _modeAll, icon: Icons.all_inclusive_rounded),
      _FilterOption(label: l10n.soloModeVocabulary, value: "Vocabulary", icon: Icons.view_list_rounded),
      _FilterOption(label: l10n.soloModeSentences, value: "Sentences", icon: Icons.chat_bubble_rounded),
    ];

    final result = await _pickFilterOption(
      context,
      title: l10n.circlesModeTitle,
      items: items,
      current: _selectedMode,
    );

    if (result != null) setState(() => _selectedMode = result);
  }

  Future<void> _selectLevelFilter() async {
    final l10n = AppLocalizations.of(context);
    final items = <_FilterOption>[
      _FilterOption(label: l10n.circlesAllLevels, value: _levelAll, icon: Icons.all_inclusive_rounded),
      _FilterOption(label: l10n.levelBeginner, value: "A", icon: Icons.rocket_launch_rounded),
      _FilterOption(label: l10n.levelIntermediate, value: "B", icon: Icons.trending_up_rounded),
      _FilterOption(label: l10n.levelAdvanced, value: "C", icon: Icons.auto_awesome_rounded),
    ];

    final result = await _pickFilterOption(
      context,
      title: l10n.circlesLevelTitle,
      items: items,
      current: _selectedLevel,
    );

    if (result != null) setState(() => _selectedLevel = result);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    _syncCoursesIfNeeded();
    final courseOptions = _buildCourseOptions();
    _CourseOption? selectedCourseOption;
    if (_selectedCourseId != _courseAll) {
      for (final o in courseOptions) {
        if (o.id == _selectedCourseId) {
          selectedCourseOption = o;
          break;
        }
      }
    }

    return SafeArea(
      child: ResponsiveFrame(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 14, 18, 12),
          child: Column(
            children: [
              // Header
              Row(
                children: [
                  Text(
                    l10n.navCircles,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurface,
                          fontWeight: FontWeight.w900,
                        ),
                  ),
                  const Spacer(),
                  _SmallIconButton(
                    icon: Icons.people_rounded,
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const FriendsScreen())),
                  ),
                  const SizedBox(width: 10),
                  _SmallIconButton(
                    icon: Icons.mail_rounded,
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const InboxScreen())),
                  ),
                ],
              ),

              const SizedBox(height: 14),

              // Filters row
              Glass(
                radius: BorderRadius.circular(18),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                child: Row(
                  children: [
                    _FilterChip(
                      label: _courseLabel(courseOptions, l10n),
                      icon: Icons.translate_rounded,
                      onTap: () => _selectCourseFilter(courseOptions),
                    ),
                    const SizedBox(width: 10),
                    _FilterChip(
                      label: _modeLabel(l10n),
                      icon: Icons.grid_view_rounded,
                      onTap: _selectModeFilter,
                    ),
                    const SizedBox(width: 10),
                    _FilterChip(
                      label: _levelLabel(l10n),
                      icon: Icons.leaderboard_rounded,
                      onTap: _selectLevelFilter,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 14),

              // Active circles list
              Expanded(
                child: StreamBuilder<List<Map<String, dynamic>>>(
                  stream: _openCirclesStream,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(
                        child: CircularProgressIndicator(color: Color(0xFF2AFADF)),
                      );
                    }
                    
                    final rooms = snapshot.data!;

                    return StreamBuilder<Map<String, CircleParticipantCounts>>(
                      stream: _participantCountsStream,
                      builder: (context, countsSnapshot) {
                        final countsByCircle = countsSnapshot.data ?? const <String, CircleParticipantCounts>{};
                        final filtered = rooms.where((data) {
                          if (!_matchesMode(data['mode']?.toString())) return false;
                          if (!_matchesLevel(data['level']?.toString())) return false;
                          if (selectedCourseOption != null && !_matchesCourse(data, selectedCourseOption)) return false;
                          return true;
                        }).toList();

                        if (filtered.isEmpty) {
                          return Center(
                            child: Text(
                              l10n.circlesNoActiveForFilters,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          );
                        }

                        return ListView.separated(
                          physics: const BouncingScrollPhysics(),
                          itemCount: filtered.length,
                          separatorBuilder: (_, __) => const SizedBox(height: 12),
                          itemBuilder: (context, i) {
                            final data = filtered[i];
                            final circleId = data['id']?.toString() ?? '';
                            final counts = countsByCircle[circleId] ?? const CircleParticipantCounts();
                            final fromLabel = langLabel(data['from_lang']?.toString() ?? '?');
                            final toLabel = langLabel(data['to_lang']?.toString() ?? '?');
                            final room = CircleRoom(
                              id: circleId,
                              title: data['name'] ?? l10n.circlesUnknownRoom,
                              fromLang: fromLabel,
                              toLang: toLabel,
                              level: data['level'] ?? 'A',
                              mode: data['mode'] ?? 'Vocabulary',
                              players: counts.players,
                              maxPlayers: data['max_players'] ?? 5,
                              spectators: counts.spectators,
                              questions: data['questions_count'] ?? 15,
                              timePerQ: data['time_per_q'] ?? 10,
                              isLive: true,
                            );

                            return CircleCard(
                              room: room,
                              onJoin: () async {
                                try {
                                  final status = data['status']?.toString() ?? 'lobby';
                                  final role = status == 'active' ? 'spectator' : 'player';
                                  await circlesRepository.joinCircle(room.id, role: role);
                                  if (!context.mounted) return;
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => CircleLobbyScreen(circleId: room.id),
                                    ),
                                  );
                                } catch (e) {
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(l10n.circlesJoinError(e.toString())),
                                        backgroundColor: Colors.redAccent,
                                      ),
                                    );
                                  }
                                }
                              },
                            );
                          },
                        );
                      },
                    );
                  }
                ),
              ),

              // Create Circle CTA
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: NeonButton(
                  label: l10n.circlesCreateCircle,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CreateCircleScreen(),
                      ),
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

class CircleRoom {
  final String id;
  final String title;
  final String fromLang;
  final String toLang;
  final String mode;
  final String level;
  final int players;
  final int maxPlayers;
  final int spectators;
  final int questions;
  final int timePerQ;
  final bool isLive;

  CircleRoom({
    required this.id,
    required this.title,
    required this.fromLang,
    required this.toLang,
    required this.mode,
    required this.level,
    required this.players,
    required this.maxPlayers,
    required this.spectators,
    required this.questions,
    required this.timePerQ,
    required this.isLive,
  });
}

class _CourseOption {
  final String id;
  final String label;
  final String fromName;
  final String toName;
  final String? fromCode;
  final String? toCode;

  const _CourseOption({
    required this.id,
    required this.label,
    required this.fromName,
    required this.toName,
    required this.fromCode,
    required this.toCode,
  });

  factory _CourseOption.fromCourse(SoloCourse course) {
    final parts = course.subtitle.split("?");
    final fromName = parts.isNotEmpty ? parts.first.trim() : course.subtitle.trim();
    final toName = parts.length > 1 ? parts[1].trim() : "";
    final label = toName.isEmpty ? fromName : "$fromName ? $toName";
    return _CourseOption(
      id: course.id,
      label: label,
      fromName: fromName,
      toName: toName,
      fromCode: langCodeFromValue(fromName),
      toCode: langCodeFromValue(toName),
    );
  }
}

class _FilterOption {
  final String label;
  final String value;
  final IconData? icon;
  final bool isAction;

  const _FilterOption({
    required this.label,
    required this.value,
    this.icon,
    this.isAction = false,
  });
}

class CircleCard extends StatelessWidget {
  final CircleRoom room;
  final VoidCallback onJoin;

  const CircleCard({
    super.key,
    required this.room,
    required this.onJoin,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final modeLabel = room.mode.toLowerCase() == "vocabulary"
        ? l10n.soloModeVocabulary
        : room.mode.toLowerCase() == "sentences"
            ? l10n.soloModeSentences
            : room.mode;
    final levelLabel = _levelLabelForValue(l10n, room.level);
    return Glass(
      radius: BorderRadius.circular(22),
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 16),
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 172),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          // Title row
          Row(
            children: [
              _LiveDot(live: room.isLive),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  room.title,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontSize: 17,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              Icon(Icons.chevron_right_rounded, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.70)),
            ],
          ),

          const SizedBox(height: 12),

          // Language + mode line
          Text(
            l10n.circlesRoomLine(room.fromLang, room.toLang, modeLabel, levelLabel),
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.75),
              fontWeight: FontWeight.w700,
              fontSize: 13.5,
            ),
          ),

          const SizedBox(height: 14),

          // Stats pills
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _Pill(icon: Icons.people_rounded, label: "${room.players}/${room.maxPlayers}"),
              _Pill(icon: Icons.visibility_rounded, label: "${room.spectators}"),
              _Pill(icon: Icons.help_rounded, label: l10n.questionsShort(room.questions)),
              _Pill(icon: Icons.timer_rounded, label: l10n.secondsShort(room.timePerQ)),
            ],
          ),

          const Spacer(),
          const SizedBox(height: 14),

          // Actions
          Row(
            children: [
              Expanded(
                child: _ActionButton(
                  label: l10n.join,
                  onTap: onJoin,
                  filled: true,
                ),
              ),
            ],
          ),
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
            child: Icon(icon, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.9), size: 22),
          ),
        ),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const _FilterChip({required this.label, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Container(
          height: 40,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            color: Theme.of(context).brightness == Brightness.light
                ? Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.08)
                : Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
            border: Border.all(
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.12)),
          ),
          child: Row(
            children: [
              Icon(icon, size: 18, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.85)),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  label,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.85),
                    fontWeight: FontWeight.w800,
                    fontSize: 12.5,
                  ),
                ),
              ),
              Icon(Icons.expand_more_rounded, size: 18, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.65)),
            ],
          ),
        ),
      ),
    );
  }
}

Future<String?> _pickFilterOption(
  BuildContext context, {
  required String title,
  required List<_FilterOption> items,
  required String current,
}) async {
  return showModalBottomSheet<String>(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (ctx) {
      final maxHeight = MediaQuery.of(context).size.height * 0.7;
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
          child: Glass(
            radius: BorderRadius.circular(26),
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
            child: SizedBox(
              height: maxHeight,
              child: ListView(
                physics: const BouncingScrollPhysics(),
                children: [
                  Row(
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface,
                          fontWeight: FontWeight.w900,
                          fontSize: 16,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: () => Navigator.pop(ctx),
                        icon: Icon(Icons.close_rounded, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.85)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  ...items.map((item) {
                    final selected = !item.isAction && item.value == current;
                    final textColor = item.isAction
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.onSurface.withValues(alpha: selected ? 0.98 : 0.92);
                    return InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: () => Navigator.pop(ctx, item.value),
                      child: Container(
                        height: 52,
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: selected
                              ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.10)
                              : (Theme.of(context).brightness == Brightness.light
                                  ? Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.08)
                                  : Theme.of(context)
                                      .colorScheme
                                      .surfaceContainerHighest
                                      .withValues(alpha: item.isAction ? 0.18 : 0.10)),
                          border: Border.all(
                            color: selected
                                ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.26)
                                : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.10),
                          ),
                        ),
                        child: Row(
                          children: [
                            if (item.icon != null) ...[
                              Icon(item.icon, color: textColor, size: 18),
                              const SizedBox(width: 8),
                            ],
                            Expanded(
                              child: Text(
                                item.label,
                                style: TextStyle(
                                  color: textColor,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                            if (selected)
                              Icon(Icons.check_rounded, color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.9)),
                          ],
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}

LangOption? _findLangByCode(String code) {
  for (final lang in kLanguages) {
    if (lang.code.toLowerCase() == code.toLowerCase()) return lang;
  }
  return null;
}

LangOption? _findLangByName(String name) {
  for (final lang in kLanguages) {
    if (lang.name.toLowerCase() == name.toLowerCase()) return lang;
  }
  return null;
}

String? langCodeFromValue(String value) {
  if (value.isEmpty) return null;
  return _findLangByCode(value)?.code ?? _findLangByName(value)?.code;
}

String langLabel(String value) {
  if (value.isEmpty) return value;
  return _findLangByCode(value)?.name ?? _findLangByName(value)?.name ?? value;
}

String? normalizeLevelCode(String value) {
  final trimmed = value.trim();
  if (trimmed.isEmpty) return null;
  final upper = trimmed.toUpperCase();
  if (upper == "A" || upper == "B" || upper == "C") return upper;
  final lower = trimmed.toLowerCase();
  if (lower == "beginner") return "A";
  if (lower == "intermediate") return "B";
  if (lower == "advanced") return "C";
  return null;
}

String _levelLabelForValue(AppLocalizations l10n, String value) {
  final normalized = normalizeLevelCode(value);
  if (normalized == "A") return l10n.levelBeginner;
  if (normalized == "B") return l10n.levelIntermediate;
  if (normalized == "C") return l10n.levelAdvanced;
  return value;
}

String levelLabel(String value) {
  final normalized = normalizeLevelCode(value);
  if (normalized == "A") return "Beginner";
  if (normalized == "B") return "Intermediate";
  if (normalized == "C") return "Advanced";
  return value;
}

class _LiveDot extends StatelessWidget {
  final bool live;
  const _LiveDot({required this.live});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 12,
      height: 12,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: live ? const Color(0xFF2AFADF) : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.25),
        boxShadow: live
            ? [
                BoxShadow(
                  color: const Color(0xFF2AFADF).withValues(alpha: 0.25),
                  blurRadius: 8,
                  spreadRadius: 0,
                ),
              ]
            : null,
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
        mainAxisSize: MainAxisSize.min,
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

class _ActionButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final bool filled;

  const _ActionButton({
    required this.label,
    required this.onTap,
    required this.filled,
  });

  @override
  Widget build(BuildContext context) {
    final bg = filled ? T.neonGradient : null;

    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Container(
        height: 46,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          gradient: bg,
          color: filled ? null : Colors.black.withValues(alpha: 0.14),
          border: Border.all(color: Colors.white.withValues(alpha: 0.14)),
          boxShadow: filled
              ? [
                  BoxShadow(
                    color: T.neonA.withValues(alpha: 0.15),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Center(
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w900,
              fontSize: 14.5,
            ),
          ),
        ),
      ),
    );
  }
}
