import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:soma/core/theme/tokens.dart';
import 'package:soma/core/widgets/glass.dart';
import 'package:soma/core/widgets/responsive.dart';
import 'package:soma/core/widgets/selection_controls.dart';
import 'package:soma/data/auth_repository.dart';
import 'package:soma/data/session_repository.dart';
import 'package:soma/data/settings_repository.dart';
import 'package:soma/l10n/gen/app_localizations.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SecuritySettingsScreen extends StatefulWidget {
  const SecuritySettingsScreen({super.key});

  @override
  State<SecuritySettingsScreen> createState() => _SecuritySettingsScreenState();
}

class _SecuritySettingsScreenState extends State<SecuritySettingsScreen> {
  late Stream<Map<String, dynamic>> _settingsStream;
  final _supabase = Supabase.instance.client;
  bool _mfaLoading = true;
  bool _twoFactorEnabled = false;

  @override
  void initState() {
    super.initState();
    _settingsStream = settingsRepository.getSettingsStream();
    _loadMfaStatus();
  }

  Future<void> _loadMfaStatus() async {
    try {
      final factors = await _supabase.auth.mfa.listFactors();
      if (!mounted) return;
      setState(() {
        _twoFactorEnabled = factors.totp.isNotEmpty || factors.phone.isNotEmpty;
        _mfaLoading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _mfaLoading = false);
    }
  }

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      body: SafeArea(
        child: ResponsiveFrame(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(18, 14, 18, 12),
            child: Column(
              children: [
                // Header
                Row(
                  children: [
                    _IconBtn(
                      icon: Icons.arrow_back_ios_new_rounded,
                      onTap: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      l10n.securityTitle,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: Theme.of(context).colorScheme.onSurface,
                            fontWeight: FontWeight.w900,
                          ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                Expanded(
                  child: StreamBuilder<Map<String, dynamic>>(
                      stream: _settingsStream,
                      builder: (final context, final snapshot) {
                        final data = snapshot.data ?? {};
                        final twoFactor = _twoFactorEnabled;
                        final biometric = data['biometric_enabled'] ?? false;
                        final appLock = data['app_lock_enabled'] ?? false;
                        final autoLockMinutes = data['auto_lock_minutes'] ?? 5;

                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }

                        return ListView(
                          physics: const BouncingScrollPhysics(),
                          children: [
                            // Password
                            _SectionTitle(l10n.securitySectionPassword),
                            _Tile(
                              icon: Icons.lock_rounded,
                              title: l10n.securityChangePasswordTitle,
                              subtitle: l10n.securityChangePasswordSubtitle,
                              onTap: () => _openChangePassword(context),
                            ),

                            const SizedBox(height: 14),

                            // 2FA
                            _SectionTitle(l10n.securitySectionTwoFactor),
                            _SwitchTile(
                              icon: Icons.verified_user_rounded,
                              title: l10n.securityEnable2faTitle,
                              subtitle: l10n.securityEnable2faSubtitle,
                              value: twoFactor,
                              onChanged: _mfaLoading
                                  ? null
                                  : (final v) async {
                                      if (v) {
                                        await _startMfaSetup(context);
                                      } else {
                                        await _disableMfa(context);
                                      }
                                    },
                            ),

                            const SizedBox(height: 14),

                            // App lock / biometrics
                            _SectionTitle(l10n.securitySectionAppLock),
                            _SwitchTile(
                              icon: Icons.fingerprint_rounded,
                              title: l10n.securityBiometricTitle,
                              subtitle: l10n.securityBiometricSubtitle,
                              value: biometric,
                              onChanged: (final v) => settingsRepository
                                  .updateSetting('biometric_enabled', v),
                            ),
                            const SizedBox(height: 10),
                            _SwitchTile(
                              icon: Icons.shield_rounded,
                              title: l10n.securityAppLockTitle,
                              subtitle: l10n.securityAppLockSubtitle,
                              value: appLock,
                              onChanged: (final v) => settingsRepository
                                  .updateSetting('app_lock_enabled', v),
                            ),
                            const SizedBox(height: 10),
                            _AutoLockRow(
                              enabled: appLock,
                              minutes: autoLockMinutes,
                              onPick: (final m) => settingsRepository
                                  .updateSetting('auto_lock_minutes', m),
                            ),

                            const SizedBox(height: 14),

                            // Sessions
                            _SectionTitle(l10n.securitySectionSessions),
                            Glass(
                              radius: BorderRadius.circular(24),
                              padding: const EdgeInsets.all(16),
                              child: StreamBuilder<List<UserSession>>(
                                stream: sessionRepository.streamSessions(),
                                builder: (final context, final snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const Center(
                                        child: CircularProgressIndicator());
                                  }

                                  final sessions = snapshot.data ?? [];
                                  if (sessions.isEmpty) {
                                    return Text(
                                      l10n.securityNoSessions,
                                      style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface
                                            .withValues(alpha: 0.75),
                                        fontWeight: FontWeight.w700,
                                      ),
                                    );
                                  }

                                  return Column(
                                    children: sessions.map((final s) {
                                      final label = s.isCurrent
                                          ? l10n.securityThisDevice
                                          : (s.deviceName ??
                                              l10n.securityDevice);
                                      final platform =
                                          s.platform ?? l10n.unknown;
                                      return Container(
                                        margin:
                                            const EdgeInsets.only(bottom: 10),
                                        padding: const EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(18),
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSurface
                                              .withValues(alpha: 0.06),
                                          border: Border.all(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onSurface
                                                  .withValues(alpha: 0.12)),
                                        ),
                                        child: Row(
                                          children: [
                                            Container(
                                              width: 40,
                                              height: 40,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(14),
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onSurface
                                                    .withValues(alpha: 0.08),
                                                border: Border.all(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .onSurface
                                                        .withValues(
                                                            alpha: 0.12)),
                                              ),
                                              child: Icon(Icons.devices_rounded,
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .onSurface
                                                      .withValues(alpha: 0.9)),
                                            ),
                                            const SizedBox(width: 12),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    label,
                                                    style: TextStyle(
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .onSurface,
                                                      fontWeight:
                                                          FontWeight.w900,
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 4),
                                                  Text(
                                                    '${platform.toUpperCase()} • ${_formatSeen(s.lastSeen)}',
                                                    style: TextStyle(
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .onSurface
                                                          .withValues(
                                                              alpha: 0.65),
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            if (s.isCurrent)
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 10,
                                                        vertical: 6),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          999),
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .onSurface
                                                      .withValues(alpha: 0.12),
                                                  border: Border.all(
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .onSurface
                                                          .withValues(
                                                              alpha: 0.22)),
                                                ),
                                                child: Text(
                                                  l10n.securityActiveLabel,
                                                  style: TextStyle(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .onSurface,
                                                    fontWeight: FontWeight.w800,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ),
                                          ],
                                        ),
                                      );
                                    }).toList(),
                                  );
                                },
                              ),
                            ),

                            const SizedBox(height: 14),
                          ],
                        );
                      }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _openChangePassword(final BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (final _) => const _ChangePasswordSheet(),
    );
  }

  Future<void> _startMfaSetup(final BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    if (authRepository.currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.securitySignInToEnable2fa)),
      );
      return;
    }

    try {
      final enroll = await _supabase.auth.mfa.enroll(
        factorType: FactorType.totp,
        issuer: 'SOMA',
        friendlyName: 'SOMA Authenticator',
      );

      final totp = enroll.totp;
      if (totp == null) throw Exception('Failed to create TOTP');

      if (!context.mounted) return;
      await showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        builder: (final _) => _MfaSetupSheet(
          factorId: enroll.id,
          qrCode: totp.qrCode,
          secret: totp.secret,
          onVerified: () {
            Navigator.pop(context);
          },
        ),
      );

      await _loadMfaStatus();
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.securityEnable2faFailed(e.toString()))),
      );
    }
  }

  Future<void> _disableMfa(final BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    try {
      final factors = await _supabase.auth.mfa.listFactors();
      for (final factor in factors.totp) {
        await _supabase.auth.mfa.unenroll(factor.id);
      }
      for (final factor in factors.phone) {
        await _supabase.auth.mfa.unenroll(factor.id);
      }

      await _loadMfaStatus();
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.securityDisable2faFailed(e.toString()))),
      );
    }
  }

  String _formatSeen(final DateTime dt) {
    final l10n = AppLocalizations.of(context);
    final now = DateTime.now();
    final diff = now.difference(dt);
    if (diff.inMinutes < 1) return l10n.timeJustNow;
    if (diff.inMinutes < 60) return l10n.timeMinutesAgo(diff.inMinutes);
    if (diff.inHours < 24) return l10n.timeHoursAgo(diff.inHours);
    return l10n.timeDaysAgo(diff.inDays);
  }
}

