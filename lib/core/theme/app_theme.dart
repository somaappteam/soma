import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'motion.dart';
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

@immutable
class AppSemanticTheme extends ThemeExtension<AppSemanticTheme> {
  final Color progress;
  final Color social;
  final Color reward;

  const AppSemanticTheme({
    required this.progress,
    required this.social,
    required this.reward,
  });

  @override
  AppSemanticTheme copyWith({Color? progress, Color? social, Color? reward}) {
    return AppSemanticTheme(
      progress: progress ?? this.progress,
      social: social ?? this.social,
      reward: reward ?? this.reward,
    );
  }

  @override
  AppSemanticTheme lerp(ThemeExtension<AppSemanticTheme>? other, double t) {
    if (other is! AppSemanticTheme) return this;
    return AppSemanticTheme(
      progress: Color.lerp(progress, other.progress, t) ?? progress,
      social: Color.lerp(social, other.social, t) ?? social,
      reward: Color.lerp(reward, other.reward, t) ?? reward,
    );
  }
}

@immutable
class AppTextToneTheme extends ThemeExtension<AppTextToneTheme> {
  final Color high;
  final Color medium;
  final Color muted;

  const AppTextToneTheme({
    required this.high,
    required this.medium,
    required this.muted,
  });

  @override
  AppTextToneTheme copyWith({Color? high, Color? medium, Color? muted}) {
    return AppTextToneTheme(
      high: high ?? this.high,
      medium: medium ?? this.medium,
      muted: muted ?? this.muted,
    );
  }

  @override
  AppTextToneTheme lerp(ThemeExtension<AppTextToneTheme>? other, double t) {
    if (other is! AppTextToneTheme) return this;
    return AppTextToneTheme(
      high: Color.lerp(high, other.high, t) ?? high,
      medium: Color.lerp(medium, other.medium, t) ?? medium,
      muted: Color.lerp(muted, other.muted, t) ?? muted,
    );
  }
}

