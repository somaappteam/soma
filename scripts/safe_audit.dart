
import 'dart:io';

import 'package:supabase/supabase.dart';

const String supabaseUrl = 'https://bnbjteedohflgkarfaxk.supabase.co';
const String serviceRoleKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImJuYmp0ZWVkb2hmbGdrYXJmYXhrIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc2OTcwMDI2NCwiZXhwIjoyMDg1Mjc2MjY0fQ.jTZOgpQ7Fy1HlUT0YldRAtr6Bvwti_Al1hfaP5Bz0Nc';

Future<void> main() async {
  final client = SupabaseClient(supabaseUrl, serviceRoleKey);
  
  final tables = [
    'profiles', 'friendships', 'messages', 'circles', 'circle_participants',
    'vocabulary', 'sentences', 'user_courses', 'courses', 'user_learned_items',
    'chat_messages', 'user_stats', 'achievements', 'user_achievements',
    'notifications', 'user_sessions', 'leaderboard', 'concepts'
  ];

  print('--- SAFE SEGMENTED AUDIT ---');
  
  for (final table in tables) {
    stdout.write('Checking $table... ');
    try {
      final res = await client.from(table).select().limit(1);
      print('✅ OK (${(res as List).length} rows sampled)');
    } catch (e) {
      print('❌ ERROR: $e');
    }
    await Future.delayed(Duration(milliseconds: 200));
  }
  print('\n--- AUDIT COMPLETE ---');
}
