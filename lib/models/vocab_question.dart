/// Typed model for a vocabulary quiz question.
///
/// Use [fromMap] to parse the raw [Map<String,dynamic>] from [QuizRepository],
/// and [toMap] to convert back for any existing call-sites that index by key.
class VocabQuestion {
  final int conceptId;

  /// The word in the **target** language.
  final String word;
  final String article;
  final String reading;
  final String gender;

  final String targetWord;
  final String nativeWord;

  final String targetLang;
  final String sourceLang;

  /// Prompt shown to the user (reversed or normal).
  final String prompt;

  /// Pre-built choice list (already shuffled).
  final List<String> choices;

  /// Index of the correct choice within [choices].
  final int correct;

  final String correctAnswer;

  final List<String> targetChoices;
  final List<String> nativeChoices;
  final List<String> choicePool;

  const VocabQuestion({
    required this.conceptId,
    required this.word,
    required this.article,
    required this.reading,
    required this.gender,
    required this.targetWord,
    required this.nativeWord,
    required this.targetLang,
    required this.sourceLang,
    required this.prompt,
    required this.choices,
    required this.correct,
    required this.correctAnswer,
    required this.targetChoices,
    required this.nativeChoices,
    required this.choicePool,
  });

  // ─── Factory ───────────────────────────────────────────────────────────────

  factory VocabQuestion.fromMap(Map<String, dynamic> m) {
    List<String> _list(dynamic v) =>
        (v is List) ? v.map((e) => e.toString()).toList() : <String>[];

    return VocabQuestion(
      conceptId: _parseInt(m['concept_id']) ?? 0,
      word: _str(m['word']),
      article: _str(m['article']),
      reading: _str(m['reading']),
      gender: _str(m['gender']),
      targetWord: _str(m['target_word']),
      nativeWord: _str(m['native_word']),
      targetLang: _str(m['target_lang']),
      sourceLang: _str(m['source_lang']),
      prompt: _str(m['prompt']),
      choices: _list(m['choices']),
      correct: _parseInt(m['correct']) ?? 0,
      correctAnswer: _str(m['correct_answer']),
      targetChoices: _list(m['target_choices']),
      nativeChoices: _list(m['native_choices']),
      choicePool: _list(m['choice_pool']),
    );
  }

  // ─── Serialisation ─────────────────────────────────────────────────────────

  Map<String, dynamic> toMap() => {
        'concept_id': conceptId,
        'word': word,
        'article': article,
        'reading': reading,
        'gender': gender,
        'target_word': targetWord,
        'native_word': nativeWord,
        'target_lang': targetLang,
        'source_lang': sourceLang,
        'prompt': prompt,
        'choices': choices,
        'correct': correct,
        'correct_answer': correctAnswer,
        'target_choices': targetChoices,
        'native_choices': nativeChoices,
        'choice_pool': choicePool,
      };

  // ─── Helpers ───────────────────────────────────────────────────────────────

  static int? _parseInt(dynamic v) {
    if (v is int) return v;
    return int.tryParse(v?.toString() ?? '');
  }

  static String _str(dynamic v) {
    final s = v?.toString().trim() ?? '';
    return s.toLowerCase() == 'null' ? '' : s;
  }

  @override
  String toString() => 'VocabQuestion(conceptId: $conceptId, word: $word)';
}
