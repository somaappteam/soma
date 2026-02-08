class Achievement {
  final String id;
  final String title;
  final String? description;
  final String? icon;
  final bool unlocked;
  final DateTime? unlockedAt;

  const Achievement({
    required this.id,
    required this.title,
    this.description,
    this.icon,
    required this.unlocked,
    this.unlockedAt,
  });
}
