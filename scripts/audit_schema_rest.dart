import 'package:soma/core/services/app_logger.dart';
import 'package:supabase/supabase.dart';

const String supabaseUrl = 'https://bnbjteedohflgkarfaxk.supabase.co';
const String serviceRoleKey =
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImJuYmp0ZWVkb2hmbGdrYXJmYXhrIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc2OTcwMDI2NCwiZXhwIjoyMDg1Mjc2MjY0fQ.jTZOgpQ7Fy1HlUT0YldRAtr6Bvwti_Al1hfaP5Bz0Nc';

Future<void> main() async {
  final client = SupabaseClient(supabaseUrl, serviceRoleKey);

  appLogger.info('--- AUDITING SCHEMA ALIGNMENT ---');

  // Check Circles Table
  appLogger.info('\n[Circles]');
  try {
    final res = await client.from('circles').select().limit(1).maybeSingle();
    if (res != null) {
      final keys = (res).keys.toList();
      appLogger.info('Existing columns: $keys');
      final expected = [
        'from_lang',
        'to_lang',
        'mode',
        'level',
        'max_players',
        'questions_count',
        'time_per_q',
        'allow_spectators',
        'is_locked'
      ];
      final missing = expected.where((final e) => !keys.contains(e)).toList();
      if (missing.isEmpty) {
        appLogger.info('✅ All expected columns present.');
      } else {
        appLogger.info('❌ Missing columns: $missing');
      }
    } else {
      appLogger.info(
          'Table empty, trying to probe via empty insert (rollback-ish if possible, but REST is direct).');
      appLogger
          .info('Falling back to checking if we can select specific columns.');
      try {
        await client.from('circles').select('is_locked').limit(1);
        appLogger.info('✅ Column is_locked exists.');
      } catch (e) {
        appLogger.info('❌ Column is_locked seems MISSING: $e');
      }
    }
  } catch (e) {
    appLogger.info('Error auditing circles: $e');
  }

  // Check Chat Messages Table
  appLogger.info('\n[Chat Messages]');
  try {
    await client.from('chat_messages').select().limit(1);
    appLogger.info('✅ Table chat_messages exists.');
  } catch (e) {
    appLogger.info('❌ Table chat_messages seems MISSING: $e');
  }

  // Check Live Quiz Questions Table
  appLogger.info('\n[Live Quiz Questions]');
  try {
    await client.from('live_quiz_questions').select().limit(1);
    appLogger.info('✅ Table live_quiz_questions exists.');
  } catch (e) {
    appLogger.info('❌ Table live_quiz_questions seems MISSING: $e');
  }

  appLogger.info('\n--- AUDIT COMPLETE ---');
}
