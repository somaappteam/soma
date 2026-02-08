import 'package:flutter/material.dart';
import 'package:soma/l10n/gen/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
// import 'package:flutter_driver/driver_extension.dart';
import 'package:google_fonts/google_fonts.dart';
import 'core/theme/tokens.dart';
import 'features/auth/splash_screen.dart';

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'dart:io';
import 'data/content_sync_service.dart';
import 'core/services/session_tracker.dart';
import 'package:flutter/foundation.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (!kIsWeb && (Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  await Supabase.initialize(
    url: 'https://bnbjteedohflgkarfaxk.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImJuYmp0ZWVkb2hmbGdrYXJmYXhrIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Njk3MDAyNjQsImV4cCI6MjA4NTI3NjI2NH0.m8ua_6P0AtykUgLbLuxeE3o3i4Dwfw_xPsvODORlKtM',
  );

  try {
    await sessionTracker.start();
  } catch (e) {
    debugPrint("Session tracking failed to start: $e");
  }
  
  _runContentSync();
  runApp(const App());
}

Future<void> _runContentSync() async {
  await Future.delayed(const Duration(seconds: 1));
  try {
    await contentSyncService.syncEverything();
  } catch (e) {
    debugPrint("Sync failed: $e");
  }
}

class App extends StatelessWidget {
  const App({super.key});

  double _uiScaleFor(MediaQueryData media) {
    final shortest = media.size.shortestSide;
    if (shortest >= 1200) return 0.86;
    if (shortest >= 900) return 0.9;
    if (shortest >= 700) return 0.94;
    return (shortest / 390).clamp(0.9, 1.0);
  }

  EdgeInsets _scaleInsets(EdgeInsets insets, double scale) {
    return EdgeInsets.fromLTRB(
      insets.left / scale,
      insets.top / scale,
      insets.right / scale,
      insets.bottom / scale,
    );
  }

  @override
  Widget build(BuildContext context) {
    final base = ThemeData.dark();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      theme: base.copyWith(
        scaffoldBackgroundColor: T.bg0,
        textTheme: GoogleFonts.poppinsTextTheme(
          base.textTheme,
        ).apply(bodyColor: T.textHi, displayColor: T.textHi),
      ),
      builder: (context, child) {
        if (child == null) return const SizedBox.shrink();
        final media = MediaQuery.of(context);
        final scale = _uiScaleFor(media);
        if (scale == 1.0) return child;

        final baseTextScale = media.textScaler.scale(1.0);
        final scaledMedia = media.copyWith(
          size: Size(media.size.width / scale, media.size.height / scale),
          padding: _scaleInsets(media.padding, scale),
          viewPadding: _scaleInsets(media.viewPadding, scale),
          viewInsets: _scaleInsets(media.viewInsets, scale),
          systemGestureInsets: _scaleInsets(media.systemGestureInsets, scale),
          textScaler: TextScaler.linear(baseTextScale * scale),
        );

        return MediaQuery(
          data: scaledMedia,
          child: Transform.scale(
            scale: scale,
            alignment: Alignment.topCenter,
            child: SizedBox(
              width: media.size.width / scale,
              height: media.size.height / scale,
              child: child,
            ),
          ),
        );
      },
      home: const SplashScreen(),
    );
  }
}
