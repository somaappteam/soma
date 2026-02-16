import 'package:flutter/material.dart';
import 'package:soma/l10n/gen/app_localizations.dart';
import '../../core/widgets/glass.dart';
import '../../core/widgets/neon_button.dart';
import '../social/friends_screen.dart';
import '../social/inbox_screen.dart';
import '../../data/presence_repository.dart';
import '../../data/user_report_repository.dart';
import '../../data/settings_repository.dart';
import '../../data/profile_repository.dart';
import '../../data/exchange_analytics_repository.dart';
import '../social/dm_chat_screen.dart';
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
  late final Stream<List<Map<String, dynamic>>> _openCirclesStream;

  @override
  void initState() {
    super.initState();
    _openCirclesStream = circlesRepository.getOpenCircles();

    _coursesRevision = coursesRepository.revision;
    _loadCourses();
    // _cleanupGhostCircles(); // Disable heavy client-side cleanup
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
    debugPrint("CirclesScreen.build called");
    final l10n = AppLocalizations.of(context);
    final isCompactWidth = MediaQuery.sizeOf(context).width < 380;
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
                const Expanded(
                  child: _LanguageExchangePanel(),
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
      color: selected ? T.accent : Colors.transparent,
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

class _ExchangeLanguageOption {
  final String name;
  final String code;

  const _ExchangeLanguageOption({required this.name, required this.code});
}

class _LearnLanguagePref {
  final _ExchangeLanguageOption language;
  final String level;

  const _LearnLanguagePref({required this.language, required this.level});

  _LearnLanguagePref copyWith({String? level}) {
    return _LearnLanguagePref(language: language, level: level ?? this.level);
  }
}


class _LanguageExchangePanel extends StatefulWidget {
  const _LanguageExchangePanel();

  @override
  State<_LanguageExchangePanel> createState() => _LanguageExchangePanelState();
}

class _LanguageExchangePanelState extends State<_LanguageExchangePanel> {
  static const List<_ExchangeLanguageOption> _exchangeLanguages = [
    _ExchangeLanguageOption(name: 'Afar', code: 'aa'),
    _ExchangeLanguageOption(name: 'Afrikaans', code: 'af'),
    _ExchangeLanguageOption(name: 'Akan', code: 'ak'),
    _ExchangeLanguageOption(name: 'Albanian', code: 'sq'),
    _ExchangeLanguageOption(name: 'Amharic', code: 'am'),
    _ExchangeLanguageOption(name: 'Arabic (Egyptian)', code: 'ar-EG'),
    _ExchangeLanguageOption(name: 'Arabic (Gulf)', code: 'ar-AE'),
    _ExchangeLanguageOption(name: 'Arabic (Iraqi)', code: 'ar-IQ'),
    _ExchangeLanguageOption(name: 'Arabic (Levantine)', code: 'ar-LB'),
    _ExchangeLanguageOption(name: 'Arabic (Maghrebi)', code: 'ar-MA'),
    _ExchangeLanguageOption(name: 'Arabic (Modern Standard)', code: 'ar'),
    _ExchangeLanguageOption(name: 'Aramaic (Syriac)', code: 'syr'),
    _ExchangeLanguageOption(name: 'Armenian', code: 'hy'),
    _ExchangeLanguageOption(name: 'Assyrian (Syriac)', code: 'syr'),
    _ExchangeLanguageOption(name: 'Asturian', code: 'ast'),
    _ExchangeLanguageOption(name: 'Awadhi', code: 'awa'),
    _ExchangeLanguageOption(name: 'Aymara', code: 'ay'),
    _ExchangeLanguageOption(name: 'Azerbaijani', code: 'az'),
    _ExchangeLanguageOption(name: 'Balinese', code: 'ban'),
    _ExchangeLanguageOption(name: 'Balochi', code: 'bal'),
    _ExchangeLanguageOption(name: 'Bambara', code: 'bm'),
    _ExchangeLanguageOption(name: 'Basque', code: 'eu'),
    _ExchangeLanguageOption(name: 'Belarusian', code: 'be'),
    _ExchangeLanguageOption(name: 'Bemba', code: 'bem'),
    _ExchangeLanguageOption(name: 'Bengali', code: 'bn'),
    _ExchangeLanguageOption(name: 'Bhojpuri', code: 'bho'),
    _ExchangeLanguageOption(name: 'Bosnian', code: 'bs'),
    _ExchangeLanguageOption(name: 'Braj Bhasha', code: 'bra'),
    _ExchangeLanguageOption(name: 'Breton', code: 'br'),
    _ExchangeLanguageOption(name: 'Bulgarian', code: 'bg'),
    _ExchangeLanguageOption(name: 'Buginese', code: 'bug'),
    _ExchangeLanguageOption(name: 'Burmese (Myanmar)', code: 'my'),
    _ExchangeLanguageOption(name: 'Cantonese (Hong Kong)', code: 'zh-HK'),
    _ExchangeLanguageOption(name: 'Catalan', code: 'ca'),
    _ExchangeLanguageOption(name: 'Cebuano', code: 'ceb'),
    _ExchangeLanguageOption(name: 'Chamorro', code: 'ch'),
    _ExchangeLanguageOption(name: 'Chechen', code: 'ce'),
    _ExchangeLanguageOption(name: 'Chhattisgarhi', code: 'hne'),
    _ExchangeLanguageOption(name: 'Chichewa (Nyanja)', code: 'ny'),
    _ExchangeLanguageOption(name: 'Corsican', code: 'co'),
    _ExchangeLanguageOption(name: 'Croatian', code: 'hr'),
    _ExchangeLanguageOption(name: 'Czech', code: 'cs'),
    _ExchangeLanguageOption(name: 'Danish', code: 'da'),
    _ExchangeLanguageOption(name: 'Dari (Afghan Persian)', code: 'fa-AF'),
    _ExchangeLanguageOption(name: 'Dogri', code: 'doi'),
    _ExchangeLanguageOption(name: 'Dutch', code: 'nl'),
    _ExchangeLanguageOption(name: 'English', code: 'en'),
    _ExchangeLanguageOption(name: 'Esperanto', code: 'eo'),
    _ExchangeLanguageOption(name: 'Estonian', code: 'et'),
    _ExchangeLanguageOption(name: 'Ewe', code: 'ee'),
    _ExchangeLanguageOption(name: 'Fang', code: 'fan'),
    _ExchangeLanguageOption(name: 'Faroese', code: 'fo'),
    _ExchangeLanguageOption(name: 'Fijian', code: 'fj'),
    _ExchangeLanguageOption(name: 'Filipino / Tagalog', code: 'fil'),
    _ExchangeLanguageOption(name: 'Finnish', code: 'fi'),
    _ExchangeLanguageOption(name: 'French', code: 'fr'),
    _ExchangeLanguageOption(name: 'Frisian', code: 'fy'),
    _ExchangeLanguageOption(name: 'Fulani / Fulfulde', code: 'ff'),
    _ExchangeLanguageOption(name: 'Galician', code: 'gl'),
    _ExchangeLanguageOption(name: 'Gan Chinese', code: 'gan'),
    _ExchangeLanguageOption(name: 'Ganda (Luganda)', code: 'lg'),
    _ExchangeLanguageOption(name: 'Georgian', code: 'ka'),
    _ExchangeLanguageOption(name: 'German', code: 'de'),
    _ExchangeLanguageOption(name: 'Greek', code: 'el'),
    _ExchangeLanguageOption(name: 'Greenlandic (Kalaallisut)', code: 'kl'),
    _ExchangeLanguageOption(name: 'Guarani', code: 'gn'),
    _ExchangeLanguageOption(name: 'Gujarati', code: 'gu'),
    _ExchangeLanguageOption(name: 'Haitian Creole', code: 'ht'),
    _ExchangeLanguageOption(name: 'Hakka', code: 'hak'),
    _ExchangeLanguageOption(name: 'Hausa', code: 'ha'),
    _ExchangeLanguageOption(name: 'Hebrew', code: 'he'),
    _ExchangeLanguageOption(name: 'Hindi', code: 'hi'),
    _ExchangeLanguageOption(name: 'Hindko', code: 'hno'),
    _ExchangeLanguageOption(name: 'Hiri Motu', code: 'ho'),
    _ExchangeLanguageOption(name: 'Hungarian', code: 'hu'),
    _ExchangeLanguageOption(name: 'Iban', code: 'iba'),
    _ExchangeLanguageOption(name: 'Icelandic', code: 'is'),
    _ExchangeLanguageOption(name: 'Igbo', code: 'ig'),
    _ExchangeLanguageOption(name: 'Ilocano', code: 'ilo'),
    _ExchangeLanguageOption(name: 'Indonesian', code: 'id'),
    _ExchangeLanguageOption(name: 'Inuktitut', code: 'iu'),
    _ExchangeLanguageOption(name: 'Irish (Gaeilge)', code: 'ga'),
    _ExchangeLanguageOption(name: 'isiXhosa', code: 'xh'),
    _ExchangeLanguageOption(name: 'Italian', code: 'it'),
    _ExchangeLanguageOption(name: 'Japanese', code: 'ja'),
    _ExchangeLanguageOption(name: 'Javanese', code: 'jv'),
    _ExchangeLanguageOption(name: 'Kannada', code: 'kn'),
    _ExchangeLanguageOption(name: 'Kanuri', code: 'kr'),
    _ExchangeLanguageOption(name: 'Kashmiri', code: 'ks'),
    _ExchangeLanguageOption(name: 'Kazakh', code: 'kk'),
    _ExchangeLanguageOption(name: 'Khandeshi', code: 'khn'),
    _ExchangeLanguageOption(name: 'Khmer', code: 'km'),
    _ExchangeLanguageOption(name: 'Kikongo', code: 'kg'),
    _ExchangeLanguageOption(name: 'Kikuyu', code: 'ki'),
    _ExchangeLanguageOption(name: 'Kinyarwanda', code: 'rw'),
    _ExchangeLanguageOption(name: 'Kirundi', code: 'rn'),
    _ExchangeLanguageOption(name: 'Konkani', code: 'kok'),
    _ExchangeLanguageOption(name: 'Korean', code: 'ko'),
    _ExchangeLanguageOption(name: 'Kurdish', code: 'ku'),
    _ExchangeLanguageOption(name: 'Kurmanji (Northern Kurdish)', code: 'kmr'),
    _ExchangeLanguageOption(name: 'Ladin', code: 'lld'),
    _ExchangeLanguageOption(name: 'Lao', code: 'lo'),
    _ExchangeLanguageOption(name: 'Latin', code: 'la'),
    _ExchangeLanguageOption(name: 'Latvian', code: 'lv'),
    _ExchangeLanguageOption(name: 'Lingala', code: 'ln'),
    _ExchangeLanguageOption(name: 'Lithuanian', code: 'lt'),
    _ExchangeLanguageOption(name: 'Luxembourgish', code: 'lb'),
    _ExchangeLanguageOption(name: 'Luo', code: 'luo'),
    _ExchangeLanguageOption(name: 'Macedonian', code: 'mk'),
    _ExchangeLanguageOption(name: 'Magahi', code: 'mag'),
    _ExchangeLanguageOption(name: 'Malagasy', code: 'mg'),
    _ExchangeLanguageOption(name: 'Maithili', code: 'mai'),
    _ExchangeLanguageOption(name: 'Malay', code: 'ms'),
    _ExchangeLanguageOption(name: 'Malayalam', code: 'ml'),
    _ExchangeLanguageOption(name: 'Maltese', code: 'mt'),
    _ExchangeLanguageOption(name: 'Manx', code: 'gv'),
    _ExchangeLanguageOption(name: 'Mandarin (Simplified, China)', code: 'zh-CN'),
    _ExchangeLanguageOption(name: 'Mandarin (Traditional, Taiwan)', code: 'zh-TW'),
    _ExchangeLanguageOption(name: 'Marathi', code: 'mr'),
    _ExchangeLanguageOption(name: 'Marshallese', code: 'mh'),
    _ExchangeLanguageOption(name: 'Māori', code: 'mi'),
    _ExchangeLanguageOption(name: 'Mayan (Macro)', code: 'myn'),
    _ExchangeLanguageOption(name: 'Meitei / Manipuri', code: 'mni'),
    _ExchangeLanguageOption(name: 'Min Nan / Hokkien', code: 'nan'),
    _ExchangeLanguageOption(name: 'Mixtec (Macro)', code: 'mix'),
    _ExchangeLanguageOption(name: 'Mongolian', code: 'mn'),
    _ExchangeLanguageOption(name: 'Montenegrin', code: 'sr-ME'),
    _ExchangeLanguageOption(name: 'Nahuatl', code: 'nah'),
    _ExchangeLanguageOption(name: 'Navajo', code: 'nv'),
    _ExchangeLanguageOption(name: 'Ndebele (Southern)', code: 'nd'),
    _ExchangeLanguageOption(name: 'Nepali', code: 'ne'),
    _ExchangeLanguageOption(name: 'Northern Sami', code: 'se'),
    _ExchangeLanguageOption(name: 'Norwegian Bokmål', code: 'nb-NO'),
    _ExchangeLanguageOption(name: 'Norwegian Nynorsk', code: 'nn-NO'),
    _ExchangeLanguageOption(name: 'Occitan', code: 'oc'),
    _ExchangeLanguageOption(name: 'Odia (Oriya)', code: 'or'),
    _ExchangeLanguageOption(name: 'Oromo', code: 'om'),
    _ExchangeLanguageOption(name: 'Palauan', code: 'pau'),
    _ExchangeLanguageOption(name: 'Pashto', code: 'ps'),
    _ExchangeLanguageOption(name: 'Persian / Farsi', code: 'fa'),
    _ExchangeLanguageOption(name: 'Portuguese (Brazil)', code: 'pt-BR'),
    _ExchangeLanguageOption(name: 'Portuguese (Portugal)', code: 'pt-PT'),
    _ExchangeLanguageOption(name: 'Punjabi', code: 'pa'),
    _ExchangeLanguageOption(name: 'Quechua', code: 'qu'),
    _ExchangeLanguageOption(name: 'Rajasthani', code: 'raj'),
    _ExchangeLanguageOption(name: 'Romanian', code: 'ro'),
    _ExchangeLanguageOption(name: 'Romansh', code: 'rm'),
    _ExchangeLanguageOption(name: 'Russian', code: 'ru'),
    _ExchangeLanguageOption(name: 'Samoan', code: 'sm'),
    _ExchangeLanguageOption(name: 'Sango', code: 'sg'),
    _ExchangeLanguageOption(name: 'Sanskrit', code: 'sa'),
    _ExchangeLanguageOption(name: 'Santhali', code: 'sat'),
    _ExchangeLanguageOption(name: 'Sardinian', code: 'sc'),
    _ExchangeLanguageOption(name: 'Scottish Gaelic', code: 'gd'),
    _ExchangeLanguageOption(name: 'Serbian', code: 'sr'),
    _ExchangeLanguageOption(name: 'Sesotho', code: 'st'),
    _ExchangeLanguageOption(name: 'Setswana', code: 'tn'),
    _ExchangeLanguageOption(name: 'Shan', code: 'shn'),
    _ExchangeLanguageOption(name: 'Shona', code: 'sn'),
    _ExchangeLanguageOption(name: 'Sicilian', code: 'scn'),
    _ExchangeLanguageOption(name: 'Sindhi', code: 'sd'),
    _ExchangeLanguageOption(name: 'Sinhala', code: 'si'),
    _ExchangeLanguageOption(name: 'Sidamo', code: 'sid'),
    _ExchangeLanguageOption(name: 'Slovak', code: 'sk'),
    _ExchangeLanguageOption(name: 'Slovenian', code: 'sl'),
    _ExchangeLanguageOption(name: 'Somali', code: 'so'),
    _ExchangeLanguageOption(name: 'Songhai', code: 'son'),
    _ExchangeLanguageOption(name: 'Sorani (Central Kurdish)', code: 'ckb'),
    _ExchangeLanguageOption(name: 'Spanish', code: 'es'),
    _ExchangeLanguageOption(name: 'Sukuma', code: 'suk'),
    _ExchangeLanguageOption(name: 'Sundanese', code: 'su'),
    _ExchangeLanguageOption(name: 'Swahili', code: 'sw'),
    _ExchangeLanguageOption(name: 'Swedish', code: 'sv'),
    _ExchangeLanguageOption(name: 'Tajik', code: 'tg'),
    _ExchangeLanguageOption(name: 'Tamil', code: 'ta'),
    _ExchangeLanguageOption(name: 'Tatar', code: 'tt'),
    _ExchangeLanguageOption(name: 'Telugu', code: 'te'),
    _ExchangeLanguageOption(name: 'Thai', code: 'th'),
    _ExchangeLanguageOption(name: 'Tibetan', code: 'bo'),
    _ExchangeLanguageOption(name: 'Tigrinya', code: 'ti'),
    _ExchangeLanguageOption(name: 'Tok Pisin', code: 'tpi'),
    _ExchangeLanguageOption(name: 'Tongan', code: 'to'),
    _ExchangeLanguageOption(name: 'Tshivenda', code: 've'),
    _ExchangeLanguageOption(name: 'Tulu', code: 'tcy'),
    _ExchangeLanguageOption(name: 'Turkish', code: 'tr'),
    _ExchangeLanguageOption(name: 'Twi', code: 'twi'),
    _ExchangeLanguageOption(name: 'Ukrainian', code: 'uk'),
    _ExchangeLanguageOption(name: 'Urdu', code: 'ur'),
    _ExchangeLanguageOption(name: 'Uyghur', code: 'ug'),
    _ExchangeLanguageOption(name: 'Uzbek', code: 'uz'),
    _ExchangeLanguageOption(name: 'Venetian', code: 'vec'),
    _ExchangeLanguageOption(name: 'Vietnamese', code: 'vi'),
    _ExchangeLanguageOption(name: 'Walloon', code: 'wa'),
    _ExchangeLanguageOption(name: 'Welsh', code: 'cy'),
    _ExchangeLanguageOption(name: 'Wolof', code: 'wo'),
    _ExchangeLanguageOption(name: 'Wu / Shanghainese', code: 'wuu'),
    _ExchangeLanguageOption(name: 'Xiang Chinese', code: 'hsn'),
    _ExchangeLanguageOption(name: 'Xitsonga', code: 'ts'),
    _ExchangeLanguageOption(name: 'Yiddish', code: 'yi'),
    _ExchangeLanguageOption(name: 'Yoruba', code: 'yo'),
    _ExchangeLanguageOption(name: 'Zapotec', code: 'zap'),
    _ExchangeLanguageOption(name: 'Zulu', code: 'zu'),
    _ExchangeLanguageOption(name: 'Tamazight (Standard Moroccan Berber)', code: 'zgh'),
  ];

  int _retryNonce = 0;
  final List<Map<String, dynamic>> _extraProfiles = [];
  DateTime? _cursorBefore;
  bool _loadingMore = false;
  bool _didPromptExchangeSetup = false;
  List<String> _speaksLanguageCodes = const [];
  List<_LearnLanguagePref> _learnLanguagePrefs = const [];

  @override
  void initState() {
    super.initState();
    _loadExchangeLanguageSettings();
  }

  _ExchangeLanguageOption _languageByCode(String code) {
    for (final lang in _exchangeLanguages) {
      if (lang.code.toLowerCase() == code.toLowerCase()) return lang;
    }
    return _exchangeLanguages.first;
  }

  _ExchangeLanguageOption? _languageByLegacyName(String name) {
    for (final lang in _exchangeLanguages) {
      if (lang.name.toLowerCase() == name.toLowerCase()) return lang;
    }
    return null;
  }

  static const List<String> _learnLevels = ['Beginner', 'Intermediate', 'Advanced'];

  List<_ExchangeLanguageOption> get _speaksLanguages =>
      _speaksLanguageCodes.map(_languageByCode).toList();

  bool get _exchangePrefsReady =>
      _speaksLanguageCodes.isNotEmpty && _learnLanguagePrefs.isNotEmpty;

  String _speaksSummary() => _speaksLanguages.isEmpty ? 'Not set' : _speaksLanguages.map((e) => e.name).join(', ');

  String _learnsSummary() =>
      _learnLanguagePrefs.isEmpty ? 'Not set' : _learnLanguagePrefs.map((e) => '${e.language.name} (${e.level})').join(', ');

  Future<void> _loadExchangeLanguageSettings() async {
    final settings = await settingsRepository.getSettings();
    if (!mounted) return;
    final speaksCodesRaw = (settings['exchange_speaks_languages'] as List?)?.map((e) => e.toString()).toList();
    final learnsRaw = settings['exchange_learns_languages'];
    final parsedLearns = <_LearnLanguagePref>[];
    if (learnsRaw is List) {
      for (final item in learnsRaw) {
        if (item is! Map) continue;
        final map = Map<String, dynamic>.from(item);
        final code = map['code']?.toString();
        final level = map['level']?.toString();
        if (code == null || !_learnLevels.contains(level)) continue;
        final lang = _languageByCode(code);
        parsedLearns.add(_LearnLanguagePref(language: lang, level: level!));
      }
    }

    final speaksCode = settings['exchange_speaks_language']?.toString();
    final learnsCode = settings['exchange_learns_language']?.toString();
    final speaksLegacyName = settings['exchange_speaks_language_name']?.toString();
    final learnsLegacyName = settings['exchange_learns_language_name']?.toString();
    setState(() {
      if (speaksCodesRaw != null && speaksCodesRaw.isNotEmpty) {
        _speaksLanguageCodes = speaksCodesRaw
            .where((c) => _exchangeLanguages.any((l) => l.code.toLowerCase() == c.toLowerCase()))
            .take(3)
            .toList();
      } else if (speaksCode != null && _exchangeLanguages.any((l) => l.code.toLowerCase() == speaksCode.toLowerCase())) {
        _speaksLanguageCodes = [speaksCode];
      } else if (speaksLegacyName != null) {
        final legacy = _languageByLegacyName(speaksLegacyName);
        if (legacy != null) _speaksLanguageCodes = [legacy.code];
      }

      if (parsedLearns.isNotEmpty) {
        _learnLanguagePrefs = parsedLearns.take(5).toList();
      } else if (learnsCode != null && _exchangeLanguages.any((l) => l.code.toLowerCase() == learnsCode.toLowerCase())) {
        _learnLanguagePrefs = [
          _LearnLanguagePref(language: _languageByCode(learnsCode), level: 'Beginner'),
        ];
      } else if (learnsLegacyName != null) {
        final legacy = _languageByLegacyName(learnsLegacyName);
        if (legacy != null) {
          _learnLanguagePrefs = [_LearnLanguagePref(language: legacy, level: 'Beginner')];
        }
      }
    });

    if (!_didPromptExchangeSetup && !_exchangePrefsReady) {
      _didPromptExchangeSetup = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        _editExchangePrefs();
      });
    }
  }

  Future<void> _saveExchangePrefs() async {
    await settingsRepository.updateSetting('exchange_speaks_languages', _speaksLanguageCodes);
    await settingsRepository.updateSetting(
      'exchange_speaks_languages_names',
      [for (final c in _speaksLanguageCodes) _languageByCode(c).name],
    );
    await settingsRepository.updateSetting(
      'exchange_learns_languages',
      [
        for (final l in _learnLanguagePrefs)
          {
            'code': l.language.code,
            'name': l.language.name,
            'level': l.level,
          },
      ],
    );

    if (_speaksLanguageCodes.isNotEmpty) {
      final first = _languageByCode(_speaksLanguageCodes.first);
      await settingsRepository.updateSetting('exchange_speaks_language', first.code);
      await settingsRepository.updateSetting('exchange_speaks_language_name', first.name);
    }
    if (_learnLanguagePrefs.isNotEmpty) {
      final first = _learnLanguagePrefs.first.language;
      await settingsRepository.updateSetting('exchange_learns_language', first.code);
      await settingsRepository.updateSetting('exchange_learns_language_name', first.name);
    }
  }

  Future<List<String>?> _pickMultiLanguages({
    required String title,
    required List<String> initialCodes,
    required int max,
  }) async {
    final selected = await showModalBottomSheet<List<String>>(
      context: context,
      showDragHandle: true,
      builder: (context) {
        final local = [...initialCodes];
        return StatefulBuilder(
          builder: (context, setModalState) => SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text('$title (${local.length}/$max)', style: const TextStyle(fontWeight: FontWeight.w900)),
                      ),
                      TextButton(onPressed: () => Navigator.pop(context, local), child: const Text('Done')),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView(
                    children: [
                      for (final lang in _exchangeLanguages)
                        CheckboxListTile(
                          value: local.contains(lang.code),
                          title: Text(lang.name),
                          subtitle: Text(lang.code),
                          onChanged: (v) {
                            setModalState(() {
                              if (v == true) {
                                if (local.length >= max || local.contains(lang.code)) return;
                                local.add(lang.code);
                              } else {
                                local.remove(lang.code);
                              }
                            });
                          },
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
    return selected;
  }

  Future<void> _editExchangePrefs() async {
    final speaks = await _pickMultiLanguages(
      title: 'Languages you speak',
      initialCodes: _speaksLanguageCodes,
      max: 3,
    );
    if (!mounted || speaks == null || speaks.isEmpty) return;

    final learnsCodes = await _pickMultiLanguages(
      title: 'Languages you want to learn',
      initialCodes: _learnLanguagePrefs.map((e) => e.language.code).toList(),
      max: 5,
    );
    if (!mounted || learnsCodes == null || learnsCodes.isEmpty) return;

    final nextLearns = <_LearnLanguagePref>[];
    for (final code in learnsCodes) {
      final existing = _learnLanguagePrefs.where((e) => e.language.code == code).toList();
      if (existing.isNotEmpty) {
        nextLearns.add(existing.first);
      } else {
        nextLearns.add(_LearnLanguagePref(language: _languageByCode(code), level: 'Beginner'));
      }
    }

    if (!mounted) return;
    setState(() {
      _speaksLanguageCodes = speaks.take(3).toList();
      _learnLanguagePrefs = nextLearns.take(5).toList();
    });
    await _saveExchangePrefs();
  }

  Future<void> _changeLearnLevel(int index) async {
    final selected = await showModalBottomSheet<String>(
      context: context,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            for (final level in _learnLevels)
              ListTile(title: Text(level), onTap: () => Navigator.pop(context, level)),
          ],
        ),
      ),
    );
    if (!mounted || selected == null) return;
    setState(() {
      _learnLanguagePrefs = [
        for (var i = 0; i < _learnLanguagePrefs.length; i++)
          i == index ? _learnLanguagePrefs[i].copyWith(level: selected) : _learnLanguagePrefs[i],
      ];
    });
    await _saveExchangePrefs();
  }

  Set<String> _toLangSet(dynamic raw) {
    if (raw is List) {
      return raw.map((e) => e.toString().trim().toLowerCase()).where((e) => e.isNotEmpty).toSet();
    }
    final value = raw?.toString() ?? '';
    if (value.trim().isEmpty) return <String>{};
    return value
        .split(RegExp(r'[,;/|]'))
        .map((e) => e.trim().toLowerCase())
        .where((e) => e.isNotEmpty)
        .toSet();
  }


  DateTime _updatedAtOf(Map<String, dynamic> row) {
    return DateTime.tryParse(row['updated_at']?.toString() ?? '') ?? DateTime.fromMillisecondsSinceEpoch(0);
  }

  int _parseUtcOffsetHours(String timezone) {
    final match = RegExp(r'([+-])(\d{1,2})').firstMatch(timezone);
    if (match == null) return DateTime.now().timeZoneOffset.inHours;
    final sign = match.group(1) == '-' ? -1 : 1;
    final hours = int.tryParse(match.group(2) ?? '0') ?? 0;
    return sign * hours;
  }

  String _firstLangLabel(Set<String> values, String fallback) {
    if (values.isEmpty) return fallback;
    final first = values.first;
    return first.isEmpty ? fallback : '${first[0].toUpperCase()}${first.substring(1)}';
  }

  bool _matchesDirection(Map<String, dynamic> profile) {
    final native = _toLangSet(profile['native_languages']);
    if (native.isEmpty) return true;
    final learnsSet = <String>{
      for (final l in _learnLanguagePrefs) ...{l.language.name.toLowerCase(), l.language.code.toLowerCase()},
    };
    return native.any(learnsSet.contains);
  }

  String _levelFromXp(int totalXp) {
    if (totalXp >= 6000) return 'C1';
    if (totalXp >= 3000) return 'B2';
    if (totalXp >= 1200) return 'B1';
    return 'A2';
  }

  int _trustScore(Map<String, dynamic> profile) {
    final completed = (profile['completed_exchange_sessions'] as num?)?.toInt() ?? 0;
    final reports = (profile['report_count'] as num?)?.toInt() ?? 0;
    var trust = 60 + (completed ~/ 3);
    trust -= (reports * 8);
    return trust.clamp(15, 100);
  }

  int _compatibilityScore({
    required bool online,
    required int dailyGoalMinutes,
    required int totalXp,
    required int trust,
    required String timezone,
  }) {
    var score = 58;
    if (online) score += 14;
    score += (dailyGoalMinutes ~/ 10).clamp(0, 8);
    score += (totalXp ~/ 900).clamp(0, 10);
    score += (trust ~/ 10).clamp(0, 10);
    final localOffset = DateTime.now().timeZoneOffset.inHours;
    final partnerOffset = _parseUtcOffsetHours(timezone);
    final diff = (localOffset - partnerOffset).abs();
    if (diff <= 2) score += 6;
    if (diff <= 5) score += 3;
    return score.clamp(30, 99);
  }

  List<_ExchangeUser> _buildPartnerUsersFromProfiles(
    List<Map<String, dynamic>> profiles,
    Map<String, bool> onlineMap,
    List<String> blockedIds,
  ) {
    final result = <_ExchangeUser>[];
    for (var i = 0; i < profiles.length; i++) {
      final profile = profiles[i];
      final id = profile['id']?.toString() ?? '';
      if (id.isEmpty || blockedIds.contains(id)) continue;

      final rawSettings = profile['settings'];
      final settings = rawSettings is Map ? Map<String, dynamic>.from(rawSettings) : const <String, dynamic>{};
      final showOnlineStatus = settings['show_online_status'] != false;
      final exchangeActive = settings['exchange_active'] == true;
      if (!showOnlineStatus || !exchangeActive) continue;
      if (!_matchesDirection(profile)) continue;

      final isOnline = onlineMap[id] ?? false;
      if (!isOnline) continue;

      final username = profile['username']?.toString();
      final name = (username == null || username.trim().isEmpty) ? 'Learner ${i + 1}' : username;
      final dailyGoal = (profile['daily_goal_minutes'] as num?)?.toInt() ?? 10;
      final totalXp = (profile['total_xp'] as num?)?.toInt() ?? 0;
      final level = _levelFromXp(totalXp);
      final trust = _trustScore(profile);
      if (trust < 25) continue;
      final timezone = profile['timezone']?.toString() ?? '';
      final compatibility = _compatibilityScore(
        online: isOnline,
        dailyGoalMinutes: dailyGoal,
        totalXp: totalXp,
        trust: trust,
        timezone: timezone,
      );

      final native = _toLangSet(profile['native_languages']);
      final learning = _toLangSet(profile['learning_languages']);
      final fallbackSpeak = _learnLanguagePrefs.isNotEmpty ? _learnLanguagePrefs.first.language.name : 'Unknown';
      final fallbackLearn = _speaksLanguages.isNotEmpty ? _speaksLanguages.first.name : 'Unknown';
      final speaksLabel = _firstLangLabel(native, fallbackSpeak);
      final learnsLabel = _firstLangLabel(learning, fallbackLearn);

      result.add(
        _ExchangeUser(
          userId: id,
          name: name,
          speaks: speaksLabel,
          learns: learnsLabel,
          level: level,
          compatibility: compatibility,
          isOnline: isOnline,
        ),
      );
    }

    result.sort((a, b) {
      final onlineCmp = (b.isOnline ? 1 : 0).compareTo(a.isOnline ? 1 : 0);
      if (onlineCmp != 0) return onlineCmp;
      return b.compatibility.compareTo(a.compatibility);
    });

    return result;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;

    return Column(
      children: [
        Glass(
          radius: BorderRadius.circular(18),
          padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: T.accent.withValues(alpha: 0.16),
                    ),
                    child: Icon(Icons.auto_awesome_rounded,
                        size: 18,
                        color: Theme.of(context).colorScheme.onSurface),
                  ),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Text(
                      '2-Language Exchange',
                      style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
                    ),
                  ),
                  _ToolChip(label: 'Language exchange only'),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                'Choose exchange languages used only for partner chats (separate from course languages).',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.74),
                ),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _ToolChip(label: 'Speaks (max 3): ${_speaksSummary()}'),
                  _ToolChip(label: 'Learns (max 5): ${_learnsSummary()}'),
                  _FilterActionChip(
                    label: 'Edit exchange languages',
                    icon: Icons.tune_rounded,
                    onTap: _editExchangePrefs,
                  ),
                  const _ModernBadge(icon: Icons.bolt_rounded, label: 'Fast rounds'),
                  const _ModernBadge(icon: Icons.insights_rounded, label: 'Session summary'),
                ],
              ),
              const SizedBox(height: 10),
              if (_exchangePrefsReady)
                _RoundFlowPreview(
                  fromLang: _speaksLanguages.first.name,
                  toLang: _learnLanguagePrefs.first.language.name,
                ),
              const SizedBox(height: 8),
              _SpeakingRoomsPremiumCard(onTap: _showSpeakingRoomsPreview),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Expanded(
          child: FutureBuilder<Map<String, dynamic>>(
            future: settingsRepository.getSettings(),
            builder: (context, settingsSnapshot) {
              final settingsData = settingsSnapshot.data ?? const <String, dynamic>{};
              final blockedIds = ((settingsData['blocked_user_ids'] as List?) ?? const [])
                  .map((e) => e.toString())
                  .toList();

              return StreamBuilder<List<Map<String, dynamic>>>(
                stream: profileRepository.streamExchangeCandidateProfiles(limit: 120),
                builder: (context, liveSnapshot) {
                  if (liveSnapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator(color: Color(0xFF2AFADF)));
                  }
                  if (liveSnapshot.hasError) {
                    return _ExchangeErrorState(
                      message: 'Unable to load active exchange users right now.',
                      onRetry: () => setState(() => _retryNonce++),
                    );
                  }

                  final liveProfiles = liveSnapshot.data ?? <Map<String, dynamic>>[];
                  final liveIds = liveProfiles.map((e) => e['id']?.toString() ?? '').toSet();
                  final mergedProfiles = <Map<String, dynamic>>[
                    ...liveProfiles,
                    ..._extraProfiles.where((e) => !liveIds.contains(e['id']?.toString() ?? '')),
                  ]..sort((a, b) => _updatedAtOf(b).compareTo(_updatedAtOf(a)));

                  if (mergedProfiles.isNotEmpty) {
                    _cursorBefore = _updatedAtOf(mergedProfiles.last);
                  }

                  final ids = mergedProfiles
                      .map((f) => f['id']?.toString() ?? '')
                      .where((id) => id.isNotEmpty)
                      .toList();

                  return StreamBuilder<Map<String, bool>>(
                    stream: presenceRepository.streamMultipleOnlineStatuses(ids),
                    builder: (context, dataSnapshot) {
                      if (dataSnapshot.connectionState == ConnectionState.waiting && !dataSnapshot.hasData) {
                        return const Center(child: CircularProgressIndicator(color: Color(0xFF2AFADF)));
                      }

                      final onlineMap = dataSnapshot.data ?? <String, bool>{};
                      final partners = _buildPartnerUsersFromProfiles(mergedProfiles, onlineMap, blockedIds);
                      if (partners.isNotEmpty) {
                        exchangeAnalyticsRepository.track(
                          'exchange_discovery_results',
                          metadata: {
                            'visible_users': partners.length,
                            'active_only': true,
                          },
                        );
                      }

                      if (!_exchangePrefsReady) {
                        return _ExchangePrefsRequiredCard(
                          onSetup: _editExchangePrefs,
                        );
                      }

                      if (partners.isEmpty) {
                        return _ExchangeNoCompatibleState(
                          onOpenInbox: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const InboxScreen()),
                          ),
                        );
                      }

                      return Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Glass(
                              radius: BorderRadius.circular(16),
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                              child: Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: [
                                  _FilterActionChip(
                                    label: _learnLanguagePrefs.map((e) => e.language.name).join(', '),
                                    icon: Icons.translate_rounded,
                                    onTap: _editExchangePrefs,
                                  ),
                                  _FilterActionChip(
                                    label: 'Speaks: ${_speaksSummary()}',
                                    icon: Icons.record_voice_over_rounded,
                                    onTap: _editExchangePrefs,
                                  ),
                                  _FilterActionChip(
                                    label: 'Open inbox',
                                    icon: Icons.inbox_rounded,
                                    onTap: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (_) => const InboxScreen()),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          if (_learnLanguagePrefs.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: Glass(
                                radius: BorderRadius.circular(14),
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                child: Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  children: [
                                    for (var i = 0; i < _learnLanguagePrefs.length; i++)
                                      _FilterActionChip(
                                        label: '${_learnLanguagePrefs[i].language.name}: ${_learnLanguagePrefs[i].level}',
                                        icon: Icons.school_rounded,
                                        onTap: () => _changeLearnLevel(i),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          Expanded(
                            child: ListView.separated(
                              physics: const BouncingScrollPhysics(),
                              itemCount: partners.length + 1,
                              separatorBuilder: (_, __) => const SizedBox(height: 10),
                              itemBuilder: (context, index) {
                                if (index == partners.length) {
                                  return Center(
                                    child: TextButton.icon(
                                      onPressed: _loadingMore || _cursorBefore == null
                                          ? null
                                          : () async {
                                              setState(() => _loadingMore = true);
                                              try {
                                                final more = await profileRepository.getExchangeCandidateProfilesBefore(
                                                  before: _cursorBefore!,
                                                  limit: 80,
                                                );
                                                if (more.isNotEmpty) {
                                                  setState(() {
                                                    _extraProfiles.addAll(more);
                                                    _cursorBefore = _updatedAtOf(more.last);
                                                  });
                                                }
                                              } finally {
                                                if (mounted) setState(() => _loadingMore = false);
                                              }
                                            },
                                      icon: const Icon(Icons.expand_more_rounded),
                                      label: Text(_loadingMore ? 'Loading...' : 'Load more users'),
                                    ),
                                  );
                                }
                                final user = partners[index];
                                return _buildExchangeUserCard(context, textTheme, l10n, user);
                              },
                            ),
                          ),
                        ],
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

  Future<void> _openExchangeGoalSheet(_ExchangeUser user) async {
    final goal = await showModalBottomSheet<String>(
      context: context,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            for (final g in const ['Fluency', 'Grammar', 'Speaking confidence'])
              ListTile(title: Text(g), onTap: () => Navigator.pop(context, g)),
          ],
        ),
      ),
    );
    if (!mounted || goal == null) return;
    final duration = await showModalBottomSheet<int>(
      context: context,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [10, 20, 30]
              .map((d) => ListTile(title: Text('$d minutes'), onTap: () => Navigator.pop(context, d)))
              .toList(),
        ),
      ),
    );
    if (!mounted || duration == null) return;
    final focus = await showModalBottomSheet<String>(
      context: context,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            for (final f in const ['Past tense', 'Conditionals', 'Question forms'])
              ListTile(title: Text(f), onTap: () => Navigator.pop(context, f)),
          ],
        ),
      ),
    );
    if (!mounted || focus == null) return;

    final plan = 'Session goal: $goal • Duration: ${duration}m • Grammar focus: $focus';
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DmChatScreen(
          meId: profileRepository.currentUserId ?? 'me',
          otherId: user.userId,
          otherName: user.name,
          initialDraftText: plan,
        ),
      ),
    );
  }

  Future<void> _showSpeakingRoomsPreview() async {
    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (context) {
        final scheme = Theme.of(context).colorScheme;
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 6, 16, 18),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          T.accent.withValues(alpha: 0.24),
                          scheme.primary.withValues(alpha: 0.18),
                        ],
                      ),
                      border: Border.all(color: scheme.onSurface.withValues(alpha: 0.12)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 34,
                              height: 34,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: scheme.surface.withValues(alpha: 0.52),
                              ),
                              child: Icon(Icons.groups_rounded, color: scheme.onSurface),
                            ),
                            const SizedBox(width: 10),
                            const Expanded(
                              child: Text(
                                'Speaking Rooms Premium',
                                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
                              ),
                            ),
                            const _ToolChip(label: 'Coming soon'),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'An immersive voice-first room experience designed for daily speaking practice, coaching insights, and premium group challenges.',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: scheme.onSurface.withValues(alpha: 0.78),
                            height: 1.35,
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            _ModernBadge(icon: Icons.timer_rounded, label: '60/90/120s rounds'),
                            _ModernBadge(icon: Icons.multitrack_audio_rounded, label: 'Realtime pronunciation hints'),
                            _ModernBadge(icon: Icons.workspace_premium_rounded, label: 'Ranked challenge packs'),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                  const _SpeakingRoomFeatureTile(
                    icon: Icons.mic_external_on_rounded,
                    title: 'Smart speaking rounds',
                    subtitle: 'Auto-rotating turns with host controls, participation balance, and gentle pace guidance.',
                  ),
                  const SizedBox(height: 8),
                  const _SpeakingRoomFeatureTile(
                    icon: Icons.equalizer_rounded,
                    title: 'Live coaching overlays',
                    subtitle: 'Instant feedback for pronunciation clarity, filler-word usage, and pace confidence.',
                  ),
                  const SizedBox(height: 8),
                  const _SpeakingRoomFeatureTile(
                    icon: Icons.flag_circle_rounded,
                    title: 'Battle & mission modes',
                    subtitle: 'Team missions, topic cards, timed debates, and streak rewards to keep sessions exciting.',
                  ),
                  const SizedBox(height: 8),
                  const _SpeakingRoomFeatureTile(
                    icon: Icons.analytics_rounded,
                    title: 'Post-session performance board',
                    subtitle: 'Personal scorecards with speaking minutes, mistakes to review, and next-session focus.',
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            Navigator.pop(context);
                            if (!mounted) return;
                            ScaffoldMessenger.of(this.context).showSnackBar(
                              const SnackBar(content: Text('Speaking Rooms waitlist opened. You will be notified before launch.')),
                            );
                          },
                          icon: const Icon(Icons.notifications_active_rounded),
                          label: const Text('Join waitlist'),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: FilledButton.icon(
                          onPressed: () {
                            Navigator.pop(context);
                            if (!mounted) return;
                            ScaffoldMessenger.of(this.context).showSnackBar(
                              const SnackBar(content: Text('Preview mode is coming soon with the first premium rooms release.')),
                            );
                          },
                          icon: const Icon(Icons.rocket_launch_rounded),
                          label: const Text('Preview roadmap'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildExchangeUserCard(
    BuildContext context,
    TextTheme textTheme,
    AppLocalizations l10n,
    _ExchangeUser user,
  ) {
    final colors = Theme.of(context).colorScheme;
    Future<void> openDm() async {
      if (!mounted || user.isCurrentUser) return;
      await _openExchangeGoalSheet(user);
    }

    return Glass(
      radius: BorderRadius.circular(16),
      padding: const EdgeInsets.all(0),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: user.isCurrentUser ? null : openDm,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: user.isCurrentUser ? T.accent.withValues(alpha: 0.2) : colors.surfaceContainerHighest,
              border: Border.all(color: user.isCurrentUser ? T.accent.withValues(alpha: 0.4) : Colors.white.withValues(alpha: 0.1)),
            ),
            child: Stack(
              children: [
                Center(
                  child: Text(
                    user.name.isEmpty ? "?" : user.name.substring(0, 1).toUpperCase(),
                    style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900),
                  ),
                ),
                if (user.isOnline)
                  Positioned(
                    right: 2,
                    bottom: 2,
                    child: _LiveDot(live: user.isOnline),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      user.isCurrentUser ? 'You' : '@${user.name}',
                      style: textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w900, color: colors.onSurface),
                    ),
                    const SizedBox(width: 4),
                    if (user.compatibility > 0)
                      _Pill(
                        label: '${user.compatibility}%',
                        filled: user.compatibility >= 80,
                        backgroundColor: user.compatibility >= 80 ? T.accent.withValues(alpha: 0.2) : null,
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'Speaks ${user.speaks} • Learns ${user.learns}',
                  style: textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colors.onSurface.withValues(alpha: 0.65),
                  ),
                ),
              ],
            ),
          ),
          if (!user.isCurrentUser)
            _SmallIconButton(
              icon: Icons.chat_bubble_outline_rounded,
              onTap: openDm,
            ),
          if (!user.isCurrentUser) ...[
            const SizedBox(width: 8),
            _SmallIconButton(
              icon: Icons.more_vert_rounded,
              onTap: () => _showModerationDialog(context, user),
            ),
          ],
        ],
          ),
        ),
      ),
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
    if (!context.mounted) return;
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

    if (!context.mounted) return;
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

