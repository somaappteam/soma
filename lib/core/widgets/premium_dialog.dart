import 'package:flutter/material.dart';

import 'package:soma/core/theme/tokens.dart';
import 'package:soma/core/widgets/glass.dart';

class PremiumDialogAction<ValueType> {
  final String label;
  final ValueType? value;
  final bool isPrimary;
  final bool destructive;

  const PremiumDialogAction({
    required this.label,
    this.value,
    this.isPrimary = false,
    this.destructive = false,
  });
}

Future<bool?> showPremiumDialog({
  required final BuildContext context,
  required final String title,
  required final String body,
  required final String confirmText,
  final String? cancelText,
  final bool destructive = false,
}) {
  final scheme = Theme.of(context).colorScheme;
  return showDialog<bool>(
    context: context,
    barrierColor: Colors.black.withValues(alpha: 0.55),
    builder: (final _) => Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      child: Glass(
        radius: BorderRadius.circular(24),
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 18),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                color: scheme.onSurface,
                fontSize: 18,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              body,
              style: TextStyle(
                color: scheme.onSurface.withValues(alpha: 0.7),
                fontSize: 13.5,
                fontWeight: FontWeight.w600,
                height: 1.35,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                if (cancelText != null)
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context, false),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: scheme.onSurface,
                        side: BorderSide(color: scheme.onSurface.withValues(alpha: 0.25)),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      child: Text(cancelText),
                    ),
                  ),
                if (cancelText != null) const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context, true),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: destructive ? scheme.error : scheme.primary,
                      foregroundColor: destructive ? scheme.onError : scheme.onPrimary,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      shadowColor: destructive
                          ? scheme.error.withValues(alpha: 0.35)
                          : T.neonA.withValues(alpha: 0.35),
                      elevation: 6,
                    ),
                    child: Text(confirmText),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

Future<ResultType?> showPremiumChoiceDialog<ResultType>({
  required final BuildContext context,
  required final String title,
  required final String body,
  required final List<PremiumDialogAction<ResultType>> actions,
}) {
  final scheme = Theme.of(context).colorScheme;
  return showDialog<ResultType>(
    context: context,
    barrierColor: Colors.black.withValues(alpha: 0.60),
    builder: (final ctx) => Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      child: Glass(
        radius: BorderRadius.circular(28),
        padding: const EdgeInsets.fromLTRB(22, 22, 22, 18),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                color: scheme.onSurface,
                fontSize: 18,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              body,
              style: TextStyle(
                color: scheme.onSurface.withValues(alpha: 0.72),
                fontSize: 13.5,
                fontWeight: FontWeight.w600,
                height: 1.35,
              ),
            ),
            const SizedBox(height: 18),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              alignment: WrapAlignment.end,
              children: actions.map((final action) {
                final foreground = action.destructive
                    ? (action.isPrimary ? scheme.onError : scheme.error)
                    : action.isPrimary
                        ? scheme.onPrimary
                        : scheme.onSurface.withValues(alpha: 0.86);
                final background = action.isPrimary
                    ? (action.destructive ? scheme.error : scheme.primary)
                    : Colors.transparent;
                final side = action.isPrimary
                    ? BorderSide.none
                    : BorderSide(color: scheme.onSurface.withValues(alpha: 0.22));

                return action.isPrimary
                    ? ElevatedButton(
                        onPressed: () => Navigator.pop(ctx, action.value),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: background,
                          foregroundColor: foreground,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                          elevation: 6,
                          shadowColor: action.destructive
                              ? scheme.error.withValues(alpha: 0.3)
                              : T.neonA.withValues(alpha: 0.3),
                        ),
                        child: Text(action.label, style: const TextStyle(fontWeight: FontWeight.w800)),
                      )
                    : OutlinedButton(
                        onPressed: () => Navigator.pop(ctx, action.value),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: foreground,
                          side: side,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                        ),
                        child: Text(action.label, style: const TextStyle(fontWeight: FontWeight.w800)),
                      );
              }).toList(),
            ),
          ],
        ),
      ),
    ),
  );
}
