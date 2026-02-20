import 'dart:async';
import 'package:flutter/material.dart';
import '../../core/services/haptics_service.dart';
import '../../core/services/sfx_service.dart';

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
import '../../data/settings_repository.dart';

class SoloSentencesQuizScreen extends StatefulWidget {
  const SoloSentencesQuizScreen({
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
  State<SoloSentencesQuizScreen> createState() =>
      _SoloSentencesQuizScreenState();
}

class _SoloSentencesQuizScreenState extends State<SoloSentencesQuizScreen> {
  List<Map<String, dynamic>> questions = [];
  bool _loading = true;
  String? _loadError;

  int index = 0;
  int correctCount = 0;
  int? selected;
  bool revealed = false;
  bool showReading = true;
  bool showTranslation = true;
  List<String> _choices = [];
  int _correctIndex = 0;
  String _prompt = '';
  String _correctAnswer = ''; // the word that fills the blank
  double _speechRate = 1.0;

  final List<Map<String, dynamic>> mistakes = [];

  late int remaining;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    remaining = widget.timePerQuestion ?? 0;
    _loadSettings();
    if (widget.reviewQuestions != null && widget.reviewQuestions!.isNotEmpty) {
      questions = widget.reviewQuestions!;
      _loading = false;
      _prepareQuestion();
      _startTimer();
    } else {
      _loadQuestions();
    }
  }

  Future<void> _loadSettings() async {
    final settings = await settingsRepository.getSettings();
    final readingSetting = settings['show_reading'];
    final translationSetting = settings['show_translation'];
    if (!mounted) return;
    setState(() {
      if (readingSetting is bool) showReading = readingSetting;
      if (translationSetting is bool) showTranslation = translationSetting;
    });
  }

  Future<void> _loadQuestions() async {
    try {
      final dbQuestions = await quizRepository.getSentenceQuestions(
          widget.course.id, widget.totalQuestions);
      if (mounted) {
        setState(() {
          questions = dbQuestions;
          _loading = false;
          _loadError = dbQuestions.isEmpty
              ? 'No sentence questions are available yet for this course.'
              : null;
        });
        if (questions.isNotEmpty) {
          _prepareQuestion();
          _startTimer();
        }
      }
    } catch (e, stack) {
      debugPrint("Error loading quiz: $e");
      if (mounted) {
        setState(() {
          _loading = false;
          _loadError = 'Failed to load sentence questions. Please try again.';
        });
        debugPrint('$stack');
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
    ttsService.stop();
    super.dispose();
  }

  void _submit({bool timedOut = false}) {
    if (revealed) return;
    if (!timedOut && selected == null) return;
    timer?.cancel();

    final q = questions[index % questions.length];
    final ok = !timedOut && selected == _correctIndex;

    if (ok) {
      correctCount++;
      if (correctCount > 0 && correctCount % 3 == 0) {
        hapticsService.mediumImpact();
        sfxService.risingTone();
      } else {
        hapticsService.mediumImpact();
        sfxService.softClick();
      }
    } else {
      mistakes.add(q);
      hapticsService.lightImpact();
      sfxService.click();
    }

    setState(() {
      revealed = true;
    });
    final speakFuture = _speakSentence();

    if (widget.timePerQuestion != null) {
      speakFuture.whenComplete(() {
        if (!mounted) return;
        Future.delayed(const Duration(milliseconds: 1000), () {
          if (!mounted) return;
          _next();
        });
      });
    }
  }

  Future<void> _speakSentence({bool withDelay = true}) {
    if (!revealed) return Future.value();
    final q = questions[index % questions.length];
    final sentence = q['full_sentence']?.toString() ?? '';
    if (sentence.trim().isEmpty || sentence.trim() == 'null') return Future.value();
    final lang = q['target_lang']?.toString().trim() ?? '';
    // Always pass a language. TtsService will stay silent if empty or unavailable.
    if (lang.isEmpty) return Future.value();
    final completer = Completer<void>();
    final delay = withDelay ? const Duration(milliseconds: 350) : Duration.zero;
    Timer(delay, () async {
      if (!mounted) {
        completer.complete();
        return;
      }
      try {
        await ttsService.speak(sentence, language: lang);
      } catch (e) {
        debugPrint('TTS Error in _speakSentence: $e');
      }
      completer.complete();
    });
    return completer.future;
  }

  void _onSpeakTap() {
    if (!revealed) return;
    _speakSentence(withDelay: false);
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

      // Sanitise DB null literals — Supabase may return the string 'null' for NULL columns.
      String sanitize(dynamic v) {
        final s = v?.toString().trim() ?? '';
        return s == 'null' ? '' : s;
      }

      final sentence = sanitize(q['full_sentence'] ?? q['sentence']);
      if ((q['full_sentence']?.toString().trim() ?? '') == 'null') q['full_sentence'] = null;
      if ((q['reading']?.toString().trim() ?? '') == 'null') q['reading'] = null;
      if ((q['translation']?.toString().trim() ?? '') == 'null') q['translation'] = null;

      final hasPool = q['choice_pool'] is List;
      final blanked = hasPool && sentence.isNotEmpty ? _blankSentence(sentence) : null;
      final choiceSet = _buildChoiceSet(q, blanked?.answer);
      setState(() {
        _prompt = blanked?.prompt ?? sanitize(q['prompt'] ?? sentence);
        _correctAnswer = blanked?.answer ?? sanitize(q['correct_answer']);
        _choices = choiceSet.choices;
        _correctIndex = choiceSet.correctIndex;
      });
    } catch (e, stack) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Error Preparing Question'),
          content: SingleChildScrollView(child: Text('$e\n$stack')),
          actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK'))],
        ),
      );
    }
  }


  _ChoiceSet _buildChoiceSet(
      Map<String, dynamic> question, String? correctOverride) {
    final pool = question['choice_pool'];
    final correctAnswer =
        (correctOverride ?? question['correct_answer']?.toString() ?? '').trim();
    if (pool is List && correctAnswer.isNotEmpty) {
      final items = pool
          .map((e) => e.toString().trim())
          .where((e) => e.isNotEmpty && e != 'null' && e != correctAnswer)
          .toSet()
          .toList();
      items.shuffle();
      final choices = <String>[correctAnswer, ...items.take(3)];
      choices.shuffle();
      return _ChoiceSet(
          choices: choices, correctIndex: choices.indexOf(correctAnswer));
    }

    final fallback = question['choices'];
    if (fallback is List) {
      final choices = fallback
          .map((e) => e.toString().trim())
          .where((e) => e.isNotEmpty && e != 'null')
          .toList();
      final correctIndex =
          question['correct'] is int ? question['correct'] as int : 0;
      return _ChoiceSet(choices: choices, correctIndex: correctIndex);
    }

    return const _ChoiceSet(choices: [], correctIndex: 0);
  }

  _BlankResult? _blankSentence(String sentence) {
    if (sentence.trim().isEmpty) return null;
    if (sentence.contains(RegExp(r'\s'))) {
      final parts = sentence.split(RegExp(r'\s+'));
      final candidates = <int>[];
      for (var i = 0; i < parts.length; i++) {
        final cleaned = parts[i]
            .replaceAll(
                RegExp(r"^[^\p{L}\p{M}'-]+|[^\p{L}\p{M}'-]+$", unicode: true),
                '')
            .trim();
        if (cleaned.isNotEmpty) {
          candidates.add(i);
        }
      }
      if (candidates.isEmpty) return null;
      candidates.shuffle();
      final pickIndex = candidates.first;
      final original = parts[pickIndex];
      final cleaned = original
          .replaceAll(
              RegExp(r"^[^\p{L}\p{M}'-]+|[^\p{L}\p{M}'-]+$", unicode: true), '')
          .trim();
      if (cleaned.isEmpty) return null;
      parts[pickIndex] = original.replaceFirst(cleaned, '____');
      return _BlankResult(prompt: parts.join(' '), answer: cleaned);
    }

    final chars =
        sentence.runes.map((rune) => String.fromCharCode(rune)).toList();
    if (chars.isEmpty) return null;
    chars.shuffle();
    final answer = chars.first;
    final index = sentence.runes.toList().indexOf(answer.runes.first);
    final promptChars =
        sentence.runes.map((rune) => String.fromCharCode(rune)).toList();
    if (index >= 0 && index < promptChars.length) {
      promptChars[index] = '____';
    }
    return _BlankResult(prompt: promptChars.join(''), answer: answer);
  }

  void _goToResults() {
    final totalAnswered = questions.length < widget.totalQuestions
        ? questions.length
        : widget.totalQuestions;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => SoloResultScreen(
          course: widget.course,
          mode: SoloMode.sentences,
          level: widget.level,
          correct: correctCount,
          total: totalAnswered,
          points: correctCount * 25,
          mistakes: mistakes,
          onPlayAgain: () {
            Navigator.pop(context);
          },
          onReviewMistakes: () {
            Navigator.pop(context);
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator(color: Color(0xFF33D6FF))),
      );
    }

    if (_loadError != null) {
      return Scaffold(
        appBar: AppBar(),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(_loadError!, textAlign: TextAlign.center),
                const SizedBox(height: 12),
                FilledButton(
                  onPressed: () {
                    setState(() {
                      _loading = true;
                      _loadError = null;
                    });
                    _loadQuestions();
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    try {
      final scheme = Theme.of(context).colorScheme;
      final q = questions[index % questions.length];
      final choices = _choices;
      final timeLimit = widget.timePerQuestion;
      final progress =
          timeLimit == null ? 1.0 : (remaining / timeLimit).clamp(0.0, 1.0);

      return Scaffold(
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final compactHeight = constraints.maxHeight < 760;
              final topSpacing = compactHeight ? 12.0 : 18.0;
              final sectionSpacing = compactHeight ? 10.0 : 14.0;
              final choicesTopSpacing = compactHeight ? 20.0 : 30.0;
              return Padding(
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
                      "Sentences • ${widget.course.title}",
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: scheme.onSurface,
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
                      text:
                          "${index + 1}/${questions.length < widget.totalQuestions ? questions.length : widget.totalQuestions}",
                      icon: Icons.layers_rounded),
                ],
              ),
              SizedBox(height: topSpacing),
              ClipRRect(
                borderRadius: BorderRadius.circular(999),
                child: SizedBox(
                  height: 10,
                  child: LinearProgressIndicator(
                    value: progress,
                    backgroundColor: scheme.onSurface.withValues(alpha: 0.10),
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Color.lerp(const Color(0xFF33D6FF),
                          const Color(0xFFFF4BD8), 1.0 - progress)!,
                    ),
                  ),
                ),
              ),
              SizedBox(height: topSpacing),
              Glass(
                radius: BorderRadius.circular(22),
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(minHeight: 92),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                      Row(
                        children: [
                          Expanded(
                            child: _SentencePromptWidget(
                              prompt: _prompt,
                              correctAnswer: _correctAnswer,
                              revealed: revealed,
                              langCode: q['target_lang']?.toString() ?? '',
                              scheme: scheme,
                              fontSize: 22,
                            ),
                          ),
                        ],
                      ),
                      if (revealed &&
                          showReading &&
                          (q['reading']?.toString().trim() ?? '').isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Directionality(
                          textDirection: _isRtlLang(q['target_lang']?.toString() ?? '')
                              ? TextDirection.rtl
                              : TextDirection.ltr,
                          child: Text(
                            q['reading'] as String,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: scheme.onSurface.withValues(alpha: 0.55),
                                fontSize: 13.5,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                      if (showTranslation) ...[
                        SizedBox(height: compactHeight ? 8 : 10),
                        Directionality(
                          textDirection: _isRtlLang(q['source_lang']?.toString() ?? '')
                              ? TextDirection.rtl
                              : TextDirection.ltr,
                          child: Text(
                            q['translation']?.toString() ?? '',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: scheme.onSurface.withValues(alpha: 0.80),
                                fontSize: 16,
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              SizedBox(height: sectionSpacing),
              Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 330),
                  child: _TtsControls(
                    rates: const [0.75, 1.0, 1.25],
                    selectedRate: _speechRate,
                    onRateSelected: (rate) {
                      setState(() => _speechRate = rate);
                      ttsService.setRate(rate);
                    },
                    onSpeak: _onSpeakTap,
                    disabled: !revealed,
                  ),
                ),
              ),
              SizedBox(height: choicesTopSpacing),
              Expanded(
                child: ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  itemCount: choices.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (_, i) {
                    final isSel = selected == i;
                    final isCorrect = i == _correctIndex;

                    Color bg = scheme.onSurface.withValues(alpha: 0.10);
                    Color border = scheme.onSurface.withValues(alpha: 0.20);

                    if (revealed) {
                      if (isCorrect) {
                        bg = const Color(0xFF2AFADF).withValues(alpha: 0.14);
                        border = const Color(0xFF2AFADF).withValues(alpha: 0.85);
                      } else if (isSel) {
                        bg = const Color(0xFFFF4FD8).withValues(alpha: 0.12);
                        border = const Color(0xFFFF4FD8).withValues(alpha: 0.85);
                      }
                    } else {
                      if (isSel) {
                        bg = scheme.onSurface.withValues(alpha: 0.12);
                        border = scheme.onSurface.withValues(alpha: 0.28);
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
                                  child: Directionality(
                                    textDirection: _isRtlLang(q['target_lang']?.toString() ?? '')
                                        ? TextDirection.rtl
                                        : TextDirection.ltr,
                                    child: Text(
                                      choices[i],
                                      style: TextStyle(
                                          color: scheme.onSurface.withValues(alpha: 0.92),
                                          fontSize: 16,
                                          fontWeight: FontWeight.w800),
                                    ),
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
              SizedBox(height: compactHeight ? 8 : 10),
              if (revealed && widget.timePerQuestion == null)
                NeonButton(
                  label: "Next",
                  onTap: _next,
                ),
                  ],
                ),
              );
            },
          ),
        ),
      );
    } catch (e, stack) {
      return Scaffold(
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Text("Build Error: $e\n$stack",
                style: const TextStyle(color: Colors.red)),
          ),
        ),
      );
    }
  }
}