class _ExchangePrefsRequiredCard extends StatelessWidget {
  final Future<void> Function() onSetup;

  const _ExchangePrefsRequiredCard({required this.onSetup});

  @override
  Widget build(BuildContext context) {
    return Glass(
      radius: BorderRadius.circular(16),
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Set your exchange languages first',
            style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
          ),
          const SizedBox(height: 8),
          Text(
            'Choose up to 3 languages you speak (native + 2 more) and up to 5 languages you want to learn with levels.',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.78),
            ),
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: NeonButton(label: 'Set exchange languages', onTap: onSetup),
          ),
        ],
      ),
    );
  }
}

class _RoundFlowPreview extends StatelessWidget {
  final String fromLang;
  final String toLang;

  const _RoundFlowPreview({
    required this.fromLang,
    required this.toLang,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _RoundRuleRow(
          roundLabel: 'Round 1 • $fromLang',
          detail: 'Write only in $fromLang',
        ),
        const SizedBox(height: 8),
        _RoundRuleRow(
          roundLabel: 'Round 2 • $toLang',
          detail: 'Switch and write in $toLang',
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

class _ModernBadge extends StatelessWidget {
  final IconData icon;
  final String label;

  const _ModernBadge({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.08),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.9)),
          const SizedBox(width: 5),
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 11,
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.9),
            ),
          ),
        ],
      ),
    );
  }
}


