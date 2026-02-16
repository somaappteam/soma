import '../core/i18n/ui_language.dart';
import '../data/soma_plus_repository.dart';

class AppSettings {
  final bool showTranslation;
  final bool showReading;
  final bool bgMusic;
  final bool sfxEnabled;
  final bool hapticsEnabled;
  final bool pushNotifications;
  final int defaultTimerS;
  final String matchDifficulty;
  final String dailyReminder;
  final String themeMode;
  final String languageUi;
  final bool plusEnabled;
  final String plusPlan;
  final Map<String, dynamic> dmActiveCall;

  const AppSettings({
    required this.showTranslation,
    required this.showReading,
    required this.bgMusic,
    required this.sfxEnabled,
    required this.hapticsEnabled,
    required this.pushNotifications,
    required this.defaultTimerS,
    required this.matchDifficulty,
    required this.dailyReminder,
    required this.themeMode,
    required this.languageUi,
    required this.plusEnabled,
    required this.plusPlan,
    required this.dmActiveCall,
  });

  factory AppSettings.defaults() => const AppSettings(
        showTranslation: true,
        showReading: true,
        bgMusic: true,
        sfxEnabled: true,
        hapticsEnabled: true,
        pushNotifications: true,
        defaultTimerS: 15,
        matchDifficulty: 'Adaptive',
        dailyReminder: '20:00',
        themeMode: 'System',
        languageUi: 'en',
        plusEnabled: false,
        plusPlan: 'free',
        dmActiveCall: {'active': false},
      );

  factory AppSettings.fromMap(Map<String, dynamic>? source) {
    final merged = Map<String, dynamic>.from(AppSettings.defaults().toMap())
      ..addAll(source ?? const {});

    final normalizedLanguage = normalizeUiLanguageCode(
      merged['language_ui']?.toString(),
    );
    final normalizedPlan = SomaPlusRepository.serializeTier(
      SomaPlusRepository.parseTier(merged['plus_plan']?.toString()),
    );

    return AppSettings(
      showTranslation: merged['show_translation'] == true,
      showReading: merged['show_reading'] == true,
      bgMusic: merged['bg_music'] == true,
      sfxEnabled: merged['sfx_enabled'] == true,
      hapticsEnabled: merged['haptics_enabled'] == true,
      pushNotifications: merged['push_notifications'] == true,
      defaultTimerS: (merged['default_timer_s'] as num?)?.toInt() ?? 15,
      matchDifficulty: merged['match_difficulty']?.toString() ?? 'Adaptive',
      dailyReminder: merged['daily_reminder']?.toString() ?? '20:00',
      themeMode: merged['theme_mode']?.toString() ?? 'System',
      languageUi: normalizedLanguage,
      plusEnabled: merged['plus_enabled'] == true,
      plusPlan: normalizedPlan,
      dmActiveCall: merged['dm_active_call'] is Map
          ? Map<String, dynamic>.from(merged['dm_active_call'] as Map)
          : {'active': false},
    );
  }

  Map<String, dynamic> toMap() => {
        'show_translation': showTranslation,
        'show_reading': showReading,
        'bg_music': bgMusic,
        'sfx_enabled': sfxEnabled,
        'haptics_enabled': hapticsEnabled,
        'push_notifications': pushNotifications,
        'default_timer_s': defaultTimerS,
        'match_difficulty': matchDifficulty,
        'daily_reminder': dailyReminder,
        'theme_mode': themeMode,
        'language_ui': languageUi,
        'plus_enabled': plusEnabled,
        'plus_plan': plusPlan,
        'dm_active_call': dmActiveCall,
        'exchange_active': false,
        'exchange_filter_online_only': true,
        'exchange_filter_strict_direction': true,
        'exchange_filter_level': 'all',
      };
}
