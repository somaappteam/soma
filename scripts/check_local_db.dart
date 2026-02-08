import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path/path.dart';
import 'dart:io';
import 'package:soma/core/database/database_helper.dart';

void main() async {
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  print("--- SQLite Database Health Check (Version 3) ---");

  final dbHelper = DatabaseHelper.instance;

  // This call will trigger _initDB -> openDatabase -> _onUpgrade
  final db = await dbHelper.database;

  final path = join(await getDatabasesPath(), 'soma_local.db');
  print("Database Path: $path");

  final tables = [
    'courses',
    'vocabulary',
    'sentences',
    'profiles',
    'user_stats',
    'user_courses',
    'user_learned_items'
  ];

  print("\nChecking tables...");
  for (final table in tables) {
    final res = await db.rawQuery(
        "SELECT name FROM sqlite_master WHERE type='table' AND name='$table'");
    if (res.isNotEmpty) {
      final countRes =
          await db.rawQuery("SELECT COUNT(*) as count FROM $table");
      final count = countRes.first['count'];
      print("[OK] Table '$table' exists. Count: $count");
    } else {
      print("[FAIL] Table '$table' is MISSING.");
    }
  }

  await db.close();
  print("\n--- Check Complete ---");
  exit(0);
}
