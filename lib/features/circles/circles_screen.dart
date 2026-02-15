import 'package:flutter/material.dart';
import 'package:soma/l10n/gen/app_localizations.dart';
import '../../core/widgets/glass.dart';
import '../../core/widgets/neon_button.dart';
import '../social/friends_screen.dart';
import '../social/inbox_screen.dart';
import '../../data/social_repository.dart';
import '../../data/presence_repository.dart';
import '../../data/user_report_repository.dart';
import '../../data/settings_repository.dart';
import '../../data/profile_repository.dart';
import 'exchange_session_screen.dart';
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
  _CirclesHomeTab _selectedTab = _CirclesHomeTab.activeCircles;

  List<SoloCourse> _courses = [];
  int _coursesRevision = 0;
  bool _isOpeningExchangeCoursePicker = false;
  bool _hasAutoOpenedExchangeCoursePicker = false;
  late final Stream<List<Map<String, dynamic>>> _openCirclesStream;

  @override
  void initState() {
    super.initState();
    _openCirclesStream = circlesRepository.getOpenCircles();

    _coursesRevision = coursesRepository.revision;
    _loadCourses();
    // _cleanupGhostCircles(); // Disable heavy client-side cleanup
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

  List<_ExchangeUser> _buildExchangeUsers() {
    final users = <_ExchangeUser>[];
    var addedCurrentUser = false;
    for (final course in _courses) {
      final option = _CourseOption.fromCourse(course);
      if (option.fromName.isEmpty || option.toName.isEmpty) continue;
      if (!addedCurrentUser) {
        users.add(
        _ExchangeUser(
          userId: 'self',
          name: 'You',
          speaks: option.fromName,
          learns: option.toName,
            level: 'B1',
            compatibility: 100,
            isCurrentUser: true,
            isOnline: true,
          ),
        );
        addedCurrentUser = true;
      }

      users.add(
        _ExchangeUser(
          userId: 'sample-${course.id}',
          name: '${option.toName} learner',
          speaks: option.toName,
          learns: option.fromName,
          level: 'A2',
          compatibility: 92,
          isOnline: true,
        ),
      );
    }

    return users;
  }

  Future<void> _openExchangeCoursePicker() async {
    if (_isOpeningExchangeCoursePicker) return;
    _isOpeningExchangeCoursePicker = true;
    try {
      final created = await Navigator.push<SoloCourse>(
        context,
        MaterialPageRoute(builder: (_) => const AddCourseScreen()),
      );

      if (created != null) {
        await coursesRepository.addCustomCourse(created);
        await _loadCourses(selectCourseId: created.id);
      }

      if (mounted && created != null) {
        setState(() => _selectedTab = _CirclesHomeTab.exchangeChat);
      }
    } finally {
      _isOpeningExchangeCoursePicker = false;
    }
  }

  void _maybeAutoOpenCoursePickerForExchange() {
    if (_selectedTab != _CirclesHomeTab.exchangeChat) return;
    if (_courses.isNotEmpty || _isOpeningExchangeCoursePicker || _hasAutoOpenedExchangeCoursePicker) return;
    _hasAutoOpenedExchangeCoursePicker = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || _selectedTab != _CirclesHomeTab.exchangeChat) return;
      _openExchangeCoursePicker();
    });
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
    debugPrint("CirclesScreen.build called");
    final l10n = AppLocalizations.of(context);
    final isCompactWidth = MediaQuery.sizeOf(context).width < 380;
    _syncCoursesIfNeeded();
    _maybeAutoOpenCoursePickerForExchange();
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

              _CirclesTabSelector(
                selectedTab: _selectedTab,
                onTabChanged: (tab) => setState(() => _selectedTab = tab),
              ),

              const SizedBox(height: 14),

              if (_selectedTab == _CirclesHomeTab.activeCircles) ...[

              // Filters row
              Glass(
                radius: BorderRadius.circular(18),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                child: isCompactWidth
                    ? Column(
                        children: [
                          Row(
                            children: [
                              _FilterChip(
                                label: _courseLabel(courseOptions, l10n),
                                icon: Icons.translate_rounded,
                                onTap: () => _selectCourseFilter(courseOptions),
                                compact: true,
                              ),
                              const SizedBox(width: 10),
                              _FilterChip(
                                label: _modeLabel(l10n),
                                icon: Icons.grid_view_rounded,
                                onTap: _selectModeFilter,
                                compact: true,
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              _FilterChip(
                                label: _levelLabel(l10n),
                                icon: Icons.leaderboard_rounded,
                                onTap: _selectLevelFilter,
                                compact: true,
                              ),
                            ],
                          ),
                        ],
                      )
                    : Row(
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
                        try {
                          final data = filtered[i];
                          final circleId = data['id']?.toString() ?? '';
                          // Use counts directly from circle data
                          final playerCount = data['player_count'] as int? ?? 0;
                          final spectatorCount = data['spectator_count'] as int? ?? 0;
                          
                          final fromLabel = langLabel(data['from_lang']?.toString() ?? '?');
                          final toLabel = langLabel(data['to_lang']?.toString() ?? '?');
                          
                          final room = CircleRoom(
                            id: circleId,
                            title: data['name'] ?? l10n.circlesUnknownRoom,
                            fromLang: fromLabel,
                            toLang: toLabel,
                            level: data['level'] ?? 'A',
                            mode: data['mode'] ?? 'Vocabulary',
                            players: playerCount,
                            maxPlayers: data['max_players'] ?? 5,
                            spectators: spectatorCount,
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
                        } catch (e, stack) {
                          debugPrint("Error building circle card at index $i: $e\n$stack");
                          return const SizedBox.shrink();
                        }
                      },
                    );
                  }
                ),
              ),

              ] else ...[
                Expanded(
                  child: _courses.isEmpty
                      ? _ExchangeCourseRequired(onSelectCourse: _openExchangeCoursePicker)
                      : _LanguageExchangePanel(
                          users: _buildExchangeUsers(),
                          selectedCourse: selectedCourseOption,
                        ),
                ),
              ],

              // Create Circle CTA
              if (_selectedTab == _CirclesHomeTab.activeCircles) ...[
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
            ],
          ),
        ),
      ),
    );
  }
}