// ----------- RTL detection ---------------------------------------------------

/// Returns [true] if the given 2-letter language code uses a right-to-left script.
bool _isRtlLang(String code) {
  const rtl = {
    'ar', 'he', 'fa', 'ur', 'ps', 'sd', 'ug', 'yi',
    'dv', 'ks', 'ku', 'ha', 'az', // Azerbaijani when written in Arabic script
  };
  return rtl.contains(code.trim().toLowerCase().split('-').first);
}

// ----------- Widgets ---------------------------------------------------------

class _SentencePromptWidget extends StatelessWidget {
  final String prompt;       // The blanked sentence  e.g. "Ich ____ Deutsch"
  final String correctAnswer; // The word that fills the blank
  final bool revealed;
  final String langCode;
  final ColorScheme scheme;
  final double fontSize;

  const _SentencePromptWidget({
    required this.prompt,
    required this.correctAnswer,
    required this.revealed,
    required this.langCode,
    required this.scheme,
    required this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    final isRtl = _isRtlLang(langCode);
    final textDir = isRtl ? TextDirection.rtl : TextDirection.ltr;
    final baseStyle = TextStyle(
      color: scheme.onSurface,
      fontSize: fontSize,
      height: 1.35,
      fontWeight: FontWeight.w900,
    );

    Widget child;
    if (revealed && correctAnswer.isNotEmpty && prompt.contains('____')) {
      // Replace ____ with the highlighted correct answer.
      final parts = prompt.split('____');
      child = Text.rich(
        TextSpan(
          children: [
            for (var i = 0; i < parts.length; i++) ...[
              TextSpan(text: parts[i], style: baseStyle),
              if (i < parts.length - 1)
                TextSpan(
                  text: correctAnswer,
                  style: baseStyle.copyWith(
                    color: const Color(0xFF2AFADF),
                    decoration: TextDecoration.underline,
                    decorationColor: const Color(0xFF2AFADF),
                  ),
                ),
            ],
          ],
        ),
        textAlign: TextAlign.center,
        textDirection: textDir,
      );
    } else {
      child = Text(
        prompt.isNotEmpty ? prompt : '…',
        textAlign: TextAlign.center,
        textDirection: textDir,
        style: baseStyle,
      );
    }

    return Directionality(textDirection: textDir, child: child);
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
          child: Icon(icon, color: scheme.onSurface.withValues(alpha: 0.92))),
    );
  }
}

