class FillBlankQuestion {
  final String prompt; // sentence with ___
  final String translation; // translation line
  final String? reading; // âœ… optional: pinyin / romaji / transliteration

  final List<String> choices;
  final int correctIndex;
  final String? hint;

  const FillBlankQuestion({
    required this.prompt,
    required this.translation,
    this.reading, // âœ…
    required this.choices,
    required this.correctIndex,
    this.hint,
  });
}
