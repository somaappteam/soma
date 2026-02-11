import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:soma/l10n/gen/app_localizations.dart';
import 'sign_in_screen.dart';
import 'sign_up_screen.dart';
import '../home/app_shell.dart';
import '../../core/widgets/neon_button.dart';
import '../../core/widgets/glass.dart';
import '../../core/theme/tokens.dart';
import '../../data/profile_store.dart';
import '../../data/settings_repository.dart';
import '../../core/widgets/responsive.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  Future<void> _changeLanguage(String language) async {
    await settingsRepository.updateSetting('language_ui', language);
  }

  List<({String value, String label})> _languageOptions(AppLocalizations l10n) {
    return [
      (value: 'English', label: l10n.languageEnglish),
      (value: 'Spanish', label: l10n.languageSpanish),
      (value: 'French', label: l10n.languageFrench),
      (value: 'German', label: l10n.languageGerman),
      (value: 'Italian', label: l10n.languageItalian),
      (value: 'Portuguese', label: l10n.languagePortuguese),
      (value: 'Russian', label: l10n.languageRussian),
      (value: 'Japanese', label: l10n.languageJapanese),
      (value: 'Chinese', label: l10n.languageChinese),
      (value: 'Arabic', label: l10n.languageArabic),
      (value: 'Hindi', label: l10n.languageHindi),
      (value: 'Indonesian', label: l10n.languageIndonesian),
      (value: 'Bengali', label: l10n.languageBengali),
      (value: 'Urdu', label: l10n.languageUrdu),
      (value: 'Vietnamese', label: l10n.languageVietnamese),
      (value: 'Turkish', label: l10n.languageTurkish),
      (value: 'Korean', label: l10n.languageKorean),
      (value: 'Thai', label: l10n.languageThai),
      (value: 'Polish', label: l10n.languagePolish),
      (value: 'Ukrainian', label: l10n.languageUkrainian),
      (value: 'Dutch', label: l10n.languageDutch),
      (value: 'Persian', label: l10n.languagePersian),
      (value: 'Punjabi', label: l10n.languagePunjabi),
      (value: 'Tamil', label: l10n.languageTamil),
      (value: 'Telugu', label: l10n.languageTelugu),
      (value: 'Swahili', label: l10n.languageSwahili),
      (value: 'Malay', label: l10n.languageMalay),
      (value: 'Romanian', label: l10n.languageRomanian),
      (value: 'Greek', label: l10n.languageGreek),
      (value: 'Hungarian', label: l10n.languageHungarian),
      (value: 'Czech', label: l10n.languageCzech),
      (value: 'Swedish', label: l10n.languageSwedish),
      (value: 'Hebrew', label: l10n.languageHebrew),
      (value: 'Norwegian', label: l10n.languageNorwegian),
      (value: 'Danish', label: l10n.languageDanish),
      (value: 'Finnish', label: l10n.languageFinnish),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final languageOptions = _languageOptions(l10n);
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            ResponsiveFrame(
              maxWidth: 430,
              child: ResponsiveScroll(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 22),
                  child: Column(
                    children: [
                    const Spacer(flex: 20),

                    // Logo + tagline
                    Column(
                      children: [
                        Text(
                          "SOMA",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.orbitron(
                            fontWeight: FontWeight.w800,
                            letterSpacing: 12.0,
                            fontSize: 54,
                            color: Colors.white,
                            shadows: [
                              // Core bright glow (Cyan-ish)
                              Shadow(
                                color: const Color(0xFF00FFFF).withValues(alpha: 0.6),
                                blurRadius: 20,
                              ),
                              // Mid layer (Purple-ish)
                              Shadow(
                                color: const Color(0xFF9D00FF).withValues(alpha: 0.5),
                                blurRadius: 40,
                              ),
                              // Ambient wide glow
                              Shadow(
                                color: const Color(0xFF6A00FF).withValues(alpha: 0.3),
                                blurRadius: 80,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          l10n.welcomeTagline,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w500,
                                color: Colors.white.withValues(alpha: 0.82),
                                fontSize: 16,
                              ),
                        ),
                      ],
                    ),

                    const Spacer(flex: 18),

                    // Buttons
                    Column(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: NeonButton(
                            label: l10n.signUp,
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const SignUpScreen(),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 14),
                        SizedBox(
                          width: double.infinity,
                          child: Glass(
                            radius: T.r28,
                            padding: EdgeInsets.zero,
                            child: InkWell(
                              borderRadius: T.r28,
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const SignInScreen(),
                                ),
                              ),
                              child: SizedBox(
                                height: 56,
                                child: Center(
                                  child: Text(
                                    l10n.signIn,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 18),
                          GestureDetector(
                          onTap: () {
                            profileStore.loginAsGuest();
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (_) => const AppShell()),
                            );
                          },
                          child: Text(
                            l10n.skipForNow,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white.withValues(alpha: 0.78),
                                ),
                          ),
                        ),
                      ],
                    ),

                    const Spacer(flex: 16),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              top: 10,
              right: 10,
              child: StreamBuilder<Map<String, dynamic>>(
                stream: settingsRepository.getSettingsStream(),
                builder: (context, snapshot) {
                  final current = snapshot.data?['language_ui']?.toString() ?? 'English';
                  final currentLabel = languageOptions
                          .firstWhere(
                            (item) => item.value == current,
                            orElse: () => languageOptions.first,
                          )
                          .label;

                  return Glass(
                    radius: BorderRadius.circular(20),
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
                    child: PopupMenuButton<String>(
                      tooltip: l10n.settingsUiLanguage,
                      onSelected: _changeLanguage,
                      itemBuilder: (context) => [
                        for (final option in languageOptions)
                          PopupMenuItem<String>(
                            value: option.value,
                            child: Row(
                              children: [
                                Expanded(child: Text(option.label)),
                                if (option.value == current)
                                  Icon(
                                    Icons.check_rounded,
                                    size: 16,
                                    color: Theme.of(context).colorScheme.primary,
                                  ),
                              ],
                            ),
                          ),
                      ],
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.language_rounded, color: Colors.white, size: 18),
                            const SizedBox(width: 8),
                            Text(
                              currentLabel,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(width: 4),
                            const Icon(Icons.expand_more_rounded, color: Colors.white, size: 18),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );

  }
}
