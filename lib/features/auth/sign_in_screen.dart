import 'package:flutter/material.dart';
import 'package:soma/core/theme/tokens.dart';
import 'package:soma/core/widgets/glass.dart';
import 'package:soma/core/widgets/neon_button.dart';
import 'package:soma/core/widgets/premium_dialog.dart';
import 'package:soma/core/widgets/responsive.dart';
import 'package:soma/data/auth_repository.dart';
import 'package:soma/data/profile_store.dart';
import 'package:soma/features/auth/sign_up_screen.dart';
import 'package:soma/features/home/app_shell.dart';
import 'package:soma/features/info/about_screen.dart';
import 'package:soma/l10n/gen/app_localizations.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SignInScreen extends StatefulWidget {
  final VoidCallback? onSignedIn;
  const SignInScreen({super.key, this.onSignedIn});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _obscure = true;
  bool _isLoading = false;
  bool _isSendingReset = false;

  Future<void> _handleSignIn() async {
    final l10n = AppLocalizations.of(context);
    final email = _email.text.trim();
    final password = _password.text.trim();

    if (email.isEmpty || password.isEmpty) {
      await showPremiumDialog(
        context: context,
        title: l10n.signIn,
        body: l10n.authFillAllFields,
        confirmText: l10n.ok,
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      await authRepository.signIn(
        email: email,
        password: password,
      );

      // Refresh profile state for the app
      await profileStore.load();

      if (widget.onSignedIn != null) {
        widget.onSignedIn!();
        if (mounted) {
          Navigator.pop(context);
        }
        return;
      }
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (final _) => const AppShell()),
        );
      }
    } catch (e) {
      if (mounted) {
        await showPremiumDialog(
          context: context,
          title: l10n.signIn,
          body: l10n.authError(e.toString()),
          confirmText: l10n.ok,
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _handleOAuthSignIn(final OAuthProvider provider) async {
    final l10n = AppLocalizations.of(context);
    try {
      await authRepository.signInWithOAuth(provider);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('${provider.name.toUpperCase()} ${l10n.signIn}...')),
      );
    } catch (e) {
      if (!mounted) return;
      await showPremiumDialog(
        context: context,
        title: l10n.signIn,
        body: l10n.authError(e.toString()),
        confirmText: l10n.ok,
      );
    }
  }

  Future<void> _handleStarTap() async {
    if (!mounted) return;
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (final _) => const AboutScreen(view: AboutView.version),
      ),
    );
  }

  Future<void> _showResetPasswordDialog() async {
    final l10n = AppLocalizations.of(context);
    final controller = TextEditingController(text: _email.text.trim());
    final confirmed = await showDialog<bool>(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.55),
      builder: (final _) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 24),
        child: Glass(
          radius: BorderRadius.circular(24),
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 18),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.authForgotPasswordTitle,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                l10n.authForgotPasswordBody,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.7),
                  fontSize: 13.5,
                  fontWeight: FontWeight.w600,
                  height: 1.35,
                ),
              ),
              const SizedBox(height: 14),
              Container(
                height: 52,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: T.fieldFill,
                  border:
                      Border.all(color: Colors.white.withValues(alpha: 0.12)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.mail_outline_rounded,
                        color: Colors.white.withValues(alpha: 0.85), size: 20),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: controller,
                        keyboardType: TextInputType.emailAddress,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                        decoration: InputDecoration(
                          hintText: l10n.authEmail,
                          hintStyle: TextStyle(
                            color: Colors.white.withValues(alpha: 0.45),
                            fontWeight: FontWeight.w600,
                          ),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context, false),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        side: BorderSide(
                            color: Colors.white.withValues(alpha: 0.25)),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14)),
                      ),
                      child: Text(l10n.cancel),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context, true),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor:
                            Theme.of(context).colorScheme.onPrimary,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14)),
                      ),
                      child: Text(l10n.authSendResetLink),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );

    if (confirmed != true) return;
    final email = controller.text.trim();
    if (email.isEmpty) {
      if (!mounted) return;
      await showPremiumDialog(
        context: context,
        title: l10n.authForgotPasswordTitle,
        body: l10n.authFillAllFields,
        confirmText: l10n.ok,
      );
      return;
    }
    if (!mounted) return;
    setState(() => _isSendingReset = true);
    try {
      await authRepository.resetPassword(email: email);
      if (!mounted) return;
      await showPremiumDialog(
        context: context,
        title: l10n.authResetSentTitle,
        body: l10n.authResetSentBody,
        confirmText: l10n.ok,
      );
    } catch (e) {
      if (!mounted) return;
      await showPremiumDialog(
        context: context,
        title: l10n.authResetFailedTitle,
        body: l10n.authError(e.toString()),
        confirmText: l10n.ok,
      );
    } finally {
      if (mounted) {
        setState(() => _isSendingReset = false);
      }
    }
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      body: SafeArea(
        child: ResponsiveFrame(
          maxWidth: 430,
          child: ResponsiveScroll(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // top row
                  Row(
                    children: [
                      _IconGlassButton(
                        icon: Icons.arrow_back_rounded,
                        onTap: () => Navigator.pop(context),
                      ),
                      const Spacer(),
                      _IconGlassButton(
                        icon: Icons.star_rounded,
                        onTap: _handleStarTap,
                      ),
                    ],
                  ),

                  const SizedBox(height: 60),

                  // Title
                  Center(
                    child: Text(
                      l10n.signIn,
                      style:
                          Theme.of(context).textTheme.headlineLarge?.copyWith(
                                fontWeight: FontWeight.w900,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                    ),
                  ),
                  const SizedBox(height: 14),

                  // glass card
                  Glass(
                    radius: BorderRadius.circular(26),
                    padding: const EdgeInsets.fromLTRB(18, 18, 18, 16),
                    child: Column(
                      children: [
                        _GlassTextField(
                          controller: _email,
                          hint: l10n.authEmail,
                          icon: Icons.mail_outline_rounded,
                          keyboardType: TextInputType.emailAddress,
                          obscure: false,
                          onToggleObscure: null,
                        ),
                        const SizedBox(height: 12),
                        _GlassTextField(
                          controller: _password,
                          hint: l10n.authPassword,
                          icon: Icons.lock_outline_rounded,
                          keyboardType: TextInputType.visiblePassword,
                          obscure: _obscure,
                          onToggleObscure: () =>
                              setState(() => _obscure = !_obscure),
                        ),
                        const SizedBox(height: 8),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: _isSendingReset
                                ? null
                                : _showResetPasswordDialog,
                            child: Text(l10n.authForgotPassword),
                          ),
                        ),
                        const SizedBox(height: 18),
                        SizedBox(
                          width: double.infinity,
                          child: NeonButton(
                            label: _isLoading
                                ? l10n.authSigningIn
                                : l10n.authContinue,
                            onTap: _isLoading ? () {} : _handleSignIn,
                          ),
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            onPressed: _isLoading
                                ? null
                                : () =>
                                    _handleOAuthSignIn(OAuthProvider.facebook),
                            icon: const Icon(Icons.facebook_rounded),
                            label: const Text('Continue with Facebook'),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 14),

                  // bottom link
                  Center(
                    child: InkWell(
                      onTap: () => Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (final _) => const SignUpScreen()),
                      ),
                      child: Text.rich(
                        TextSpan(
                          text: l10n.authHaveAccount,
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface
                                        .withValues(alpha: 0.72),
                                  ),
                          children: [
                            TextSpan(
                              text: l10n.signUp,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    fontWeight: FontWeight.w800,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _IconGlassButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _IconGlassButton({
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(final BuildContext context) {
    return Glass(
      radius: BorderRadius.circular(14),
      padding: EdgeInsets.zero,
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: SizedBox(
          width: 44,
          height: 44,
          child: Center(
            child: Icon(
              icon,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ),
      ),
    );
  }
}

class _GlassTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final IconData icon;
  final TextInputType keyboardType;
  final bool obscure;
  final VoidCallback? onToggleObscure;

  const _GlassTextField({
    required this.controller,
    required this.hint,
    required this.icon,
    required this.keyboardType,
    required this.obscure,
    required this.onToggleObscure,
  });

  @override
  Widget build(final BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isLight = Theme.of(context).brightness == Brightness.light;

    return Container(
      height: 54,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: isLight ? scheme.surfaceContainerHighest : T.fieldFill,
        border: Border.all(
          color: scheme.onSurface.withValues(alpha: 0.16),
          width: 1,
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Row(
        children: [
          Icon(icon, color: scheme.onSurface.withValues(alpha: 0.85), size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: controller,
              obscureText: obscure,
              keyboardType: keyboardType,
              style: TextStyle(
                color: scheme.onSurface,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: TextStyle(
                  color: scheme.onSurface.withValues(alpha: 0.45),
                  fontWeight: FontWeight.w600,
                ),
                border: InputBorder.none,
              ),
            ),
          ),
          if (onToggleObscure != null)
            IconButton(
              onPressed: onToggleObscure,
              icon: Icon(
                obscure
                    ? Icons.visibility_off_rounded
                    : Icons.visibility_rounded,
                color: scheme.onSurface.withValues(alpha: 0.75),
                size: 20,
              ),
            ),
        ],
      ),
    );
  }
}
