import 'package:soma/core/services/app_logger.dart';
import 'package:supabase/supabase.dart';

const String supabaseUrl = 'https://bnbjteedohflgkarfaxk.supabase.co';
const String serviceRoleKey =
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImJuYmp0ZWVkb2hmbGdrYXJmYXhrIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc2OTcwMDI2NCwiZXhwIjoyMDg1Mjc2MjY0fQ.jTZOgpQ7Fy1HlUT0YldRAtr6Bvwti_Al1hfaP5Bz0Nc';

void main() async {
  final client = SupabaseClient(supabaseUrl, serviceRoleKey);

  appLogger.info('--- Testing vocabulary insert with voca_id ---');

  try {
    // Match the exact CSV structure
    final testRow = {
      'voca_id': 99999,
      'concept_id': 99999,
      'lang': 'test',
      'word': 'test_word',
      'article': null,
      'gender': null,
      'romanization': null,
      'pinyin': null,
      'transliteration': null,
      'level': 'A',
    };

    appLogger.info('Inserting test row: $testRow');
    await client.from('vocabulary').insert(testRow);
    appLogger.info('Insert succeeded!');

    // Verify
    final result =
        await client.from('vocabulary').select().eq('voca_id', 99999);
    appLogger.info('Result: ${result.length} rows');

    // Clean up
    await client.from('vocabulary').delete().eq('voca_id', 99999);
    appLogger.info('Cleaned up');
  } catch (e) {
    appLogger.info('Error: $e');
  }
}
