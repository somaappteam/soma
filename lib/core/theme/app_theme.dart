import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'tokens.dart';

@immutable
class GlassTheme extends ThemeExtension<GlassTheme> {
  final Color fill;
  final Color stroke;
  final Color shadow;

  const GlassTheme({
    required this.fill,
    required this.stroke,
    required this.shadow,
  });

  @override
  GlassTheme copyWith({Color? fill, Color? stroke, Color? shadow}) {
    return GlassTheme(
      fill: fill ?? this.fill,
      stroke: stroke ?? this.stroke,
      shadow: shadow ?? this.shadow,
    );
  }

  @override
  GlassTheme lerp(ThemeExtension<GlassTheme>? other, double t) {
    if (other is! GlassTheme) return this;
    return GlassTheme(
      fill: Color.lerp(fill, other.fill, t) ?? fill,
      stroke: Color.lerp(stroke, other.stroke, t) ?? stroke,
      shadow: Color.lerp(shadow, other.shadow, t) ?? shadow,
    );
  }
}

@immutable
class AppBackgroundTheme extends ThemeExtension<AppBackgroundTheme> {
  final Gradient gradient;

  const AppBackgroundTheme({required this.gradient});

  @override
  AppBackgroundTheme copyWith({Gradient? gradient}) {
    return AppBackgroundTheme(gradient: gradient ?? this.gradient);
  }

  @override
  AppBackgroundTheme lerp(ThemeExtension<AppBackgroundTheme>? other, double t) {
    if (other is! AppBackgroundTheme) return this;
    return AppBackgroundTheme(
      gradient: Gradient.lerp(gradient, other.gradient, t) ?? gradient,
    );
  }
}

class AppTheme {
  static ThemeData light() {
    const scheme = ColorScheme.light(
      primary: Color(0xFF5E4BFF),
      secondary: Color(0xFF2BBEF9),
      tertiary: Color(0xFFFF4CB5),
      surface: Color(0xFFFFFFFF),
      surfaceContainerHighest: Color(0xFFF2F1FA),
      background: Color(0xFFF7F7FB),
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: Color(0xFF1C1B29),
      onBackground: Color(0xFF1C1B29),
    );

    const glass = GlassTheme(
      fill: Color(0xCCFFFFFF),
      stroke: Color(0x40FFFFFF),
      shadow: Color(0x14000000),
    );
    const background = AppBackgroundTheme(
      gradient: LinearGradient(
        colors: [Color(0xFFF7F7FB), Color(0xFFEFF1FF), Color(0xFFF9F6FF)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    );

    return _baseTheme(
      scheme: scheme,
      brightness: Brightness.light,
      glass: glass,
      background: background,
      scaffoldBackground: scheme.background,
    );
  }

  static ThemeData dark() {
    const scheme = ColorScheme.dark(
      primary: T.neonA,
      secondary: T.neonB,
      tertiary: T.neonC,
      surface: Color(0xFF15162C),
      surfaceContainerHighest: Color(0xFF1E1E3A),
      background: Color(0xFF0B0B2D),
      onPrimary: Colors.white,
      onSecondary: Colors.black,
      onSurface: Color(0xFFF6F5FF),
      onBackground: Color(0xFFF6F5FF),
    );

    const glass = GlassTheme(
      fill: Color(0x1FFFFFFF),
      stroke: Color(0x2FFFFFFF),
      shadow: Color(0x7A000000),
    );
    const background = AppBackgroundTheme(
      gradient: RadialGradient(
        colors: [Color(0xFF120A3D), Color(0xFF0B0B2D), Color(0x00000000)],
        radius: 1.25,
        center: Alignment(0.0, -0.35),
      ),
    );

    return _baseTheme(
      scheme: scheme,
      brightness: Brightness.dark,
      glass: glass,
      background: background,
      scaffoldBackground: scheme.background,
    );
  }

  static ThemeData _baseTheme({
    required ColorScheme scheme,
    required Brightness brightness,
    required GlassTheme glass,
    required AppBackgroundTheme background,
    required Color scaffoldBackground,
  }) {
    final base = ThemeData(
      brightness: brightness,
      colorScheme: scheme,
      useMaterial3: true,
    );
    final isLight = brightness == Brightness.light;
    final cardShadow = isLight ? scheme.shadow.withValues(alpha: 0.16) : Colors.transparent;

    return base.copyWith(
      scaffoldBackgroundColor: scaffoldBackground,
      dividerTheme: DividerThemeData(
        color: scheme.onSurface.withValues(alpha: 0.12),
        thickness: 1,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: scheme.surface,
        titleTextStyle: TextStyle(
          color: scheme.onSurface,
          fontWeight: FontWeight.w800,
          fontSize: 18,
        ),
        contentTextStyle: TextStyle(
          color: scheme.onSurface.withValues(alpha: 0.8),
          fontWeight: FontWeight.w600,
        ),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: scheme.surface,
        surfaceTintColor: Colors.transparent,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: scheme.surface,
        contentTextStyle: TextStyle(color: scheme.onSurface, fontWeight: FontWeight.w600),
        actionTextColor: scheme.primary,
      ),
      cardTheme: CardThemeData(
        color: scheme.surface,
        elevation: isLight ? 3 : 0,
        shadowColor: cardShadow,
        shape: RoundedRectangleBorder(borderRadius: T.r28),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: scheme.onBackground),
        titleTextStyle: TextStyle(
          color: scheme.onBackground,
          fontWeight: FontWeight.w800,
          fontSize: 18,
        ),
      ),
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: <TargetPlatform, PageTransitionsBuilder>{
          TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
          TargetPlatform.iOS: FadeUpwardsPageTransitionsBuilder(),
          TargetPlatform.linux: FadeUpwardsPageTransitionsBuilder(),
          TargetPlatform.macOS: FadeUpwardsPageTransitionsBuilder(),
          TargetPlatform.windows: FadeUpwardsPageTransitionsBuilder(),
          TargetPlatform.fuchsia: FadeUpwardsPageTransitionsBuilder(),
        },
      ),
      switchTheme: SwitchThemeData(
        trackColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? scheme.primary.withValues(alpha: 0.4)
              : scheme.onSurface.withValues(alpha: 0.2),
        ),
        thumbColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected) ? scheme.primary : scheme.onSurface,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: T.fieldFill,
        border: OutlineInputBorder(borderRadius: T.r20, borderSide: BorderSide.none),
        hintStyle: TextStyle(color: scheme.onSurface.withValues(alpha: 0.55)),
        labelStyle: TextStyle(color: scheme.onSurface.withValues(alpha: 0.75)),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: scheme.primary),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: scheme.onSurface,
          side: BorderSide(color: scheme.onSurface.withValues(alpha: 0.3)),
          shape: RoundedRectangleBorder(borderRadius: T.r20),
        ),
      ),
      textTheme: GoogleFonts.poppinsTextTheme(base.textTheme).copyWith(
        displayLarge: GoogleFonts.poppins(fontSize: 36, fontWeight: FontWeight.w700),
        displayMedium: GoogleFonts.poppins(fontSize: 30, fontWeight: FontWeight.w700),
        displaySmall: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.w700),
        headlineMedium: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.w700),
        titleLarge: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w700),
        titleMedium: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600),
        bodyLarge: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w500),
        bodyMedium: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w500),
        bodySmall: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w500),
      ).apply(
        bodyColor: scheme.onBackground,
        displayColor: scheme.onBackground,
      ),
      extensions: [glass, background],
    );
  }
}
