import 'package:flutter/material.dart';
import 'package:soma/core/theme/motion.dart';
import 'package:soma/core/theme/tokens.dart';
import 'package:soma/data/auth_repository.dart';
import 'package:soma/features/auth/welcome_screen.dart';
import 'package:soma/features/home/app_shell.dart';
import 'package:soma/l10n/gen/app_localizations.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


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

    _fade = Tween<double>(begin: 1.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.0, 0.6, curve: MotionTokens.fadeCurve)),
    );

    _controller.forward();
    _goNext();
  }

  Future<void> _goNext() async {
    // Run animation for at least 600ms AND ensure auth session is fresh.
    await Future.wait([
      Future.delayed(const Duration(milliseconds: 600)),
      Supabase.instance.client.auth.refreshSession().catchError((final _) => AuthResponse(session: null, user: null)),
    ]);
    if (!mounted) return;

    final session = authRepository.currentUser;
    if (session != null) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (final _) => const AppShell()),
      );
      return;
    }

    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (final _, final __, final ___) => const WelcomeScreen(),
        transitionsBuilder: (final _, final a, final __, final c) => FadeTransition(opacity: a, child: c),
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
  Widget build(final BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF02071A),
      body: Center(
        child: FadeTransition(
          opacity: _fade,
          child: ScaleTransition(
            scale: _scale,
            child: Image.asset(
              'assets/logo.jpeg',
              width: 200,
              height: 200,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}

