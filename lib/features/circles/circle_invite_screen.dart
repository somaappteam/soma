import 'package:flutter/material.dart';
import 'package:soma/core/widgets/glass.dart';
import 'package:soma/core/widgets/neon_button.dart';
import 'package:soma/core/widgets/responsive.dart';
import 'package:soma/data/auth_repository.dart';
import 'package:soma/data/circles_repository.dart';
import 'package:soma/features/auth/sign_in_screen.dart';
import 'package:soma/features/auth/sign_up_screen.dart';
import 'package:soma/features/circles/circle_lobby_screen.dart';
import 'package:soma/l10n/gen/app_localizations.dart';

class CircleInviteScreen extends StatefulWidget {
  final String circleId;
  final String? circleTitle;

  const CircleInviteScreen({
    super.key,
    required this.circleId,
    this.circleTitle,
  });

  @override
  State<CircleInviteScreen> createState() => _CircleInviteScreenState();
}

class _CircleInviteScreenState extends State<CircleInviteScreen> {
  bool _isLoading = false;
  String? _error;

  bool get _isGuest => authRepository.currentUser == null;

  @override
  void initState() {
    super.initState();
    if (!_isGuest) {
      _attemptJoin();
    }
  }

  Future<void> _attemptJoin() async {
    final l10n = AppLocalizations.of(context);
    if (_isLoading) return;
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final outcome =
          await circlesRepository.joinCircleFromInvite(widget.circleId);
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (final _) => CircleLobbyScreen(circleId: widget.circleId),
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            outcome.role == 'player'
                ? l10n.circleJoinedAsPlayer
                : l10n.circleJoinedAsSpectator,
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final title = widget.circleTitle ?? l10n.circleInviteTitle;

    return Scaffold(
      body: SafeArea(
        child: ResponsiveFrame(
          maxWidth: 420,
          child: LayoutBuilder(
            builder: (final context, final constraints) {
              final compactHeight = constraints.maxHeight < 760;
              final sectionSpacing = compactHeight ? 12.0 : 16.0;

              return Padding(
                padding: const EdgeInsets.fromLTRB(18, 14, 18, 12),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Glass(
                          radius: BorderRadius.circular(14),
                          padding: EdgeInsets.zero,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(14),
                            onTap: () => Navigator.pop(context),
                            child: const SizedBox(
                              width: 44,
                              height: 44,
                              child: Center(
                                child: Icon(Icons.arrow_back_ios_new_rounded,
                                    color: Colors.white, size: 20),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Circle Invite',
                          style:
                              Theme.of(context).textTheme.titleLarge?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w900,
                                  ),
                        ),
                      ],
                    ),
                    SizedBox(height: sectionSpacing),
                    Glass(
                      radius: BorderRadius.circular(24),
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w900,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            l10n.circleIdLabel(widget.circleId),
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.7),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          if (_error != null) ...[
                            const SizedBox(height: 10),
                            Text(
                              _error!,
                              style: const TextStyle(
                                color: Color(0xFFFF6B6B),
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    const Spacer(),
                    if (_isGuest) ...[
                      NeonButton(
                        label: l10n.signInToJoin,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (final _) =>
                                  SignInScreen(onSignedIn: _attemptJoin),
                            ),
                          );
                        },
                      ),
                      SizedBox(height: compactHeight ? 10 : 12),
                      Glass(
                        radius: BorderRadius.circular(999),
                        padding: EdgeInsets.zero,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(999),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (final _) =>
                                    SignUpScreen(onSignedUp: _attemptJoin),
                              ),
                            );
                          },
                          child: SizedBox(
                            height: 56,
                            child: Center(
                              child: Text(
                                l10n.authCreateAccount,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ] else ...[
                      NeonButton(
                        label:
                            _isLoading ? l10n.joiningCircle : l10n.joinCircle,
                        onTap: _isLoading ? null : _attemptJoin,
                      ),
                    ],
                    SizedBox(height: compactHeight ? 14 : 18),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
