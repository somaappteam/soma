import 'package:soma/core/services/app_logger.dart';
import 'package:supabase/supabase.dart';

const String supabaseUrl = 'https://bnbjteedohflgkarfaxk.supabase.co';
const String serviceRoleKey =
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImJuYmp0ZWVkb2hmbGdrYXJmYXhrIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc2OTcwMDI2NCwiZXhwIjoyMDg1Mjc2MjY0fQ.jTZOgpQ7Fy1HlUT0YldRAtr6Bvwti_Al1hfaP5Bz0Nc';

void main() async {
  final client = SupabaseClient(supabaseUrl, serviceRoleKey);

  final vocabResp = await client.from('vocabulary').select('id').limit(1);
  final sentencesResp = await client.from('sentences').select('id').limit(1);

  // In some versions of postgrest-dart, the response has a .count property if we use a specific builder.
  // For now, let's just use the RPC approach if possible, or just a simple 'select' and see the count in the response object.

  appLogger.info('Vocab exists check: ${vocabResp.length}');
  appLogger.info('Sentences exists check: ${sentencesResp.length}');
}
