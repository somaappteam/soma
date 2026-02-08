import 'package:supabase_flutter/supabase_flutter.dart';

class UserSession {
  final String id;
  final String deviceId;
  final String? deviceName;
  final String? platform;
  final DateTime lastSeen;
  final bool isCurrent;

  const UserSession({
    required this.id,
    required this.deviceId,
    required this.deviceName,
    required this.platform,
    required this.lastSeen,
    required this.isCurrent,
  });

  factory UserSession.fromRow(Map<String, dynamic> row) {
    final rawSeen = row['last_seen'];
    final lastSeen = rawSeen is DateTime
        ? rawSeen
        : DateTime.parse(rawSeen.toString());
    return UserSession(
      id: row['id'].toString(),
      deviceId: row['device_id']?.toString() ?? '',
      deviceName: row['device_name']?.toString(),
      platform: row['platform']?.toString(),
      lastSeen: lastSeen,
      isCurrent: row['is_current'] == true,
    );
  }
}

class SessionRepository {
  final _supabase = Supabase.instance.client;

  Stream<List<UserSession>> streamSessions() {
    final uid = _supabase.auth.currentUser?.id;
    if (uid == null) return const Stream.empty();

    return _supabase
        .from('user_sessions')
        .stream(primaryKey: ['id'])
        .eq('user_id', uid)
        .order('last_seen', ascending: false)
        .map((rows) => rows.map(UserSession.fromRow).toList());
  }

  Future<void> endCurrentSession(String deviceId) async {
    final uid = _supabase.auth.currentUser?.id;
    if (uid == null) return;

    await _supabase
        .from('user_sessions')
        .update({'is_current': false})
        .eq('user_id', uid)
        .eq('device_id', deviceId);
  }
}

final sessionRepository = SessionRepository();
