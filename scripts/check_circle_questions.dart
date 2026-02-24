import 'package:soma/core/services/app_logger.dart';
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
  appLogger.info('Fetching most recent circle...');
  final response = await supabase
      .from('circles')
      .select()
      .order('created_at', ascending: false)
      .limit(1)
      .maybeSingle();

  if (response == null) {
    appLogger.info('No circles found');
    return;
  }

  appLogger.info('\n=== Circle Data ===');
  appLogger.info('ID: ${response['id']}');
  appLogger.info('Name: ${response['name']}');
  appLogger.info('Status: ${response['status']}');
  appLogger.info('Questions count field: ${response['questions_count']}');
  appLogger
      .info('Questions column exists: ${response.containsKey('questions')}');

  if (response.containsKey('questions')) {
    final questions = response['questions'];
    appLogger.info('Questions type: ${questions.runtimeType}');
    appLogger.info('Questions value: $questions');

    if (questions is List) {
      appLogger.info('Questions array length: ${questions.length}');
      if (questions.isNotEmpty) {
        appLogger.info('First question: ${questions.first}');
      }
    }
  } else {
    appLogger.info('ERROR: questions column does not exist in response!');
  }
}
