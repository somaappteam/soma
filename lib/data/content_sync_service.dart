import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../core/database/database_helper.dart';
import 'app_analytics_repository.dart';
import 'settings_repository.dart';

class ContentSyncResult {
  final Duration duration;
  final List<String> failedSteps;
  final Map<String, int> stepDurationsMs;

  const ContentSyncResult({
    required this.duration,
    required this.failedSteps,
    required this.stepDurationsMs,
  });

  bool get success => failedSteps.isEmpty;
}

class ContentSyncService {
  final _supabase = Supabase.instance.client;
  final _dbHelper = DatabaseHelper.instance;

  Future<ContentSyncResult> syncEverything() async {
    final userId = _supabase.auth.currentUser?.id;
    final failedSteps = <String>[];
    final stepDurationsMs = <String, int>{};
    final startedAt = DateTime.now();
    final settings = await settingsRepository.getSettings();

    debugPrint('SYNC: Starting content sync...');

    await _runStep(
      'courses',
      () => _syncCourses(settings['sync_cursor_courses']?.toString()),
      failedSteps,
      stepDurationsMs,
    );
    await _runStep(
      'vocabulary',
      () => _syncVocabulary(settings['sync_cursor_vocabulary']?.toString()),
      failedSteps,
      stepDurationsMs,
    );
    await _runStep(
      'sentences',
      () => _syncSentences(settings['sync_cursor_sentences']?.toString()),
      failedSteps,
      stepDurationsMs,
    );

    if (userId != null) {
      await _runStep(
        'profile',
        () => _syncProfile(userId, settings['sync_cursor_profile']?.toString()),
        failedSteps,
        stepDurationsMs,
      );
      await _runStep(
        'user_progress',
        () => _syncUserProgress(userId, settings),
        failedSteps,
        stepDurationsMs,
      );
      await _runStep(
        'user_stats',
        () => _syncUserStats(userId, settings['sync_cursor_user_stats']?.toString()),
        failedSteps,
        stepDurationsMs,
      );
    }

    final duration = DateTime.now().difference(startedAt);
    final result = ContentSyncResult(
      duration: duration,
      failedSteps: failedSteps,
      stepDurationsMs: stepDurationsMs,
    );

    await appAnalyticsRepository.track(
      result.success ? 'sync_success' : 'sync_failed',
      metadata: {
        'duration_ms': duration.inMilliseconds,
        'failed_steps': result.failedSteps,
        'step_durations_ms': result.stepDurationsMs,
      },
    );

    if (result.success) {
      debugPrint('SYNC: Content sync completed in ${duration.inMilliseconds}ms.');
    } else {
      debugPrint(
        'SYNC: Content sync completed with failures in ${duration.inMilliseconds}ms. '
        'Failed steps: ${failedSteps.join(', ')}',
      );
    }

    return result;
  }

  Future<void> _runStep(
    String name,
    Future<void> Function() action,
    List<String> failedSteps,
    Map<String, int> stepDurationsMs,
  ) async {
    final startedAt = DateTime.now();
    try {
      await action();
    } catch (e, st) {
      failedSteps.add(name);
      debugPrint('SYNC: $name failed: $e\n$st');
    } finally {
      stepDurationsMs[name] = DateTime.now().difference(startedAt).inMilliseconds;
    }
  }

  Future<List<Map<String, dynamic>>> _selectWithCursor({
    required String table,
    String? cursor,
    String? userFilterColumn,
    String? userFilterValue,
  }) async {
    dynamic query = _supabase.from(table).select();
    if (userFilterColumn != null && userFilterValue != null) {
      query = query.eq(userFilterColumn, userFilterValue);
    }

    if (cursor != null && cursor.isNotEmpty) {
      try {
        dynamic cursorQuery = _supabase.from(table).select().gte('updated_at', cursor);
        if (userFilterColumn != null && userFilterValue != null) {
          cursorQuery = cursorQuery.eq(userFilterColumn, userFilterValue);
        }
        final response = await cursorQuery.order('updated_at');
        return List<Map<String, dynamic>>.from(response);
      } catch (_) {
        // fallback to full select if table does not support updated_at
      }
    }

    final response = await query;
    return List<Map<String, dynamic>>.from(response);
  }

