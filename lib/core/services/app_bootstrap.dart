import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../config/app_config.dart';
import '../../data/settings_repository.dart';
import '../../data/soma_plus_repository.dart';
import 'haptics_service.dart';
import 'session_tracker.dart';
import 'sfx_service.dart';
import 'theme_mode_controller.dart';

class AppBootstrap {
  const AppBootstrap();

  Future<void> initialize() async {
    _initSqliteIfNeeded();

    AppConfig.validate();
    await Supabase.initialize(
      url: AppConfig.supabaseUrl,
      anonKey: AppConfig.supabaseAnonKey,
    );

    try {
      await sessionTracker.start();
    } catch (e) {
      debugPrint('Session tracking failed to start: $e');
    }

    await themeModeController.load();
    await hapticsService.init();
    await sfxService.init();
    await settingsRepository.init();
    await somaPlusRepository.init();
  }

  void _initSqliteIfNeeded() {
    if (kIsWeb) return;

    if (Platform.isWindows) {
      _fixSqliteDll();
    }

    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    }
  }

  void _fixSqliteDll() {
    try {
      final exeDir = File(Platform.resolvedExecutable).parent;
      final bundled = File('${exeDir.path}\\sqlite3.dll');
      final target = File('${exeDir.path}\\sqlite3.x64.windows.dll');
      if (bundled.existsSync() && !target.existsSync()) {
        bundled.copySync(target.path);
      }
    } catch (_) {
      // Non-fatal best effort.
    }
  }
}
