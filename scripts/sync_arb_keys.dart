import 'dart:convert';
import 'dart:io';
import 'package:soma/core/services/app_logger.dart';

void main() {
  final dir = Directory('lib/l10n');
  final files = dir.listSync().whereType<File>().where(
      (final f) => f.path.endsWith('.arb') && !f.path.endsWith('app_en.arb'));

  final newKeys = {
    'incomingCallFrom': 'Incoming call from {name}',
    '@incomingCallFrom': {
      'placeholders': {'name': {}}
    },
    'declineCall': 'Decline',
    'acceptCall': 'Accept',
    'voiceCall': 'Voice call',
    'inCallWith': 'In call • {name}',
    '@inCallWith': {
      'placeholders': {'name': {}}
    },
    'authBenefitLiveCircles': 'Live circles with real learners',
    'authBenefitVoiceRooms': 'Voice rooms with instant practice',
    'authBenefitFriendChallenges': 'Friend challenges and saved progress'
  };

  int count = 0;
  for (final file in files) {
    try {
      final content = file.readAsStringSync();
      final Map<String, dynamic> json = jsonDecode(content);

      bool updated = false;
      for (final entry in newKeys.entries) {
        if (!json.containsKey(entry.key)) {
          json[entry.key] = entry.value;
          updated = true;
        }
      }

      if (updated) {
        const encoder = JsonEncoder.withIndent('  ');
        file.writeAsStringSync('${encoder.convert(json)}\n');
        count++;
      }
    } catch (e) {
      appLogger.info('Failed to process ${file.path}: $e');
    }
  }

  appLogger.info('Added new keys to $count files.');
}
