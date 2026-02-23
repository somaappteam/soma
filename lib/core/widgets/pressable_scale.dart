import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:soma/core/services/haptics_service.dart';
import 'package:soma/core/services/sfx_service.dart';
import 'package:soma/core/theme/motion.dart';

class PressableScale extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final double pressedScale;
  final Duration duration;
  final Curve curve;
  final bool enableHaptics;
  final String? semanticLabel;
  final bool isButton;

  const PressableScale({
    super.key,
    required this.child,
    this.onTap,
    this.pressedScale = 0.97,
    this.duration = MotionTokens.micro,
    this.curve = MotionTokens.emphasisCurve,
    this.enableHaptics = true,
    this.semanticLabel,
    this.isButton = true,
  });

  @override
  State<PressableScale> createState() => _PressableScaleState();
}

class _PressableScaleState extends State<PressableScale> {
  bool _pressed = false;

  void _setPressed(final bool value) {
    if (_pressed == value) return;
    setState(() => _pressed = value);
  }

  @override
  Widget build(final BuildContext context) {
    final enabled = widget.onTap != null;
    final isLight = Theme.of(context).brightness == Brightness.light;
    final effectiveDuration = widget.duration == MotionTokens.micro
        ? (isLight ? MotionTokens.lightTap : MotionTokens.darkTap)
        : widget.duration;
    final effectiveCurve = widget.curve == MotionTokens.emphasisCurve
        ? (isLight ? MotionTokens.lightTapCurve : MotionTokens.darkTapCurve)
        : widget.curve;

    Widget core = GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: widget.onTap,
      onTapDown: enabled
          ? (final _) {
              if (widget.enableHaptics) {
                hapticsService.selectionClick();
                sfxService.click();
              }
              _setPressed(true);
            }
          : null,
      onTapUp: enabled ? (final _) => _setPressed(false) : null,
      onTapCancel: enabled ? () => _setPressed(false) : null,
      child: widget.child,
    ).animate(target: _pressed && enabled ? 1 : 0)
     .scaleXY(end: widget.pressedScale, duration: effectiveDuration, curve: effectiveCurve)
     .tint(color: isLight ? Colors.black : Colors.white, end: 0.05, duration: effectiveDuration);

    if (widget.semanticLabel != null || widget.isButton) {
      core = Semantics(
        label: widget.semanticLabel,
        button: widget.isButton,
        enabled: enabled,
        child: core,
      );
    }

    return core;
  }
}
