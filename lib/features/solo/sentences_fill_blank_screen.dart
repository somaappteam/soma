import 'dart:async';
import 'package:flutter/material.dart';
import 'package:soma/l10n/gen/app_localizations.dart';

import '../../models/fill_blank_question.dart';
import '../../core/widgets/soma_background.dart';
import '../../core/widgets/neon_button.dart';
import '../../core/widgets/glass.dart';

class SentencesFillBlankScreen extends StatefulWidget {
  const SentencesFillBlankScreen({super.key});

  @override
  State<SentencesFillBlankScreen> createState() => _SentencesFillBlankScreenState();
}

class _SentencesFillBlankScreenState extends State<SentencesFillBlankScreen> {
 final List<FillBlankQuestion> _questions = const [
  FillBlankQuestion(
    prompt: "The store is closing ___ five minutes.",
    translation: "商店五分钟后关门。",
    reading: "Shāngdiàn wǔ fēnzhōng hòu guānmén.",
    choices: ["in", "on", "at", "to"],
    correctIndex: 0,
  ),
  FillBlankQuestion(
    prompt: "She is good ___ math.",
    translation: "彼女は数学が得意です。",
    reading: "Kanojo wa suugaku ga tokui desu.",
    choices: ["in", "at", "on", "to"],
    correctIndex: 1,
  ),
  FillBlankQuestion(
    prompt: "I’ve been learning Spanish ___ two months.",
    translation: "أنا أتعلم الإسبانية منذ شهرين.",
    reading: "Ana ata‘allam al-isbaniyya mundhu shahrayn.",
    choices: ["since", "for", "during", "from"],
    correctIndex: 1,
  ),

  // No reading (for languages that don't need it)
  FillBlankQuestion(
    prompt: "She is good ___ math.",
    translation: "Ella es buena en matemáticas.",
    choices: ["in", "at", "on", "to"],
    correctIndex: 1,
  ),
];


  int _index = 0;
  int _score = 0;

  int? _selected;
  bool _locked = false;

