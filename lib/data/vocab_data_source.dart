import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../data/csv_service.dart';
import '../core/database/database_helper.dart';

// ─── Abstract interface ───────────────────────────────────────────────────────

/// Strategy interface for fetching raw vocabulary rows.
///
/// Each implementation returns a list of maps in the same shape that
/// [QuizRepository] understands, keeping the repository's selection /
/// shuffling / SRS logic entirely unchanged.
abstract class VocabDataSource {
  /// Fetch vocabulary rows for [sourceLang] and [targetLang].
  ///
  /// Returns a record of `(sourceRows, targetRows)`.
  Future<({List<Map<String, dynamic>> source, List<Map<String, dynamic>> target})>
      fetchVocab({
    required String sourceLang,
    required String targetLang,
    int limit = 1000,
  });
}

// ─── CSV / SQLite implementation ─────────────────────────────────────────────

/// Reads vocabulary from the bundled CSV files (works offline).
class CsvVocabDataSource implements VocabDataSource {
  const CsvVocabDataSource();

  @override
  Future<({List<Map<String, dynamic>> source, List<Map<String, dynamic>> target})>
      fetchVocab({
    required String sourceLang,
    required String targetLang,
    int limit = 1000,
  }) async {
    final csv = CsvService.instance;
    final sourceRows = await csv.getVocabularyByLang(sourceLang);
    final targetRows = await csv.getVocabularyByLang(targetLang);

    List<Map<String, dynamic>> toMapList(dynamic rows) {
      if (rows is! List) return [];
      return rows
          .whereType<Map>()
          .map((r) => Map<String, dynamic>.from(r))
          .toList();
    }

    return (source: toMapList(sourceRows), target: toMapList(targetRows));
  }
}

// ─── Supabase implementation ──────────────────────────────────────────────────

/// Reads vocabulary directly from the Supabase `vocabulary` table.
/// Used for live circle sessions where the host picks questions from the cloud.
class SupabaseVocabDataSource implements VocabDataSource {
  const SupabaseVocabDataSource();

  @override
  Future<({List<Map<String, dynamic>> source, List<Map<String, dynamic>> target})>
      fetchVocab({
    required String sourceLang,
    required String targetLang,
    int limit = 1000,
  }) async {
    final client = Supabase.instance.client;

    final results = await Future.wait([
      client.from('vocabulary').select().eq('lang_code', sourceLang).limit(limit),
      client.from('vocabulary').select().eq('lang_code', targetLang).limit(limit),
    ]);

    final sourceRows = List<Map<String, dynamic>>.from(results[0] as List);
    final targetRows = List<Map<String, dynamic>>.from(results[1] as List);

    debugPrint(
        'SupabaseVocabDataSource: source(${sourceRows.length}) target(${targetRows.length})');

    return (source: sourceRows, target: targetRows);
  }
}

// ─── SQLite implementation ────────────────────────────────────────────────────

/// Reads vocabulary from the local SQLite database.
class SqliteVocabDataSource implements VocabDataSource {
  const SqliteVocabDataSource();

  @override
  Future<({List<Map<String, dynamic>> source, List<Map<String, dynamic>> target})>
      fetchVocab({
    required String sourceLang,
    required String targetLang,
    int limit = 1000,
  }) async {
    final dbHelper = DatabaseHelper.instance;
    final sourceRows = await dbHelper.getVocabularyByLang(sourceLang);
    final targetRows = await dbHelper.getVocabularyByLang(targetLang);

    // SQLite returns List<Map<String, Object?>>, we cast to dynamic
    List<Map<String, dynamic>> toMapList(List<Map<String, dynamic>> rows) {
      return rows.map((r) => Map<String, dynamic>.from(r)).toList();
    }

    return (source: toMapList(sourceRows), target: toMapList(targetRows));
  }
}

// ─── Sentence data sources ────────────────────────────────────────────────────

abstract class SentenceDataSource {
  Future<({List<Map<String, dynamic>> source, List<Map<String, dynamic>> target})>
      fetchSentences({
    required String sourceLang,
    required String targetLang,
    int limit = 1000,
  });
}

class CsvSentenceDataSource implements SentenceDataSource {
  const CsvSentenceDataSource();

  @override
  Future<({List<Map<String, dynamic>> source, List<Map<String, dynamic>> target})>
      fetchSentences({
    required String sourceLang,
    required String targetLang,
    int limit = 1000,
  }) async {
    final csv = CsvService.instance;
    final sourceRows = await csv.getSentencesByLang(sourceLang);
    final targetRows = await csv.getSentencesByLang(targetLang);

    List<Map<String, dynamic>> toMapList(dynamic rows) {
      if (rows is! List) return [];
      return rows
          .whereType<Map>()
          .map((r) => Map<String, dynamic>.from(r))
          .toList();
    }

    return (source: toMapList(sourceRows), target: toMapList(targetRows));
  }
}

class SqliteSentenceDataSource implements SentenceDataSource {
  const SqliteSentenceDataSource();

  @override
  Future<({List<Map<String, dynamic>> source, List<Map<String, dynamic>> target})>
      fetchSentences({
    required String sourceLang,
    required String targetLang,
    int limit = 1000,
  }) async {
    final dbHelper = DatabaseHelper.instance;
    final sourceRows = await dbHelper.getSentencesByLang(sourceLang);
    final targetRows = await dbHelper.getSentencesByLang(targetLang);

    // SQLite returns List<Map<String, Object?>>, we cast to dynamic
    List<Map<String, dynamic>> toMapList(List<Map<String, dynamic>> rows) {
      return rows.map((r) => Map<String, dynamic>.from(r)).toList();
    }

    return (source: toMapList(sourceRows), target: toMapList(targetRows));
  }
}
