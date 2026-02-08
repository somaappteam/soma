import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/tokens.dart';
import '../theme/motion.dart';

class NeonButton extends StatefulWidget {
  final String label;
  final VoidCallback? onTap;
  final bool breathe;

  const NeonButton({
    super.key,
    required this.label,
    this.onTap,
    this.breathe = true,
  });

  @override
  State<NeonButton> createState() => _NeonButtonState();
}

class _NeonButtonState extends State<NeonButton> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _pulse;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: MotionTokens.breathe);
    _pulse = CurvedAnimation(parent: _controller, curve: MotionTokens.breatheCurve);
    if (widget.breathe) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(covariant NeonButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.breathe != oldWidget.breathe) {
      if (widget.breathe) {
        _controller.repeat(reverse: true);
      } else {
        _controller.stop();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap == null
          ? null
          : () {
              HapticFeedback.lightImpact();
              widget.onTap?.call();
            },
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          final scale = widget.breathe ? 1.0 + (_pulse.value * 0.02) : 1.0;
          final glow = widget.breathe ? 0.5 + (_pulse.value * 0.2) : 0.5;
          return Transform.scale(
            scale: scale,
            child: Stack(
              alignment: Alignment.center,
              clipBehavior: Clip.none,
              children: [
                // 1. Broad Outer Glow
                Opacity(
                  opacity: glow,
                  child: ImageFiltered(
                    imageFilter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
                    child: Container(
                      height: 56,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: T.r28,
                        gradient: T.neonGradient,
                      ),
                    ),
                  ),
                ),

                // 2. Focused Glow
                Opacity(
                  opacity: 0.8,
                  child: ImageFiltered(
                    imageFilter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                    child: Container(
                      height: 56,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: T.r28,
                        gradient: T.neonGradient,
                      ),
                    ),
                  ),
                ),

                // 3. Main Button Pill
                Container(
                  height: 56,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: T.r28,
                    gradient: T.neonGradient,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.25),
                        offset: const Offset(0, 4),
                        blurRadius: 12,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      widget.label,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ),
                ),

                // 4. Glass Reflection (Top highlight)
                Positioned(
                  top: 2,
                  left: 20,
                  right: 20,
                  child: Container(
                    height: 14,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.white.withValues(alpha: 0.35),
                          Colors.white.withValues(alpha: 0.0),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
