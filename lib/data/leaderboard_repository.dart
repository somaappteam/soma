import 'package:flutter/foundation.dart';
import 'package:soma/core/di/locator.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LeaderboardRepository {
  final _supabase = Supabase.instance.client;

  // ─────────────────────────── Global ─────────────────────────────────────────

  Future<List<Map<String, dynamic>>> getGlobalLeaderboard({final int limit = 50}) async {
    final response = await _supabase
        .from('leaderboard')
        .select()
        .order('xp', ascending: false)
        .limit(limit);

    return List<Map<String, dynamic>>.from(response);
  }

  // ─────────────────────────── Language-filtered ──────────────────────────────

  /// Returns top XP players who are learning [language].
  Future<List<Map<String, dynamic>>> getLanguageLeaderboard(
    final String language, {
    final int limit = 50,
  }) async {
    try {
      // The leaderboard view joins profiles; filter by learning_languages array.
      final response = await _supabase
          .from('leaderboard')
          .select()
          .contains('learning_languages', [language])
          .order('xp', ascending: false)
          .limit(limit);
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      debugPrint('LeaderboardRepository.getLanguageLeaderboard: $e');
      return [];
    }
  }

  // ─────────────────────────── Weekly ─────────────────────────────────────────

  /// Returns top players active in the last 7 days, ordered by XP.
  Future<List<Map<String, dynamic>>> getWeeklyLeaderboard({final int limit = 50}) async {
    try {
      final cutoff = DateTime.now().subtract(const Duration(days: 7)).toIso8601String();
      final response = await _supabase
          .from('leaderboard')
          .select()
          .gte('last_active_date', cutoff.split('T').first)
          .order('xp', ascending: false)
          .limit(limit);
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      debugPrint('LeaderboardRepository.getWeeklyLeaderboard: $e');
      return [];
    }
  }

  // ─────────────────────────── Friends-only ───────────────────────────────────

  /// Returns leaderboard entries filtered to [friendIds].
  Future<List<Map<String, dynamic>>> getFriendsLeaderboard(
    final List<String> friendIds, {
    final int limit = 50,
  }) async {
    if (friendIds.isEmpty) return [];
    try {
      final response = await _supabase
          .from('leaderboard')
          .select()
          .inFilter('id', friendIds)
          .order('xp', ascending: false)
          .limit(limit);
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      debugPrint('LeaderboardRepository.getFriendsLeaderboard: $e');
      return [];
    }
  }

  // ─────────────────────────── Search ─────────────────────────────────────────

  Future<List<Map<String, dynamic>>> searchUsers(final String query) async {
    final response = await _supabase
        .from('leaderboard')
        .select()
        .ilike('username', '%$query%')
        .order('xp', ascending: false)
        .limit(20);

    return List<Map<String, dynamic>>.from(response);
  }

  // ─────────────────────────── Username lookup ────────────────────────────────

  /// Resolves a username to a leaderboard row (used for deep links).
  Future<Map<String, dynamic>?> fetchByUsername(final String username) async {
    try {
      final response = await _supabase
          .from('leaderboard')
          .select()
          .ilike('username', username)
          .maybeSingle();
      return response;
    } catch (e) {
      debugPrint('LeaderboardRepository.fetchByUsername: $e');
      return null;
    }
  }

  // ─────────────────────────── Rank ───────────────────────────────────────────

  Future<int> getUserRank(final int xp) async {
    final response = await _supabase
        .from('leaderboard')
        .count(CountOption.exact)
        .gt('xp', xp);

    return response + 1;
  }

  // ─────────────────────────── Friend IDs helper ──────────────────────────────

  /// Fetches accepted friend IDs for [uid] from the friendships table.
  Future<List<String>> getFriendIds(final String uid) async {
    try {
      final rows = await _supabase
          .from('friendships')
          .select('requester_id, addressee_id')
          .or('requester_id.eq.$uid,addressee_id.eq.$uid')
          .eq('status', 'accepted');

      return rows.map<String>((final r) {
        final requesterId = r['requester_id'] as String;
        return requesterId == uid
            ? r['addressee_id'] as String
            : requesterId;
      }).toList();
    } catch (e) {
      debugPrint('LeaderboardRepository.getFriendIds: $e');
      return [];
    }
  }
}

LeaderboardRepository get leaderboardRepository => locator<LeaderboardRepository>();
