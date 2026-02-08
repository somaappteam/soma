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
import 'data/settings_repository.dart';
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

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  final List<Locale> _supportedLocales = const [
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('de'),
    Locale('it'),
    Locale('pt'),
    Locale('ru'),
    Locale('ja'),
    Locale('zh'),
    Locale('ar'),
    Locale('hi'),
    Locale('id'),
    Locale('bn'),
    Locale('ur'),
    Locale('vi'),
    Locale('tr'),
    Locale('ko'),
    Locale('th'),
    Locale('pl'),
    Locale('uk'),
    Locale('nl'),
  ];

  Locale? _currentLocale;

  @override
  void initState() {
    super.initState();
    _loadSavedLocale();
    _listenToLocaleChanges();
  }

  Future<void> _loadSavedLocale() async {
    try {
      final settings = await settingsRepository.getSettings();
      final languageUi = settings['language_ui'] as String?;
      if (languageUi != null && mounted) {
        final locale = _languageToLocale(languageUi);
        setState(() => _currentLocale = locale);
      }
    } catch (e) {
      debugPrint('Failed to load saved locale: $e');
    }
  }

  void _listenToLocaleChanges() {
    settingsRepository.getSettingsStream().listen((settings) {
      final languageUi = settings['language_ui'] as String?;
      if (languageUi != null && mounted) {
        final locale = _languageToLocale(languageUi);
        if (_currentLocale != locale) {
          setState(() => _currentLocale = locale);
        }
      }
    });
  }

  Locale _languageToLocale(String language) {
    switch (language) {
      case 'Spanish': return const Locale('es');
      case 'French': return const Locale('fr');
      case 'German': return const Locale('de');
      case 'Italian': return const Locale('it');
      case 'Portuguese': return const Locale('pt');
      case 'Russian': return const Locale('ru');
      case 'Japanese': return const Locale('ja');
      case 'Chinese': return const Locale('zh');
      case 'Arabic': return const Locale('ar');
      case 'Hindi': return const Locale('hi');
      case 'Indonesian': return const Locale('id');
      case 'Bengali': return const Locale('bn');
      case 'Urdu': return const Locale('ur');
      case 'Vietnamese': return const Locale('vi');
      case 'Turkish': return const Locale('tr');
      case 'Korean': return const Locale('ko');
      case 'Thai': return const Locale('th');
      case 'Polish': return const Locale('pl');
      case 'Ukrainian': return const Locale('uk');
      case 'Dutch': return const Locale('nl');
      case 'Persian': return const Locale('fa');
      case 'Punjabi': return const Locale('pa');
      case 'Tamil': return const Locale('ta');
      case 'Telugu': return const Locale('te');
      case 'Swahili': return const Locale('sw');
      case 'Malay': return const Locale('ms');
      case 'Romanian': return const Locale('ro');
      case 'Greek': return const Locale('el');
      case 'Hungarian': return const Locale('hu');
      case 'Czech': return const Locale('cs');
      case 'Swedish': return const Locale('sv');
      case 'Hebrew': return const Locale('he');
      case 'Norwegian': return const Locale('no');
      case 'Danish': return const Locale('da');
      case 'Finnish': return const Locale('fi');
      default: return const Locale('en');
    }
  }

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
      supportedLocales: _supportedLocales,
      locale: _currentLocale,
      theme: base.copyWith(
        scaffoldBackgroundColor: T.bg0,
        textTheme: GoogleFonts.poppinsTextTheme(
          base.textTheme,
        ).apply(bodyColor: T.textHi, displayColor: T.textHi),
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: <TargetPlatform, PageTransitionsBuilder>{
            TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
            TargetPlatform.iOS: FadeUpwardsPageTransitionsBuilder(),
            TargetPlatform.linux: FadeUpwardsPageTransitionsBuilder(),
            TargetPlatform.macOS: FadeUpwardsPageTransitionsBuilder(),
            TargetPlatform.windows: FadeUpwardsPageTransitionsBuilder(),
            TargetPlatform.fuchsia: FadeUpwardsPageTransitionsBuilder(),
          },
        ),
      ),
      builder: (context, child) {
        if (child == null) return const SizedBox.shrink();
        final media = MediaQuery.of(context);
        final scale = _uiScaleFor(media);
        if (scale == 1.0) {
          return child;
        }

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
