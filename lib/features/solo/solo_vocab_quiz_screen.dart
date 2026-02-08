import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/widgets/glass.dart';
import '../../core/widgets/neon_button.dart';
import '../../core/widgets/pressable_scale.dart';
import '../../core/widgets/staggered_in.dart';
import '../../core/widgets/reward_sparkle.dart';
import '../../models/solo_course.dart';
import 'solo_result_screen.dart';
import 'solo_course_detail_screen.dart';
import '../../data/quiz_repository.dart';
import '../../core/services/tts_service.dart';
import '../../core/theme/motion.dart';

class SoloVocabQuizScreen extends StatefulWidget {
  const SoloVocabQuizScreen({
    super.key,
    required this.course,
    required this.level,
    required this.totalQuestions,
    required this.isReview,
    this.reviewQuestions,
    this.timePerQuestion,
  });

  final SoloCourse course;
  final String level;
  final int totalQuestions;
  final bool isReview;
  final List<Map<String, dynamic>>? reviewQuestions;
  final int? timePerQuestion;

  @override
  State<SoloVocabQuizScreen> createState() => _SoloVocabQuizScreenState();
}

class _SoloVocabQuizScreenState extends State<SoloVocabQuizScreen> {
  // DEMO: replace with your generator/data
  List<Map<String, dynamic>> questions = [];
  final List<Map<String, dynamic>> _demoQuestions = [
    {
      "prompt": "llegar",
      "reading": "",
      "choices": ["arrive", "leave", "eat", "live"],
      "correct": 0,
    },
    {
      "prompt": "rápidamente",
      "reading": "",
      "choices": ["slowly", "quickly", "never", "yesterday"],
      "correct": 1,
    },
  ];

  int index = 0;
  int correctCount = 0;
  int? selected;
  bool revealed = false;
  bool showReading = true;
  List<String> _choices = [];
  int _correctIndex = 0;
  double _speechRate = 1.0;
  Timer? _ttsTimer;

  final List<Map<String, dynamic>> mistakes = [];