enum _CirclesHomeTab { activeCircles, exchangeChat }

class _CirclesTabSelector extends StatelessWidget {
  final _CirclesHomeTab selectedTab;
  final ValueChanged<_CirclesHomeTab> onTabChanged;

  const _CirclesTabSelector({
    required this.selectedTab,
    required this.onTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Glass(
      radius: BorderRadius.circular(16),
      padding: const EdgeInsets.all(6),
      child: Row(
        children: [
          Expanded(
            child: _TabPill(
              label: 'Active circles',
              selected: selectedTab == _CirclesHomeTab.activeCircles,
              onTap: () => onTabChanged(_CirclesHomeTab.activeCircles),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _TabPill(
              label: '2-language exchange',
              selected: selectedTab == _CirclesHomeTab.exchangeChat,
              onTap: () => onTabChanged(_CirclesHomeTab.exchangeChat),
            ),
          ),
        ],
      ),
    );
  }
}

class _TabPill extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _TabPill({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Material(
      color: selected ? AppTokens.accent : Colors.transparent,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: selected ? Colors.black : colors.onSurface.withValues(alpha: 0.88),
              fontWeight: FontWeight.w800,
              fontSize: 13,
            ),
          ),
        ),
      ),
    );
  }
}

class _ExchangeUser {
  final String userId;
  final String name;
  final String speaks;
  final String learns;
  final String level;
  final int compatibility;
  final bool isCurrentUser;
  final bool isOnline;

  const _ExchangeUser({
    required this.userId,
    required this.name,
    required this.speaks,
    required this.learns,
    required this.level,
    required this.compatibility,
    this.isCurrentUser = false,
    this.isOnline = true,
  });
}


class _ExchangeCourseRequired extends StatelessWidget {
  final Future<void> Function() onSelectCourse;

  const _ExchangeCourseRequired({required this.onSelectCourse});

  @override
  Widget build(BuildContext context) {
    return Glass(
      radius: BorderRadius.circular(16),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Select a course to start Social Exchange',
            style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
          ),
          const SizedBox(height: 8),
          Text(
            'We use your selected course to match people by speaks/learns language.',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.78),
            ),
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: NeonButton(
              label: 'Select course',
              onTap: onSelectCourse,
            ),
          ),
        ],
      ),
    );
  }
}

class _LanguageExchangePanel extends StatefulWidget {
  final List<_ExchangeUser> users;
  final _CourseOption? selectedCourse;

