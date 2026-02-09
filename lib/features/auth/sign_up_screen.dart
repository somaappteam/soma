import 'package:flutter/material.dart';
import 'package:soma/l10n/gen/app_localizations.dart';
import '../home/app_shell.dart';
import '../../core/widgets/glass.dart';
import '../../core/widgets/neon_button.dart';
import '../../data/auth_repository.dart';
import '../../data/profile_store.dart';
import '../../core/widgets/responsive.dart';
import '../../core/theme/tokens.dart';
import 'sign_in_screen.dart';
import '../../core/widgets/premium_dialog.dart';


class SignUpScreen extends StatefulWidget {
  final VoidCallback? onSignedUp;
  const SignUpScreen({super.key, this.onSignedUp});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _username = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();

  bool _isLoading = false;
  bool _obscure = true;

  Future<void> _handleSignUp() async {
    final l10n = AppLocalizations.of(context);
    final username = _username.text.trim();
    final email = _email.text.trim();
    final password = _password.text.trim();

    if (username.isEmpty || email.isEmpty || password.isEmpty) {
      await showPremiumDialog(
        context: context,
        title: l10n.signUp,
        body: l10n.authFillAllFields,
        confirmText: l10n.ok,
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      await authRepository.signUp(
        email: email,
        password: password,
        username: username,
      );

      // Refresh profile state for the app
      await profileStore.load();

      if (widget.onSignedUp != null) {
        widget.onSignedUp!();
        if (mounted) {
          Navigator.pop(context);
        }
        return;
      }
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const AppShell()),
        );
      }
    } catch (e) {
      if (mounted) {
        await showPremiumDialog(
          context: context,
          title: l10n.signUp,
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

  @override
  void dispose() {
    _username.dispose();
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                          onTap: () {},
                        ),
                      ],
                    ),

                    const Spacer(flex: 10),

                    // Title
                    Center(
                      child: Text(
                        l10n.signUp,
                        style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                            ),
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Glass Card
                    Glass(
                      radius: BorderRadius.circular(26),
                      padding: const EdgeInsets.fromLTRB(18, 18, 18, 16),
                      child: Column(
                        children: [
                          _GlassTextField(
                            controller: _username,
                            hint: l10n.authUsername,
                            icon: Icons.person_outline_rounded,
                            keyboardType: TextInputType.name,
                            obscure: false,
                            onToggleObscure: null,
                          ),
                          const SizedBox(height: 12),
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
                            onToggleObscure: () => setState(() => _obscure = !_obscure),
                          ),
                          const SizedBox(height: 18),

                          SizedBox(
                            width: double.infinity,
                            child: NeonButton(
                              label: _isLoading ? l10n.authCreating : l10n.authCreateAccount,
                              onTap: _isLoading ? () {} : _handleSignUp,
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
                          MaterialPageRoute(builder: (_) => const SignInScreen()),
                        ),
                        child: Text.rich(
                          TextSpan(
                            text: l10n.authHaveAccount,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: Colors.white.withValues(alpha: 0.72),
                                ),
                            children: [
                              TextSpan(
                                text: l10n.signIn,
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w800,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    const Spacer(flex: 16),
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
  Widget build(BuildContext context) {
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
              color: Colors.white,
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
  Widget build(BuildContext context) {
    return Container(
      height: 54,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: T.fieldFill,
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.16),
          width: 1,
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Row(
        children: [
          Icon(icon, color: Colors.white.withValues(alpha: 0.85), size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: controller,
              obscureText: obscure,
              keyboardType: keyboardType,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: TextStyle(
                  color: Colors.white.withValues(alpha: 0.45),
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
                obscure ? Icons.visibility_off_rounded : Icons.visibility_rounded,
                color: Colors.white.withValues(alpha: 0.75),
                size: 20,
              ),
            ),
        ],
      ),
    );
  }
}
