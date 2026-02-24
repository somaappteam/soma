import 'dart:io';

import 'package:soma/core/services/app_logger.dart';
import 'package:supabase/supabase.dart';

const String supabaseUrl = 'https://bnbjteedohflgkarfaxk.supabase.co';
const String serviceRoleKey =
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImJuYmp0ZWVkb2hmbGdrYXJmYXhrIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc2OTcwMDI2NCwiZXhwIjoyMDg1Mjc2MjY0fQ.jTZOgpQ7Fy1HlUT0YldRAtr6Bvwti_Al1hfaP5Bz0Nc';

Future<void> main() async {
  final client = SupabaseClient(supabaseUrl, serviceRoleKey);

  final sqlFile =
      File('supabase/migrations/20260301113000_full_update_alignment.sql');
  if (!await sqlFile.exists()) {
    appLogger.info('SQL file not found!');
    return;
  }

  final sql = await sqlFile.readAsString();
  appLogger.info('Applying migration via RPC exec_sql...');

  try {
    // Note: Some SQL files have BEGN/COMMIT inside.
    // Supabase RPC might run in a transaction already.
    // If it fails, we might need to strip BEGIN/COMMIT.
    await client.rpc('exec_sql', params: {'query': sql});
    appLogger.info('✅ Migration applied successfully!');
  } catch (e) {
    appLogger.info('❌ RPC call failed: $e');
    appLogger.info(
        'Trying common alternative parameter name "sql" instead of "query"...');
    try {
      await client.rpc('exec_sql', params: {'sql': sql});
      appLogger.info('✅ Migration applied successfully (with "sql" param)!');
    } catch (e2) {
      appLogger.info('❌ RPC call failed again: $e2');
    }
  }
}
