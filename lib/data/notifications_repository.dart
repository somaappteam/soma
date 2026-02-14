import 'package:supabase_flutter/supabase_flutter.dart';

import 'experiment_repository.dart';

class NotificationsRepository {
  final _supabase = Supabase.instance.client;

  Stream<List<Map<String, dynamic>>> getNotificationsStream() {
    final uid = _supabase.auth.currentUser?.id;
    if (uid == null) return const Stream.empty();

    // Table: notifications (id, user_id, type, title, body, is_read, metadata, created_at)
    return _supabase
        .from('notifications')
        .stream(primaryKey: ['id'])
        .eq('user_id', uid)
        .order('created_at', ascending: false);
  }

  Future<void> markAsRead(String notificationId) async {
    await _supabase
        .from('notifications')
        .update({'is_read': true})
        .eq('id', notificationId);
  }

  Future<void> deleteNotification(String notificationId) async {
    await _supabase
        .from('notifications')
        .delete()
        .eq('id', notificationId);
  }

  Future<void> markAllAsRead() async {
    final uid = _supabase.auth.currentUser?.id;
    if (uid == null) return;

    await _supabase
        .from('notifications')
        .update({'is_read': true})
        .eq('user_id', uid);
  }

  Future<void> sendCircleInvite({
    required String toUserId,
    required String circleId,
    required String circleTitle,
    required String fromUserId,
    required String fromUserName,
  }) async {
    await _supabase.from('notifications').insert({
      'user_id': toUserId,
      'type': 'circle',
      'title': 'Circle invite',
      'body': '$fromUserName invited you to $circleTitle.',
      'is_read': false,
      'metadata': {
        'circle_action': 'invite',
        'circle_id': circleId,
        'circle_title': circleTitle,
        'from_user_id': fromUserId,
        'from_user_name': fromUserName,
      },
    });
  }

  Future<void> sendFriendRequestNotification({
    required String toUserId,
    required String fromUserId,
    required String fromUserName,
    String? friendshipId,
  }) async {
    final variant = await experimentRepository.variant(
      'notif_copy_friend_request',
      buckets: const ['A', 'B'],
    );
    final title = variant == 'B' ? 'Someone wants to connect' : 'New friend request';
    final body = variant == 'B'
        ? '$fromUserName sent you a connection invite.'
        : '$fromUserName wants to add you as a friend.';

    await _supabase.from('notifications').insert({
      'user_id': toUserId,
      'type': 'social',
      'title': title,
      'body': body,
      'is_read': false,
      'metadata': {
        'action': 'friend_request',
        'social_action': 'friend_request',
        'copy_variant': variant,
        'from_user_id': fromUserId,
        'from_user_name': fromUserName,
        if (friendshipId != null) 'friendship_id': friendshipId,
      },
    });
  }
}

final notificationsRepository = NotificationsRepository();
