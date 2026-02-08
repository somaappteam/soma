import 'package:flutter/material.dart';
import 'package:soma/l10n/gen/app_localizations.dart';
import '../../core/widgets/glass.dart';
import '../../features/info/about_screen.dart';
import '../../data/settings_repository.dart';
import '../../data/auth_repository.dart';
// Note: EditProfileScreen, PrivacySettingsScreen, SecuritySettingsScreen are needed
// Assuming imports work, if not I'll fix them.
import 'edit_profile_screen.dart';
import 'privacy_settings_screen.dart';
import 'security_settings_screen.dart';
import '../../data/profile_store.dart';
import '../auth/welcome_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late Stream<Map<String, dynamic>> _settingsStream;
  bool _guestShowTranslation = true;
  bool _guestShowReading = true;
  bool _guestMusic = true;
  bool _guestSfx = true;
  bool _guestHaptics = true;
  bool _guestNotifications = true;
  String _guestThemeMode = "System";
  String _guestLanguageUi = "English";
  int _guestTimerSeconds = 15;
  String _guestDifficulty = "Adaptive";
  String _guestDailyReminder = "20:00";

  @override
  void initState() {
    super.initState();
    _settingsStream = settingsRepository.getSettingsStream();
  }

  Future<void> _pickTimerSeconds({required int current, required ValueChanged<int> onSelected}) async {
    final options = [10, 15, 20, 25, 30];
    final result = await showModalBottomSheet<int>(
      context: context,
      backgroundColor: const Color(0xFF1A1630),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) => _BottomSheetList<int>(
        title: AppLocalizations.of(context).settingsDefaultTimerPerQuestion,
        options: options,
        current: current,
        labelBuilder: (value) => "${value}s",
      ),
    );
    if (result != null) onSelected(result);
  }

  Future<void> _pickDifficulty({required String current, required ValueChanged<String> onSelected}) async {
    final options = <_BottomSheetOption<String>>[
      const _BottomSheetOption(value: "Adaptive", label: "Adaptive"),
      const _BottomSheetOption(value: "Easy", label: "Easy"),
      const _BottomSheetOption(value: "Medium", label: "Medium"),
      const _BottomSheetOption(value: "Hard", label: "Hard"),
    ];
    final result = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: const Color(0xFF1A1630),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) => _BottomSheetList<String>(
        title: AppLocalizations.of(context).settingsMatchDifficulty,
        options: options.map((o) => o.value).toList(),
        current: current,
        labelBuilder: (value) => options.firstWhere((o) => o.value == value).label,
      ),
    );
    if (result != null) onSelected(result);
  }

  Future<void> _pickDailyReminder({required String current, required ValueChanged<String> onSelected}) async {
    final options = ["08:00", "12:00", "17:00", "20:00", "22:00"];
    final result = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: const Color(0xFF1A1630),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) => _BottomSheetList<String>(
        title: AppLocalizations.of(context).settingsDailyReminder,
        options: options,
        current: current,
        labelBuilder: _formatTime,
      ),
    );
    if (result != null) onSelected(result);
  }

  void _showSupportSheet() {
    final l10n = AppLocalizations.of(context);
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: const Color(0xFF1A1630),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.settingsSupport,
              style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 10),
            Text(
              "Reach us any time for help, feedback, or account support.",
              style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 14),
            Text(
              "support@soma.app",
              style: const TextStyle(color: Color(0xFF2AFADF), fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => Navigator.pop(ctx),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  side: BorderSide(color: Colors.white.withValues(alpha: 0.4)),
                ),
                child: const Text("Close"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(String value) {
    final parts = value.split(':');
    if (parts.length != 2) return value;
    final hour = int.tryParse(parts[0]) ?? 0;
    final minute = parts[1];
    final period = hour >= 12 ? "PM" : "AM";
    final normalized = hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour);
    return "$normalized:$minute $period";
  }

  Widget _buildGuestSettings(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final themeItems = <_DropdownItem>[
      _DropdownItem('System', l10n.themeSystem),
      _DropdownItem('Dark', l10n.themeDark),
      _DropdownItem('Light', l10n.themeLight),
    ];
    final languageItems = <_DropdownItem>[
      _DropdownItem('English', l10n.languageEnglish),
      _DropdownItem('Spanish', l10n.languageSpanish),
      _DropdownItem('French', l10n.languageFrench),
      _DropdownItem('German', l10n.languageGerman),
      _DropdownItem('Italian', l10n.languageItalian),
      _DropdownItem('Portuguese', l10n.languagePortuguese),
      _DropdownItem('Russian', l10n.languageRussian),
      _DropdownItem('Japanese', l10n.languageJapanese),
      _DropdownItem('Chinese', l10n.languageChinese),
      _DropdownItem('Arabic', l10n.languageArabic),
      _DropdownItem('Hindi', l10n.languageHindi),
      _DropdownItem('Indonesian', l10n.languageIndonesian),
      _DropdownItem('Bengali', l10n.languageBengali),
      _DropdownItem('Urdu', l10n.languageUrdu),
      _DropdownItem('Vietnamese', l10n.languageVietnamese),
      _DropdownItem('Turkish', l10n.languageTurkish),
      _DropdownItem('Korean', l10n.languageKorean),
      _DropdownItem('Thai', l10n.languageThai),
      _DropdownItem('Polish', l10n.languagePolish),
      _DropdownItem('Ukrainian', l10n.languageUkrainian),
      _DropdownItem('Dutch', l10n.languageDutch),
      _DropdownItem('Persian', l10n.languagePersian),
      _DropdownItem('Punjabi', l10n.languagePunjabi),
      _DropdownItem('Tamil', l10n.languageTamil),
      _DropdownItem('Telugu', l10n.languageTelugu),
      _DropdownItem('Swahili', l10n.languageSwahili),
      _DropdownItem('Malay', l10n.languageMalay),
      _DropdownItem('Romanian', l10n.languageRomanian),
      _DropdownItem('Greek', l10n.languageGreek),
      _DropdownItem('Hungarian', l10n.languageHungarian),
      _DropdownItem('Czech', l10n.languageCzech),
      _DropdownItem('Swedish', l10n.languageSwedish),
      _DropdownItem('Hebrew', l10n.languageHebrew),
      _DropdownItem('Norwegian', l10n.languageNorwegian),
      _DropdownItem('Danish', l10n.languageDanish),
      _DropdownItem('Finnish', l10n.languageFinnish),
    ];
    final guestThemeValue = themeItems.any((item) => item.value == _guestThemeMode)
        ? _guestThemeMode
        : themeItems.first.value;
    final guestLanguageValue = languageItems.any((item) => item.value == _guestLanguageUi)
        ? _guestLanguageUi
        : languageItems.first.value;
    return ListView(
      physics: const BouncingScrollPhysics(),
      children: [
        _SectionTitle(l10n.settingsSectionGameplay),
        const SizedBox(height: 10),
        Glass(
          radius: BorderRadius.circular(22),
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              _ToggleRow(
                icon: Icons.translate_rounded,
                label: l10n.settingsShowTranslationLine,
                value: _guestShowTranslation,
                onChanged: (v) => setState(() => _guestShowTranslation = v),
              ),
              _DividerSoft(),
              _ToggleRow(
                icon: Icons.text_fields_rounded,
                label: l10n.settingsShowReadingLine,
                value: _guestShowReading,
                onChanged: (v) => setState(() => _guestShowReading = v),
              ),
              _DividerSoft(),
              _NavRow(
                icon: Icons.timer_rounded,
                label: l10n.settingsDefaultTimerPerQuestion,
                trailingText: "${_guestTimerSeconds}s",
                onTap: () => _pickTimerSeconds(
                  current: _guestTimerSeconds,
                  onSelected: (value) => setState(() => _guestTimerSeconds = value),
                ),
              ),
              _DividerSoft(),
              _NavRow(
                icon: Icons.bar_chart_rounded,
                label: l10n.settingsMatchDifficulty,
                trailingText: _guestDifficulty == "Adaptive"
                    ? l10n.settingsMatchDifficultyAdaptive
                    : _guestDifficulty,
                onTap: () => _pickDifficulty(
                  current: _guestDifficulty,
                  onSelected: (value) => setState(() => _guestDifficulty = value),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        _SectionTitle(l10n.settingsSectionSoundFeel),
        const SizedBox(height: 10),
        Glass(
          radius: BorderRadius.circular(22),
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              _ToggleRow(
                icon: Icons.music_note_rounded,
                label: l10n.settingsMusic,
                value: _guestMusic,
                onChanged: (v) => setState(() => _guestMusic = v),
              ),
              _DividerSoft(),
              _ToggleRow(
                icon: Icons.volume_up_rounded,
                label: l10n.settingsSoundEffects,
                value: _guestSfx,
                onChanged: (v) => setState(() => _guestSfx = v),
              ),
              _DividerSoft(),
              _ToggleRow(
                icon: Icons.vibration_rounded,
                label: l10n.settingsHaptics,
                value: _guestHaptics,
                onChanged: (v) => setState(() => _guestHaptics = v),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        _SectionTitle(l10n.settingsSectionNotifications),
        const SizedBox(height: 10),
        Glass(
          radius: BorderRadius.circular(22),
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              _ToggleRow(
                icon: Icons.notifications_rounded,
                label: l10n.settingsPushNotifications,
                value: _guestNotifications,
                onChanged: (v) => setState(() => _guestNotifications = v),
              ),
              _DividerSoft(),
              _NavRow(
                icon: Icons.schedule_rounded,
                label: l10n.settingsDailyReminder,
                trailingText: _formatTime(_guestDailyReminder),
                onTap: () => _pickDailyReminder(
                  current: _guestDailyReminder,
                  onSelected: (value) => setState(() => _guestDailyReminder = value),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        _SectionTitle(l10n.settingsSectionAppearance),
        const SizedBox(height: 10),
        Glass(
          radius: BorderRadius.circular(22),
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              _DropdownRow(
                icon: Icons.dark_mode_rounded,
                label: l10n.settingsTheme,
                value: guestThemeValue,
                items: themeItems,
                onChanged: (v) => setState(() => _guestThemeMode = v),
              ),
              _DividerSoft(),
              _DropdownRow(
                icon: Icons.language_rounded,
                label: l10n.settingsUiLanguage,
                value: guestLanguageValue,
                items: languageItems,
                onChanged: (v) => setState(() => _guestLanguageUi = v),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        _SectionTitle(l10n.settingsSectionAbout),
        const SizedBox(height: 10),
        Glass(
          radius: BorderRadius.circular(22),
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              _NavRow(
                icon: Icons.info_rounded,
                label: l10n.settingsVersion,
                trailingText: "1.0.0",
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AboutScreen())),
              ),
              _DividerSoft(),
              _NavRow(
                icon: Icons.description_rounded,
                label: l10n.settingsTermsPrivacy,
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AboutScreen())),
              ),
              _DividerSoft(),
              _NavRow(
                icon: Icons.support_agent_rounded,
                label: l10n.settingsSupport,
                onTap: _showSupportSheet,
              ),
            ],
          ),
        ),
        const SizedBox(height: 28),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isGuest = authRepository.currentUser == null;
    final themeItems = <_DropdownItem>[
      _DropdownItem('System', l10n.themeSystem),
      _DropdownItem('Dark', l10n.themeDark),
      _DropdownItem('Light', l10n.themeLight),
    ];
    final languageItems = <_DropdownItem>[
      _DropdownItem('English', l10n.languageEnglish),
      _DropdownItem('Spanish', l10n.languageSpanish),
      _DropdownItem('French', l10n.languageFrench),
      _DropdownItem('German', l10n.languageGerman),
      _DropdownItem('Italian', l10n.languageItalian),
      _DropdownItem('Portuguese', l10n.languagePortuguese),
      _DropdownItem('Russian', l10n.languageRussian),
      _DropdownItem('Japanese', l10n.languageJapanese),
      _DropdownItem('Chinese', l10n.languageChinese),
      _DropdownItem('Arabic', l10n.languageArabic),
      _DropdownItem('Hindi', l10n.languageHindi),
      _DropdownItem('Indonesian', l10n.languageIndonesian),
      _DropdownItem('Bengali', l10n.languageBengali),
      _DropdownItem('Urdu', l10n.languageUrdu),
      _DropdownItem('Vietnamese', l10n.languageVietnamese),
      _DropdownItem('Turkish', l10n.languageTurkish),
      _DropdownItem('Korean', l10n.languageKorean),
      _DropdownItem('Thai', l10n.languageThai),
      _DropdownItem('Polish', l10n.languagePolish),
      _DropdownItem('Ukrainian', l10n.languageUkrainian),
      _DropdownItem('Dutch', l10n.languageDutch),
      _DropdownItem('Persian', l10n.languagePersian),
      _DropdownItem('Punjabi', l10n.languagePunjabi),
      _DropdownItem('Tamil', l10n.languageTamil),
      _DropdownItem('Telugu', l10n.languageTelugu),
      _DropdownItem('Swahili', l10n.languageSwahili),
      _DropdownItem('Malay', l10n.languageMalay),
      _DropdownItem('Romanian', l10n.languageRomanian),
      _DropdownItem('Greek', l10n.languageGreek),
      _DropdownItem('Hungarian', l10n.languageHungarian),
      _DropdownItem('Czech', l10n.languageCzech),
      _DropdownItem('Swedish', l10n.languageSwedish),
      _DropdownItem('Hebrew', l10n.languageHebrew),
      _DropdownItem('Norwegian', l10n.languageNorwegian),
      _DropdownItem('Danish', l10n.languageDanish),
      _DropdownItem('Finnish', l10n.languageFinnish),
    ];
    return Scaffold(
      body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 18),
            child: Column(
              children: [
                _TopBar(
                  title: l10n.settingsTitle,
                  onBack: () => Navigator.pop(context),
                ),
                const SizedBox(height: 14),

                Expanded(
                  child: isGuest ? _buildGuestSettings(context) : StreamBuilder<Map<String, dynamic>>(
                    stream: _settingsStream,
                    builder: (context, snapshot) {
                      final data = snapshot.data ?? {};
                       
                      final showTranslation = data['show_translation'] ?? true;
                      final showReading = data['show_reading'] ?? true;
                       
                      final music = data['bg_music'] ?? true;
                      final sfx = data['sfx_enabled'] ?? true;
                      final haptics = data['haptics_enabled'] ?? true;
                       
                      final notifications = data['push_notifications'] ?? true;
                      final timerSeconds = (data['default_timer_s'] as num?)?.toInt() ?? 15;
                      final difficulty = data['match_difficulty']?.toString() ?? "Adaptive";
                      final dailyReminder = data['daily_reminder']?.toString() ?? "20:00";
                       
                      final themeMode = data['theme_mode'] ?? "System";
                      final languageUi = data['language_ui'] ?? "English";
                      final themeModeValue = themeItems.any((item) => item.value == themeMode)
                          ? themeMode
                          : themeItems.first.value;
                      final languageUiValue = languageItems.any((item) => item.value == languageUi)
                          ? languageUi
                          : languageItems.first.value;

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      return ListView(
                        physics: const BouncingScrollPhysics(),
                        children: [
                          _SectionTitle(l10n.settingsSectionAccount),
                          const SizedBox(height: 10),
                          Glass(
                            radius: BorderRadius.circular(22),
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              children: [
                                _NavRow(
                                  icon: Icons.person_rounded,
                                  label: l10n.settingsEditProfile,
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (_) => const EditProfileScreen()),
                                    );
                                  },
                                ),
                                _DividerSoft(),
                                _NavRow(
                                  icon: Icons.lock_rounded,
                                  label: l10n.settingsPrivacy,
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (_) => const PrivacySettingsScreen()),
                                    );
                                  },
                                ),
                                _DividerSoft(),
                                _NavRow(
                                  icon: Icons.security_rounded,
                                  label: l10n.settingsSecurity,
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (_) => const SecuritySettingsScreen()),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 16),
                          _SectionTitle(l10n.settingsSectionGameplay),
                          const SizedBox(height: 10),
                          Glass(
                            radius: BorderRadius.circular(22),
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              children: [
                                _ToggleRow(
                                  icon: Icons.translate_rounded,
                                  label: l10n.settingsShowTranslationLine,
                                  value: showTranslation,
                                  onChanged: (v) => settingsRepository.updateSetting('show_translation', v),
                                ),
                                _DividerSoft(),
                                _ToggleRow(
                                  icon: Icons.text_fields_rounded,
                                  label: l10n.settingsShowReadingLine,
                                  value: showReading,
                                  onChanged: (v) => settingsRepository.updateSetting('show_reading', v),
                                ),
                                _DividerSoft(),
                                _NavRow(
                                  icon: Icons.timer_rounded,
                                  label: l10n.settingsDefaultTimerPerQuestion,
                                  trailingText: "${timerSeconds}s",
                                  onTap: () => _pickTimerSeconds(
                                    current: timerSeconds,
                                    onSelected: (value) => settingsRepository.updateSetting('default_timer_s', value),
                                  ),
                                ),
                                _DividerSoft(),
                                _NavRow(
                                  icon: Icons.bar_chart_rounded,
                                  label: l10n.settingsMatchDifficulty,
                                  trailingText: difficulty == "Adaptive"
                                      ? l10n.settingsMatchDifficultyAdaptive
                                      : difficulty,
                                  onTap: () => _pickDifficulty(
                                    current: difficulty,
                                    onSelected: (value) => settingsRepository.updateSetting('match_difficulty', value),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 16),
                          _SectionTitle(l10n.settingsSectionSoundFeel),
                          const SizedBox(height: 10),
                          Glass(
                            radius: BorderRadius.circular(22),
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              children: [
                                _ToggleRow(
                                  icon: Icons.music_note_rounded,
                                  label: l10n.settingsMusic,
                                  value: music,
                                  onChanged: (v) => settingsRepository.updateSetting('bg_music', v),
                                ),
                                _DividerSoft(),
                                _ToggleRow(
                                  icon: Icons.volume_up_rounded,
                                  label: l10n.settingsSoundEffects,
                                  value: sfx,
                                  onChanged: (v) => settingsRepository.updateSetting('sfx_enabled', v),
                                ),
                                _DividerSoft(),
                                _ToggleRow(
                                  icon: Icons.vibration_rounded,
                                  label: l10n.settingsHaptics,
                                  value: haptics,
                                  onChanged: (v) => settingsRepository.updateSetting('haptics_enabled', v),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 16),
                          _SectionTitle(l10n.settingsSectionNotifications),
                          const SizedBox(height: 10),
                          Glass(
                            radius: BorderRadius.circular(22),
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              children: [
                                _ToggleRow(
                                  icon: Icons.notifications_rounded,
                                  label: l10n.settingsPushNotifications,
                                  value: notifications,
                                  onChanged: (v) => settingsRepository.updateSetting('push_notifications', v),
                                ),
                                _DividerSoft(),
                                _NavRow(
                                  icon: Icons.schedule_rounded,
                                  label: l10n.settingsDailyReminder,
                                  trailingText: _formatTime(dailyReminder),
                                  onTap: () => _pickDailyReminder(
                                    current: dailyReminder,
                                    onSelected: (value) => settingsRepository.updateSetting('daily_reminder', value),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 16),
                          _SectionTitle(l10n.settingsSectionAppearance),
                          const SizedBox(height: 10),
                          Glass(
                            radius: BorderRadius.circular(22),
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              children: [
                                _DropdownRow(
                                  icon: Icons.dark_mode_rounded,
                                  label: l10n.settingsTheme,
                                  value: themeModeValue,
                                  items: themeItems,
                                  onChanged: (v) => settingsRepository.updateSetting('theme_mode', v),
                                ),
                                _DividerSoft(),
                                _DropdownRow(
                                  icon: Icons.language_rounded,
                                  label: l10n.settingsUiLanguage,
                                  value: languageUiValue,
                                  items: languageItems,
                                  onChanged: (v) => settingsRepository.updateSetting('language_ui', v),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 16),
                          _SectionTitle(l10n.settingsSectionAbout),
                          const SizedBox(height: 10),
                          Glass(
                            radius: BorderRadius.circular(22),
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              children: [
                                _NavRow(
                                    icon: Icons.info_rounded,
                                    label: l10n.settingsVersion,
                                    trailingText: "1.0.0",
                                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AboutScreen())),
                                ),
                                _DividerSoft(),
                                _NavRow(
                                    icon: Icons.description_rounded,
                                    label: l10n.settingsTermsPrivacy,
                                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AboutScreen())),
                                ),
                                _DividerSoft(),
                                _NavRow(
                                  icon: Icons.support_agent_rounded,
                                  label: l10n.settingsSupport,
                                  onTap: _showSupportSheet,
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 16),
                          Glass(
                            radius: BorderRadius.circular(22),
                            padding: const EdgeInsets.all(12),
                            child: _DangerRow(
                              icon: Icons.logout_rounded,
                              label: l10n.settingsLogout,
                              onTap: () async {
                                await authRepository.signOut();
                                profileStore.reset();
                                if (!context.mounted) return;
                                Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(builder: (_) => const WelcomeScreen()),
                                  (route) => false,
                                );
                              },
                            ),
                          ),

                          const SizedBox(height: 28),
                        ],
                      );
                    }
                  ),
                ),
              ],
            ),
          ),
        ),
      );
  }
}

// ------------------- UI helpers -------------------

class _TopBar extends StatelessWidget {
  final String title;
  final VoidCallback onBack;
  const _TopBar({required this.title, required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: onBack,
          child: Glass(
            radius: BorderRadius.circular(16),
            padding: const EdgeInsets.all(10),
            child: Icon(Icons.arrow_back_rounded, color: Colors.white.withValues(alpha: 0.9)),
          ),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: Colors.white.withValues(alpha: 0.85),
        fontSize: 14,
        fontWeight: FontWeight.w800,
        letterSpacing: 0.2,
      ),
    );
  }
}

class _DividerSoft extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Divider(height: 1, thickness: 1, color: Colors.white.withValues(alpha: 0.10));
  }
}

class _NavRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? trailingText;
  final VoidCallback onTap;

  const _NavRow({
    required this.icon,
    required this.label,
    required this.onTap,
    this.trailingText,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
        child: Row(
          children: [
            Icon(icon, color: Colors.white.withValues(alpha: 0.9)),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14.5,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            if (trailingText != null)
              Text(
                trailingText!,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.65),
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
            const SizedBox(width: 6),
            Icon(Icons.chevron_right_rounded, color: Colors.white.withValues(alpha: 0.5)),
          ],
        ),
      ),
    );
  }
}

