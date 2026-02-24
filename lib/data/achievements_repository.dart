import 'package:flutter/foundation.dart';
import 'package:soma/core/di/locator.dart';
import 'package:soma/core/services/app_logger.dart';
import 'package:soma/models/achievement.dart';
import 'package:soma/models/user_stats.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Global notifier that emits an [Achievement] whenever one is newly unlocked.
/// Listeners (e.g. [AppShell]) should show a toast and reset to null after consuming.
final achievementUnlockNotifier = ValueNotifier<Achievement?>(null);

class AchievementsRepository {
  final _supabase = Supabase.instance.client;

  /// In-memory cache of already-unlocked achievement IDs for the current session.
  /// Populated lazily on the first [unlock] call, then kept up-to-date.
  final Set<String> _unlockedCache = {};
  bool _cacheWarmed = false;

  // ─────────────────────────────── Read ───────────────────────────────────────

  Future<List<Achievement>> getAchievements() async {
    final achievements = await _supabase
        .from('achievements')
        .select()
        .order('created_at', ascending: true);

    final uid = _supabase.auth.currentUser?.id;
    if (uid == null) {
      return achievements
          .map((final row) => Achievement(
                id: row['id'].toString(),
                title: row['title'] ?? '',
                description: row['description'],
                icon: row['icon'],
                unlocked: false,
                unlockedAt: null,
              ))
          .toList();
    }

    final unlockedRows = await _supabase
        .from('user_achievements')
        .select('achievement_id, unlocked_at')
        .eq('user_id', uid);

    final unlockedMap = {
      for (final row in unlockedRows)
        row['achievement_id'].toString(): row['unlocked_at']?.toString(),
    };

    // Warm cache while we have the data.
    _unlockedCache.addAll(unlockedMap.keys);
    _cacheWarmed = true;

    return achievements.map((final row) {
      final id = row['id'].toString();
      final unlockedAtRaw = unlockedMap[id];
      return Achievement(
        id: id,
        title: row['title'] ?? '',
        description: row['description'],
        icon: row['icon'],
        unlocked: unlockedAtRaw != null,
        unlockedAt:
            unlockedAtRaw != null ? DateTime.tryParse(unlockedAtRaw) : null,
      );
    }).toList();
  }

  // ─────────────────────────────── Unlock ─────────────────────────────────────

  /// Unlocks an achievement by [achievementId].
  ///
  /// Checks the in-memory cache first to avoid redundant DB writes and duplicate
  /// toasts. If the cache is cold, warms it from Supabase before checking.
  Future<void> unlock(final String achievementId) async {
    final uid = _supabase.auth.currentUser?.id;
    if (uid == null) return;

    // Warm cache if needed.
    if (!_cacheWarmed) {
      try {
        final rows = await _supabase
            .from('user_achievements')
            .select('achievement_id')
            .eq('user_id', uid);
        for (final r in rows) {
          _unlockedCache.add(r['achievement_id'].toString());
        }
        _cacheWarmed = true;
      } catch (e) {
        appLogger.debug('AchievementsRepository: cache warm failed – $e');
      }
    }

    // Already unlocked → skip silently.
    if (_unlockedCache.contains(achievementId)) return;

    try {
      await _supabase.from('user_achievements').upsert({
        'user_id': uid,
        'achievement_id': achievementId,
        'unlocked_at': DateTime.now().toIso8601String(),
      }, onConflict: 'user_id, achievement_id');

      _unlockedCache.add(achievementId);

      // Fetch the achievement details and emit for in-app toast.
      _emitUnlockToast(achievementId);
    } catch (e) {
      appLogger.debug(
          'AchievementsRepository: unlock failed for $achievementId – $e');
    }
  }

  /// Fetches an achievement row and pushes it onto [achievementUnlockNotifier].
  void _emitUnlockToast(final String achievementId) async {
    try {
      final rows = await _supabase
          .from('achievements')
          .select()
          .eq('id', achievementId)
          .limit(1);
      if (rows.isEmpty) return;
      final row = rows.first;
      achievementUnlockNotifier.value = Achievement(
        id: achievementId,
        title: row['title'] ?? achievementId,
        description: row['description'],
        icon: row['icon'],
        unlocked: true,
        unlockedAt: DateTime.now(),
      );
    } catch (e) {
      appLogger.debug('AchievementsRepository: toast emit failed – $e');
    }
  }

