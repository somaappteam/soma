import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:soma/core/services/haptics_service.dart';
import 'package:soma/core/services/sfx_service.dart';
import 'package:soma/core/theme/app_theme.dart';
import 'package:soma/core/theme/layout_tokens.dart';
import 'package:soma/core/widgets/glass.dart';
import 'package:soma/core/widgets/neon_button.dart';
import 'package:soma/core/widgets/premium_screen_scaffold.dart';
import 'package:soma/core/widgets/reward_sparkle.dart';
import 'package:soma/core/widgets/staggered_in.dart';
import 'package:soma/data/quiz_repository.dart';
import 'package:soma/data/settings_repository.dart';
import 'package:soma/data/soma_plus_repository.dart';
import 'package:soma/features/solo/solo_course_detail_screen.dart';
import 'package:soma/features/solo/solo_sentences_quiz_screen.dart';
import 'package:soma/features/solo/solo_vocab_quiz_screen.dart';
import 'package:soma/l10n/gen/app_localizations.dart';
import 'package:soma/models/solo_course.dart';

class SoloResultScreen extends StatefulWidget {
  const SoloResultScreen({
    super.key,
    required this.course,
    required this.mode,
    required this.level,
    required this.correct,
    required this.total,
    required this.points,
    this.mistakes = const [],
    required this.onPlayAgain,
    required this.onContinue,
    required this.onReviewMistakes,
  });

  final SoloCourse course;
  final SoloMode mode;
  final String level;

  final int correct;
  final int total;
  final int points;
  final List<Map<String, dynamic>> mistakes;

  final VoidCallback onPlayAgain;
  final VoidCallback onContinue;
  final VoidCallback onReviewMistakes;

  @override
  State<SoloResultScreen> createState() => _SoloResultScreenState();
}

class _SoloResultScreenState extends State<SoloResultScreen> {
  bool _hasShownFreePlanAd = false;
  bool _didPlayMilestoneFx = false;

  @override
  void initState() {
    super.initState();
    _saveProgress();
    WidgetsBinding.instance.addPostFrameCallback((final _) {
      _maybeShowFreePlanAd();
      _playMilestoneFeedback();
    });
  }

  Future<void> _saveProgress() async {
    // Fire and forget save
    await quizRepository.saveQuizResult(
      courseId: widget.course.id,
      xpEarned: widget.points,
      correctCount: widget.correct,
      totalCount: widget.total,
    );
  }

