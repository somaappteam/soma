import 'dart:convert';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:shared_preferences/shared_preferences.dart';
import '../core/database/database_helper.dart';
import 'package:flutter/foundation.dart';
import 'offline_queue_repository.dart';

class QuizCache {
  static const Duration defaultMaxAge = Duration(days: 7);
  static const String _cachePrefix = 'quiz_cache';
  static const String _timePrefix = 'quiz_cache_time';

  Future<void> save(String key, List<Map<String, dynamic>> questions) async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(questions);
    await prefs.setString('$_cachePrefix:$key', encoded);
    await prefs.setInt('$_timePrefix:$key', DateTime.now().millisecondsSinceEpoch);
  }

  Future<List<Map<String, dynamic>>> load(
    String key, {
    Duration maxAge = defaultMaxAge,
    bool allowStale = false,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString('$_cachePrefix:$key');
    if (raw == null) return [];

    final ts = prefs.getInt('$_timePrefix:$key') ?? 0;
    final ageMs = DateTime.now().millisecondsSinceEpoch - ts;
    if (!allowStale && ageMs > maxAge.inMilliseconds) return [];

    try {
      final decoded = jsonDecode(raw);
      if (decoded is! List) return [];
      return decoded
          .whereType<Map>()
          .map((row) => Map<String, dynamic>.from(row))
          .toList();
    } catch (_) {
      return [];
    }
  }
}

class VocabSrsStore {
  final _supabase = Supabase.instance.client;
  final _dbHelper = DatabaseHelper.instance;
  static const List<int> _scheduleDays = [1, 3, 7, 14, 30];

  String? get _uid => _supabase.auth.currentUser?.id;

  Future<Map<int, SrsEntry>> load(String courseId) async {
    final uid = _uid;
    final localItems = await _dbHelper.getUserLearnedItems(uid ?? 'guest', courseId);
    
    final entries = <int, SrsEntry>{};
    for (final item in localItems) {
      final conceptId = _parseInt(item['concept_id']);
      final interval = _parseInt(item['interval_days']);
      final dueAtStr = item['due_at']?.toString();
      if (conceptId == null || interval == null || dueAtStr == null) continue;
      
      final dueAtMs = DateTime.parse(dueAtStr).millisecondsSinceEpoch;
      entries[conceptId] = SrsEntry(
        conceptId: conceptId,
        intervalDays: interval,
        dueAtMs: dueAtMs,
      );
    }

    return entries;
  }

  Future<void> save(String courseId, Map<int, SrsEntry> entries) async {
    final uid = _uid ?? 'guest';

    for (final entry in entries.values) {
      final item = {
        'user_id': uid,
        'course_id': courseId,
        'concept_id': entry.conceptId,
        'interval_days': entry.intervalDays,
        'due_at': DateTime.fromMillisecondsSinceEpoch(entry.dueAtMs).toIso8601String(),
      };
      await _dbHelper.upsertUserLearnedItem(item);

      if (uid != 'guest') {
        try {
          await _supabase.from('user_learned_items').upsert(item, onConflict: 'user_id, course_id, concept_id');
        } catch (e) {
          debugPrint("Cloud SRS push failed: $e. Enqueuing.");
          await offlineQueueRepository.enqueue(
            tableName: 'user_learned_items',
            operation: 'UPSERT',
            data: item,
          );
        }
      }
    }
  }

  Future<List<int>> dueConceptIds(String courseId) async {
    final entries = await load(courseId);
    if (entries.isEmpty) return [];
    final now = DateTime.now().millisecondsSinceEpoch;
    return entries.values
        .where((entry) => entry.dueAtMs <= now)
        .map((entry) => entry.conceptId)
        .toList();
  }

  Future<void> recordResult({
    required String courseId,
    required int conceptId,
    required bool correct,
  }) async {
    final entries = await load(courseId);
    final existing = entries[conceptId];

    if (!correct) {
      final interval = _scheduleDays.first;
      entries[conceptId] = SrsEntry(
        conceptId: conceptId,
        intervalDays: interval,
        dueAtMs: _dueAtMs(interval),
      );
      await save(courseId, entries);
      return;
    }

    if (existing == null) {
      final interval = _scheduleDays.first;
      entries[conceptId] = SrsEntry(
        conceptId: conceptId,
        intervalDays: interval,
        dueAtMs: _dueAtMs(interval),
      );
    } else {
      final nextInterval = _advanceInterval(existing.intervalDays);
      entries[conceptId] = SrsEntry(
        conceptId: conceptId,
        intervalDays: nextInterval,
        dueAtMs: _dueAtMs(nextInterval),
      );
    }
    
    await save(courseId, entries);
  }

  int _advanceInterval(int current) {
    final index = _scheduleDays.indexWhere((d) => d >= current);
    if (index == -1) return _scheduleDays.last;
    final nextIndex = (index + 1).clamp(0, _scheduleDays.length - 1);
    return _scheduleDays[nextIndex];
  }

  int _dueAtMs(int intervalDays) {
    return DateTime.now().add(Duration(days: intervalDays)).millisecondsSinceEpoch;
  }

  int? _parseInt(dynamic value) {
    if (value is int) return value;
    return int.tryParse(value?.toString() ?? '');
  }
}

class SrsEntry {
  final int conceptId;
  final int intervalDays;
  final int dueAtMs;

  const SrsEntry({
    required this.conceptId,
    required this.intervalDays,
    required this.dueAtMs,
  });
}
