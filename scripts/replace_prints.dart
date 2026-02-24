import 'dart:io';

Future<void> main() async {
  final rootDir = Directory('.');
  final files =
      rootDir.listSync(recursive: true).whereType<File>().where((final f) {
    if (!f.path.endsWith('.dart')) return false;
    // skip generated files, hidden dirs, builds, and test/ios/android wrappers
    if (f.path.contains('.dart_tool') ||
        f.path.contains('build') ||
        f.path.contains('.pub') ||
        f.path.contains('.git') ||
        f.path.endsWith('.g.dart') ||
        f.path.endsWith('.freezed.dart') ||
        f.path.contains('app_logger.dart')) {
      return false;
    }
    return true;
  });

  int modifiedCount = 0;
  final printRegex =
      RegExp(r'(?<!\.)\bprint\((.*?)\);', multiLine: true, dotAll: true);
  final debugPrintRegex =
      RegExp(r'\bdebugPrint\((.*?)\);', multiLine: true, dotAll: true);
  final appLoggerImport =
      "import 'package:soma/core/services/app_logger.dart';\n";

  for (final file in files) {
    String content = await file.readAsString();
    bool modified = false;

    if (printRegex.hasMatch(content)) {
      content = content.replaceAllMapped(printRegex, (final match) {
        return 'appLogger.info(${match.group(1)});';
      });
      modified = true;
    }

    if (debugPrintRegex.hasMatch(content)) {
      content = content.replaceAllMapped(debugPrintRegex, (final match) {
        return 'appLogger.debug(${match.group(1)});';
      });
      modified = true;
    }

    if (modified) {
      if (!content.contains('app_logger.dart') &&
          !content.contains('appLogger')) {
        final importIndex = content.indexOf('import ');
        if (importIndex != -1) {
          content = content.substring(0, importIndex) +
              appLoggerImport +
              content.substring(importIndex);
        } else {
          content = appLoggerImport + content;
        }
      }

      await file.writeAsString(content);
      modifiedCount++;
      print('Updated: ${file.path}');
    }
  }

  print('Total files updated: $modifiedCount');
}
