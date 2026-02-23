import 'package:flutter/foundation.dart';
import 'package:soma/core/di/locator.dart';
import 'package:soma/models/activity_event.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ActivityFeedRepository {
  final _supabase = Supabase.instance.client;

  /// Returns the IDs of accepted friends for the current user.
  Future<List<String>> _getFriendIds() async {
    final uid = _supabase.auth.currentUser?.id;
    if (uid == null) return [];

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
  }

  /// Returns the latest activity events for all accepted friends.
  ///
  /// Joins `user_stats` (last active, quiz count) with `profiles`
  /// to build a lightweight activity feed — no extra table required.
  Future<List<ActivityEvent>> getFriendActivity({final int limit = 30}) async {
    final friendIds = await _getFriendIds();
    if (friendIds.isEmpty) return [];

    try {
      // Fetch each friend's most recent stats snapshot + profile.
      final rows = await _supabase
          .from('user_stats')
          .select('''
            user_id,
            total_quizzes,
            total_correct,
            total_questions,
            streak_days,
            updated_at,
            profiles!user_stats_user_id_fkey (
              username,
              display_name,
              total_xp,
              avatar_url
            )
          ''')
          .inFilter('user_id', friendIds)
          .order('updated_at', ascending: false)
          .limit(limit);

      return rows.map<ActivityEvent>((final r) {
        final profile = r['profiles'] as Map<String, dynamic>? ?? {};
        final username    = profile['username']?.toString()     ?? 'learner';
        final displayName = profile['display_name']?.toString() ?? username;
        final avatarUrl   = profile['avatar_url']?.toString();
        final xp          = (profile['total_xp'] as num?)?.toInt() ?? 0;
        final quizzes     = (r['total_quizzes'] as num?)?.toInt() ?? 0;
        final correct     = (r['total_correct'] as num?)?.toInt() ?? 0;
        final total       = (r['total_questions'] as num?)?.toInt() ?? 0;
        final streak      = (r['streak_days'] as num?)?.toInt() ?? 0;
        final ts          = DateTime.tryParse(r['updated_at'] as String? ?? '') ?? DateTime.now();

        String action;
        int xpDelta = 0;
        if (streak > 1) {
          action = 'is on a $streak-day streak 🔥';
        } else if (quizzes > 0 && total > 0) {
          final pct = (correct / total * 100).round();
          xpDelta = correct * 3; // approx
          action = 'completed a quiz · $pct% correct (+${xpDelta > 0 ? xpDelta : correct * 3} XP)';
        } else {
          action = 'is learning · $xp XP total';
        }

        return ActivityEvent(
          userId:      r['user_id'] as String,
          username:    username,
          displayName: displayName,
          avatarUrl:   avatarUrl,
          actionText:  action,
          xpDelta:     xpDelta,
          timestamp:   ts,
        );
      }).toList();
    } catch (e) {
      debugPrint('ActivityFeedRepository: error – $e');
      return [];
    }
  }
}

ActivityFeedRepository get activityFeedRepository => locator<ActivityFeedRepository>();
