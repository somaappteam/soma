
import 'package:supabase/supabase.dart';
import 'dart:io';

const String supabaseUrl = 'https://bnbjteedohflgkarfaxk.supabase.co';
const String serviceRoleKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImJuYmp0ZWVkb2hmbGdrYXJmYXhrIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc2OTcwMDI2NCwiZXhwIjoyMDg1Mjc2MjY0fQ.jTZOgpQ7Fy1HlUT0YldRAtr6Bvwti_Al1hfaP5Bz0Nc';

Future<void> main() async {
  final client = SupabaseClient(supabaseUrl, serviceRoleKey);
  final buffer = StringBuffer();
  
  void log(String msg) {
    print(msg);
    buffer.writeln(msg);
  }

  log('--- COMPREHENSIVE DEEP-DIVE AUDIT ---');

  final schemaMap = {
    'profiles': ['id', 'username', 'display_name', 'daily_goal_minutes', 'total_xp', 'avatar_url', 'settings'],
    'friendships': ['id', 'user_id', 'friend_id', 'status', 'addressee_id'],
    'messages': ['id', 'sender_id', 'receiver_id', 'content', 'is_read'],
    'circles': ['id', 'name', 'host_id', 'is_locked', 'status', 'questions'],
    'circle_participants': ['id', 'circle_id', 'user_id', 'joined_at'],
    'vocabulary': ['id', 'concept_id', 'lang', 'word', 'definition', 'translation', 'examples', 'audio_url'],
    'sentences': ['id', 'concept_id', 'lang_code', 'text', 'translation', 'audio_url'],
    'user_courses': ['user_id', 'course_id', 'progress', 'status', 'last_accessed'],
    'courses': ['id', 'title', 'description', 'language', 'cover_url'],
    'user_learned_items': ['user_id', 'concept_id', 'mastery_level', 'last_reviewed', 'next_review'],
    'chat_messages': ['id', 'circle_id', 'user_id', 'content', 'created_at'],
    'user_stats': ['user_id', 'quizzes_taken', 'correct_answers', 'sentences_read', 'circles_joined'],
    'achievements': ['id', 'title', 'description', 'icon_url', 'xp_reward'],
    'user_achievements': ['user_id', 'achievement_id', 'earned_at'],
    'notifications': ['id', 'user_id', 'type', 'title', 'message', 'data', 'is_read', 'created_at'],
    'user_sessions': ['id', 'user_id', 'device_id', 'device_name', 'platform', 'last_seen', 'is_current'],
    'leaderboard': ['id', 'user_id', 'xp', 'rank'],
    'concepts': ['id', 'category', 'tags'],
  };

  for (var entry in schemaMap.entries) {
    final table = entry.key;
    final columns = entry.value;
    log('\n[Table: $table]');
    
    try {
      final res = await client.from(table).select().limit(1).maybeSingle();
      if (res != null) {
        log('✅ Table exists and has data.');
        final keys = (res as Map<String, dynamic>).keys.toSet();
        for (var col in columns) {
          if (keys.contains(col)) log('  ✅ Column "$col" present');
          else log('  ❌ Column "$col" MISSING');
        }
      } else {
        log('ℹ️ Table exists but is empty. Probing columns individually...');
        for (var col in columns) {
          try {
            await client.from(table).select(col).limit(1);
            log('  ✅ Column "$col" present');
          } catch (e) {
            log('  ❌ Column "$col" MISSING or error: $e');
          }
        }
      }
    } catch (e) {
      log('❌ Table MISSING or unreachable: $e');
    }
  }

  log('\n--- SEED DATA CHECK ---');
  try {
    final achievements = await client.from('achievements').select('id');
    log('Achievements in DB: ${achievements.length}');
    if (achievements.isEmpty) log('⚠️ Achievements table is EMPTY!');
  } catch (e) { log('Error checking achievements: $e'); }

  try {
    final vocab = await client.from('vocabulary').select('id').limit(10);
    log('Vocabulary samples: ${vocab.length}');
    if (vocab.isEmpty) log('⚠️ Vocabulary table is EMPTY!');
  } catch (e) { log('Error checking vocabulary: $e'); }

  log('\n--- RLS PROBE (Preliminary) ---');
  log('Note: Service Role Key used here. RLS verification requires testing with Anon Key.');
  
  log('\n--- END DEEP AUDIT ---');
  await File('deep_audit_results.txt').writeAsString(buffer.toString());
}
