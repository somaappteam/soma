
import 'dart:io';

void main() async {
  print('--- Vocabulary Analysis ---');
  final vocabFile = File('assets/vocabulary.csv');
  final vocabLines = await vocabFile.readAsLines();
  if (vocabLines.isNotEmpty) {
    final header = vocabLines[0].split(',');
    final langIndex = header.indexOf('lang_code');
    final conceptIndex = header.indexOf('concept_id');
    final wordIndex = header.indexOf('word');

    final langValidConcepts = <String, Set<int>>{};

    for (var i = 1; i < vocabLines.length; i++) {
      final parts = vocabLines[i].split(',');
      if (parts.length <= langIndex || parts.length <= conceptIndex || parts.length <= wordIndex) continue;

      final lang = parts[langIndex].trim();
      final word = parts[wordIndex].trim().toLowerCase();
      if (word == 'null' || word.isEmpty) continue;

      final concept = int.tryParse(parts[conceptIndex].trim());
      if (concept == null) continue;

      langValidConcepts.putIfAbsent(lang, () => <int>{}).add(concept);
    }

    void checkPair(String l1, String l2) {
      if (langValidConcepts.containsKey(l1) && langValidConcepts.containsKey(l2)) {
        final common = langValidConcepts[l1]!.intersection(langValidConcepts[l2]!);
        print('$l1 <-> $l2: ${common.length} common vocabulary concepts');
      }
    }
    checkPair('en', 'de');
    checkPair('en', 'es');
  }

  print('\n--- Sentences Analysis ---');
  final sentFile = File('assets/sentences.csv');
  final sentLines = await sentFile.readAsLines();
  if (sentLines.isNotEmpty) {
    final header = sentLines[0].split(',');
    final langIndex = header.indexOf('lang_code');
    final conceptIndex = header.indexOf('concept_id');
    final textIndex = header.indexOf('text');

    final langValidConcepts = <String, Set<int>>{};

    for (var i = 1; i < sentLines.length; i++) {
      final parts = sentLines[i].split(',');
      if (parts.length <= langIndex || parts.length <= conceptIndex || parts.length <= textIndex) continue;

      final lang = parts[langIndex].trim();
      final text = parts[textIndex].trim().toLowerCase();
      if (text == 'null' || text.isEmpty) continue;

      final concept = int.tryParse(parts[conceptIndex].trim());
      if (concept == null) continue;

      langValidConcepts.putIfAbsent(lang, () => <int>{}).add(concept);
    }

    void checkPair(String l1, String l2) {
      if (langValidConcepts.containsKey(l1) && langValidConcepts.containsKey(l2)) {
        final common = langValidConcepts[l1]!.intersection(langValidConcepts[l2]!);
        print('$l1 <-> $l2: ${common.length} common sentence concepts');
      }
    }
    checkPair('en', 'de');
    checkPair('en', 'es');
  }
}
