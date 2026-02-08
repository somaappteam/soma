import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/achievement.dart';
import '../models/user_stats.dart';

class AchievementsRepository {
  final _supabase = Supabase.instance.client;

  Future<List<Achievement>> getAchievements() async {
    final achievements = await _supabase
        .from('achievements')
        .select()
        .order('created_at', ascending: true);

    final uid = _supabase.auth.currentUser?.id;
    if (uid == null) {
      return achievements
          .map((row) => Achievement(
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

    return achievements.map((row) {
      final id = row['id'].toString();
      final unlockedAtRaw = unlockedMap[id];
      return Achievement(
        id: id,
        title: row['title'] ?? '',
        description: row['description'],
        icon: row['icon'],
        unlocked: unlockedAtRaw != null,
        unlockedAt: unlockedAtRaw != null ? DateTime.tryParse(unlockedAtRaw) : null,
      );
    }).toList();
  }

  Future<void> unlock(String achievementId) async {
    final uid = _supabase.auth.currentUser?.id;
    if (uid == null) return;

    await _supabase.from('user_achievements').upsert({
      'user_id': uid,
      'achievement_id': achievementId,
      'unlocked_at': DateTime.now().toIso8601String(),
    }, onConflict: 'user_id, achievement_id');
  }

  Future<void> checkAfterQuiz({
    required UserStats stats,
    required int correctCount,
    required int totalCount,
  }) async {
    final uid = _supabase.auth.currentUser?.id;
    if (uid == null) return;

    if (totalCount > 0 && correctCount == totalCount) {
      await unlock('fast');
    }

    if (stats.totalQuizzes >= 20) {
      await unlock('study');
    }

    final profile = await _supabase
        .from('profiles')
        .select('total_xp')
        .eq('id', uid)
        .single();
    final totalXp = (profile['total_xp'] ?? 0) as int;
    if (totalXp >= 1000) {
      await unlock('level_up');
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

  Future<void> checkAfterCircle({required UserStats stats}) async {
    if (stats.circlesJoined >= 1) {
      await unlock('voice');
    }
  }

  Future<void> _checkTop3(String uid) async {
    final top = await _supabase
        .from('leaderboard')
        .select('id')
        .order('xp', ascending: false)
        .limit(3);
    final inTop = top.any((row) => row['id']?.toString() == uid);
    if (inTop) {
      await unlock('top3');
    }
  }
}

final achievementsRepository = AchievementsRepository();
