import 'package:soma/core/database/database_helper.dart';
import 'package:soma/core/services/app_logger.dart';
import 'package:soma/data/offline_queue_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// QuizCache has been removed in favor of SQLite local storage in DatabaseHelper

/// SM-2 Spaced Repetition System implementation.
///
/// Algorithm:
///   - First correct answer  → interval = 1 day
///   - Second correct answer → interval = 6 days
///   - Subsequent correct    → interval = round(prev_interval × ease_factor)
///   - Correct answer        → ease_factor += 0.1
///   - Wrong answer          → interval resets to 1 day, ease_factor -= 0.2 (min 1.3)
class VocabSrsStore {
  final _supabase = Supabase.instance.client;
  final _dbHelper = DatabaseHelper.instance;

  static const int _firstInterval = 1;
  static const int _secondInterval = 6;
  static const double _defaultEase = 2.5;
  static const double _minEase = 1.3;

  String? get _uid => _supabase.auth.currentUser?.id;

  Future<Map<int, SrsEntry>> load(final String courseId) async {
    final uid = _uid;
    final localItems =
        await _dbHelper.getUserLearnedItems(uid ?? 'guest', courseId);

    final entries = <int, SrsEntry>{};
    for (final item in localItems) {
      final conceptId = _parseInt(item['concept_id']);
      final interval = _parseInt(item['interval_days']);
      final dueAtStr = item['due_at']?.toString();
      if (conceptId == null || interval == null || dueAtStr == null) continue;

      final dueAtMs = DateTime.parse(dueAtStr).millisecondsSinceEpoch;
      final rawEase = item['ease_factor'];
      final easeFactor = (rawEase is num)
          ? rawEase.toDouble()
          : (double.tryParse(rawEase?.toString() ?? '') ?? _defaultEase);

      entries[conceptId] = SrsEntry(
        conceptId: conceptId,
        intervalDays: interval,
        dueAtMs: dueAtMs,
        easeFactor: easeFactor,
      );
    }

    return entries;
  }

  Future<void> save(
      final String courseId, final Map<int, SrsEntry> entries) async {
    final uid = _uid ?? 'guest';

    for (final entry in entries.values) {
      final item = {
        'user_id': uid,
        'course_id': courseId,
        'concept_id': entry.conceptId,
        'interval_days': entry.intervalDays,
        'ease_factor': entry.easeFactor,
        'due_at': DateTime.fromMillisecondsSinceEpoch(entry.dueAtMs)
            .toIso8601String(),
      };
      await _dbHelper.upsertUserLearnedItem(item);

      if (uid != 'guest') {
        try {
          await _supabase
              .from('user_learned_items')
              .upsert(item, onConflict: 'user_id, course_id, concept_id');
        } catch (e) {
          appLogger.debug('Cloud SRS push failed: $e. Enqueuing.');
          await offlineQueueRepository.enqueue(
            tableName: 'user_learned_items',
            operation: 'UPSERT',
            data: item,
          );
        }
      }
    }
  }

  Future<List<int>> dueConceptIds(final String courseId) async {
    final entries = await load(courseId);
    if (entries.isEmpty) return [];
    final now = DateTime.now().millisecondsSinceEpoch;
    return entries.values
        .where((final entry) => entry.dueAtMs <= now)
        .map((final entry) => entry.conceptId)
        .toList();
  }

  Future<void> recordResult({
    required final String courseId,
    required final int conceptId,
    required final bool correct,
  }) async {
    final entries = await load(courseId);
    final existing = entries[conceptId];

    if (!correct) {
      // SM-2: wrong answer resets interval to 1, reduces ease factor.
      final oldEase = existing?.easeFactor ?? _defaultEase;
      final newEase = (oldEase - 0.2).clamp(_minEase, double.infinity);
      entries[conceptId] = SrsEntry(
        conceptId: conceptId,
        intervalDays: _firstInterval,
        dueAtMs: _dueAtMs(_firstInterval),
        easeFactor: newEase,
      );
      await save(courseId, entries);
      return;
    }

    // SM-2: correct answer — compute next interval.
    if (existing == null) {
      // Brand new card: first correct → 1 day.
      entries[conceptId] = SrsEntry(
        conceptId: conceptId,
        intervalDays: _firstInterval,
        dueAtMs: _dueAtMs(_firstInterval),
        easeFactor: _defaultEase,
      );
    } else if (existing.intervalDays <= _firstInterval) {
      // Second correct answer → 6 days (SM-2 step 2).
      final newEase =
          (existing.easeFactor + 0.1).clamp(_minEase, double.infinity);
      entries[conceptId] = SrsEntry(
        conceptId: conceptId,
        intervalDays: _secondInterval,
        dueAtMs: _dueAtMs(_secondInterval),
        easeFactor: newEase,
      );
    } else {
      // Subsequent correct → multiply by ease factor.
      final newEase =
          (existing.easeFactor + 0.1).clamp(_minEase, double.infinity);
      final newInterval =
          (existing.intervalDays * newEase).round().clamp(1, 365);
      entries[conceptId] = SrsEntry(
        conceptId: conceptId,
        intervalDays: newInterval,
        dueAtMs: _dueAtMs(newInterval),
        easeFactor: newEase,
      );
    }

    await save(courseId, entries);
  }

  int _dueAtMs(final int intervalDays) {
    return DateTime.now()
        .add(Duration(days: intervalDays))
        .millisecondsSinceEpoch;
  }

  int? _parseInt(final dynamic value) {
    if (value is int) return value;
    return int.tryParse(value?.toString() ?? '');
  }
}

class SrsEntry {
  final int conceptId;
  final int intervalDays;
  final int dueAtMs;

  /// SM-2 ease factor — controls interval growth speed on correct answers.
  /// Default: 2.5 (SM-2 spec). Minimum: 1.3.
  final double easeFactor;

  const SrsEntry({
    required this.conceptId,
    required this.intervalDays,
    required this.dueAtMs,
    this.easeFactor = 2.5,
  });
}
