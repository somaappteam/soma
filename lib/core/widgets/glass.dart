import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../theme/tokens.dart';

class Glass extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;
  final BorderRadius radius;

  const Glass({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.radius = T.r28,
  });

  @override
  Widget build(BuildContext context) {
    final glass = Theme.of(context).extension<GlassTheme>();
    final fill = glass?.fill ?? T.glassFill;
    final stroke = glass?.stroke ?? T.glassStroke;
    final shadow = glass?.shadow ?? const Color(0x7A000000);

    return ClipRRect(
      borderRadius: radius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: fill,
            borderRadius: radius,
            border: Border.all(color: stroke, width: 1),
            boxShadow: [
              BoxShadow(
                color: shadow,
                blurRadius: 28,
                offset: Offset(0, 16),
              ),
            ],
          ),
          child: Padding(padding: padding, child: child),
        ),
      ),
    );
  }
}
