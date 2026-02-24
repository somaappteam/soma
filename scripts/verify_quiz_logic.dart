import 'package:soma/core/services/app_logger.dart';

void main() {
  appLogger.info('--- Quiz Logic Verification ---');

  final List<Map<String, dynamic>> targetList = [
    {'concept_id': 1, 'word': 'word1'},
    {'concept_id': 2, 'word': 'word2'},
    {'concept_id': 3, 'word': 'null'}, // Should be filtered
    {'concept_id': 4, 'word': 'word4'},
    {'concept_id': 5, 'word': ''}, // Should be filtered
    {'concept_id': 6, 'word': 'word6'},
    {'concept_id': 7, 'word': 'word7'},
    {'concept_id': 8, 'word': 'word8'},
    {'concept_id': 9, 'word': 'word9'},
    {'concept_id': 10, 'word': 'word10'},
    {'concept_id': 11, 'word': 'word11'},
    {'concept_id': 12, 'word': 'word12'},
  ];

  final Map<int, Map<String, dynamic>> sourceByConcept = {
    1: {'concept_id': 1, 'word': 's1'},
    2: {'concept_id': 2, 'word': 's2'},
    3: {'concept_id': 3, 'word': 's3'},
    4: {'concept_id': 4, 'word': 's4'},
    5: {'concept_id': 5, 'word': 's5'},
    6: {'concept_id': 6, 'word': 's6'},
    7: {'concept_id': 7, 'word': 's7'},
    8: {'concept_id': 8, 'word': 's8'},
    9: {'concept_id': 9, 'word': 's9'},
    10: {'concept_id': 10, 'word': 's10'},
    11: {'concept_id': 11, 'word': ''}, // Should be filtered (empty source)
    12: {'concept_id': 12, 'word': 's12'},
  };

  // Simulated QuizRepository._formatVocabWord logic
  String format(final Map<String, dynamic> row) {
    final w = row['word']?.toString() ?? '';
    return (w.toLowerCase() == 'null' || w.isEmpty) ? '' : w;
  }

  appLogger.info('Simulating 12 candidates with 3 invalid entries...');

  // --- OLD LOGIC SIMULATION ---
  final limit = 10;
  final oldSelected = targetList.take(limit).toList();
  final oldFiltered = oldSelected.where((final row) {
    final conceptId = row['concept_id'] as int;
    final sourceRow = sourceByConcept[conceptId];
    if (sourceRow == null) return false;
    return format(row).isNotEmpty && format(sourceRow).isNotEmpty;
  }).toList();

  appLogger.info('OLD LOGIC (filter after take): ${oldFiltered.length} items');

  // --- NEW LOGIC SIMULATION ---
  final candidates = <Map<String, dynamic>>[];
  for (final row in targetList) {
    final conceptId = row['concept_id'] as int;
    final sourceRow = sourceByConcept[conceptId];
    if (sourceRow == null) continue;

    final targetWord = format(row);
    final sourceWord = format(sourceRow);
    if (targetWord.isEmpty || sourceWord.isEmpty) continue;

    candidates.add(row);
  }

  final newSelected = candidates.take(limit).toList();
  appLogger.info('NEW LOGIC (filter before take): ${newSelected.length} items');

  if (newSelected.length > oldFiltered.length) {
    appLogger
        .info('SUCCESS: New logic produced more valid items than old logic.');
  } else {
    appLogger.info('FAILURE: New logic did not improve count.');
  }
}
