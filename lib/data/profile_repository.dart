import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/user_profile.dart';
import '../core/database/database_helper.dart';
import 'package:flutter/foundation.dart';

class ProfileRepository {
  final _supabase = Supabase.instance.client;

  // Get current user ID
  String? get currentUserId => _supabase.auth.currentUser?.id;

  Future<UserProfile?> fetchProfile({String? userId}) async {
    final uid = userId ?? currentUserId;
    if (uid == null) return null;

    UserProfile? localProfile;
    // Try local first
    try {
      final local = await DatabaseHelper.instance.getProfile(uid);
      if (local != null) {
        localProfile = UserProfile(
          id: local['id'] ?? uid,
          displayName: local['display_name'] ?? 'User',
          username: local['username'] ?? 'learner',
          bio: local['bio'] ?? '',
          location: local['location'] ?? '',
          dailyGoalMinutes: local['daily_goal_minutes'] ?? 10,
          totalXp: local['total_xp'] ?? 0,
          avatarUrl: local['avatar_url'],
          showOnlineStatus: true,
        );
      }
    } catch (e) {
      debugPrint("Local profile fetch failed: $e");
    }

    try {
      final data = await _supabase.from('profiles').select().eq('id', uid).single();
      
      // Update local mirror
      await DatabaseHelper.instance.upsertProfile(data);

      return UserProfile(
        id: data['id'] ?? uid,
        displayName: data['display_name'] ?? 'User',
        username: data['username'] ?? 'learner',
        bio: data['bio'] ?? '',
        location: data['location'] ?? '',
        dailyGoalMinutes: data['daily_goal_minutes'] ?? 10,
        totalXp: data['total_xp'] ?? 0,
        avatarUrl: data['avatar_url'],
        showOnlineStatus: (data['settings'] as Map<String, dynamic>?)?['show_online_status'] ?? true,
      );
    } catch (e) {
      return localProfile;
    }
  }

  Future<void> updateProfile(UserProfile profile) async {
    final uid = currentUserId;
    if (uid == null) return;

    final payload = {
      'id': uid,
      'display_name': profile.displayName,
      'username': profile.username,
      'bio': profile.bio,
      'location': profile.location,
      'avatar_url': profile.avatarUrl,
      'daily_goal_minutes': profile.dailyGoalMinutes,
      'updated_at': DateTime.now().toIso8601String(),
    };

    await _supabase.from('profiles').upsert(payload);

    // Update local mirror
    await DatabaseHelper.instance.upsertProfile({
      ...payload,
      'total_xp': profile.totalXp,
      'avatar_url': profile.avatarUrl,
    });
  }

  // Fetch multiple profiles by IDs
  Future<List<Map<String, dynamic>>> getProfilesByIds(List<String> userIds) async {
    if (userIds.isEmpty) return [];
    final data = await _supabase.from('profiles').select().inFilter('id', userIds);
    return List<Map<String, dynamic>>.from(data);
  }

  // Fetch global exchange candidates (not limited to friends).
  Future<List<Map<String, dynamic>>> getExchangeCandidateProfiles({
    int limit = 100,
    int offset = 0,
  }) async {
    final uid = currentUserId;
    final query = _supabase
        .from('profiles')
        .select(
          'id, username, daily_goal_minutes, total_xp, settings, updated_at, '
          'native_languages, learning_languages, timezone, completed_exchange_sessions, report_count',
        )
        .order('updated_at', ascending: false)
        .range(offset, offset + limit - 1);

    final data = uid == null ? await query : await query.neq('id', uid);
    return List<Map<String, dynamic>>.from(data);
  }

  Stream<List<Map<String, dynamic>>> streamExchangeCandidateProfiles({int limit = 120}) {
    final uid = currentUserId;
    final stream = _supabase
        .from('profiles')
        .stream(primaryKey: ['id'])
        .order('updated_at', ascending: false)
        .limit(limit)
        .map((rows) => rows.map((e) => Map<String, dynamic>.from(e)).toList());

    if (uid == null) return stream;
    return stream.map((rows) => rows.where((row) => row['id']?.toString() != uid).toList());
  }

  Future<List<Map<String, dynamic>>> getExchangeCandidateProfilesBefore({
    required DateTime before,
    int limit = 100,
  }) async {
    final uid = currentUserId;
    final query = _supabase
        .from('profiles')
        .select(
          'id, username, daily_goal_minutes, total_xp, settings, updated_at, '
          'native_languages, learning_languages, timezone, completed_exchange_sessions, report_count',
        )
        .lt('updated_at', before.toIso8601String())
        .order('updated_at', ascending: false)
        .limit(limit);
    final data = uid == null ? await query : await query.neq('id', uid);
    return List<Map<String, dynamic>>.from(data);
  }

}

final profileRepository = ProfileRepository();