// ---------------- UI pieces ----------------

class _IconBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _IconBtn({required this.icon, required this.onTap});

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
            child: Icon(icon,
                color: Theme.of(context)
                    .colorScheme
                    .onSurface
                    .withValues(alpha: 0.9),
                size: 20),
          ),
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);

  @override
  Widget build(final BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 10),
      child: Text(
        text,
        style: TextStyle(
          color:
              Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.75),
          fontWeight: FontWeight.w900,
          fontSize: 12.5,
          letterSpacing: 0.2,
        ),
      ),
    );
  }
}

class _Tile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _Tile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(final BuildContext context) {
    return Glass(
      radius: BorderRadius.circular(24),
      padding: EdgeInsets.zero,
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
          child: Row(
            children: [
              _IconBox(icon: icon),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface,
                            fontWeight: FontWeight.w900,
                            fontSize: 15)),
                    const SizedBox(height: 4),
                    Text(subtitle,
                        style: TextStyle(
                            color: Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withValues(alpha: 0.62),
                            fontWeight: FontWeight.w700,
                            height: 1.2)),
                  ],
                ),
              ),
              Icon(Icons.chevron_right_rounded,
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withValues(alpha: 0.75)),
            ],
          ),
        ),
      ),
    );
  }
}

class _SwitchTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool>? onChanged;

  const _SwitchTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(final BuildContext context) {
    return Glass(
      radius: BorderRadius.circular(24),
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
      child: Row(
        children: [
          _IconBox(icon: icon),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                        fontWeight: FontWeight.w900,
                        fontSize: 15)),
                const SizedBox(height: 4),
                Text(subtitle,
                    style: TextStyle(
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withValues(alpha: 0.62),
                        fontWeight: FontWeight.w700,
                        height: 1.2)),
              ],
            ),
          ),
          AppNeonSwitch(value: value, onChanged: onChanged),
        ],
      ),
    );
  }
}

