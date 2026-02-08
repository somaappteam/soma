import 'package:flutter/material.dart';
import 'package:soma/l10n/gen/app_localizations.dart';

import '../../core/widgets/glass.dart';
import '../../core/widgets/neon_button.dart';
import '../../models/solo_course.dart';
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
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
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
                      style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w900),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              Glass(
                radius: BorderRadius.circular(24),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.course.subtitle,
                        style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontWeight: FontWeight.w800, fontSize: 12.5)),
                    const SizedBox(height: 10),

                    Text(l10n.difficulty,
                        style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w900)),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        _Chip(label: "A", selected: level == "A", onTap: () => setState(() => level = "A")),
                        const SizedBox(width: 10),
                        _Chip(label: "B", selected: level == "B", onTap: () => setState(() => level = "B")),
                        const SizedBox(width: 10),
                        _Chip(label: "C", selected: level == "C", onTap: () => setState(() => level = "C")),
                      ],
                    ),

                    const SizedBox(height: 16),
                    Text(l10n.numberOfQuestions,
                        style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w900)),
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
                        style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w900)),
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
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(999),
        onTap: onTap,
        child: Container(
          height: 44,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(999),
            color: selected ? Colors.white.withValues(alpha: 0.14) : Colors.white.withValues(alpha: 0.07),
            border: Border.all(color: selected ? Colors.white.withValues(alpha: 0.28) : Colors.white.withValues(alpha: 0.14)),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 14),
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
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Glass(
        radius: BorderRadius.circular(16),
        padding: const EdgeInsets.all(10),
        child: Icon(icon, color: Colors.white.withValues(alpha: 0.92)),
      ),
    );
  }
}
