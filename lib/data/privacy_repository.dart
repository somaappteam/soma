import 'package:supabase_flutter/supabase_flutter.dart';
import '../core/di/locator.dart';

class PrivacyRepository {
  final _supabase = Supabase.instance.client;

  Future<Map<String, dynamic>> exportUserDataSnapshot() async {
    final uid = _supabase.auth.currentUser?.id;
    if (uid == null) throw StateError('Not authenticated');

    final snapshot = <String, dynamic>{
      'exported_at': DateTime.now().toUtc().toIso8601String(),
      'user_id': uid,
    };

    snapshot['profile'] = await _safeSelectSingle(
      table: 'profiles',
      filters: (q) => q.eq('id', uid),
    );
    snapshot['user_stats'] = await _safeSelectSingle(
      table: 'user_stats',
      filters: (q) => q.eq('user_id', uid),
    );
    snapshot['user_settings'] = (snapshot['profile'] as Map<String, dynamic>?)?['settings'];

    snapshot['user_courses'] = await _safeSelectList(
      table: 'user_courses',
      filters: (q) => q.eq('user_id', uid),
    );
    snapshot['friendships'] = await _safeSelectList(
      table: 'friendships',
      filters: (q) => q.or('requester_id.eq.$uid,addressee_id.eq.$uid'),
    );
    snapshot['message_requests'] = await _safeSelectList(
      table: 'message_requests',
      filters: (q) => q.or('requester_id.eq.$uid,recipient_id.eq.$uid'),
    );
    snapshot['messages'] = await _safeSelectList(
      table: 'messages',
      filters: (q) => q.or('sender_id.eq.$uid,receiver_id.eq.$uid').order('created_at'),
      limit: 5000,
    );
    snapshot['conversations'] = await _safeSelectList(
      table: 'conversations',
      filters: (q) => q.eq('user_id', uid),
    );
    snapshot['notifications'] = await _safeSelectList(
      table: 'notifications',
      filters: (q) => q.eq('user_id', uid).order('created_at'),
      limit: 2000,
    );
    snapshot['exchange_events'] = await _safeSelectList(
      table: 'exchange_events',
      filters: (q) => q.eq('user_id', uid).order('created_at'),
      limit: 2000,
    );
    snapshot['chat_reports'] = await _safeSelectList(
      table: 'chat_reports',
      filters: (q) => q.eq('reporter_id', uid).order('created_at'),
    );
    snapshot['user_reports'] = await _safeSelectList(
      table: 'user_reports',
      filters: (q) => q.eq('reporter_id', uid).order('created_at'),
    );
    snapshot['user_sessions'] = await _safeSelectList(
      table: 'user_sessions',
      filters: (q) => q.eq('user_id', uid).order('last_seen', ascending: false),
      limit: 300,
    );

    return snapshot;
  }

  Future<Map<String, dynamic>?> _safeSelectSingle({
    required String table,
    required PostgrestTransformBuilder<dynamic> Function(PostgrestFilterBuilder<dynamic>) filters,
  }) async {
    try {
      final res = await filters(_supabase.from(table).select()).maybeSingle();
      if (res == null) return null;
      if (res is Map<String, dynamic>) return res;
      if (res is Map) return Map<String, dynamic>.from(res);
      return null;
    } catch (e) {
      return {'_error': e.toString()};
    }
  }

  Future<List<Map<String, dynamic>>> _safeSelectList({
    required String table,
    required PostgrestTransformBuilder<dynamic> Function(PostgrestFilterBuilder<dynamic>) filters,
    int? limit,
  }) async {
    try {
      var query = filters(_supabase.from(table).select());
      if (limit != null && limit > 0) {
        query = query.limit(limit);
      }
      final data = await query;
      if (data is List) {
        return data.whereType<Map>().map((e) => Map<String, dynamic>.from(e)).toList();
      }
      return const [];
    } catch (e) {
      return [
        {'_error': e.toString()}
      ];
    }
  }

  Future<void> requestAccountDeletion() async {
    final uid = _supabase.auth.currentUser?.id;
    if (uid == null) throw StateError('Not authenticated');

    final now = DateTime.now().toUtc().toIso8601String();
    await _supabase.from('account_deletion_requests').upsert({
      'user_id': uid,
      'status': 'pending',
      'requested_at': now,
    }, onConflict: 'user_id');
  }
}

PrivacyRepository get privacyRepository => locator<PrivacyRepository>();
