import 'dart:async';
import 'dart:io' show Platform;
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:soma/core/services/app_logger.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SessionTracker {
  final _supabase = Supabase.instance.client;
  StreamSubscription<AuthState>? _sub;
  String? _deviceId;

  static const _deviceIdKey = 'soma_device_id';

  Future<void> start() async {
    _deviceId ??= await _loadDeviceId();

    _sub ??= _supabase.auth.onAuthStateChange.listen((final data) {
      if (data.session?.user.id != null) {
        _upsertSession(data.session!.user.id);
      }
    });

    final uid = _supabase.auth.currentUser?.id;
    if (uid != null) {
      await _upsertSession(uid);
    }
  }

  Future<void> endCurrentSession() async {
    final uid = _supabase.auth.currentUser?.id;
    if (uid == null) return;
    final deviceId = _deviceId ?? await _loadDeviceId();

    await _supabase
        .from('user_sessions')
        .update({'is_current': false})
        .eq('user_id', uid)
        .eq('device_id', deviceId);
  }

  Future<String> _loadDeviceId() async {
    final prefs = await SharedPreferences.getInstance();
    final existing = prefs.getString(_deviceIdKey);
    if (existing != null && existing.isNotEmpty) return existing;

    final id = _generateDeviceId();
    await prefs.setString(_deviceIdKey, id);
    return id;
  }

  String _generateDeviceId() {
    final rand = Random.secure();
    final bytes = List<int>.generate(16, (final _) => rand.nextInt(256));
    return bytes.map((final b) => b.toRadixString(16).padLeft(2, '0')).join();
  }

  Future<void> _upsertSession(final String userId) async {
    final deviceId = _deviceId;
    if (deviceId == null) return;

    final platform = kIsWeb ? 'web' : Platform.operatingSystem;
    final deviceName = kIsWeb ? 'Web' : Platform.localHostname;

    try {
      await _supabase
          .from('user_sessions')
          .update({'is_current': false}).eq('user_id', userId);

      await _supabase.from('user_sessions').upsert({
        'user_id': userId,
        'device_id': deviceId,
        'device_name': deviceName,
        'platform': platform,
        'last_seen': DateTime.now().toIso8601String(),
        'is_current': true,
      }, onConflict: 'user_id, device_id');
    } catch (e) {
      appLogger.debug('Failed to upsert session: $e');
    }
  }
}

final sessionTracker = SessionTracker();
