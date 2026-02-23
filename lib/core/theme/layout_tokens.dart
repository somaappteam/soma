import 'package:flutter/widgets.dart';

class SectionGap {
  static const double xs = 6;
  static const double sm = 10;
  static const double md = 14;
  static const double lg = 18;
  static const double xl = 24;
}

class CardGap {
  static const double compact = 8;
  static const double comfortable = 12;
  static const double spacious = 16;
}

enum LayoutDensity { compact, comfortable, spacious }

class PremiumLayout {
  static LayoutDensity densityForWidth(final double width) {
    if (width < 380) return LayoutDensity.compact;
    if (width >= 900) return LayoutDensity.spacious;
    return LayoutDensity.comfortable;
  }

  static double listGap(final LayoutDensity density) {
    switch (density) {
      case LayoutDensity.compact:
        return CardGap.compact;
      case LayoutDensity.spacious:
        return CardGap.spacious;
      case LayoutDensity.comfortable:
        return CardGap.comfortable;
    }
  }

  static EdgeInsets screenPadding(final LayoutDensity density) {
    switch (density) {
      case LayoutDensity.compact:
        return const EdgeInsets.fromLTRB(14, 12, 14, 14);
      case LayoutDensity.spacious:
        return const EdgeInsets.fromLTRB(22, 16, 22, 20);
      case LayoutDensity.comfortable:
        return const EdgeInsets.fromLTRB(16, 14, 16, 18);
    }
  }

  static double maxContentWidth(final double width) {
    if (width >= 1600) return 1200;
    if (width >= 1200) return 980;
    if (width >= 900) return 860;
    return width;
  }
}
