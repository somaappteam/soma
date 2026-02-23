import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:soma/core/services/haptics_service.dart';
import 'package:soma/core/services/sfx_service.dart';
import 'package:soma/core/theme/motion.dart';
import 'package:soma/core/theme/tokens.dart';

enum NeonButtonStyle { vibrant, subtle }

class NeonButton extends StatefulWidget {
  final String label;
  final VoidCallback? onTap;
  final NeonButtonStyle style;

  const NeonButton({
    super.key,
    required this.label,
    this.onTap,
    this.style = NeonButtonStyle.vibrant,
  });

  @override
  State<NeonButton> createState() => _NeonButtonState();
}

class _NeonButtonState extends State<NeonButton> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late Animation<double> _pulse;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: MotionTokens.lightPulse);
    _pulse = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _configurePulse();
  }

  @override
  void didUpdateWidget(covariant final NeonButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.style != widget.style || oldWidget.onTap != widget.onTap) {
      _configurePulse();
    }
  }

  void _configurePulse() {
    final isLight = Theme.of(context).brightness == Brightness.light;
    _controller.duration = isLight ? MotionTokens.lightPulse : MotionTokens.darkPulse;
    _pulse = CurvedAnimation(
      parent: _controller,
      curve: isLight ? MotionTokens.lightStaggerCurve : MotionTokens.darkStaggerCurve,
    );
    final shouldAnimate = widget.style == NeonButtonStyle.vibrant && widget.onTap != null;
    if (shouldAnimate) {
      _controller.repeat(reverse: true);
    } else {
      _controller.stop();
      _controller.value = 0.5;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    final enabled = widget.onTap != null;
    final scheme = Theme.of(context).colorScheme;
    final isLight = Theme.of(context).brightness == Brightness.light;
    final isSubtle = widget.style == NeonButtonStyle.subtle;

    final gradientStart = isLight ? scheme.primary : T.neonA;
    final gradientEnd = isSubtle ? scheme.secondary : (isLight ? scheme.tertiary : T.neonC);
    final ambientGlow = isLight ? scheme.primary : T.neonA;
    final accentGlow = isLight ? scheme.secondary : T.neonB;

    return GestureDetector(
      onTap: widget.onTap == null
          ? null
          : () {
              hapticsService.lightImpact();
              sfxService.click();
              widget.onTap?.call();
            },
      child: AnimatedBuilder(
        animation: _pulse,
        builder: (final context, final child) {
          final glowStrength = isSubtle
              ? 0.02
              : (lerpDouble(0.08, 0.16, _pulse.value) ?? 0.12);
          final shimmerShift = isSubtle ? 0.0 : (lerpDouble(-0.2, 0.2, _pulse.value) ?? 0.0);
          final baseA = enabled
              ? gradientStart
              : gradientStart.withValues(alpha: 0.45);
          final baseC = enabled
              ? gradientEnd
              : gradientEnd.withValues(alpha: 0.45);
          return Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.none,
            children: [
              Container(
                height: 48,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: T.r20,
                  boxShadow: [
                    BoxShadow(
                      color: ambientGlow.withValues(alpha: glowStrength),
                      offset: const Offset(0, 6),
                      blurRadius: isSubtle ? 6 : 10,
                      spreadRadius: -7,
                    ),
                    BoxShadow(
                      color: accentGlow.withValues(alpha: glowStrength * 0.6),
                      offset: const Offset(0, 1),
                      blurRadius: isSubtle ? 5 : 10,
                      spreadRadius: -9,
                    ),
                  ],
                ),
              ),
              Container(
                height: 48,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: T.r20,
                  gradient: LinearGradient(
                    begin: Alignment(-1 + shimmerShift, -1),
                    end: Alignment(1, 1 + shimmerShift),
                    colors: [baseA, baseC],
                  ),
                  border: isSubtle
                      ? Border.all(color: scheme.onPrimary.withValues(alpha: 0.22), width: 0.8)
                      : null,
                ),
                child: Center(
                  child: Text(
                    widget.label,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: enabled ? 1 : 0.7),
                      fontSize: 15.5,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 1,
                left: 20,
                right: 20,
                child: Container(
                  height: 1,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(1),
                    color: Colors.white.withValues(alpha: isSubtle ? 0.16 : 0.25),
                  ),
                ),
              ),
              Positioned.fill(
                child: IgnorePointer(
                  child: Opacity(
                    opacity: isSubtle ? 0.05 : (enabled ? 0.14 : 0.08),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        borderRadius: T.r20,
                        gradient: LinearGradient(
                          begin: Alignment(-1.2 + shimmerShift, -0.6),
                          end: Alignment(1.2 + shimmerShift, 0.6),
                          colors: [
                            Colors.white.withValues(alpha: 0),
                            Colors.white.withValues(alpha: isSubtle ? 0.2 : 0.35),
                            Colors.white.withValues(alpha: 0),
                          ],
                          stops: const [0.25, 0.5, 0.75],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
