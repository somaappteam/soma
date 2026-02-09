import 'dart:async';

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/foundation.dart';

class SettingsRepository {
  final _supabase = Supabase.instance.client;
  final Map<String, dynamic> _guestSettings = {
    'show_translation': true,
    'show_reading': true,
    'bg_music': true,
    'sfx_enabled': true,
    'haptics_enabled': true,
    'push_notifications': true,
    'default_timer_s': 15,
    'match_difficulty': 'Adaptive',
    'daily_reminder': '20:00',
    'theme_mode': 'System',
    'language_ui': 'English',
  };
  final StreamController<Map<String, dynamic>> _guestSettingsController =
      StreamController<Map<String, dynamic>>.broadcast();

  String? get currentUserId => _supabase.auth.currentUser?.id;

  Future<Map<String, dynamic>> getSettings() async {
    final uid = currentUserId;
    if (uid == null) return Map<String, dynamic>.from(_guestSettings);

    final resp = await _supabase
        .from('profiles')
        .select('settings')
        .eq('id', uid)
        .single();
    return Map<String, dynamic>.from(resp['settings'] ?? {});
  }

  /// Stream of the user's settings JSON object from the 'profiles' table.
  /// Assumes a 'settings' column of type JSONB exists.
  Stream<Map<String, dynamic>> getSettingsStream() {
    final uid = currentUserId;
    if (uid == null) {
      return Stream<Map<String, dynamic>>.multi((controller) {
        controller.add(Map<String, dynamic>.from(_guestSettings));
        final sub = _guestSettingsController.stream.listen(controller.add);
        controller.onCancel = sub.cancel;
      });
    }

    return _supabase
        .from('profiles')
        .stream(primaryKey: ['id'])
        .eq('id', uid)
        .map((event) {
          if (event.isEmpty) return {};
          final row = event.first;
          // Handle case where 'settings' column might be null
          return (row['settings'] as Map<String, dynamic>?) ?? {};
        });
  }

  /// Updates a specific setting key with a new value.
  /// Merges with existing settings.
  Future<void> updateSetting(String key, dynamic value) async {
    final uid = currentUserId;
    if (uid == null) {
      _guestSettings[key] = value;
      _guestSettingsController.add(Map<String, dynamic>.from(_guestSettings));
      return;
    }

    try {
      // 1. Fetch current settings to merge
      final resp = await _supabase
          .from('profiles')
          .select('settings')
          .eq('id', uid)
          .single();
      
      final currentSettings = Map<String, dynamic>.from(resp['settings'] ?? {});
      
      // 2. Update the specific key
      currentSettings[key] = value;

      // 3. Save back
      await _supabase
          .from('profiles')
          .update({'settings': currentSettings})
          .eq('id', uid);
    } catch (e) {
      // If 'settings' column doesn't exist, we might need to notify user or handle gracefully.
      // For now, rethrow or log?
      debugPrint("Error updating setting $key: $e");
    }
  }

  // Helper to bulk update if needed
  Future<void> updateSettings(Map<String, dynamic> newValues) async {
    final uid = currentUserId;
    if (uid == null) {
      _guestSettings.addAll(newValues);
      _guestSettingsController.add(Map<String, dynamic>.from(_guestSettings));
      return;
    }

    try {
      final resp = await _supabase.from('profiles').select('settings').eq('id', uid).single();
      final currentSettings = Map<String, dynamic>.from(resp['settings'] ?? {});
      
      currentSettings.addAll(newValues);

      await _supabase.from('profiles').update({'settings': currentSettings}).eq('id', uid);
    } catch (e) {
      debugPrint("Error updating settings: $e");
    }
  }
}

final settingsRepository = SettingsRepository();
