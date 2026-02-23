import 'package:supabase/supabase.dart';

const String supabaseUrl = 'https://bnbjteedohflgkarfaxk.supabase.co';
const String serviceRoleKey =
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImJuYmp0ZWVkb2hmbGdrYXJmYXhrIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc2OTcwMDI2NCwiZXhwIjoyMDg1Mjc2MjY0fQ.jTZOgpQ7Fy1HlUT0YldRAtr6Bvwti_Al1hfaP5Bz0Nc';

void main() async {
  final client = SupabaseClient(supabaseUrl, serviceRoleKey);

  print('--- Closing ALL open circles (lobby & active) ---');

  try {
    // 1. Fetch all open circles
    final response = await client
        .from('circles')
        .select('id, name, status')
        .or('status.eq.lobby,status.eq.active');
    
    final circles = List<Map<String, dynamic>>.from(response);
    print('Found ${circles.length} open circles.');

    if (circles.isEmpty) {
      print('No open circles to close.');
      return;
    }

    for (final circle in circles) {
      final circleId = circle['id'] as String;
      final name = circle['name'];
      final status = circle['status'];
      
      print("Closing circle '$name' (ID: $circleId, status: $status)...");
      await client.from('circles').update({'status': 'ended'}).eq('id', circleId);
      print('  -> Closed.');
    }

    print('\nDone! Closed ${circles.length} circles.');

  } catch (e) {
    print('Error: $e');
  }
}
