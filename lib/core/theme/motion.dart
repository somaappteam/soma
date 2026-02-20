import 'package:flutter/animation.dart';

class MotionTokens {
  const MotionTokens._();

  static const Duration micro = Duration(milliseconds: 140);
  static const Duration short = Duration(milliseconds: 220);
  static const Duration medium = Duration(milliseconds: 320);
  static const Duration long = Duration(milliseconds: 480);
  static const Duration pageIn = Duration(milliseconds: 460);
  static const Duration pageOut = Duration(milliseconds: 320);
  static const Duration splash = Duration(milliseconds: 1600);
  static const Duration delayShort = Duration(milliseconds: 300);
  static const Duration ambient = Duration(seconds: 12);
  static const Duration breathe = Duration(milliseconds: 2800);

  static const Curve pageInCurve = Curves.easeOutCubic;
  static const Curve pageOutCurve = Curves.easeInCubic;
  static const Curve standardCurve = Curves.easeOutCubic;
  static const Curve emphasisCurve = Curves.easeOutBack;
  static const Curve movementCurve = Curves.easeInOutCubic;
  static const Curve fadeCurve = Curves.easeIn;
  static const Curve ambientCurve = Curves.easeInOutSine;
  static const Curve breatheCurve = Curves.easeInOutSine;

  // Theme-specific motion personality.
  static const Duration lightPageIn = Duration(milliseconds: 420);
  static const Duration lightPageOut = Duration(milliseconds: 300);
  static const Duration darkPageIn = Duration(milliseconds: 520);
  static const Duration darkPageOut = Duration(milliseconds: 360);

  static const Curve lightPageInCurve = Curves.easeOutCubic;
  static const Curve lightPageOutCurve = Curves.easeInCubic;
  static const Curve darkPageInCurve = Curves.easeOutQuart;
  static const Curve darkPageOutCurve = Curves.easeInOutCubicEmphasized;

  // Component-level motion personality.
  static const Duration lightTap = Duration(milliseconds: 140);
  static const Duration darkTap = Duration(milliseconds: 180);
  static const Duration lightStagger = Duration(milliseconds: 220);
  static const Duration darkStagger = Duration(milliseconds: 280);
  static const Duration lightPulse = Duration(milliseconds: 2400);
  static const Duration darkPulse = Duration(milliseconds: 3200);

  static const Curve lightTapCurve = Curves.easeOutBack;
  static const Curve darkTapCurve = Curves.easeOutCubic;
  static const Curve lightStaggerCurve = Curves.easeOutCubic;
  static const Curve darkStaggerCurve = Curves.easeInOutCubic;
}
