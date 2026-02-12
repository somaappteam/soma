import 'package:supabase_flutter/supabase_flutter.dart';
import 'presence_repository.dart';

class ChatRepository {
  static const int _maxContentChars = 4000;
  static const int _maxMessagesPerMinute = 20;

  final _supabase = Supabase.instance.client;
  final List<DateTime> _sendTimestamps = [];

  String? get currentUserId => _supabase.auth.currentUser?.id;

  /// Send a message
  Future<void> sendMessage(String receiverId, String content) async {
    final uid = currentUserId;
    if (uid == null) throw Exception("Not logged in");
    if (content.length > _maxContentChars) {
      throw Exception('Message payload exceeds 4000 characters');
    }

    final now = DateTime.now();
    _sendTimestamps.removeWhere((t) => now.difference(t).inSeconds >= 60);
    if (_sendTimestamps.length >= _maxMessagesPerMinute) {
      throw Exception('Rate limit reached. Please wait before sending more messages.');
    }
    _sendTimestamps.add(now);

    await _supabase.from('messages').insert({
      'sender_id': uid,
      'receiver_id': receiverId,
      'content': content,
      // 'is_read': false, // default
    });
  }

  /// Steam messages for a conversation
  Stream<List<Map<String, dynamic>>> getMessagesStream(String otherUserId) {
    final uid = currentUserId;
    if (uid == null) return const Stream.empty();

    return _supabase
        .from('messages')
        .stream(primaryKey: ['id'])
        .order('created_at', ascending: true)
        .map((rows) {
          // Filter for conversation between me and other
          return rows.where((row) {
            final s = row['sender_id'];
            final r = row['receiver_id'];
            return (s == uid && r == otherUserId) || (s == otherUserId && r == uid);
          }).toList();
        });
  }


  Future<void> markConversationAsRead(String otherUserId) async {
    final uid = currentUserId;
    if (uid == null) return;

    await _supabase
        .from('messages')
        .update({'is_read': true})
        .eq('sender_id', otherUserId)
        .eq('receiver_id', uid)
        .eq('is_read', false);
  }

  Future<void> markConversationAsUnread(String otherUserId) async {
    final uid = currentUserId;
    if (uid == null) return;

    await _supabase
        .from('messages')
        .update({'is_read': false})
        .eq('sender_id', otherUserId)
        .eq('receiver_id', uid)
        .eq('is_read', true);
  }

  Future<void> deleteConversation(String otherUserId) async {
    final uid = currentUserId;
    if (uid == null) return;

    await _supabase
        .from('messages')
        .delete()
        .or('and(sender_id.eq.$uid,receiver_id.eq.$otherUserId),and(sender_id.eq.$otherUserId,receiver_id.eq.$uid)');
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

  /// Get Inbox (list of conversations)
  /// Note: Supabase doesn't support grouping in Stream easily, and we don't have a 'conversations' table.
  /// For MVP, we will fetch recent messages and process distinct users locally, OR use Friends list.
  /// Better approach for Scalability: `conversations` table.
  /// For this MVP: Fetch 'my friends' and for each, show last message.
  /// Queries:
  /// 1. Get Friends
  /// 2. For each friend, fetch last message? (N+1 problem)
  /// 
  /// Alternative: Fetch all my messages ordered by date (limit 500) and group locally.
  Future<List<Map<String, dynamic>>> getInboxThreads() async {
    final uid = currentUserId;
    if (uid == null) return [];

    final prefRows = await _supabase
        .from('conversations')
        .select('other_user_id,is_pinned,is_muted,is_archived,unread_count,last_message,last_message_at')
        .eq('user_id', uid);
    final prefsByOther = <String, Map<String, dynamic>>{
      for (final r in prefRows)
        r['other_user_id'].toString(): Map<String, dynamic>.from(r),
    };

    // Fetch last 100 messages involving me
    final response = await _supabase
        .from('messages')
        .select()
        .or('sender_id.eq.$uid,receiver_id.eq.$uid')
        .order('created_at', ascending: false)
        .limit(200);

    // Group by 'other' user
    final Map<String, Map<String, dynamic>> threads = {};
    final Map<String, int> unreadByOther = {};

    for (final msg in response) {
      final isMeSender = msg['sender_id'] == uid;
      final otherId = (isMeSender ? msg['receiver_id'] : msg['sender_id']).toString();
      final receiverId = msg['receiver_id']?.toString();
      final senderId = msg['sender_id']?.toString();
      final isRead = msg['is_read'] == true || msg['is_read'] == 1;

      if (!threads.containsKey(otherId)) {
        final pref = prefsByOther[otherId] ?? const <String, dynamic>{};
        final parsed = DateTime.tryParse(msg['created_at']?.toString() ?? '');
        threads[otherId] = {
          'otherId': otherId,
          'lastMsg': pref['last_message']?.toString() ?? msg['content']?.toString() ?? '',
          'time': DateTime.tryParse(pref['last_message_at']?.toString() ?? '') ?? parsed ?? DateTime.now(),
          'unreadCount': 0,
          'isPinned': pref['is_pinned'] == true,
          'isMuted': pref['is_muted'] == true,
          'isArchived': pref['is_archived'] == true,
        };
      }

      final isUnreadForMe = receiverId == uid && senderId == otherId && !isRead;
      if (isUnreadForMe) {
        unreadByOther[otherId] = (unreadByOther[otherId] ?? 0) + 1;
      }
    }

    for (final entry in threads.entries) {
      final pref = prefsByOther[entry.key] ?? const <String, dynamic>{};
      entry.value['unreadCount'] =
          (pref['unread_count'] is int ? pref['unread_count'] as int : null) ?? (unreadByOther[entry.key] ?? 0);
    }

    // We need profiles for names
    final otherIds = threads.keys.toList();
    if (otherIds.isEmpty) return [];

    final profiles = await _supabase.from('profiles').select('id, username, avatar_url, settings').inFilter('id', otherIds);
    final profileMap = {for (var p in profiles) p['id']: p};
    final onlineStatuses = await presenceRepository.fetchOnlineStatuses(otherIds);

    final List<Map<String, dynamic>> result = [];
    for (final t in threads.values) {
       final pid = t['otherId'];
       final p = profileMap[pid];
       if (p != null) {
         final settings = (p['settings'] as Map<String, dynamic>?) ?? {};
         final showOnlineStatus = settings['show_online_status'] ?? true;
         final isOnline = onlineStatuses[pid] ?? false;
         t['otherName'] = p['username'] ?? 'User';
         t['avatar_url'] = p['avatar_url'];
         t['isOnline'] = showOnlineStatus && isOnline;
         result.add(t);
       }
    }
    
    return result;
  }
}

final chatRepository = ChatRepository();
