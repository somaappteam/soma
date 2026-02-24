import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';

import 'package:soma/data/settings_repository.dart';

class AppLockGate extends StatefulWidget {
  final Widget child;

  const AppLockGate({super.key, required this.child});

  @override
  State<AppLockGate> createState() => _AppLockGateState();
}

class _AppLockGateState extends State<AppLockGate> with WidgetsBindingObserver {
  final LocalAuthentication _auth = LocalAuthentication();
  DateTime? _lastInactive;
  bool _locked = false;
  bool _appLockEnabled = false;
  bool _biometricEnabled = false;
  int _autoLockMinutes = 5;
  bool _authInProgress = false;
  late final StreamSubscription<Map<String, dynamic>> _settingsSub;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _settingsSub =
        settingsRepository.getSettingsStream().listen((final settings) {
      final nextLock = settings['app_lock_enabled'] ?? false;
      final nextBio = settings['biometric_enabled'] ?? false;
      final nextMinutes = (settings['auto_lock_minutes'] as num?)?.toInt() ?? 5;
      setState(() {
        _appLockEnabled = nextLock;
        _biometricEnabled = nextBio;
        _autoLockMinutes = nextMinutes;
        if (!_appLockEnabled) {
          _locked = false;
        }
      });
    });
  }

  @override
  void dispose() {
    _settingsSub.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(final AppLifecycleState state) {
    if (!_appLockEnabled) return;
    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.paused) {
      _lastInactive = DateTime.now();
    }
    if (state == AppLifecycleState.resumed) {
      if (_lastInactive == null) return;
      final elapsed = DateTime.now().difference(_lastInactive!);
      if (elapsed.inMinutes >= _autoLockMinutes) {
        _lock();
      }
    }
  }

  Future<void> _lock() async {
    if (!mounted) return;
    setState(() => _locked = true);
    await _attemptUnlock();
  }

  Future<void> _attemptUnlock() async {
    if (!_locked || _authInProgress) return;
    if (kIsWeb) return;

    try {
      _authInProgress = true;
      final canCheck = await _auth.canCheckBiometrics;
      final supported = await _auth.isDeviceSupported();
      if (!canCheck && !supported) {
        return;
      }
      final authenticated = await _auth.authenticate(
        localizedReason: 'Unlock Soma',
        options: AuthenticationOptions(
          biometricOnly: _biometricEnabled,
          stickyAuth: true,
        ),
      );
      if (mounted && authenticated) {
        setState(() => _locked = false);
      }
    } catch (_) {
      // ignore auth errors and keep locked
    } finally {
      _authInProgress = false;
    }
  }

  @override
  Widget build(final BuildContext context) {
    return Stack(
      children: [
        widget.child,
        if (_locked)
          Positioned.fill(
            child: Container(
              color: Colors.black.withValues(alpha: 0.55),
              child: Center(
                child: _LockCard(
                  onUnlock: _attemptUnlock,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _LockCard extends StatelessWidget {
  final VoidCallback onUnlock;

  const _LockCard({required this.onUnlock});

  @override
  Widget build(final BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: BoxDecoration(
        color: scheme.surface.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: scheme.onSurface.withValues(alpha: 0.2)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.lock_rounded, color: scheme.onSurface, size: 32),
          const SizedBox(height: 10),
          Text(
            'App locked',
            style: TextStyle(
              color: scheme.onSurface,
              fontWeight: FontWeight.w900,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Authenticate to continue',
            style: TextStyle(
              color: scheme.onSurface.withValues(alpha: 0.7),
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: onUnlock,
              child: const Text('Unlock'),
            ),
          ),
        ],
      ),
    );
  }
}
