import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  List<Map<String, dynamic>> questions = [];
  bool _loading = true;
  String? _loadError;

  int index = 0;
  int correctCount = 0;
  int? selected;
  bool revealed = false;
  bool showReading = true;
  bool _reverseLanguage = false;
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
    _loadSettings();
    if (widget.reviewQuestions != null && widget.reviewQuestions!.isNotEmpty) {
      questions = widget.reviewQuestions!;
      _loading = false;
      _prepareQuestion();
      _startTimer();
    } else {
      _checkForSavedSession();
    }
  }

  // --------------- Session persistence ----------------------------------------

  String get _sessionKey => 'quiz_session_vocab_${widget.course.id}';

  Future<void> _saveSession() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final payload = jsonEncode({
        'index': index,
        'correct': correctCount,
        'level': widget.level,
        'total': widget.totalQuestions,
        'saved_at': DateTime.now().millisecondsSinceEpoch,
        'questions': questions,
      });
      await prefs.setString(_sessionKey, payload);
    } catch (e) {
      debugPrint('Session save error: $e');
    }
  }

  Future<void> _clearSession() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_sessionKey);
    } catch (_) {}
  }

  Future<void> _checkForSavedSession() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_sessionKey);
      if (raw == null) {
        _loadQuestions();
        return;
      }
      final data = jsonDecode(raw) as Map<String, dynamic>;
      final savedAt = data['saved_at'] as int? ?? 0;
      final ageH = (DateTime.now().millisecondsSinceEpoch - savedAt) / 3600000;
      // Discard sessions older than 24 hours.
      if (ageH > 24) {
        await _clearSession();
        _loadQuestions();
        return;
      }
      final savedLevel = data['level']?.toString() ?? widget.level;
      if (savedLevel != widget.level) {
        await _clearSession();
        _loadQuestions();
        return;
      }
      // Offer resume dialog.
      if (!mounted) return;
      final resume = await _showResumeDialog();
      if (!mounted) return;
      if (resume == true) {
        final savedQuestions = (data['questions'] as List? ?? [])
            .whereType<Map>()
            .map((e) => Map<String, dynamic>.from(e))
            .toList();
        final savedIndex = (data['index'] as int? ?? 0).clamp(0, savedQuestions.length - 1);
        setState(() {
          questions = savedQuestions;
          index = savedIndex;
          correctCount = data['correct'] as int? ?? 0;
          _loading = false;
          _loadError = savedQuestions.isEmpty ? 'No questions in saved session.' : null;
        });
        if (questions.isNotEmpty) {
          _prepareQuestion();
          _startTimer();
        }
      } else {
        await _clearSession();
        _loadQuestions();
      }
    } catch (e) {
      debugPrint('Session load error: $e');
      _loadQuestions();
    }
  }

  Future<bool?> _showResumeDialog() {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        final scheme = Theme.of(ctx).colorScheme;
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: scheme.surface.withValues(alpha: 0.95),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: scheme.onSurface.withValues(alpha: 0.12)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.history_rounded, size: 40, color: scheme.primary),
                const SizedBox(height: 12),
                Text(
                  'Resume session?',
                  style: TextStyle(
                    color: scheme.onSurface,
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'You have an unfinished quiz. Would you like to continue where you left off?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: scheme.onSurface.withValues(alpha: 0.7),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(ctx, false),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: scheme.onSurface,
                          side: BorderSide(color: scheme.onSurface.withValues(alpha: 0.25)),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        ),
                        child: const Text('Start fresh'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: FilledButton(
                        onPressed: () => Navigator.pop(ctx, true),
                        style: FilledButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        ),
                        child: const Text('Resume'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
  // ---------------------------------------------------------------------------

  Future<void> _loadSettings() async {
    final settings = await settingsRepository.getSettings();
    final readingSetting = settings['show_reading'];
    if (readingSetting is bool && mounted) {
      setState(() => showReading = readingSetting);
    }
  }

  Future<void> _loadQuestions() async {
    // Try fetch from DB
    try {
      final dbQuestions = await quizRepository.getVocabQuestions(
          widget.course.id, widget.totalQuestions);
      if (mounted) {
        setState(() {
          questions = dbQuestions;
          _loading = false;
          _loadError = dbQuestions.isEmpty
              ? 'No vocabulary questions are available yet for this course.'
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
          _loadError = 'Failed to load vocabulary questions. Please try again.';
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
    _saveSession(); // persist progress after each question
    _prepareQuestion();
    _startTimer();
  }

  void _prepareQuestion() {
    try {
      if (questions.isEmpty) return;
      final q = questions[index % questions.length];

      // Sanitise raw DB values — Supabase may return the string 'null' for NULL columns.
      String sanitize(String? v) {
        final s = v?.toString().trim() ?? '';
        return s == 'null' ? '' : s;
      }

      final nativeWord = sanitize(q['native_word']?.toString());
      final targetWord = sanitize(q['target_word']?.toString());

      // Also sanitise per-question fields that may be 'null'.
      if ((q['article']?.toString().trim() ?? '') == 'null') q['article'] = null;
      if ((q['word']?.toString().trim() ?? '') == 'null') q['word'] = null;
      if ((q['reading']?.toString().trim() ?? '') == 'null') q['reading'] = null;

      // Build the full word pool from whichever language is the answer language.
      // native_choices / target_choices are the pre-built pools stored in the question.
      List<String> answerPool;
      String correctAnswer;
      String promptText;

      if (_reverseLanguage && nativeWord.isNotEmpty && targetWord.isNotEmpty) {
        // Prompt: native word → answer: target word.
        promptText = nativeWord;
        correctAnswer = targetWord;
        answerPool = (q['target_choices'] as List?)?.map((e) => e.toString()).where(
          (e) => e.trim().isNotEmpty && e.trim() != 'null').toList() ?? [];
      } else {
        // Prompt: target word → answer: native word.
        promptText = targetWord.isNotEmpty ? targetWord : sanitize(q['prompt']?.toString());
        correctAnswer = nativeWord.isNotEmpty ? nativeWord : sanitize(q['correct_answer']?.toString());
        answerPool = (q['native_choices'] as List?)?.map((e) => e.toString()).where(
          (e) => e.trim().isNotEmpty && e.trim() != 'null').toList() ?? [];
      }

      // Update the question map so the prompt widget shows the right text.
      q['prompt'] = promptText;

      final choiceSet = _buildChoiceSet(correctAnswer, answerPool);
      setState(() {
        _choices = choiceSet.choices;
        _correctIndex = choiceSet.correctIndex;
      });
      _scheduleQuestionAudio();
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

  void _scheduleQuestionAudio() {
    _ttsTimer?.cancel();
    final q = questions[index % questions.length];
    final prompt = _speechText(q);
    if (prompt.trim().isEmpty) return;
    // When reversed the user reads the native word, so we speak source lang; otherwise target.
    final lang = _reverseLanguage
        ? (q['source_lang']?.toString() ?? '')
        : (q['target_lang']?.toString() ?? '');
    _ttsTimer = Timer(const Duration(milliseconds: 350), () async {
      if (!mounted) return;
      try {
        await ttsService.setRate(_speechRate);
        await ttsService.speak(prompt, language: lang.isNotEmpty ? lang : null);
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
      final lang = _reverseLanguage
          ? (q['source_lang']?.toString() ?? '')
          : (q['target_lang']?.toString() ?? '');
      await ttsService.setRate(_speechRate);
      await ttsService.speak(prompt, language: lang.isNotEmpty ? lang : null);
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

  /// Builds a [_ChoiceSet] with exactly 4 options: the [correctAnswer] plus up to
  /// 3 unique random distractors drawn from [pool]. The list is always shuffled
  /// so the correct answer appears in a random position each time.
  _ChoiceSet _buildChoiceSet(String correctAnswer, List<String> pool) {
    if (correctAnswer.trim().isEmpty) return const _ChoiceSet(choices: [], correctIndex: 0);

    final distractors = pool
        .map((e) => e.toString().trim())
        .where((e) => e.isNotEmpty && e != 'null' && e != correctAnswer)
        .toSet()
        .toList();
    distractors.shuffle();

    final choices = <String>[correctAnswer, ...distractors.take(3)];
    choices.shuffle();
    return _ChoiceSet(choices: choices, correctIndex: choices.indexOf(correctAnswer));
  }

  void _goToResults() {
    _clearSession(); // clear saved session on quiz completion
    final totalAnswered = questions.length < widget.totalQuestions
        ? questions.length
        : widget.totalQuestions;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => SoloResultScreen(
          course: widget.course,
          mode: SoloMode.vocabulary,
          level: widget.level,
          correct: correctCount,
          total: totalAnswered,
          points: correctCount * 15,
          mistakes: mistakes,
          onPlayAgain: () {
            Navigator.pop(context); // Go back to detail
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
                Text(
                  _loadError!,
                  textAlign: TextAlign.center,
                ),
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
    final scheme = Theme.of(context).colorScheme;
    final q = questions[index % questions.length];
    final List<String> choices = _choices;
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
                      "Solo • ${widget.course.title}",
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: scheme.onSurface,
                          fontSize: 18,
                          fontWeight: FontWeight.w900),
                    ),
                  ),
                  _IconGlass(
                    icon: Icons.swap_horiz_rounded,
                    onTap: () {
                      setState(() {
                        _reverseLanguage = !_reverseLanguage;
                        _prepareQuestion(); // Re-prepare current question instantly
                      });
                    },
                  ),
                  const SizedBox(width: 8),
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
                  child: AnimatedSize(
                    duration: MotionTokens.short,
                    curve: MotionTokens.standardCurve,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                    _VocabPromptRow(
                      question: q,
                      langCode: _reverseLanguage
                          ? (q['source_lang']?.toString() ?? '')
                          : (q['target_lang']?.toString() ?? ''),
                    ),
                    if (showReading &&
                        (q['reading']?.toString().trim() ?? '').isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Directionality(
                        textDirection: _isRtlLang(
                                _reverseLanguage
                                    ? (q['source_lang']?.toString() ?? '')
                                    : (q['target_lang']?.toString() ?? ''),
                              )
                            ? TextDirection.rtl
                            : TextDirection.ltr,
                        child: Text(
                          q['reading']?.toString() ?? '',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: scheme.onSurface.withValues(alpha: 0.55),
                              fontSize: 13.5,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      ],
                    ],
                    ),
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
                    onSpeak: _speakPrompt,
                  ),
                ),
              ),
              SizedBox(height: choicesTopSpacing),
              Expanded(
                child: ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(12, 20, 12, 20),
                  clipBehavior: Clip.none,
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
                        // User selected this wrong answer
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
                            constraints: const BoxConstraints(minHeight: 72),
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
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
                            child: AnimatedSize(
                              duration: MotionTokens.short,
                              curve: MotionTokens.standardCurve,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Directionality(
                                      textDirection: _isRtlLang(
                                            _reverseLanguage
                                                ? (q['target_lang']?.toString() ?? '')
                                                : (q['source_lang']?.toString() ?? ''),
                                          )
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
                                  const SizedBox(width: 8),
                                 AnimatedSwitcher(
                                   duration: MotionTokens.short,
                                   transitionBuilder: (child, anim) => FadeTransition(opacity: anim, child: ScaleTransition(scale: anim, child: child)),
                                   child: (revealed && isCorrect)
                                     ? Row(
                                         mainAxisSize: MainAxisSize.min,
                                         key: const ValueKey('correct-reveal'),
                                         children: [
                                           const Icon(Icons.check_rounded, color: Color(0xFF2AFADF)),
                                           const SizedBox(width: 6),
                                           const RewardSparkle(show: true),
                                         ],
                                       )
                                     : (revealed && isSel && !isCorrect)
                                         ? const Icon(Icons.close_rounded, color: Color(0xFFFF4FD8), key: ValueKey('wrong-reveal'))
                                         : const SizedBox.shrink(key: ValueKey('none')),
                                 ),
                              ],
                            ),
                          ),
                        ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: compactHeight ? 8 : 10),
              if (widget.timePerQuestion == null)
                AnimatedSize(
                  duration: MotionTokens.short,
                  curve: MotionTokens.standardCurve,
                  child: revealed
                      ? Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: NeonButton(
                            label: "Next",
                            onTap: _next,
                          ),
                        )
                      : const SizedBox(width: double.infinity, height: 0),
                ),
            ],
              ),
            );
          },
        ),
      ),
    );
  }
}

