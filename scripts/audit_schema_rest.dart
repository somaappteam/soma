
import 'package:supabase/supabase.dart';

const String supabaseUrl = 'https://bnbjteedohflgkarfaxk.supabase.co';
const String serviceRoleKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImJuYmp0ZWVkb2hmbGdrYXJmYXhrIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc2OTcwMDI2NCwiZXhwIjoyMDg1Mjc2MjY0fQ.jTZOgpQ7Fy1HlUT0YldRAtr6Bvwti_Al1hfaP5Bz0Nc';

Future<void> main() async {
  final client = SupabaseClient(supabaseUrl, serviceRoleKey);

  print('--- AUDITING SCHEMA ALIGNMENT ---');

  // Check Circles Table
  print('\n[Circles]');
  try {
    final res = await client.from('circles').select().limit(1).maybeSingle();
    if (res != null) {
      final keys = (res).keys.toList();
      print('Existing columns: $keys');
      final expected = ['from_lang', 'to_lang', 'mode', 'level', 'max_players', 'questions_count', 'time_per_q', 'allow_spectators', 'is_locked'];
      final missing = expected.where((final e) => !keys.contains(e)).toList();
      if (missing.isEmpty) {
        print('✅ All expected columns present.');
      } else {
        print('❌ Missing columns: $missing');
      }
    } else {
      print('Table empty, trying to probe via empty insert (rollback-ish if possible, but REST is direct).');
      print('Falling back to checking if we can select specific columns.');
      try {
        await client.from('circles').select('is_locked').limit(1);
        print('✅ Column is_locked exists.');
      } catch (e) {
         print('❌ Column is_locked seems MISSING: $e');
      }
    }
  } catch (e) {
    print('Error auditing circles: $e');
  }

  // Check Chat Messages Table
  print('\n[Chat Messages]');
  try {
    await client.from('chat_messages').select().limit(1);
    print('✅ Table chat_messages exists.');
  } catch (e) {
    print('❌ Table chat_messages seems MISSING: $e');
  }

  // Check Live Quiz Questions Table
  print('\n[Live Quiz Questions]');
  try {
    await client.from('live_quiz_questions').select().limit(1);
    print('✅ Table live_quiz_questions exists.');
  } catch (e) {
    print('❌ Table live_quiz_questions seems MISSING: $e');
  }

  print('\n--- AUDIT COMPLETE ---');
}
