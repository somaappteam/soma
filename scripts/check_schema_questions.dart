import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  const supabaseUrl = 'https://bnbjteedohflgkarfaxk.supabase.co';
  const supabaseKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImJuYmp0ZWVkb2hmbGdrYXJmYXhrIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Njk3MDAyNjQsImV4cCI6MjA4NTI3NjI2NH0.m8ua_6P0AtykUgLbLuxeE3o3i4Dwfw_xPsvODORlKtM';

  await Supabase.initialize(url: supabaseUrl, anonKey: supabaseKey);
  final client = Supabase.instance.client;

  print("Checking 'questions' column in 'circles' table...");

  try {
    // Try to select ONLY the 'questions' column. 
    // If it doesn't exist, this should throw a PostgrestException.
    final response = await client
        .from('circles')
        .select('questions')
        .limit(1);

    print("Column 'questions' exists!");
    if (response.isNotEmpty) {
      final val = response.first['questions'];
      if (val == null) {
        print('But the value is NULL in the first row.');
      } else {
        print('And it contains data: $val');
      }
    } else {
      print('Table is empty, but query succeeded.');
    }
  } catch (e) {
    print("Error querying 'questions' column: $e");
    if (e.toString().contains('does not exist') || e.toString().contains('42703')) {
      print("CONFIRMED: Column 'questions' DOES NOT EXIST.");
    }
  }
}
