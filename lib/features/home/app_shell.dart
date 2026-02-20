import 'dart:async';
import 'package:flutter/material.dart';
import '../../data/settings_repository.dart';
import 'package:soma/l10n/gen/app_localizations.dart';
import '../../data/auth_repository.dart';
import '../../core/widgets/glass.dart';
import '../auth/sign_in_screen.dart';
import '../auth/sign_up_screen.dart';
import '../circles/circles_screen.dart';
import 'home_screen.dart';
import '../profile/profile_screen.dart';
import '../social/dm_chat_screen.dart';
import '../../core/theme/motion.dart';
import '../../core/widgets/pressable_scale.dart';
import '../../core/widgets/responsive.dart';
import '../../data/call_signaling_service.dart';
import '../../data/profile_repository.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _index = 0;
  StreamSubscription<CallSignalEvent>? _signalSub;

  bool get _isGuest => authRepository.currentUser == null;

  void _handleNavChange(int nextIndex) {
    if (nextIndex == 1 && _isGuest) {
      _showAuthRequiredDialog();
      return;
    }
    setState(() => _index = nextIndex);
  }

  @override
  void initState() {
    super.initState();
    _initGlobalSignaling();
  }

  void _initGlobalSignaling() {
    if (_isGuest) return;
    callSignalingService.initialize();
    _signalSub = callSignalingService.events.listen((event) {
      if (event.type == CallSignalType.invite) {
        _handleGlobalInvite(event);
      }
    });
  }

  Future<void> _handleGlobalInvite(CallSignalEvent event) async {
    // If we are already in DmChatScreen, it will handle it (or we can let AppShell handle it globally)
    // For now, let's show a global dialog if we aren't in a call.
    final settings = await settingsRepository.getTypedSettings();
    if (settings.dmActiveCall['active'] == true) {
      await callSignalingService.sendSignal(
        toUserId: event.fromUserId,
        type: CallSignalType.busy,
      );
      return;
    }

    if (!mounted) return;
    
    final fromProfile = await profileRepository.fetchProfile(userId: event.fromUserId);
    final fromName = fromProfile?.displayName ?? fromProfile?.username ?? 'Someone';

    final accepted = await _showGlobalIncomingCallDialog(fromName);
    if (accepted == true) {
      // Navigate to DM chat screen with this user
      if (!mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => DmChatScreen(
            meId: authRepository.currentUser?.id ?? '',
            otherId: event.fromUserId,
            otherName: fromName,
            initialIncomingCall: true,
          ),
        ),
      );
    } else {
      await callSignalingService.sendSignal(
        toUserId: event.fromUserId,
        type: CallSignalType.decline,
      );
    }
  }

  Future<bool?> _showGlobalIncomingCallDialog(String name) async {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Glass(
          radius: BorderRadius.circular(24),
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.call_rounded, size: 48, color: Colors.blue),
              const SizedBox(height: 16),
              Text(
                'Incoming call from $name',
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text('Decline'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text('Accept'),
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

  @override
  void dispose() {
    _signalSub?.cancel();
    super.dispose();
  }

  Future<void> _openAuthFlow(Widget screen) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => screen),
    );
    if (mounted && !_isGuest) {
      setState(() => _index = 1);
    }
  }

  Future<void> _showAuthRequiredDialog() async {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    await showDialog<void>(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.6),
      builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 24),
        child: Glass(
          radius: BorderRadius.circular(24),
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 18),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: LinearGradient(
                    colors: [
                      scheme.primary.withValues(alpha: 0.9),
                      scheme.tertiary.withValues(alpha: 0.9),
                    ],
                  ),
                ),
                child: Icon(Icons.public_rounded, color: scheme.onPrimary, size: 24),
              ),
              const SizedBox(height: 12),
              Text(
                l10n.dialogAuthRequiredTitle,
                style: TextStyle(
                  color: scheme.onSurface,
                  fontWeight: FontWeight.w900,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                l10n.dialogAuthRequiredBody,
                style: TextStyle(
                  color: scheme.onSurface.withValues(alpha: 0.75),
                  fontWeight: FontWeight.w600,
                  height: 1.35,
                ),
              ),
              const SizedBox(height: 10),
              _BenefitRow(label: 'Live circles with real learners'),
              _BenefitRow(label: 'Voice rooms with instant practice'),
              _BenefitRow(label: 'Friend challenges and saved progress'),
              const SizedBox(height: 18),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(ctx),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: scheme.onSurface,
                        side: BorderSide(color: scheme.onSurface.withValues(alpha: 0.25)),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      child: Text(l10n.notNow),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(ctx);
                        _openAuthFlow(const SignInScreen());
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: scheme.primary,
                        foregroundColor: scheme.onPrimary,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      child: Text(l10n.signIn),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () {
                    Navigator.pop(ctx);
                    _openAuthFlow(const SignUpScreen());
                  },
                  child: Text(
                    l10n.signUp,
                    style: TextStyle(color: scheme.tertiary, fontWeight: FontWeight.w800),
                  ),
                ),
              ),
            ],
          ),
        ),
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

        final contentSlot = isWide
            ? Row(
                children: [
                  _SomaSideNav(
                    index: _index,
                    onChanged: _handleNavChange,
                  ),
                  Expanded(child: activePage),
                ],
              )
            : activePage;

        final topOverlaySlot = StreamBuilder<Map<String, dynamic>>(
          stream: settingsRepository.getSettingsStream(),
          builder: (context, snapshot) {
            final call = snapshot.data?['dm_active_call'];
            final isActive = call is Map && call['active'] == true;
            final name = call is Map ? (call['other_name']?.toString() ?? 'Voice call') : 'Voice call';
            final otherId = call is Map ? call['other_id']?.toString() : null;
            if (!isActive) return const SizedBox.shrink();
            return Positioned(
              right: 14,
              top: 16,
              child: _GlobalActiveCallPill(
                name: name,
                onTap: otherId == null || otherId.isEmpty
                    ? null
                    : () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => DmChatScreen(
                              meId: authRepository.currentUser?.id ?? '',
                              otherId: otherId,
                              otherName: name,
                            ),
                          ),
                        );
                      },
              ),
            );
          },
        );

        final floatingContextActionSlot = const SizedBox.shrink();

        final bottomNavSlot = isWide
            ? null
            : _SomaBottomNav(
                index: _index,
                onChanged: _handleNavChange,
              );

        return Scaffold(
          backgroundColor: Colors.transparent,
          body: Stack(
            children: [
              contentSlot,
              topOverlaySlot,
              floatingContextActionSlot,
            ],
          ),
          bottomNavigationBar: bottomNavSlot,
        );
      },
    );
  }
}

