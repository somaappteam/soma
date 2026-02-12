import 'package:supabase_flutter/supabase_flutter.dart';

class CircleChatRepository {
  final _supabase = Supabase.instance.client;

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

    await _supabase.from('chat_messages').insert({
      'circle_id': circleId,
      'sender_id': uid,
      'content': content,
      'read_by': [uid], // Sender has read it
    });
  }

  Future<void> markRead(String messageId) async {
    try {
      await _supabase.rpc('mark_chat_message_read', params: {'message_id': messageId});
    } catch (e) {
      // Ignore errors, it's just a read receipt
    }
  }
}

final circleChatRepository = CircleChatRepository();
