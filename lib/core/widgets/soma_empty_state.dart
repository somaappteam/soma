import 'package:flutter/material.dart';
import 'package:soma/core/theme/tokens.dart';
import 'package:soma/core/widgets/glass.dart';

/// A premium illustrated empty state for when a list or feed has no content.
///
/// Usage:
/// ```dart
/// SomaEmptyState(
///   emoji: '👥',
///   title: 'No friends yet',
///   subtitle: 'Invite someone to start playing together!',
///   action: ElevatedButton(onPressed: ..., child: Text('Invite friends')),
/// )
/// ```
class SomaEmptyState extends StatefulWidget {
  final String emoji;
  final String title;
  final String? subtitle;
  final Widget? action;

  const SomaEmptyState({
    super.key,
    required this.emoji,
    required this.title,
    this.subtitle,
    this.action,
  });

  @override
  State<SomaEmptyState> createState() => _SomaEmptyStateState();
}

class _SomaEmptyStateState extends State<SomaEmptyState>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulse;
  late final Animation<double> _scaleAnim;
  late final Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..repeat(reverse: true);

    _scaleAnim = Tween<double>(begin: 1.0, end: 1.08).animate(
      CurvedAnimation(parent: _pulse, curve: Curves.easeInOut),
    );
    _fadeAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _pulse,
        curve: const Interval(0.0, 0.3, curve: Curves.easeOut),
      ),
    );
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
        child: FadeTransition(
          opacity: _fadeAnim,
          child: Glass(
            radius: BorderRadius.circular(28),
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 36),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Pulsing emoji.
                ScaleTransition(
                  scale: _scaleAnim,
                  child: Text(
                    widget.emoji,
                    style: const TextStyle(fontSize: 64),
                    semanticsLabel: '',
                  ),
                ),
                const SizedBox(height: 20),

                // Title.
                Text(
                  widget.title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: scheme.onSurface,
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    height: 1.2,
                  ),
                ),

                if (widget.subtitle != null) ...[
                  const SizedBox(height: 10),
                  Text(
                    widget.subtitle!,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: scheme.onSurface.withValues(alpha: 0.55),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      height: 1.4,
                    ),
                  ),
                ],

                if (widget.action != null) ...[
                  const SizedBox(height: 24),
                  widget.action!,
                ],

                // Decorative neon shimmer line.
                const SizedBox(height: 20),
                Container(
                  height: 2,
                  width: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(999),
                    gradient: LinearGradient(
                      colors: [
                        T.neonA.withValues(alpha: 0.0),
                        T.neonA.withValues(alpha: 0.6),
                        T.neonB.withValues(alpha: 0.6),
                        T.neonB.withValues(alpha: 0.0),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