class _AutoLockRow extends StatelessWidget {
  final bool enabled;
  final int minutes;
  final ValueChanged<int> onPick;

  const _AutoLockRow(
      {required this.enabled, required this.minutes, required this.onPick});

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final options = const [1, 5, 15];
    return Glass(
      radius: BorderRadius.circular(24),
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      child: Row(
        children: [
          _IconBox(icon: Icons.timer_rounded),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              l10n.securityAutoLockAfter,
              style: TextStyle(
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withValues(alpha: 0.85),
                  fontWeight: FontWeight.w900,
                  fontSize: 14),
            ),
          ),
          Opacity(
            opacity: enabled ? 1 : 0.45,
            child: Row(
              children: options.map((final m) {
                final selected = m == minutes;
                return Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: AppSelectablePill(
                    label: l10n.minutesShort(m),
                    selected: selected,
                    onTap: enabled ? () => onPick(m) : null,
                    fontSize: 12.5,
                    height: 36,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _IconBox extends StatelessWidget {
  final IconData icon;
  const _IconBox({required this.icon});

  @override
  Widget build(final BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.08),
        border: Border.all(
            color: Theme.of(context)
                .colorScheme
                .onSurface
                .withValues(alpha: 0.12)),
      ),
      child: Icon(icon,
          color:
              Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.92),
          size: 22),
    );
  }
}

class _MfaSetupSheet extends StatefulWidget {
  final String factorId;
  final String qrCode;
  final String secret;
  final VoidCallback onVerified;

  const _MfaSetupSheet({
    required this.factorId,
    required this.qrCode,
    required this.secret,
    required this.onVerified,
  });

  @override
  State<_MfaSetupSheet> createState() => _MfaSetupSheetState();
}

class _MfaSetupSheetState extends State<_MfaSetupSheet> {
  final _codeCtrl = TextEditingController();
  bool _isVerifying = false;

  @override
  void dispose() {
    _codeCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final svgData = _parseSvg(widget.qrCode);
    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
        top: 10,
      ),
      child: Glass(
        radius: BorderRadius.circular(24),
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.securitySetup2faTitle,
              style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontWeight: FontWeight.w900,
                  fontSize: 16),
            ),
            const SizedBox(height: 10),
            Center(
              child: SvgPicture.string(
                svgData,
                width: 180,
                height: 180,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              l10n.securitySecretKeyLabel,
              style: TextStyle(
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withValues(alpha: 0.75),
                  fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 6),
            SelectableText(
              widget.secret,
              style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 12),
            _Input(_codeCtrl,
                hint: l10n.securityCodeHint,
                obscure: false,
                onChanged: () => setState(() {})),
            const SizedBox(height: 12),
            InkWell(
              borderRadius: BorderRadius.circular(999),
              onTap: _isVerifying
                  ? null
                  : () async {
                      final code = _codeCtrl.text.trim();
                      if (code.isEmpty) return;
                      setState(() => _isVerifying = true);
                      try {
                        await Supabase.instance.client.auth.mfa
                            .challengeAndVerify(
                                factorId: widget.factorId, code: code);
                        if (!context.mounted) return;
                        widget.onVerified();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(l10n.security2faEnabled)),
                        );
                      } catch (e) {
                        if (!context.mounted) return;
                        setState(() => _isVerifying = false);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text(
                                  l10n.securityVerifyCodeFailed(e.toString()))),
                        );
                      }
                    },
              child: Container(
                height: 46,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(999),
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withValues(alpha: 0.10),
                  border: Border.all(
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withValues(alpha: 0.14)),
                ),
                alignment: Alignment.center,
                child: Text(
                  _isVerifying ? l10n.securityVerifying : l10n.securityVerify,
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface,
                      fontWeight: FontWeight.w900,
                      fontSize: 14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _parseSvg(final String dataUri) {
    try {
      final uri = Uri.parse(dataUri);
      if (uri.scheme == 'data') {
        return UriData.parse(dataUri).contentAsString();
      }
    } catch (_) {
      // ignore
    }
    return dataUri;
  }
}

class _ChangePasswordSheet extends StatefulWidget {
  const _ChangePasswordSheet();

  @override
  State<_ChangePasswordSheet> createState() => _ChangePasswordSheetState();
}

class _ChangePasswordSheetState extends State<_ChangePasswordSheet> {
  final oldCtrl = TextEditingController();
  final newCtrl = TextEditingController();
  final confirmCtrl = TextEditingController();
  bool _isSaving = false;

  @override
  void dispose() {
    oldCtrl.dispose();
    newCtrl.dispose();
    confirmCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);
    // In a real app we'd trigger a reload of the build to enable/disable button
    // For now we just check controllers

    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
        top: 10,
      ),
      child: Glass(
        radius: BorderRadius.circular(24),
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(l10n.securityChangePasswordTitle,
                style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontWeight: FontWeight.w900,
                    fontSize: 16)),
            const SizedBox(height: 12),
            _Input(oldCtrl,
                hint: l10n.securityCurrentPasswordHint,
                obscure: true,
                onChanged: () => setState(() {})),
            const SizedBox(height: 10),
            _Input(newCtrl,
                hint: l10n.securityNewPasswordHint,
                obscure: true,
                onChanged: () => setState(() {})),
            const SizedBox(height: 10),
            _Input(confirmCtrl,
                hint: l10n.securityConfirmPasswordHint,
                obscure: true,
                onChanged: () => setState(() {})),
            const SizedBox(height: 12),
            InkWell(
              borderRadius: BorderRadius.circular(999),
              onTap: _isSaving
                  ? null
                  : () async {
                      if (authRepository.currentUser == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content:
                                  Text(l10n.securitySignInToChangePassword)),
                        );
                        return;
                      }

                      final current = oldCtrl.text.trim();
                      final next = newCtrl.text.trim();
                      final confirm = confirmCtrl.text.trim();

                      if (current.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text(l10n.securityEnterCurrentPassword)),
                        );
                        return;
                      }
                      if (next.length < 8) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text(l10n.securityPasswordMinLength)),
                        );
                        return;
                      }
                      if (next != confirm) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text(l10n.securityPasswordsDoNotMatch)),
                        );
                        return;
                      }

                      setState(() => _isSaving = true);
                      try {
                        await authRepository.updatePassword(next);
                        if (!context.mounted) return;
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(l10n.securityPasswordUpdated)),
                        );
                      } catch (e) {
                        if (!context.mounted) return;
                        setState(() => _isSaving = false);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text(l10n
                                  .securityPasswordUpdateFailed(e.toString()))),
                        );
                      }
                    },
              child: Container(
                height: 46,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(999),
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withValues(alpha: 0.10),
                  border: Border.all(
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withValues(alpha: 0.14)),
                ),
                alignment: Alignment.center,
                child: Text(l10n.save,
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                        fontWeight: FontWeight.w900,
                        fontSize: 14)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Input extends StatelessWidget {
  final TextEditingController c;
  final String hint;
  final bool obscure;
  final VoidCallback onChanged;

  const _Input(this.c,
      {required this.hint, required this.obscure, required this.onChanged});

  @override
  Widget build(final BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: Theme.of(context).brightness == Brightness.light
            ? Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.08)
            : T.fieldFill,
        border: Border.all(
            color: Theme.of(context)
                .colorScheme
                .onSurface
                .withValues(alpha: 0.12)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: TextField(
        controller: c,
        obscureText: obscure,
        onChanged: (final _) => onChanged(),
        style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
            fontWeight: FontWeight.w800,
            fontSize: 14.5),
        cursorColor: Theme.of(context).colorScheme.primary,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(
              color: Theme.of(context)
                  .colorScheme
                  .onSurface
                  .withValues(alpha: 0.45),
              fontWeight: FontWeight.w700),
          border: InputBorder.none,
          isDense: true,
        ),
      ),
    );
  }
}
