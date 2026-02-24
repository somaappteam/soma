import 'package:soma/core/services/app_logger.dart';
import 'package:supabase/supabase.dart';

const String supabaseUrl = 'https://bnbjteedohflgkarfaxk.supabase.co';
const String serviceRoleKey =
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImJuYmp0ZWVkb2hmbGdrYXJmYXhrIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc2OTcwMDI2NCwiZXhwIjoyMDg1Mjc2MjY0fQ.jTZOgpQ7Fy1HlUT0YldRAtr6Bvwti_Al1hfaP5Bz0Nc';

void main() async {
  final client = SupabaseClient(supabaseUrl, serviceRoleKey);

  appLogger.info('--- Checking Supabase Vocabulary ---');

  try {
    // Simple select with limit
    final sample = await client.from('vocabulary').select().limit(5);
    appLogger.info('Got ${sample.length} vocabulary items (limited to 5)');

    for (final row in sample) {
      appLogger.info('  - ${row['word']} (lang: ${row['lang']})');
    }

    if (sample.isEmpty) {
      appLogger.info('\nVocabulary table is EMPTY!');
    }
  } catch (e) {
    appLogger.info('Error: $e');
  }
}
