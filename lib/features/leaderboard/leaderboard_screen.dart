import 'dart:async';
import 'package:flutter/material.dart';
import 'package:soma/l10n/gen/app_localizations.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/widgets/glass.dart';
import '../../core/widgets/pressable_scale.dart';
import '../../core/widgets/staggered_in.dart';
import '../../core/theme/app_theme.dart';
import '../../core/theme/layout_tokens.dart';
import '../../core/widgets/premium_screen_scaffold.dart';
import '../../data/leaderboard_repository.dart';
import '../../data/presence_repository.dart';
import '../profile/profile_screen.dart';

// ─── Tab definition ──────────────────────────────────────────────────────────

enum _LeaderboardTab { global, language, friends }

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late Future<List<Map<String, dynamic>>> _leaderboardFuture;
  final TextEditingController _searchController = TextEditingController();

  String _query = '';
  bool _weeklyOnly = false;
  List<String> _friendIds = [];
  String? _myLearningLanguage;
  final _supabase = Supabase.instance.client;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        _searchController.clear();
        _query = '';
        _fetchLeaderboard();
      }
    });
    _loadMetadata();
    _fetchLeaderboard();
  }

  Future<void> _loadMetadata() async {
    final uid = _supabase.auth.currentUser?.id;
    if (uid == null) return;

    // Fetch friend IDs.
    final ids = await leaderboardRepository.getFriendIds(uid);

    // Fetch current user's first learning language for the language tab.
    String? lang;
    try {
      final profile = await _supabase
          .from('profiles')
          .select('learning_languages')
          .eq('id', uid)
          .maybeSingle();
      final langs = profile?['learning_languages'];
      if (langs is List && langs.isNotEmpty) {
        lang = langs.first?.toString();
      }
    } catch (_) {}

    if (mounted) {
      setState(() {
        _friendIds = ids;
        _myLearningLanguage = lang;
      });
      _fetchLeaderboard();
    }
  }

  void _fetchLeaderboard() {
    final tab = _LeaderboardTab.values[_tabController.index];
    setState(() {
      if (_query.isNotEmpty) {
        _leaderboardFuture = _searchAndRank(_query);
      } else if (_weeklyOnly) {
        _leaderboardFuture =
            leaderboardRepository.getWeeklyLeaderboard(limit: 50);
      } else {
        switch (tab) {
          case _LeaderboardTab.global:
            _leaderboardFuture =
                leaderboardRepository.getGlobalLeaderboard(limit: 50);
          case _LeaderboardTab.language:
            _leaderboardFuture = _myLearningLanguage != null
                ? leaderboardRepository.getLanguageLeaderboard(
                    _myLearningLanguage!,
                    limit: 50,
                  )
                : leaderboardRepository.getGlobalLeaderboard(limit: 50);
          case _LeaderboardTab.friends:
            _leaderboardFuture =
                leaderboardRepository.getFriendsLeaderboard(_friendIds);
        }
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

  Timer? _debounce;
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
    _tabController.dispose();
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    final textTones = Theme.of(context).extension<AppTextToneTheme>();
    final tab = _LeaderboardTab.values[_tabController.index];

    String tabTitle;
    switch (tab) {
      case _LeaderboardTab.global:
        tabTitle = l10n.leaderboardGlobalTitle;
      case _LeaderboardTab.language:
        tabTitle = _myLearningLanguage != null
            ? 'Top in ${_myLearningLanguage!}'
            : l10n.leaderboardGlobalTitle;
      case _LeaderboardTab.friends:
        tabTitle = 'Friends';
    }

    return PremiumScreenScaffold(
      includeHeader: true,
      title: _weeklyOnly ? 'Weekly · $tabTitle' : tabTitle,
      leading: _IconGlass(
        icon: Icons.arrow_back_ios_new_rounded,
        onTap: () => Navigator.pop(context),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final density = PremiumLayout.densityForWidth(constraints.maxWidth);
          final listGap = PremiumLayout.listGap(density);

          return Column(
            children: [
              // ── Tab bar ──────────────────────────────────────────────────
              Glass(
                depth: GlassDepth.l1,
                radius: BorderRadius.circular(20),
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                child: TabBar(
                  controller: _tabController,
                  indicator: BoxDecoration(
                    color: scheme.primary.withValues(alpha: 0.18),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  dividerColor: Colors.transparent,
                  labelColor: scheme.primary,
                  unselectedLabelColor:
                      textTones?.muted ?? scheme.onSurface.withValues(alpha: 0.5),
                  labelStyle: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 13,
                  ),
                  tabs: [
                    const Tab(text: 'Global'),
                    Tab(
                        text: _myLearningLanguage != null
                            ? _myLearningLanguage!
                            : 'Language'),
                    const Tab(text: 'Friends'),
                  ],
                ),
              ),
              const SizedBox(height: 10),

              // ── Weekly toggle + search row ────────────────────────────────
              Row(
                children: [
                  // Weekly toggle pill.
                  GestureDetector(
                    onTap: () {
                      setState(() => _weeklyOnly = !_weeklyOnly);
                      _fetchLeaderboard();
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: _weeklyOnly
                            ? scheme.primary.withValues(alpha: 0.18)
                            : scheme.onSurface.withValues(alpha: 0.07),
                        borderRadius: BorderRadius.circular(999),
                        border: Border.all(
                          color: _weeklyOnly
                              ? scheme.primary.withValues(alpha: 0.5)
                              : Colors.transparent,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.calendar_today_rounded,
                              size: 13,
                              color: _weeklyOnly
                                  ? scheme.primary
                                  : textTones?.muted ??
                                      scheme.onSurface.withValues(alpha: 0.5)),
                          const SizedBox(width: 4),
                          Text(
                            'Weekly',
                            style: TextStyle(
                              color: _weeklyOnly
                                  ? scheme.primary
                                  : textTones?.muted ??
                                      scheme.onSurface.withValues(alpha: 0.5),
                              fontWeight: FontWeight.w700,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),

                  // Search field.
                  Expanded(
                    child: Glass(
                      depth: GlassDepth.l1,
                      radius: BorderRadius.circular(20),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 10),
                      child: Row(
                        children: [
                          Icon(Icons.search_rounded,
                              color: textTones?.medium ??
                                  scheme.onSurface.withValues(alpha: 0.7)),
                          const SizedBox(width: 10),
                          Expanded(
                            child: TextField(
                              controller: _searchController,
                              onChanged: _onSearchChanged,
                              style: TextStyle(
                                  color: scheme.onSurface,
                                  fontWeight: FontWeight.w700),
                              cursorColor: scheme.onSurface,
                              decoration: InputDecoration(
                                hintText: 'Search players…',
                                hintStyle: TextStyle(
                                    color: textTones?.muted ??
                                        scheme.onSurface
                                            .withValues(alpha: 0.45)),
                                border: InputBorder.none,
                                isDense: true,
                              ),
                            ),
                          ),
                          if (_searchController.text.isNotEmpty)
                            GestureDetector(
                              onTap: () {
                                _searchController.clear();
                                _onSearchChanged('');
                                setState(() {});
                              },
                              child: Icon(Icons.close_rounded,
                                  color: textTones?.medium ??
                                      scheme.onSurface.withValues(alpha: 0.7)),
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: SectionGap.lg),

              // ── List ─────────────────────────────────────────────────────
              Expanded(
                child: FutureBuilder<List<Map<String, dynamic>>>(
                  future: _leaderboardFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                          child: CircularProgressIndicator(
                              color: scheme.primary));
                    }
                    if (snapshot.hasError) {
                      return const Center(
                          child: Text('Error loading leaderboard'));
                    }
                    final data = snapshot.data ?? [];
                    if (data.isEmpty) {
                      String emptyMsg;
                      if (_tabController.index == 2) {
                        emptyMsg = 'Add friends to see them here!';
                      } else if (_query.isNotEmpty) {
                        emptyMsg = 'No players found for "$_query"';
                      } else {
                        emptyMsg = l10n.leaderboardEmpty;
                      }
                      return Center(
                        child: Glass(
                          depth: GlassDepth.l1,
                          radius: BorderRadius.circular(18),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 14),
                          child: Text(emptyMsg,
                              style: TextStyle(
                                  color: textTones?.muted ??
                                      scheme.onSurface.withValues(alpha: 0.62))),
                        ),
                      );
                    }

                    final userIds = data
                        .map((u) =>
                            (u['id'] ?? u['user_id'])?.toString())
                        .whereType<String>()
                        .toList();

                    final podium = _query.isEmpty &&
                            _tabController.index == 0 &&
                            !_weeklyOnly
                        ? data.take(3).toList()
                        : const <Map<String, dynamic>>[];

                    return StreamBuilder<Map<String, bool>>(
                      stream: presenceRepository
                          .streamMultipleOnlineStatuses(userIds),
                      builder: (context, presenceSnapshot) {
                        final onlineStatuses =
                            presenceSnapshot.data ?? {};
                        return ListView(
                          physics: const BouncingScrollPhysics(),
                          children: [
                            if (podium.isNotEmpty) ...[
                              StaggeredIn(
                                  index: 0,
                                  child: _PodiumCard(players: podium)),
                              SizedBox(height: listGap),
                            ],
                            ...List.generate(data.length, (index) {
                              final user = data[index];
                              final rank =
                                  user['rank'] ?? (index + 1);
                              final isTop3 = rank <= 3;
                              final avatarUrl =
                                  user['avatar_url']?.toString();
                              final displayName =
                                  user['display_name']?.toString();
                              final username =
                                  user['username']?.toString();
                              final userId = user['id']?.toString() ??
                                  user['user_id']?.toString();
                              final name = (displayName != null &&
                                      displayName.trim().isNotEmpty)
                                  ? displayName
                                  : (username?.isNotEmpty == true
                                      ? username!
                                      : l10n.userFallbackName);
                              final isOnline =
                                  onlineStatuses[userId] == true;
                              final trend = (rank % 4) - 2;
                              final streak =
                                  (user['streak_days'] is int)
                                      ? user['streak_days'] as int
                                      : (int.tryParse(user[
                                                  'streak_days']
                                              ?.toString() ??
                                          '') ??
                                          0);

                              return Padding(
                                padding:
                                    EdgeInsets.only(bottom: listGap),
                                child: StaggeredIn(
                                  index: index + 1,
                                  child: PressableScale(
                                    onTap: userId == null
                                        ? null
                                        : () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (_) =>
                                                    ProfileScreen(
                                                        userId: userId),
                                              ),
                                            );
                                          },
                                    child: Glass(
                                      selected: isTop3,
                                      depth: isTop3
                                          ? GlassDepth.l3
                                          : GlassDepth.l2,
                                      radius: BorderRadius.circular(18),
                                      padding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 16,
                                              vertical: 12),
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            width: 42,
                                            child: Text(
                                              '#$rank',
                                              style: TextStyle(
                                                color: isTop3
                                                    ? scheme.primary
                                                    : (textTones
                                                            ?.muted ??
                                                        scheme.onSurface
                                                            .withValues(
                                                                alpha:
                                                                    0.52)),
                                                fontWeight:
                                                    FontWeight.w900,
                                                fontSize: 15,
                                              ),
                                            ),
                                          ),
                                          Hero(
                                            tag: userId == null
                                                ? 'leader-avatar-$rank'
                                                : 'profile-avatar-$userId',
                                            child: Stack(
                                              children: [
                                                Container(
                                                  width: 40,
                                                  height: 40,
                                                  decoration:
                                                      BoxDecoration(
                                                    shape:
                                                        BoxShape.circle,
                                                    color: scheme
                                                        .onSurface
                                                        .withValues(
                                                            alpha: 0.08),
                                                  ),
                                                  child: (avatarUrl !=
                                                              null &&
                                                          avatarUrl
                                                              .trim()
                                                              .isNotEmpty)
                                                      ? ClipOval(
                                                          child: Image
                                                              .network(
                                                            avatarUrl,
                                                            width: 40,
                                                            height: 40,
                                                            fit: BoxFit
                                                                .cover,
                                                            errorBuilder:
                                                                (_, __,
                                                                        ___) =>
                                                                    Icon(
                                                              Icons
                                                                  .person,
                                                              color: scheme
                                                                  .onSurface,
                                                            ),
                                                          ),
                                                        )
                                                      : Icon(Icons.person,
                                                          color: scheme
                                                              .onSurface),
                                                ),
                                                if (isOnline)
                                                  Positioned(
                                                    bottom: 1,
                                                    right: 1,
                                                    child: Container(
                                                      width: 10,
                                                      height: 10,
                                                      decoration:
                                                          BoxDecoration(
                                                        shape:
                                                            BoxShape.circle,
                                                        color: const Color(
                                                            0xFF58F7B6),
                                                        border: Border.all(
                                                            color: scheme
                                                                .surface,
                                                            width: 2),
                                                      ),
                                                    ),
                                                  ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment
                                                      .start,
                                              children: [
                                                Text(
                                                  name,
                                                  maxLines: 1,
                                                  overflow: TextOverflow
                                                      .ellipsis,
                                                  style: TextStyle(
                                                    color:
                                                        scheme.onSurface,
                                                    fontWeight:
                                                        FontWeight.w700,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                                const SizedBox(height: 2),
                                                Row(
                                                  children: [
                                                    _RankTrendChip(
                                                        delta: trend),
                                                    const SizedBox(
                                                        width: 6),
                                                    if (streak > 0)
                                                      Row(
                                                        children: [
                                                          Icon(
                                                            Icons
                                                                .local_fire_department_rounded,
                                                            size: 14,
                                                            color: scheme
                                                                .tertiary,
                                                          ),
                                                          const SizedBox(
                                                              width: 2),
                                                          Text(
                                                            '$streak',
                                                            style:
                                                                TextStyle(
                                                              color: textTones
                                                                      ?.medium ??
                                                                  scheme.onSurface
                                                                      .withValues(
                                                                          alpha:
                                                                              0.72),
                                                              fontSize:
                                                                  11.5,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          Text(
                                            l10n.profileXpValue(
                                                user['xp'] ?? 0),
                                            style: TextStyle(
                                              color: textTones?.high ??
                                                  scheme.onSurface
                                                      .withValues(
                                                          alpha: 0.9),
                                              fontWeight: FontWeight.w800,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }),
                          ],
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

// ─── Podium ──────────────────────────────────────────────────────────────────

class _PodiumCard extends StatelessWidget {
  final List<Map<String, dynamic>> players;
  const _PodiumCard({required this.players});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Glass(
      depth: GlassDepth.l3,
      selected: true,
      radius: BorderRadius.circular(22),
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Top 3 Podium',
              style: TextStyle(
                  color: scheme.onSurface,
                  fontWeight: FontWeight.w900,
                  fontSize: 16)),
          const SizedBox(height: 10),
          Row(
            children: List.generate(players.length, (i) {
              final player = players[i];
              final rank = i + 1;
              return Expanded(
                child: Column(
                  children: [
                    Container(
                      width: 46,
                      height: 46,
                      decoration: BoxDecoration(
                        color: scheme.primary.withValues(alpha: 0.16),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: rank == 1
                              ? scheme.primary
                              : scheme.onSurface.withValues(alpha: 0.14),
                        ),
                      ),
                      child: Center(
                          child: Text('#$rank',
                              style: TextStyle(
                                  color: scheme.onSurface,
                                  fontWeight: FontWeight.w900))),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      (player['display_name']?.toString().isNotEmpty == true)
                          ? player['display_name'].toString()
                          : (player['username']?.toString() ?? 'Player'),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: scheme.onSurface,
                          fontWeight: FontWeight.w700,
                          fontSize: 12.5),
                    ),
                    const SizedBox(height: 2),
                    Text('${player['xp'] ?? 0} XP',
                        style: TextStyle(
                            color: scheme.onSurface.withValues(alpha: 0.72),
                            fontWeight: FontWeight.w700,
                            fontSize: 11)),
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

// ─── Rank trend chip ─────────────────────────────────────────────────────────

class _RankTrendChip extends StatelessWidget {
  final int delta;
  const _RankTrendChip({required this.delta});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTones = Theme.of(context).extension<AppTextToneTheme>();
    final isUp = delta > 0;
    final isFlat = delta == 0;
    final color = isFlat
        ? scheme.onSurface.withValues(alpha: 0.45)
        : (isUp
            ? const Color(0xFF41D99A)
            : scheme.error.withValues(alpha: 0.82));
    final icon = isFlat
        ? Icons.trending_flat_rounded
        : (isUp
            ? Icons.arrow_upward_rounded
            : Icons.arrow_downward_rounded);
    final text = isFlat ? '0' : '${isUp ? '+' : ''}$delta';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        color: color.withValues(alpha: 0.16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 11, color: color),
          const SizedBox(width: 2),
          Text(text,
              style: TextStyle(
                  color: color,
                  fontSize: 10.5,
                  fontWeight: FontWeight.w800)),
        ],
      ),
    );
  }
}

// ─── Icon glass button ───────────────────────────────────────────────────────

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
        depth: GlassDepth.l1,
        radius: BorderRadius.circular(16),
        padding: const EdgeInsets.all(10),
        child:
            Icon(icon, color: scheme.onSurface.withValues(alpha: 0.92)),
      ),
    );
  }
}
