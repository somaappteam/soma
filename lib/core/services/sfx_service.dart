import 'dart:async';

import 'package:flutter/services.dart';

import 'package:soma/data/settings_repository.dart';

class SfxService {
  bool _enabled = true;
  StreamSubscription<Map<String, dynamic>>? _subscription;

  Future<void> init() async {
    final settings = await settingsRepository.getSettings();
    _enabled = settings['sfx_enabled'] ?? true;
    _subscription?.cancel();
    _subscription = settingsRepository.getSettingsStream().listen((final settings) {
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

  void softClick() {
    click();
  }

  void risingTone() {
    if (_enabled) {
      SystemSound.play(SystemSoundType.alert);
    }
  }


  void answerCorrect({final bool isStreak = false}) {
    if (!_enabled) return;
    if (isStreak) {
      risingTone();
      return;
    }
    SystemSound.play(SystemSoundType.alert);
  }

  void answerWrong() {
    if (!_enabled) return;
    SystemSound.play(SystemSoundType.click);
    Future<void>.delayed(const Duration(milliseconds: 40), () {
      if (_enabled) {
        SystemSound.play(SystemSoundType.click);
      }
    });
  }

  void sparkle() {
    if (_enabled) {
      SystemSound.play(SystemSoundType.alert);
      SystemSound.play(SystemSoundType.click);
    }
  }
}

final sfxService = SfxService();
