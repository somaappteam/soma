import 'package:flutter/material.dart';
import 'package:soma/l10n/gen/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
// import 'package:flutter_driver/driver_extension.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/splash_screen.dart';


import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'dart:ffi';
import 'dart:io';
import 'data/content_sync_service.dart';
import 'data/settings_repository.dart';
import 'core/services/session_tracker.dart';
import 'core/services/theme_mode_controller.dart';
import 'core/services/haptics_service.dart';
import 'core/services/sfx_service.dart';
import 'core/widgets/app_lock_gate.dart';
import 'package:flutter/foundation.dart';

enum SyncStatus { idle, syncing, error }

final syncStatusNotifier = ValueNotifier<SyncStatus>(SyncStatus.idle);
final syncMessageNotifier = ValueNotifier<String?>(null);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (!kIsWeb && Platform.isWindows) {
    _fixSqliteDll();
  }

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

  await themeModeController.load();
  await hapticsService.init();
  await sfxService.init();
  await settingsRepository.init();
  
  _runContentSync();
  runApp(const App());
}

Future<void> _runContentSync() async {
  await Future.delayed(const Duration(seconds: 1));
  syncStatusNotifier.value = SyncStatus.syncing;
  syncMessageNotifier.value = null;
  try {
    await contentSyncService.syncEverything();
    syncStatusNotifier.value = SyncStatus.idle;
  } catch (e) {
    debugPrint("Sync failed: $e");
    syncStatusNotifier.value = SyncStatus.error;
    syncMessageNotifier.value = "Sync failed. Check your connection.";
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
    Locale('fa'),
    Locale('pa'),
    Locale('ta'),
    Locale('te'),
    Locale('sw'),
    Locale('ms'),
    Locale('ro'),
    Locale('el'),
    Locale('hu'),
    Locale('cs'),
    Locale('sv'),
    Locale('he'),
    Locale('no'),
    Locale('da'),
    Locale('fi'),
  ];

  Locale? _currentLocale;

  @override
  void initState() {
    super.initState();
    _loadSavedLocale();
    _listenToSettingsChanges();
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

  void _listenToSettingsChanges() {
    settingsRepository.getSettingsStream().listen((settings) {
      final languageUi = settings['language_ui'] as String?;
      final themeMode = settings['theme_mode'] as String?;
      if (languageUi != null && mounted) {
        final locale = _languageToLocale(languageUi);
        if (_currentLocale != locale) {
          setState(() => _currentLocale = locale);
        }
      }
      if (themeMode != null) {
        themeModeController.setModeFromSetting(themeMode, persist: false);
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

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: themeModeController,
      builder: (context, _) {
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
          theme: AppTheme.light(),
          darkTheme: AppTheme.dark(),
          themeMode: themeModeController.mode,
          themeAnimationDuration: const Duration(milliseconds: 180),
          themeAnimationCurve: Curves.easeOutCubic,
          builder: (context, child) {
            if (child == null) return const SizedBox.shrink();
            final background =
                Theme.of(context).extension<AppBackgroundTheme>()?.gradient;
            final media = MediaQuery.of(context);
            final clampedMedia = media.copyWith(
              textScaler: media.textScaler.clamp(
                minScaleFactor: 0.9,
                maxScaleFactor: 1.15,
              ),
            );

            final decoratedChild = MediaQuery(
              data: clampedMedia,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final width = constraints.maxWidth;
                  final maxContentWidth =
                      width >= 1700 ? 1500.0 : (width >= 1400 ? 1320.0 : width);
                  final sidePadding =
                      width >= 1200 ? 20.0 : (width >= 900 ? 12.0 : 0.0);

                  return Align(
                    alignment: Alignment.topCenter,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: maxContentWidth),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: sidePadding),
                        child: child,
                      ),
                    ),
                  );
                },
              ),
            );

            final content = DecoratedBox(
              decoration: BoxDecoration(gradient: background),
              child: decoratedChild,
            );

            return AppLockGate(
              child: ValueListenableBuilder<SyncStatus>(
                valueListenable: syncStatusNotifier,
                builder: (context, status, _) {
                  return Stack(
                    children: [
                      content,
                      if (status != SyncStatus.idle)
                        SafeArea(
                          child: Align(
                            alignment: Alignment.topCenter,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              child: _SyncStatusBanner(status: status),
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),
            );
          },
          home: const SplashScreen(),
        );
      },
    );
  }
}

class _SyncStatusBanner extends StatelessWidget {
  final SyncStatus status;
  const _SyncStatusBanner({required this.status});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final isError = status == SyncStatus.error;
    final icon = isError ? Icons.wifi_off_rounded : Icons.sync_rounded;
    final label = isError ? "Sync failed" : "Syncing…";

    return ValueListenableBuilder<String?>(
      valueListenable: syncMessageNotifier,
      builder: (context, message, _) {
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          child: Container(
            key: ValueKey(status),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: isError
                  ? scheme.error.withValues(alpha: 0.2)
                  : scheme.surfaceContainerHighest.withValues(alpha: 0.85),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: scheme.onSurface.withValues(alpha: 0.15)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: 18, color: scheme.onSurface.withValues(alpha: 0.9)),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    message ?? label,
                    style: textTheme.bodySmall?.copyWith(
                      color: scheme.onSurface.withValues(alpha: 0.9),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

void _fixSqliteDll() {
  try {
    final scriptDir = File(Platform.resolvedExecutable).parent.path;
    final src = File('$scriptDir\\sqlite3.dll');
    final dest = File('$scriptDir\\sqlite3.x64.windows.dll');
    if (src.existsSync() && !dest.existsSync()) {
      src.copySync(dest.path);
      debugPrint('SQLite DLL fixed: copied to ${dest.path}');
    }
  } catch (e) {
    debugPrint('SQLite DLL fix failed: $e');
  }
}