  const _LanguageExchangePanel({
    required this.users,
    required this.selectedCourse,
  });

  @override
  State<_LanguageExchangePanel> createState() => _LanguageExchangePanelState();
}

class _LanguageExchangePanelState extends State<_LanguageExchangePanel> {
  int _retryNonce = 0;

  List<_ExchangeUser> _buildPartnerUsersFromFriends(
    List<Map<String, dynamic>> friends,
    Map<String, bool> onlineMap,
    List<String> blockedIds,
    Map<String, Map<String, dynamic>> profileMap,
  ) {
    final base = widget.selectedCourse;
    if (base == null) return [];

    final result = <_ExchangeUser>[];
    for (var i = 0; i < friends.length; i++) {
      final friend = friends[i];
      final id = friend['id']?.toString() ?? '';
      if (id.isEmpty || blockedIds.contains(id)) continue;
      final username = friend['username']?.toString();
      final name = (username == null || username.trim().isEmpty) ? 'Learner ${i + 1}' : username;
      final profile = profileMap[id] ?? const <String, dynamic>{};
      final dailyGoal = (profile['daily_goal_minutes'] as num?)?.toInt() ?? 10;
      final totalXp = (profile['total_xp'] as num?)?.toInt() ?? 0;
      final level = totalXp >= 3000
          ? 'B2'
          : totalXp >= 1200
              ? 'B1'
              : 'A2';
      final compatibility = _compatibilityScore(
        online: onlineMap[id] ?? false,
        dailyGoalMinutes: dailyGoal,
        totalXp: totalXp,
      );
      result.add(
        _ExchangeUser(
          userId: id,
          name: name,
          speaks: base.toName,
          learns: base.fromName,
          level: level,
          compatibility: compatibility,
          isOnline: onlineMap[id] ?? false,
        ),
      );
    }
    return result;
  }