class _GlobalActiveCallPill extends StatelessWidget {
  final String name;
  final VoidCallback? onTap;
  const _GlobalActiveCallPill({required this.name, this.onTap});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: Glass(
        radius: BorderRadius.circular(999),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.call_rounded, size: 16, color: scheme.primary),
            const SizedBox(width: 6),
            Text(
              'In call • $name',
              style: TextStyle(
                color: scheme.onSurface,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class _BenefitRow extends StatelessWidget {
  final String label;

  const _BenefitRow({required this.label});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Icon(Icons.check_circle_rounded,
              size: 16, color: scheme.tertiary.withValues(alpha: 0.9)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                color: scheme.onSurface.withValues(alpha: 0.78),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
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
    final scheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final color = selected
        ? (isDark ? const Color(0xFF36F4E8) : scheme.primary)
        : scheme.onSurface.withValues(alpha: 0.65);
    final bg = selected
        ? (isDark
            ? const Color(0xFF3A3568)
            : Color.alphaBlend(scheme.primary.withValues(alpha: 0.16), scheme.surface))
        : Colors.transparent;
    final border = selected
        ? (isDark ? const Color(0xFF6B5CFF) : scheme.primary.withValues(alpha: 0.35))
        : Colors.transparent;

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
    final scheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final color = selected
        ? (isDark ? const Color(0xFF36F4E8) : scheme.primary)
        : scheme.onSurface.withValues(alpha: 0.65);
    final bg = selected
        ? (isDark
            ? const Color(0xFF3A3568)
            : Color.alphaBlend(scheme.primary.withValues(alpha: 0.16), scheme.surface))
        : Colors.transparent;
    final border = selected
        ? (isDark ? const Color(0xFF6B5CFF) : scheme.primary.withValues(alpha: 0.35))
        : Colors.transparent;

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
