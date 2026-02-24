import 'package:soma/core/services/app_logger.dart';
import 'package:supabase/supabase.dart';

void main() async {
  appLogger.info('Connecting to Supabase...');
  final client = SupabaseClient(
    'https://bnbjteedohflgkarfaxk.supabase.co',
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImJuYmp0ZWVkb2hmbGdrYXJmYXhrIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Njk3MDAyNjQsImV4cCI6MjA4NTI3NjI2NH0.m8ua_6P0AtykUgLbLuxeE3o3i4Dwfw_xPsvODORlKtM',
  );

  appLogger.info('Fetching latest circle...');
  try {
    final response = await client
        .from('circles')
        .select('id, name, created_at, questions')
        .order('created_at', ascending: false)
        .limit(1)
        .maybeSingle();

    if (response == null) {
      appLogger.info('No circles found.');
      return;
    }

    appLogger.info('Latest Circle ID: ${response['id']}');
    appLogger.info('Name: ${response['name']}');
    appLogger.info('Created At: ${response['created_at']}');

    final questions = response['questions'];
    appLogger.info('Questions Type: ${questions.runtimeType}');

    if (questions == null) {
      appLogger.info('Questions is NULL');
    } else if (questions is List) {
      appLogger.info('Questions Count: ${questions.length}');
      if (questions.isNotEmpty) {
        appLogger.info('First Question: ${questions.first}');
      } else {
        appLogger.info('Questions list is EMPTY');
      }
    } else {
      appLogger.info('Questions content (raw): $questions');
    }
  } catch (e) {
    appLogger.info('Error: $e');
  }
}
