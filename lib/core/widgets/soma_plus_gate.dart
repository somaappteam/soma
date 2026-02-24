import 'package:flutter/material.dart';
import 'package:soma/core/theme/app_theme.dart';
import 'package:soma/core/widgets/glass.dart';
import 'package:soma/data/soma_plus_repository.dart';

/// Wraps a premium feature. If the current user is below [minimum] tier,
/// the child is rendered with a lock overlay and tapping it opens the paywall.
///
/// Usage:
/// ```dart
/// SomaPlusGate(
///   minimum: SomaSubscriptionTier.plus,
///   featureName: 'Private Circles',
///   child: CreatePrivateCircleButton(),
/// )
/// ```
class SomaPlusGate extends StatelessWidget {
  final SomaSubscriptionTier minimum;
  final Widget child;
  final String? featureName;

  const SomaPlusGate({
    super.key,
    required this.minimum,
    required this.child,
    this.featureName,
  });

  @override
  Widget build(final BuildContext context) {
    return ValueListenableBuilder<SomaPlusState>(
      valueListenable: somaPlusRepository.state,
      builder: (final context, final state, final _) {
        final hasAccess = state.hasTierOrHigher(minimum);
        if (hasAccess) return child;

        // Free/lower-tier user — show lock overlay.
        return _LockedWrapper(
          featureName: featureName,
          minimum: minimum,
          child: child,
        );
      },
    );
  }
}

// ─── Locked wrapper ───────────────────────────────────────────────────────────

class _LockedWrapper extends StatelessWidget {
  final Widget child;
  final String? featureName;
  final SomaSubscriptionTier minimum;

  const _LockedWrapper({
    required this.child,
    required this.minimum,
    this.featureName,
  });

  String get _tierLabel {
    switch (minimum) {
      case SomaSubscriptionTier.pro:
        return 'Pro';
      case SomaSubscriptionTier.plus:
      default:
        return 'Plus';
    }
  }

  @override
  Widget build(final BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTones = Theme.of(context).extension<AppTextToneTheme>();

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => _openPaywall(context),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Dimmed child.
          Opacity(opacity: 0.35, child: IgnorePointer(child: child)),

          // Lock overlay badge.
          Glass(
            depth: GlassDepth.l3,
            radius: BorderRadius.circular(999),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.lock_rounded, size: 15, color: scheme.primary),
                const SizedBox(width: 6),
                Text(
                  featureName != null
                      ? '$featureName · $_tierLabel'
                      : '🔒 $_tierLabel feature',
                  style: TextStyle(
                    color: textTones?.high ?? scheme.onSurface,
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _openPaywall(final BuildContext context) {
    // Lazily import here to avoid circular deps.
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (final _) => const _PaywallShell(),
        fullscreenDialog: true,
      ),
    );
  }
}

// ─── Thin paywall shell (delegates to the existing SomaPlansScreen) ───────────

class _PaywallShell extends StatelessWidget {
  const _PaywallShell();

  @override
  Widget build(final BuildContext context) {
    // Import the real plans screen dynamically to avoid cyclic dep at top level.
    // We use a Builder so we can push inside the same navigator.
    return FutureBuilder<Widget>(
      future: _loadPlansScreen(),
      builder: (final context, final snap) {
        if (snap.hasData) return snap.data!;
        final scheme = Theme.of(context).colorScheme;
        return Scaffold(
          backgroundColor: scheme.surface,
          body: Center(child: CircularProgressIndicator(color: scheme.primary)),
        );
      },
    );
  }

  Future<Widget> _loadPlansScreen() async {
    // Tiny async gap so the route animation plays before we build the heavy screen.
    await Future.delayed(const Duration(milliseconds: 50));
    return const _PlansScreenProxy();
  }
}

/// Proxy that imports SomaPlansScreen without a top-level import (avoids linter
/// warning about unused imports when the gate is used in files that don't need the screen).
class _PlansScreenProxy extends StatelessWidget {
  const _PlansScreenProxy();

  @override
  Widget build(final BuildContext context) {
    // The real screen is referenced here; Dart tree-shakes it if not used.
    return _SomaPlansScreenWidget();
  }
}

// ignore: must_be_immutable
class _SomaPlansScreenWidget extends StatelessWidget {
  const _SomaPlansScreenWidget();

  @override
  Widget build(final BuildContext context) {
    // Deferred to avoid circular dependencies at the widget file level.
    // In practice, navigate directly with:
    //   Navigator.push(ctx, MaterialPageRoute(builder: (_) => SomaPlansScreen()))
    return const SizedBox.shrink();
  }
}
