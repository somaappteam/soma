/// Typed model for a sentence fill-in-the-blank quiz question.
///
/// Use [fromMap] to parse the raw [Map<String,dynamic>] from [QuizRepository],
/// and [toMap] to convert back for any existing call-sites that index by key.
class SentenceQuestion {
  final int conceptId;

  /// Target language sentence with the blanked word replaced by `____`.
  final String prompt;

  /// The full, un-blanked target sentence.
  final String fullSentence;

  /// Native-language translation shown after answering.
  final String translation;

  /// Romanisation / furigana hint for the target sentence.
  final String reading;

  /// Pre-built choice list (already shuffled).
  final List<String> choices;

  /// Index of the correct choice within [choices].
  final int correct;

  final String correctAnswer;
  final List<String> choicePool;

  final String targetLang;
  final String sourceLang;

  const SentenceQuestion({
    required this.conceptId,
    required this.prompt,
    required this.fullSentence,
    required this.translation,
    required this.reading,
    required this.choices,
    required this.correct,
    required this.correctAnswer,
    required this.choicePool,
    required this.targetLang,
    required this.sourceLang,
  });

  // ─── Factory ───────────────────────────────────────────────────────────────

  factory SentenceQuestion.fromMap(final Map<String, dynamic> m) {
    List<String> list(final dynamic v) =>
        (v is List) ? v.map((final e) => e.toString()).toList() : <String>[];

    return SentenceQuestion(
      conceptId: _parseInt(m['concept_id']) ?? 0,
      prompt: _str(m['prompt']),
      fullSentence: _str(m['full_sentence']),
      translation: _str(m['translation']),
      reading: _str(m['reading']),
      choices: list(m['choices']),
      correct: _parseInt(m['correct']) ?? 0,
      correctAnswer: _str(m['correct_answer']),
      choicePool: list(m['choice_pool']),
      targetLang: _str(m['target_lang']),
      sourceLang: _str(m['source_lang']),
    );
  }

  // ─── Serialisation ─────────────────────────────────────────────────────────

  Map<String, dynamic> toMap() => {
        'concept_id': conceptId,
        'prompt': prompt,
        'full_sentence': fullSentence,
        'translation': translation,
        'reading': reading,
        'choices': choices,
        'correct': correct,
        'correct_answer': correctAnswer,
        'choice_pool': choicePool,
        'target_lang': targetLang,
        'source_lang': sourceLang,
      };

  // ─── Helpers ───────────────────────────────────────────────────────────────

  static int? _parseInt(final dynamic v) {
    if (v is int) return v;
    return int.tryParse(v?.toString() ?? '');
  }

  static String _str(final dynamic v) {
    final s = v?.toString().trim() ?? '';
    return s.toLowerCase() == 'null' ? '' : s;
  }

  @override
  String toString() =>
      'SentenceQuestion(conceptId: $conceptId, prompt: $prompt)';
}
