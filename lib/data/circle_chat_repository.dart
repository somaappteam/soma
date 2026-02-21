import 'dart:async';

import 'package:supabase_flutter/supabase_flutter.dart';
import '../core/di/locator.dart';

class CircleChatRepository {
  final _supabase = Supabase.instance.client;
  final List<Map<String, String>> _pendingSends = [];
  Timer? _retryTimer;

  String? get currentUserId => _supabase.auth.currentUser?.id;

  Stream<List<Map<String, dynamic>>> getMessagesStream(String circleId) {
    return _supabase
        .from('chat_messages')
        .stream(primaryKey: ['id'])
        .eq('circle_id', circleId)
        .order('created_at', ascending: true);
  }

  Future<void> sendMessage({
    required String circleId,
    required String content,
  }) async {
    final uid = currentUserId;
    if (uid == null) throw Exception("Not logged in");

    final circle = await _supabase
        .from('circles')
        .select('chat_muted_user_ids')
        .eq('id', circleId)
        .maybeSingle();
    final mutedIds = (circle?['chat_muted_user_ids'] as List?)
            ?.map((e) => e.toString())
            .toSet() ??
        <String>{};
    if (mutedIds.contains(uid)) {
      throw Exception('Chat is muted for you in this circle.');
    }

    try {
      await _supabase.from('chat_messages').insert({
        'circle_id': circleId,
        'sender_id': uid,
        'content': content,
        'read_by': [uid],
      });
    } catch (_) {
      _pendingSends.add({'circle_id': circleId, 'sender_id': uid, 'content': content});
      _ensureRetryLoop();
      rethrow;
    }
  }

  void _ensureRetryLoop() {
    _retryTimer ??= Timer.periodic(const Duration(seconds: 12), (_) async {
      if (_pendingSends.isEmpty) {
        _retryTimer?.cancel();
        _retryTimer = null;
        return;
      }
      final pending = List<Map<String, String>>.from(_pendingSends);
      _pendingSends.clear();
      for (final p in pending) {
        try {
          await _supabase.from('chat_messages').insert({
            'circle_id': p['circle_id'],
            'sender_id': p['sender_id'],
            'content': p['content'],
            'read_by': [p['sender_id']],
          });
        } catch (_) {
          _pendingSends.add(p);
        }
      }
    });
  }

  Future<void> markRead(String messageId) async {
    try {
      await _supabase.rpc('mark_chat_message_read', params: {'message_id': messageId});
    } catch (_) {}
  }

  Future<void> markReadBatch(List<String> messageIds) async {
    for (final id in messageIds) {
      await markRead(id);
    }
  }

  Future<void> toggleReaction({
    required String messageId,
    required String emoji,
  }) async {
    final uid = currentUserId;
    if (uid == null) return;

    final row = await _supabase
        .from('chat_messages')
        .select('reactions')
        .eq('id', messageId)
        .maybeSingle();
    final reactionsRaw = (row?['reactions'] as Map<String, dynamic>?) ?? {};
    final users = ((reactionsRaw[emoji] as List?) ?? const [])
        .map((e) => e.toString())
        .toSet();
    if (users.contains(uid)) {
      users.remove(uid);
    } else {
      users.add(uid);
    }

    final next = <String, dynamic>{...reactionsRaw};
    if (users.isEmpty) {
      next.remove(emoji);
    } else {
      next[emoji] = users.toList();
    }

    await _supabase
        .from('chat_messages')
        .update({'reactions': next})
        .eq('id', messageId);
  }

  Future<void> deleteMessage(String messageId) async {
    final uid = currentUserId;
    if (uid == null) return;

    await _supabase
        .from('chat_messages')
        .delete()
        .eq('id', messageId)
        .eq('sender_id', uid);
  }

  Future<void> hostDeleteMessage(String messageId) async {
    await _supabase.from('chat_messages').delete().eq('id', messageId);
  }

  Future<void> setUserMutedInCircle({
    required String circleId,
    required String targetUserId,
    required bool muted,
  }) async {
    final circle = await _supabase
        .from('circles')
        .select('chat_muted_user_ids')
        .eq('id', circleId)
        .maybeSingle();
    final mutedIds = (circle?['chat_muted_user_ids'] as List?)
            ?.map((e) => e.toString())
            .toSet() ??
        <String>{};
    if (muted) {
      mutedIds.add(targetUserId);
    } else {
      mutedIds.remove(targetUserId);
    }

    await _supabase
        .from('circles')
        .update({'chat_muted_user_ids': mutedIds.toList()}).eq('id', circleId);
  }

  Future<void> setSlowMode({
    required String circleId,
    required int seconds,
  }) async {
    await _supabase
        .from('circles')
        .update({'chat_slow_mode_seconds': seconds}).eq('id', circleId);
  }

  Future<void> pinHighlight({
    required String circleId,
    required String message,
  }) async {
    await _supabase
        .from('circles')
        .update({'chat_highlight_text': message}).eq('id', circleId);
  }

  Stream<Map<String, dynamic>?> streamCircleChatConfig(String circleId) {
    return _supabase
        .from('circles')
        .stream(primaryKey: ['id'])
        .eq('id', circleId)
        .map((rows) => rows.isEmpty ? null : rows.first);
  }
}

CircleChatRepository get circleChatRepository => locator<CircleChatRepository>();
