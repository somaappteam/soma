
import 'package:supabase/supabase.dart';

const String supabaseUrl = 'https://bnbjteedohflgkarfaxk.supabase.co';
const String anonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImJuYmp0ZWVkb2hmbGdrYXJmYXhrIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Njk3MDAyNjQsImV4cCI6MjA4NTI3NjI2NH0.m8ua_6P0AtykUgLbLuxeE3o3i4Dwfw_xPsvODORlKtM';

Future<void> main() async {
  final client = SupabaseClient(supabaseUrl, anonKey);

  print('--- ANON RLS PROBE ---');

  final publicTables = ['vocabulary', 'sentences', 'achievements', 'courses', 'leaderboard', 'circles'];
  
  for (var table in publicTables) {
    try {
      final res = await client.from(table).select().limit(1);
      print('✅ $table: Readable by ANON (RLS likely OK for public read)');
    } catch (e) {
      print('❌ $table: NOT readable by ANON: $e');
    }
  }

  final privateTables = ['messages', 'friendships', 'notifications', 'user_stats', 'user_courses', 'user_learned_items', 'circle_participants', 'chat_messages'];
  
  for (var table in privateTables) {
    try {
      final res = await client.from(table).select().limit(1);
      if (res.isEmpty) {
        print('✅ $table: Read returned empty (expected if RLS is on and no public data)');
      } else {
        print('⚠️ $table: Read SUCCESS by ANON but returned data! Check RLS for leaks.');
      }
    } catch (e) {
      print('✅ $table: Read FAILED for ANON (expected for private tables): $e');
    }
  }
}
