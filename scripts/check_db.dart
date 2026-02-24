import 'dart:io';

import 'package:soma/core/services/app_logger.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() async {
  sqfliteFfiInit();
  final databaseFactory = databaseFactoryFfi;
  final dbPath = 'soma_local.db';

  if (!await File(dbPath).exists()) {
    appLogger.info('Database file not found at $dbPath');
    return;
  }

  final db = await databaseFactory.openDatabase(dbPath);

  Future<void> countTable(final String table) async {
    try {
      final res = await db.rawQuery('SELECT COUNT(*) as count FROM $table');
      appLogger.info('$table count: ${res.first['count']}');
    } catch (e) {
      appLogger.info('Error counting $table: $e');
    }
  }

  await countTable('courses');
  await countTable('vocabulary');
  await countTable('sentences');
  await countTable('user_learned_items');
  await countTable('profiles');

  appLogger.info('\n--- Vocabulary by Language ---');
  try {
    final res = await db.rawQuery(
        'SELECT lang_code, COUNT(*) as count FROM vocabulary GROUP BY lang_code');
    for (var row in res) {
      appLogger.info('${row['lang_code']}: ${row['count']}');
    }
  } catch (e) {
    appLogger.info('Error grouping vocabulary: $e');
  }

  await db.close();
}
