import 'dart:io';

void main() async {
  final dataDir = Directory('lib/data');
  if (!await dataDir.exists()) {
    print('lib/data not found');
    return;
  }

  final files = dataDir.listSync(recursive: true).whereType<File>().where((final f) => f.path.endsWith('.dart'));
  
  final regex = RegExp(r'final\s+([a-zA-Z]+Repository)\s*=\s*([a-zA-Z]+Repository)\([^)]*\);');

  int modifiedCount = 0;

  for (final file in files) {
    String content = await file.readAsString();
    if (regex.hasMatch(content)) {
      // Add import if missing
      if (!content.contains("import '../core/di/locator.dart';")) {
        // Find the last import
        final lastImportIndex = content.lastIndexOf(RegExp(r'^import .*;', multiLine: true));
        if (lastImportIndex != -1) {
          final endOfImport = content.indexOf('\n', lastImportIndex);
          content = "${content.substring(0, endOfImport + 1)}import '../core/di/locator.dart';\n${content.substring(endOfImport + 1)}";
        } else {
          content = "import '../core/di/locator.dart';\n\n$content";
        }
      }

      // Replace global variable with getter definition
      content = content.replaceAllMapped(regex, (final match) {
        final varName = match.group(1)!;
        final className = match.group(2)!;
        return '$className get $varName => locator<$className>();';
      });

      await file.writeAsString(content);
      print('Updated ${file.path}');
      modifiedCount++;
    }
  }

  print('Migration complete. Modified $modifiedCount files.');
}
