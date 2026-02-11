import 'package:flutter/material.dart';
import 'package:soma/l10n/gen/app_localizations.dart';

import '../../core/widgets/glass.dart';
import '../../core/widgets/neon_button.dart';
import '../../models/solo_course.dart';
import '../../data/settings_repository.dart';
import 'solo_course_detail_screen.dart';
import 'solo_vocab_quiz_screen.dart';
import 'solo_sentences_quiz_screen.dart';

class SoloSetupScreen extends StatefulWidget {
  const SoloSetupScreen({super.key, required this.course, required this.mode});
  final SoloCourse course;
  final SoloMode mode;

  @override
  State<SoloSetupScreen> createState() => _SoloSetupScreenState();
}

class _SoloSetupScreenState extends State<SoloSetupScreen> {
  String level = "A"; // A/B/C
  int questions = 10;
  int? timeLimit;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final settings = await settingsRepository.getSettings();
    final defaultTimer = settings['default_timer_s'];
    if (defaultTimer is num && mounted) {
      setState(() => timeLimit = defaultTimer.toInt());
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    final modeLabel = widget.mode == SoloMode.vocabulary
        ? l10n.soloModeVocabulary
        : widget.mode == SoloMode.sentences
            ? l10n.soloModeSentences
            : l10n.soloModeReview;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 18),
          child: Column(
            children: [
              Row(
                children: [
                  _IconGlass(icon: Icons.arrow_back_ios_new_rounded, onTap: () => Navigator.pop(context)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      l10n.soloSetupTitle(modeLabel),
                      style: TextStyle(color: scheme.onSurface, fontSize: 20, fontWeight: FontWeight.w900),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),

              Glass(
                radius: BorderRadius.circular(24),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.course.subtitle,
                        style: TextStyle(color: scheme.onSurface.withValues(alpha: 0.7), fontWeight: FontWeight.w800, fontSize: 12.5)),
                    const SizedBox(height: 10),

                    Text(l10n.difficulty,
                        style: TextStyle(color: scheme.onSurface, fontSize: 15, fontWeight: FontWeight.w900)),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        _Chip(label: l10n.levelBeginner, selected: level == "A", onTap: () => setState(() => level = "A")),
                        const SizedBox(width: 10),
                        _Chip(label: l10n.levelIntermediate, selected: level == "B", onTap: () => setState(() => level = "B")),
                        const SizedBox(width: 10),
                        _Chip(label: l10n.levelAdvanced, selected: level == "C", onTap: () => setState(() => level = "C")),
                      ],
                    ),

                    const SizedBox(height: 16),
                    Text(l10n.numberOfQuestions,
                        style: TextStyle(color: scheme.onSurface, fontSize: 15, fontWeight: FontWeight.w900)),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        _Chip(label: "10", selected: questions == 10, onTap: () => setState(() => questions = 10)),
                        const SizedBox(width: 10),
                        _Chip(label: "15", selected: questions == 15, onTap: () => setState(() => questions = 15)),
                        const SizedBox(width: 10),
                        _Chip(label: "20", selected: questions == 20, onTap: () => setState(() => questions = 20)),
                      ],
                    ),

                    const SizedBox(height: 16),
                    Text(l10n.timerPerQuestion,
                        style: TextStyle(color: scheme.onSurface, fontSize: 15, fontWeight: FontWeight.w900)),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        _Chip(label: l10n.noTimer, selected: timeLimit == null, onTap: () => setState(() => timeLimit = null)),
                        const SizedBox(width: 10),
                        _Chip(label: "10s", selected: timeLimit == 10, onTap: () => setState(() => timeLimit = 10)),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        _Chip(label: "15s", selected: timeLimit == 15, onTap: () => setState(() => timeLimit = 15)),
                        const SizedBox(width: 10),
                        _Chip(label: "20s", selected: timeLimit == 20, onTap: () => setState(() => timeLimit = 20)),
                      ],
                    ),
                  ],
                ),
              ),

              const Spacer(),

              NeonButton(
                label: l10n.start,
                onTap: () {
                  if (widget.mode == SoloMode.sentences) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => SoloSentencesQuizScreen(
                          course: widget.course,
                          level: level,
                          totalQuestions: questions,
                          isReview: widget.mode == SoloMode.review,
                          timePerQuestion: timeLimit,
                        ),
                      ),
                    );
                  } else {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => SoloVocabQuizScreen(
                          course: widget.course,
                          level: level,
                          totalQuestions: questions,
                          isReview: widget.mode == SoloMode.review,
                          timePerQuestion: timeLimit,
                        ),
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _Chip({required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(999),
        onTap: onTap,
        child: Container(
          height: 44,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(999),
            color: selected
                ? scheme.primary.withValues(alpha: 0.15)
                : scheme.onSurface.withValues(alpha: 0.1),
            border: Border.all(
              color: selected
                  ? scheme.primary.withValues(alpha: 0.5)
                  : scheme.onSurface.withValues(alpha: 0.15),
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(color: selected ? scheme.primary : scheme.onSurface, fontWeight: FontWeight.w900, fontSize: 14),
          ),
        ),
      ),
    );
  }
}

class _IconGlass extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _IconGlass({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Glass(
        radius: BorderRadius.circular(16),
        padding: const EdgeInsets.all(10),
        child: Icon(icon, color: scheme.onSurface.withValues(alpha: 0.92)),
      ),
    );
  }
}
