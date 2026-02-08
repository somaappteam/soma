import 'package:supabase/supabase.dart';
import 'dart:io';

void main() async {
  final client = SupabaseClient(
    'https://bnbjteedohflgkarfaxk.supabase.co',
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImJuYmp0ZWVkb2hmbGdrYXJmYXhrIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Njk3MDAyNjQsImV4cCI6MjA4NTI3NjI2NH0.m8ua_6P0AtykUgLbLuxeE3o3i4Dwfw_xPsvODORlKtM',
  );

  final tables = ['vocabulary', 'sentences', 'courses', 'concepts', 'profiles', 'user_learned_items'];
  
  print('--- Supabase Row Counts ---');
  for (final table in tables) {
    try {
      final res = await client.from(table).select('id').count(CountOption.exact);
      print('$table: ${res.count}');
    } catch (e) {
      print('$table error: $e');
    }
  }
  exit(0);
}
