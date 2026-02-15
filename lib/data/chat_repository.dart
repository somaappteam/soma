import 'dart:async';

import 'package:supabase_flutter/supabase_flutter.dart';

import 'presence_repository.dart';

class ChatRepository {
  static const int _maxContentChars = 4000;
  static const int _maxMessagesPerMinute = 20;
  static const int _newConnectionMaxMessagesPerMinute = 8;

  final _supabase = Supabase.instance.client;
  final List<DateTime> _sendTimestamps = [];
  final List<_PendingDmSend> _pendingDmSends = [];
  Timer? _retryTimer;

  String? get currentUserId => _supabase.auth.currentUser?.id;

  Stream<void> inboxRefreshStream() {
    final uid = currentUserId;
    if (uid == null) return const Stream.empty();

    return _supabase
        .from('conversations')
        .stream(primaryKey: ['id'])
        .eq('user_id', uid)
        .map((_) {});
  }

  Future<void> sendMessage(String receiverId, String content) async {
    final uid = currentUserId;
    if (uid == null) throw Exception("Not logged in");

    final settings =
        await _supabase.from('profiles').select('settings').eq('id', uid).single();
    final blockedIds = (settings['settings']?['blocked_user_ids'] as List?)
            ?.map((e) => e.toString())
            .toList() ??
        [];
    if (blockedIds.contains(receiverId)) {
      throw Exception("You have blocked this user.");
    }

    if (content.length > _maxContentChars) {
      throw Exception('Message payload exceeds 4000 characters');
    }

    await _enforceDmRateLimit(receiverId);

    final startedAt = DateTime.now();
    try {
      await _supabase.from('messages').insert({
        'sender_id': uid,
        'receiver_id': receiverId,
        'content': content,
      });
      await recordLatencyEvent(
        metric: 'send_to_insert_ms',
        valueMs: DateTime.now().difference(startedAt).inMilliseconds,
        peerUserId: receiverId,
      );
    } catch (_) {
      _pendingDmSends.add(_PendingDmSend(receiverId: receiverId, content: content));
      _ensureRetryLoop();
      rethrow;
    }

    await setTypingState(otherUserId: receiverId, isTyping: false);
  }

  Future<void> _enforceDmRateLimit(String receiverId) async {
    final now = DateTime.now();
    _sendTimestamps.removeWhere((t) => now.difference(t).inSeconds >= 60);

    var allowed = _maxMessagesPerMinute;
    final uid = currentUserId;
    if (uid != null) {
      final friendship = await _supabase
          .from('friendships')
          .select('status,created_at')
          .or(
              'and(requester_id.eq.$uid,addressee_id.eq.$receiverId),and(requester_id.eq.$receiverId,addressee_id.eq.$uid)')
          .maybeSingle();
      final createdAt = DateTime.tryParse(friendship?['created_at']?.toString() ?? '');
      final isAccepted = friendship?['status']?.toString() == 'accepted';
      final isNewConnection = !isAccepted ||
          createdAt == null ||
          DateTime.now().difference(createdAt).inHours < 24;
      if (isNewConnection) {
        allowed = _newConnectionMaxMessagesPerMinute;
      }
    }

    if (_sendTimestamps.length >= allowed) {
      throw Exception('Rate limit reached. Please wait before sending more messages.');
    }
    _sendTimestamps.add(now);
  }

  void _ensureRetryLoop() {
    _retryTimer ??= Timer.periodic(const Duration(seconds: 12), (_) async {
      if (_pendingDmSends.isEmpty) {
        _retryTimer?.cancel();
        _retryTimer = null;
        return;
      }
      final pending = List<_PendingDmSend>.from(_pendingDmSends);
      _pendingDmSends.clear();
      for (final item in pending) {
        try {
          await _supabase.from('messages').insert({
            'sender_id': currentUserId,
            'receiver_id': item.receiverId,
            'content': item.content,
          });
        } catch (_) {
          _pendingDmSends.add(item);
        }
      }
    });
  }

