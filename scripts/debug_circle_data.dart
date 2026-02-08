import 'package:supabase/supabase.dart';


void main() async {
  print('Connecting to Supabase...');
  final client = SupabaseClient(
    'https://bnbjteedohflgkarfaxk.supabase.co',
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImJuYmp0ZWVkb2hmbGdrYXJmYXhrIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Njk3MDAyNjQsImV4cCI6MjA4NTI3NjI2NH0.m8ua_6P0AtykUgLbLuxeE3o3i4Dwfw_xPsvODORlKtM',
  );

  print('Fetching latest circle...');
  try {
    final response = await client
        .from('circles')
        .select('id, name, created_at, questions')
        .order('created_at', ascending: false)
        .limit(1)
        .maybeSingle();

    if (response == null) {
      print('No circles found.');
      return;
    }

    print('Latest Circle ID: ${response['id']}');
    print('Name: ${response['name']}');
    print('Created At: ${response['created_at']}');
    
    final questions = response['questions'];
    print('Questions Type: ${questions.runtimeType}');
    
    if (questions == null) {
      print('Questions is NULL');
    } else if (questions is List) {
      print('Questions Count: ${questions.length}');
      if (questions.isNotEmpty) {
        print('First Question: ${questions.first}');
      } else {
        print('Questions list is EMPTY');
      }
    } else {
      print('Questions content (raw): $questions');
    }

  } catch (e) {
    print('Error: $e');
  }
}