  int _compatibilityScore({
    required bool online,
    required int dailyGoalMinutes,
    required int totalXp,
  }) {
    var score = 70;
    if (online) score += 12;
    score += (dailyGoalMinutes ~/ 10).clamp(0, 8);
    score += (totalXp ~/ 800).clamp(0, 10);
    if (score > 99) return 99;
    if (score < 40) return 40;
    return score;
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final l10n = AppLocalizations.of(context);
    final myUser = widget.users.where((u) => u.isCurrentUser).toList();

    return Column(
      children: [
        Glass(
          radius: BorderRadius.circular(16),
          padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Two-Language Exchange Chat',
                style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
              ),
              const SizedBox(height: 6),
              Text(
                'Structured turn chat with language lock, helper tools, and a session summary.',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.82),
                ),
              ),
              if (myUser.isNotEmpty) ...[
                const SizedBox(height: 10),
                Text(
                  'You: ${myUser.first.speaks} → ${myUser.first.learns} (${myUser.first.level})',
                  style: textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w700),
                ),
              ],
              const SizedBox(height: 10),
              const _RoundFlowPreview(),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: const [
                  _ToolChip(label: 'Translate'),
                  _ToolChip(label: 'Suggest reply'),
                  _ToolChip(label: 'Correct my sentence'),
                  _ToolChip(label: '1 correction / round'),
                ],
              ),
              const SizedBox(height: 10),
              const _SessionProgressPreview(),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Expanded(
          child: FutureBuilder<Map<String, dynamic>>(
            future: settingsRepository.getSettings(),
            builder: (context, settingsSnapshot) {
              final blockedIds = ((settingsSnapshot.data?['blocked_user_ids'] as List?) ?? const [])
                  .map((e) => e.toString())
                  .toList();

              return StreamBuilder<List<Map<String, dynamic>>>(
                key: ValueKey(_retryNonce),
                stream: socialRepository.getFriendsStream(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator(color: Color(0xFF2AFADF)));
                  }

                  if (snapshot.hasError) {
                    return _ExchangeErrorState(
                      message: 'Could not load exchange partners.',
                      onRetry: () => setState(() => _retryNonce++),
                    );
                  }

                  final friends = snapshot.data ?? [];
                  if (friends.isEmpty) {
                    return _ExchangeNoPartnersState(onOpenFriends: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const FriendsScreen()),
                      );
                    });
                  }

                  final ids = friends.map((f) => f['id']?.toString() ?? '').where((id) => id.isNotEmpty).toList();

                  return FutureBuilder<(Map<String, bool>, Map<String, Map<String, dynamic>>)>(
                    future: () async {
                      final online = await presenceRepository.fetchOnlineStatuses(ids);
                      final profiles = await profileRepository.getProfilesByIds(ids);
                      final profileMap = <String, Map<String, dynamic>>{
                        for (final p in profiles) (p['id']?.toString() ?? ''): p,
                      };
                      return (online, profileMap);
                    }(),
                    builder: (context, dataSnapshot) {
                      if (dataSnapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator(color: Color(0xFF2AFADF)));
                      }

                      final payload = dataSnapshot.data;
                      final onlineMap = payload?.$1 ?? <String, bool>{};
                      final profileMap = payload?.$2 ?? <String, Map<String, dynamic>>{};
                      final partners = _buildPartnerUsersFromFriends(friends, onlineMap, blockedIds, profileMap);

                      if (partners.isEmpty) {
                        if (friends.isNotEmpty && blockedIds.length >= friends.length) {
                          return _ExchangeBlockedAllState(onOpenFriends: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const FriendsScreen()),
                            );
                          });
                        }
                        return _ExchangeNoCompatibleState(onOpenFriends: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const FriendsScreen()),
                          );
                        });
                      }

                      return ListView.separated(
                        physics: const BouncingScrollPhysics(),
                        itemCount: partners.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 10),
                        itemBuilder: (context, index) {
                          final user = partners[index];
                          return Glass(
                            radius: BorderRadius.circular(14),
                            padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 18,
                                      backgroundColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.7),
                                      child: Text(
                                        user.name.substring(0, 1).toUpperCase(),
                                        style: const TextStyle(fontWeight: FontWeight.w800, color: Colors.black),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            user.name,
                                            style: textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            'Speaks ${user.speaks} • Learns ${user.learns} • ${user.level}',
                                            style: textTheme.bodySmall?.copyWith(
                                              fontWeight: FontWeight.w600,
                                              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.72),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                                      decoration: BoxDecoration(
                                        color: user.isOnline ? const Color(0xFF2AFADF).withValues(alpha: 0.2) : Colors.grey.withValues(alpha: 0.2),
                                        borderRadius: BorderRadius.circular(999),
                                      ),
                                      child: Text(
                                        user.isOnline ? 'Active' : 'Offline',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          color: user.isOnline ? const Color(0xFF2AFADF) : Colors.grey,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  children: [
                                    _ToolChip(label: '${user.compatibility}% match'),
                                    const SizedBox(width: 8),
                                    const _ToolChip(label: 'Topic-safe rounds'),
                                    const Spacer(),
                                    SizedBox(
                                      width: 112,
                                      child: _ActionButton(
                                        label: l10n.start,
                                        filled: true,
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) => ExchangeSessionScreen(
                                                partnerUserId: user.userId,
                                                partnerName: user.name,
                                                myLearningLanguage: user.speaks,
                                                partnerLearningLanguage: user.learns,
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    TextButton.icon(
                                      onPressed: () => _showModerationDialog(context, user),
                                      icon: const Icon(Icons.report_gmailerrorred_rounded, size: 16),
                                      label: const Text('Report'),
                                    ),
                                    TextButton.icon(
                                      onPressed: () => _showBlockDialog(context, user),
                                      icon: const Icon(Icons.block_rounded, size: 16),
                                      label: const Text('Block'),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Future<void> _showModerationDialog(BuildContext context, _ExchangeUser user) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Report user?'),
        content: Text('We will review reports for @${user.name} to keep exchange safe.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Report')),
        ],
      ),
    );
    if (confirmed != true) return;
    if (user.userId.isEmpty) return;
    await userReportRepository.reportUser(user.userId);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('User reported')));
  }

  Future<void> _showBlockDialog(BuildContext context, _ExchangeUser user) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Block user?'),
        content: Text('You will no longer see @${user.name} in exchange suggestions.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Block')),
        ],
      ),
    );
    if (confirmed != true) return;
    if (user.userId.isEmpty) return;

    final settings = await settingsRepository.getSettings();
    final blockedIds = ((settings['blocked_user_ids'] as List?) ?? const []).map((e) => e.toString()).toList();
    if (!blockedIds.contains(user.userId)) blockedIds.add(user.userId);
    await settingsRepository.updateSetting('blocked_user_ids', blockedIds);
    await userReportRepository.reportUser(user.userId);

    if (!mounted) return;
    setState(() => _retryNonce++);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('User blocked and reported')));
  }
}