class _ToggleRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _ToggleRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: Colors.white.withValues(alpha: 0.9)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14.5,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: const Color(0xFF2AFADF),
          ),
        ],
      ),
    );
  }
}

class _DropdownRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final List<_DropdownItem> items;
  final ValueChanged<String> onChanged;

  const _DropdownRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      child: Row(
        children: [
          Icon(icon, color: Colors.white.withValues(alpha: 0.9)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14.5,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          DropdownButton<String>(
            value: value,
            dropdownColor: const Color(0xFF1A1630),
            underline: const SizedBox.shrink(),
            iconEnabledColor: Colors.white.withValues(alpha: 0.8),
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
            items: items
                .map((e) => DropdownMenuItem<String>(
                      value: e.value,
                      child: Text(e.label),
                    ))
                .toList(),
            onChanged: (v) {
              if (v != null) onChanged(v);
            },
          ),
        ],
      ),
    );
  }
}

class _DropdownItem {
  final String value;
  final String label;
  const _DropdownItem(this.value, this.label);
}

class _BottomSheetOption<T> {
  final T value;
  final String label;
  const _BottomSheetOption({required this.value, required this.label});
}

class _BottomSheetList<T> extends StatelessWidget {
  final String title;
  final List<T> options;
  final T current;
  final String Function(T value) labelBuilder;

  const _BottomSheetList({
    required this.title,
    required this.options,
    required this.current,
    required this.labelBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 18),
            ),
            const SizedBox(height: 12),
            ...options.map((value) {
              final selected = value == current;
              return ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(
                  labelBuilder(value),
                  style: TextStyle(
                    color: selected ? const Color(0xFF2AFADF) : Colors.white,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                trailing: selected
                    ? const Icon(Icons.check_rounded, color: Color(0xFF2AFADF))
                    : const SizedBox.shrink(),
                onTap: () => Navigator.pop(context, value),
              );
            }),
          ],
        ),
      ),
    );
  }
}

class _DangerRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _DangerRow({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
        child: Row(
          children: [
            Icon(icon, color: Colors.redAccent.withValues(alpha: 0.95)),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  color: Colors.redAccent,
                  fontSize: 14.5,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            Icon(Icons.chevron_right_rounded, color: Colors.white.withValues(alpha: 0.5)),
          ],
        ),
      ),
    );
  }
}
