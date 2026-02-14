import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../core/database/database_helper.dart';

class ContentSyncResult {
  final Duration duration;
  final List<String> failedSteps;

  const ContentSyncResult({
    required this.duration,
    required this.failedSteps,
  });

  bool get success => failedSteps.isEmpty;
}

class ContentSyncService {
  final _supabase = Supabase.instance.client;
  final _dbHelper = DatabaseHelper.instance;

  Future<ContentSyncResult> syncEverything() async {
    final userId = _supabase.auth.currentUser?.id;
    final failedSteps = <String>[];
    final startedAt = DateTime.now();

    debugPrint('SYNC: Starting content sync...');

    await _runStep('courses', _syncCourses, failedSteps);
    await _runStep('vocabulary', _syncVocabulary, failedSteps);
    await _runStep('sentences', _syncSentences, failedSteps);

    if (userId != null) {
      await _runStep('profile', () => _syncProfile(userId), failedSteps);
      await _runStep('user_progress', () => _syncUserProgress(userId), failedSteps);
      await _runStep('user_stats', () => _syncUserStats(userId), failedSteps);
    }

    final duration = DateTime.now().difference(startedAt);
    final result = ContentSyncResult(duration: duration, failedSteps: failedSteps);

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
  ) async {
    try {
      await action();
    } catch (e, st) {
      failedSteps.add(name);
      debugPrint('SYNC: $name failed: $e\n$st');
    }
  }

  Future<void> _syncCourses() async {
    final response = await _supabase.from('courses').select();
    for (final row in response) {
      await _dbHelper.upsertCourse(row);
    }
    debugPrint('SYNC: Synced ${response.length} courses.');
  }

  Future<void> _syncVocabulary() async {
    final response = await _supabase.from('vocabulary').select();
    for (final row in response) {
      await _dbHelper.upsertVocabulary(row);
    }
    debugPrint('SYNC: Synced ${response.length} vocabulary items.');
  }

  Future<void> _syncSentences() async {
    final response = await _supabase.from('sentences').select();
    for (final row in response) {
      await _dbHelper.upsertSentence(row);
    }
    debugPrint('SYNC: Synced ${response.length} sentences.');
  }

  Future<void> _syncProfile(String userId) async {
    final profileResp =
        await _supabase.from('profiles').select().eq('id', userId).maybeSingle();

    if (profileResp != null) {
      await _dbHelper.upsertProfile(profileResp);
      debugPrint('SYNC: Synced profile for $userId.');
    }
  }

  Future<void> _syncUserProgress(String userId) async {
    final coursesResp = await _supabase.from('user_courses').select().eq('user_id', userId);

    for (final row in coursesResp) {
      await _dbHelper.upsertUserCourse(row);
    }

    final srsResp =
        await _supabase.from('user_learned_items').select().eq('user_id', userId);

    for (final row in srsResp) {
      await _dbHelper.upsertUserLearnedItem(row);
    }

    debugPrint('SYNC: Synced user progress for $userId.');
  }

  Future<void> _syncUserStats(String userId) async {
    final statsResp =
        await _supabase.from('user_stats').select().eq('user_id', userId).maybeSingle();

    if (statsResp != null) {
      await _dbHelper.upsertUserStats(statsResp);
      debugPrint('SYNC: Synced user stats for $userId.');
    }
  }
}

final contentSyncService = ContentSyncService();
