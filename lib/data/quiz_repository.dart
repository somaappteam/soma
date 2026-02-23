import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:soma/core/database/database_helper.dart';
import 'package:soma/core/di/locator.dart';
import 'package:soma/data/achievements_repository.dart';
import 'package:soma/data/offline_queue_repository.dart';
import 'package:soma/data/quiz_local_store.dart';
import 'package:soma/data/settings_repository.dart';
import 'package:soma/data/stats_repository.dart';
import 'package:soma/data/vocab_data_source.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class QuizRepository {
  final SupabaseClient _client = Supabase.instance.client;
  final Random _random = Random();
  final VocabSrsStore _srsStore = VocabSrsStore();

  Future<List<Map<String, dynamic>>> getVocabQuestions(final String courseId, final int limit,
      {final bool reverse = false, final Set<int>? onlyConceptIds, final bool preferDue = true}) async {
    final langs = _parseCourseLangs(courseId);
    if (langs == null) return [];
    final dueConcepts = preferDue ? await _srsStore.dueConceptIds(courseId) : <int>[];

    try {
      List<Map<String, dynamic>> sourceList;
      List<Map<String, dynamic>> targetList;

      final sqliteSrc = const SqliteVocabDataSource();
      final sqliteRes = await sqliteSrc.fetchVocab(sourceLang: langs.source, targetLang: langs.target);
      sourceList = sqliteRes.source;
      targetList = sqliteRes.target;

      if (sourceList.isEmpty || targetList.isEmpty) {
        final csvSrc = const CsvVocabDataSource();
        final csvRes = await csvSrc.fetchVocab(sourceLang: langs.source, targetLang: langs.target);
        sourceList = csvRes.source;
        targetList = csvRes.target;
      }

      if (sourceList.isEmpty || targetList.isEmpty) {
        return [];
      }

      final targetByConcept = <int, Map<String, dynamic>>{};
      final sourceByConcept = <int, Map<String, dynamic>>{};
      for (final row in targetList) {
        final concept = _parseInt(row['concept_id']);
        if (concept == null || row['word'] == null) continue;
        targetByConcept[concept] = row;
      }
      for (final row in sourceList) {
        final concept = _parseInt(row['concept_id']);
        if (concept == null || row['word'] == null) continue;
        sourceByConcept[concept] = row;
      }

      final candidates = <Map<String, dynamic>>[];
      for (final row in targetList) {
        final concept = _parseInt(row['concept_id']);
        if (concept == null) continue;

        // Skip if source doesn't exist
        final sourceRow = sourceByConcept[concept];
        if (sourceRow == null) continue;

        // Skip if either word is empty (strict filtering)
        final targetWord = _formatVocabWord(row);
        final sourceWord = _formatVocabWord(sourceRow);
        if (targetWord.isEmpty || sourceWord.isEmpty) continue;

        if (onlyConceptIds == null || onlyConceptIds.contains(concept)) {
          candidates.add(row);
        }
      }

      final dueSet = dueConcepts.toSet();
      final dueCandidates = candidates
          .where((final row) => dueSet.contains(_parseInt(row['concept_id'])))
          .toList();
      dueCandidates.shuffle();

      final selected = <Map<String, dynamic>>[];
      selected.addAll(dueCandidates.take(limit));

      if (selected.length < limit) {
        final remaining = candidates
            .where((final row) => !selected.contains(row))
            .toList();
        remaining.shuffle();
        selected.addAll(remaining.take(limit - selected.length));
      }

      selected.shuffle();

      final sourceWords = sourceList
          .map(_formatVocabWord)
          .where((final word) => word.isNotEmpty)
          .toSet()
          .toList();

      final targetWords = targetList
          .map(_formatVocabWord)
          .where((final word) => word.isNotEmpty)
          .toSet()
          .toList();

      final questions = selected.map((final row) {
        final concept = _parseInt(row['concept_id']);
        final sourceRow = sourceByConcept[concept]!;

        final targetWord = _formatVocabWord(row);
        final correct = _formatVocabWord(sourceRow);

        // Strip the string literal 'null' returned by Supabase for NULL columns.
        String s(final dynamic v) {
          final t = v?.toString().trim() ?? '';
          return t.toLowerCase() == 'null' ? '' : t;
        }

        final nativeChoices = _buildChoices(sourceWords, correct);
        final targetChoices = _buildChoices(targetWords, targetWord);
        
        return {
          'concept_id': concept,
          'word': s(row['word']),
          'article': s(row['article']),
          'reading': s(row['pronunciation']),
          'gender': s(row['gender']),

          // Reversible toggle properties
          'target_word': targetWord,
          'native_word': correct,
          'target_choices': targetChoices,
          'native_choices': nativeChoices,

          // Language codes for TTS
          'target_lang': langs.target,
          'source_lang': langs.source,

          // Reverse-aware display fields
          'prompt': reverse ? correct : targetWord,
          'choices': reverse ? targetChoices : nativeChoices,
          'correct': reverse ? targetChoices.indexOf(targetWord) : nativeChoices.indexOf(correct),
          'correct_answer': reverse ? targetWord : correct,
          'choice_pool': reverse ? targetWords : sourceWords,
        };
      }).toList();

      return questions;
    } catch (e) {
      debugPrint('Error fetching vocab questions from CSV/SQLite: $e');
      return [];
    }
  }

  // Fallback or future implementation for Sentences
  Future<List<Map<String, dynamic>>> getSentenceQuestions(final String courseId, final int limit, {final Set<int>? onlyConceptIds}) async {
    final langs = _parseCourseLangs(courseId);
    if (langs == null) return [];

    try {
      List<Map<String, dynamic>> sourceList;
      List<Map<String, dynamic>> targetList;

      final sqliteSrc = const SqliteSentenceDataSource();
      final sqliteRes = await sqliteSrc.fetchSentences(sourceLang: langs.source, targetLang: langs.target);
      sourceList = sqliteRes.source;
      targetList = sqliteRes.target;

      if (sourceList.isEmpty || targetList.isEmpty) {
        final csvSrc = const CsvSentenceDataSource();
        final csvRes = await csvSrc.fetchSentences(sourceLang: langs.source, targetLang: langs.target);
        sourceList = csvRes.source;
        targetList = csvRes.target;
      }

      if (sourceList.isEmpty || targetList.isEmpty) {
         return [];
      }

      final targetByConcept = <int, Map<String, dynamic>>{};
      final sourceByConcept = <int, Map<String, dynamic>>{};
      for (final row in targetList) {
        final concept = _parseInt(row['concept_id']);
        if (concept == null || row['sentence'] == null) continue;
        targetByConcept[concept] = row;
      }
      for (final row in sourceList) {
        final concept = _parseInt(row['concept_id']);
        if (concept == null || row['sentence'] == null) continue;
        sourceByConcept[concept] = row;
      }

      final candidates = <Map<String, dynamic>>[];
      for (final row in targetList) {
        final concept = _parseInt(row['concept_id']);
        if (concept == null) continue;

        // Skip if source doesn't exist
        final sourceRow = sourceByConcept[concept];
        if (sourceRow == null) continue;

        // Skip if either sentence is empty
        final targetSentence = row['sentence']?.toString() ?? '';
        final sourceSentence = sourceRow['sentence']?.toString() ?? '';
        if (targetSentence.trim().isEmpty || sourceSentence.trim().isEmpty) continue;

        // Skip if 'null' literal (CSV often has this)
        if (targetSentence.toLowerCase() == 'null' || sourceSentence.toLowerCase() == 'null') continue;

        // CRITICAL: Skip if blanking fails (this was likely the main issue for sentences)
        if (_blankSentence(targetSentence) == null) continue;

        if (onlyConceptIds == null || onlyConceptIds.contains(concept)) {
          candidates.add(row);
        }
      }

      candidates.shuffle();
      final selected = candidates.take(limit).toList();
      final targetWords = <String>{};
      for (final row in targetList) {
        final sentence = row['sentence']?.toString() ?? '';
        if (sentence.trim().isEmpty) continue;
        targetWords.addAll(_extractSentenceWords(sentence));
      }
      final targetPool = targetWords.where((final word) => word.trim().isNotEmpty).toList();

      final questions = selected.map((final row) {
        final concept = _parseInt(row['concept_id'])!;
        final targetRow = targetByConcept[concept]!;
        final sourceRow = sourceByConcept[concept]!;

        final targetSentence = targetRow['sentence']?.toString() ?? '';
        final sourceSentence = sourceRow['sentence']?.toString() ?? '';

        // Strip 'null' literals that Supabase may return for NULL columns.
        String s(final dynamic v) {
          final t = v?.toString().trim() ?? '';
          return t.toLowerCase() == 'null' ? '' : t;
        }

        final blanked = _blankSentence(targetSentence)!;

        final choices = _buildChoices(targetPool, blanked.answer);
        return {
          'concept_id': concept,
          'prompt': blanked.prompt,
          'full_sentence': targetSentence,
          'translation': s(sourceSentence),
          'reading': s(targetRow['pronunciation']),
          'choices': choices,
          'correct': choices.indexOf(blanked.answer),
          'choice_pool': targetPool,
          'correct_answer': blanked.answer,
          // Language codes for TTS
          'target_lang': langs.target,
          'source_lang': langs.source,
        };
      }).toList();

        return questions;
    } catch (e) {
      debugPrint('Error fetching sentence questions from CSV/SQLite: $e');
      return [];
    }
  }

  Future<void> recordVocabAnswer({
    required final String courseId,
    required final Map<String, dynamic> question,
    required final bool correct,
  }) async {
    final conceptId = _parseInt(question['concept_id']);
    if (conceptId == null) return;
    await _srsStore.recordResult(
      courseId: courseId,
      conceptId: conceptId,
      correct: correct,
    );
  }


  Future<Set<int>> _reviewConceptIds(final String courseId, {required final String scope}) async {
    final entries = await _srsStore.load(courseId);
    if (entries.isEmpty) return <int>{};

    if (scope == 'struggling') {
      return entries.values
          .where((final entry) => entry.intervalDays <= 1 && entry.easeFactor < 2.5)
          .map((final entry) => entry.conceptId)
          .toSet();
    }

    return entries.keys.toSet();
  }

  Future<List<Map<String, dynamic>>> getVocabReviewQuestions(
    final String courseId,
    final int limit, {
    required final String scope,
  }) async {
    final conceptIds = await _reviewConceptIds(courseId, scope: scope);
    if (conceptIds.isEmpty) return [];
    return getVocabQuestions(
      courseId,
      limit,
      onlyConceptIds: conceptIds,
      preferDue: false,
    );
  }

  Future<List<Map<String, dynamic>>> getSentenceReviewQuestions(
    final String courseId,
    final int limit, {
    required final String scope,
  }) async {
    final conceptIds = await _reviewConceptIds(courseId, scope: scope);
    if (conceptIds.isEmpty) return [];
    return getSentenceQuestions(courseId, limit, onlyConceptIds: conceptIds);
  }

  _LangPair? _parseCourseLangs(final String courseId) {
    if (courseId.contains('-')) {
      final parts = courseId.split('-');
      if (parts.length == 2) {
        return _LangPair(source: parts[0].trim(), target: parts[1].trim());
      }
    }
    final parts = courseId.split('_');
    if (parts.length >= 3) {
      final source = parts[1].trim();
      final target = parts[2].trim();
      if (source.isNotEmpty && target.isNotEmpty) {
        return _LangPair(source: source, target: target);
      }
    }
    return null;
  }

  List<Map<String, dynamic>> _rowsToMapList(final dynamic rows) {
    if (rows is! List) return [];
    return rows
        .whereType<Map>()
        .map((final row) => Map<String, dynamic>.from(row))
        .toList();
  }

  int? _parseInt(final dynamic value) {
    if (value is int) return value;
    return int.tryParse(value?.toString() ?? '');
  }

  String _formatVocabWord(final Map<String, dynamic> row) {
    // Treat the string literal 'null' (which SQLite/CSV can produce) as empty.
    String nonNull(final dynamic v) {
      final s = v?.toString().trim() ?? '';
      return s.toLowerCase() == 'null' ? '' : s;
    }
    final word = nonNull(row['word']);
    if (word.isEmpty) return '';
    final article = nonNull(row['article']);
    return article.isEmpty ? word : '$article $word';
  }

  // ----------- Stopwords -------------------------------------------------------
  // Common stopwords and grammatical particles to skip when blanking sentences.
  // Kept deliberately minimal — covers the most frequent languages in the app.
  static final Set<String> _kStopwords = {
    // English
    'a', 'an', 'the', 'is', 'are', 'was', 'were', 'be', 'been', 'being',
    'i', 'me', 'my', 'we', 'our', 'you', 'your', 'he', 'she', 'it',
    'they', 'them', 'their', 'this', 'that', 'these', 'those',
    'in', 'on', 'at', 'to', 'for', 'of', 'and', 'or', 'but', 'not',
    'with', 'by', 'from', 'as', 'so', 'do', 'did', 'does', 'have', 'has', 'had',
    // German
    'der', 'die', 'das', 'ein', 'eine', 'und', 'oder', 'aber', 'ist', 'sind',
    'war', 'ich', 'du', 'er', 'sie', 'es', 'wir', 'ihr', 'den', 'dem',
    'in', 'an', 'auf', 'bei', 'mit', 'von', 'zu', 'für', 'als',
    // French
    'le', 'la', 'les', 'un', 'une', 'des', 'et', 'ou', 'mais', 'est',
    'je', 'tu', 'il', 'elle', 'nous', 'vous', 'ils', 'elles',
    'en', 'à', 'de', 'du', 'au', 'par', 'sur', 'dans', 'avec',
    // Spanish
    'el', 'la', 'los', 'las', 'un', 'una', 'unos', 'unas', 'y', 'o',
    'es', 'son', 'era', 'yo', 'tú', 'él', 'ella', 'nosotros', 'ellos',
    'en', 'de', 'del', 'al', 'con', 'por', 'para', 'que', 'no',
    // Japanese particles/copulas (common)
    'は', 'が', 'を', 'に', 'で', 'と', 'も', 'か', 'の', 'へ', 'から', 'まで',
    'です', 'ます', 'した', 'て', 'な', 'だ',
    // Chinese particles/copulas
    '的', '了', '在', '是', '有', '和', '也', '都', '不', '没', '人',
    // Korean particles
    '은', '는', '이', '가', '을', '를', '에', '의', '과', '와', '도', '로',
  };

  /// Builds 4 answer choices: [correct] + 3 distractors.
  /// Distractors are preferred from the same word-length bucket as [correct]
  /// (short ≤5, medium 6-10, long >10) for more plausible wrong options.
  List<String> _buildChoices(final List<String> pool, final String correct) {
    final unique = pool
        .where((final v) => v.trim().isNotEmpty && v != correct)
        .toSet()
        .toList();

    // Bucket by word length for more plausible distractors.
    int bucket(final String w) {
      final len = w.length;
      if (len <= 5) return 0;   // short
      if (len <= 10) return 1;  // medium
      return 2;                 // long
    }

    final correctBucket = bucket(correct);
    final sameBucket = unique.where((final v) => bucket(v) == correctBucket).toList();
    sameBucket.shuffle();

    List<String> distractors;
    if (sameBucket.length >= 3) {
      distractors = sameBucket.take(3).toList();
    } else {
      // Not enough same-bucket words — pad from the full pool.
      final rest = unique.where((final v) => bucket(v) != correctBucket).toList();
      rest.shuffle();
      distractors = [...sameBucket, ...rest.take(3 - sameBucket.length)];
    }

    final choices = <String>[correct, ...distractors];
    choices.shuffle();
    return choices;
  }

  List<String> _extractSentenceWords(final String sentence) {
    if (sentence.trim().isEmpty) return [];
    if (sentence.contains(RegExp(r'\s'))) {
      final parts = sentence.split(RegExp(r'\s+'));
      final words = <String>[];
      for (final part in parts) {
        final cleaned = part.replaceAll(RegExp(r"^[^\p{L}\p{M}'-]+|[^\p{L}\p{M}'-]+$", unicode: true), '');
        if (cleaned.isNotEmpty) {
          words.add(cleaned);
        }
      }
      return words;
    }

    final chars = sentence.runes.map((final rune) => String.fromCharCode(rune)).toList();
    return chars.where((final char) => char.trim().isNotEmpty).toList();
  }

  _BlankResult? _blankSentence(final String sentence) {
    if (sentence.trim().isEmpty) return null;
    if (sentence.contains(RegExp(r'\s'))) {
      final parts = sentence.split(RegExp(r'\s+'));

      // Build candidate indices, skipping stopwords/particles.
      List<int> candidates0(final bool skipStopwords) {
        final result = <int>[];
        for (var i = 0; i < parts.length; i++) {
          final cleaned = parts[i]
              .replaceAll(RegExp(r"^[^\p{L}\p{M}'-]+|[^\p{L}\p{M}'-]+$", unicode: true), '')
              .trim();
          if (cleaned.isEmpty) continue;
          if (skipStopwords && _kStopwords.contains(cleaned.toLowerCase())) continue;
          result.add(i);
        }
        return result;
      }

      // Prefer content-word candidates; fall back to all words if none found.
      var candidates = candidates0(true);
      if (candidates.isEmpty) candidates = candidates0(false);
      if (candidates.isEmpty) return null;

      final pickIndex = candidates[_random.nextInt(candidates.length)];
      final original = parts[pickIndex];
      final cleaned = original
          .replaceAll(RegExp(r"^[^\p{L}\p{M}'-]+|[^\p{L}\p{M}'-]+$", unicode: true), '')
          .trim();
      if (cleaned.isEmpty) return null;
      parts[pickIndex] = original.replaceFirst(cleaned, '____');
      return _BlankResult(prompt: parts.join(' '), answer: cleaned);
    }

    // CJK / single-character language fallback: pick a non-stopword char.
    final chars = sentence.runes.map((final rune) => String.fromCharCode(rune)).toList();
    if (chars.isEmpty) return null;
    final contentChars = chars
        .asMap()
        .entries
        .where((final e) => e.value.trim().isNotEmpty && !_kStopwords.contains(e.value))
        .map((final e) => e.key)
        .toList();
    final pickIndex = contentChars.isNotEmpty
        ? contentChars[_random.nextInt(contentChars.length)]
        : _random.nextInt(chars.length);
    final answer = chars[pickIndex];
    chars[pickIndex] = '____';
    return _BlankResult(prompt: chars.join(''), answer: answer);
  }

  // Supabase Fetching Methods

  Future<List<Map<String, dynamic>>> getVocabQuestionsFromSupabase(
      final String courseId, final int limit,
      {final bool reverse = false, final Set<int>? onlyConceptIds}) async {
    final langs = _parseCourseLangs(courseId);
    if (langs == null) return [];

    try {
      // 1. Fetch source language items
      final sourceResponse = await _client
          .from('vocabulary')
          .select()
          .eq('lang_code', langs.source) // Changed to lang_code
          .limit(1000); // Fetch a decent pool

      // 2. Fetch target language items 
      final targetResponse = await _client
          .from('vocabulary')
          .select()
          .eq('lang_code', langs.target) // Changed to lang_code
          .limit(1000);

      final sourceList = List<Map<String, dynamic>>.from(sourceResponse);
      final targetList = List<Map<String, dynamic>>.from(targetResponse);

      debugPrint('Supabase Vocab Fetch: Source(${langs.source})=${sourceList.length}, Target(${langs.target})=${targetList.length}');

      if (sourceList.isEmpty || targetList.isEmpty) return [];

      final targetByConcept = <int, Map<String, dynamic>>{};
      final sourceByConcept = <int, Map<String, dynamic>>{};
      
      for (final row in targetList) {
        final concept = _parseInt(row['concept_id']);
        if (concept != null && row['word'] != null) targetByConcept[concept] = row;
      }
      for (final row in sourceList) {
        final concept = _parseInt(row['concept_id']);
        if (concept != null && row['word'] != null) sourceByConcept[concept] = row;
      }

      final candidates = <Map<String, dynamic>>[];
      targetByConcept.forEach((final concept, final row) {
        final sourceRow = sourceByConcept[concept];
        if (sourceRow != null) {
          // Strict filtering: skip items with empty words after formatting
          final targetWord = _formatVocabWord(row);
          final nativeWord = _formatVocabWord(sourceRow);
          
          if (targetWord.isNotEmpty && nativeWord.isNotEmpty) {
            if (onlyConceptIds == null || onlyConceptIds.contains(concept)) {
              candidates.add(row);
            }
          }
        }
      });

      candidates.shuffle();
      final selected = candidates.take(limit).toList();

      final sourceWords = sourceList
          .map(_formatVocabWord)
          .where((final word) => word.isNotEmpty)
          .toSet()
          .toList();

      final targetWords = targetList
          .map(_formatVocabWord)
          .where((final word) => word.isNotEmpty)
          .toSet()
          .toList();

      return selected.map((final row) {
        final concept = _parseInt(row['concept_id'])!;
        final sourceRow = sourceByConcept[concept]!;

        // Strip the string literal 'null' returned by Supabase for NULL columns.
        String s(final dynamic v) {
          final t = v?.toString().trim() ?? '';
          return t == 'null' ? '' : t;
        }

        final targetWord = _formatVocabWord(row);
        final nativeWord = _formatVocabWord(sourceRow);

        final nativeChoices = _buildChoices(sourceWords, nativeWord);
        final targetChoices = _buildChoices(targetWords, targetWord);

        return {
          'concept_id': concept,
          'prompt': reverse ? nativeWord : targetWord,
          'word': s(row['word']),
          'article': s(row['article']),
          'reading': s(row['pronunciation']),
          'gender': s(row['gender']),
          'choices': reverse ? targetChoices : nativeChoices,
          'correct': reverse ? targetChoices.indexOf(targetWord) : nativeChoices.indexOf(nativeWord),
          'choice_pool': reverse ? targetWords : sourceWords,
          'correct_answer': reverse ? targetWord : nativeWord,
          'translation': reverse ? targetWord : nativeWord,
          'target_word': targetWord,
          'native_word': nativeWord,
          'target_lang': langs.target,
          'source_lang': langs.source,
        };
      }).toList();

    } catch (e) {
      debugPrint('Error fetching vocab from Supabase: $e');
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getSentenceQuestionsFromSupabase(final String courseId, final int limit, {final Set<int>? onlyConceptIds}) async {
    final langs = _parseCourseLangs(courseId);
    if (langs == null) return [];

    try {
      final sourceResponse = await _client
          .from('sentences')
          .select()
          .eq('lang_code', langs.source) // Note: using lang_code as per schema
          .limit(1000);

      final targetResponse = await _client
          .from('sentences')
          .select()
          .eq('lang_code', langs.target)
          .limit(1000);

      final sourceList = List<Map<String, dynamic>>.from(sourceResponse);
      final targetList = List<Map<String, dynamic>>.from(targetResponse);

      debugPrint('Supabase Sentence Fetch: Source(${langs.source})=${sourceList.length}, Target(${langs.target})=${targetList.length}');

      if (sourceList.isEmpty || targetList.isEmpty) return [];

      final targetByConcept = <int, Map<String, dynamic>>{};
      final sourceByConcept = <int, Map<String, dynamic>>{};

      for (final row in targetList) {
        final concept = _parseInt(row['concept_id']);
        if (concept != null && row['sentence'] != null) targetByConcept[concept] = row;
      }
      for (final row in sourceList) {
        final concept = _parseInt(row['concept_id']);
        if (concept != null && row['sentence'] != null) sourceByConcept[concept] = row;
      }

      final candidates = <Map<String, dynamic>>[];
      targetByConcept.forEach((final concept, final row) {
        final sourceRow = sourceByConcept[concept];
        if (sourceRow != null) {
          final targetSentence = row['sentence']?.toString() ?? '';
          final sourceSentence = sourceRow['sentence']?.toString() ?? '';
          
          if (targetSentence.isNotEmpty && sourceSentence.isNotEmpty && 
              targetSentence.toLowerCase() != 'null' && sourceSentence.toLowerCase() != 'null') {
            
            // CRITICAL: Blanking check
            if (_blankSentence(targetSentence) != null) {
              if (onlyConceptIds == null || onlyConceptIds.contains(concept)) {
                candidates.add(row);
              }
            }
          }
        }
      });

      candidates.shuffle();
      final selected = candidates.take(limit).toList();
      
      final targetWords = <String>{};
      for (final row in targetList) {
        final sentence = row['sentence']?.toString() ?? '';
        if (sentence.trim().isEmpty) continue;
        targetWords.addAll(_extractSentenceWords(sentence));
      }
      final targetPool = targetWords.where((final word) => word.trim().isNotEmpty).toList();

      return selected.map((final row) {
        final concept = _parseInt(row['concept_id'])!;
        final sourceRow = sourceByConcept[concept]!;

        final targetSentence = row['sentence']?.toString() ?? '';
        final sourceSentence = sourceRow['sentence']?.toString() ?? '';

        final blanked = _blankSentence(targetSentence)!;

        final choices = _buildChoices(targetPool, blanked.answer);

        return {
          'concept_id': concept,
          'prompt': blanked.prompt,
          'full_sentence': targetSentence,
          'translation': sourceSentence,
          'reading': row['pronunciation'] ?? '',
          'choices': choices,
          'correct': choices.indexOf(blanked.answer),
          'choice_pool': targetPool,
          'correct_answer': blanked.answer,
        };
      }).toList();

    } catch (e) {
      debugPrint('Error fetching sentences from Supabase: $e');
      return [];
    }
  }
  // Save quiz result to Supabase and Local SQLite
  Future<void> saveQuizResult({
    required final String courseId,
    required final int xpEarned,
    required final int correctCount,
    required final int totalCount,
  }) async {
    final client = Supabase.instance.client;
    final userId = client.auth.currentUser?.id;
    if (userId == null) return;

    try {
      // 1. Update Profile Total XP
      try {
        await client.rpc('update_profile_xp', params: {'increment_xp': xpEarned});
      } catch (e) {
         debugPrint('Cloud Update XP RPC failed: $e. Enqueuing.');
         await offlineQueueRepository.enqueue(
           tableName: 'rpc:update_profile_xp',
           operation: 'RPC',
           data: {'increment_xp': xpEarned},
         );
      }

      final stats = await statsRepository.recordQuizResult(
        correctCount: correctCount,
        totalCount: totalCount,
      );

      await achievementsRepository.checkAfterQuiz(
        stats: stats,
        correctCount: correctCount,
        totalCount: totalCount,
      );

      if (_isCustomCourse(courseId)) {
        await _updateCustomCourseProgress(courseId, xpEarned);
        return;
      }

      // 2. Update User Course Progress
      Map<String, dynamic>? courseProgress;
      try {
        courseProgress = await client
            .from('user_courses')
            .select()
            .eq('user_id', userId)
            .eq('course_id', courseId)
            .maybeSingle();
      } catch (_) {
         // Offline fetch failed, try local
         final localCourses = await DatabaseHelper.instance.getUserCourses(userId);
         // Find matching course manually
         try {
           courseProgress = localCourses.firstWhere((final c) => c['course_id'] == courseId);
         } catch (_) {}
      }

      final int oldCourseXp = courseProgress != null ? (courseProgress['progress_xp'] as int) : 0;

      final updatedCourse = {
        'user_id': userId,
        'course_id': courseId,
        'progress_xp': oldCourseXp + xpEarned,
        'last_accessed': DateTime.now().toIso8601String(),
      };

      try {
        await client.from('user_courses').upsert(updatedCourse, onConflict: 'user_id, course_id');
      } catch (e) {
        debugPrint('Cloud User Course Upsert failed: $e. Enqueuing.');
        await offlineQueueRepository.enqueue(
          tableName: 'user_courses',
          operation: 'UPSERT',
          data: updatedCourse,
        );
      }
      
      // Always update local for immediate feedback
      await DatabaseHelper.instance.upsertUserCourse(updatedCourse);

    } catch (e) {
      debugPrint('Error saving quiz result: $e');
    }
  }

  bool _isCustomCourse(final String courseId) {
    final parts = courseId.split('_');
    return parts.length >= 4;
  }

  Future<void> _updateCustomCourseProgress(final String courseId, final int xpEarned) async {
    try {
      final settings = await settingsRepository.getSettings();
      final raw = settings['custom_course_progress'];
      final progress = <String, int>{};
      if (raw is Map) {
        raw.forEach((final key, final value) {
          final xp = value is int ? value : int.tryParse(value?.toString() ?? '');
          if (xp != null) progress[key.toString()] = xp;
        });
      }

      final current = progress[courseId] ?? 0;
      progress[courseId] = current + xpEarned;
      await settingsRepository.updateSetting('custom_course_progress', progress);
    } catch (e) {
      debugPrint('Error updating custom course progress: $e');
    }
  }
}

QuizRepository get quizRepository => locator<QuizRepository>();

class _LangPair {
  final String source;
  final String target;
  _LangPair({required this.source, required this.target});
}

class _BlankResult {
  final String prompt;
  final String answer;
  _BlankResult({required this.prompt, required this.answer});
}
