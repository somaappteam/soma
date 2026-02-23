import 'dart:io';
import 'package:supabase/supabase.dart';

const String supabaseUrl = 'https://bnbjteedohflgkarfaxk.supabase.co';
const String serviceRoleKey =
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImJuYmp0ZWVkb2hmbGdrYXJmYXhrIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc2OTcwMDI2NCwiZXhwIjoyMDg1Mjc2MjY0fQ.jTZOgpQ7Fy1HlUT0YldRAtr6Bvwti_Al1hfaP5Bz0Nc';

void main() async {
  final client = SupabaseClient(supabaseUrl, serviceRoleKey);

  print('--- Testing Manual Import Data Integrity ---');

  // Test Case: English to Spanish (en -> es)
  // Adjust these based on what languages you imported!
  // I will try to find *any* language pair with data if these are empty.
  
  // First, let's list available languages to be smart.
  await listAvailableLanguages(client);

  // Then test a specific pair.
  // We'll try 'en' -> 'am' to check pronunciation
  await testVocab(client, 'en', 'am');
  await testSentences(client, 'en', 'am');

  print('--- Test Completed ---');
  exit(0);
}

Future<void> listAvailableLanguages(final SupabaseClient client) async {
  print('\n[Discovery] Checking available languages...');
  try {
    final vocabLangs = await client.from('vocabulary').select('lang_code').limit(50);
    final sentenceLangs = await client.from('sentences').select('lang_code').limit(50);

    final vSet = vocabLangs.map((final e) => e['lang_code']).toSet();
    final sSet = sentenceLangs.map((final e) => e['lang_code']).toSet();

    print('  Vocabulary Languages found (sample): $vSet');
    print('  Sentence Languages found (sample): $sSet');
  } catch (e) {
    print('  Error listing languages: $e');
  }
}

Future<void> testVocab(final SupabaseClient client, final String sourceLang, final String targetLang) async {
  print('\n[Vocabulary] Fetching for $sourceLang -> $targetLang');

  try {
    final sourceResponse = await client
        .from('vocabulary')
        .select()
        .eq('lang_code', sourceLang)
        .limit(5);

    final targetResponse = await client
        .from('vocabulary')
        .select()
        .eq('lang_code', targetLang)
        .limit(5);
    
    print('  Fetched ${sourceResponse.length} source items');
    print('  Fetched ${targetResponse.length} target items');

    if (targetResponse.isNotEmpty) {
      final sample = targetResponse.first;
      print('  Sample Target Item:');
      print('    ID: ${sample['vocabulary_id']}');
      print('    Word: ${sample['word']}');
      print('    Pronunciation: ${sample['pronunciation']}');
      
      if (sample['pronunciation'] == null || sample['pronunciation'].toString().isEmpty) {
         print('  Note: Pronunciation is empty.');
      } else {
         print('  OK: Pronunciation present.');
      }
    }

  } catch (e) {
    print('  Error: $e');
  }
}

Future<void> testSentences(final SupabaseClient client, final String sourceLang, final String targetLang) async {
  print('\n[Sentences] Fetching for $sourceLang -> $targetLang');
  
  try {
    final sourceResponse = await client
        .from('sentences')
        .select()
        .eq('lang_code', sourceLang)
        .limit(5);

    final targetResponse = await client
        .from('sentences')
        .select()
        .eq('lang_code', targetLang)
        .limit(5);
    
    print('  Fetched ${sourceResponse.length} source items');
    print('  Fetched ${targetResponse.length} target items');

    if (targetResponse.isNotEmpty) {
      final sample = targetResponse.first;
      print('  Sample Target Item:');
       print('    ID: ${sample['sentence_id']}');
      print('    Sentence: ${sample['sentence']}');
      print('    Pronunciation: ${sample['pronunciation']}');

       if (sample['pronunciation'] == null || sample['pronunciation'].toString().isEmpty) {
         print('  Note: Pronunciation is empty.');
      } else {
         print('  OK: Pronunciation present.');
      }
    }
  } catch (e) {
    print('  Error: $e');
  }
}
