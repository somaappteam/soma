import 'dart:async';
import 'package:flutter/material.dart';
import 'package:soma/l10n/gen/app_localizations.dart';
import '../../data/circle_voice_service.dart';
import '../../data/profile_store.dart';
import '../../data/rtc_voice_service.dart';
import '../../core/widgets/glass.dart';
import '../../core/widgets/responsive.dart';


class CircleCountdownScreen extends StatefulWidget {
  final int seconds;
  final VoidCallback onFinished;
  final String? circleId;

  const CircleCountdownScreen({
    super.key,
    this.seconds = 3,
    required this.onFinished,
    this.circleId,
  });

  @override
  State<CircleCountdownScreen> createState() => _CircleCountdownScreenState();
}

class _CircleCountdownScreenState extends State<CircleCountdownScreen> {
  late int _t;
  Timer? _timer;
  bool _didConnectVoice = false;

  @override
  void initState() {
    super.initState();
    _t = widget.seconds;
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      if (_t <= 1) {
        _timer?.cancel();
        widget.onFinished();
      } else {
        setState(() => _t -= 1);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      body: SafeArea(
          child: ResponsiveFrame(
            alignment: Alignment.center,
            maxWidth: 420,
            child: Center(
              child: Glass(
                radius: BorderRadius.circular(28),
                padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 28),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      l10n.circleCountdownTitle,
                      style: TextStyle(
                        color: scheme.onSurface.withValues(alpha: 0.92),
                        fontWeight: FontWeight.w900,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      "$_t",
                      style: TextStyle(
                        color: scheme.onSurface,
                        fontWeight: FontWeight.w900,
                        fontSize: 72,
                        height: 1.0,
                        letterSpacing: 1.0,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      l10n.circleCountdownSubtitle,
                      style: TextStyle(
                        color: scheme.onSurface.withValues(alpha: 0.72),
                        fontWeight: FontWeight.w800,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 16),
                    if (widget.circleId != null)
                      StreamBuilder<Map<String, VoicePresence>>(
                        stream: circleVoiceService.stream,
                        builder: (context, snapshot) {
                          final me = circleVoiceService.me;
                          return _MicToggleButton(
                            muted: me?.muted ?? false,
                            speaking: me?.speaking ?? false,
                            onTap: rtcVoiceService.toggleMuted,
                          );
                        },
                      ),
                    const SizedBox(height: 14),
                    _GlowBar(progress: (widget.seconds - _t) / widget.seconds),
                  ],
                ),
              ),
            ),
          ),
      ),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_didConnectVoice) return;
    _didConnectVoice = true;
    _connectVoice();
  }

  Future<void> _connectVoice() async {
    final circleId = widget.circleId;
    if (circleId == null) return;

    final l10n = AppLocalizations.of(context);
    final profile = profileStore.profile;
    final name = profile.displayName.isNotEmpty
        ? profile.displayName
        : (profile.username.isNotEmpty ? profile.username : l10n.userFallbackName);

    await circleVoiceService.connect(circleId: circleId, name: name);
    await rtcVoiceService.connect(circleId: circleId, asSpeaker: true, prioritySpeaker: true);
  }
}

class _GlowBar extends StatelessWidget {
  final double progress;
  const _GlowBar({required this.progress});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 10,
      width: 220,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.12),
        border: Border.all(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.16)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(999),
        child: Align(
          alignment: Alignment.centerLeft,
          child: FractionallySizedBox(
            widthFactor: progress.clamp(0.0, 1.0),
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF2AFADF), Color(0xFF7C7CFF), Color(0xFFFF4FD8)],
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF7C7CFF).withValues(alpha: 0.65),
                    blurRadius: 14,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _MicToggleButton extends StatelessWidget {
  final bool muted;
  final bool speaking;
  final VoidCallback onTap;

  const _MicToggleButton({
    required this.muted,
    required this.speaking,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final onSurface = Theme.of(context).colorScheme.onSurface;
    final color = muted ? onSurface.withValues(alpha: 0.6) : onSurface;
    final label = muted ? l10n.micOff : l10n.micOn;

    return InkWell(
      borderRadius: BorderRadius.circular(999),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(999),
          color: onSurface.withValues(alpha: muted ? 0.08 : 0.12),
          border: Border.all(color: onSurface.withValues(alpha: 0.16)),
          boxShadow: speaking
              ? [
                  BoxShadow(
                    color: const Color(0xFF2AFADF).withValues(alpha: 0.4),
                    blurRadius: 12,
                    spreadRadius: 1,
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(muted ? Icons.mic_off_rounded : Icons.mic_rounded, color: color, size: 18),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w800,
                fontSize: 12.5,
              ),
            ),
            if (speaking) ...[
              const SizedBox(width: 8),
              Container(
                width: 6,
                height: 6,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFF2AFADF),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
