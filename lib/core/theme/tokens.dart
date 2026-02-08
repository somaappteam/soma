import 'package:flutter/material.dart';

class T {
  // Space background
  static const bg0 = Color(0x00000000); // Transparent to show global background

  static const bg1 = Color(0xFF0B0B2D);
  static const bg2 = Color(0xFF120A3D);

  // Text
  static const textHi = Color(0xFFFFFFFF);
  static const textLo = Color(0xB3FFFFFF);

  // Glass
  static const glassFill = Color(0x14FFFFFF); // ~8%
  static const glassStroke = Color(0x26FFFFFF); // ~15%

  // Premium accents
  static const neonA = Color(0xFF6C4DFF); // deeper purple
  static const neonB = Color(0xFF2AE6FF); // sharp cyan
  static const neonC = Color(0xFFFF3DB4); // richer pink
  static const neonG = Color(0xFF2BD910); // slightly more natural green

  static const r20 = BorderRadius.all(Radius.circular(20));
  static const r28 = BorderRadius.all(Radius.circular(28));

  static const neonGradient = LinearGradient(
    colors: [neonB, neonA], // Simplified to 2 colors
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const bgGradient = RadialGradient(
    colors: [bg2, bg1, bg0],
    radius: 1.25,
    center: Alignment(0.0, -0.35),
  );
}
