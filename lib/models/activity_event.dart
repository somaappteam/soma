/// A single entry in the friend activity feed.
class ActivityEvent {
  final String userId;
  final String username;
  final String displayName;
  final String? avatarUrl;
  final String actionText;
  final int xpDelta;
  final DateTime timestamp;

  const ActivityEvent({
    required this.userId,
    required this.username,
    required this.displayName,
    this.avatarUrl,
    required this.actionText,
    required this.xpDelta,
    required this.timestamp,
  });

  /// Human-readable time-ago string (e.g. "2h ago", "just now").
  String get timeAgo {
    final diff = DateTime.now().difference(timestamp);
    if (diff.inSeconds < 60) return 'just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }
}
