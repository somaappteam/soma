import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final tts = FlutterTts();
  
  final langs = await tts.getLanguages;
  print('Available Languages: $langs');

  final testCodes = ['en-US', 'en', 'es', 'es-ES', 'hu', 'el', 'fr', 'de'];
  for (final code in testCodes) {
    final isAvailable = await tts.isLanguageAvailable(code);
    print("Is '$code' available? $isAvailable");
  }
}
