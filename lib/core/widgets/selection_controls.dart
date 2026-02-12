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

  static const Color _selectedFill = Color(0xFF3A3568);
  static const Color _selectedBorder = Color(0xFF6B5CFF);
  static const Color _selectedText = Color(0xFF36F4E8);

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return InkWell(
      borderRadius: BorderRadius.circular(999),
      onTap: onTap,
      child: Container(
        height: height,
        padding: padding,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(999),
          color: selected ? _selectedFill : scheme.onSurface.withValues(alpha: 0.08),
          border: Border.all(
            color: selected ? _selectedBorder : scheme.onSurface.withValues(alpha: 0.14),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? _selectedText : scheme.onSurface.withValues(alpha: 0.76),
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
  Widget build(BuildContext context) {
    return Switch(
      value: value,
      onChanged: onChanged,
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return const Color(0xFF36F4E8);
        }
        return Colors.white.withValues(alpha: 0.85);
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return const Color(0xFF4A3EA1);
        }
        return Colors.white.withValues(alpha: 0.24);
      }),
      trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
    );
  }
}
