class SoloCourse {
  final String id;
  final String title;
  final String subtitle;
  final String iconUrl; // or asset path
  final int xp;

  const SoloCourse({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.iconUrl,
    this.xp = 0,
  });

  SoloCourse copyWith({int? xp}) {
    return SoloCourse(
      id: id,
      title: title,
      subtitle: subtitle,
      iconUrl: iconUrl,
      xp: xp ?? this.xp,
    );
  }
}
