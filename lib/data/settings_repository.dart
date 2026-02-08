import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/foundation.dart';

class SettingsRepository {
  final _supabase = Supabase.instance.client;

  String? get currentUserId => _supabase.auth.currentUser?.id;

  Future<Map<String, dynamic>> getSettings() async {
    final uid = currentUserId;
    if (uid == null) return {};

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
    if (uid == null) return const Stream.empty();

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
    if (uid == null) return;

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
    if (uid == null) return;

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
