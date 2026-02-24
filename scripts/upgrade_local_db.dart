import 'dart:io';

import 'package:path/path.dart';
import 'package:soma/core/services/app_logger.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() async {
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  final dbPath = await getDatabasesPath();
  final path = join(dbPath, 'soma_local.db');

  appLogger.info('--- Manual SQLite Upgrade ---');
  appLogger.info('Database Path: $path');

  final db = await openDatabase(path, version: 3);

  appLogger.info("\nCreating missing tables if they don't exist...");

  final sql = [
    '''
    CREATE TABLE IF NOT EXISTS user_learned_items (
      user_id TEXT,
      course_id TEXT,
      concept_id INTEGER,
      interval_days INTEGER,
      due_at TEXT,
      PRIMARY KEY (user_id, course_id, concept_id)
    )
    ''',
    '''
    CREATE TABLE IF NOT EXISTS user_courses (
      user_id TEXT,
      course_id TEXT,
      progress_xp INTEGER,
      last_accessed TEXT,
      PRIMARY KEY (user_id, course_id)
    )
    ''',
    '''
    CREATE TABLE IF NOT EXISTS user_stats (
      user_id TEXT PRIMARY KEY,
      total_wins INTEGER,
      streak_days INTEGER,
      longest_streak INTEGER,
      last_active_date TEXT,
      total_quizzes INTEGER,
      total_correct INTEGER,
      total_questions INTEGER,
      perfect_quizzes INTEGER,
      circles_joined INTEGER,
      updated_at TEXT
    )
    ''',
    '''
    CREATE TABLE IF NOT EXISTS profiles (
      id TEXT PRIMARY KEY,
      display_name TEXT,
      username TEXT,
      bio TEXT,
      location TEXT,
      daily_goal_minutes INTEGER,
      total_xp INTEGER,
      avatar_url TEXT,
      updated_at TEXT
    )
    '''
  ];

  for (final query in sql) {
    await db.execute(query);
  }

  appLogger.info('\nVerification...');
  final tables = [
    'courses',
    'vocabulary',
    'sentences',
    'profiles',
    'user_stats',
    'user_courses',
    'user_learned_items'
  ];
  for (final table in tables) {
    final res = await db.rawQuery(
        "SELECT name FROM sqlite_master WHERE type='table' AND name='$table'");
    if (res.isNotEmpty) {
      appLogger.info("[OK] Table '$table' successfully provisioned.");
    } else {
      appLogger.info("[FAIL] Table '$table' still missing!");
    }
  }

  await db.close();
  appLogger.info('\n--- Upgrade Complete ---');
  exit(0);
}
