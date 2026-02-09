import 'package:flutter/material.dart';
import '../services/haptics_service.dart';
import '../services/sfx_service.dart';
import '../theme/motion.dart';

class PressableScale extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final double pressedScale;
  final Duration duration;
  final Curve curve;
  final bool enableHaptics;

  const PressableScale({
    super.key,
    required this.child,
    this.onTap,
    this.pressedScale = 0.98,
    this.duration = MotionTokens.micro,
    this.curve = MotionTokens.standardCurve,
    this.enableHaptics = true,
  });

  @override
  State<PressableScale> createState() => _PressableScaleState();
}

class _PressableScaleState extends State<PressableScale> {
  bool _pressed = false;

  void _setPressed(bool value) {
    if (_pressed == value) return;
    setState(() => _pressed = value);
  }

  @override
  Widget build(BuildContext context) {
    final enabled = widget.onTap != null;
    return AnimatedScale(
      scale: _pressed && enabled ? widget.pressedScale : 1,
      duration: widget.duration,
      curve: widget.curve,
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: widget.onTap,
        onTapDown: enabled
            ? (_) {
                if (widget.enableHaptics) {
                  hapticsService.selectionClick();
                  sfxService.click();
                }
                _setPressed(true);
              }
            : null,
        onTapUp: enabled ? (_) => _setPressed(false) : null,
        onTapCancel: enabled ? () => _setPressed(false) : null,
        child: widget.child,
      ),
    );
  }
}
