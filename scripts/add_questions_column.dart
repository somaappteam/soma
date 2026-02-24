import 'package:soma/core/services/app_logger.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Apply the questions column migration to the circles table
void main() async {
  appLogger.info('🔧 Applying questions column migration...\n');

  // Initialize Supabase (using environment from app)
  await Supabase.initialize(
    url: 'https://YOUR_PROJECT_REF.supabase.co',
    anonKey: 'YOUR_ANON_KEY',
  );

  final supabase = Supabase.instance.client;

  try {
    appLogger.info('Step 1: Checking if questions column exists...');

    // Try to select questions column
    try {
      final test = await supabase
          .from('circles')
          .select('questions')
          .limit(1)
          .maybeSingle();

      if (test != null && test.containsKey('questions')) {
        appLogger.info('✅ Questions column already exists!');
        appLogger.info('   Sample data: ${test['questions']}');
        return;
      }
    } catch (e) {
      appLogger.info('   Column does not exist or has error: $e');
    }

    appLogger.info('\nStep 2: Adding questions column via RPC...');

    // Use a stored procedure approach (if available) or direct SQL
    // Note: This requires the supabase user to have proper permissions

    appLogger.info('\n⚠️  Cannot add column directly from Dart client.');
    appLogger
        .info('   PostgreSQL DDL operations require elevated permissions.');
    appLogger
        .info('\n📋 Please run this SQL manually in Supabase Dashboard:\n');
    appLogger.info(
        '   ALTER TABLE public.circles ADD COLUMN IF NOT EXISTS questions JSONB DEFAULT \'[]\'::jsonb;\n');
    appLogger.info(
        '\n🌐 Go to: https://supabase.com/dashboard/project/YOUR_PROJECT/sql-editor\n');
  } catch (e) {
    appLogger.info('❌ Error: $e');
  }

  appLogger.info('\nAfter running the SQL:');
  appLogger
      .info('1. Verify with: SELECT id, name, questions FROM circles LIMIT 1;');
  appLogger.info('2. Restart your Flutter app');
  appLogger.info('3. Create a new circle');
  appLogger.info('4. Questions should now appear in the quiz!');
}
