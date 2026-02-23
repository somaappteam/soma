import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:soma/core/theme/motion.dart';

class RewardSparkle extends StatelessWidget {
  final bool show;
  final double size;
  final Color color;
  final bool burst;

  const RewardSparkle({
    super.key,
    required this.show,
    this.size = 18,
    this.color = const Color(0xFF2AFADF),
    this.burst = true,
  });

  @override
  Widget build(final BuildContext context) {
    if (!show) return const SizedBox.shrink();
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.6, end: 1.0),
      duration: MotionTokens.short,
      curve: MotionTokens.emphasisCurve,
      builder: (final context, final value, final child) {
        return Opacity(
          opacity: value,
          child: Transform.scale(
            scale: value,
            child: child,
          ),
        );
      },
      child: burst
          ? SizedBox(
              width: size * 1.9,
              height: size * 1.9,
              child: Stack(
                alignment: Alignment.center,
                children: List.generate(3, (final index) {
                  final angle = (index * 2 * math.pi) / 3;
                  final offset = Offset(math.cos(angle), math.sin(angle)) * (size * 0.32);
                  return Transform.translate(
                    offset: offset,
                    child: Icon(
                      index == 0 ? Icons.auto_awesome : Icons.star_rounded,
                      color: color.withValues(alpha: index == 0 ? 1 : 0.85),
                      size: index == 0 ? size : size * 0.7,
                    ),
                  );
                }),
              ),
            )
          : Icon(
              Icons.auto_awesome,
              color: color,
              size: size,
            ),
    );
  }
}
