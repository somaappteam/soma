import 'package:supabase/supabase.dart';

const String supabaseUrl = 'https://bnbjteedohflgkarfaxk.supabase.co';
const String serviceRoleKey =
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImJuYmp0ZWVkb2hmbGdrYXJmYXhrIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc2OTcwMDI2NCwiZXhwIjoyMDg1Mjc2MjY0fQ.jTZOgpQ7Fy1HlUT0YldRAtr6Bvwti_Al1hfaP5Bz0Nc';

void main() async {
  final client = SupabaseClient(supabaseUrl, serviceRoleKey);

  print('--- Checking for Ghost Circles ---');

  try {
    // 1. Fetch all open circles (lobby/active)
    final response = await client
        .from('circles')
        .select('id, name, host_id, status')
        .or('status.eq.lobby,status.eq.active');
    
    final circles = List<Map<String, dynamic>>.from(response);
    print('Found ${circles.length} open circles.');

    int ghostsFound = 0;

    for (final circle in circles) {
      final circleId = circle['id'] as String;
      final hostId = circle['host_id'] as String;
      final name = circle['name'];

      // 2. Check if host is still a participant
      final hostParticipant = await client
          .from('circle_participants')
          .select('role') // minimal select
          .eq('circle_id', circleId)
          .eq('user_id', hostId)
          .maybeSingle();

      // 3. If host missing, end the circle
      if (hostParticipant == null) {
        print("MISSING HOST: Circle '$name' ($circleId). Host $hostId is not in participants.");
        ghostsFound++;
        
        print('  -> Closing circle...');
        await client.from('circles').update({'status': 'ended'}).eq('id', circleId);
        print('  -> Closed.');
      } else {
        // print("  OK: Circle '$name' has host.");
      }
    }

    if (ghostsFound == 0) {
      print('No ghost circles found!');
    } else {
      print('Cleaned up $ghostsFound ghost circles.');
    }

  } catch (e) {
    print('Error: $e');
  }
}
