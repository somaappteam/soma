
import 'dart:io';

void main() {
  final directory = Directory('lib');
  final files = directory.listSync(recursive: true).whereType<File>().where((final f) => f.path.endsWith('.dart'));
  
  int count = 0;
  for (final file in files) {
    String content = file.readAsStringSync();
    bool updated = false;
    
    // Replace old imports
    if (content.contains('package:soma/l10n/app_localizations.dart')) {
      content = content.replaceAll(
        'package:soma/l10n/app_localizations.dart',
        'package:soma/l10n/gen/app_localizations.dart'
      );
      updated = true;
    }
    
    // Replace synthetic imports
    if (content.contains('package:flutter_gen/gen_l10n/app_localizations.dart')) {
      content = content.replaceAll(
        'package:flutter_gen/gen_l10n/app_localizations.dart',
        'package:soma/l10n/gen/app_localizations.dart'
      );
      updated = true;
    }

    if (updated) {
      print('Fixing ${file.path}');
      file.writeAsStringSync(content);
      count++;
    }
  }
  print('Fixed $count files.');
}
