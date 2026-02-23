
import 'dart:io';

import 'package:supabase/supabase.dart';

const String supabaseUrl = 'https://bnbjteedohflgkarfaxk.supabase.co';
const String serviceRoleKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImJuYmp0ZWVkb2hmbGdrYXJmYXhrIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc2OTcwMDI2NCwiZXhwIjoyMDg1Mjc2MjY0fQ.jTZOgpQ7Fy1HlUT0YldRAtr6Bvwti_Al1hfaP5Bz0Nc';

Future<void> main() async {
  final client = SupabaseClient(supabaseUrl, serviceRoleKey);
  
  final tables = ['profiles', 'friendships', 'messages', 'circles', 'user_sessions', 'leaderboard'];

  final buffer = StringBuffer();
  buffer.writeln('--- COLUMN AUDIT ---');

  for (final table in tables) {
    buffer.writeln('\n[TABLE: $table]');
    try {
      final res = await client.from(table).select().limit(1).maybeSingle();
      if (res != null) {
        buffer.writeln('Columns: ${(res).keys.join(", ")}');
      } else {
        buffer.writeln('Table empty or no accessible record.');
      }
    } catch (e) {
      buffer.writeln('ERROR: $e');
    }
  }
  
  await File('col_final.txt').writeAsString(buffer.toString());
  print('Audit written to col_final.txt');
}
