class UserProfile {
  String? id;
  String displayName;
  String username;
  String bio;
  String location;
  int dailyGoalMinutes;
  int totalXp;
  String? avatarUrl;
  bool showOnlineStatus;

  UserProfile({
    this.id,
    required this.displayName,
    required this.username,
    required this.bio,
    required this.location,
    required this.dailyGoalMinutes,
    this.totalXp = 0,
    this.avatarUrl,
    this.showOnlineStatus = true,
    this.isGuest = false,
  });

  bool isGuest;

  UserProfile copy() => UserProfile(
        id: id,
        displayName: displayName,
        username: username,
        bio: bio,
        location: location,
        dailyGoalMinutes: dailyGoalMinutes,
        totalXp: totalXp,
        avatarUrl: avatarUrl,
        showOnlineStatus: showOnlineStatus,
        isGuest: isGuest,
      );
}
