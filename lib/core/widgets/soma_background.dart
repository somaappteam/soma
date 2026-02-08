import 'dart:math';
import 'package:flutter/material.dart';
import '../theme/motion.dart';
import 'responsive.dart';

class SomaBackgroundScope extends InheritedWidget {
  const SomaBackgroundScope({super.key, required super.child});

  static bool hasScope(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<SomaBackgroundScope>() != null;
  }

  @override
  bool updateShouldNotify(SomaBackgroundScope oldWidget) => false;
}

class SomaBackground extends StatefulWidget {
  final Widget child;
  const SomaBackground({super.key, required this.child});

  @override
  State<SomaBackground> createState() => _SomaBackgroundState();
}

class _SomaBackgroundState extends State<SomaBackground> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: MotionTokens.ambient)
      ..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (SomaBackgroundScope.hasScope(context)) {
      return widget.child;
    }
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final t = CurvedAnimation(parent: _controller, curve: MotionTokens.ambientCurve).value;
        final driftX = sin(t * pi * 2) * 0.04;
        final driftY = cos(t * pi * 2) * 0.03;
        final bgAlign = Alignment(driftX, -0.15 + driftY);
        final radialCenter = Alignment(driftX * 0.6, -0.2 + driftY * 0.8);
        final glowAlpha = 0.22 + (sin(t * pi * 2) * 0.06);

        return SomaBackgroundScope(
          child: Stack(
            children: [
              Positioned.fill(
                child: Image.asset(
                  "assets/bg/welcome_bg.jpg",
                  fit: BoxFit.cover,
                  alignment: bgAlign,
                ),
              ),
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withValues(alpha: 0.30),
                        Colors.transparent,
                        Colors.black.withValues(alpha: 0.55),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      center: radialCenter,
                      radius: 1.25,
                      colors: [
                        Colors.transparent,
                        Colors.black.withValues(alpha: glowAlpha),
                      ],
                    ),
                  ),
                ),
              ),
              ResponsiveFrame(child: child!),
            ],
          ),
        );
      },
      child: widget.child,
    );
  }
}
