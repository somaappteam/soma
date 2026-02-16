import 'package:supabase_flutter/supabase_flutter.dart';

class AiRepository {
  final SupabaseClient _supabase;

  AiRepository(this._supabase);

  /// Polish text to be more grammatically correct and natural
  Future<String> polishText(String text) async {
    try {
      final res = await _supabase.functions.invoke('ai-polish', body: {
        'text': text,
      });
      return res.data['text'] as String;
    } catch (e) {
      // Fallback to original if offline/error, or rethrow to let UI handle
      rethrow;
    }
  }

  /// Rewrite text in a specific style (formal, romantic, etc)
  Future<String> rewriteText(String text, String style) async {
    try {
      final res = await _supabase.functions.invoke('ai-rewrite', body: {
        'text': text,
        'style': style,
      });
      return res.data['text'] as String;
    } catch (e) {
      rethrow;
    }
  }

  /// Translate text to target language
  Future<String> translateText(String text, String targetLanguage) async {
    try {
      final res = await _supabase.functions.invoke('ai-translate', body: {
        'text': text,
        'target_language': targetLanguage,
      });
      return res.data['text'] as String;
    } catch (e) {
      rethrow;
    }
  }

  /// Analyze pronunciation from audio transcript
  /// Returns a Map with score, difficult words, and tips
  Future<Map<String, dynamic>> analyzePronunciation(String transcript) async {
    try {
      final res = await _supabase.functions.invoke('ai-pronunciation', body: {
        'transcript': transcript,
      });
      return res.data as Map<String, dynamic>;
    } catch (e) {
      rethrow;
    }
  }
}

final aiRepository = AiRepository(Supabase.instance.client);
