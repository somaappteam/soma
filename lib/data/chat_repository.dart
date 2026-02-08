import 'package:supabase_flutter/supabase_flutter.dart';

class ChatRepository {
  final _supabase = Supabase.instance.client;

  String? get currentUserId => _supabase.auth.currentUser?.id;

  /// Send a message
  Future<void> sendMessage(String receiverId, String content) async {
    final uid = currentUserId;
    if (uid == null) throw Exception("Not logged in");

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

    // Fetch last 100 messages involving me
    final response = await _supabase
        .from('messages')
        .select()
        .or('sender_id.eq.$uid,receiver_id.eq.$uid')
        .order('created_at', ascending: false)
        .limit(200);

    // Group by 'other' user
    final Map<String, Map<String, dynamic>> threads = {};
    
    for (final msg in response) {
      final isMeSender = msg['sender_id'] == uid;
      final otherId = isMeSender ? msg['receiver_id'] : msg['sender_id'];
      
      if (!threads.containsKey(otherId)) {
        threads[otherId] = {
            'otherId': otherId,
            'lastMsg': msg['content'],
            'time': DateTime.parse(msg['created_at']),
            'unreadCount': 0, // TODO
        };
      }
    }

    // We need profiles for names
    final otherIds = threads.keys.toList();
    if (otherIds.isEmpty) return [];

    final profiles = await _supabase.from('profiles').select().inFilter('id', otherIds);
    final profileMap = {for (var p in profiles) p['id']: p};

    final List<Map<String, dynamic>> result = [];
    for (final t in threads.values) {
       final pid = t['otherId'];
       final p = profileMap[pid];
       if (p != null) {
         t['otherName'] = p['username'] ?? 'User';
         t['avatar_url'] = p['avatar_url'];
         result.add(t);
       }
    }
    
    return result;
  }
}

final chatRepository = ChatRepository();
