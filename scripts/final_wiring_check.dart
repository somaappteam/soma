
import 'package:supabase/supabase.dart';
import 'dart:io';

const String supabaseUrl = 'https://bnbjteedohflgkarfaxk.supabase.co';
const String serviceRoleKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImJuYmp0ZWVkb2hmbGdrYXJmYXhrIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc2OTcwMDI2NCwiZXhwIjoyMDg1Mjc2MjY0fQ.jTZOgpQ7Fy1HlUT0YldRAtr6Bvwti_Al1hfaP5Bz0Nc';

Future<void> main() async {
  final client = SupabaseClient(supabaseUrl, serviceRoleKey);
  
  print('--- VERBOSE WIRING CHECK ---');
  
  final items = [
    {'table': 'profiles', 'columns': 'daily_goal_minutes, settings, total_xp'},
    {'table': 'messages', 'columns': 'is_read, sender_id, receiver_id'},
    {'table': 'user_sessions', 'columns': 'device_id, is_current, last_seen'},
    {'table': 'leaderboard', 'columns': 'user_id, xp, rank'},
    {'table': 'concepts', 'columns': 'id, category'},
  ];

  for (final item in items) {
    final table = item['table'] as String;
    final cols = item['columns'] as String;
    try {
      await client.from(table).select(cols).limit(1);
      print('✅ $table ($cols): OK');
    } catch (e) {
      print('❌ $table ($cols): FAILED - $e');
    }
  }
}
