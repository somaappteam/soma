import 'package:supabase_flutter/supabase_flutter.dart';

class LeaderboardRepository {
  final _supabase = Supabase.instance.client;

  Future<List<Map<String, dynamic>>> getGlobalLeaderboard({int limit = 50}) async {
    final response = await _supabase
        .from('leaderboard')
        .select()
        .order('xp', ascending: false)
        .limit(limit);
    
    return List<Map<String, dynamic>>.from(response);
  }

  Future<List<Map<String, dynamic>>> searchUsers(String query) async {
    final response = await _supabase
        .from('leaderboard')
        .select()
        .ilike('username', '%$query%')
        .order('xp', ascending: false)
        .limit(20);
        
    return List<Map<String, dynamic>>.from(response);
  }

  Future<int> getUserRank(int xp) async {
    final response = await _supabase
        .from('leaderboard')
        .count(CountOption.exact)
        .gt('xp', xp);
    
    return response + 1;
  }
}

final leaderboardRepository = LeaderboardRepository();
