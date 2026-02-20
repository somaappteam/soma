import 'package:flutter/services.dart' show rootBundle;
import 'package:csv/csv.dart';
import 'package:flutter/foundation.dart';

class CsvService {
  static final CsvService instance = CsvService._init();
  CsvService._init();

  List<Map<String, dynamic>>? _vocabularyCache;
  List<Map<String, dynamic>>? _sentencesCache;

  Future<void> _loadVocabulary() async {
    if (_vocabularyCache != null) return;
    try {
      final data = await rootBundle.loadString('assets/vocabulary.csv');
      final rows = const CsvToListConverter().convert(data, eol: '\n');
      if (rows.isEmpty) {
        _vocabularyCache = [];
        return;
      }
      
      final headers = rows.first.map((e) => e.toString().trim()).toList();
      final result = <Map<String, dynamic>>[];
      
      for (var i = 1; i < rows.length; i++) {
        final row = rows[i];
        final map = <String, dynamic>{};
        for (var j = 0; j < headers.length && j < row.length; j++) {
          map[headers[j]] = row[j];
        }
        result.add(map);
      }
      _vocabularyCache = result;
      debugPrint('Loaded ${_vocabularyCache?.length} vocabulary items from CSV');
    } catch (e) {
      debugPrint('Error loading vocabulary.csv: $e');
      _vocabularyCache = [];
    }
  }

  Future<void> _loadSentences() async {
    if (_sentencesCache != null) return;
    try {
      final data = await rootBundle.loadString('assets/sentences.csv');
      final rows = const CsvToListConverter().convert(data, eol: '\n');
      if (rows.isEmpty) {
        _sentencesCache = [];
        return;
      }
      
      final headers = rows.first.map((e) => e.toString().trim()).toList();
      final result = <Map<String, dynamic>>[];
      
      for (var i = 1; i < rows.length; i++) {
        final row = rows[i];
        final map = <String, dynamic>{};
        for (var j = 0; j < headers.length && j < row.length; j++) {
          map[headers[j]] = row[j];
        }
        result.add(map);
      }
      _sentencesCache = result;
      debugPrint('Loaded ${_sentencesCache?.length} sentence items from CSV');
    } catch (e) {
      debugPrint('Error loading sentences.csv: $e');
      _sentencesCache = [];
    }
  }

  Future<List<Map<String, dynamic>>> getVocabularyByLang(String langCode) async {
    await _loadVocabulary();
    return _vocabularyCache?.where((row) => row['lang_code'] == langCode).toList() ?? [];
  }

  Future<List<Map<String, dynamic>>> getSentencesByLang(String langCode) async {
    await _loadSentences();
    return _sentencesCache?.where((row) => row['lang_code'] == langCode).toList() ?? [];
  }
}
