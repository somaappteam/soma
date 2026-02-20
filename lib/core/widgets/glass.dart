import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../theme/motion.dart';
import '../theme/tokens.dart';

enum GlassDepth { l1, l2, l3 }

class Glass extends StatefulWidget {
  final Widget child;
  final EdgeInsets padding;
  final BorderRadius radius;
  final GlassDepth depth;
  final bool selected;

  const Glass({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.radius = T.r28,
    this.depth = GlassDepth.l2,
    this.selected = false,
  });

  @override
  State<Glass> createState() => _GlassState();
}

class _GlassState extends State<Glass> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: MotionTokens.ambient,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  ({double sigma, List<BoxShadow> shadows}) _depthStyle(
    bool isLight,
    Color shadow,
  ) {
    switch (widget.depth) {
      case GlassDepth.l1:
        return (
          sigma: isLight ? 14 : 9,
          shadows: [
            BoxShadow(
              color: shadow.withValues(alpha: isLight ? 0.14 : 0.36),
              blurRadius: isLight ? 7 : 12,
              offset: const Offset(0, 4),
            ),
          ]
        );
      case GlassDepth.l3:
        return (
          sigma: isLight ? 24 : 16,
          shadows: [
            BoxShadow(
              color: shadow.withValues(alpha: isLight ? 0.22 : 0.46),
              blurRadius: isLight ? 12 : 20,
              offset: const Offset(0, 10),
            ),
            BoxShadow(
              color: shadow.withValues(alpha: isLight ? 0.11 : 0.24),
              blurRadius: isLight ? 20 : 26,
              spreadRadius: isLight ? 1 : 0,
              offset: const Offset(0, 16),
            ),
          ]
        );
      case GlassDepth.l2:
        return (
          sigma: isLight ? 20 : 13,
          shadows: [
            BoxShadow(
              color: shadow.withValues(alpha: isLight ? 0.2 : 0.4),
              blurRadius: isLight ? 9 : 16,
              offset: const Offset(0, 6),
            ),
            BoxShadow(
              color: shadow.withValues(alpha: isLight ? 0.09 : 0.2),
              blurRadius: isLight ? 20 : 26,
              spreadRadius: isLight ? 2 : 0,
              offset: const Offset(0, 12),
            ),
          ]
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final glass = Theme.of(context).extension<GlassTheme>();
    final isLight = Theme.of(context).brightness == Brightness.light;
    final fill = glass?.fill ?? T.glassFill;
    final stroke = glass?.stroke ?? T.glassStroke;
    final effectiveFill = isLight
        ? Color.alphaBlend(Colors.black.withValues(alpha: 0.035), fill)
        : fill;
    final shadow = glass?.shadow ?? const Color(0x7A000000);
    final warmHighlightBase = isLight
        ? Colors.white
        : const Color(0xFFFFE9D1); // warm-neutral top sheen in dark mode
    final coolEdgeTint = isLight
        ? Colors.white
        : const Color(0xFF66DFFF); // cool cyan edge tint in dark mode
    final highlight = Color.lerp(effectiveFill, warmHighlightBase, isLight ? 0.18 : 0.12) ??
        warmHighlightBase.withValues(alpha: 0.12);
    final highlightOpacity = (effectiveFill.a + (isLight ? 0.12 : 0.06)).clamp(0.0, 1.0);
    final rimColor = Color.lerp(stroke, coolEdgeTint, isLight ? 0.2 : 0.34) ??
        stroke.withValues(alpha: isLight ? 0.64 : 0.26);
    final depthStyle = _depthStyle(isLight, shadow);
    final selectedGlow = widget.selected
        ? [
            BoxShadow(
              color: Theme.of(context).colorScheme.primary.withValues(alpha: isLight ? 0.18 : 0.28),
              blurRadius: isLight ? 16 : 20,
              spreadRadius: 0,
              offset: const Offset(0, 0),
            ),
          ]
        : const <BoxShadow>[];

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final sweepX = lerpDouble(-1.2, 1.2, _controller.value) ?? 0;
        return ClipRRect(
          borderRadius: widget.radius,
          child: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: depthStyle.sigma,
              sigmaY: depthStyle.sigma,
            ),
            child: Stack(
              children: [
                DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        highlight.withValues(alpha: highlightOpacity),
                        effectiveFill,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: widget.radius,
                    border: Border.all(
                      color: stroke,
                      width: isLight ? 1.7 : 0.95,
                    ),
                    boxShadow: [...depthStyle.shadows, ...selectedGlow],
                  ),
                  child: Padding(padding: widget.padding, child: widget.child),
                ),
                Positioned.fill(
                  child: IgnorePointer(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        borderRadius: widget.radius,
                        border: Border.all(color: rimColor, width: widget.selected ? 1.15 : 0.7),
                      ),
                    ),
                  ),
                ),
                Positioned.fill(
                  child: IgnorePointer(
                    child: Opacity(
                      opacity: isLight ? 0.055 : 0.042,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          borderRadius: widget.radius,
                          gradient: LinearGradient(
                            begin: Alignment(sweepX - 0.6, -0.9),
                            end: Alignment(sweepX + 0.6, 0.9),
                            colors: [
                              Colors.white.withValues(alpha: 0),
                              Colors.white.withValues(alpha: 0.24),
                              Colors.white.withValues(alpha: 0),
                            ],
                            stops: const [0.32, 0.5, 0.68],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
