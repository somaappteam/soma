import 'package:flutter/material.dart';
import '../theme/motion.dart';

class RewardSparkle extends StatelessWidget {
  final bool show;
  final double size;
  final Color color;

  const RewardSparkle({
    super.key,
    required this.show,
    this.size = 18,
    this.color = const Color(0xFF2AFADF),
  });

  @override
  Widget build(BuildContext context) {
    if (!show) return const SizedBox.shrink();
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.6, end: 1.0),
      duration: MotionTokens.short,
      curve: MotionTokens.standardCurve,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.scale(
            scale: value,
            child: child,
          ),
        );
      },
      child: Icon(
        Icons.auto_awesome,
        color: color,
        size: size,
      ),
    );
  }
}
