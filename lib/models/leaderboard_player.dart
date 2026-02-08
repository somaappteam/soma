class LeaderboardPlayer {
  final String? userId;
  final String name;
  final int points;
  final int correct;
  final int total;
  final bool isMe;
  final bool isHost;
  final bool isMuted;
  final bool isSpeaking;
  final LeaderboardAnswer lastAnswer;
  final String? avatarUrl;

  const LeaderboardPlayer({
    this.userId,
    required this.name,
    required this.points,
    required this.correct,
    required this.total,
    this.isMe = false,
    this.isHost = false,
    this.isMuted = false,
    this.isSpeaking = false,
    this.lastAnswer = LeaderboardAnswer.none,
    this.avatarUrl,
  });

  int get accuracyPct => total == 0 ? 0 : ((correct / total) * 100).round();
}

enum LeaderboardAnswer { none, correct, wrong }

