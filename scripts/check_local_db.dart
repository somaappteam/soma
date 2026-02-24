import 'dart:io';

import 'package:path/path.dart';
import 'package:soma/core/database/database_helper.dart';
import 'package:soma/core/services/app_logger.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() async {
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  appLogger.info('--- SQLite Database Health Check (Version 3) ---');

  final dbHelper = DatabaseHelper.instance;

  // This call will trigger _initDB -> openDatabase -> _onUpgrade
  final db = await dbHelper.database;

  final path = join(await getDatabasesPath(), 'soma_local.db');
  appLogger.info('Database Path: $path');

  final tables = [
    'courses',
    'vocabulary',
    'sentences',
    'profiles',
    'user_stats',
    'user_courses',
    'user_learned_items'
  ];

  appLogger.info('\nChecking tables...');
  for (final table in tables) {
    final res = await db.rawQuery(
        "SELECT name FROM sqlite_master WHERE type='table' AND name='$table'");
    if (res.isNotEmpty) {
      final countRes =
          await db.rawQuery('SELECT COUNT(*) as count FROM $table');
      final count = countRes.first['count'];
      appLogger.info("[OK] Table '$table' exists. Count: $count");
    } else {
      appLogger.info("[FAIL] Table '$table' is MISSING.");
    }
  }

  await db.close();
  appLogger.info('\n--- Check Complete ---');
  exit(0);
}
