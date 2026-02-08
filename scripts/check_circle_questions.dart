import 'package:supabase_flutter/supabase_flutter.dart';

/// Quick script to check if a circle's questions are being stored and retrieved correctly
void main() async {
  // Initialize Supabase
  await Supabase.initialize(
    url: 'YOUR_SUPABASE_URL',
    anonKey: 'YOUR_ANON_KEY',
  );

  final supabase = Supabase.instance.client;
  
  // Fetch the most recent circle
  print('Fetching most recent circle...');
  final response = await supabase
      .from('circles')
      .select()
      .order('created_at', ascending: false)
      .limit(1)
      .maybeSingle();
  
  if (response == null) {
    print('No circles found');
    return;
  }
  
  print('\n=== Circle Data ===');
  print('ID: ${response['id']}');
  print('Name: ${response['name']}');
  print('Status: ${response['status']}');
  print('Questions count field: ${response['questions_count']}');
  print('Questions column exists: ${response.containsKey('questions')}');
  
  if (response.containsKey('questions')) {
    final questions = response['questions'];
    print('Questions type: ${questions.runtimeType}');
    print('Questions value: $questions');
    
    if (questions is List) {
      print('Questions array length: ${questions.length}');
      if (questions.isNotEmpty) {
        print('First question: ${questions.first}');
      }
    }
  } else {
    print('ERROR: questions column does not exist in response!');
  }
}