  Future<void> recordLatencyEvent({
    required String metric,
    required int valueMs,
    String? peerUserId,
    String? messageId,
  }) async {
    final uid = currentUserId;
    if (uid == null) return;
    try {
      await _supabase.from('chat_latency_events').insert({
        'user_id': uid,
        'peer_user_id': peerUserId,
        'message_id': messageId,
        'metric': metric,
        'value_ms': valueMs,
      });
    } catch (_) {}
  }

  Future<void> setTypingState({
    required String otherUserId,
    required bool isTyping,
  }) async {
    final uid = currentUserId;
    if (uid == null) return;

    await _supabase.from('dm_typing').upsert({
      'user_id': uid,
      'other_user_id': otherUserId,
      'is_typing': isTyping,
      'updated_at': DateTime.now().toIso8601String(),
    }, onConflict: 'user_id,other_user_id');
  }

  Stream<bool> typingStream(String otherUserId) {
    final uid = currentUserId;
    if (uid == null) return const Stream.empty();

    return _supabase
        .from('dm_typing')
        .stream(primaryKey: ['user_id', 'other_user_id'])
        .eq('user_id', otherUserId)
        .eq('other_user_id', uid)
        .map((rows) {
      if (rows.isEmpty) return false;
      final row = rows.first;
      final isTyping = row['is_typing'] == true;
      final updatedAt = DateTime.tryParse(row['updated_at']?.toString() ?? '');
      if (!isTyping || updatedAt == null) return false;
      return DateTime.now().difference(updatedAt).inSeconds <= 8;
    });
  }

  Future<Map<String, dynamic>> getDmGateState(String otherUserId) async {
    final uid = currentUserId;
    if (uid == null) return {'canChat': false, 'reason': 'not_logged_in'};

    try {
      final rpc = await _supabase.rpc('get_dm_gate_state', params: {
        'target_user_id': otherUserId,
      });
      if (rpc is Map<String, dynamic>) {
        return {
          'canChat': rpc['can_chat'] == true,
          'reason': rpc['reason']?.toString(),
          'sentRequestStatus': rpc['sent_request_status']?.toString(),
          'incomingRequestStatus': rpc['incoming_request_status']?.toString(),
        };
      }
    } catch (_) {}

    return {'canChat': true, 'reason': null};
  }

  Future<void> sendMessageRequest(String otherUserId) async {
    final uid = currentUserId;
    if (uid == null) return;
    await _supabase.from('message_requests').upsert({
      'requester_id': uid,
      'recipient_id': otherUserId,
      'status': 'pending',
      'updated_at': DateTime.now().toIso8601String(),
    }, onConflict: 'requester_id,recipient_id');
  }

  Future<void> respondToMessageRequest({
    required String requesterId,
    required bool accept,
  }) async {
    final uid = currentUserId;
    if (uid == null) return;
    await _supabase.from('message_requests').update({
      'status': accept ? 'accepted' : 'declined',
      'updated_at': DateTime.now().toIso8601String(),
    }).eq('requester_id', requesterId).eq('recipient_id', uid);
  }

  Future<void> submitChatReport({
    required String otherUserId,
    required String messageId,
    required String messagePreview,
    String? reason,
  }) async {
    final uid = currentUserId;
    if (uid == null) return;

    await _supabase.from('chat_reports').insert({
      'reporter_id': uid,
      'reported_user_id': otherUserId,
      'message_id': messageId,
      'message_preview': messagePreview,
      'reason': reason,
    });
  }

  Future<void> toggleMessageReaction({
    required String messageId,
    required String emoji,
  }) async {
    final uid = currentUserId;
    if (uid == null) return;
    final row = await _supabase
        .from('messages')
        .select('reactions')
        .eq('id', messageId)
        .maybeSingle();
    final reactions = (row?['reactions'] as Map<String, dynamic>?) ?? {};
    final users = ((reactions[emoji] as List?) ?? const [])
        .map((e) => e.toString())
        .toSet();
    if (!users.add(uid)) {
      users.remove(uid);
    }
    final next = <String, dynamic>{...reactions};
    if (users.isEmpty) {
      next.remove(emoji);
    } else {
      next[emoji] = users.toList();
    }
    await _supabase.from('messages').update({'reactions': next}).eq('id', messageId);
  }

