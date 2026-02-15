import 'dart:io';

void main(List<String> args) {
  if (args.length != 2) {
    stderr.writeln('Usage: dart run tool/check_coverage.dart <lcov_path> <minimum_percent>');
    exitCode = 64;
    return;
  }

  final file = File(args[0]);
  final minPercent = double.tryParse(args[1]);
  if (!file.existsSync() || minPercent == null) {
    stderr.writeln('Invalid input. fileExists=${file.existsSync()}, min=${args[1]}');
    exitCode = 64;
    return;
  }

  final lines = file.readAsLinesSync();
  var totalFound = 0;
  var totalHit = 0;

  for (final line in lines) {
    if (!line.startsWith('DA:')) continue;
    final payload = line.substring(3).split(',');
    if (payload.length != 2) continue;
    totalFound += 1;
    final hit = int.tryParse(payload[1]) ?? 0;
    if (hit > 0) {
      totalHit += 1;
    }
  }

  final coverage = totalFound == 0 ? 0.0 : (totalHit / totalFound) * 100;
  stdout.writeln('Coverage: ${coverage.toStringAsFixed(2)}% (min ${minPercent.toStringAsFixed(2)}%)');

  if (coverage < minPercent) {
    stderr.writeln('Coverage gate failed.');
    exitCode = 1;
  }
}
