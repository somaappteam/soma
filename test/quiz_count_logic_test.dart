import 'package:test/test.dart';

void main() {
  test('Filtering logic ensures limit is met', () {
    final List<Map<String, dynamic>> targetList = [
      {'concept_id': 1, 'word': 'word1'},
      {'concept_id': 2, 'word': 'word2'},
      {'concept_id': 3, 'word': 'null'}, // Should be filtered
      {'concept_id': 4, 'word': 'word4'},
      {'concept_id': 5, 'word': ''},      // Should be filtered
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
      11: {'concept_id': 11, 'word': ''}, // Should be filtered
      12: {'concept_id': 12, 'word': 's12'},
    };

    // Simulated QuizRepository._formatVocabWord logic
    String format(Map<String, dynamic> row) {
      final w = row['word']?.toString() ?? '';
      return (w.toLowerCase() == 'null' || w.isEmpty) ? '' : w;
    }

    // NEW LOGIC: Filter candidates strictly
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

    final limit = 10;
    final selected = candidates.take(limit).toList();

    // Verify candidates count
    // Original targetList had 12 items.
    // Index 2 (concept 3) has target 'null' -> filtered
    // Index 4 (concept 5) has target '' -> filtered
    // Index 10 (concept 11) has source '' -> filtered
    // Remaining valid: 1, 2, 4, 6, 7, 8, 9, 10, 12 (Total 9 valid)
    
    expect(candidates.length, 9);
    expect(selected.length, 9);

    // Previously, if we took limit=10 from targetList *before* these filters,
    // we would have taken the first 10 items (concepts 1 to 10).
    // From those 10, concepts 3 and 5 would be filtered out later.
    // Result: 8 items.
    
    final oldSelected = targetList.take(limit).toList();
    final oldFiltered = oldSelected.where((row) {
      final conceptId = row['concept_id'] as int;
      final sourceRow = sourceByConcept[conceptId];
      if (sourceRow == null) return false;
      return format(row).isNotEmpty && format(sourceRow).isNotEmpty;
    }).toList();
    
    expect(oldFiltered.length, 8); // This confirms the 8-9 count bug!
    
    print('Logic Verification:');
    print('Old logic result: ${oldFiltered.length} items');
    print('New logic result: ${selected.length} items');
  });
}
