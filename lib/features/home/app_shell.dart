import 'package:flutter/material.dart';
import 'package:soma/l10n/gen/app_localizations.dart';
import '../../data/auth_repository.dart';
import '../../core/widgets/glass.dart';
import '../auth/sign_in_screen.dart';
import '../auth/sign_up_screen.dart';
import '../circles/circles_screen.dart';
import 'home_screen.dart';
import '../profile/profile_screen.dart';
import '../../core/theme/motion.dart';
import '../../core/widgets/pressable_scale.dart';
import '../../core/widgets/responsive.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _index = 0;

  bool get _isGuest => authRepository.currentUser == null;

  void _handleNavChange(int nextIndex) {
    if (nextIndex == 1 && _isGuest) {
      _showAuthRequiredDialog();
      return;
    }
    setState(() => _index = nextIndex);
  }

  Future<void> _showAuthRequiredDialog() async {
    final l10n = AppLocalizations.of(context);
    await showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1C1C1C),
        title: Text(
          l10n.dialogAuthRequiredTitle,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900),
        ),
        content: Text(
          l10n.dialogAuthRequiredBody,
          style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontWeight: FontWeight.w600),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l10n.notNow, style: TextStyle(color: Colors.white.withValues(alpha: 0.75))),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SignInScreen()),
              );
            },
            child: Text(l10n.signIn, style: const TextStyle(color: Color(0xFF2AFADF), fontWeight: FontWeight.w800)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SignUpScreen()),
              );
            },
            child: Text(l10n.signUp, style: const TextStyle(color: Color(0xFFFF4ECD), fontWeight: FontWeight.w800)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      const HomeScreen(),
      const CirclesScreen(),
      const ProfileScreen(),
    ];
    final activePage = AnimatedSwitcher(
      duration: MotionTokens.pageIn,
      reverseDuration: MotionTokens.pageOut,
      switchInCurve: MotionTokens.pageInCurve,
      switchOutCurve: MotionTokens.pageOutCurve,
      transitionBuilder: (child, animation) {
        final slide = Tween<Offset>(
          begin: const Offset(0, 0.04),
          end: Offset.zero,
        ).animate(animation);
        final fade = Tween<double>(begin: 0.0, end: 1.0).animate(animation);
        return FadeTransition(
          opacity: fade,
          child: SlideTransition(
            position: slide,
            child: ScaleTransition(
              scale: Tween<double>(begin: 0.98, end: 1.0).animate(animation),
              child: child,
            ),
          ),
        );
      },
      child: KeyedSubtree(
        key: ValueKey(_index),
        child: pages[_index],
      ),
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= SomaBreakpoints.medium;

        return Scaffold(
          backgroundColor: Colors.transparent,
          body: isWide
              ? Row(
                  children: [
                    _SomaSideNav(
                      index: _index,
                      onChanged: _handleNavChange,
                    ),
                    Expanded(child: activePage),
                  ],
                )
              : activePage,
          bottomNavigationBar: isWide
              ? null
              : _SomaBottomNav(
                  index: _index,
                  onChanged: _handleNavChange,
                ),
        );
      },
    );
  }
}

class _SomaBottomNav extends StatelessWidget {
  final int index;
  final ValueChanged<int> onChanged;

  const _SomaBottomNav({
    required this.index,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return SafeArea(
      top: false,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;
          final scale = (width / 360).clamp(0.85, 1.1);
          final outerPad = EdgeInsets.fromLTRB(14 * scale, 0, 14 * scale, 12 * scale);
          final innerPad = EdgeInsets.symmetric(horizontal: 6 * scale, vertical: 8 * scale);
          final radius = 24 * scale;
          final iconSize = 22 * scale;
          final fontSize = 12 * scale;
          final labelGap = 4 * scale;
          final itemPad = EdgeInsets.symmetric(horizontal: 8 * scale, vertical: 8 * scale);

          return Padding(
            padding: outerPad,
            child: Glass(
              radius: BorderRadius.circular(radius),
              padding: innerPad,
              child: Row(
                children: [
                  Expanded(
                    child: _NavItem(
                      label: l10n.navHome,
                      icon: Icons.home_rounded,
                      selected: index == 0,
                      iconSize: iconSize,
                      fontSize: fontSize,
                      labelGap: labelGap,
                      padding: itemPad,
                      onTap: () => onChanged(0),
                    ),
                  ),
                  Expanded(
                    child: _NavItem(
                      label: l10n.navCircles,
                      icon: Icons.public_rounded,
                      selected: index == 1,
                      iconSize: iconSize,
                      fontSize: fontSize,
                      labelGap: labelGap,
                      padding: itemPad,
                      onTap: () => onChanged(1),
                    ),
                  ),
                  Expanded(
                    child: _NavItem(
                      label: l10n.navProfile,
                      icon: Icons.person_rounded,
                      selected: index == 2,
                      iconSize: iconSize,
                      fontSize: fontSize,
                      labelGap: labelGap,
                      padding: itemPad,
                      onTap: () => onChanged(2),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;
  final double iconSize;
  final double fontSize;
  final double labelGap;
  final EdgeInsets padding;

  const _NavItem({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
    required this.iconSize,
    required this.fontSize,
    required this.labelGap,
    required this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final color = selected ? Colors.white : Colors.white.withValues(alpha: 0.65);
    final bg = selected ? Colors.white.withValues(alpha: 0.12) : Colors.transparent;
    final border = selected ? Colors.white.withValues(alpha: 0.22) : Colors.transparent;

    return PressableScale(
      onTap: onTap,
      child: Container(
        padding: padding,
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: border),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: iconSize),
            SizedBox(height: labelGap),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: color,
                fontSize: fontSize,
                fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SomaSideNav extends StatelessWidget {
  final int index;
  final ValueChanged<int> onChanged;

  const _SomaSideNav({
    required this.index,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return SafeArea(
      right: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
        child: SizedBox(
          width: 100,
          child: Glass(
            radius: BorderRadius.circular(24),
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _RailItem(
                  label: l10n.navHome,
                  icon: Icons.home_rounded,
                  selected: index == 0,
                  onTap: () => onChanged(0),
                ),
                const SizedBox(height: 14),
                _RailItem(
                  label: l10n.navCircles,
                  icon: Icons.public_rounded,
                  selected: index == 1,
                  onTap: () => onChanged(1),
                ),
                const SizedBox(height: 14),
                _RailItem(
                  label: l10n.navProfile,
                  icon: Icons.person_rounded,
                  selected: index == 2,
                  onTap: () => onChanged(2),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _RailItem extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _RailItem({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = selected ? Colors.white : Colors.white.withValues(alpha: 0.65);
    final bg = selected ? Colors.white.withValues(alpha: 0.12) : Colors.transparent;
    final border = selected ? Colors.white.withValues(alpha: 0.22) : Colors.transparent;

    return PressableScale(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: border),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color),
            const SizedBox(height: 6),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 12,
                fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
