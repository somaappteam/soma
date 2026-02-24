import 'package:soma/core/database/database_helper.dart';
import 'package:soma/core/di/locator.dart';
import 'package:soma/core/services/app_logger.dart';
import 'package:soma/data/offline_queue_repository.dart';
import 'package:soma/models/user_stats.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class StatsRepository {
  final _supabase = Supabase.instance.client;

  Future<UserStats> getStats({final String? userId}) async {
    final uid = userId ?? _supabase.auth.currentUser?.id;
    if (uid == null) return UserStats.empty();

    // Try local first for faster UI.
    try {
      final local = await DatabaseHelper.instance.getUserStats(uid);
      if (local != null) return UserStats.fromRow(local);
    } catch (e) {
      appLogger.debug('Local stats fetch failed: $e');
    }

    final row = await _supabase
        .from('user_stats')
        .select()
        .eq('user_id', uid)
        .maybeSingle();

    if (row == null) return UserStats.empty();

    // Mirror to local SQLite.
    await DatabaseHelper.instance.upsertUserStats(row);

    return UserStats.fromRow(row);
  }

  Future<UserStats> recordQuizResult({
    required final int correctCount,
    required final int totalCount,
  }) async {
    final uid = _supabase.auth.currentUser?.id;
    if (uid == null) return UserStats.empty();

    // Read existing stats — prefer local (already up-to-date) over cloud.
    Map<String, dynamic>? existing;
    try {
      existing = await DatabaseHelper.instance.getUserStats(uid);
    } catch (_) {}
    // If local is empty, fall back to cloud once.
    if (existing == null) {
      try {
        existing = await _supabase
            .from('user_stats')
            .select()
            .eq('user_id', uid)
            .maybeSingle();
      } catch (_) {}
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
    final circlesJoined = (existing?['circles_joined'] ?? 0) as int;

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

    // ── SQLite-first: write locally without blocking the caller. ────────────
    try {
      await DatabaseHelper.instance.upsertUserStats(payload);
    } catch (e) {
      appLogger.debug('StatsRepository: local write failed – $e');
    }

    // ── Cloud in background: fire-and-forget, enqueue on failure. ───────────
    _pushToCloud('user_stats', payload);

    return UserStats.fromRow(payload);
  }

  Future<UserStats> incrementCirclesJoined() async {
    final uid = _supabase.auth.currentUser?.id;
    if (uid == null) return UserStats.empty();

    // Read existing stats — prefer local.
    Map<String, dynamic>? existing;
    try {
      existing = await DatabaseHelper.instance.getUserStats(uid);
    } catch (_) {}
    if (existing == null) {
      try {
        existing = await _supabase
            .from('user_stats')
            .select()
            .eq('user_id', uid)
            .maybeSingle();
      } catch (_) {}
    }

    final next = (existing?['circles_joined'] ?? 0) + 1;

    final payload = {
      'user_id': uid,
      'circles_joined': next,
      'updated_at': DateTime.now().toIso8601String(),
    };

    // SQLite-first.
    try {
      await DatabaseHelper.instance.upsertUserStats(payload);
    } catch (e) {
      appLogger.debug('StatsRepository: local write (circles) failed – $e');
    }

    // Cloud in background.
    _pushToCloud('user_stats', payload);

    return UserStats.fromRow({...?existing, ...payload});
  }

  /// Upserts [payload] to Supabase in the background.
  /// On failure, enqueues the payload for offline retry.
  void _pushToCloud(final String table, final Map<String, dynamic> payload) {
    _supabase
        .from(table)
        .upsert(payload, onConflict: 'user_id')
        .then((final _) {
      appLogger.debug('StatsRepository: cloud sync OK for $table');
    }).catchError((final e) {
      appLogger.debug(
          'StatsRepository: cloud sync failed for $table – $e. Enqueuing.');
      offlineQueueRepository.enqueue(
        tableName: table,
        operation: 'UPSERT',
        data: payload,
      );
    });
  }

  static DateTime? _parseDate(final dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    if (value is String && value.isNotEmpty) {
      return DateTime.tryParse(value);
    }
    return null;
  }
}

StatsRepository get statsRepository => locator<StatsRepository>();
