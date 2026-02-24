import 'dart:io';

import 'package:soma/core/services/app_logger.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Run SQL to add questions column to circles table
void main() async {
  appLogger.info('🔧 Adding questions column to circles table...\n');

  // Read Supabase URL and key from config
  final configFile = File('lib/core/config/supabase_config.dart');
  if (!configFile.existsSync()) {
    appLogger.info('❌ Config file not found');
    exit(1);
  }

  final configContent = await configFile.readAsString();
  final urlMatch = RegExp(r"supabaseUrl = '([^']+)'").firstMatch(configContent);
  final keyMatch =
      RegExp(r"supabaseAnonKey = '([^']+)'").firstMatch(configContent);

  if (urlMatch == null || keyMatch == null) {
    appLogger.info('❌ Could not extract Supabase credentials from config');
    exit(1);
  }

  final url = urlMatch.group(1)!;
  final key = keyMatch.group(1)!;

  appLogger.info('Connecting to Supabase...');
  await Supabase.initialize(url: url, anonKey: key);

  final supabase = Supabase.instance.client;

  try {
    // First, check if column exists
    appLogger.info('\nChecking if questions column exists...');
    final existingCircle = await supabase
        .from('circles')
        .select('id, name, questions')
        .limit(1)
        .maybeSingle();

    if (existingCircle != null && existingCircle.containsKey('questions')) {
      appLogger.info('✅ Questions column already exists!');
      appLogger.info('   Sample data: ${existingCircle['questions']}');
      exit(0);
    }
  } catch (e) {
    appLogger.info('   Column does not exist yet (expected): $e');
  }

  appLogger.info(
      '\n❌ Cannot add column from Dart client - need database admin access\n');
  appLogger.info('Please run this SQL in Supabase Dashboard SQL Editor:');
  appLogger
      .info('┌────────────────────────────────────────────────────────────┐');
  appLogger
      .info('│ ALTER TABLE public.circles                                │');
  appLogger
      .info('│ ADD COLUMN IF NOT EXISTS questions JSONB                  │');
  appLogger
      .info('│ DEFAULT \'[]\'::jsonb;                                      │');
  appLogger
      .info('└────────────────────────────────────────────────────────────┘');
  appLogger.info(
      '\nDashboard URL: ${url.replaceAll('.supabase.co', '.supabase.co/project/_/sql')}');
}