  // ─────────────────────────────── Check triggers ─────────────────────────────

  Future<void> checkAfterQuiz({
    required final UserStats stats,
    required final int correctCount,
    required final int totalCount,
  }) async {
    final uid = _supabase.auth.currentUser?.id;
    if (uid == null) return;

    // Perfect score.
    if (totalCount > 0 && correctCount == totalCount) {
      await unlock('fast');
    }

    // Quiz count milestone.
    if (stats.totalQuizzes >= 20) {
      await unlock('study');
    }

    // Streak milestones.
    if (stats.streakDays >= 3) await unlock('streak_3');
    if (stats.streakDays >= 7) await unlock('streak_7');
    if (stats.streakDays >= 30) await unlock('streak_30');

    // XP milestones — fetched once, checked against multiple thresholds.
    try {
      final profile = await _supabase
          .from('profiles')
          .select('total_xp')
          .eq('id', uid)
          .single();
      final totalXp = (profile['total_xp'] ?? 0) as int;

      if (totalXp >= 500) await unlock('xp_500');
      if (totalXp >= 1000) await unlock('xp_1000');
      if (totalXp >= 5000) await unlock('xp_5000');
      if (totalXp >= 10000) await unlock('xp_10000');
    } catch (e) {
      appLogger.debug('AchievementsRepository: XP check failed – $e');
    }

    await _checkTop3(uid);
  }

  Future<void> checkAfterFriend() async {
    final uid = _supabase.auth.currentUser?.id;
    if (uid == null) return;

    final rows = await _supabase
        .from('friendships')
        .select('id')
        .or('requester_id.eq.$uid,addressee_id.eq.$uid')
        .eq('status', 'accepted')
        .limit(1);

    if (rows.isNotEmpty) {
      await unlock('social');
    }
  }

  Future<void> checkAfterCircle({required final UserStats stats}) async {
    if (stats.circlesJoined >= 1) {
      await unlock('voice');
    }
  }

  /// Runs a full achievement sweep after login.
  /// Checks XP, streak, quiz count, leaderboard position, and social.
  Future<void> checkOnLogin() async {
    final uid = _supabase.auth.currentUser?.id;
    if (uid == null) return;

    try {
      // Fetch profile and stats in parallel.
      final results = await Future.wait([
        _supabase.from('profiles').select('total_xp').eq('id', uid).single(),
        _supabase.from('user_stats').select().eq('user_id', uid).maybeSingle(),
      ]);

      final profileRow = results[0];
      final statsRow = results[1];

      final totalXp = (profileRow?['total_xp'] ?? 0) as int;
      final totalQuizzes = (statsRow?['total_quizzes'] ?? 0) as int;
      final streakDays = (statsRow?['streak_days'] ?? 0) as int;
      final circlesJoined = (statsRow?['circles_joined'] ?? 0) as int;

      // XP milestones.
      if (totalXp >= 500) await unlock('xp_500');
      if (totalXp >= 1000) await unlock('xp_1000');
      if (totalXp >= 5000) await unlock('xp_5000');
      if (totalXp >= 10000) await unlock('xp_10000');

      // Quiz milestones.
      if (totalQuizzes >= 20) await unlock('study');

      // Streak milestones.
      if (streakDays >= 3) await unlock('streak_3');
      if (streakDays >= 7) await unlock('streak_7');
      if (streakDays >= 30) await unlock('streak_30');

      // Circle participation.
      if (circlesJoined >= 1) await unlock('voice');

      // Leaderboard.
      await _checkTop3(uid);

      // Friends.
      await checkAfterFriend();
    } catch (e) {
      appLogger.debug('AchievementsRepository: checkOnLogin failed – $e');
    }
  }

  Future<void> _checkTop3(final String uid) async {
    try {
      final top = await _supabase
          .from('leaderboard')
          .select('id')
          .order('xp', ascending: false)
          .limit(3);
      final inTop = top.any((final row) => row['id']?.toString() == uid);
      if (inTop) await unlock('top3');
    } catch (e) {
      appLogger.debug('AchievementsRepository: top3 check failed – $e');
    }
  }
}

AchievementsRepository get achievementsRepository =>
    locator<AchievementsRepository>();
