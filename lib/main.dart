import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:soma/l10n/gen/app_localizations.dart';

import 'core/i18n/ui_language.dart';
import 'core/services/app_bootstrap.dart';
import 'core/services/sync_retry_policy.dart';
import 'core/services/theme_mode_controller.dart';
import 'core/theme/app_theme.dart';
import 'core/widgets/app_lock_gate.dart';
import 'data/app_analytics_repository.dart';
import 'data/content_sync_service.dart';
import 'data/offline_queue_repository.dart';
import 'data/settings_repository.dart';
import 'features/auth/splash_screen.dart';
import 'models/app_settings.dart';
import 'core/di/locator.dart';

enum SyncStatus { idle, syncing, error }

final syncStatusNotifier = ValueNotifier<SyncStatus>(SyncStatus.idle);
final syncMessageNotifier = ValueNotifier<String?>(null);
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  await SentryFlutter.init(
    (options) {
      // Pass --dart-define=SENTRY_DSN=https://... to enable in release.
      const dsn = String.fromEnvironment('SENTRY_DSN');
      const traceRate = double.fromEnvironment('SENTRY_TRACE_SAMPLE_RATE', defaultValue: 0.2);
      const profileRate = double.fromEnvironment('SENTRY_PROFILE_SAMPLE_RATE', defaultValue: 0.1);
      const enableInDebug = bool.fromEnvironment('SENTRY_ENABLE_IN_DEBUG', defaultValue: false);

      options.dsn = dsn.isEmpty ? '' : dsn;
      options.tracesSampleRate = traceRate.clamp(0, 1);
      options.profilesSampleRate = profileRate.clamp(0, 1);
      options.enableAppLifecycleBreadcrumbs = true;
      options.environment = const String.fromEnvironment('APP_ENV', defaultValue: 'development');
      options.debug = enableInDebug;
    },
    appRunner: () async {
      WidgetsFlutterBinding.ensureInitialized();
      setupLocator();
      const bootstrap = AppBootstrap();
      await bootstrap.initialize();

      // Start listening for connectivity changes to auto-drain the offline queue.
      offlineQueueRepository.startListening();

      unawaited(runContentSync());
      runApp(const App());
    },
  );
}

Future<void> runContentSync() async {
  syncStatusNotifier.value = SyncStatus.syncing;
  syncMessageNotifier.value = null;

  final retryPolicy = SyncRetryPolicy();
  final result = await retryPolicy.execute(
    runSync: contentSyncService.syncEverything,
    onRetryScheduled: (attempt, failedSteps) async {
      syncMessageNotifier.value =
          'Sync issue (${failedSteps.join(', ')}). Retrying ($attempt/${SyncRetryPolicy.maxAttempts})…';
      await appAnalyticsRepository.track('sync_retry_scheduled', metadata: {
        'attempt': attempt,
        'failed_steps': failedSteps,
      });
    },
  );

  if (result.success) {
    syncStatusNotifier.value = SyncStatus.idle;
    return;
  }

  final durations = result.stepDurationsMs.entries.map((e) => '${e.key}:${e.value}ms').join(' · ');
  syncStatusNotifier.value = SyncStatus.error;
  syncMessageNotifier.value = result.failedSteps.isEmpty
      ? 'Sync failed unexpectedly. Tap retry to try again.'
      : 'Sync failed: ${result.failedSteps.join(', ')}. $durations Tap retry to try again.';
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  final List<Locale> _supportedLocales =
      kSupportedUiLanguages.map((item) => Locale(item.code)).toList();

  Locale? _currentLocale;
  StreamSubscription<AppSettings>? _settingsSubscription;

  @override
  void initState() {
    super.initState();
    _loadSavedLocale();
    _listenToSettingsChanges();
    syncStatusNotifier.addListener(_handleSyncStatusChanged);
  }

  Future<void> _loadSavedLocale() async {
    try {
      final settings = await settingsRepository.getTypedSettings();
      if (mounted) {
        final locale = uiLanguageToLocale(settings.languageUi);
        setState(() => _currentLocale = locale);
      }
    } catch (e) {
      debugPrint('Failed to load saved locale: $e');
    }
  }

  void _listenToSettingsChanges() {
    _settingsSubscription?.cancel();
    _settingsSubscription =
        settingsRepository.getTypedSettingsStream().listen((settings) {
      if (mounted) {
        final locale = uiLanguageToLocale(settings.languageUi);
        if (_currentLocale != locale) {
          setState(() => _currentLocale = locale);
        }
      }
      themeModeController.setModeFromSetting(settings.themeMode, persist: false);
    });
  }

  void _handleSyncStatusChanged() {
    if (syncStatusNotifier.value != SyncStatus.error) return;

    final context = navigatorKey.currentContext;
    if (context == null) return;

    final messenger = ScaffoldMessenger.of(context);
    final message = syncMessageNotifier.value ?? 'Background sync failed. We will retry automatically.';

    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 4),
          action: SnackBarAction(
            label: 'Retry',
            onPressed: () => unawaited(runContentSync()),
          ),
        ),
      );
  }

  @override
  void dispose() {
    syncStatusNotifier.removeListener(_handleSyncStatusChanged);
    _settingsSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: themeModeController,
      builder: (context, _) {
        return MaterialApp(
          navigatorKey: navigatorKey,
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
                maxScaleFactor: 1.4,
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

            return AppLockGate(child: content);
          },
          home: const SplashScreen(),
        );
      },
    );
  }
}
