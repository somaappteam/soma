import 'package:soma/core/services/app_logger.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Service Role Key from existing code
const String supabaseUrl = 'https://bnbjteedohflgkarfaxk.supabase.co';
const String serviceRoleKey =
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImJuYmp0ZWVkb2hmbGdrYXJmYXhrIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc2OTcwMDI2NCwiZXhwIjoyMDg1Mjc2MjY0fQ.jTZOgpQ7Fy1HlUT0YldRAtr6Bvwti_Al1hfaP5Bz0Nc';

void main() async {
  final client = SupabaseClient(supabaseUrl, serviceRoleKey);

  appLogger.info('--- Checking Vocabulary Languages ---');
  try {
    final vocabLangs =
        await client.from('vocabulary').select('lang').limit(100);
    final uniqueVocab = vocabLangs.map((final e) => e['lang']).toSet();
    appLogger.info('Found Vocabulary Languages: $uniqueVocab');
  } catch (e) {
    appLogger.info('Error checking vocab: $e');
  }

  appLogger.info('\n--- Checking Sentences Languages ---');
  try {
    final sentenceLangs =
        await client.from('sentences').select('lang_code').limit(100);
    final uniqueSentences =
        sentenceLangs.map((final e) => e['lang_code']).toSet();
    appLogger.info('Found Sentences Languages: $uniqueSentences');
  } catch (e) {
    appLogger.info('Error checking sentences: $e');
  }
}
