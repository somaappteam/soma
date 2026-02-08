class ChatMessage {
  final String id;
  final String fromUserId;
  final String toUserId;
  final String text;
  final DateTime createdAt;

  ChatMessage({
    required this.id,
    required this.fromUserId,
    required this.toUserId,
    required this.text,
    required this.createdAt,
  });
}
