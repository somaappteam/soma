import 'package:flutter/material.dart';

class T {
  // Space background
  static const bg0 = Color(0xFF07061A);
  static const bg1 = Color(0xFF0B0B2D);
  static const bg2 = Color(0xFF120A3D);

  // Text
  static const textHi = Color(0xFFFFFFFF);
  static const textLo = Color(0xB3FFFFFF);

  // Glass
  static const glassFill = Color(0x14FFFFFF); // ~8%
  static const glassStroke = Color(0x26FFFFFF); // ~15%

  // Neon accents
  static const neonA = Color(0xFF7A5CFF); // purple
  static const neonB = Color(0xFF3AE6FF); // cyan
  static const neonC = Color(0xFFFF4FD8); // pink
  static const neonG = Color(0xFF39FF14); // neon green

  static const r20 = BorderRadius.all(Radius.circular(20));
  static const r28 = BorderRadius.all(Radius.circular(28));

  static const neonGradient = LinearGradient(
    colors: [neonB, neonA, neonC],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static const bgGradient = RadialGradient(
    colors: [bg2, bg1, bg0],
    radius: 1.25,
    center: Alignment(0.0, -0.35),
  );
}
