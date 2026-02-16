import 'package:flutter/foundation.dart';
import 'dart:async';
import '../models/user_profile.dart';
import 'profile_repository.dart';

class ProfileStore extends ChangeNotifier {
  UserProfile _profile = UserProfile(
    displayName: "Guest",
    username: "",
    bio: "",
    location: "",
    dailyGoalMinutes: 10,
  );



  UserProfile get profile => _profile;
  StreamSubscription<UserProfile?>? _profileSub;

  Future<void> load() async {
    // 1. Initial fetch for immediate data
    final p = await profileRepository.fetchProfile();
    if (p != null) {
      _profile = p;
      notifyListeners();
    }

    // 2. Subscribe to real-time updates
    _profileSub?.cancel();
    _profileSub = profileRepository.getProfileStream().listen((p) {
      if (p != null) {
        _profile = p;
        notifyListeners();
      }
    });
  }

  @override
  void dispose() {
    _profileSub?.cancel();
    super.dispose();
  }

  void update(UserProfile next) {
    _profile = next;
    notifyListeners();
  }

  void reset() {
    _profile = UserProfile(
      displayName: "Guest",
      username: "",
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
      username: "",
      bio: "",
      location: "",
      dailyGoalMinutes: 10,
      avatarUrl: "",
      isGuest: true,
    );
    notifyListeners();
  }
}

final profileStore = ProfileStore();
