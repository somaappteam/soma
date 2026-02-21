import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/foundation.dart';

import '../core/i18n/ui_language.dart';
import '../core/services/notification_service.dart';
import '../models/app_settings.dart';
import 'achievements_repository.dart';
import 'soma_plus_repository.dart';
import '../core/di/locator.dart';

class SettingsRepository {
  final _supabase = Supabase.instance.client;
  SharedPreferences? _prefs;
  final Map<String, dynamic> _guestSettings = {
    ...AppSettings.defaults().toMap(),
    'plus_trial_started_at': null,
    'plus_expires_at': null,
  };
  final StreamController<Map<String, dynamic>> _settingsController =
      StreamController<Map<String, dynamic>>.broadcast();
  StreamSubscription<List<Map<String, dynamic>>>? _userSettingsSubscription;
  
  // Cache the current effective settings (either guest or user)
  Map<String, dynamic> _effectiveSettings = {};

  String? get currentUserId => _supabase.auth.currentUser?.id;

  Future<Map<String, dynamic>> getSettings() async {
    // Return cached if available, otherwise fetch
    if (_effectiveSettings.isNotEmpty) return Map<String, dynamic>.from(_effectiveSettings);
    
    final uid = currentUserId;
    if (uid == null) {
        _effectiveSettings = Map<String, dynamic>.from(_guestSettings);
        return _effectiveSettings;
    }

    try {
      final resp = await _supabase
          .from('profiles')
          .select('settings')
          .eq('id', uid)
          .single();
      _effectiveSettings = _withDefaults(resp['settings'] as Map<String, dynamic>?);
    } catch (e) {
      debugPrint("Error fetching settings: $e");
      // Fallback to guest settings structure but empty? or keep previous?
      // For now, valid valid map
      if (_effectiveSettings.isEmpty) _effectiveSettings = Map<String, dynamic>.from(_guestSettings);
    }
    return _effectiveSettings;
  }

  Future<AppSettings> getTypedSettings() async {
    final settings = await getSettings();
    return AppSettings.fromMap(settings);
  }

  /// Stream of the settings JSON object.
  Stream<Map<String, dynamic>> getSettingsStream() {
    return Stream<Map<String, dynamic>>.multi((controller) {
      // Emit current cached settings immediately
      controller.add(Map<String, dynamic>.from(_effectiveSettings.isEmpty ? _guestSettings : _effectiveSettings));
      
      final sub = _settingsController.stream.listen(controller.add);
      controller.onCancel = sub.cancel;
    });
  }

  Stream<AppSettings> getTypedSettingsStream() {
    return getSettingsStream().map(AppSettings.fromMap);
  }

  void _initAuthListener() {
    _supabase.auth.onAuthStateChange.listen((data) {
      if (data.session != null) {
        // User logged in — switch to user stream and sweep achievements.
        _listenToUserSettings(data.session!.user.id);
        // Delay slightly so the shell UI is ready before toasts appear.
        Future.delayed(const Duration(seconds: 2), () {
          achievementsRepository.checkOnLogin();
          notificationService.startRealtimeListener();
        });
      } else {
        // User logged out — revert to guest settings and clean up notifications.
        notificationService.stopRealtimeListener();
        notificationService.clearToken();
        _userSettingsSubscription?.cancel();
        _effectiveSettings = Map<String, dynamic>.from(_guestSettings);
        _settingsController.add(_effectiveSettings);
      }
    });
  }

  void _listenToUserSettings(String uid) {
    _userSettingsSubscription?.cancel();
    
    // First, fetch latest to ensure we have data immediately
    _bootstrapUserSettings(uid);

    _userSettingsSubscription = _supabase
        .from('profiles')
        .stream(primaryKey: ['id'])
        .eq('id', uid)
        .listen((event) {
      if (event.isEmpty) return;
      final row = event.first;
      _effectiveSettings = _withDefaults(row['settings'] as Map<String, dynamic>?);
      _settingsController.add(_effectiveSettings);
    });
  }

  Future<void> _bootstrapUserSettings(String uid) async {
    try {
      final resp = await _supabase.from('profiles').select('settings').eq('id', uid).single();
      _effectiveSettings = _withDefaults(resp['settings'] as Map<String, dynamic>?);
      _settingsController.add(_effectiveSettings);
    } catch (e) {
      debugPrint("Error bootstrapping settings: $e");
    }
  }

  /// Updates a specific setting key with a new value.
  Future<void> updateSetting(String key, dynamic value) async {
    final uid = currentUserId;

    // Update guest persistence if guest (or always? usually we want to persist guest settings locally)
    // The previous logic only persisted to prefs if guest.
    
    if (uid == null) {
      _guestSettings[key] = _normalizeSettingValue(key, value);
      _effectiveSettings = Map<String, dynamic>.from(_guestSettings);
      _settingsController.add(_effectiveSettings);
      
      _persistGuestValue(key, _guestSettings[key]);
      return;
    }

    // User is logged in
    _effectiveSettings[key] = _normalizeSettingValue(key, value);
    _settingsController.add(Map<String, dynamic>.from(_effectiveSettings));

    // Reflect notification-related setting changes immediately.
    _applyNotificationSetting(key, _effectiveSettings[key], _effectiveSettings);

    try {
      final resp = await _supabase
          .from('profiles')
          .select('settings')
          .eq('id', uid)
          .single();
      
      final currentSettings = _withDefaults(resp['settings'] as Map<String, dynamic>?);
      currentSettings[key] = _normalizeSettingValue(key, value);

      await _supabase
          .from('profiles')
          .update({'settings': currentSettings})
          .eq('id', uid);
    } catch (e) {
      debugPrint("Error updating setting $key: $e");
    }
  }

