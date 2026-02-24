import 'package:flutter/foundation.dart';
import 'package:soma/data/notifications_repository.dart';

enum NotifType { system, course, social, circle }

enum SocialAction { friendRequest }

enum CircleAction { invite }

enum CourseAction { dailyGoal }

class AppNotification {
  final String id;
  final NotifType type;
  final String title;
  final String body;
  final DateTime time;

  bool isRead;

  // Optional payload
  final SocialAction? socialAction;
  final String? fromUserId;
  final String? fromUserName;
  final String? friendshipId;

  final CircleAction? circleAction;
  final String? circleId;
  final String? circleTitle;

  final CourseAction? courseAction;
  final String? courseId;

  AppNotification({
    required this.id,
    required this.type,
    required this.title,
    required this.body,
    required this.time,
    this.isRead = false,
    this.socialAction,
    this.fromUserId,
    this.fromUserName,
    this.friendshipId,
    this.circleAction,
    this.circleId,
    this.circleTitle,
    this.courseAction,
    this.courseId,
  });
}

class NotificationsStore extends ChangeNotifier {
  List<AppNotification> _items = [];
  bool _initialized = false;
  VoidCallback? _disposeListener;

  List<AppNotification> get items => List.unmodifiable(_items);
  int get unreadCount => _items.where((final n) => !n.isRead).length;

  NotificationsStore() {
    _init();
  }

  void _init() {
    if (_initialized) return;
    _initialized = true;

    final sub =
        notificationsRepository.getNotificationsStream().listen((final rows) {
      _items = rows.map((final row) {
        final metadataRaw = row['metadata'];
        final metadata = metadataRaw is Map
            ? Map<String, dynamic>.from(metadataRaw)
            : <String, dynamic>{};

        final courseAction = metadata['course_action'] == 'daily_goal'
            ? CourseAction.dailyGoal
            : null;

        return AppNotification(
          id: row['id'].toString(),
          type: _parseType(row['type']),
          title: row['title'] ?? '',
          body: row['body'] ?? '',
          time: _parseTime(row['created_at']),
          isRead: row['is_read'] == true || row['is_read'] == 1,
          socialAction: metadata['social_action'] == 'friend_request'
              ? SocialAction.friendRequest
              : null,
          fromUserId: metadata['from_user_id'],
          fromUserName: metadata['from_user_name'],
          friendshipId: metadata['friendship_id']?.toString(),
          circleAction: metadata['circle_action'] == 'invite'
              ? CircleAction.invite
              : null,
          circleId: metadata['circle_id'],
          circleTitle: metadata['circle_title'],
          courseAction: courseAction,
          courseId: metadata['course_id']?.toString(),
        );
      }).toList();
      notifyListeners();
    });

    _disposeListener = () {
      sub.cancel();
      _disposeListener = null;
    };
  }

  DateTime _parseTime(final dynamic raw) {
    if (raw is DateTime) return raw;
    if (raw is String) {
      return DateTime.tryParse(raw) ?? DateTime.now();
    }
    return DateTime.now();
  }

  NotifType _parseType(final String? type) {
    switch (type) {
      case 'social':
        return NotifType.social;
      case 'circle':
        return NotifType.circle;
      case 'course':
        return NotifType.course;
      default:
        return NotifType.system;
    }
  }

  void markRead(final String id) {
    notificationsRepository.markAsRead(id);
  }

  void markAllRead() {
    notificationsRepository.markAllAsRead();
  }

  void delete(final String id) {
    notificationsRepository.deleteNotification(id);
  }

  void acceptFriendRequest(final String notifId) {
    // Logic will be handled via SocialRepository or by clicking the notification
    markRead(notifId);
  }

  void declineFriendRequest(final String notifId) {
    markRead(notifId);
  }

  void joinCircle(final String notifId) {
    markRead(notifId);
  }

  @override
  void dispose() {
    _disposeListener?.call();
    super.dispose();
  }
}

final notificationsStore = NotificationsStore();
