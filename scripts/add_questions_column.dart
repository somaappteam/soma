import 'package:supabase_flutter/supabase_flutter.dart';

/// Apply the questions column migration to the circles table
void main() async {
  print('🔧 Applying questions column migration...\n');
  
  // Initialize Supabase (using environment from app)
  await Supabase.initialize(
    url: 'https://YOUR_PROJECT_REF.supabase.co',
    anonKey: 'YOUR_ANON_KEY',
  );

  final supabase = Supabase.instance.client;
  
  try {
    print('Step 1: Checking if questions column exists...');
    
    // Try to select questions column
    try {
      final test = await supabase
          .from('circles')
          .select('questions')
          .limit(1)
          .maybeSingle();
      
      if (test != null && test.containsKey('questions')) {
        print('✅ Questions column already exists!');
        print('   Sample data: ${test['questions']}');
        return;
      }
    } catch (e) {
      print('   Column does not exist or has error: $e');
    }
    
    print('\nStep 2: Adding questions column via RPC...');
    
    // Use a stored procedure approach (if available) or direct SQL
    // Note: This requires the supabase user to have proper permissions
    
    print('\n⚠️  Cannot add column directly from Dart client.');
    print('   PostgreSQL DDL operations require elevated permissions.');
    print('\n📋 Please run this SQL manually in Supabase Dashboard:\n');
    print('   ALTER TABLE public.circles ADD COLUMN IF NOT EXISTS questions JSONB DEFAULT \'[]\'::jsonb;\n');
    print('\n🌐 Go to: https://supabase.com/dashboard/project/YOUR_PROJECT/sql-editor\n');
    
  } catch (e) {
    print('❌ Error: $e');
  }
  
  print('\nAfter running the SQL:');
  print('1. Verify with: SELECT id, name, questions FROM circles LIMIT 1;');
  print('2. Restart your Flutter app');
  print('3. Create a new circle');
  print('4. Questions should now appear in the quiz!');
}