  // Helper to bulk update if needed
  Future<void> updateSettings(Map<String, dynamic> newValues) async {
    final uid = currentUserId;
    if (uid == null) {
      for (final entry in newValues.entries) {
        _guestSettings[entry.key] = _normalizeSettingValue(entry.key, entry.value);
      }
      _effectiveSettings = Map<String, dynamic>.from(_guestSettings);
      _settingsController.add(_effectiveSettings);
      for (final entry in newValues.entries) {
        _persistGuestValue(entry.key, _guestSettings[entry.key]);
      }
      return;
    }

    for (final entry in newValues.entries) {
      _effectiveSettings[entry.key] = _normalizeSettingValue(entry.key, entry.value);
    }
    _settingsController.add(_effectiveSettings);
    
    try {
      final resp = await _supabase.from('profiles').select('settings').eq('id', uid).single();
      final currentSettings = _withDefaults(resp['settings'] as Map<String, dynamic>?);
      for (final entry in newValues.entries) {
        currentSettings[entry.key] = _normalizeSettingValue(entry.key, entry.value);
      }

      await _supabase.from('profiles').update({'settings': currentSettings}).eq('id', uid);
    } catch (e) {
      debugPrint("Error updating settings: $e");
    }
  }


  Map<String, dynamic> _withDefaults(Map<String, dynamic>? remote) {
    final merged = Map<String, dynamic>.from(_guestSettings);
    if (remote != null) {
      merged.addAll(remote);
    }
    merged['language_ui'] = normalizeUiLanguageCode(merged['language_ui']?.toString());
    merged['plus_plan'] = SomaPlusRepository.serializeTier(SomaPlusRepository.parseTier(merged['plus_plan']?.toString()));
    merged['plus_enabled'] = merged['plus_enabled'] == true;
    return merged;
  }

  dynamic _normalizeSettingValue(String key, dynamic value) {
    if (key == 'language_ui') {
      return normalizeUiLanguageCode(value?.toString());
    }
    if (key == 'plus_plan') {
      return SomaPlusRepository.serializeTier(SomaPlusRepository.parseTier(value?.toString()));
    }
    return value;
  }

  void _persistGuestValue(String key, dynamic value) {
    if (value is bool) {
      _prefs?.setBool(key, value);
    } else if (value is String) {
      _prefs?.setString(key, value);
    } else if (value is int) {
      _prefs?.setInt(key, value);
    } else if (value is double) {
      _prefs?.setDouble(key, value);
    } else if (value is Map || value is List) {
      // Maps and Lists are stored as JSON strings.
      _prefs?.setString(key, jsonEncode(value));
    }
  }

  /// Reacts immediately to notification-related setting changes.
  void _applyNotificationSetting(
      String key, dynamic value, Map<String, dynamic> current) {
    if (key == 'push_notifications') {
      final enabled = value == true;
      notificationService.setPushEnabled(enabled);
      // Re-schedule or cancel reminder based on new toggle.
      final time = current['daily_reminder']?.toString() ?? '20:00';
      notificationService.scheduleReminder(time, enabled: enabled);
    } else if (key == 'daily_reminder') {
      final enabled = current['push_notifications'] == true;
      notificationService.scheduleReminder(value?.toString() ?? '', enabled: enabled);
    }
  }

  Future<void> _hydrateFromCurrentSessionIfNeeded() async {
    final uid = currentUserId;
    if (uid == null) {
      _effectiveSettings = Map<String, dynamic>.from(_guestSettings);
      _settingsController.add(_effectiveSettings);
      return;
    }
    await _bootstrapUserSettings(uid);
    _listenToUserSettings(uid);
  }

  SettingsRepository();

  Future<void> init() async {
    try {
      _prefs = await SharedPreferences.getInstance();
      await _loadGuestPersistence();
      // Initialize effective settings with guest settings initially
      _effectiveSettings = Map<String, dynamic>.from(_guestSettings);
    } catch (e) {
      debugPrint("Error initializing settings repository: $e");
    }
    _initAuthListener();
    await _hydrateFromCurrentSessionIfNeeded();
  }

  Future<void> _loadGuestPersistence() async {
    try {
      if (_prefs == null) return;
      
      final keys = _guestSettings.keys;
      bool changed = false;
      for (final key in keys) {
        final val = _prefs?.get(key);
        if (val != null) {
          final defaultVal = _guestSettings[key];
          // If we stored a Map/List as a JSON string, decode it back.
          if (val is String && (defaultVal is Map || defaultVal is List)) {
            try {
              _guestSettings[key] = jsonDecode(val);
            } catch (_) {
              _guestSettings[key] = val;
            }
          } else {
            _guestSettings[key] = val;
          }
          changed = true;
        }
      }
      _guestSettings['language_ui'] = normalizeUiLanguageCode(_guestSettings['language_ui']?.toString());
      // If we loaded something, update the effective settings if we are currently a guest
      if (changed && currentUserId == null) {
         _effectiveSettings = Map<String, dynamic>.from(_guestSettings);
         _settingsController.add(_effectiveSettings);
      }
    } catch (e) {
      debugPrint("Error loading guest settings: $e");
    }
  }
}

SettingsRepository get settingsRepository => locator<SettingsRepository>();
