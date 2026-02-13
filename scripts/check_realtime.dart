
import 'package:supabase/supabase.dart';
import 'dart:io';

const String supabaseUrl = 'https://bnbjteedohflgkarfaxk.supabase.co';
const String serviceRoleKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImJuYmp0ZWVkb2hmbGdrYXJmYXhrIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc2OTcwMDI2NCwiZXhwIjoyMDg1Mjc2MjY0fQ.jTZOgpQ7Fy1HlUT0YldRAtr6Bvwti_Al1hfaP5Bz0Nc';

Future<void> main() async {
  final client = SupabaseClient(supabaseUrl, serviceRoleKey);
  
  print('--- REALTIME PUBLICATION CHECK ---');
  
  try {
    // Check which tables are in the 'supabase_realtime' publication
    final res = await client.rpc('check_realtime_tables');
    print('Tables in realtime: $res');
  } catch (e) {
    print('RPC failed, trying raw query via a temporary script if possible or checking specific error.');
    // Fallback: Just check if we can get a single row from profiles to ensure RLS is not the issue
    try {
      final p = await client.from('profiles').select('id').limit(1);
      print('Profiles access OK: ${p.length} rows found');
    } catch (e2) {
      print('Profiles access FAILED: $e2');
    }
  }
}
