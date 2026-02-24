import 'dart:async';

import 'package:flutter/services.dart';
import 'package:soma/data/settings_repository.dart';

class HapticsService {
  bool _enabled = true;
  StreamSubscription<Map<String, dynamic>>? _subscription;

  Future<void> init() async {
    final settings = await settingsRepository.getSettings();
    _enabled = settings['haptics_enabled'] ?? true;
    _subscription?.cancel();
    _subscription =
        settingsRepository.getSettingsStream().listen((final settings) {
      final next = settings['haptics_enabled'];
      if (next is bool) {
        _enabled = next;
      }
    });
  }

  void dispose() {
    _subscription?.cancel();
  }

  void selectionClick() {
    if (_enabled) {
      HapticFeedback.selectionClick();
    }
  }

  void lightImpact() {
    if (_enabled) {
      HapticFeedback.lightImpact();
    }
  }

  void mediumImpact() {
    if (_enabled) {
      HapticFeedback.mediumImpact();
    }
  }
}

final hapticsService = HapticsService();
