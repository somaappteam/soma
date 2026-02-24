import 'dart:io';

import 'package:soma/core/services/app_logger.dart';
import 'package:supabase/supabase.dart';

const String supabaseUrl = 'https://bnbjteedohflgkarfaxk.supabase.co';
const String serviceRoleKey =
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImJuYmp0ZWVkb2hmbGdrYXJmYXhrIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc2OTcwMDI2NCwiZXhwIjoyMDg1Mjc2MjY0fQ.jTZOgpQ7Fy1HlUT0YldRAtr6Bvwti_Al1hfaP5Bz0Nc';

void main() async {
  final client = SupabaseClient(supabaseUrl, serviceRoleKey);

  appLogger.info('--- Testing Manual Import Data Integrity ---');

  // Test Case: English to Spanish (en -> es)
  // Adjust these based on what languages you imported!
  // I will try to find *any* language pair with data if these are empty.

  // First, let's list available languages to be smart.
  await listAvailableLanguages(client);

  // Then test a specific pair.
  // We'll try 'en' -> 'am' to check pronunciation
  await testVocab(client, 'en', 'am');
  await testSentences(client, 'en', 'am');

  appLogger.info('--- Test Completed ---');
  exit(0);
}

Future<void> listAvailableLanguages(final SupabaseClient client) async {
  appLogger.info('\n[Discovery] Checking available languages...');
  try {
    final vocabLangs =
        await client.from('vocabulary').select('lang_code').limit(50);
    final sentenceLangs =
        await client.from('sentences').select('lang_code').limit(50);

    final vSet = vocabLangs.map((final e) => e['lang_code']).toSet();
    final sSet = sentenceLangs.map((final e) => e['lang_code']).toSet();

    appLogger.info('  Vocabulary Languages found (sample): $vSet');
    appLogger.info('  Sentence Languages found (sample): $sSet');
  } catch (e) {
    appLogger.info('  Error listing languages: $e');
  }
}

Future<void> testVocab(final SupabaseClient client, final String sourceLang,
    final String targetLang) async {
  appLogger.info('\n[Vocabulary] Fetching for $sourceLang -> $targetLang');

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

    appLogger.info('  Fetched ${sourceResponse.length} source items');
    appLogger.info('  Fetched ${targetResponse.length} target items');

    if (targetResponse.isNotEmpty) {
      final sample = targetResponse.first;
      appLogger.info('  Sample Target Item:');
      appLogger.info('    ID: ${sample['vocabulary_id']}');
      appLogger.info('    Word: ${sample['word']}');
      appLogger.info('    Pronunciation: ${sample['pronunciation']}');

      if (sample['pronunciation'] == null ||
          sample['pronunciation'].toString().isEmpty) {
        appLogger.info('  Note: Pronunciation is empty.');
      } else {
        appLogger.info('  OK: Pronunciation present.');
      }
    }
  } catch (e) {
    appLogger.info('  Error: $e');
  }
}

Future<void> testSentences(final SupabaseClient client, final String sourceLang,
    final String targetLang) async {
  appLogger.info('\n[Sentences] Fetching for $sourceLang -> $targetLang');

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

    appLogger.info('  Fetched ${sourceResponse.length} source items');
    appLogger.info('  Fetched ${targetResponse.length} target items');

    if (targetResponse.isNotEmpty) {
      final sample = targetResponse.first;
      appLogger.info('  Sample Target Item:');
      appLogger.info('    ID: ${sample['sentence_id']}');
      appLogger.info('    Sentence: ${sample['sentence']}');
      appLogger.info('    Pronunciation: ${sample['pronunciation']}');

      if (sample['pronunciation'] == null ||
          sample['pronunciation'].toString().isEmpty) {
        appLogger.info('  Note: Pronunciation is empty.');
      } else {
        appLogger.info('  OK: Pronunciation present.');
      }
    }
  } catch (e) {
    appLogger.info('  Error: $e');
  }
}
