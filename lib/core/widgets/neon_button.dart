import 'dart:ui';

import 'package:flutter/material.dart';
import '../services/haptics_service.dart';
import '../services/sfx_service.dart';
import '../theme/tokens.dart';

class NeonButton extends StatefulWidget {
  final String label;
  final VoidCallback? onTap;

  const NeonButton({
    super.key,
    required this.label,
    this.onTap,
  });

  @override
  State<NeonButton> createState() => _NeonButtonState();
}

class _NeonButtonState extends State<NeonButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _pulse;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2800),
    )..repeat(reverse: true);
    _pulse = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final enabled = widget.onTap != null;
    final scheme = Theme.of(context).colorScheme;
    final isLight = Theme.of(context).brightness == Brightness.light;

    final gradientStart = isLight ? scheme.primary : T.neonA;
    final gradientEnd = isLight ? scheme.tertiary : T.neonC;
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
        builder: (context, child) {
          final glowStrength = lerpDouble(0.12, 0.28, _pulse.value) ?? 0.2;
          final shimmerShift = lerpDouble(-0.2, 0.2, _pulse.value) ?? 0.0;
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
              // 1. Pulsing ambient glow (alive feel)
              Container(
                height: 56,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: T.r28,
                  boxShadow: [
                    BoxShadow(
                      color: ambientGlow.withValues(alpha: glowStrength),
                      offset: const Offset(0, 8),
                      blurRadius: 26,
                      spreadRadius: -6,
                    ),
                    BoxShadow(
                      color: accentGlow.withValues(alpha: glowStrength * 0.6),
                      offset: const Offset(0, 2),
                      blurRadius: 18,
                      spreadRadius: -8,
                    ),
                  ],
                ),
              ),

              // 2. Main Button Pill (animated gradient shimmer)
              Container(
                height: 56,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: T.r28,
                  gradient: LinearGradient(
                    begin: Alignment(-1 + shimmerShift, -1),
                    end: Alignment(1, 1 + shimmerShift),
                    colors: [baseA, baseC],
                  ),
                ),
                child: Center(
                  child: Text(
                    widget.label,
                    style: TextStyle(
                      color: Colors.white.withValues(
                        alpha: enabled ? 1 : 0.7,
                      ),
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),

              // 3. Subtle top specular highlight
              Positioned(
                top: 1,
                left: 24,
                right: 24,
                child: Container(
                  height: 1,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(1),
                    color: Colors.white.withValues(alpha: 0.25),
                  ),
                ),
              ),

              // 4. Animated sheen sweep
              Positioned.fill(
                child: IgnorePointer(
                  child: Opacity(
                    opacity: enabled ? 0.22 : 0.1,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        borderRadius: T.r28,
                        gradient: LinearGradient(
                          begin: Alignment(-1.2 + shimmerShift, -0.6),
                          end: Alignment(1.2 + shimmerShift, 0.6),
                          colors: [
                            Colors.white.withValues(alpha: 0),
                            Colors.white.withValues(alpha: 0.35),
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
