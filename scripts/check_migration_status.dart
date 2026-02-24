import 'package:soma/core/services/app_logger.dart';
import 'package:supabase/supabase.dart';

const String supabaseUrl = 'https://bnbjteedohflgkarfaxk.supabase.co';
const String serviceRoleKey =
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImJuYmp0ZWVkb2hmbGdrYXJmYXhrIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc2OTcwMDI2NCwiZXhwIjoyMDg1Mjc2MjY0fQ.jTZOgpQ7Fy1HlUT0YldRAtr6Bvwti_Al1hfaP5Bz0Nc';

void main() async {
  final client = SupabaseClient(supabaseUrl, serviceRoleKey);

  appLogger.info('=== FULL MIGRATION STATUS CHECK ===');
  appLogger.info('');

  // 1. Check all tables exist and get sample counts
  final tables = [
    'profiles',
    'circles',
    'circle_participants',
    'live_quiz_questions',
    'live_quiz_answers',
    'vocabulary',
    'sentences',
    'user_stats',
    'user_learned_items',
    'courses',
    'achievements',
    'user_achievements',
    'friendships',
    'chat_messages',
    'notifications',
  ];

  appLogger.info('--- TABLE STATUS ---');
  final missing = <String>[];
  final existing = <String>[];

  for (final table in tables) {
    try {
      final result = await client.from(table).select().limit(3);
      existing.add('$table (${result.length}+ rows)');
    } catch (e) {
      final errStr = e.toString();
      if (errStr.contains('does not exist') || errStr.contains('not found')) {
        missing.add(table);
      } else {
        missing.add('$table (ERROR)');
      }
    }
  }

  appLogger.info('');
  appLogger.info('EXISTING TABLES:');
  for (final t in existing) {
    appLogger.info('  ✅ $t');
  }

  appLogger.info('');
  appLogger.info('MISSING TABLES:');
  if (missing.isEmpty) {
    appLogger.info('  None!');
  } else {
    for (final t in missing) {
      appLogger.info('  ❌ $t');
    }
  }

  appLogger.info('');
  appLogger.info('--- DATA COUNTS ---');

  // Check vocabulary
  try {
    final vocab = await client.from('vocabulary').select('voca_id');
    appLogger.info('Vocabulary: ${vocab.length} rows');
  } catch (e) {
    appLogger.info('Vocabulary: ERROR');
  }

  // Check sentences
  try {
    final sent = await client.from('sentences').select('sentence_id');
    appLogger.info('Sentences: ${sent.length} rows');
  } catch (e) {
    appLogger.info('Sentences: ERROR');
  }

  appLogger.info('');
  appLogger.info('=== DONE ===');
}
