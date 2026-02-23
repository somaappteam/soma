import 'package:supabase_flutter/supabase_flutter.dart';

// Service Role Key from existing code
const String supabaseUrl = 'https://bnbjteedohflgkarfaxk.supabase.co';
const String serviceRoleKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImJuYmp0ZWVkb2hmbGdrYXJmYXhrIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc2OTcwMDI2NCwiZXhwIjoyMDg1Mjc2MjY0fQ.jTZOgpQ7Fy1HlUT0YldRAtr6Bvwti_Al1hfaP5Bz0Nc';

void main() async {
  final client = SupabaseClient(supabaseUrl, serviceRoleKey);
  
  print('--- Checking Vocabulary Languages ---');
  try {
    final vocabLangs = await client.from('vocabulary').select('lang').limit(100);
    final uniqueVocab = vocabLangs.map((final e) => e['lang']).toSet();
    print('Found Vocabulary Languages: $uniqueVocab');
  } catch (e) {
    print('Error checking vocab: $e');
  }

  print('\n--- Checking Sentences Languages ---');
  try {
    final sentenceLangs = await client.from('sentences').select('lang_code').limit(100);
    final uniqueSentences = sentenceLangs.map((final e) => e['lang_code']).toSet();
    print('Found Sentences Languages: $uniqueSentences');
  } catch (e) {
    print('Error checking sentences: $e');
  }
}