  static const int _secondsPerQuestion = 10;
  int _secondsLeft = _secondsPerQuestion;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer?.cancel();
    _secondsLeft = _secondsPerQuestion;
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) return;
      if (_locked) return;
      setState(() {
        _secondsLeft--;
        if (_secondsLeft <= 0) {
          _lockAndReveal(null); // timed out
        }
      });
    });
  }

  void _lockAndReveal(int? choice) {
    if (_locked) return;
    final q = _questions[_index];

    setState(() {
      _locked = true;
      _selected = choice;

      if (choice != null && choice == q.correctIndex) {
        _score += 100;
      }
    });

    // Auto-next after a short delay
    Future.delayed(const Duration(milliseconds: 900), () {
      if (!mounted) return;
      _next();
    });
  }

  void _next() {
    if (_index >= _questions.length - 1) {
      // Done — for now just pop or show result later
      Navigator.pop(context);
      return;
    }

    setState(() {
      _index++;
      _selected = null;
      _locked = false;
    });

    _startTimer();
  }

  Color _choiceBorderColor({
    required bool isCorrect,
    required bool isSelected,
  }) {
    if (!_locked) {
      return Colors.white.withValues(alpha: isSelected ? 0.35 : 0.15);
    }
    if (isCorrect) return const Color(0xFF58F7B6); // green glow vibe
    if (isSelected && !isCorrect) return const Color(0xFFFF5AA5); // pink/red
    return Colors.white.withValues(alpha: 0.10);
  }

  Color _choiceFillColor({
    required bool isCorrect,
    required bool isSelected,
  }) {
    if (!_locked) {
      return Colors.white.withValues(alpha: isSelected ? 0.08 : 0.04);
    }
    if (isCorrect) return const Color(0xFF58F7B6).withValues(alpha: 0.10);
    if (isSelected && !isCorrect) return const Color(0xFFFF5AA5).withValues(alpha: 0.10);
    return Colors.white.withValues(alpha: 0.03);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final q = _questions[_index];
    final progress = (_secondsLeft / _secondsPerQuestion).clamp(0.0, 1.0);

    return Scaffold(
      body: SomaBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(18, 14, 18, 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Top bar
                Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
                    ),
                    const Spacer(),
                    _Pill(
                      child: Row(
                        children: [
                          const Icon(Icons.timer_rounded, color: Colors.white, size: 18),
                          const SizedBox(width: 8),
                          Text(
                            "0:${_secondsLeft.toString().padLeft(2, '0')}",
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    _Pill(
                      child: Row(
                        children: [
                          const Icon(Icons.bolt_rounded, color: Colors.white, size: 18),
                          const SizedBox(width: 8),
                          Text(
                            "+$_score",
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                // Timer bar
                Glass(
                  radius: BorderRadius.circular(18),
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          Text(
                            l10n.soloModeSentences,
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.9),
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            "${_index + 1}/${_questions.length}",
                            style: TextStyle(color: Colors.white.withValues(alpha: 0.65)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(999),
                        child: SizedBox(
                          height: 10,
                          child: Stack(
                            children: [
                              Container(color: Colors.white.withValues(alpha: 0.10)),
                              FractionallySizedBox(
                                widthFactor: progress,
                                child: Container(
                                  decoration: const BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [Color(0xFF25E0FF), Color(0xFFB46CFF), Color(0xFFFF5AA5)],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 14),

                // Prompt card
                Glass(
                  radius: BorderRadius.circular(22),
                  padding: const EdgeInsets.fromLTRB(16, 18, 16, 18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                     Text(
  q.prompt,
  textAlign: TextAlign.center,
  style: const TextStyle(
    color: Colors.white,
    fontSize: 22,
    height: 1.25,
    fontWeight: FontWeight.w800,
  ),
),

const SizedBox(height: 10),

// ✅ Translation line
Text(
  q.translation,
  textAlign: TextAlign.center,
  style: TextStyle(
    color: Colors.white.withValues(alpha: 0.70),
    fontSize: 15,
    height: 1.25,
    fontWeight: FontWeight.w600,
  ),
),

// ✅ Optional reading line (pinyin / romaji / transliteration)
if (q.reading != null && q.reading!.trim().isNotEmpty) ...[
  const SizedBox(height: 8),
  Text(
    q.reading!,
    textAlign: TextAlign.center,
    style: TextStyle(
      color: Colors.white.withValues(alpha: 0.55),
      fontSize: 13.5,
      height: 1.25,
      fontWeight: FontWeight.w600,
    ),
  ),
],

// ✅ Optional hint (unchanged)
if (q.hint != null) ...[
  const SizedBox(height: 10),
  Text(
    q.hint!,
    textAlign: TextAlign.center,
    style: TextStyle(
      color: Colors.white.withValues(alpha: 0.55),
      fontSize: 13,
    ),
  ),
],

                    ],
                  ),
                ),

                const SizedBox(height: 14),

                // Choices
                Expanded(
                  child: ListView.separated(
                    itemCount: q.choices.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, i) {
                      final isSelected = _selected == i;
                      final isCorrect = i == q.correctIndex;

                      return GestureDetector(
                        onTap: _locked ? null : () => setState(() => _selected = i),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 180),
                          curve: Curves.easeOut,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(
                              color: _choiceBorderColor(
                                isCorrect: isCorrect,
                                isSelected: isSelected,
                              ),
                              width: 1.2,
                            ),
                            color: _choiceFillColor(
                              isCorrect: isCorrect,
                              isSelected: isSelected,
                            ),
                            boxShadow: [
                              if (_locked && isCorrect)
                                BoxShadow(
                                  color: const Color(0xFF58F7B6).withValues(alpha: 0.25),
                                  blurRadius: 18,
                                  spreadRadius: 1,
                                ),
                              if (_locked && isSelected && !isCorrect)
                                BoxShadow(
                                  color: const Color(0xFFFF5AA5).withValues(alpha: 0.22),
                                  blurRadius: 16,
                                  spreadRadius: 1,
                                ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                            child: Row(
                              children: [
                                Container(
                                  width: 22,
                                  height: 22,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(color: Colors.white.withValues(alpha: 0.35)),
                                  ),
                                  child: isSelected
                                      ? Center(
                                          child: Container(
                                            width: 10,
                                            height: 10,
                                            decoration: const BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.white,
                                            ),
                                          ),
                                        )
                                      : null,
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  q.choices[i],
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16,
                                  ),
                                ),
                                const Spacer(),
                                if (_locked && isCorrect)
                                  const Icon(Icons.check_rounded, color: Color(0xFF58F7B6)),
                                if (_locked && isSelected && !isCorrect)
                                  const Icon(Icons.close_rounded, color: Color(0xFFFF5AA5)),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 10),

                // Continue button
                NeonButton(
                  label: _locked ? l10n.continueLabel : l10n.submit,
                  onTap: () {
                    if (_locked) return _next();
                    _lockAndReveal(_selected);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  final Widget child;
  const _Pill({required this.child});

  @override
  Widget build(BuildContext context) {
    return Glass(
      radius: BorderRadius.circular(999),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: child,
    );
  }
}