  late int remaining;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    remaining = widget.timePerQuestion ?? 0;
    if (widget.reviewQuestions != null && widget.reviewQuestions!.isNotEmpty) {
      questions = widget.reviewQuestions!;
      _prepareQuestion();
      _startTimer();
    } else {
      _loadQuestions();
    }
  }

  Future<void> _loadQuestions() async {
    // Try fetch from DB
    try {
      final dbQuestions = await quizRepository.getVocabQuestions(
          widget.course.id, widget.totalQuestions);
      if (mounted) {
        setState(() {
          questions = dbQuestions.isNotEmpty ? dbQuestions : _demoQuestions;
        });
        _prepareQuestion();
        _startTimer();
      }
    } catch (e, stack) {
      debugPrint("Error loading quiz: $e");
      if (mounted) {
        showDialog(context: context, builder: (_) => AlertDialog(
          title: const Text("Error Loading Quiz"),
          content: SingleChildScrollView(child: Text("$e\n$stack")),
          actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text("OK"))],
        ));
        setState(() {
          questions = _demoQuestions;
        });
        _prepareQuestion();
        _startTimer();
      }
    }
  }

  void _startTimer() {
    timer?.cancel();
    final timeLimit = widget.timePerQuestion;
    if (timeLimit == null) {
      setState(() => remaining = 0);
      return;
    }
    remaining = timeLimit;
    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) return;
      try {
        setState(() {
          remaining--;
          if (remaining <= 0) {
            remaining = 0;
            t.cancel();
            _submit(timedOut: true);
          }
        });
      } catch (e, stack) {
        debugPrint("Timer error: $e");
         showDialog(context: context, builder: (_) => AlertDialog(
          title: const Text("Timer Error"),
          content: SingleChildScrollView(child: Text("$e\n$stack")),
          actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text("OK"))],
        ));
      }
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    _ttsTimer?.cancel();
    ttsService.stop();
    super.dispose();
  }

  void _submit({bool timedOut = false}) {
    if (revealed) return; // Prevent double submit
    if (!timedOut && selected == null) return;
    timer?.cancel();

    final q = questions[index % questions.length];
    final ok = !timedOut && selected == _correctIndex;
    if (ok) {
      correctCount++;
      HapticFeedback.mediumImpact();
    } else {
      mistakes.add(q);
      HapticFeedback.lightImpact();
    }
    quizRepository.recordVocabAnswer(
      courseId: widget.course.id,
      question: q,
      correct: ok,
    );

    setState(() {
      revealed = true;
    });

    if (widget.timePerQuestion != null) {
      Future.delayed(const Duration(milliseconds: 900), () {
        if (!mounted) return;
        _next();
      });
    }
  }

  void _next() {
    final isLast = index >= questions.length - 1;
    if (isLast || index >= widget.totalQuestions - 1) {
      _goToResults();
      return;
    }

    setState(() {
      index++;
      selected = null;
      revealed = false;
    });
    _prepareQuestion();
    _startTimer();
  }

  void _prepareQuestion() {
    try {
      if (questions.isEmpty) return;
      final q = questions[index % questions.length];
      final choiceSet = _buildChoiceSet(q);
      setState(() {
        _choices = choiceSet.choices;
        _correctIndex = choiceSet.correctIndex;
      });
      _scheduleQuestionAudio();
    } catch (e, stack) {
       showDialog(context: context, builder: (_) => AlertDialog(
          title: const Text("Error Preparing Question"),
          content: SingleChildScrollView(child: Text("$e\n$stack")),
          actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text("OK"))],
        ));
    }
  }

  void _scheduleQuestionAudio() {
    _ttsTimer?.cancel();
    final q = questions[index % questions.length];
    final prompt = _speechText(q);
    if (prompt.trim().isEmpty) return;
    _ttsTimer = Timer(const Duration(milliseconds: 350), () async {
      if (!mounted) return;
      try {
        await ttsService.setRate(_speechRate);
        await ttsService.speak(prompt);
      } catch (e) {
        debugPrint("TTS Error in _scheduleQuestionAudio: $e");
      }
    });
  }

  void _speakPrompt() async {
    try {
      final q = questions[index % questions.length];
      final prompt = _speechText(q);
      if (prompt.trim().isEmpty) return;
      await ttsService.setRate(_speechRate);
      await ttsService.speak(prompt);
    } catch (e) {
      debugPrint("TTS Error (Manual): $e");
    }
  }

  String _speechText(Map<String, dynamic> question) {
    final article = question["article"]?.toString().trim() ?? '';
    final word = question["word"]?.toString().trim() ?? '';
    if (article.isNotEmpty && word.isNotEmpty) return "$article $word";
    return question["prompt"]?.toString() ?? '';
  }

  _ChoiceSet _buildChoiceSet(Map<String, dynamic> question) {
    final pool = question["choice_pool"];
    final correctAnswer = question["correct_answer"]?.toString() ?? '';
    if (pool is List && correctAnswer.trim().isNotEmpty) {
      final items = pool
          .map((e) => e.toString())
          .where((e) => e.trim().isNotEmpty && e != correctAnswer)
          .toSet()
          .toList();
      items.shuffle();
      final choices = <String>[correctAnswer, ...items.take(3)];
      choices.shuffle();
      return _ChoiceSet(
          choices: choices, correctIndex: choices.indexOf(correctAnswer));
    }

    final fallback = question["choices"];
    if (fallback is List) {
      final choices = fallback.map((e) => e.toString()).toList();
      final correctIndex =
          question["correct"] is int ? question["correct"] as int : 0;
      return _ChoiceSet(choices: choices, correctIndex: correctIndex);
    }

    return const _ChoiceSet(choices: [], correctIndex: 0);
  }

  void _goToResults() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => SoloResultScreen(
          course: widget.course,
          mode: SoloMode.vocabulary,
          level: widget.level,
          correct: correctCount,
          total: widget.totalQuestions,
          points: correctCount * 15,
          mistakes: mistakes,
          onPlayAgain: () {
            Navigator.pop(context); // Go back to detail
          },
          onReviewMistakes: () {
            // Demo: just pop for now or show mistakes
            Navigator.pop(context);
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (questions.isEmpty) {
      return const Scaffold(
        body:
            Center(child: CircularProgressIndicator(color: Color(0xFF33D6FF))),
      );
    }

    final q = questions[index % questions.length];
    final List<String> choices = _choices;
    final timeLimit = widget.timePerQuestion;
    final progress =
        timeLimit == null ? 1.0 : (remaining / timeLimit).clamp(0.0, 1.0);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 18),
          child: Column(
            children: [
              Row(
                children: [
                  _IconGlass(
                      icon: Icons.arrow_back_ios_new_rounded,
                      onTap: () => Navigator.pop(context)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      "Solo • ${widget.course.title}",
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w900),
                    ),
                  ),
                  _IconGlass(
                    icon: showReading
                        ? Icons.text_fields_rounded
                        : Icons.text_fields_outlined,
                    onTap: () => setState(() => showReading = !showReading),
                  ),
                  const SizedBox(width: 10),
                  _Pill(
                      text: "${index + 1}/${widget.totalQuestions}",
                      icon: Icons.layers_rounded),
                ],
              ),
              const SizedBox(height: 14),
              Glass(
                radius: BorderRadius.circular(22),
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(999),
                      child: SizedBox(
                        height: 10,
                        child: LinearProgressIndicator(
                          value: progress,
                          backgroundColor: Colors.white.withValues(alpha: 0.10),
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Color.lerp(const Color(0xFF33D6FF),
                                const Color(0xFFFF4BD8), 1.0 - progress)!,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    _VocabPromptRow(question: q),
                    if (showReading &&
                        (q["reading"] as String?)?.trim().isNotEmpty ==
                            true) ...[
                      const SizedBox(height: 8),
                      Text(
                        q["reading"] as String,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.55),
                            fontSize: 13.5,
                            fontWeight: FontWeight.w600),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 14),
              _TtsControls(
                rates: const [0.75, 1.0, 1.25],
                selectedRate: _speechRate,
                onRateSelected: (rate) {
                  setState(() => _speechRate = rate);
                  ttsService.setRate(rate);
                },
                onSpeak: _speakPrompt,
              ),
              const SizedBox(height: 12),
              Expanded(
                child: ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  itemCount: choices.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (_, i) {
                    final isSel = selected == i;
                    final isCorrect = i == _correctIndex;

                    Color bg = Colors.white.withValues(alpha: 0.06);
                    Color border = Colors.white.withValues(alpha: 0.14);

                    if (revealed) {
                      if (isCorrect) {
                        bg = const Color(0xFF2AFADF).withValues(alpha: 0.14);
                        border = const Color(0xFF2AFADF).withValues(alpha: 0.85);
                      } else if (isSel) {
                        // User selected this wrong answer
                        bg = const Color(0xFFFF4FD8).withValues(alpha: 0.12);
                        border = const Color(0xFFFF4FD8).withValues(alpha: 0.85);
                      }
                    } else {
                      if (isSel) {
                        bg = Colors.white.withValues(alpha: 0.12);
                        border = Colors.white.withValues(alpha: 0.28);
                      }
                    }

                    return StaggeredIn(
                      index: i,
                      child: PressableScale(
                        onTap: revealed
                            ? null
                            : () {
                                setState(() => selected = i);
                                _submit();
                              },
                        child: AnimatedScale(
                          scale: revealed && isCorrect ? 1.02 : 1,
                          duration: MotionTokens.short,
                          curve: MotionTokens.standardCurve,
                          child: AnimatedContainer(
                            duration: MotionTokens.short,
                            curve: MotionTokens.standardCurve,
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(18),
                              color: bg,
                              border: Border.all(color: border),
                              boxShadow: revealed && isCorrect
                                  ? [
                                      BoxShadow(
                                        color: const Color(0xFF2AFADF).withValues(alpha: 0.35),
                                        blurRadius: 16,
                                        spreadRadius: 1,
                                      ),
                                    ]
                                  : [],
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    choices[i],
                                    style: TextStyle(
                                        color: Colors.white.withValues(alpha: 0.92),
                                        fontSize: 16,
                                        fontWeight: FontWeight.w800),
                                  ),
                                ),
                                if (revealed && isCorrect) ...[
                                  const Icon(Icons.check_rounded, color: Color(0xFF2AFADF)),
                                  const SizedBox(width: 6),
                                  const RewardSparkle(show: true),
                                ] else if (revealed && isSel && !isCorrect)
                                  const Icon(Icons.close_rounded, color: Color(0xFFFF4FD8))
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 10),
              if (revealed && widget.timePerQuestion == null)
                NeonButton(
                  label: "Next",
                  onTap: _next,
                ),
            ],
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
  Widget build(BuildContext context) => InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Glass(
            radius: BorderRadius.circular(16),
            padding: const EdgeInsets.all(10),
            child: Icon(icon, color: Colors.white.withValues(alpha: 0.92))),
      );
}

class _ChoiceSet {
  final List<String> choices;
  final int correctIndex;

  const _ChoiceSet({required this.choices, required this.correctIndex});
}

class _TtsControls extends StatelessWidget {
  final List<double> rates;
  final double selectedRate;
  final ValueChanged<double> onRateSelected;
  final VoidCallback onSpeak;

  const _TtsControls({
    required this.rates,
    required this.selectedRate,
    required this.onRateSelected,
    required this.onSpeak,
  });

  @override
  Widget build(BuildContext context) {
    return Glass(
      radius: BorderRadius.circular(18),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          ...rates.map((rate) {
            final selected = rate == selectedRate;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: _SpeedChip(
                label: "${rate.toStringAsFixed(rate == 1.0 ? 0 : 2)}x",
                selected: selected,
                onTap: () => onRateSelected(rate),
              ),
            );
          }),
          const Spacer(),
          InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: onSpeak,
            child: Padding(
              padding: const EdgeInsets.all(6),
              child: Icon(Icons.volume_up_rounded,
                  color: Colors.white.withValues(alpha: 0.9)),
            ),
          ),
        ],
      ),
    );
  }
}

