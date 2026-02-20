import 'dart:io';
import 'dart:convert';
import 'package:supabase/supabase.dart';
import 'package:csv/csv.dart';

const String supabaseUrl = 'https://bnbjteedohflgkarfaxk.supabase.co';
const String serviceRoleKey =
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImJuYmp0ZWVkb2hmbGdrYXJmYXhrIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc2OTcwMDI2NCwiZXhwIjoyMDg1Mjc2MjY0fQ.jTZOgpQ7Fy1HlUT0YldRAtr6Bvwti_Al1hfaP5Bz0Nc';

void main() async {
  final client = SupabaseClient(supabaseUrl, serviceRoleKey);

  print('--- Starting Data Migration (Fix EOL) ---');

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
      // Try \n as EOL. If that fails, we might need to inspect the file.
      .transform(const CsvToListConverter(eol: '\n'))
      .toList();

  print('Parsed ${fields.length} rows from vocabulary CSV.');

  if (fields.isEmpty) return;

  final rawHeaders = fields[0];
  // print('Vocabulary Headers found: $rawHeaders');
  
  final headers = <int, String>{};
  for (var j = 0; j < rawHeaders.length; j++) {
    final key = rawHeaders[j].toString().trim();
    // Headers: vocabulary_id, concept_id, lang_code, word, article, pronunciation, level
    if (key.isNotEmpty) {
      headers[j] = key;
    }
  }

  // print('Mapped headers: $headers');

  final data = <Map<String, dynamic>>[];

  // Skip header row
  for (var i = 1; i < fields.length; i++) {
    final values = fields[i];
    final row = <String, dynamic>{};

    headers.forEach((index, key) {
      if (index < values.length) {
        // if (index < 0 || index >= values.length) return; // Safety check
        var val = values[index];
        // Parse integer/bigint columns
        if (key == 'concept_id' || key == 'vocabulary_id') {
          if (val is int) {
            row[key] = val;
          } else {
            row[key] = int.tryParse(val.toString().trim());
          }
        } else {
          row[key] = val.toString().trim().isEmpty ? null : val.toString().trim();
        }
      }
    });

    if (row.isNotEmpty) {
      data.add(row);
    }
    
    if (i % 5000 == 0) print('Processed $i rows locally...');

    if (data.length >= 1000) { // Batch 1000
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
      .transform(const CsvToListConverter(eol: '\n'))
      .toList();
      
  print('Parsed ${fields.length} rows from sentences CSV.');

  if (fields.isEmpty) return;

  final rawHeaders = fields[0];
  // print('Sentences Headers found: $rawHeaders');

  final headers = <int, String>{};
  for (var j = 0; j < rawHeaders.length; j++) {
    final key = rawHeaders[j].toString().trim();
    // Headers: sentence_id, concept_id, lang_code, sentence, pronunciation, level
    if (key.isNotEmpty) {
      headers[j] = key;
    }
  }
  
  // print('Mapped headers: $headers');

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
          row[key] = val.toString().trim().isEmpty ? null : val.toString().trim();
        }
      }
    });

    if (row.isNotEmpty) {
      data.add(row);
    }
    
    if (i % 5000 == 0) print('Processed $i rows locally...');

    if (data.length >= 1000) {
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
    // Use upsert on PK to handle existing rows if running multiple times
    await client.from(table).upsert(data); 
    // print('  Upserted ${data.length} rows to $table');
  } catch (e) {
    print('Error upserting to $table: $e');
    
    // If batch fails, try one by one to find the problematic row
    int success = 0;
    int failed = 0;
    for (final row in data) {
      try {
        await client.from(table).upsert(row);
        success++;
      } catch (e2) {
        failed++;
        if (failed <= 3) {
          print('  Failed row: $row');
          print('  Error: $e2');
        }
      }
    }
    print('  Individual upsert: $success succeeded, $failed failed');
  }
}
