import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../core/database/database_helper.dart';
import '../core/services/app_logger.dart';
import '../core/services/error_reporter.dart';
import 'app_analytics_repository.dart';
import 'settings_repository.dart';
import 'offline_queue_repository.dart';

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

    appLogger.info('Starting content sync');

    await _runStep(
      'offline_queue',
      _processOfflineQueue,
      failedSteps,
      stepDurationsMs,
    );

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
      appLogger.info('Content sync completed', context: {'duration_ms': duration.inMilliseconds});
    } else {
      appLogger.warning('Content sync completed with failures', context: {'duration_ms': duration.inMilliseconds, 'failed_steps': failedSteps});
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
      appLogger.error('Sync step failed', context: {'step': name}, error: e, stackTrace: st);
      await errorReporter.capture(e, st, hint: 'ContentSyncService._runStep::$name');
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
    appLogger.debug('Courses synced', context: {'count': response.length});
  }

  Future<void> _syncVocabulary(String? cursor) async {
    final response = await _selectWithCursor(table: 'vocabulary', cursor: cursor);
    for (final row in response) {
      await _dbHelper.upsertVocabulary(row);
    }
    await _persistCursor('sync_cursor_vocabulary', response);
    appLogger.debug('Vocabulary synced', context: {'count': response.length});
  }

  Future<void> _syncSentences(String? cursor) async {
    final response = await _selectWithCursor(table: 'sentences', cursor: cursor);
    for (final row in response) {
      await _dbHelper.upsertSentence(row);
    }
    await _persistCursor('sync_cursor_sentences', response);
    appLogger.debug('Sentences synced', context: {'count': response.length});
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
      appLogger.debug('Profile synced', context: {'user_id': userId});
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

    appLogger.debug('User progress synced', context: {'user_id': userId});
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
      appLogger.debug('User stats synced', context: {'user_id': userId});
    }
  }

  Future<void> _processOfflineQueue() async {
    final items = await offlineQueueRepository.getAll();
    if (items.isEmpty) return;
    
    appLogger.info('Processing offline queue', context: {'count': items.length});
    final currentUserId = _supabase.auth.currentUser?.id;

    for (int i = 0; i < items.length; i++) {
      final item = items[i];
      try {
        appLogger.debug(
          'Processing offline queue item',
          context: {
            'index': i + 1,
            'total': items.length,
            'table': item.tableName,
            'operation': item.operation,
          },
        );

        if (item.data['user_id'] != currentUserId) {
          appLogger.warning(
            'Offline queue user mismatch',
            context: {'item_user_id': item.data['user_id']?.toString(), 'current_user_id': currentUserId},
          );
        }

        if (item.operation == 'UPSERT') {
          String? onConflict;
          if (item.tableName == 'user_learned_items') {
            onConflict = 'user_id,course_id,concept_id';
          } else if (item.tableName == 'user_courses') {
            onConflict = 'user_id,course_id';
          }
          await _supabase.from(item.tableName).upsert(item.data, onConflict: onConflict);
        } else if (item.operation == 'RPC') {
           final funcName = item.tableName.split(':').last;
           await _supabase.rpc(funcName, params: item.data);
        }
        await offlineQueueRepository.delete(item.id!);
      } catch (e, st) {
        appLogger.error('Offline queue item failed', context: {'item_id': item.id, 'table': item.tableName}, error: e, stackTrace: st);
        await errorReporter.capture(e, st, hint: 'ContentSyncService._processOfflineQueue');
        final es = e.toString();
        if (e is PostgrestException || es.contains('PostgrestException') || es.contains('PGRST')) {
          appLogger.warning('Dropping offline queue item after permanent database/schema error', context: {'item_id': item.id});
          await offlineQueueRepository.delete(item.id!);
        } else {
          rethrow;
        }
      }
    }
    appLogger.info('Offline queue processed successfully');
  }
}

final contentSyncService = ContentSyncService();
