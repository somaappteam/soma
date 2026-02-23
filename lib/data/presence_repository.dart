import 'package:soma/core/di/locator.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PresenceRepository {
  PresenceRepository({final SupabaseClient? client})
      : _supabase = client ?? Supabase.instance.client;

  final SupabaseClient _supabase;

  static const Duration onlineThreshold = Duration(minutes: 5);

  Stream<bool> streamOnlineStatus(final String userId) {
    return _supabase
        .from('user_sessions')
        .stream(primaryKey: ['id'])
        .eq('user_id', userId)
        .map(_isOnlineFromRows);
  }

  Stream<Map<String, bool>> streamMultipleOnlineStatuses(final List<String> userIds) {
    if (userIds.isEmpty) return Stream.value({});
    return _supabase
        .from('user_sessions')
        .stream(primaryKey: ['id'])
        .inFilter('user_id', userIds)
        .map((final rows) {
      final grouped = <String, List<Map<String, dynamic>>>{};
      for (final row in rows) {
        final uid = row['user_id']?.toString();
        if (uid == null) continue;
        grouped.putIfAbsent(uid, () => []).add(row);
      }
      return {
        for (final uid in userIds) uid: _isOnlineFromRows(grouped[uid] ?? []),
      };
    });
  }

  Future<bool> fetchOnlineStatus(final String userId) async {
    final rows = await _supabase
        .from('user_sessions')
        .select('user_id, last_seen, is_current')
        .eq('user_id', userId);
    return _isOnlineFromRows(List<Map<String, dynamic>>.from(rows));
  }

  Future<Map<String, bool>> fetchOnlineStatuses(final List<String> userIds) async {
    if (userIds.isEmpty) return {};
    final rows = await _supabase
        .from('user_sessions')
        .select('user_id, last_seen, is_current')
        .inFilter('user_id', userIds);
    final grouped = <String, List<Map<String, dynamic>>>{};
    for (final row in rows) {
      final userId = row['user_id']?.toString();
      if (userId == null) continue;
      grouped.putIfAbsent(userId, () => []).add(Map<String, dynamic>.from(row));
    }
    return {
      for (final entry in grouped.entries) entry.key: _isOnlineFromRows(entry.value),
    };
  }

  bool _isOnlineFromRows(final List<Map<String, dynamic>> rows) {
    if (rows.isEmpty) return false;
    final now = DateTime.now();
    for (final row in rows) {
      if (row['is_current'] != true) continue;
      final rawSeen = row['last_seen'];
      if (rawSeen == null) continue;
      final lastSeen = rawSeen is DateTime
          ? rawSeen
          : DateTime.tryParse(rawSeen.toString());
      if (lastSeen == null) continue;
      if (now.difference(lastSeen.toLocal()).abs() <= onlineThreshold) {
        return true;
      }
    }
    return false;
  }
}

PresenceRepository get presenceRepository => locator<PresenceRepository>();
