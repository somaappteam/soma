import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:soma/core/services/app_logger.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final tts = FlutterTts();

  final langs = await tts.getLanguages;
  appLogger.info('Available Languages: $langs');

  final testCodes = ['en-US', 'en', 'es', 'es-ES', 'hu', 'el', 'fr', 'de'];
  for (final code in testCodes) {
    final isAvailable = await tts.isLanguageAvailable(code);
    appLogger.info("Is '$code' available? $isAvailable");
  }
}
