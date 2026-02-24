import 'package:soma/core/services/app_logger.dart';
import 'package:supabase/supabase.dart';

const String supabaseUrl = 'https://bnbjteedohflgkarfaxk.supabase.co';
const String serviceRoleKey =
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImJuYmp0ZWVkb2hmbGdrYXJmYXhrIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc2OTcwMDI2NCwiZXhwIjoyMDg1Mjc2MjY0fQ.jTZOgpQ7Fy1HlUT0YldRAtr6Bvwti_Al1hfaP5Bz0Nc';

void main() async {
  final client = SupabaseClient(supabaseUrl, serviceRoleKey);

  appLogger.info('--- CHECKING COLUMNS FOR CIRCLES ---');
  try {
    final circles = await client.from('circles').select().limit(1);
    if (circles.isNotEmpty) {
      appLogger.info('Columns in circles: ${circles.first.keys.toList()}');
    } else {
      appLogger.info(
          'Circles table is empty, cannot check columns easily via select');
    }
  } catch (e) {
    appLogger.info('Error checking circles columns: $e');
  }

  appLogger.info('\n--- CHECKING COLUMNS FOR CIRCLE_PARTICIPANTS ---');
  try {
    final participants =
        await client.from('circle_participants').select().limit(1);
    if (participants.isNotEmpty) {
      appLogger.info(
          'Columns in circle_participants: ${participants.first.keys.toList()}');
    } else {
      appLogger.info('Circle_participants table is empty');
    }
  } catch (e) {
    appLogger.info('Error checking circle_participants columns: $e');
  }

  appLogger.info('\n--- CHECKING COURSES FOR LANGUAGES ---');
  try {
    final courses = await client.from('courses').select().limit(1);
    if (courses.isNotEmpty) {
      appLogger.info('Columns in courses: ${courses.first.keys.toList()}');
    }
  } catch (e) {
    appLogger.info('Error checking courses columns: $e');
  }
}
