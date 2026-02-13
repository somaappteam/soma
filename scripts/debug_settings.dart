
import 'package:supabase/supabase.dart';
import 'dart:io';

const String supabaseUrl = 'https://bnbjteedohflgkarfaxk.supabase.co';
const String serviceRoleKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImJuYmp0ZWVkb2hmbGdrYXJmYXhrIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc2OTcwMDI2NCwiZXhwIjoyMDg1Mjc2MjY0fQ.jTZOgpQ7Fy1HlUT0YldRAtr6Bvwti_Al1hfaP5Bz0Nc';

Future<void> main() async {
  final client = SupabaseClient(supabaseUrl, serviceRoleKey);
  
  print('--- REALTIME & PROFILE CHECK ---');
  
  try {
    // 1. Check if 'profiles' has realtime enabled via a dummy query or checking publication
    final res = await client.rpc('get_table_realtime_status', params: {'t_name': 'profiles'});
    print('Realtime status for profiles: $res');
  } catch (e) {
    print('Could not check realtime via RPC: $e');
  }

  try {
    // 2. Check current users
    final users = await client.from('profiles').select('id, username').limit(5);
    print('Recent profile IDs: ${users.map((u) => u['id']).toList()}');
  } catch (e) {
    print('Error fetching profiles: $e');
  }
}
