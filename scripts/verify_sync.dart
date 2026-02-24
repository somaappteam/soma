import 'dart:io';

import 'package:soma/core/database/database_helper.dart';
import 'package:soma/core/services/app_logger.dart';
import 'package:soma/data/content_sync_service.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  // Setup FFI for Windows
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  appLogger.info('--- Comprehensive Sync Verification ---');

  await Supabase.initialize(
    url: 'https://bnbjteedohflgkarfaxk.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImJuYmp0ZWVkb2hmbGdrYXJmYXhrIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Njk3MDAyNjQsImV4cCI6MjA4NTI3NjI2NH0.m8ua_6P0AtykUgLbLuxeE3o3i4Dwfw_xPsvODORlKtM',
  );

  final dbHelper = DatabaseHelper.instance;
  final db = await dbHelper.database;

  appLogger.info('\n1. Verifying Table Presence...');
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
    try {
      final res = await db.rawQuery(
          "SELECT name FROM sqlite_master WHERE type='table' AND name='$table'");
      if (res.isNotEmpty) {
        appLogger.info("[OK] Table '$table' exists.");
      } else {
        appLogger.info("[FAIL] Table '$table' MISSING.");
      }
    } catch (e) {
      appLogger.info("[ERROR] Failed to check table '$table': $e");
    }
  }

  appLogger.info('\n2. Checking Data Counts Before Sync...');
  await _printCounts(db);

  appLogger.info('\n3. Running Content Sync (Public Content)...');
  try {
    await contentSyncService.syncEverything();
    appLogger.info('Sync successful!');
  } catch (e) {
    appLogger.info('Sync failed: $e');
  }

  appLogger.info('\n4. Checking Data Counts After Sync...');
  await _printCounts(db);

  appLogger.info('\n5. Verifying Repository Integrations (Dummy Check)...');
  // This is a simple check to see if we can query some tables
  try {
    final courses = await dbHelper.getAllCourses();
    appLogger.info('Retrieved ${courses.length} courses via DatabaseHelper.');
  } catch (e) {
    appLogger.info('Error querying DatabaseHelper: $e');
  }

  appLogger.info('\n--- Verification Complete ---');
  exit(0);
}

Future<void> _printCounts(final Database db) async {
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
    try {
      final count = Sqflite.firstIntValue(
              await db.rawQuery('SELECT COUNT(*) FROM $table')) ??
          0;
      appLogger.info("Table '$table' count: $count");
    } catch (e) {
      appLogger.info("Could not count '$table': $e");
    }
  }
}
