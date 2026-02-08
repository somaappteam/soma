import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  const supabaseUrl = 'https://bnbjteedohflgkarfaxk.supabase.co';
  const supabaseKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImJuYmp0ZWVkb2hmbGdrYXJmYXhrIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Njk3MDAyNjQsImV4cCI6MjA4NTI3NjI2NH0.m8ua_6P0AtykUgLbLuxeE3o3i4Dwfw_xPsvODORlKtM';

  await Supabase.initialize(url: supabaseUrl, anonKey: supabaseKey);
  final client = Supabase.instance.client;

  print("Fetching latest circle...");

  try {
    final response = await client
        .from('circles')
        .select()
        .order('created_at', ascending: false)
        .limit(1);

    if (response.isEmpty) {
      print("No circles found.");
      return;
    }

    final circle = response.first;
    print("Latest Circle ID: ${circle['id']}");
    print("Name: ${circle['name']}");
    print("Status: ${circle['status']}");
    
    final questions = circle['questions'];
    if (questions == null) {
      print("Questions field is NULL");
    } else if (questions is List) {
      print("Questions Count: ${questions.length}");
      if (questions.isNotEmpty) {
        print("First Question Sample: ${questions.first['prompt']}");
      }
    } else {
      print("Questions field is of type: ${questions.runtimeType}");
      print("Value: $questions");
    }

  } catch (e) {
    print("Error fetching circle: $e");
  }
}
