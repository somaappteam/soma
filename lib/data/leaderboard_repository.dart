import 'package:supabase_flutter/supabase_flutter.dart';

class LeaderboardRepository {
  final _supabase = Supabase.instance.client;

  Future<List<Map<String, dynamic>>> getGlobalLeaderboard({int limit = 50}) async {
    final response = await _supabase
        .from('leaderboard')
        .select()
        .order('xp', ascending: false) // 'xp' column confirmed from schema
        .limit(limit);
    
    return List<Map<String, dynamic>>.from(response);
  }
}

final leaderboardRepository = LeaderboardRepository();
