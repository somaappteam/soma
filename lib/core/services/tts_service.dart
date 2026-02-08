import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';

class TtsService {
  final FlutterTts _tts = FlutterTts();
  bool _initialized = false;
  double _rate = 1.0;
  bool _isSpeaking = false;

  double get rate => _rate;

  Future<void> _ensureInit() async {
    if (_initialized) return;
    try {
      _initialized = true;
      
      // On Windows, awaitSpeakCompletion can sometimes cause issues or isn't fully supported
      if (!kIsWeb && !Platform.isWindows) {
        await _tts.awaitSpeakCompletion(true);
      }
      
      await _tts.setSpeechRate(_rate);
      
      _tts.setStartHandler(() {
        _isSpeaking = true;
      });

      _tts.setCompletionHandler(() {
        _isSpeaking = false;
      });

      _tts.setErrorHandler((msg) {
        _isSpeaking = false;
        debugPrint('TTS Error handler: $msg');
      });

    } catch (e) {
      _initialized = false;
      debugPrint('Error initializing TTS: $e');
    }
  }

  Future<void> setRate(double rate) async {
    _rate = rate;
    try {
      await _ensureInit();
      await _tts.setSpeechRate(rate);
    } catch (e) {
      debugPrint('Error setting TTS rate: $e');
    }
  }

  Future<void> speak(String text) async {
    if (text.trim().isEmpty) return;
    try {
      await _ensureInit();
      // On Windows, stopping and immediately speaking can cause crashes if not handled carefully
      if (_isSpeaking) {
        await _tts.stop();
      }
      await _tts.speak(text);
    } catch (e) {
      debugPrint('Error speaking TTS: $e');
    }
  }

  Future<void> stop() async {
    try {
      if (_initialized) {
        await _tts.stop();
        _isSpeaking = false;
      }
    } catch (e) {
      debugPrint('Error stopping TTS: $e');
    }
  }
}

final ttsService = TtsService();