  Future<void> _maybeShowFreePlanAd() async {
    if (!mounted || _hasShownFreePlanAd) return;
    final settings = await settingsRepository.getSettings();
    if (!mounted) return;
    final tier =
        SomaPlusRepository.parseTier(settings['plus_plan']?.toString());
    if (tier != SomaSubscriptionTier.free) return;

    _hasShownFreePlanAd = true;
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (final ctx) {
        final scheme = Theme.of(ctx).colorScheme;
        return AlertDialog(
          title: const Text('Sponsored Break'),
          content: const Text(
            'Ads are shown after each solo quiz session on the Free plan. '
            'Upgrade to Plus for an ad-free experience.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: Text('Continue', style: TextStyle(color: scheme.primary)),
            ),
          ],
        );
      },
    );
  }

  int get accuracyPct =>
      widget.total == 0 ? 0 : ((widget.correct / widget.total) * 100).round();

  void _playMilestoneFeedback() {
    if (_didPlayMilestoneFx || !mounted) return;
    _didPlayMilestoneFx = true;
    final perfect = widget.total > 0 && widget.correct == widget.total;
    final streakLike = accuracyPct >= 80;

    if (perfect) {
      hapticsService.mediumImpact();
      sfxService.sparkle();
      return;
    }
    if (streakLike) {
      hapticsService.mediumImpact();
      sfxService.risingTone();
      return;
    }

    hapticsService.lightImpact();
    sfxService.softClick();
  }

  String _modeLabel(final AppLocalizations l10n) {
    if (widget.mode == SoloMode.vocabulary) return l10n.soloModeVocabulary;
    if (widget.mode == SoloMode.sentences) return l10n.soloModeSentences;
    return l10n.soloModeReview;
  }

  String _feedbackLine(final AppLocalizations l10n) {
    final p = accuracyPct;
    if (p >= 90) return l10n.soloResultsFeedbackElite;
    if (p >= 75) return l10n.soloResultsFeedbackStrong;
    if (p >= 55) return l10n.soloResultsFeedbackProgress;
    return l10n.soloResultsFeedbackTryAgain;
  }

  Future<void> _shareResults() async {
    final l10n = AppLocalizations.of(context);
    final summary = '${widget.course.subtitle} â€¢ ${_modeLabel(l10n)}';
    final stats = '${l10n.statCorrect}: ${widget.correct}/${widget.total}';
    final points = '${l10n.pointsLabel}: +${widget.points}';
    final accuracy = '${l10n.statAccuracy}: $accuracyPct%';
    await Share.share('$summary\n$stats\n$accuracy\n$points');
  }

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    final textTones = Theme.of(context).extension<AppTextToneTheme>();
    final p = accuracyPct.clamp(0, 100);

    return PremiumScreenScaffold(
      body: LayoutBuilder(
        builder: (final context, final constraints) {
          final compactHeight = constraints.maxHeight < 760;
          final blockSpacing = compactHeight ? 12.0 : 14.0;
          final buttonSpacing = compactHeight ? 8.0 : 10.0;

          return Align(
            alignment: Alignment.topCenter,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 760),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 18),
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  children: [
                    StaggeredIn(
                      index: 0,
                      child: Row(
                        children: [
                          _IconGlass(
                            icon: Icons.close_rounded,
                            onTap: () => Navigator.popUntil(
                                context, (final r) => r.isFirst),
                          ),
                          const Spacer(),
                          Text(
                            l10n.resultsTitle,
                            style: TextStyle(
                              color: textTones?.high ??
                                  scheme.onSurface.withValues(alpha: 0.92),
                              fontWeight: FontWeight.w900,
                              fontSize: 18,
                            ),
                          ),
                          const Spacer(),
                          _IconGlass(
                            icon: Icons.ios_share_rounded,
                            onTap: _shareResults,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: blockSpacing),
                    StaggeredIn(
                      index: 1,
                      child: Glass(
                        depth: GlassDepth.l3,
                        selected: true,
                        radius: BorderRadius.circular(24),
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Align(
                              alignment: Alignment.centerRight,
                              child: RewardSparkle(
                                show: widget.total > 0 &&
                                    widget.correct == widget.total,
                                size: 20,
                              ),
                            ),
                            Text(
                              '${widget.course.subtitle} â€¢ ${_modeLabel(l10n)}',
                              style: TextStyle(
                                color: textTones?.medium ??
                                    scheme.onSurface.withValues(alpha: 0.7),
                                fontWeight: FontWeight.w800,
                                fontSize: 12.5,
                              ),
                            ),
                            const SizedBox(height: SectionGap.sm),
                            Row(
                              children: [
                                _Badge(level: widget.level),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        l10n.soloResultsCompletedTitle,
                                        style: TextStyle(
                                          color: scheme.onSurface,
                                          fontWeight: FontWeight.w900,
                                          fontSize: 18,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        _feedbackLine(l10n),
                                        style: TextStyle(
                                          color: textTones?.muted ??
                                              scheme.onSurface
                                                  .withValues(alpha: 0.62),
                                          fontWeight: FontWeight.w700,
                                          fontSize: 12,
                                          height: 1.25,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      l10n.pointsLabel,
                                      style: TextStyle(
                                        color: textTones?.muted ??
                                            scheme.onSurface
                                                .withValues(alpha: 0.60),
                                        fontWeight: FontWeight.w800,
                                        fontSize: 12,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '+${widget.points}',
                                      style: TextStyle(
                                        color: scheme.onSurface,
                                        fontWeight: FontWeight.w900,
                                        fontSize: 22,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(height: blockSpacing),
                            _AccuracyBar(percent: p),
                            SizedBox(height: blockSpacing),
                            StaggeredIn(
                              index: 2,
                              withScale: true,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: _StatTile(
                                      title: l10n.statCorrect,
                                      value: '${widget.correct}',
                                      subtitle: l10n.statAnswers,
                                      icon: Icons.check_circle_rounded,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: _StatTile(
                                      title: l10n.statTotal,
                                      value: '${widget.total}',
                                      subtitle: l10n.statQuestions,
                                      icon: Icons.quiz_rounded,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: buttonSpacing),
                            StaggeredIn(
                              index: 3,
                              withScale: true,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: _StatTile(
                                      title: l10n.statAccuracy,
                                      value: '$p%',
                                      subtitle: l10n.statRate,
                                      icon: Icons.track_changes_rounded,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: _StatTile(
                                      title: l10n.statMode,
                                      value: _modeLabel(l10n),
                                      subtitle: l10n.statType,
                                      icon: Icons.layers_rounded,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: blockSpacing),
                    StaggeredIn(
                      index: 4,
                      child: Glass(
                        depth: GlassDepth.l1,
                        radius: BorderRadius.circular(22),
                        padding: const EdgeInsets.all(14),
                        child: Row(
                          children: [
                            Icon(Icons.auto_fix_high_rounded,
                                color: scheme.onSurface),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                widget.mistakes.isEmpty
                                    ? l10n.soloResultsPerfectScore
                                    : l10n.soloResultsReviewPrompt,
                                style: TextStyle(
                                  color: textTones?.medium ??
                                      scheme.onSurface.withValues(alpha: 0.78),
                                  fontWeight: FontWeight.w700,
                                  fontSize: 12.5,
                                  height: 1.25,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: compactHeight ? 14 : 18),
                    if (widget.mistakes.isNotEmpty) ...[
                      NeonButton(
                        style: NeonButtonStyle.subtle,
                        label: l10n
                            .soloResultsReviewMistakes(widget.mistakes.length),
                        onTap: () {
                          if (widget.mode == SoloMode.vocabulary) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (final _) => SoloVocabQuizScreen(
                                  course: widget.course,
                                  level: widget.level,
                                  totalQuestions: widget.mistakes.length,
                                  isReview: true,
                                  reviewQuestions: widget.mistakes,
                                ),
                              ),
                            );
                          } else {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (final _) => SoloSentencesQuizScreen(
                                  course: widget.course,
                                  level: widget.level,
                                  totalQuestions: widget.mistakes.length,
                                  isReview: true,
                                  reviewQuestions: widget.mistakes,
                                ),
                              ),
                            );
                          }
                        },
                      ),
                      SizedBox(height: buttonSpacing),
                    ],
                    _SecondaryButton(
                      label: l10n.playAgain,
                      onTap: widget.onPlayAgain,
                    ),
                    SizedBox(height: buttonSpacing),
                    _SecondaryButton(
                      label: l10n.continueLabel,
                      onTap: widget.onContinue,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
      padding: PremiumLayout.screenPadding(
          PremiumLayout.densityForWidth(MediaQuery.of(context).size.width)),
    );
  }
}

// ---------------- UI parts ----------------

class _IconGlass extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _IconGlass({required this.icon, required this.onTap});

  @override
  Widget build(final BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTones = Theme.of(context).extension<AppTextToneTheme>();
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Glass(
        radius: BorderRadius.circular(16),
        padding: const EdgeInsets.all(10),
        child: Icon(icon,
            color: textTones?.high ?? scheme.onSurface.withValues(alpha: 0.92),
            size: 20),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final String level;
  const _Badge({required this.level});

  @override
  Widget build(final BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTones = Theme.of(context).extension<AppTextToneTheme>();
    return Container(
      width: 46,
      height: 46,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: scheme.onSurface.withValues(alpha: 0.1),
        border: Border.all(color: scheme.onSurface.withValues(alpha: 0.2)),
      ),
      child: Center(
        child: Text(
          level,
          style: TextStyle(
              color: scheme.onSurface,
              fontWeight: FontWeight.w900,
              fontSize: 18),
        ),
      ),
    );
  }
}

class _AccuracyBar extends StatelessWidget {
  final int percent;
  const _AccuracyBar({required this.percent});

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    final textTones = Theme.of(context).extension<AppTextToneTheme>();
    final clamped = percent.clamp(0, 100);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              l10n.statAccuracy,
              style: TextStyle(
                  color: scheme.onSurface.withValues(alpha: 0.70),
                  fontSize: 12,
                  fontWeight: FontWeight.w800),
            ),
            const Spacer(),
            Text(
              '$clamped%',
              style: TextStyle(
                  color: scheme.onSurface,
                  fontSize: 12,
                  fontWeight: FontWeight.w900),
            ),
          ],
        ),
        const SizedBox(height: SectionGap.sm),
        ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: Container(
            height: 10,
            color: scheme.onSurface.withValues(alpha: 0.15),
            child: Align(
              alignment: Alignment.centerLeft,
              child: FractionallySizedBox(
                widthFactor: clamped / 100,
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color(0xFF35E7FF),
                        Color(0xFF9A5BFF),
                        Color(0xFFFF49D7)
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _StatTile extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final IconData icon;

  const _StatTile({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
  });

  @override
  Widget build(final BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTones = Theme.of(context).extension<AppTextToneTheme>();
    return Glass(
      radius: BorderRadius.circular(18),
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              color: scheme.onSurface.withValues(alpha: 0.1),
              border:
                  Border.all(color: scheme.onSurface.withValues(alpha: 0.2)),
            ),
            child: Icon(icon, color: scheme.onSurface, size: 20),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: scheme.onSurface.withValues(alpha: 0.65),
                    fontWeight: FontWeight.w800,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: scheme.onSurface,
                    fontWeight: FontWeight.w900,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 1),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: scheme.onSurface.withValues(alpha: 0.55),
                    fontWeight: FontWeight.w700,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SecondaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _SecondaryButton({required this.label, required this.onTap});

  @override
  Widget build(final BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTones = Theme.of(context).extension<AppTextToneTheme>();
    return InkWell(
      borderRadius: BorderRadius.circular(999),
      onTap: onTap,
      child: Container(
        height: 56,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(999),
          color: scheme.onSurface.withValues(alpha: 0.1),
          border: Border.all(color: scheme.onSurface.withValues(alpha: 0.2)),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
              color: scheme.onSurface,
              fontWeight: FontWeight.w900,
              fontSize: 16),
        ),
      ),
    );
  }
}
