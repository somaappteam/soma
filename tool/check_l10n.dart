import 'dart:convert';
import 'dart:io';

void main() {
  final l10nDir = Directory('lib/l10n');
  final enFile = File('lib/l10n/app_en.arb');
  if (!enFile.existsSync()) {
    stderr.writeln('Missing baseline localization file: ${enFile.path}');
    exitCode = 1;
    return;
  }

  final base = _arbKeys(enFile);
  final arbFiles = l10nDir
      .listSync()
      .whereType<File>()
      .where((final f) => f.path.endsWith('.arb') && !f.path.endsWith('app_en.arb'))
      .toList()
    ..sort((final a, final b) => a.path.compareTo(b.path));

  final issues = <String>[];
  for (final file in arbFiles) {
    final keys = _arbKeys(file);
    final missing = base.difference(keys);
    if (missing.isNotEmpty) {
      issues.add('${file.path} missing ${missing.length} key(s): ${missing.take(8).join(', ')}');
    }
  }

  if (issues.isNotEmpty) {
    stderr.writeln('Localization parity check failed:');
    for (final issue in issues) {
      stderr.writeln('- $issue');
    }
    exitCode = 1;
    return;
  }

  stdout.writeln('Localization parity check passed for ${arbFiles.length + 1} locales.');
}

Set<String> _arbKeys(final File file) {
  final jsonMap = jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;
  return jsonMap.keys.where((final k) => !k.startsWith('@')).toSet();
}
