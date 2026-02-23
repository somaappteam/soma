
import 'dart:io';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() async {
  sqfliteFfiInit();
  final databaseFactory = databaseFactoryFfi;
  final dbPath = 'soma_local.db';

  if (!await File(dbPath).exists()) {
    print('Database file not found at $dbPath');
    return;
  }

  final db = await databaseFactory.openDatabase(dbPath);

  Future<void> countTable(String table) async {
    try {
      final res = await db.rawQuery('SELECT COUNT(*) as count FROM $table');
      print('$table count: ${res.first['count']}');
    } catch (e) {
      print('Error counting $table: $e');
    }
  }

  await countTable('courses');
  await countTable('vocabulary');
  await countTable('sentences');
  await countTable('user_learned_items');
  await countTable('profiles');

  print('\n--- Vocabulary by Language ---');
  try {
    final res = await db.rawQuery('SELECT lang_code, COUNT(*) as count FROM vocabulary GROUP BY lang_code');
    for (var row in res) {
      print('${row['lang_code']}: ${row['count']}');
    }
  } catch (e) {
    print('Error grouping vocabulary: $e');
  }

  await db.close();
}
