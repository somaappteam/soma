import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/tokens.dart';

class NeonButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;

  const NeonButton({super.key, required this.label, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          // 1. Broad Outer Glow
          Opacity(
            opacity: 0.5,
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
                label,
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
  }
}

