import 'package:flutter/foundation.dart';
import '../models/user_profile.dart';
import 'profile_repository.dart';

class ProfileStore extends ChangeNotifier {
  UserProfile _profile = UserProfile(
    displayName: "Loading...",
    username: "...",
    bio: "",
    location: "",
    dailyGoalMinutes: 10,
  );

  UserProfile get profile => _profile;

  Future<void> load() async {
    final p = await profileRepository.fetchProfile();
    if (p != null) {
      _profile = p;
      notifyListeners();
    }
  }

  void update(UserProfile next) {
    _profile = next;
    notifyListeners();
  }

  void reset() {
    _profile = UserProfile(
      displayName: "Guest",
      username: "...",
      bio: "",
      location: "",
      dailyGoalMinutes: 10,
      isGuest: true,
    );
    notifyListeners();
  }

  void loginAsGuest() {
    _profile = UserProfile(
      displayName: "Guest",
      username: "guest_user",
      bio: "Just checking things out",
      location: "Earth",
      dailyGoalMinutes: 10,
      avatarUrl: "",
      isGuest: true,
    );
    notifyListeners();
  }
}

final profileStore = ProfileStore();