  Stream<List<Map<String, dynamic>>> getMessagesStream(String otherUserId) {
    final uid = currentUserId;
    if (uid == null) return const Stream.empty();

    return _supabase
        .from('messages')
        .stream(primaryKey: ['id'])
        .order('created_at', ascending: true)
        .map((rows) {
      return rows.where((row) {
        final s = row['sender_id'];
        final r = row['receiver_id'];
        return (s == uid && r == otherUserId) ||
            (s == otherUserId && r == uid);
      }).toList();
    });
  }

  Future<void> markConversationAsRead(String otherUserId) async {
    final uid = currentUserId;
    if (uid == null) return;

    final started = DateTime.now();
    await _supabase
        .from('messages')
        .update({'is_read': true, 'read_at': DateTime.now().toIso8601String()})
        .eq('sender_id', otherUserId)
        .eq('receiver_id', uid)
        .eq('is_read', false);
    await recordLatencyEvent(
      metric: 'mark_read_ms',
      valueMs: DateTime.now().difference(started).inMilliseconds,
      peerUserId: otherUserId,
    );
  }

  Future<void> markConversationAsUnread(String otherUserId) async {
    final uid = currentUserId;
    if (uid == null) return;

    await _supabase
        .from('messages')
        .update({'is_read': false, 'read_at': null})
        .eq('sender_id', otherUserId)
        .eq('receiver_id', uid)
        .eq('is_read', true);
  }

  Future<void> markAllConversationsAsRead(List<String> otherIds) async {
    for (final id in otherIds) {
      await markConversationAsRead(id);
    }
  }

  Future<void> archiveConversations(List<String> otherIds) async {
    for (final id in otherIds) {
      await setConversationPreference(id, archived: true);
    }
  }

  Future<void> deleteConversation(String otherUserId) async {
    final uid = currentUserId;
    if (uid == null) return;

    await _supabase.from('messages').delete().or(
        'and(sender_id.eq.$uid,receiver_id.eq.$otherUserId),and(sender_id.eq.$otherUserId,receiver_id.eq.$uid)');
  }

  Future<void> deleteMessageById(String messageId) async {
    final uid = currentUserId;
    if (uid == null) return;

    await _supabase
        .from('messages')
        .delete()
        .eq('id', messageId)
        .eq('sender_id', uid);
  }

  Future<void> editMessageById(String messageId, String content) async {
    final uid = currentUserId;
    if (uid == null) return;

    await _supabase
        .from('messages')
        .update({'content': content})
        .eq('id', messageId)
        .eq('sender_id', uid);
  }

  Future<void> setConversationPreference(
    String otherUserId, {
    bool? pinned,
    bool? muted,
    bool? archived,
  }) async {
    final uid = currentUserId;
    if (uid == null) return;

    final update = <String, dynamic>{
      if (pinned != null) 'is_pinned': pinned,
      if (muted != null) 'is_muted': muted,
      if (archived != null) 'is_archived': archived,
      'updated_at': DateTime.now().toIso8601String(),
    };
    if (update.isEmpty) return;

    await _supabase.from('conversations').upsert({
      'user_id': uid,
      'other_user_id': otherUserId,
      ...update,
    });
  }

