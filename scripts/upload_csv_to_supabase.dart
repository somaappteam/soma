import 'dart:io';

import 'package:csv/csv.dart';
import 'package:soma/core/services/app_logger.dart';
import 'package:supabase/supabase.dart';

const String supabaseUrl = 'https://bnbjteedohflgkarfaxk.supabase.co';
const String serviceRoleKey =
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImJuYmp0ZWVkb2hmbGdrYXJmYXhrIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc2OTcwMDI2NCwiZXhwIjoyMDg1Mjc2MjY0fQ.jTZOgpQ7Fy1HlUT0YldRAtr6Bvwti_Al1hfaP5Bz0Nc';

Future<void> main() async {
  appLogger.info('--- Starting CSV to Supabase Migration (REST) ---');

  final client = SupabaseClient(supabaseUrl, serviceRoleKey);

  try {
    // 1. Migrate Vocabulary
    await _migrateVocabulary(client);

    // 2. Migrate Sentences
    await _migrateSentences(client);

    appLogger.info('\nMigration completed successfully!');
  } catch (e) {
    appLogger.info('\nError during migration: $e');
  }
}

Future<void> _migrateVocabulary(final SupabaseClient client) async {
  final file = File('assets/vocabulary.csv');
  if (!await file.exists()) {
    appLogger.info('Vocabulary CSV not found!');
    return;
  }

  appLogger.info('Processing Vocabulary...');
  final csvData = await file.readAsString();
  final rows = const CsvToListConverter().convert(csvData);
  appLogger.info(
      'Parsed ${rows.length} vocabulary rows. First row: ${rows.isNotEmpty ? rows.first : "empty"}');

  if (rows.isEmpty) return;
  final dataRows = rows.skip(1).toList();

  appLogger.info('Deleting old vocabulary data...');
  try {
    await client.from('vocabulary').delete().neq('voca_id', -1);
  } catch (e) {
    appLogger
        .info('Note: Delete failed (maybe table empty or policy issues): $e');
  }

  appLogger.info('Inserting ${dataRows.length} vocabulary rows...');
  const chunkSize = 100;
  for (var i = 0; i < dataRows.length; i += chunkSize) {
    appLogger.info('Processing chunk $i to ${i + chunkSize}...');
    final chunk = dataRows.sublist(
        i, i + chunkSize > dataRows.length ? dataRows.length : i + chunkSize);

    final maps = chunk
        .map((final row) {
          if (row.length < 10) return null;
          return {
            'voca_id': row[0],
            'concept_id': row[1],
            'lang': row[2],
            'word': row[3],
            'article': row[4],
            'gender': row[5],
            'romanization': row[6],
            'pinyin': row[7],
            'transliteration': row[8],
            'level': row[9],
          };
        })
        .whereType<Map<String, dynamic>>()
        .toList();

    if (maps.isNotEmpty) {
      await client.from('vocabulary').insert(maps);
    }
  }
  appLogger.info('\nVocabulary migration done.');
}

Future<void> _migrateSentences(final SupabaseClient client) async {
  final file = File('assets/sentences.csv');
  if (!await file.exists()) {
    appLogger.info('Sentences CSV not found!');
    return;
  }

  appLogger.info('Processing Sentences...');
  final csvData = await file.readAsString();
  final rows = const CsvToListConverter().convert(csvData);
  appLogger.info(
      'Parsed ${rows.length} sentence rows. First row: ${rows.isNotEmpty ? rows.first : "empty"}');

  if (rows.isEmpty) return;
  final dataRows = rows.skip(1).toList();

  appLogger.info('Deleting old sentences data...');
  try {
    await client.from('sentences').delete().neq('sentence_id', -1);
  } catch (e) {
    appLogger.info('Note: Delete failed: $e');
  }

  appLogger.info('Inserting ${dataRows.length} sentence rows...');
  const chunkSize = 100;
  for (var i = 0; i < dataRows.length; i += chunkSize) {
    appLogger.info('Processing chunk $i to ${i + chunkSize}...');
    final chunk = dataRows.sublist(
        i, i + chunkSize > dataRows.length ? dataRows.length : i + chunkSize);

    final maps = chunk
        .map((final row) {
          if (row.length < 9) return null;
          return {
            'sentence_id': row[0],
            'concept_id': row[1],
            'lang_code': row[2],
            'lang_name': row[3],
            'sentence': row[4],
            'romanization': row[5],
            'pinyin': row[6],
            'transliteration': row[7],
            'level': row[8],
          };
        })
        .whereType<Map<String, dynamic>>()
        .toList();

    if (maps.isNotEmpty) {
      await client.from('sentences').insert(maps);
    }
  }
  appLogger.info('\nSentences migration done.');
}
