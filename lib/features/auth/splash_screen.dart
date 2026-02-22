import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:soma/l10n/gen/app_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import '../auth/welcome_screen.dart';
import '../../core/theme/motion.dart';
import '../../core/theme/tokens.dart';
import '../../data/auth_repository.dart';
import '../home/app_shell.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;
  late final Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: MotionTokens.splash,
    );

    _scale = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: MotionTokens.emphasisCurve),
    );

    _fade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.0, 0.6, curve: MotionTokens.fadeCurve)),
    );

    _controller.forward();
    _goNext();
  }

  Future<void> _goNext() async {
    // Run animation for at least 600ms AND ensure auth session is fresh.
    await Future.wait([
      Future.delayed(const Duration(milliseconds: 600)),
      Supabase.instance.client.auth.refreshSession().catchError((_) {}),
    ]);
    if (!mounted) return;

    final session = authRepository.currentUser;
    if (session != null) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const AppShell()),
      );
      return;
    }

    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => const WelcomeScreen(),
        transitionsBuilder: (_, a, __, c) => FadeTransition(opacity: a, child: c),
        transitionDuration: const Duration(milliseconds: 500),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isLight = Theme.of(context).brightness == Brightness.light;
    final logoColor = isLight ? const Color(0xFF1E325A) : Colors.white;
    final glowA = isLight
        ? const Color(0xFF73A7FF).withValues(alpha: 0.55)
        : T.neonA.withValues(alpha: 0.6);
    final glowB = isLight
        ? const Color(0xFFA8C9FF).withValues(alpha: 0.48)
        : T.neonB.withValues(alpha: 0.4);

    return Scaffold(
      backgroundColor: const Color(0xFF02071A),
      body: Center(
        child: FadeTransition(
          opacity: _fade,
          child: ScaleTransition(
            scale: _scale,
            child: Text(
              l10n.appTitle,
              style: GoogleFonts.orbitron(
                fontSize: 64,
                fontWeight: FontWeight.w900,
                letterSpacing: 8,
                color: logoColor,
                shadows: [
                  BoxShadow(
                    color: glowA,
                    blurRadius: 34,
                    spreadRadius: 8,
                  ),
                  BoxShadow(
                    color: glowB,
                    blurRadius: 70,
                    spreadRadius: 16,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