  String? _latestUpdatedAt(List<Map<String, dynamic>> rows) {
    DateTime? latest;
    for (final row in rows) {
      final raw = row['updated_at']?.toString();
      if (raw == null || raw.isEmpty) continue;
      final parsed = DateTime.tryParse(raw);
      if (parsed == null) continue;
      if (latest == null || parsed.isAfter(latest)) {
        latest = parsed;
      }
    }
    return latest?.toIso8601String();
  }

  Future<void> _persistCursor(String key, List<Map<String, dynamic>> rows) async {
    final latest = _latestUpdatedAt(rows);
    if (latest != null) {
      await settingsRepository.updateSetting(key, latest);
    }
  }

  Future<void> _syncCourses(String? cursor) async {
    final response = await _selectWithCursor(table: 'courses', cursor: cursor);
    for (final row in response) {
      await _dbHelper.upsertCourse(row);
    }
    await _persistCursor('sync_cursor_courses', response);
    debugPrint('SYNC: Synced ${response.length} courses.');
  }

  Future<void> _syncVocabulary(String? cursor) async {
    final response = await _selectWithCursor(table: 'vocabulary', cursor: cursor);
    for (final row in response) {
      await _dbHelper.upsertVocabulary(row);
    }
    await _persistCursor('sync_cursor_vocabulary', response);
    debugPrint('SYNC: Synced ${response.length} vocabulary items.');
  }

  Future<void> _syncSentences(String? cursor) async {
    final response = await _selectWithCursor(table: 'sentences', cursor: cursor);
    for (final row in response) {
      await _dbHelper.upsertSentence(row);
    }
    await _persistCursor('sync_cursor_sentences', response);
    debugPrint('SYNC: Synced ${response.length} sentences.');
  }

  Future<void> _syncProfile(String userId, String? cursor) async {
    final profileRows = await _selectWithCursor(
      table: 'profiles',
      cursor: cursor,
      userFilterColumn: 'id',
      userFilterValue: userId,
    );

    if (profileRows.isNotEmpty) {
      await _dbHelper.upsertProfile(profileRows.first);
      await _persistCursor('sync_cursor_profile', profileRows);
      debugPrint('SYNC: Synced profile for $userId.');
    }
  }

  Future<void> _syncUserProgress(String userId, Map<String, dynamic> settings) async {
    final coursesResp = await _selectWithCursor(
      table: 'user_courses',
      cursor: settings['sync_cursor_user_courses']?.toString(),
      userFilterColumn: 'user_id',
      userFilterValue: userId,
    );

    for (final row in coursesResp) {
      await _dbHelper.upsertUserCourse(row);
    }

    final srsResp = await _selectWithCursor(
      table: 'user_learned_items',
      cursor: settings['sync_cursor_user_learned_items']?.toString(),
      userFilterColumn: 'user_id',
      userFilterValue: userId,
    );

    for (final row in srsResp) {
      await _dbHelper.upsertUserLearnedItem(row);
    }

    await _persistCursor('sync_cursor_user_courses', coursesResp);
    await _persistCursor('sync_cursor_user_learned_items', srsResp);

    debugPrint('SYNC: Synced user progress for $userId.');
  }

  Future<void> _syncUserStats(String userId, String? cursor) async {
    final statsResp = await _selectWithCursor(
      table: 'user_stats',
      cursor: cursor,
      userFilterColumn: 'user_id',
      userFilterValue: userId,
    );

    if (statsResp.isNotEmpty) {
      await _dbHelper.upsertUserStats(statsResp.first);
      await _persistCursor('sync_cursor_user_stats', statsResp);
      debugPrint('SYNC: Synced user stats for $userId.');
    }
  }
}

final contentSyncService = ContentSyncService();