class _ChoiceSet {
  final List<String> choices;
  final int correctIndex;

  const _ChoiceSet({required this.choices, required this.correctIndex});
}

class _BlankResult {
  final String prompt;
  final String answer;

  const _BlankResult({required this.prompt, required this.answer});
}


class _TtsControls extends StatelessWidget {
  final List<double> rates;
  final double selectedRate;
  final ValueChanged<double> onRateSelected;
  final VoidCallback onSpeak;
  final bool disabled;

  const _TtsControls({
    required this.rates,
    required this.selectedRate,
    required this.onRateSelected,
    required this.onSpeak,
    required this.disabled,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final opacity = disabled ? 0.5 : 1.0;
    return Opacity(
      opacity: opacity,
      child: Glass(
        radius: BorderRadius.circular(16),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
        child: Row(
          children: [
            ...rates.map((rate) {
              final selected = rate == selectedRate;
              return Padding(
                padding: const EdgeInsets.only(right: 6),
                child: _SpeedChip(
                  label: "${rate.toStringAsFixed(rate == 1.0 ? 0 : 2)}x",
                  selected: selected,
                  onTap: disabled ? null : () => onRateSelected(rate),
                ),
              );
            }),
            const Spacer(),
            InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: disabled ? null : onSpeak,
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: Icon(
                  Icons.volume_up_rounded,
                  color: scheme.onSurface.withValues(alpha: 0.9),
                  size: 18,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SpeedChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback? onTap;

  const _SpeedChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return InkWell(
      borderRadius: BorderRadius.circular(999),
      onTap: onTap,
      child: Container(
        height: 24,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(999),
          color: selected
              ? scheme.onSurface.withValues(alpha: 0.16)
              : scheme.onSurface.withValues(alpha: 0.08),
          border: Border.all(
              color: selected
                  ? scheme.onSurface.withValues(alpha: 0.32)
                  : scheme.onSurface.withValues(alpha: 0.16)),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
              color: scheme.onSurface, fontWeight: FontWeight.w800, fontSize: 11),
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
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        color: scheme.onSurface.withValues(alpha: 0.08),
        border: Border.all(color: scheme.onSurface.withValues(alpha: 0.14)),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: scheme.onSurface.withValues(alpha: 0.9)),
          const SizedBox(width: 6),
          Text(text,
              style: TextStyle(
                  color: scheme.onSurface, fontWeight: FontWeight.w900)),
        ],
      ),
    );
  }
}
