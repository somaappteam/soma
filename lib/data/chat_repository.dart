import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:soma/core/di/locator.dart';
import 'package:soma/data/presence_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ChatRepository {
  static const int _maxContentChars = 4000;
  static const int _maxMessagesPerMinute = 20;
  static const int _newConnectionMaxMessagesPerMinute = 8;

  final SupabaseClient _supabase = Supabase.instance.client;
  final List<DateTime> _sendTimestamps = [];
  final List<_PendingDmSend> _pendingDmSends = [];
  Timer? _retryTimer;

  String? get currentUserId => _supabase.auth.currentUser?.id;

  Stream<void> inboxRefreshStream() {
    final uid = currentUserId;
    if (uid == null) return const Stream.empty();

    return _supabase
        .from('conversations')
        .stream(primaryKey: ['user_id', 'other_user_id'])
        .eq('user_id', uid)
        .order('last_message_at', ascending: false)
        .limit(50)
        .map((final _) {
          debugPrint('ChatRepository: inbox refresh stream event');
        });
  }

  Future<void> sendMessage(final String receiverId, final String content) async {
    final uid = currentUserId;
    if (uid == null) throw Exception('Not logged in');

    final settingsRow = await _supabase
        .from('profiles')
        .select('settings')
        .eq('id', uid)
        .maybeSingle();
    final settings = settingsRow?['settings'];
    final blockedSource = settings is Map<String, dynamic>
        ? settings['blocked_user_ids']
        : null;
    final blockedIds = (blockedSource as List?)?.map((final e) => e.toString()).toList() ?? [];
    if (blockedIds.contains(receiverId)) {
      throw Exception('You have blocked this user.');
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
      // Conversation synchronization is now handled by a database trigger 
      // (update_conversations_on_message) to avoid RLS issues.
      
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


  String _parseMessagePreview(final String? content) {
    if (content == null || content.isEmpty) return '';
    if (!content.startsWith('{')) return content;
    try {
      final data = jsonDecode(content);
      if (data is Map<String, dynamic>) {
        final type = data['type']?.toString().toLowerCase();
        final text = data['text']?.toString() ?? '';
        final label = data['label']?.toString() ?? '';
        switch (type) {
          case 'text':
            return text;
          case 'image':
            return 'Photo';
          case 'document':
          case 'file':
            return 'Document';
          case 'voice':
            return 'Voice message';
          case 'location':
            return label.isNotEmpty ? label : 'Location card';
          case 'contact':
            return label.isNotEmpty ? label : 'Contact card';
          case 'invite':
            return label.isNotEmpty ? label : (text.isNotEmpty ? text : 'Practice invite');
          case 'poll':
            return label.isNotEmpty ? label : 'Poll';
          case 'checklist':
            return text.isNotEmpty ? text : 'Checklist';
          default:
            if (label.isNotEmpty) return label;
            if (text.isNotEmpty) return text;
        }
      }
    } catch (_) {
      // Fallback to raw content if not JSON
    }
    return content;
  }

  Future<void> _enforceDmRateLimit(final String receiverId) async {
    final now = DateTime.now();
    _sendTimestamps.removeWhere((final t) => now.difference(t).inSeconds >= 60);

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
    _retryTimer ??= Timer.periodic(const Duration(seconds: 12), (final _) async {
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
    required final String metric,
    required final int valueMs,
    final String? peerUserId,
    final String? messageId,
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
    required final String otherUserId,
    required final bool isTyping,
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

  Stream<bool> typingStream(final String otherUserId) {
    final uid = currentUserId;
    if (uid == null) return const Stream.empty();

    return _supabase
        .from('dm_typing')
        .stream(primaryKey: ['user_id', 'other_user_id'])
        .eq('user_id', otherUserId)
        .map((final rows) {
      final matches = rows.where((final r) => r['other_user_id'] == uid).toList();
      if (matches.isEmpty) return false;
      final row = matches.first;
      final isTyping = row['is_typing'] == true;
      final updatedAt = DateTime.tryParse(row['updated_at']?.toString() ?? '');
      if (!isTyping || updatedAt == null) return false;
      return DateTime.now().difference(updatedAt).inSeconds <= 8;
    });
  }

  Future<Map<String, dynamic>> getDmGateState(final String otherUserId) async {
    final uid = currentUserId;
    if (uid == null) return {'can_chat': false, 'reason': 'not_logged_in'};

    try {
      final rpc = await _supabase.rpc('get_dm_gate_state', params: {
        'target_user_id': otherUserId,
      });
      if (rpc is Map<String, dynamic>) {
        return {
          'can_chat': rpc['can_chat'] == true,
          'reason': rpc['reason']?.toString(),
          'sent_request_status': rpc['sent_request_status']?.toString(),
          'incoming_request_status': rpc['incoming_request_status']?.toString(),
        };
      }
    } catch (_) {}

    return {'can_chat': true, 'reason': null};
  }

  Future<void> sendMessageRequest(final String otherUserId) async {
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
    required final String requesterId,
    required final bool accept,
  }) async {
    final uid = currentUserId;
    if (uid == null) return;
    await _supabase.from('message_requests').update({
      'status': accept ? 'accepted' : 'declined',
      'updated_at': DateTime.now().toIso8601String(),
    }).eq('requester_id', requesterId).eq('recipient_id', uid);
  }

  Future<void> submitChatReport({
    required final String otherUserId,
    required final String messageId,
    required final String messagePreview,
    final String? reason,
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
    required final String messageId,
    required final String emoji,
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
        .map((final e) => e.toString())
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

  Stream<List<Map<String, dynamic>>> getMessagesStream(final String otherUserId) {
    final uid = currentUserId;
    if (uid == null) return const Stream.empty();

    return _supabase
        .from('messages')
        .stream(primaryKey: ['id'])
        .order('created_at', ascending: false) // Listen to NEWEST messages
        .limit(100)
        // Note: Real-time filtering by complex OR is not supported in the current stream builder.
        // We listen to the tail and rely on client-side filtering or conversation_id if available.
        .map((final rows) {
          final filtered = rows.where((final row) {
            final sId = row['sender_id'];
            final rId = row['receiver_id'];
            return (sId == uid && rId == otherUserId) || (sId == otherUserId && rId == uid);
          }).toList();
          // We fetched DESC (newest first) to get the latest updates/edits.
          // The UI expects ASC (oldest first) so we reverse the list.
          return filtered.reversed.toList();
        });
  }

  Future<void> markConversationAsRead(final String otherUserId) async {
    final uid = currentUserId;
    if (uid == null) return;

    final started = DateTime.now();
    await _supabase
        .from('messages')
        .update({'is_read': true, 'read_at': DateTime.now().toIso8601String()})
        .eq('sender_id', otherUserId)
        .eq('receiver_id', uid)
        .eq('is_read', false);

    await _supabase
        .from('conversations')
        .update({'unread_count': 0})
        .eq('user_id', uid)
        .eq('other_user_id', otherUserId);

    await recordLatencyEvent(
      metric: 'mark_read_ms',
      valueMs: DateTime.now().difference(started).inMilliseconds,
      peerUserId: otherUserId,
    );
  }

  Future<void> markConversationAsUnread(final String otherUserId) async {
    final uid = currentUserId;
    if (uid == null) return;

    await _supabase
        .from('messages')
        .update({'is_read': false, 'read_at': null})
        .eq('sender_id', otherUserId)
        .eq('receiver_id', uid)
        .eq('is_read', true);
  }

  Future<void> markAllConversationsAsRead(final List<String> otherIds) async {
    for (final id in otherIds) {
      await markConversationAsRead(id);
    }
  }

  Future<void> archiveConversations(final List<String> otherIds) async {
    for (final id in otherIds) {
      await setConversationPreference(id, archived: true);
    }
  }

  Future<void> deleteConversation(final String otherUserId) async {
    final uid = currentUserId;
    if (uid == null) return;

    await _supabase.from('messages').delete().or(
        'and(sender_id.eq.$uid,receiver_id.eq.$otherUserId),and(sender_id.eq.$otherUserId,receiver_id.eq.$uid)');
  }

  Future<void> deleteMessageById(final String messageId) async {
    final uid = currentUserId;
    if (uid == null) return;

    debugPrint('ChatRepository: deleting message $messageId');
    await _supabase
        .from('messages')
        .delete()
        .eq('id', messageId)
        .eq('sender_id', uid);
    debugPrint('ChatRepository: deleted message $messageId');
  }

  Future<void> editMessageById(final String messageId, final String content) async {
    final uid = currentUserId;
    if (uid == null) return;

    debugPrint('ChatRepository: editing message $messageId');
    await _supabase
        .from('messages')
        .update({'content': content})
        .eq('id', messageId)
        .eq('sender_id', uid);
    debugPrint('ChatRepository: edited message $messageId');
  }

  Future<void> setConversationPreference(
    final String otherUserId, {
    final bool? pinned,
    final bool? muted,
    final bool? archived,
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

  Stream<Map<String, dynamic>?> streamConversation(final String otherUserId) {
    final uid = currentUserId;
    if (uid == null) return Stream.value(null);

    return _supabase
        .from('conversations')
        .stream(primaryKey: ['user_id', 'other_user_id'])
        .eq('user_id', uid)
        .map((final event) {
      final matches = event.where((final e) => e['other_user_id'] == otherUserId);
      return matches.isNotEmpty ? matches.first : null;
    });
  }

  Stream<List<Map<String, dynamic>>> getInboxThreadsStream() async* {
    yield await getInboxThreads();
    yield* inboxRefreshStream().asyncMap((final _) => getInboxThreads());
  }

  Future<List<Map<String, dynamic>>> getInboxThreads() async {
    final uid = currentUserId;
    if (uid == null) return [];

    final List<Map<String, dynamic>> normalizedRows = [];

    // 1. Fetch Conversations
    try {
      final conversationRows = await _supabase
          .from('conversations')
          .select(
              'other_user_id,is_pinned,is_muted,is_archived,unread_count,last_message,last_message_at')
          .eq('user_id', uid)
          .order('last_message_at', ascending: false)
          .limit(200);

      if (conversationRows.isNotEmpty) {
        normalizedRows.addAll(
          conversationRows.map((final row) => Map<String, dynamic>.from(row)),
        );
      }
    } catch (e) {
      debugPrint('ChatRepository: Error fetching conversations: $e');
    }

    // 2. Fallback to Messages if no conversations found
    if (normalizedRows.isEmpty) {
      try {
        final messageRows = await _supabase
            .from('messages')
            .select('sender_id,receiver_id,content,created_at,is_read')
            .or('sender_id.eq.$uid,receiver_id.eq.$uid')
            .order('created_at', ascending: false)
            .limit(500);

        final derived = <String, Map<String, dynamic>>{};
        for (final row in messageRows) {
          final sender = row['sender_id']?.toString();
          final receiver = row['receiver_id']?.toString();
          if (sender == null || receiver == null) continue;
          final otherId = sender == uid ? receiver : sender;
          if (otherId == uid) continue;

          if (!derived.containsKey(otherId)) {
            derived[otherId] = {
              'other_user_id': otherId,
              'is_pinned': false,
              'is_muted': false,
              'is_archived': false,
              'unread_count': 0,
              'last_message': row['content']?.toString() ?? '',
              'last_message_at': row['created_at'],
            };
          }
          if (receiver == uid && row['is_read'] != true) {
            final count = derived[otherId]!['unread_count'] as int;
            derived[otherId]!['unread_count'] = count + 1;
          }
        }
        normalizedRows.addAll(derived.values);
        normalizedRows.sort((final a, final b) {
          final aTime = DateTime.tryParse(a['last_message_at']?.toString() ?? '') ??
              DateTime.fromMillisecondsSinceEpoch(0);
          final bTime = DateTime.tryParse(b['last_message_at']?.toString() ?? '') ??
              DateTime.fromMillisecondsSinceEpoch(0);
          return bTime.compareTo(aTime);
        });
      } catch (e) {
        debugPrint('ChatRepository: Error deriving threads from messages: $e');
      }
    }

    if (normalizedRows.isEmpty) return [];

    final otherIds = normalizedRows
        .map((final row) => row['other_user_id']?.toString())
        .whereType<String>()
        .toSet()
        .toList();

    if (otherIds.isEmpty) return [];

    // Supplemental data holders
    final friendIds = <String>{};
    final incomingPendingIds = <String>{};
    final outgoingPendingIds = <String>{};
    Map<String, dynamic> profileMap = {};
    Map<String, bool> onlineStatuses = {};

    // 3. Parallel fetch of supplemental data
    await Future.wait([
      // Fetch Friends
      () async {
        try {
          final friendshipRows = await _supabase
              .from('friendships')
              .select('requester_id,addressee_id,status')
              .or('requester_id.eq.$uid,addressee_id.eq.$uid')
              .eq('status', 'accepted');
          for (final row in friendshipRows) {
            final requester = row['requester_id']?.toString();
            final addressee = row['addressee_id']?.toString();
            if (requester == uid && addressee != null) friendIds.add(addressee);
            if (addressee == uid && requester != null) friendIds.add(requester);
          }
        } catch (e) {
          debugPrint('ChatRepository: Error fetching friendships: $e');
        }
      }(),
      // Fetch Message Requests
      () async {
        try {
          final requestRows = await _supabase
              .from('message_requests')
              .select('requester_id,recipient_id,status')
              .or('requester_id.eq.$uid,recipient_id.eq.$uid')
              .inFilter('status', ['pending', 'accepted']);
          for (final row in requestRows) {
            final requester = row['requester_id']?.toString();
            final recipient = row['recipient_id']?.toString();
            final status = row['status']?.toString();
            if (status == 'pending') {
              if (requester == uid && recipient != null) outgoingPendingIds.add(recipient);
              if (recipient == uid && requester != null) incomingPendingIds.add(requester);
            }
          }
        } catch (e) {
          debugPrint('ChatRepository: Error fetching message requests: $e');
        }
      }(),
      // Fetch Profiles
      () async {
        try {
          final profiles = await _supabase
              .from('profiles')
              .select('id, username, display_name, avatar_url, settings')
              .inFilter('id', otherIds);
          profileMap = {for (var p in profiles) p['id'].toString(): p};
        } catch (e) {
          debugPrint('ChatRepository: Error fetching profiles: $e');
        }
      }(),
      // Fetch Online Status
      () async {
        try {
          onlineStatuses = await presenceRepository.fetchOnlineStatuses(otherIds);
        } catch (e) {
          debugPrint('ChatRepository: Error fetching online statuses: $e');
        }
      }(),
    ]);

    // 4. Combine Results
    final result = <Map<String, dynamic>>[];
    for (final row in normalizedRows) {
      final otherId = row['other_user_id']?.toString();
      if (otherId == null) continue;

      final profile = profileMap[otherId];
      final settings = (profile?['settings'] as Map<String, dynamic>?) ?? {};
      final showOnlineStatus = settings['show_online_status'] ?? true;
      final isOnline = onlineStatuses[otherId] ?? false;

      // Fallback display name info
      final displayName = profile?['display_name']?.toString().isNotEmpty == true
          ? profile!['display_name'].toString()
          : (profile?['username']?.toString().isNotEmpty == true
              ? profile!['username'].toString()
              : 'User ${otherId.substring(0, 4)}');

      final reliabilityScore = ((settings['reply_consistency_score'] as num?)?.toInt())?.clamp(0, 100);
      final correctionHelpfulnessScore = ((settings['correction_helpfulness_score'] as num?)?.toInt())?.clamp(0, 100);
      final voiceFeedbackScore = ((settings['voice_feedback_quality_score'] as num?)?.toInt())?.clamp(0, 100);
      final verifiedSeriousLearner = settings['verified_serious_learner'] == true;

      final lastMessageRaw = row['last_message']?.toString() ?? '';
      final lastMessageText = _parseMessagePreview(lastMessageRaw);
      final normalizedLastMessage = lastMessageText.toLowerCase();
      final hasChallengePending =
          normalizedLastMessage.contains('challenge') || normalizedLastMessage.contains('[challenge]');
      final hasCorrectionUnread =
          normalizedLastMessage.contains('correction') || normalizedLastMessage.contains('correct this');
      final hasVoiceFeedback =
          normalizedLastMessage.contains('voice') || normalizedLastMessage.contains('transcript');
      final practiceStreakAtRisk = DateTime.now().difference(
            DateTime.tryParse(row['last_message_at']?.toString() ?? '') ?? DateTime.now(),
          ).inHours >= 24;

      final unreadCount = row['unread_count'] is int
          ? row['unread_count'] as int
          : int.tryParse(row['unread_count']?.toString() ?? '0') ?? 0;

      result.add({
        'otherId': otherId,
        'otherName': displayName,
        'avatar_url': profile?['avatar_url'],
        'lastMsg': lastMessageText,
        'time': DateTime.tryParse(row['last_message_at']?.toString() ?? '') ?? DateTime.now(),
        'unreadCount': unreadCount,
        'isPinned': row['is_pinned'] == true,
        'isMuted': row['is_muted'] == true,
        'isArchived': row['is_archived'] == true,
        'isOnline': showOnlineStatus && isOnline,
        'isFriend': friendIds.contains(otherId),
        'hasIncomingRequest': incomingPendingIds.contains(otherId),
        'hasOutgoingRequest': outgoingPendingIds.contains(otherId),
        'hasChallengePending': hasChallengePending,
        'hasCorrectionUnread': hasCorrectionUnread,
        'hasVoiceFeedback': hasVoiceFeedback,
        'practiceStreakAtRisk': practiceStreakAtRisk,
        'partnerQuality': settings['partner_quality_score'] is num
            ? (settings['partner_quality_score'] as num).toInt().clamp(0, 100)
            : null,
        'reliabilityScore': reliabilityScore,
        'correctionHelpfulnessScore': correctionHelpfulnessScore,
        'voiceFeedbackScore': voiceFeedbackScore,
        'verifiedSeriousLearner': verifiedSeriousLearner,
        'summary': _threadSummary(
          unreadCount: unreadCount,
          isFriend: friendIds.contains(otherId),
          incomingRequest: incomingPendingIds.contains(otherId),
          outgoingRequest: outgoingPendingIds.contains(otherId),
          lastMessage: lastMessageText,
        ),
      });
    }

    return result;
  }

  String _threadSummary({
    required final int unreadCount,
    required final bool isFriend,
    required final bool incomingRequest,
    required final bool outgoingRequest,
    required final String lastMessage,
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

ChatRepository get chatRepository => locator<ChatRepository>();