class _ExchangeErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ExchangeErrorState({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Glass(
      radius: BorderRadius.circular(14),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.wifi_off_rounded, size: 34),
          const SizedBox(height: 10),
          Text(message, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.w800)),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: _ActionButton(label: 'Retry', filled: true, onTap: onRetry),
          ),
        ],
      ),
    );
  }
}

class _RoundFlowPreview extends StatelessWidget {
  const _RoundFlowPreview();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        _RoundRuleRow(
          roundLabel: 'Round 1 • French',
          detail: 'Both users write in French. English is blocked.',
        ),
        SizedBox(height: 8),
        _RoundRuleRow(
          roundLabel: 'Round 2 • English',
          detail: 'Both users write in English. French is blocked.',
        ),
      ],
    );
  }
}

class _RoundRuleRow extends StatelessWidget {
  final String roundLabel;
  final String detail;

  const _RoundRuleRow({required this.roundLabel, required this.detail});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            roundLabel,
            style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 12.5),
          ),
          const SizedBox(height: 2),
          Text(
            detail,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 11.5,
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.75),
            ),
          ),
        ],
      ),
    );
  }
}

class _ToolChip extends StatelessWidget {
  final String label;
  const _ToolChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white.withValues(alpha: 0.14)),
        color: Colors.black.withValues(alpha: 0.14),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 11,
          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.9),
        ),
      ),
    );
  }
}

class _SessionProgressPreview extends StatelessWidget {
  const _SessionProgressPreview();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: AppTokens.accent.withValues(alpha: 0.12),
        border: Border.all(color: AppTokens.accent.withValues(alpha: 0.28)),
      ),
      child: const Text(
        'Session target: 10 rounds / 10 mins • Progress summary at end',
        style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12),
      ),
    );
  }
}


class _ExchangeNoCompatibleState extends StatelessWidget {
  final VoidCallback onOpenFriends;

  const _ExchangeNoCompatibleState({required this.onOpenFriends});

  @override
  Widget build(BuildContext context) {
    return _ExchangeEmptyBase(
      icon: Icons.filter_alt_off_rounded,
      title: 'No compatible partners right now',
      subtitle: 'Your friends are active, but none match this language direction yet.',
      ctaLabel: 'Open friends',
      onTap: onOpenFriends,
    );
  }
}

class _ExchangeBlockedAllState extends StatelessWidget {
  final VoidCallback onOpenFriends;

  const _ExchangeBlockedAllState({required this.onOpenFriends});

  @override
  Widget build(BuildContext context) {
    return _ExchangeEmptyBase(
      icon: Icons.block_rounded,
      title: 'All available partners are blocked',
      subtitle: 'Unblock someone from privacy settings or add new friends.',
      ctaLabel: 'Open friends',
      onTap: onOpenFriends,
    );
  }
}

class _ExchangeEmptyBase extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String ctaLabel;
  final VoidCallback onTap;

  const _ExchangeEmptyBase({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.ctaLabel,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Glass(
      radius: BorderRadius.circular(14),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 34),
          const SizedBox(height: 10),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 6),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.74),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: NeonButton(
              label: ctaLabel,
              onTap: onTap,
            ),
          ),
        ],
      ),
    );
  }
}

class _ExchangeNoPartnersState extends StatelessWidget {
  final VoidCallback onOpenFriends;

  const _ExchangeNoPartnersState({required this.onOpenFriends});

  @override
  Widget build(BuildContext context) {
    return Glass(
      radius: BorderRadius.circular(14),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.people_outline_rounded, size: 34),
          const SizedBox(height: 10),
          const Text(
            'No compatible active users yet',
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 6),
          Text(
            'Add friends or wait for learners with matching language goals.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.74),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: NeonButton(
              label: 'Open friends',
              onTap: onOpenFriends,
            ),
          ),
        ],
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

class CircleCard extends StatefulWidget {
  final CircleRoom room;
  final Future<void> Function() onJoin;

  const CircleCard({
    super.key,
    required this.room,
    required this.onJoin,
  });

  @override
  State<CircleCard> createState() => _CircleCardState();
}