class AppTheme {
  static ThemeData light() {
    const scheme = ColorScheme.light(
      // Premium editorial light palette: dominant green + one support accent.
      primary: Color(0xFF0FAE72),
      secondary: Color(0xFF6D6AF7),
      tertiary: Color(0xFF7A7A93),
      surface: Color(0xFFFFFFFF),
      surfaceContainerHighest: Color(0xFFF3F7F4),
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: Color(0xFF10221D),
    );

    const glass = GlassTheme(
      fill: Color(0xEFF4F7F4),
      stroke: Color(0x341A3F2F),
      shadow: Color(0x4A12382A),
    );
    const background = AppBackgroundTheme(
      gradient: LinearGradient(
        colors: [
          Color(0xFFE5F3E8),
          Color(0xFFF7F6EC),
          Color(0xFFF4ECE2),
        ],
        stops: [0.0, 0.55, 1.0],
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
      textTones: const AppTextToneTheme(
        high: Color(0xE610221D),
        medium: Color(0xB510221D),
        muted: Color(0x8A10221D),
      ),
    );
  }

  static ThemeData dark() {
    const scheme = ColorScheme.dark(
      primary: T.neonA,
      secondary: T.neonB,
      surface: Color(0xFF06070F),
      surfaceContainerHighest: Color(0xFF181E2E),
      onPrimary: Colors.white,
      onSecondary: Colors.black,
      onSurface: Color(0xFFF6F5FF),
    );

    const glass = GlassTheme(
      fill: Color(0x1EFFFFFF),
      stroke: Color(0x2B77E7FF),
      shadow: Color(0x66000000),
    );
    const background = AppBackgroundTheme(
      gradient: LinearGradient(
        colors: [
          Color(0xFF04050B),
          Color(0xFF090D1A),
          Color(0xFF0A0F19),
          Color(0x120E5B88), // cyan haze <8%
          Color(0x120F2C7A), // purple haze <8%
        ],
        stops: [0.0, 0.45, 0.7, 0.86, 1.0],
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
      textTones: const AppTextToneTheme(
        high: Color(0xE8F6F5FF),
        medium: Color(0xC5F6F5FF),
        muted: Color(0x96F6F5FF),
      ),
    );
  }

  static ThemeData _baseTheme({
    required ColorScheme scheme,
    required Brightness brightness,
    required GlassTheme glass,
    required AppBackgroundTheme background,
    required Color scaffoldBackground,
    required AppTextToneTheme textTones,
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
      pageTransitionsTheme: PageTransitionsTheme(
        builders: {
          TargetPlatform.android: _FastPageTransitionsBuilder(isLight: isLight),
          TargetPlatform.iOS: _FastPageTransitionsBuilder(isLight: isLight),
          TargetPlatform.macOS: _FastPageTransitionsBuilder(isLight: isLight),
          TargetPlatform.windows: _FastPageTransitionsBuilder(isLight: isLight),
          TargetPlatform.linux: _FastPageTransitionsBuilder(isLight: isLight),
          TargetPlatform.fuchsia: _FastPageTransitionsBuilder(isLight: isLight),
        },
      ),
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
        surfaceTintColor: scheme.primary.withValues(alpha: isLight ? 0.04 : 0),
        elevation: isLight ? 2.5 : 0,
        shadowColor: cardShadow,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: T.r28,
          side: BorderSide(
            color: scheme.onSurface.withValues(alpha: isLight ? 0.12 : 0.24),
            width: isLight ? 1.0 : 0.8,
          ),
        ),
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
        displayLarge: GoogleFonts.poppins(fontSize: 36, fontWeight: isLight ? FontWeight.w700 : FontWeight.w600),
        displayMedium: GoogleFonts.poppins(fontSize: 30, fontWeight: isLight ? FontWeight.w700 : FontWeight.w600),
        displaySmall: GoogleFonts.poppins(fontSize: 24, fontWeight: isLight ? FontWeight.w700 : FontWeight.w600),
        headlineMedium: GoogleFonts.poppins(fontSize: 22, fontWeight: isLight ? FontWeight.w700 : FontWeight.w600),
        titleLarge: GoogleFonts.poppins(fontSize: 19, fontWeight: isLight ? FontWeight.w700 : FontWeight.w600),
        titleMedium: GoogleFonts.poppins(fontSize: 16, fontWeight: isLight ? FontWeight.w600 : FontWeight.w500),
        bodyLarge: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w400),
        bodyMedium: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w400),
        bodySmall: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w400),
      ).apply(
        bodyColor: scheme.onSurface,
        displayColor: scheme.onSurface,
      ),
      extensions: [
        glass,
        background,
        const AppSemanticTheme(
          progress: T.semanticProgress,
          social: T.semanticSocial,
          reward: T.semanticReward,
        ),
        textTones,
      ],
    );
  }
}

class _FastPageTransitionsBuilder extends PageTransitionsBuilder {
  final bool isLight;

  const _FastPageTransitionsBuilder({required this.isLight});

  @override
  Duration get transitionDuration => isLight ? MotionTokens.lightPageIn : MotionTokens.darkPageIn;

  @override
  Duration get reverseTransitionDuration =>
      isLight ? MotionTokens.lightPageOut : MotionTokens.darkPageOut;

  @override
  Widget buildTransitions<R>(
    PageRoute<R> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    final curve = isLight ? MotionTokens.lightPageInCurve : MotionTokens.darkPageInCurve;
    final reverseCurve = isLight ? MotionTokens.lightPageOutCurve : MotionTokens.darkPageOutCurve;
    final curved = CurvedAnimation(
      parent: animation,
      curve: curve,
      reverseCurve: reverseCurve,
    );

    final slide = Tween<Offset>(
      begin: Offset(isLight ? 0.02 : 0.014, 0),
      end: Offset.zero,
    ).animate(curved);

    return FadeTransition(
      opacity: curved,
      child: SlideTransition(position: slide, child: child),
    );
  }
}
