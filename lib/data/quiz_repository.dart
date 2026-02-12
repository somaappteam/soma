import 'dart:math';

import 'package:supabase_flutter/supabase_flutter.dart';
import 'quiz_local_store.dart';
import 'settings_repository.dart';
import 'stats_repository.dart';
import 'achievements_repository.dart';
import '../core/database/database_helper.dart';
import 'package:flutter/foundation.dart';

class QuizRepository {
  final SupabaseClient _client = Supabase.instance.client;
  final Random _random = Random();
  final QuizCache _cache = QuizCache();
  final VocabSrsStore _srsStore = VocabSrsStore();

  Future<List<Map<String, dynamic>>> getVocabQuestions(String courseId, int limit) async {
    final langs = _parseCourseLangs(courseId);
    if (langs == null) return [];
    final cacheKey = 'vocab_${courseId}_$limit';
    final dueConcepts = await _srsStore.dueConceptIds(courseId);

    if (dueConcepts.isEmpty) {
      final cached = await _cache.load(cacheKey);
      if (cached.isNotEmpty) return cached;
    }

    try {
      // Prioritize Supabase for real-time/group quizzes if available
      if (_client.auth.currentUser != null) {
        final supabaseQs = await getVocabQuestionsFromSupabase(courseId, limit);
        if (supabaseQs.isNotEmpty) {
          await _cache.save(cacheKey, supabaseQs);
          return supabaseQs;
        }
      }

      final dbHelper = DatabaseHelper.instance;
      final sourceRows = await dbHelper.getVocabularyByLang(langs.source);
      final targetRows = await dbHelper.getVocabularyByLang(langs.target);

      final sourceList = _rowsToMapList(sourceRows);
      final targetList = _rowsToMapList(targetRows);
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
        if (concept == null || row['word'] == null) continue;
        if (sourceByConcept.containsKey(concept)) {
          candidates.add(row);
        }
      }

      final dueSet = dueConcepts.toSet();
      final dueCandidates = candidates
          .where((row) => dueSet.contains(_parseInt(row['concept_id'])))
          .toList();
      dueCandidates.shuffle();

      final selected = <Map<String, dynamic>>[];
      selected.addAll(dueCandidates.take(limit));

      if (selected.length < limit) {
        final remaining = candidates
            .where((row) => !selected.contains(row))
            .toList();
        remaining.shuffle();
        selected.addAll(remaining.take(limit - selected.length));
      }

      selected.shuffle();

      final sourceWords = sourceList
          .map(_formatVocabWord)
          .where((word) => word.isNotEmpty)
          .toSet()
          .toList();

      final questions = selected.map((row) {
        final concept = _parseInt(row['concept_id']);
        final sourceRow = concept != null ? sourceByConcept[concept] : null;
        if (sourceRow == null) return null;

        final targetWord = _formatVocabWord(row);
        final correct = _formatVocabWord(sourceRow);
        if (targetWord.isEmpty || correct.isEmpty) return null;

        final choices = _buildChoices(sourceWords, correct);
        return {
          "concept_id": concept,
          "prompt": targetWord,
          "word": row['word'],
          "article": row['article'],
          "gender": row['gender'],
          "reading": _formatReading(row),
          "choices": choices,
          "correct": choices.indexOf(correct),
          "choice_pool": sourceWords,
          "correct_answer": correct,
        };
      }).whereType<Map<String, dynamic>>().toList();

      if (questions.isNotEmpty) {
        await _cache.save(cacheKey, questions);
      }

      return questions;
    } catch (e) {
      final cached = await _cache.load(cacheKey, allowStale: true);
      return cached;
    }
  }

  // Fallback or future implementation for Sentences
  Future<List<Map<String, dynamic>>> getSentenceQuestions(String courseId, int limit) async {
    final langs = _parseCourseLangs(courseId);
    if (langs == null) return [];
    final cacheKey = 'sentences_${courseId}_$limit';
    final cached = await _cache.load(cacheKey);
    if (cached.isNotEmpty) return cached;

    try {
      // Prioritize Supabase
      if (_client.auth.currentUser != null) {
        final supabaseQs = await getSentenceQuestionsFromSupabase(courseId, limit);
        if (supabaseQs.isNotEmpty) {
          await _cache.save(cacheKey, supabaseQs);
          return supabaseQs;
        }
      }

      final dbHelper = DatabaseHelper.instance;
      final sourceRows = await dbHelper.getSentencesByLang(langs.source);
      final targetRows = await dbHelper.getSentencesByLang(langs.target);

      final sourceList = _rowsToMapList(sourceRows);
      final targetList = _rowsToMapList(targetRows);
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
        if (concept == null || row['sentence'] == null) continue;
        if (sourceByConcept.containsKey(concept)) {
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
      final targetPool = targetWords.where((word) => word.trim().isNotEmpty).toList();

      final questions = selected.map((row) {
        final concept = _parseInt(row['concept_id']);
        final targetRow = concept != null ? targetByConcept[concept] : null;
        final sourceRow = concept != null ? sourceByConcept[concept] : null;
        if (targetRow == null || sourceRow == null) return null;

        final targetSentence = targetRow['sentence']?.toString() ?? '';
        final sourceSentence = sourceRow['sentence']?.toString() ?? '';
        if (targetSentence.trim().isEmpty || sourceSentence.trim().isEmpty) return null;

        final blanked = _blankSentence(targetSentence);
        if (blanked == null) return null;

        final choices = _buildChoices(targetPool, blanked.answer);
        return {
          "concept_id": concept,
          "prompt": blanked.prompt,
          "full_sentence": targetSentence,
          "translation": sourceSentence,
          "reading": _formatReading(targetRow),
          "choices": choices,
          "correct": choices.indexOf(blanked.answer),
          "choice_pool": targetPool,
          "correct_answer": blanked.answer,
        };
      }).whereType<Map<String, dynamic>>().toList();

      if (questions.isNotEmpty) {
        await _cache.save(cacheKey, questions);
      }

      return questions;
    } catch (e) {
      final cached = await _cache.load(cacheKey, allowStale: true);
      return cached;
    }
  }

  Future<void> recordVocabAnswer({
    required String courseId,
    required Map<String, dynamic> question,
    required bool correct,
  }) async {
    final conceptId = _parseInt(question['concept_id']);
    if (conceptId == null) return;
    await _srsStore.recordResult(
      courseId: courseId,
      conceptId: conceptId,
      correct: correct,
    );
  }

  _LangPair? _parseCourseLangs(String courseId) {
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

  List<Map<String, dynamic>> _rowsToMapList(dynamic rows) {
    if (rows is! List) return [];
    return rows
        .whereType<Map>()
        .map((row) => Map<String, dynamic>.from(row))
        .toList();
  }

  int? _parseInt(dynamic value) {
    if (value is int) return value;
    return int.tryParse(value?.toString() ?? '');
  }

  String _formatVocabWord(Map<String, dynamic> row) {
    final word = row['word']?.toString().trim() ?? '';
    if (word.isEmpty) return '';
    final article = row['article']?.toString().trim() ?? '';
    return article.isEmpty ? word : '$article $word';
  }

  String _formatReading(Map<String, dynamic> row) {
    final romanization = row['romanization']?.toString().trim() ?? '';
    if (romanization.isNotEmpty) return romanization;
    final pinyin = row['pinyin']?.toString().trim() ?? '';
    if (pinyin.isNotEmpty) return pinyin;
    final transliteration = row['transliteration']?.toString().trim() ?? '';
    return transliteration;
  }

  List<String> _buildChoices(List<String> pool, String correct) {
    final unique = pool.where((value) => value.trim().isNotEmpty && value != correct).toSet().toList();
    unique.shuffle();
    final choices = <String>[correct, ...unique.take(3)];
    choices.shuffle();
    return choices;
  }

  List<String> _extractSentenceWords(String sentence) {
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

    final chars = sentence.runes.map((rune) => String.fromCharCode(rune)).toList();
    return chars.where((char) => char.trim().isNotEmpty).toList();
  }

  _BlankResult? _blankSentence(String sentence) {
    if (sentence.trim().isEmpty) return null;
    if (sentence.contains(RegExp(r'\s'))) {
      final parts = sentence.split(RegExp(r'\s+'));
      final candidates = <int>[];
      for (var i = 0; i < parts.length; i++) {
        final cleaned = parts[i]
            .replaceAll(RegExp(r"^[^\p{L}\p{M}'-]+|[^\p{L}\p{M}'-]+$", unicode: true), '')
            .trim();
        if (cleaned.isNotEmpty) {
          candidates.add(i);
        }
      }
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

    final chars = sentence.runes.map((rune) => String.fromCharCode(rune)).toList();
    if (chars.isEmpty) return null;
    final pickIndex = _random.nextInt(chars.length);
    final answer = chars[pickIndex];
    chars[pickIndex] = '____';
    return _BlankResult(prompt: chars.join(''), answer: answer);
  }

  // Supabase Fetching Methods

  Future<List<Map<String, dynamic>>> getVocabQuestionsFromSupabase(String courseId, int limit) async {
    final langs = _parseCourseLangs(courseId);
    if (langs == null) return [];

    try {
      // 1. Fetch source language items
      final sourceResponse = await _client
          .from('vocabulary')
          .select()
          .eq('lang', langs.source)
          .limit(1000); // Fetch a decent pool

      // 2. Fetch target language items 
      final targetResponse = await _client
          .from('vocabulary')
          .select()
          .eq('lang', langs.target)
          .limit(1000);

      final sourceList = List<Map<String, dynamic>>.from(sourceResponse);
      final targetList = List<Map<String, dynamic>>.from(targetResponse);

      debugPrint("Supabase Vocab Fetch: Source(${langs.source})=${sourceList.length}, Target(${langs.target})=${targetList.length}");

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
      targetByConcept.forEach((concept, row) {
        if (sourceByConcept.containsKey(concept)) {
          candidates.add(row);
        }
      });

      candidates.shuffle();
      final selected = candidates.take(limit).toList();

      final sourceWords = sourceList
          .map(_formatVocabWord)
          .where((word) => word.isNotEmpty)
          .toSet()
          .toList();

      return selected.map((row) {
        final concept = _parseInt(row['concept_id'])!;
        final sourceRow = sourceByConcept[concept]!;
        
        final targetWord = _formatVocabWord(row);
        final correct = _formatVocabWord(sourceRow);
        
        if (targetWord.isEmpty || correct.isEmpty) return null;

        final choices = _buildChoices(sourceWords, correct);
        
        return {
          "concept_id": concept,
          "prompt": targetWord,
          "word": row['word'],
          "article": row['article'],
          "gender": row['gender'],
          "reading": _formatReading(row),
          "choices": choices,
          "correct": choices.indexOf(correct),
          "choice_pool": sourceWords,
          "correct_answer": correct,
          "translation": correct,
        };
      }).whereType<Map<String, dynamic>>().toList();

    } catch (e) {
      debugPrint("Error fetching vocab from Supabase: $e");
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getSentenceQuestionsFromSupabase(String courseId, int limit) async {
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

      debugPrint("Supabase Sentence Fetch: Source(${langs.source})=${sourceList.length}, Target(${langs.target})=${targetList.length}");

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
      targetByConcept.forEach((concept, row) {
        if (sourceByConcept.containsKey(concept)) {
          candidates.add(row);
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
      final targetPool = targetWords.where((word) => word.trim().isNotEmpty).toList();

      return selected.map((row) {
        final concept = _parseInt(row['concept_id'])!;
        final sourceRow = sourceByConcept[concept]!;

        final targetSentence = row['sentence']?.toString() ?? '';
        final sourceSentence = sourceRow['sentence']?.toString() ?? '';

        if (targetSentence.isEmpty || sourceSentence.isEmpty) return null;

        final blanked = _blankSentence(targetSentence);
        if (blanked == null) return null;

        final choices = _buildChoices(targetPool, blanked.answer);

        return {
          "concept_id": concept,
          "prompt": blanked.prompt,
          "full_sentence": targetSentence,
          "translation": sourceSentence,
          "reading": _formatReading(row),
          "choices": choices,
          "correct": choices.indexOf(blanked.answer),
          "choice_pool": targetPool,
          "correct_answer": blanked.answer,
        };
      }).whereType<Map<String, dynamic>>().toList();

    } catch (e) {
      debugPrint("Error fetching sentences from Supabase: $e");
      return [];
    }
  }
  // Save quiz result to Supabase and Local SQLite
  Future<void> saveQuizResult({
    required String courseId,
    required int xpEarned,
    required int correctCount,
    required int totalCount,
  }) async {
    final client = Supabase.instance.client;
    final userId = client.auth.currentUser?.id;
    if (userId == null) return;

    try {
      // 1. Update Profile Total XP
      await client.rpc('update_profile_xp', params: {'increment_xp': xpEarned});

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
      final courseProgress = await client
          .from('user_courses')
          .select()
          .eq('user_id', userId)
          .eq('course_id', courseId)
          .maybeSingle();

      final int oldCourseXp = courseProgress != null ? (courseProgress['progress_xp'] as int) : 0;

      final updatedCourse = {
        'user_id': userId,
        'course_id': courseId,
        'progress_xp': oldCourseXp + xpEarned,
        'last_accessed': DateTime.now().toIso8601String(),
      };

      await client.from('user_courses').upsert(updatedCourse, onConflict: 'user_id, course_id');
      
    } catch (e) {
      debugPrint("Error saving quiz result: $e");
    }
  }

  bool _isCustomCourse(String courseId) {
    final parts = courseId.split('_');
    return parts.length >= 4;
  }

  Future<void> _updateCustomCourseProgress(String courseId, int xpEarned) async {
    try {
      final settings = await settingsRepository.getSettings();
      final raw = settings['custom_course_progress'];
      final progress = <String, int>{};
      if (raw is Map) {
        raw.forEach((key, value) {
          final xp = value is int ? value : int.tryParse(value?.toString() ?? '');
          if (xp != null) progress[key.toString()] = xp;
        });
      }

      final current = progress[courseId] ?? 0;
      progress[courseId] = current + xpEarned;
      await settingsRepository.updateSetting('custom_course_progress', progress);
    } catch (e) {
      debugPrint("Error saving custom course progress: $e");
    }
  }
}

final quizRepository = QuizRepository();

class _LangPair {
  final String source;
  final String target;

  const _LangPair({required this.source, required this.target});
}

class _BlankResult {
  final String prompt;
  final String answer;

  const _BlankResult({required this.prompt, required this.answer});
}
