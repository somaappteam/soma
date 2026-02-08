import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:soma/data/content_sync_service.dart';
import 'package:soma/core/database/database_helper.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io';

void main() async {
  // Setup FFI for Windows
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  print("--- Comprehensive Sync Verification ---");

  await Supabase.initialize(
    url: 'https://bnbjteedohflgkarfaxk.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImJuYmp0ZWVkb2hmbGdrYXJmYXhrIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Njk3MDAyNjQsImV4cCI6MjA4NTI3NjI2NH0.m8ua_6P0AtykUgLbLuxeE3o3i4Dwfw_xPsvODORlKtM',
  );

  final dbHelper = DatabaseHelper.instance;
  final db = await dbHelper.database;

  print("\n1. Verifying Table Presence...");
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
        print("[OK] Table '$table' exists.");
      } else {
        print("[FAIL] Table '$table' MISSING.");
      }
    } catch (e) {
      print("[ERROR] Failed to check table '$table': $e");
    }
  }

  print("\n2. Checking Data Counts Before Sync...");
  await _printCounts(db);

  print("\n3. Running Content Sync (Public Content)...");
  try {
    await contentSyncService.syncEverything();
    print("Sync successful!");
  } catch (e) {
    print("Sync failed: $e");
  }

  print("\n4. Checking Data Counts After Sync...");
  await _printCounts(db);

  print("\n5. Verifying Repository Integrations (Dummy Check)...");
  // This is a simple check to see if we can query some tables
  try {
    final courses = await dbHelper.getAllCourses();
    print("Retrieved ${courses.length} courses via DatabaseHelper.");
  } catch (e) {
    print("Error querying DatabaseHelper: $e");
  }

  print("\n--- Verification Complete ---");
  exit(0);
}

Future<void> _printCounts(Database db) async {
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
      print("Table '$table' count: $count");
    } catch (e) {
      print("Could not count '$table': $e");
    }
  }
}
