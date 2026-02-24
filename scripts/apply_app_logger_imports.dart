import 'dart:io';

void main() async {
  final libDir = Directory('lib');
  final scriptsDir = Directory('scripts');
  final importLine = "import 'package:soma/core/services/app_logger.dart';";

  final files = <File>[];
  if (await libDir.exists()) {
    files.addAll(await libDir
        .list(recursive: true)
        .where(
            (final entity) => entity is File && entity.path.endsWith('.dart'))
        .cast<File>()
        .toList());
  }
  if (await scriptsDir.exists()) {
    files.addAll(await scriptsDir
        .list(recursive: true)
        .where(
            (final entity) => entity is File && entity.path.endsWith('.dart'))
        .cast<File>()
        .toList());
  }

  print('Scanning ${files.length} files...');
  int fixedCount = 0;

  for (final file in files) {
    if (file.path.endsWith('app_logger.dart')) continue;
    if (file.path.endsWith('.g.dart')) continue;
    if (file.path.endsWith('.freezed.dart')) continue;

    final content = await file.readAsString();

    // Check if appLogger is used as a standalone word (to avoid matching something like MyAppLogger)
    final appLoggerRegex = RegExp(r'\bappLogger\b');
    if (appLoggerRegex.hasMatch(content)) {
      // Check if it's already imported
      if (!content.contains('app_logger.dart')) {
        final lines = content.split('\n');
        int lastImportIndex = -1;
        for (int i = 0; i < lines.length; i++) {
          if (lines[i].trim().startsWith('import ')) {
            lastImportIndex = i;
          }
        }

        if (lastImportIndex == -1) {
          // No imports found, insert at top but after comments/metadata
          int insertIndex = 0;
          while (insertIndex < lines.length &&
              (lines[insertIndex].trim().isEmpty ||
                  lines[insertIndex].trim().startsWith('//') ||
                  lines[insertIndex].trim().startsWith('/*') ||
                  lines[insertIndex].trim().startsWith('@'))) {
            insertIndex++;
          }
          lines.insert(insertIndex, importLine);
        } else {
          // Insert after the last import
          lines.insert(lastImportIndex + 1, importLine);
        }

        await file.writeAsString(lines.join('\n'));
        fixedCount++;
        print('Fixed: ${file.path}');
      }
    }
  }

  print('Done. Fixed $fixedCount files.');
}
