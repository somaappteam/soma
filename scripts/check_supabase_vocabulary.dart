import 'package:supabase/supabase.dart';

const String supabaseUrl = 'https://bnbjteedohflgkarfaxk.supabase.co';
const String serviceRoleKey =
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImJuYmp0ZWVkb2hmbGdrYXJmYXhrIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc2OTcwMDI2NCwiZXhwIjoyMDg1Mjc2MjY0fQ.jTZOgpQ7Fy1HlUT0YldRAtr6Bvwti_Al1hfaP5Bz0Nc';

void main() async {
  final client = SupabaseClient(supabaseUrl, serviceRoleKey);

  print('--- Checking Supabase Vocabulary ---');

  try {
    // Simple select with limit
    final sample = await client.from('vocabulary').select().limit(5);
    print('Got ${sample.length} vocabulary items (limited to 5)');
    
    for (final row in sample) {
      print('  - ${row['word']} (lang: ${row['lang']})');
    }
    
    if (sample.isEmpty) {
      print('\nVocabulary table is EMPTY!');
    }
  } catch (e) {
    print("Error: $e");
  }
}
