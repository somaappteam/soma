import 'package:soma/core/services/app_logger.dart';
import 'package:supabase/supabase.dart';

const String supabaseUrl = 'https://bnbjteedohflgkarfaxk.supabase.co';
const String serviceRoleKey =
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImJuYmp0ZWVkb2hmbGdrYXJmYXhrIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc2OTcwMDI2NCwiZXhwIjoyMDg1Mjc2MjY0fQ.jTZOgpQ7Fy1HlUT0YldRAtr6Bvwti_Al1hfaP5Bz0Nc';

void main() async {
  final client = SupabaseClient(supabaseUrl, serviceRoleKey);

  appLogger.info('=== COURSE ID CHECK ===');

  try {
    final courses = await client
        .from('courses')
        .select('id, title, source_lang, target_lang');
    appLogger.info('Found ${courses.length} courses:');
    for (final c in courses) {
      appLogger.info(
          '  ID: ${c['id']} | Title: ${c['title']} | Lang: ${c['source_lang']} -> ${c['target_lang']}');
    }
  } catch (e) {
    appLogger.info('Error: $e');
  }
}
