import 'package:soma/core/services/app_logger.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Apply the add_questions_to_circles migration directly
void main() async {
  appLogger.info('Initializing Supabase...');

  // Get environment variables or prompt for them
  final supabaseUrl = const String.fromEnvironment('SUPABASE_URL');
  final supabaseKey = const String.fromEnvironment('SUPABASE_KEY');

  await Supabase.initialize(
    url: supabaseUrl,
    anonKey: supabaseKey,
  );

  final supabase = Supabase.instance.client;

  try {
    appLogger.info('\nApplying migration: add_questions_to_circles');
    appLogger.info(
        'SQL: ALTER TABLE public.circles ADD COLUMN IF NOT EXISTS questions JSONB;');

    await supabase.rpc('exec_sql', params: {
      'sql':
          'ALTER TABLE public.circles ADD COLUMN IF NOT EXISTS questions JSONB;'
    });

    appLogger.info('✅ Migration applied successfully!');

    // Verify the column exists
    appLogger.info('\nVerifying column exists...');
    final result =
        await supabase.from('circles').select().limit(1).maybeSingle();

    if (result != null && result.containsKey('questions')) {
      appLogger.info('✅ Column "questions" exists in circles table!');
    } else {
      appLogger.info('❌ Column "questions" not found in response');
    }
  } catch (e) {
    appLogger.info('Error: $e');
    appLogger.info('\nTrying alternative approach - using raw SQL...');

    // Alternative: Use a SQL function if it exists
    try {
      await supabase.from('circles').select('questions').limit(1);
      appLogger.info('✅ Column already exists!');
    } catch (e2) {
      appLogger.info('❌ Column does not exist. Error: $e2');
      appLogger.info('\nPlease apply this SQL manually in Supabase Dashboard:');
      appLogger.info(
          'ALTER TABLE public.circles ADD COLUMN IF NOT EXISTS questions JSONB;');
    }
  }
}
