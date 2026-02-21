import 'package:flutter_test/flutter_test.dart';
import 'package:soma/models/vocab_question.dart';
import 'package:soma/models/sentence_question.dart';

void main() {
  group('VocabQuestion', () {
    final sampleMap = {
      'concept_id': 42,
      'word': 'chien',
      'article': 'le',
      'reading': '',
      'gender': 'm',
      'target_word': 'chien',
      'native_word': 'dog',
      'target_lang': 'fr',
      'source_lang': 'en',
      'prompt': 'chien',
      'choices': ['dog', 'cat', 'fish', 'bird'],
      'correct': 0,
      'correct_answer': 'dog',
      'target_choices': ['chien', 'chat', 'poisson', 'oiseau'],
      'native_choices': ['dog', 'cat', 'fish', 'bird'],
      'choice_pool': ['dog', 'cat', 'fish', 'bird'],
    };

    test('fromMap parses all fields correctly', () {
      final q = VocabQuestion.fromMap(sampleMap);

      expect(q.conceptId, 42);
      expect(q.word, 'chien');
      expect(q.article, 'le');
      expect(q.gender, 'm');
      expect(q.targetWord, 'chien');
      expect(q.nativeWord, 'dog');
      expect(q.targetLang, 'fr');
      expect(q.sourceLang, 'en');
      expect(q.prompt, 'chien');
      expect(q.choices, ['dog', 'cat', 'fish', 'bird']);
      expect(q.correct, 0);
      expect(q.correctAnswer, 'dog');
    });

    test('toMap round-trips cleanly', () {
      final q = VocabQuestion.fromMap(sampleMap);
      final m = q.toMap();

      expect(m['concept_id'], 42);
      expect(m['word'], 'chien');
      expect(m['correct_answer'], 'dog');
      expect(m['choices'], isA<List>());
    });

    test('fromMap handles null/missing fields gracefully', () {
      final q = VocabQuestion.fromMap({});

      expect(q.conceptId, 0);
      expect(q.word, '');
      expect(q.choices, isEmpty);
    });

    test('fromMap strips the string literal "null"', () {
      final q = VocabQuestion.fromMap({'word': 'null', 'article': 'NULL'});

      expect(q.word, '');
      expect(q.article, '');
    });
  });

  group('SentenceQuestion', () {
    final sampleMap = {
      'concept_id': 7,
      'prompt': 'Le ____ est grand',
      'full_sentence': 'Le chien est grand',
      'translation': 'The dog is big',
      'reading': '',
      'choices': ['chien', 'chat', 'poisson'],
      'correct': 0,
      'correct_answer': 'chien',
      'choice_pool': ['chien', 'chat', 'poisson'],
      'target_lang': 'fr',
      'source_lang': 'en',
    };

    test('fromMap parses all fields correctly', () {
      final q = SentenceQuestion.fromMap(sampleMap);

      expect(q.conceptId, 7);
      expect(q.prompt, 'Le ____ est grand');
      expect(q.fullSentence, 'Le chien est grand');
      expect(q.translation, 'The dog is big');
      expect(q.choices, ['chien', 'chat', 'poisson']);
      expect(q.correct, 0);
      expect(q.correctAnswer, 'chien');
      expect(q.targetLang, 'fr');
    });

    test('toMap round-trips cleanly', () {
      final q = SentenceQuestion.fromMap(sampleMap);
      final m = q.toMap();

      expect(m['prompt'], 'Le ____ est grand');
      expect(m['correct_answer'], 'chien');
    });

    test('fromMap handles empty map', () {
      final q = SentenceQuestion.fromMap({});

      expect(q.conceptId, 0);
      expect(q.prompt, '');
      expect(q.choices, isEmpty);
    });
  });
}