// ----------- RTL detection ---------------------------------------------------

/// Returns [true] if the given 2-letter language code uses a right-to-left script.
bool _isRtlLang(String code) {
  const rtl = {
    'ar', 'he', 'fa', 'ur', 'ps', 'sd', 'ug', 'yi',
    'dv', 'ks', 'ku', 'ha',
  };
  return rtl.contains(code.trim().toLowerCase().split('-').first);
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
    final scheme = Theme.of(context).colorScheme;
    return Glass(
      radius: BorderRadius.circular(18),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      child: Row(
        children: [
          ...rates.map((rate) {
            final selected = rate == selectedRate;
            return Padding(
              padding: const EdgeInsets.only(right: 6),
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
              padding: const EdgeInsets.all(4),
              child: Icon(Icons.volume_up_rounded,
                  color: scheme.onSurface.withValues(alpha: 0.9), size: 18),
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
        color: scheme.onSurface.withValues(alpha: 0.1),
        border: Border.all(color: scheme.onSurface.withValues(alpha: 0.2)),
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

class _VocabPromptRow extends StatelessWidget {
  final Map<String, dynamic> question;
  final String langCode;

  const _VocabPromptRow({required this.question, required this.langCode});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final prompt = question['prompt']?.toString() ?? '';
    final article = question['article']?.toString().trim() ?? '';
    final word = question['word']?.toString().trim() ?? '';
    final gender = question['gender']?.toString().trim() ?? '';
    final isReversed = prompt == question['native_word']; // Native word acts as prompt
    final hasArticle = article.isNotEmpty && word.isNotEmpty && !isReversed
        && article != 'null' && word != 'null';

    final isRtl = _isRtlLang(langCode);
    final textDir = isRtl ? TextDirection.rtl : TextDirection.ltr;

    final baseStyle = TextStyle(
      color: scheme.onSurface,
      fontSize: 22,
      height: 1.25,
      fontWeight: FontWeight.w900,
    );

    final textWidget = hasArticle
        ? Directionality(
            textDirection: textDir,
            child: Text.rich(
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
            ),
          )
        : Directionality(
            textDirection: textDir,
            child: Text(
              prompt,
              textAlign: TextAlign.center,
              style: baseStyle,
            ),
          );

    return Row(
      children: [
        Expanded(child: textWidget),
        if (gender.isNotEmpty && gender != 'null') ...[
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
    final scheme = Theme.of(context).colorScheme;
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
        color: scheme.onSurface.withValues(alpha: 0.10),
        border: Border.all(color: scheme.onSurface.withValues(alpha: 0.18)),
      ),
      child: Text(
        display,
        style: TextStyle(
          color: scheme.onSurface,
          fontWeight: FontWeight.w800,
          fontSize: 11.5,
          letterSpacing: 0.6,
        ),
      ),
    );
  }
}
