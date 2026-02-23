class SoloCourse {
  final String id;
  final String title;
  final String subtitle;
  final String iconUrl; // or asset path
  final int xp;
  final DateTime? lastAccessed;

  const SoloCourse({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.iconUrl,
    this.xp = 0,
    this.lastAccessed,
  });

  SoloCourse copyWith({final int? xp, final DateTime? lastAccessed}) {
    return SoloCourse(
      id: id,
      title: title,
      subtitle: subtitle,
      iconUrl: iconUrl,
      xp: xp ?? this.xp,
      lastAccessed: lastAccessed ?? this.lastAccessed,
    );
  }
}
