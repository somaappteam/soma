import 'package:flutter/material.dart';
import 'package:soma/l10n/gen/app_localizations.dart';
import '../../core/widgets/soma_background.dart';
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

  @override
  void initState() {
    super.initState();
    _settingsStream = settingsRepository.getSettingsStream();
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
      _DropdownItem('French', l10n.languageFrench),
      _DropdownItem('Spanish', l10n.languageSpanish),
      _DropdownItem('Portuguese', l10n.languagePortuguese),
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
                trailingText: "15s",
                onTap: () {},
              ),
              _DividerSoft(),
              _NavRow(
                icon: Icons.bar_chart_rounded,
                label: l10n.settingsMatchDifficulty,
                trailingText: l10n.settingsMatchDifficultyAdaptive,
                onTap: () {},
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
                trailingText: "8:00 PM",
                onTap: () {},
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
                onTap: () {},
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
      _DropdownItem('French', l10n.languageFrench),
      _DropdownItem('Spanish', l10n.languageSpanish),
      _DropdownItem('Portuguese', l10n.languagePortuguese),
    ];
    return Scaffold(
      body: SomaBackground(
        child: SafeArea(
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
                                  trailingText: "15s",
                                  onTap: () {},
                                ),
                                _DividerSoft(),
                                _NavRow(
                                  icon: Icons.bar_chart_rounded,
                                  label: l10n.settingsMatchDifficulty,
                                  trailingText: l10n.settingsMatchDifficultyAdaptive,
                                  onTap: () {},
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
                                  trailingText: "8:00 PM",
                                  onTap: () {},
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
                                  onTap: () {},
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
                                if (mounted) {
                                  Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(builder: (_) => const WelcomeScreen()),
                                    (route) => false,
                                  );
                                }
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