class _SpeedChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _SpeedChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(999),
      onTap: onTap,
      child: Container(
        height: 30,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(999),
          color: selected
              ? Colors.white.withValues(alpha: 0.16)
              : Colors.white.withValues(alpha: 0.08),
          border: Border.all(
              color: selected
                  ? Colors.white.withValues(alpha: 0.32)
                  : Colors.white.withValues(alpha: 0.16)),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: const TextStyle(
              color: Colors.white, fontWeight: FontWeight.w800, fontSize: 12),
        ),
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  final String text;
  final IconData icon;
  const _Pill({required this.text, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        color: Colors.white.withValues(alpha: 0.08),
        border: Border.all(color: Colors.white.withValues(alpha: 0.14)),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.white.withValues(alpha: 0.9)),
          const SizedBox(width: 6),
          Text(text,
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.w900)),
        ],
      ),
    );
  }
}

class _VocabPromptRow extends StatelessWidget {
  final Map<String, dynamic> question;

  const _VocabPromptRow({required this.question});

  @override
  Widget build(BuildContext context) {
    final prompt = question["prompt"]?.toString() ?? '';
    final article = question["article"]?.toString().trim() ?? '';
    final word = question["word"]?.toString().trim() ?? '';
    final gender = question["gender"]?.toString().trim() ?? '';
    final hasArticle = article.isNotEmpty && word.isNotEmpty;

    final baseStyle = const TextStyle(
      color: Colors.white,
      fontSize: 22,
      height: 1.25,
      fontWeight: FontWeight.w900,
    );

    final textWidget = hasArticle
        ? Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: article,
                  style: baseStyle.copyWith(color: const Color(0xFF2AFADF)),
                ),
                const TextSpan(text: ' '),
                TextSpan(text: word, style: baseStyle),
              ],
            ),
            textAlign: TextAlign.center,
          )
        : Text(
            prompt,
            textAlign: TextAlign.center,
            style: baseStyle,
          );

    return Row(
      children: [
        Expanded(child: textWidget),
        if (gender.isNotEmpty) ...[
          const SizedBox(width: 8),
          _GenderChip(label: gender),
        ],
      ],
    );
  }
}

class _GenderChip extends StatelessWidget {
  final String label;

  const _GenderChip({required this.label});

  @override
  Widget build(BuildContext context) {
    final trimmed = label.trim();
    final display = trimmed.isEmpty
        ? ""
        : (trimmed.length <= 2 && !trimmed.contains(' '))
            ? trimmed.toLowerCase()
            : trimmed.substring(0, 1).toLowerCase();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        color: Colors.white.withValues(alpha: 0.10),
        border: Border.all(color: Colors.white.withValues(alpha: 0.18)),
      ),
      child: Text(
        display,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w800,
          fontSize: 11.5,
          letterSpacing: 0.6,
        ),
      ),
    );
  }
}
