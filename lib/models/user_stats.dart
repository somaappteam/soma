class UserStats {
  final int totalWins;
  final int streakDays;
  final int longestStreak;
  final int totalQuizzes;
  final int totalCorrect;
  final int totalQuestions;
  final int perfectQuizzes;
  final int circlesJoined;
  final DateTime? lastActiveDate;

  const UserStats({
    required this.totalWins,
    required this.streakDays,
    required this.longestStreak,
    required this.totalQuizzes,
    required this.totalCorrect,
    required this.totalQuestions,
    required this.perfectQuizzes,
    required this.circlesJoined,
    required this.lastActiveDate,
  });

  factory UserStats.fromRow(final Map<String, dynamic> row) {
    return UserStats(
      totalWins: row['total_wins'] ?? 0,
      streakDays: row['streak_days'] ?? 0,
      longestStreak: row['longest_streak'] ?? 0,
      totalQuizzes: row['total_quizzes'] ?? 0,
      totalCorrect: row['total_correct'] ?? 0,
      totalQuestions: row['total_questions'] ?? 0,
      perfectQuizzes: row['perfect_quizzes'] ?? 0,
      circlesJoined: row['circles_joined'] ?? 0,
      lastActiveDate: _parseDate(row['last_active_date']),
    );
  }

  static DateTime? _parseDate(final dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    if (value is String && value.isNotEmpty) {
      return DateTime.tryParse(value);
    }
    return null;
  }

  static UserStats empty() {
    return const UserStats(
      totalWins: 0,
      streakDays: 0,
      longestStreak: 0,
      totalQuizzes: 0,
      totalCorrect: 0,
      totalQuestions: 0,
      perfectQuizzes: 0,
      circlesJoined: 0,
      lastActiveDate: null,
    );
  }
}
