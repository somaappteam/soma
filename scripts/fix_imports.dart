import 'dart:io';

Future<void> main() async {
  final file = File('analyze_script_output.txt');
  if (!file.existsSync()) {
    print('analyze_script_output.txt not found');
    return;
  }

  final contentStr = await file.readAsString();
  final filesToFix = <String>{};

  // Find occurrences of the file path immediately preceding undefined_identifier
  // by looking for 'lib\...dart'
  final regex = RegExp(r'(?:lib|scripts)[\/\\][a-zA-Z0-9_\/\\]+\.dart');
  final matches = regex.allMatches(contentStr);

  for (final match in matches) {
    final path = match.group(0);
    if (path != null) {
      filesToFix.add(path);
    }
  }

  print('Found \${filesToFix.length} files missing appLogger import.');

  final appLoggerImport =
      "import 'package:soma/core/services/app_logger.dart';\n";

  int fixedCount = 0;
  for (final filePath in filesToFix) {
    final targetFile = File(filePath);
    if (!targetFile.existsSync()) {
      continue;
    }

    String content = await targetFile.readAsString();
    if (content.contains('appLogger') && !content.contains('app_logger.dart')) {
      final importIndex = content.indexOf('import ');
      if (importIndex != -1) {
        content = content.substring(0, importIndex) +
            appLoggerImport +
            content.substring(importIndex);
      } else {
        content = appLoggerImport + content;
      }
      await targetFile.writeAsString(content);
      fixedCount++;
    }
  }

  print('Fixed \$fixedCount files.');
}
