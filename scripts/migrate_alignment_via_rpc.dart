
import 'dart:io';
import 'package:supabase/supabase.dart';

const String supabaseUrl = 'https://bnbjteedohflgkarfaxk.supabase.co';
const String serviceRoleKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImJuYmp0ZWVkb2hmbGdrYXJmYXhrIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc2OTcwMDI2NCwiZXhwIjoyMDg1Mjc2MjY0fQ.jTZOgpQ7Fy1HlUT0YldRAtr6Bvwti_Al1hfaP5Bz0Nc';

Future<void> main() async {
  final client = SupabaseClient(supabaseUrl, serviceRoleKey);
  
  final sqlFile = File('supabase/migrations/20260301113000_full_update_alignment.sql');
  if (!await sqlFile.exists()) {
    print('SQL file not found!');
    return;
  }
  
  final sql = await sqlFile.readAsString();
  print('Applying migration via RPC exec_sql...');

  try {
    // Note: Some SQL files have BEGN/COMMIT inside. 
    // Supabase RPC might run in a transaction already.
    // If it fails, we might need to strip BEGIN/COMMIT.
    await client.rpc('exec_sql', params: {'query': sql});
    print('✅ Migration applied successfully!');
  } catch (e) {
    print('❌ RPC call failed: $e');
    print('Trying common alternative parameter name "sql" instead of "query"...');
    try {
       await client.rpc('exec_sql', params: {'sql': sql});
       print('✅ Migration applied successfully (with "sql" param)!');
    } catch (e2) {
      print('❌ RPC call failed again: $e2');
    }
  }
}
