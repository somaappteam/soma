import 'package:flutter/material.dart';
import 'package:soma/l10n/gen/app_localizations.dart';
import '../../core/widgets/soma_background.dart';
import '../../core/widgets/glass.dart';
import '../../core/widgets/neon_button.dart';
import '../../models/solo_course.dart';
import '../../data/quiz_repository.dart';
import 'solo_course_detail_screen.dart';
import 'solo_vocab_quiz_screen.dart';
import 'solo_sentences_quiz_screen.dart';

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
  final VoidCallback onReviewMistakes;

  @override
  State<SoloResultScreen> createState() => _SoloResultScreenState();
}

class _SoloResultScreenState extends State<SoloResultScreen> {

  @override
  void initState() {
    super.initState();
    _saveProgress();
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

  int get accuracyPct => widget.total == 0 ? 0 : ((widget.correct / widget.total) * 100).round();

  String _modeLabel(AppLocalizations l10n) {
    if (widget.mode == SoloMode.vocabulary) return l10n.soloModeVocabulary;
    if (widget.mode == SoloMode.sentences) return l10n.soloModeSentences;
    return l10n.soloModeReview;
  }

  String _feedbackLine(AppLocalizations l10n) {
    final p = accuracyPct;
    if (p >= 90) return l10n.soloResultsFeedbackElite;
    if (p >= 75) return l10n.soloResultsFeedbackStrong;
    if (p >= 55) return l10n.soloResultsFeedbackProgress;
    return l10n.soloResultsFeedbackTryAgain;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final p = accuracyPct.clamp(0, 100);

    return Scaffold(
      body: SomaBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 18),
            child: ListView(
              physics: const BouncingScrollPhysics(),
              children: [
                // Top bar
                Row(
                  children: [
                    _IconGlass(
                      icon: Icons.close_rounded,
                      onTap: () => Navigator.popUntil(context, (r) => r.isFirst),
                    ),
                    const Spacer(),
                    Text(
                      l10n.resultsTitle,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.92),
                        fontWeight: FontWeight.w900,
                        fontSize: 18,
                      ),
                    ),
                    const Spacer(),
                    _IconGlass(
                      icon: Icons.ios_share_rounded,
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(l10n.shareLater)),
                        );
                      },
                    ),
                  ],
                ),

                const SizedBox(height: 14),

                // Summary card
                Glass(
                  radius: BorderRadius.circular(24),
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${widget.course.subtitle} • ${_modeLabel(l10n)}",
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.70),
                          fontWeight: FontWeight.w800,
                          fontSize: 12.5,
                        ),
                      ),
                      const SizedBox(height: 8),

                      Row(
                        children: [
                          _Badge(level: widget.level),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  l10n.soloResultsCompletedTitle,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w900,
                                    fontSize: 18,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  _feedbackLine(l10n),
                                  style: TextStyle(
                                    color: Colors.white.withValues(alpha: 0.62),
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
                                  color: Colors.white.withValues(alpha: 0.60),
                                  fontWeight: FontWeight.w800,
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "+${widget.points}",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 22,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),

                      const SizedBox(height: 14),

                      _AccuracyBar(percent: p),

                      const SizedBox(height: 14),

                      Row(
                        children: [
                          Expanded(
                            child: _StatTile(
                              title: l10n.statCorrect,
                              value: "${widget.correct}",
                              subtitle: l10n.statAnswers,
                              icon: Icons.check_circle_rounded,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: _StatTile(
                              title: l10n.statTotal,
                              value: "${widget.total}",
                              subtitle: l10n.statQuestions,
                              icon: Icons.quiz_rounded,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 10),

                      Row(
                        children: [
                          Expanded(
                            child: _StatTile(
                              title: l10n.statAccuracy,
                              value: "$p%",
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
                    ],
                  ),
                ),

                const SizedBox(height: 14),

                // Mistakes preview (placeholder)
                Glass(
                  radius: BorderRadius.circular(22),
                  padding: const EdgeInsets.all(14),
                  child: Row(
                    children: [
                      const Icon(Icons.auto_fix_high_rounded, color: Colors.white),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          widget.mistakes.isEmpty 
                              ? l10n.soloResultsPerfectScore
                              : l10n.soloResultsReviewPrompt,
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.78),
                            fontWeight: FontWeight.w700,
                            fontSize: 12.5,
                            height: 1.25,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 18),

                // Buttons
                if (widget.mistakes.isNotEmpty) ...[
                  NeonButton(
                    label: l10n.soloResultsReviewMistakes(widget.mistakes.length),
                    onTap: () {
                      if (widget.mode == SoloMode.vocabulary) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => SoloVocabQuizScreen(
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
                            builder: (_) => SoloSentencesQuizScreen(
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
                  const SizedBox(height: 10),
                ],
                _SecondaryButton(
                  label: l10n.playAgain,
                  onTap: widget.onPlayAgain,
                ),
                const SizedBox(height: 10),
                _SecondaryButton(
                  label: l10n.backToCourse,
                  onTap: () => Navigator.popUntil(context, (r) => r.isFirst),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------- UI parts ----------------

class _IconGlass extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _IconGlass({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Glass(
        radius: BorderRadius.circular(16),
        padding: const EdgeInsets.all(10),
        child: Icon(icon, color: Colors.white.withValues(alpha: 0.92), size: 20),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final String level;
  const _Badge({required this.level});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 46,
      height: 46,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white.withValues(alpha: 0.08),
        border: Border.all(color: Colors.white.withValues(alpha: 0.16)),
      ),
      child: Center(
        child: Text(
          level,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 18),
        ),
      ),
    );
  }
}

class _AccuracyBar extends StatelessWidget {
  final int percent;
  const _AccuracyBar({required this.percent});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final clamped = percent.clamp(0, 100);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              l10n.statAccuracy,
              style: const TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w800),
            ),
            const Spacer(),
            Text(
              "$clamped%",
              style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w900),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: Container(
            height: 10,
            color: Colors.white.withValues(alpha: 0.10),
            child: Align(
              alignment: Alignment.centerLeft,
              child: FractionallySizedBox(
                widthFactor: clamped / 100,
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF35E7FF), Color(0xFF9A5BFF), Color(0xFFFF49D7)],
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
  Widget build(BuildContext context) {
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
              color: Colors.white.withValues(alpha: 0.08),
              border: Border.all(color: Colors.white.withValues(alpha: 0.16)),
            ),
            child: Icon(icon, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.65),
                    fontWeight: FontWeight.w800,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 1),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.55),
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
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(999),
      onTap: onTap,
      child: Container(
        height: 56,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(999),
          color: Colors.black.withValues(alpha: 0.22),
          border: Border.all(color: Colors.white.withValues(alpha: 0.16)),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 16),
        ),
      ),
    );
  }
}
