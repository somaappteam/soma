import 'package:flutter/material.dart';

class Motion {
  static const Duration fast = Duration(milliseconds: 160);
  static const Duration medium = Duration(milliseconds: 280);
  static const Duration slow = Duration(milliseconds: 420);

  static const Curve emphasizedIn = Curves.easeOutCubic;
  static const Curve emphasizedOut = Curves.easeInCubic;
  static const Curve standard = Curves.fastOutSlowIn;

  static bool animationsDisabled(BuildContext context) {
    final media = MediaQuery.maybeOf(context);
    return media?.disableAnimations ?? false;
  }
}
