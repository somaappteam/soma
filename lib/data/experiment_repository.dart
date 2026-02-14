import 'dart:math';

import 'settings_repository.dart';

class ExperimentRepository {
  final Random _random = Random();

  Future<String> variant(String key, {List<String> buckets = const ['A', 'B']}) async {
    final settings = await settingsRepository.getSettings();
    final exp = (settings['experiments'] as Map<String, dynamic>?) ?? {};
    final existing = exp[key]?.toString();
    if (existing != null && buckets.contains(existing)) return existing;

    final selected = buckets[_random.nextInt(buckets.length)];
    exp[key] = selected;
    await settingsRepository.updateSetting('experiments', exp);
    return selected;
  }
}

final experimentRepository = ExperimentRepository();