  Future<List<Map<String, dynamic>>> getInboxThreads() async {
    final uid = currentUserId;
    if (uid == null) return [];

    final conversationRows = await _supabase
        .from('conversations')
        .select(
            'other_user_id,is_pinned,is_muted,is_archived,unread_count,last_message,last_message_at')
        .eq('user_id', uid)
        .order('last_message_at', ascending: false)
        .limit(200);

    if (conversationRows.isEmpty) return [];

    final otherIds = conversationRows
        .map((row) => row['other_user_id']?.toString())
        .whereType<String>()
        .toSet()
        .toList();

    if (otherIds.isEmpty) return [];

    final friendshipRows = await _supabase
        .from('friendships')
        .select('requester_id,addressee_id,status')
        .or('requester_id.eq.$uid,addressee_id.eq.$uid')
        .eq('status', 'accepted');
    final friendIds = <String>{};
    for (final row in friendshipRows) {
      final requester = row['requester_id']?.toString();
      final addressee = row['addressee_id']?.toString();
      if (requester == uid && addressee != null) friendIds.add(addressee);
      if (addressee == uid && requester != null) friendIds.add(requester);
    }

    final requestRows = await _supabase
        .from('message_requests')
        .select('requester_id,recipient_id,status,updated_at')
        .or('requester_id.eq.$uid,recipient_id.eq.$uid')
        .inFilter('status', ['pending', 'accepted']);
    final incomingPendingIds = <String>{};
    final outgoingPendingIds = <String>{};
    for (final row in requestRows) {
      final requester = row['requester_id']?.toString();
      final recipient = row['recipient_id']?.toString();
      final status = row['status']?.toString();
      if (status != 'pending') continue;
      if (requester == uid && recipient != null) {
        outgoingPendingIds.add(recipient);
      }
      if (recipient == uid && requester != null) {
        incomingPendingIds.add(requester);
      }
    }

    final profiles = await _supabase
        .from('profiles')
        .select('id, username, avatar_url, settings')
        .inFilter('id', otherIds);
    final profileMap = {for (var p in profiles) p['id'].toString(): p};
    final onlineStatuses = await presenceRepository.fetchOnlineStatuses(otherIds);

    final result = <Map<String, dynamic>>[];
    for (final row in conversationRows) {
      final otherId = row['other_user_id']?.toString();
      if (otherId == null) continue;
      final profile = profileMap[otherId];
      if (profile == null) continue;

      final settings = (profile['settings'] as Map<String, dynamic>?) ?? {};
      final showOnlineStatus = settings['show_online_status'] ?? true;
      final isOnline = onlineStatuses[otherId] ?? false;

      result.add({
        'otherId': otherId,
        'otherName': profile['username'] ?? 'User',
        'avatar_url': profile['avatar_url'],
        'lastMsg': row['last_message']?.toString() ?? '',
        'time': DateTime.tryParse(row['last_message_at']?.toString() ?? '') ??
            DateTime.now(),
        'unreadCount': row['unread_count'] is int
            ? row['unread_count'] as int
            : int.tryParse(row['unread_count']?.toString() ?? '0') ?? 0,
        'isPinned': row['is_pinned'] == true,
        'isMuted': row['is_muted'] == true,
        'isArchived': row['is_archived'] == true,
        'isOnline': showOnlineStatus && isOnline,
        'isFriend': friendIds.contains(otherId),
        'hasIncomingRequest': incomingPendingIds.contains(otherId),
        'hasOutgoingRequest': outgoingPendingIds.contains(otherId),
        'summary': _threadSummary(
          unreadCount: row['unread_count'] is int
              ? row['unread_count'] as int
              : int.tryParse(row['unread_count']?.toString() ?? '0') ?? 0,
          isFriend: friendIds.contains(otherId),
          incomingRequest: incomingPendingIds.contains(otherId),
          outgoingRequest: outgoingPendingIds.contains(otherId),
          lastMessage: row['last_message']?.toString() ?? '',
        ),
      });
    }

    return result;
  }

  String _threadSummary({
    required int unreadCount,
    required bool isFriend,
    required bool incomingRequest,
    required bool outgoingRequest,
    required String lastMessage,
  }) {
    if (incomingRequest) return 'Incoming request · tap to respond';
    if (outgoingRequest) return 'Request pending approval';
    if (unreadCount > 0) return '$unreadCount unread · priority';
    if (isFriend) return 'Friend chat';
    if (lastMessage.isEmpty) return 'New connection';
    return 'Recent activity';
  }
}

class _PendingDmSend {
  final String receiverId;
  final String content;
  const _PendingDmSend({required this.receiverId, required this.content});
}

final chatRepository = ChatRepository();
