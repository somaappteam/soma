import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';

class TtsService {
  final FlutterTts _tts = FlutterTts();
  bool _initialized = false;
  double _rate = 1.0;
  bool _isSpeaking = false;
  double get rate => _rate;

  double _engineRate(double uiRate) {
    // Keep 1.0x as natural speed while preserving slower/faster presets.
    return (uiRate * 0.75).clamp(0.2, 1.0);
  }

  // Maps our internal 2-letter codes to preferred BCP-47 locales for TTS.
  // TTS engines expect these regional variants; bare 2-letter codes often fail.
  static const Map<String, String> _langToBcp47 = {
    'af': 'af-ZA',
    'ar': 'ar-SA',
    'bg': 'bg-BG',
    'bn': 'bn-BD',
    'cs': 'cs-CZ',
    'cy': 'cy-GB',
    'da': 'da-DK',
    'de': 'de-DE',
    'el': 'el-GR',
    'en': 'en-US',
    'es': 'es-ES',
    'et': 'et-EE',
    'fa': 'fa-IR',
    'fi': 'fi-FI',
    'fil': 'fil-PH',
    'fr': 'fr-FR',
    'ga': 'ga-IE',
    'gu': 'gu-IN',
    'he': 'he-IL',
    'hi': 'hi-IN',
    'hr': 'hr-HR',
    'hu': 'hu-HU',
    'id': 'id-ID',
    'is': 'is-IS',
    'it': 'it-IT',
    'ja': 'ja-JP',
    'kn': 'kn-IN',
    'ko': 'ko-KR',
    'lt': 'lt-LT',
    'lv': 'lv-LV',
    'ml': 'ml-IN',
    'mr': 'mr-IN',
    'ms': 'ms-MY',
    'mt': 'mt-MT',
    'nb': 'nb-NO',
    'nl': 'nl-NL',
    'pa': 'pa-IN',
    'pl': 'pl-PL',
    'pt': 'pt-PT',
    'ro': 'ro-RO',
    'ru': 'ru-RU',
    'sk': 'sk-SK',
    'sl': 'sl-SI',
    'sq': 'sq-AL',
    'sr': 'sr-RS',
    'sv': 'sv-SE',
    'sw': 'sw-KE',
    'ta': 'ta-IN',
    'te': 'te-IN',
    'th': 'th-TH',
    'tr': 'tr-TR',
    'uk': 'uk-UA',
    'ur': 'ur-PK',
    'vi': 'vi-VN',
    'zh': 'zh-CN',
    'zu': 'zu-ZA',
  };

  /// Converts a 2-letter language code or an existing BCP-47 tag into the
  /// preferred BCP-47 form expected by the platform TTS engine.
  /// Returns the original value unchanged if the code is not in the map
  /// (e.g., it was already a full locale like 'en-US').
  static String toBcp47(String code) {
    final trimmed = code.trim().toLowerCase();
    return _langToBcp47[trimmed] ?? code;
  }

  Future<void> _ensureInit() async {
    if (_initialized) return;
    try {
      _initialized = true;

      // awaitSpeakCompletion is not fully supported on Windows / Web.
      if (!kIsWeb && !Platform.isWindows) {
        await _tts.awaitSpeakCompletion(true);
      }

      // Map UI rate to engine rate (e.g., UI 1.0 -> Engine 0.75) for natural playback.
      await _tts.setSpeechRate(_engineRate(_rate));

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

  /// Sets the playback speech rate.
  Future<void> setRate(double rate) async {
    _rate = rate;
    try {
      await _ensureInit();
      // Map UI rate to engine rate (e.g., UI 1.0 -> Engine 0.75) for natural playback.
      await _tts.setSpeechRate(_engineRate(rate));
    } catch (e) {
      debugPrint('Error setting TTS rate: $e');
    }
  }

  /// Sets the TTS language, checking availability first.
  /// If the language is not available, it quietly resets to the default.
  /// Returns [true] if the language was set successfully, [false] otherwise.
  Future<bool> setLanguage(String langCode) async {
    try {
      await _ensureInit();
      final bcp47 = toBcp47(langCode);
      final isAvailable = await _tts.isLanguageAvailable(bcp47);
      if (isAvailable == true || isAvailable == 1) {
        await _tts.setLanguage(bcp47);
        return true;
      } else {
        // Try bare 2-letter code as fallback (e.g., 'en' when 'en-US' not found).
        final bare = langCode.trim().toLowerCase().split('-').first;
        if (bare != bcp47.toLowerCase()) {
          final bareAvailable = await _tts.isLanguageAvailable(bare);
          if (bareAvailable == true || bareAvailable == 1) {
            await _tts.setLanguage(bare);
            return true;
          }
        }
        debugPrint('TTS: language "$bcp47" not available on this device.');
        return false;
      }
    } catch (e) {
      debugPrint('TTS setLanguage error for "$langCode": $e');
      return false;
    }
  }

  /// Speaks [text] in the given [language].
  ///
  /// [language] is REQUIRED. If it is null, empty, or the language is not
  /// installed on the device, the method returns silently — ensuring the quiz
  /// continues without sound rather than accidentally speaking in the wrong
  /// language (e.g. English voices for non-English content).
  ///
  /// The speech rate is always re-applied after setting the language because
  /// some TTS engines reset the rate to their default when the language
  /// changes.
  Future<void> speak(String text, {String? language}) async {
    if (text.trim().isEmpty) return;

    // Require an explicit language. Without one we can't guarantee the correct
    // voice, so we stay silent rather than risk wrong-language playback.
    if (language == null || language.trim().isEmpty) return;

    try {
      await _ensureInit();

      final ok = await setLanguage(language);
      if (!ok) {
        // Language not available on this device — play quiz silently.
        return;
      }

      // Re-apply rate — some engines reset it when the language changes.
      await _tts.setSpeechRate(_engineRate(_rate));

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
