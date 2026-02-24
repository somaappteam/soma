import 'package:soma/core/services/app_logger.dart';
import 'package:supabase/supabase.dart';

const String supabaseUrl = 'https://bnbjteedohflgkarfaxk.supabase.co';
const String anonKey =
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImJuYmp0ZWVkb2hmbGdrYXJmYXhrIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Njk3MDAyNjQsImV4cCI6MjA4NTI3NjI2NH0.m8ua_6P0AtykUgLbLuxeE3o3i4Dwfw_xPsvODORlKtM';

void main() async {
  final client = SupabaseClient(supabaseUrl, anonKey);

  appLogger.info('--- Verifying RLS & Data with ANON KEY ---');

  // Check Vocabulary
  try {
    appLogger.info('\nAttempting to fetch Vocabulary...');
    final vocabInfo = await client.from('vocabulary').select('lang').limit(10);
    if (vocabInfo.isEmpty) {
      appLogger.info('❌ Vocabulary fetch returned EMPTY list.');
    } else {
      appLogger.info('✅ Vocabulary fetch SUCCESS. First few rows: $vocabInfo');
      // Check distinct langs (limited to the 10 rows fetched, but gives a hint)
      final unique = vocabInfo.map((final e) => e['lang']).toSet();
      appLogger.info("ℹ️  Observed 'lang' values: $unique");
    }
  } catch (e) {
    appLogger.info('❌ Vocabulary fetch FAILED: $e');
  }

  // Check Sentences
  try {
    appLogger.info('\nAttempting to fetch Sentences...');
    final sentenceInfo =
        await client.from('sentences').select('lang_code').limit(10);
    if (sentenceInfo.isEmpty) {
      appLogger.info('❌ Sentences fetch returned EMPTY list.');
    } else {
      appLogger
          .info('✅ Sentences fetch SUCCESS. First few rows: $sentenceInfo');
      final unique = sentenceInfo.map((final e) => e['lang_code']).toSet();
      appLogger.info("ℹ️  Observed 'lang_code' values: $unique");
    }
  } catch (e) {
    appLogger.info('❌ Sentences fetch FAILED: $e');
  }
}
