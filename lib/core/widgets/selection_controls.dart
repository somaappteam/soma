import 'package:flutter/material.dart';

class AppSelectablePill extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback? onTap;
  final double fontSize;
  final EdgeInsetsGeometry? padding;
  final double height;

  const AppSelectablePill({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
    this.fontSize = 14,
    this.padding,
    this.height = 44,
  });

  @override
  Widget build(final BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final selectedFill = isDark
        ? const Color(0xFF3A3568)
        : Color.alphaBlend(
            scheme.primary.withValues(alpha: 0.16), scheme.surface);
    final selectedBorder = isDark
        ? const Color(0xFF6B5CFF)
        : scheme.primary.withValues(alpha: 0.35);
    final selectedText = isDark ? const Color(0xFF36F4E8) : scheme.primary;

    return InkWell(
      borderRadius: BorderRadius.circular(999),
      onTap: onTap,
      child: Container(
        height: height,
        padding: padding,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(999),
          color: selected
              ? selectedFill
              : scheme.onSurface.withValues(alpha: 0.08),
          border: Border.all(
            color: selected
                ? selectedBorder
                : scheme.onSurface.withValues(alpha: 0.14),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected
                ? selectedText
                : scheme.onSurface.withValues(alpha: 0.76),
            fontWeight: FontWeight.w900,
            fontSize: fontSize,
          ),
        ),
      ),
    );
  }
}

class AppNeonSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool>? onChanged;

  const AppNeonSwitch({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(final BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final selectedThumb = isDark ? const Color(0xFF36F4E8) : scheme.onPrimary;
    final selectedTrack = isDark
        ? const Color(0xFF4A3EA1)
        : Color.alphaBlend(
            scheme.primary.withValues(alpha: 0.78), scheme.surface);
    final unselectedThumb = isDark
        ? Colors.white.withValues(alpha: 0.85)
        : scheme.outline.withValues(alpha: 0.85);
    final unselectedTrack = isDark
        ? Colors.white.withValues(alpha: 0.24)
        : scheme.outlineVariant.withValues(alpha: 0.75);

    return Switch(
      value: value,
      onChanged: onChanged,
      thumbColor: WidgetStateProperty.resolveWith((final states) {
        if (states.contains(WidgetState.selected)) {
          return selectedThumb;
        }
        return unselectedThumb;
      }),
      trackColor: WidgetStateProperty.resolveWith((final states) {
        if (states.contains(WidgetState.selected)) {
          return selectedTrack;
        }
        return unselectedTrack;
      }),
      trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
    );
  }
}
