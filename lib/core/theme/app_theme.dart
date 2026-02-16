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
      // More colorful light theme palette
      primary: Color(0xFF0DBB74),
      secondary: Color(0xFFFFE06C),
      tertiary: Color(0xFFFF8A4C),
      surface: Color(0xFFFFFFFF),
      surfaceContainerHighest: Color(0xFFF5FBF7),
      onPrimary: Colors.white,
      onSecondary: Color(0xFF1B2418),
      onSurface: Color(0xFF10221D),
    );

    const glass = GlassTheme(
      fill: Color(0xE6FFFFFF), // ~90% opacity white
      stroke: Color(0xFFFFFFFF), // Solid white stroke
      shadow: Color(0x400E3E2A), // ~25% opacity shadow (darker green tint)
    );
    const background = AppBackgroundTheme(
      gradient: LinearGradient(
        colors: [
          Color(0xFFDFF7E5), // Rich Mint (Top)
          Color(0xFFFFF5CC), // Warm Butter (Middle)
          Color(0xFFFFEAD1), // Soft Apricot (Bottom)
        ],
        stops: [0.0, 0.5, 1.0],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ),
    );

    return _baseTheme(
      scheme: scheme,
      brightness: Brightness.light,
      glass: glass,
      background: background,
      scaffoldBackground: scheme.surface,
    );
  }

  static ThemeData dark() {
    const scheme = ColorScheme.dark(
      primary: T.neonA,
      secondary: T.neonB,
      surface: Color(0xFF15162C),
      surfaceContainerHighest: Color(0xFF1E1E3A),
      onPrimary: Colors.white,
      onSecondary: Colors.black,
      onSurface: Color(0xFFF6F5FF),
    );

    const glass = GlassTheme(
      fill: Color(0x1FFFFFFF),
      stroke: Color(0x2FFFFFFF),
      shadow: Color(0x7A000000),
    );
    const background = AppBackgroundTheme(
      gradient: LinearGradient(
        colors: [Color(0xFF0B0B2D), Color(0xFF0B0B2D)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ),
    );

    return _baseTheme(
      scheme: scheme,
      brightness: Brightness.dark,
      glass: glass,
      background: background,
      scaffoldBackground: scheme.surface,
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
    final cardShadow = isLight
        ? const Color(0xFF0A3B24).withValues(alpha: 0.10)
        : Colors.transparent;

    return base.copyWith(
      scaffoldBackgroundColor: scaffoldBackground,
      dividerTheme: DividerThemeData(
        color: scheme.primary.withValues(alpha: 0.12),
        thickness: 1,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: scheme.surface,
        surfaceTintColor: scheme.primary.withValues(alpha: isLight ? 0.06 : 0),
        shape: RoundedRectangleBorder(borderRadius: T.r28),
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
        surfaceTintColor: scheme.primary.withValues(alpha: isLight ? 0.05 : 0),
        elevation: isLight ? 8 : 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: isLight ? Colors.white : scheme.surface,
        elevation: isLight ? 4 : 0,
        contentTextStyle: TextStyle(
          color: scheme.onSurface,
          fontWeight: FontWeight.w600,
        ),
        actionTextColor: scheme.primary,
      ),
      cardTheme: CardThemeData(
        color: isLight ? scheme.surfaceContainerHighest : scheme.surface,
        surfaceTintColor: scheme.primary.withValues(alpha: isLight ? 0.05 : 0),
        elevation: isLight ? 5 : 0,
        shadowColor: cardShadow,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: T.r28),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: isLight ? Colors.white.withValues(alpha: 0.72) : Colors.transparent,
        surfaceTintColor: Colors.transparent,
        scrolledUnderElevation: isLight ? 2 : 0,
        shadowColor: cardShadow.withValues(alpha: 0.6),
        elevation: 0,
        iconTheme: IconThemeData(color: scheme.onSurface),
        titleTextStyle: TextStyle(
          color: scheme.onSurface,
          fontWeight: FontWeight.w800,
          fontSize: 18,
        ),
      ),
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: <TargetPlatform, PageTransitionsBuilder>{
          TargetPlatform.android: _FastPageTransitionsBuilder(),
          TargetPlatform.iOS: _FastPageTransitionsBuilder(),
          TargetPlatform.linux: _FastPageTransitionsBuilder(),
          TargetPlatform.macOS: _FastPageTransitionsBuilder(),
          TargetPlatform.windows: _FastPageTransitionsBuilder(),
          TargetPlatform.fuchsia: _FastPageTransitionsBuilder(),
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
        fillColor: isLight ? Colors.white.withValues(alpha: 0.84) : T.fieldFill,
        border: OutlineInputBorder(borderRadius: T.r20, borderSide: BorderSide.none),
        enabledBorder: OutlineInputBorder(
          borderRadius: T.r20,
          borderSide: BorderSide(
            color: scheme.onSurface.withValues(alpha: isLight ? 0.12 : 0.2),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: T.r20,
          borderSide: BorderSide(
            color: scheme.primary.withValues(alpha: 0.68),
            width: 1.6,
          ),
        ),
        hintStyle: TextStyle(color: scheme.onSurface.withValues(alpha: 0.62)),
        labelStyle: TextStyle(color: scheme.onSurface.withValues(alpha: 0.82)),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: scheme.primary,
          textStyle: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: scheme.onSurface,
          side: BorderSide(
            color: isLight
                ? scheme.primary.withValues(alpha: 0.32)
                : scheme.onSurface.withValues(alpha: 0.3),
          ),
          shape: RoundedRectangleBorder(borderRadius: T.r20),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          foregroundColor: scheme.onPrimary,
          backgroundColor: scheme.primary,
          elevation: isLight ? 2.5 : 0,
          shadowColor: isLight
              ? scheme.primary.withValues(alpha: 0.22)
              : Colors.transparent,
          textStyle: const TextStyle(fontWeight: FontWeight.w700),
          shape: RoundedRectangleBorder(borderRadius: T.r20),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          foregroundColor: scheme.onPrimary,
          backgroundColor: scheme.primary,
          elevation: isLight ? 2 : 0,
          shadowColor: isLight
              ? scheme.primary.withValues(alpha: 0.20)
              : Colors.transparent,
          textStyle: const TextStyle(fontWeight: FontWeight.w700),
          shape: RoundedRectangleBorder(borderRadius: T.r20),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: scheme.primary,
        foregroundColor: scheme.onPrimary,
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: scheme.primary,
        linearTrackColor: scheme.primary.withValues(alpha: 0.16),
        circularTrackColor: scheme.primary.withValues(alpha: 0.16),
      ),
      chipTheme: base.chipTheme.copyWith(
        backgroundColor: isLight
            ? scheme.primary.withValues(alpha: 0.10)
            : scheme.surfaceContainerHighest,
        selectedColor: scheme.primary.withValues(alpha: 0.22),
        labelStyle: TextStyle(
          color: scheme.onSurface,
          fontWeight: FontWeight.w600,
        ),
        side: BorderSide(
          color: scheme.primary.withValues(alpha: isLight ? 0.22 : 0.34),
        ),
        shape: RoundedRectangleBorder(borderRadius: T.r20),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: isLight
            ? Colors.white.withValues(alpha: 0.92)
            : scheme.surface,
        shadowColor: isLight ? cardShadow : Colors.transparent,
        elevation: isLight ? 10 : 0,
        surfaceTintColor: scheme.primary.withValues(alpha: isLight ? 0.04 : 0),
        indicatorColor: scheme.primary.withValues(alpha: isLight ? 0.20 : 0.3),
        iconTheme: WidgetStateProperty.resolveWith(
          (states) => IconThemeData(
            color: states.contains(WidgetState.selected)
                ? scheme.primary
                : scheme.onSurface.withValues(alpha: 0.65),
          ),
        ),
        labelTextStyle: WidgetStateProperty.resolveWith(
          (states) => TextStyle(
            color: states.contains(WidgetState.selected)
                ? scheme.primary
                : scheme.onSurface.withValues(alpha: 0.68),
            fontWeight: states.contains(WidgetState.selected)
                ? FontWeight.w700
                : FontWeight.w600,
          ),
        ),
      ),
      textTheme: GoogleFonts.poppinsTextTheme(base.textTheme).copyWith(
        displayLarge: GoogleFonts.poppins(fontSize: 36, fontWeight: FontWeight.w600),
        displayMedium: GoogleFonts.poppins(fontSize: 30, fontWeight: FontWeight.w600),
        displaySmall: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.w600),
        headlineMedium: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.w600),
        titleLarge: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600),
        titleMedium: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500),
        bodyLarge: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w400),
        bodyMedium: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w400),
        bodySmall: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w400),
      ).apply(
        bodyColor: scheme.onSurface,
        displayColor: scheme.onSurface,
      ),
      extensions: [glass, background],
    );
  }
}

class _FastPageTransitionsBuilder extends PageTransitionsBuilder {
  const _FastPageTransitionsBuilder();

  @override
  Widget buildTransitions<R>(
    PageRoute<R> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    final curved = CurvedAnimation(
      parent: animation,
      curve: Curves.easeOutCubic,
      reverseCurve: Curves.easeOutCubic,
    );

    final slide = Tween<Offset>(
      begin: const Offset(0.02, 0),
      end: Offset.zero,
    ).animate(curved);

    return FadeTransition(
      opacity: curved,
      child: SlideTransition(position: slide, child: child),
    );
  }
}
