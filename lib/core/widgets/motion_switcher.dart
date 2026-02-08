import 'package:flutter/material.dart';
import '../theme/motion.dart';

class MotionPageSwitcher extends StatelessWidget {
  final Widget child;
  final Object? pageKey;

  const MotionPageSwitcher({
    super.key,
    required this.child,
    required this.pageKey,
  });

  @override
  Widget build(BuildContext context) {
    if (Motion.animationsDisabled(context)) {
      return KeyedSubtree(
        key: ValueKey(pageKey),
        child: child,
      );
    }

    return AnimatedSwitcher(
      duration: Motion.slow,
      reverseDuration: Motion.medium,
      switchInCurve: Motion.emphasizedIn,
      switchOutCurve: Motion.emphasizedOut,
      transitionBuilder: (child, animation) {
        final slide = Tween<Offset>(
          begin: const Offset(0, 0.03),
          end: Offset.zero,
        ).animate(animation);
        final fade = Tween<double>(begin: 0.0, end: 1.0).animate(animation);
        final scale = Tween<double>(begin: 0.985, end: 1.0).animate(animation);
        return FadeTransition(
          opacity: fade,
          child: SlideTransition(
            position: slide,
            child: ScaleTransition(
              scale: scale,
              child: child,
            ),
          ),
        );
      },
      child: KeyedSubtree(
        key: ValueKey(pageKey),
        child: child,
      ),
    );
  }
}
