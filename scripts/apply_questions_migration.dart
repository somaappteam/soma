import 'package:supabase_flutter/supabase_flutter.dart';

/// Apply the add_questions_to_circles migration directly
void main() async {
  print('Initializing Supabase...');
  
  // Get environment variables or prompt for them
  final supabaseUrl = const String.fromEnvironment('SUPABASE_URL');
  final supabaseKey = const String.fromEnvironment('SUPABASE_KEY');
  
  await Supabase.initialize(
    url: supabaseUrl,
    anonKey: supabaseKey,
  );

  final supabase = Supabase.instance.client;
  
  try {
    print('\nApplying migration: add_questions_to_circles');
    print('SQL: ALTER TABLE public.circles ADD COLUMN IF NOT EXISTS questions JSONB;');
    
    await supabase.rpc('exec_sql', params: {
      'sql': 'ALTER TABLE public.circles ADD COLUMN IF NOT EXISTS questions JSONB;'
    });
    
    print('✅ Migration applied successfully!');
    
    // Verify the column exists
    print('\nVerifying column exists...');
    final result = await supabase
        .from('circles')
        .select()
        .limit(1)
        .maybeSingle();
    
    if (result != null && result.containsKey('questions')) {
      print('✅ Column "questions" exists in circles table!');
    } else {
      print('❌ Column "questions" not found in response');
    }
    
  } catch (e) {
    print('Error: $e');
    print('\nTrying alternative approach - using raw SQL...');
    
    // Alternative: Use a SQL function if it exists
    try {
      await supabase.from('circles').select('questions').limit(1);
      print('✅ Column already exists!');
    } catch (e2) {
      print('❌ Column does not exist. Error: $e2');
      print('\nPlease apply this SQL manually in Supabase Dashboard:');
      print('ALTER TABLE public.circles ADD COLUMN IF NOT EXISTS questions JSONB;');
    }
  }
}
