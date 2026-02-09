import 'package:flutter/material.dart';
import '../services/haptics_service.dart';
import '../services/sfx_service.dart';
import '../theme/tokens.dart';

class NeonButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;

  const NeonButton({
    super.key,
    required this.label,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap == null
          ? null
          : () {
              hapticsService.lightImpact();
              sfxService.click();
              onTap?.call();
            },
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          // 1. Shadow for elevation (Clean & subtle)
          Container(
            height: 56,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: T.r28,
              boxShadow: [
                BoxShadow(
                  color: T.neonA.withValues(alpha: 0.15),
                  offset: const Offset(0, 8),
                  blurRadius: 20,
                  spreadRadius: -4,
                ),
              ],
            ),
          ),

          // 2. Main Button Pill
          Container(
            height: 56,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: T.r28,
              gradient: T.neonGradient,
            ),
            child: Center(
              child: Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ),

          // 3. Subtle Glass Reflection (Very thin top highlight)
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
        ],
      ),
    );
  }
}
