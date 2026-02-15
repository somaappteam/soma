import 'package:flutter_test/flutter_test.dart';
import 'package:soma/models/app_settings.dart';

void main() {
  test('AppSettings normalizes language and plan values', () {
    final settings = AppSettings.fromMap({
      'language_ui': 'English',
      'plus_plan': 'PRO',
      'show_translation': false,
    });

    expect(settings.languageUi, 'en');
    expect(settings.plusPlan, 'pro');
    expect(settings.showTranslation, isFalse);
    expect(settings.defaultTimerS, 15);
  });
}
