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
    final isLight = Theme.of(context).brightness == Brightness.light;
    final fill = glass?.fill ?? T.glassFill;
    final stroke = glass?.stroke ?? T.glassStroke;
    final shadow = glass?.shadow ?? const Color(0x7A000000);
    final highlight = Color.lerp(fill, Colors.white, 0.18) ??
        Colors.white.withValues(alpha: 0.12);
    final highlightOpacity = (fill.a + 0.08).clamp(0.0, 1.0);
    final rimColor = Color.lerp(stroke, Colors.white, isLight ? 0.3 : 0.2) ??
        stroke.withValues(alpha: isLight ? 0.7 : 0.3);

    return ClipRRect(
      borderRadius: radius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
        child: Stack(
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    highlight.withValues(alpha: highlightOpacity),
                    fill,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: radius,
                border: Border.all(
                  color: stroke,
                  width: isLight ? 2.2 : 1, // Significantly sharper border in light mode
                ),
                boxShadow: [
                  if (isLight) ...[
                    // "Grounded shadow" - sharper and deeper
                    BoxShadow(
                      color: shadow.withValues(alpha: 0.25),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                    // Stronger ambient depth
                    BoxShadow(
                      color: shadow.withValues(alpha: 0.12),
                      blurRadius: 18,
                      spreadRadius: 2,
                      offset: const Offset(0, 8),
                    ),
                  ] else ...[
                    BoxShadow(
                      color: shadow,
                      blurRadius: 28,
                      offset: const Offset(0, 16),
                    ),
                  ],
                ],
              ),
              child: Padding(padding: padding, child: child),
            ),
            Positioned.fill(
              child: IgnorePointer(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: radius,
                    border: Border.all(color: rimColor, width: 0.7),
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
