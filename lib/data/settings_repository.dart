import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/foundation.dart';

class SettingsRepository {
  final _supabase = Supabase.instance.client;
  SharedPreferences? _prefs;
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
      _effectiveSettings = Map<String, dynamic>.from(resp['settings'] ?? {});
    } catch (e) {
      debugPrint("Error fetching settings: $e");
      // Fallback to guest settings structure but empty? or keep previous?
      // For now, valid valid map
      if (_effectiveSettings.isEmpty) _effectiveSettings = Map<String, dynamic>.from(_guestSettings);
    }
    return _effectiveSettings;
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

  void _initAuthListener() {
    _supabase.auth.onAuthStateChange.listen((data) {
      if (data.session != null) {
        // User logged in, switch to user stream
        _listenToUserSettings(data.session!.user.id);
      } else {
        // User logged out, revert to guest settings
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
      final serverSettings = (row['settings'] as Map<String, dynamic>?) ?? {};
      _effectiveSettings = Map<String, dynamic>.from(serverSettings);
      _settingsController.add(_effectiveSettings);
    });
  }

  Future<void> _bootstrapUserSettings(String uid) async {
    try {
      final resp = await _supabase.from('profiles').select('settings').eq('id', uid).single();
      final settings = Map<String, dynamic>.from(resp['settings'] ?? {});
      _effectiveSettings = settings;
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
      _guestSettings[key] = value;
      _effectiveSettings = Map<String, dynamic>.from(_guestSettings);
      _settingsController.add(_effectiveSettings);
      
      if (value is bool) {
        _prefs?.setBool(key, value);
      } else if (value is String) {
        _prefs?.setString(key, value);
      } else if (value is int) {
        _prefs?.setInt(key, value);
      } else if (value is double) {
        _prefs?.setDouble(key, value);
      }
      return;
    }

    // User is logged in
    _effectiveSettings[key] = value;
    _settingsController.add(Map<String, dynamic>.from(_effectiveSettings));

    try {
      final resp = await _supabase
          .from('profiles')
          .select('settings')
          .eq('id', uid)
          .single();
      
      final currentSettings = Map<String, dynamic>.from(resp['settings'] ?? {});
      currentSettings[key] = value;

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
      _guestSettings.addAll(newValues);
      _effectiveSettings = Map<String, dynamic>.from(_guestSettings);
      _settingsController.add(_effectiveSettings);
      return;
    }

    _effectiveSettings.addAll(newValues);
    _settingsController.add(_effectiveSettings);
    
    try {
      final resp = await _supabase.from('profiles').select('settings').eq('id', uid).single();
      final currentSettings = Map<String, dynamic>.from(resp['settings'] ?? {});
      currentSettings.addAll(newValues);

      await _supabase.from('profiles').update({'settings': currentSettings}).eq('id', uid);
    } catch (e) {
      debugPrint("Error updating settings: $e");
    }
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
  }

  Future<void> _loadGuestPersistence() async {
    try {
      if (_prefs == null) return;
      
      final keys = _guestSettings.keys;
      bool changed = false;
      for (final key in keys) {
        final val = _prefs?.get(key);
        if (val != null) {
          _guestSettings[key] = val;
          changed = true;
        }
      }
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

final settingsRepository = SettingsRepository();
