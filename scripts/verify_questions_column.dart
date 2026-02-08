import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:io';

/// Run SQL to add questions column to circles table
void main() async {
  print('🔧 Adding questions column to circles table...\n');
  
  // Read Supabase URL and key from config
  final configFile = File('lib/core/config/supabase_config.dart');
  if (!configFile.existsSync()) {
    print('❌ Config file not found');
    exit(1);
  }
  
  final  configContent = await configFile.readAsString();
  final urlMatch = RegExp(r"supabaseUrl = '([^']+)'").firstMatch(configContent);
  final keyMatch = RegExp(r"supabaseAnonKey = '([^']+)'").firstMatch(configContent);
  
  if (urlMatch == null || keyMatch == null) {
    print('❌ Could not extract Supabase credentials from config');
    exit(1);
  }
  
  final url = urlMatch.group(1)!;
  final key = keyMatch.group(1)!;
  
  print('Connecting to Supabase...');
  await Supabase.initialize(url: url, anonKey: key);
  
  final supabase = Supabase.instance.client;
  
  try {
    // First, check if column exists
    print('\nChecking if questions column exists...');
    final existingCircle = await supabase
        .from('circles')
        .select('id, name, questions')
        .limit(1)
        .maybeSingle();
    
    if (existingCircle != null && existingCircle.containsKey('questions')) {
      print('✅ Questions column already exists!');
      print('   Sample data: ${existingCircle['questions']}');
      exit(0);
    }
  } catch (e) {
    print('   Column does not exist yet (expected): $e');
  }
  
  print('\n❌ Cannot add column from Dart client - need database admin access\n');
  print('Please run this SQL in Supabase Dashboard SQL Editor:');
  print('┌────────────────────────────────────────────────────────────┐');
  print('│ ALTER TABLE public.circles                                │');
  print('│ ADD COLUMN IF NOT EXISTS questions JSONB                  │');
  print('│ DEFAULT \'[]\'::jsonb;                                      │');
  print('└────────────────────────────────────────────────────────────┘');
  print('\nDashboard URL: ${url.replaceAll('.supabase.co', '.supabase.co/project/_/sql')}');
}