class _CircleCardState extends State<CircleCard> {
  bool _isJoining = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final modeLabel = widget.room.mode.toLowerCase() == "vocabulary"
        ? l10n.soloModeVocabulary
        : widget.room.mode.toLowerCase() == "sentences"
            ? l10n.soloModeSentences
            : widget.room.mode;
    final levelLabel = _levelLabelForValue(l10n, widget.room.level);
    return Glass(
      radius: BorderRadius.circular(16),
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title row
          Row(
            children: [
              _LiveDot(live: widget.room.isLive),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  widget.room.title,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontSize: 15.5,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              Icon(Icons.chevron_right_rounded,
                  size: 20,
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withValues(alpha: 0.60)),
            ],
          ),

          const SizedBox(height: 6),

          // Language + mode line
          Text(
            l10n.circlesRoomLine(widget.room.fromLang, widget.room.toLang,
                modeLabel, levelLabel),
            style: TextStyle(
              color: Theme.of(context)
                  .colorScheme
                  .onSurface
                  .withValues(alpha: 0.70),
              fontWeight: FontWeight.w600,
              fontSize: 12.5,
            ),
          ),

          const SizedBox(height: 10),

          // Stats pills
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _Pill(
                  icon: Icons.people_rounded,
                  label: "${widget.room.players}/${widget.room.maxPlayers}"),
              _Pill(
                  icon: Icons.visibility_rounded,
                  label: "${widget.room.spectators}"),
              _Pill(
                  icon: Icons.help_rounded,
                  label: l10n.questionsShort(widget.room.questions)),
              _Pill(
                  icon: Icons.timer_rounded,
                  label: l10n.secondsShort(widget.room.timePerQ)),
            ],
          ),

          const SizedBox(height: 12),

          // Actions
          Row(
            children: [
              Expanded(
                child: _ActionButton(
                  label: l10n.join,
                  onTap: _isJoining
                      ? () {}
                      : () async {
                          setState(() => _isJoining = true);
                          try {
                            await widget.onJoin();
                          } finally {
                            if (mounted) setState(() => _isJoining = false);
                          }
                        },
                  filled: true,
                  isLoading: _isJoining,
                ),
              ),
            ],
          ),
        ],
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
  final bool compact;

  const _FilterChip({required this.label, required this.icon, required this.onTap, this.compact = false});

  @override
  Widget build(BuildContext context) {
    final content = InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Container(
        height: 40,
        padding: EdgeInsets.symmetric(horizontal: compact ? 8 : 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: Theme.of(context).brightness == Brightness.light
              ? Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.08)
              : Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
          border: Border.all(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.12)),
        ),
        child: Row(
          children: [
            Icon(icon, size: compact ? 16 : 18, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.85)),
            SizedBox(width: compact ? 6 : 8),
            Expanded(
              child: Text(
                label,
                maxLines: 1,
                softWrap: false,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.95),
                  fontWeight: FontWeight.w800,
                  fontSize: compact ? 12 : 12.5,
                ),
              ),
            ),
            if (!compact)
              Icon(Icons.expand_more_rounded, size: 18, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.65)),
          ],
        ),
      ),
    );

    return Expanded(
      child: content,
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
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        color: Colors.black.withValues(alpha: 0.16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.10)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Colors.white.withValues(alpha: 0.8)),
          const SizedBox(width: 5),
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.90),
              fontWeight: FontWeight.w700,
              fontSize: 12,
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
  final bool isLoading;

  const _ActionButton({
    required this.label,
    required this.onTap,
    required this.filled,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isLight = Theme.of(context).brightness == Brightness.light;

    final gradient = isLight
        ? LinearGradient(
            colors: [scheme.primary, scheme.tertiary],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          )
        : T.neonGradient;

    final bg = filled ? gradient : null;
    final shadowColor =
        isLight ? scheme.primary.withValues(alpha: 0.25) : T.neonA.withValues(alpha: 0.15);

    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Container(
        height: 38,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          gradient: bg,
          color: filled ? null : Colors.black.withValues(alpha: 0.14),
          border: Border.all(color: Colors.white.withValues(alpha: 0.14)),
          boxShadow: filled
              ? [
                  BoxShadow(
                    color: shadowColor,
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ]
              : null,
        ),
        child: Center(
          child: isLoading
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 13.5,
                  ),
                ),
        ),
      ),
    );
  }
}
