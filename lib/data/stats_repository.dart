import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/user_stats.dart';
import '../core/database/database_helper.dart';
import 'package:flutter/foundation.dart';
import 'offline_queue_repository.dart';

class StatsRepository {
  final _supabase = Supabase.instance.client;

  Future<UserStats> getStats({String? userId}) async {
    final uid = userId ?? _supabase.auth.currentUser?.id;
    if (uid == null) return UserStats.empty();

    // Try local first for faster UI
    try {
      final local = await DatabaseHelper.instance.getUserStats(uid);
      if (local != null) return UserStats.fromRow(local);
    } catch (e) {
      debugPrint("Local stats fetch failed: $e");
    }

    final row = await _supabase
        .from('user_stats')
        .select()
        .eq('user_id', uid)
        .maybeSingle();

    if (row == null) return UserStats.empty();
    
    // Update local mirror
    await DatabaseHelper.instance.upsertUserStats(row);
    
    return UserStats.fromRow(row);
  }

  Future<UserStats> recordQuizResult({
    required int correctCount,
    required int totalCount,
  }) async {
    final uid = _supabase.auth.currentUser?.id;
    if (uid == null) return UserStats.empty();

    Map<String, dynamic>? existing;
    try {
      existing = await _supabase
          .from('user_stats')
          .select()
          .eq('user_id', uid)
          .maybeSingle();
    } catch (_) {
      // Offline fallback: try local
      existing = await DatabaseHelper.instance.getUserStats(uid);
    }

    final now = DateTime.now().toUtc();
    final today = DateTime.utc(now.year, now.month, now.day);

    int streak = 1;
    int longest = 1;

    if (existing != null) {
      final lastRaw = existing['last_active_date'];
      final last = _parseDate(lastRaw);
      final currentStreak = (existing['streak_days'] ?? 0) as int;
      final currentLongest = (existing['longest_streak'] ?? 0) as int;

      if (last != null) {
        final lastDate = DateTime.utc(last.year, last.month, last.day);
        final diff = today.difference(lastDate).inDays;
        if (diff == 0) {
          streak = currentStreak == 0 ? 1 : currentStreak;
        } else if (diff == 1) {
          streak = currentStreak + 1;
        } else {
          streak = 1;
        }
      }
      longest = streak > currentLongest ? streak : currentLongest;
    }

    final totalQuizzes = (existing?['total_quizzes'] ?? 0) + 1;
    final totalCorrect = (existing?['total_correct'] ?? 0) + correctCount;
    final totalQuestions = (existing?['total_questions'] ?? 0) + totalCount;
    final perfectQuizzes = (existing?['perfect_quizzes'] ?? 0) +
        ((totalCount > 0 && correctCount == totalCount) ? 1 : 0);

    final winThreshold = (totalCount * 0.7).ceil();
    final didWin = totalCount > 0 && correctCount >= winThreshold;
    final totalWins = (existing?['total_wins'] ?? 0) + (didWin ? 1 : 0);
    final circlesJoined = (existing?['circles_joined'] ?? 0);

    final payload = {
      'user_id': uid,
      'total_wins': totalWins,
      'streak_days': streak,
      'longest_streak': longest,
      'last_active_date': today.toIso8601String().split('T').first,
      'total_quizzes': totalQuizzes,
      'total_correct': totalCorrect,
      'total_questions': totalQuestions,
      'perfect_quizzes': perfectQuizzes,
      'circles_joined': circlesJoined,
      'updated_at': DateTime.now().toIso8601String(),
    };

    try {
      final updated = await _supabase
          .from('user_stats')
          .upsert(payload, onConflict: 'user_id')
          .select()
          .single();
      
      // Mirror to local SQLite
      await DatabaseHelper.instance.upsertUserStats(updated);
      return UserStats.fromRow(updated);
      
    } catch (e) {
      debugPrint("Cloud User Stats Upsert failed: $e. Enqueuing.");
      await offlineQueueRepository.enqueue(
          tableName: 'user_stats',
          operation: 'UPSERT',
          data: payload,
      );
      
      // Update local SQLite anyway
      await DatabaseHelper.instance.upsertUserStats(payload);
      return UserStats.fromRow(payload);
    }
  }

  Future<UserStats> incrementCirclesJoined() async {
    final uid = _supabase.auth.currentUser?.id;
    if (uid == null) return UserStats.empty();

    Map<String, dynamic>? existing;
    try {
      existing = await _supabase
          .from('user_stats')
          .select()
          .eq('user_id', uid)
          .maybeSingle();
    } catch (_) {
      existing = await DatabaseHelper.instance.getUserStats(uid);
    }

    final next = (existing?['circles_joined'] ?? 0) + 1;

    final payload = {
      'user_id': uid,
      'circles_joined': next,
      'updated_at': DateTime.now().toIso8601String(),
    };

    try {
      final updated = await _supabase
          .from('user_stats')
          .upsert(payload, onConflict: 'user_id')
          .select()
          .single();
      
      await DatabaseHelper.instance.upsertUserStats(updated);
      return UserStats.fromRow(updated);
    } catch (e) {
      debugPrint("Cloud Stats (Circles) Upsert failed: $e. Enqueuing.");
      await offlineQueueRepository.enqueue(
        tableName: 'user_stats',
        operation: 'UPSERT',
        data: payload,
      );
      
      await DatabaseHelper.instance.upsertUserStats(payload);
      return UserStats.fromRow(payload);
    }
  }

  static DateTime? _parseDate(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    if (value is String && value.isNotEmpty) {
      return DateTime.tryParse(value);
    }
    return null;
  }
}

final statsRepository = StatsRepository();
