import 'package:soma/core/services/app_logger.dart';
import 'package:supabase/supabase.dart';

const String supabaseUrl = 'https://bnbjteedohflgkarfaxk.supabase.co';
const String serviceRoleKey =
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImJuYmp0ZWVkb2hmbGdrYXJmYXhrIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc2OTcwMDI2NCwiZXhwIjoyMDg1Mjc2MjY0fQ.jTZOgpQ7Fy1HlUT0YldRAtr6Bvwti_Al1hfaP5Bz0Nc';

void main() async {
  final client = SupabaseClient(supabaseUrl, serviceRoleKey);

  try {
    final response = await client.from('vocabulary').select().limit(1);
    appLogger.info(
        'Vocabulary columns: ${response.isNotEmpty ? response.first.keys : "Empty table, checking schema..."}');

    // Fallback: Query columns directly from information_schema if allowed via postgrest
    // Usually it's not exposed, but 'select' on a table that exists but has no columns or different ones might show hints.
  } catch (e) {
    appLogger.info('Failed to select: $e');
  }
}
