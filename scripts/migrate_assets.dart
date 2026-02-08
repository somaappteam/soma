import 'dart:io';
import 'dart:convert';
import 'package:supabase/supabase.dart';
import 'package:csv/csv.dart';

const String supabaseUrl = 'https://bnbjteedohflgkarfaxk.supabase.co';
const String serviceRoleKey =
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImJuYmp0ZWVkb2hmbGdrYXJmYXhrIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc2OTcwMDI2NCwiZXhwIjoyMDg1Mjc2MjY0fQ.jTZOgpQ7Fy1HlUT0YldRAtr6Bvwti_Al1hfaP5Bz0Nc';

void main() async {
  final client = SupabaseClient(supabaseUrl, serviceRoleKey);

  print('--- Starting Data Migration ---');

  // Adjust these paths if running from a different directory
  final assetsDir = Directory('assets');
  if (!assetsDir.existsSync()) {
    print('Error: assets directory not found in current working directory.');
    print('Current directory: ${Directory.current.path}');
    return;
  }

  await migrateVocabulary(client, 'assets/vocabulary.csv');
  await migrateSentences(client, 'assets/sentences.csv');

  print('--- Migration Completed ---');
}

Future<void> migrateVocabulary(SupabaseClient client, String filePath) async {
  print('Migrating Vocabulary from $filePath...');
  final file = File(filePath);
  if (!await file.exists()) {
    print('Vocabulary CSV not found at $filePath!');
    return;
  }

  final input = file.openRead();
  final fields = await input
      .transform(utf8.decoder)
      .transform(const CsvToListConverter())
      .toList();

  if (fields.isEmpty) return;

  final rawHeaders = fields[0];
  final headers = <int, String>{};
  for (var j = 0; j < rawHeaders.length; j++) {
    final key = rawHeaders[j].toString().trim();
    // Include all columns including voca_id as PK
    if (key.isNotEmpty) {
      headers[j] = key;
    }
  }

  final data = <Map<String, dynamic>>[];

  // Skip header row
  for (var i = 1; i < fields.length; i++) {
    final values = fields[i];
    final row = <String, dynamic>{};

    headers.forEach((index, key) {
      if (index < values.length) {
        var val = values[index];
        // Parse integer columns
        if (key == 'concept_id' || key == 'voca_id') {
          if (val is int) {
            row[key] = val;
          } else {
            row[key] = int.tryParse(val.toString().trim());
          }
        } else {
          row[key] = val.toString().trim().isEmpty ? null : val;
        }
      }
    });

    if (row.isNotEmpty) {
      data.add(row);
    }

    if (data.length >= 500) {
      await _upsert(client, 'vocabulary', data);
      data.clear();
      print('Uploaded vocabulary up to row $i...');
    }
  }

  if (data.isNotEmpty) {
    await _upsert(client, 'vocabulary', data);
  }
  print('Vocabulary migration done.');
}

Future<void> migrateSentences(SupabaseClient client, String filePath) async {
  print('Migrating Sentences from $filePath...');
  final file = File(filePath);
  if (!await file.exists()) {
    print('Sentences CSV not found at $filePath!');
    return;
  }

  final input = file.openRead();
  final fields = await input
      .transform(utf8.decoder)
      .transform(const CsvToListConverter())
      .toList();

  if (fields.isEmpty) return;

  final rawHeaders = fields[0];
  final headers = <int, String>{};
  for (var j = 0; j < rawHeaders.length; j++) {
    final key = rawHeaders[j].toString().trim();
    // Include all columns including sentence_id as PK
    if (key.isNotEmpty) {
      headers[j] = key;
    }
  }

  final data = <Map<String, dynamic>>[];

  for (var i = 1; i < fields.length; i++) {
    final values = fields[i];
    final row = <String, dynamic>{};

    headers.forEach((index, key) {
      if (index < values.length) {
        var val = values[index];
        // Parse integer columns
        if (key == 'concept_id' || key == 'sentence_id') {
          if (val is int) {
            row[key] = val;
          } else {
            row[key] = int.tryParse(val.toString().trim());
          }
        } else {
          row[key] = val.toString().trim().isEmpty ? null : val;
        }
      }
    });

    if (row.isNotEmpty) {
      data.add(row);
    }

    if (data.length >= 500) {
      await _upsert(client, 'sentences', data);
      data.clear();
      print('Uploaded sentences up to row $i...');
    }
  }

  if (data.isNotEmpty) {
    await _upsert(client, 'sentences', data);
  }
  print('Sentences migration done.');
}

Future<void> _upsert(SupabaseClient client, String table,
    List<Map<String, dynamic>> data) async {
  if (data.isEmpty) return;
  
  try {
    // Use simple insert - table should be empty or use upsert on PK
    await client.from(table).insert(data);
    print('  Inserted ${data.length} rows to $table');
  } catch (e) {
    print('Error inserting to $table: $e');
    
    // If batch fails, try one by one to find the problematic row
    int success = 0;
    int failed = 0;
    for (final row in data) {
      try {
        await client.from(table).insert(row);
        success++;
      } catch (e2) {
        failed++;
        if (failed <= 3) {
          print('  Failed row: $row');
          print('  Error: $e2');
        }
      }
    }
    print('  Individual insert: $success succeeded, $failed failed');
  }
}
