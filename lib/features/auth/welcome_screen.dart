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
import '../../core/widgets/responsive.dart';


class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: IgnorePointer(
                child: Align(
                  alignment: const Alignment(0, -0.20),
                  child: Container(
                    width: 520,
                    height: 320,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(999),
                      color: const Color(0xFF7A5CFF).withValues(alpha: 0.18),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF7A5CFF).withValues(alpha: 0.22),
                          blurRadius: 90,
                          spreadRadius: 30,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
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
          ],
        ),
      ),
    );

  }
}
