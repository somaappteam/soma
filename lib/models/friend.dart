enum FriendStatus { friend, incomingRequest, outgoingRequest }

class Friend {
  final String id; // later: user uuid
  final String username;
  final String? subtitle; // e.g. "Online", "Last seen", "Learning: en→es"
  final FriendStatus status;

  const Friend({
    required this.id,
    required this.username,
    this.subtitle,
    required this.status,
  });

  bool get isOnline => (subtitle ?? "").toLowerCase().contains("online");
}
