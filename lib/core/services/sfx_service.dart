import 'dart:async';

import 'package:flutter/services.dart';

import '../../data/settings_repository.dart';

class SfxService {
  bool _enabled = true;
  StreamSubscription<Map<String, dynamic>>? _subscription;

  Future<void> init() async {
    final settings = await settingsRepository.getSettings();
    _enabled = settings['sfx_enabled'] ?? true;
    _subscription?.cancel();
    _subscription = settingsRepository.getSettingsStream().listen((settings) {
      final next = settings['sfx_enabled'];
      if (next is bool) {
        _enabled = next;
      }
    });
  }

  void dispose() {
    _subscription?.cancel();
  }

  void click() {
    if (_enabled) {
      SystemSound.play(SystemSoundType.click);
    }
  }
}

final sfxService = SfxService();
