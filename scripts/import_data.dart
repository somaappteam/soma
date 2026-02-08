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

  await migrateVocabulary(client);
  await migrateSentences(client);

  print('--- Migration Completed ---');
}

Future<void> migrateVocabulary(SupabaseClient client) async {
  print('Migrating Vocabulary...');
  final file = File('C:/Users/amosl/Desktop/vocabulary .csv');
  if (!await file.exists()) {
    print('Vocabulary CSV not found!');
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
    if (key.isNotEmpty && key != 'voca_id') {
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
        if (key == 'concept_id') {
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

Future<void> migrateSentences(SupabaseClient client) async {
  print('Migrating Sentences...');
  final file = File('C:/Users/amosl/Desktop/sentences .csv');
  if (!await file.exists()) {
    print('Sentences CSV not found!');
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
    if (key.isNotEmpty && key != 'sentence_id') {
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
        if (key == 'concept_id') {
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
  try {
    await client.from(table).upsert(data);
  } catch (e) {
    print('Error upserting to $table: $e');
  }
}