class _SpeakingRoomsPremiumCard extends StatelessWidget {
  final VoidCallback onTap;

  const _SpeakingRoomsPremiumCard({required this.onTap});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Ink(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              T.accent.withValues(alpha: 0.18),
              scheme.primary.withValues(alpha: 0.14),
            ],
          ),
          border: Border.all(color: scheme.onSurface.withValues(alpha: 0.16)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.groups_rounded, size: 18),
                const SizedBox(width: 6),
                Text(
                  'Speaking Rooms (Premium)',
                  style: TextStyle(
                    color: scheme.onSurface,
                    fontWeight: FontWeight.w900,
                    fontSize: 13,
                  ),
                ),
                const Spacer(),
                Icon(Icons.arrow_forward_rounded, size: 16, color: scheme.onSurface.withValues(alpha: 0.74)),
              ],
            ),
            const SizedBox(height: 7),
            Text(
              'Voice-first rooms with live coaching overlays, team challenges, and premium scoreboards.',
              style: TextStyle(
                color: scheme.onSurface.withValues(alpha: 0.78),
                fontWeight: FontWeight.w600,
                fontSize: 11.5,
                height: 1.3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SpeakingRoomFeatureTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _SpeakingRoomFeatureTile({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
      decoration: BoxDecoration(
        color: scheme.onSurface.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: scheme.onSurface.withValues(alpha: 0.12)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 1),
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(9),
              color: T.accent.withValues(alpha: 0.18),
            ),
            child: Icon(icon, size: 16, color: scheme.onSurface),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: scheme.onSurface.withValues(alpha: 0.74),
                    fontWeight: FontWeight.w600,
                    fontSize: 11.8,
                    height: 1.32,
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

class _FilterActionChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const _FilterActionChip({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(999),
      onTap: onTap,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 240),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(999),
          color: T.accent.withValues(alpha: 0.16),
          border: Border.all(color: T.accent.withValues(alpha: 0.28)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                label,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 11.5),
              ),
            ),
            const SizedBox(width: 2),
            const Icon(Icons.expand_more_rounded, size: 14),
          ],
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
        color: T.accent.withValues(alpha: 0.12),
        border: Border.all(color: T.accent.withValues(alpha: 0.28)),
      ),
      child: const Text(
        'Session target: 10 rounds / 10 mins • Progress summary at end',
        style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12),
      ),
    );
  }
}


class _ExchangeNoCompatibleState extends StatelessWidget {
  final VoidCallback onOpenInbox;

  const _ExchangeNoCompatibleState({required this.onOpenInbox});

  @override
  Widget build(BuildContext context) {
    return _ExchangeEmptyBase(
      icon: Icons.filter_alt_off_rounded,
      title: 'No active exchange users right now',
      subtitle: 'Check your inbox or come back soon when more users are active.',
      ctaLabel: 'Open inbox',
      onTap: onOpenInbox,
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
  final IconData? icon;
  final String label;
  final bool filled;
  final Color? backgroundColor;

  const _Pill({
    this.icon,
    required this.label,
    this.filled = false,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        color: backgroundColor ?? Colors.black.withValues(alpha: 0.16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.10)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 14, color: Colors.white.withValues(alpha: 0.8)),
            const SizedBox(width: 5),
          ],
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
