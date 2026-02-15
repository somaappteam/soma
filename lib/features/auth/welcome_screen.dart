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
import '../../core/i18n/ui_language.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  Future<void> _changeLanguage(String languageCode) async {
    await settingsRepository.updateSetting('language_ui', languageCode);
  }

  List<({String value, String label})> _languageOptions(AppLocalizations l10n) {
    return [
      for (final language in kSupportedUiLanguages)
        (value: language.code, label: language.labelBuilder(l10n)),
    ];
  }



  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final languageOptions = _languageOptions(l10n);
    final isLight = Theme.of(context).brightness == Brightness.light;
    final scheme = Theme.of(context).colorScheme;
    final screenHeight = MediaQuery.sizeOf(context).height;
    final logoTopPadding = (screenHeight * 0.20).clamp(96.0, 170.0);
    final actionsBottomPadding = (screenHeight * 0.08).clamp(28.0, 64.0);

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            ResponsiveFrame(
              maxWidth: 430,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 22),
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.topCenter,
                      child: Padding(
                        padding: EdgeInsets.only(top: logoTopPadding),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "SOMA",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.orbitron(
                                fontWeight: FontWeight.w800,
                                letterSpacing: 12.0,
                                fontSize: 54,
                                color: isLight ? scheme.primary : Colors.white,
                                shadows: [
                                  Shadow(
                                    color: const Color(0xFF00FFFF).withValues(alpha: 0.6),
                                    blurRadius: 20,
                                  ),
                                  Shadow(
                                    color: const Color(0xFF9D00FF).withValues(alpha: 0.5),
                                    blurRadius: 40,
                                  ),
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
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w500,
                                    color: scheme.onSurface.withValues(alpha: 0.82),
                                    fontSize: 16,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: EdgeInsets.only(bottom: actionsBottomPadding),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
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
                                          style: TextStyle(
                                            color: scheme.onSurface,
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
                                        color: scheme.onSurface.withValues(alpha: 0.6),
                                      ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 10,
              right: 10,
              child: StreamBuilder<Map<String, dynamic>>(
                stream: settingsRepository.getSettingsStream(),
                builder: (context, snapshot) {
                  final current = normalizeUiLanguageCode(snapshot.data?['language_ui']?.toString());
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
                            Icon(Icons.language_rounded, color: scheme.onSurface, size: 18),
                            const SizedBox(width: 8),
                            Text(
                              currentLabel,
                              style: TextStyle(
                                color: scheme.onSurface,
                                fontWeight: FontWeight.w700,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Icon(Icons.expand_more_rounded, color: scheme.onSurface, size: 18),
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
