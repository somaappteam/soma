import 'dart:async';

import 'package:soma/core/di/locator.dart';
import 'package:soma/core/services/app_logger.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class EdgeFunctionInvoker {
  Future<FunctionResponse> invoke(final String name, {final Object? body});
}

class SupabaseEdgeFunctionInvoker implements EdgeFunctionInvoker {
  final SupabaseClient _supabase;

  SupabaseEdgeFunctionInvoker(this._supabase);

  @override
  Future<FunctionResponse> invoke(final String name, {final Object? body}) {
    return _supabase.functions.invoke(name, body: body);
  }
}

class AiRepository {
  AiRepository(this._invoker);

  final EdgeFunctionInvoker _invoker;

  static const int _maxAttempts = 3;
  static const Duration _requestTimeout = Duration(seconds: 8);

  Future<String> polishText(final String text) async {
    final res = await _invokeWithRetry('ai-polish', body: {'text': text});
    return _readTextResponse(res.data, field: 'text');
  }

  Future<String> rewriteText(final String text, final String style) async {
    final res = await _invokeWithRetry('ai-rewrite',
        body: {'text': text, 'style': style});
    return _readTextResponse(res.data, field: 'text');
  }

  Future<String> translateText(
      final String text, final String targetLanguage) async {
    final res = await _invokeWithRetry(
      'ai-translate',
      body: {'text': text, 'target_language': targetLanguage},
    );
    final translated = _readTextResponse(res.data, field: 'text');
    if (translated.length > 1200) {
      throw const FormatException(
          'Translated output exceeded maximum allowed length');
    }
    return translated;
  }

  Future<Map<String, dynamic>> analyzePronunciation(
      final String transcript) async {
    final res = await _invokeWithRetry('ai-pronunciation',
        body: {'transcript': transcript});
    final data = res.data;
    if (data is! Map<String, dynamic>) {
      throw const FormatException(
          'Unexpected response format for pronunciation analysis');
    }

    final score = data['score'];
    final difficultWords = data['difficult_words'];
    final tip = data['tip'];
    if (score is! num ||
        score < 0 ||
        score > 100 ||
        difficultWords is! List ||
        tip is! String) {
      throw const FormatException(
          'Pronunciation analysis payload schema mismatch');
    }
    return data;
  }

  Future<FunctionResponse> _invokeWithRetry(final String name,
      {required final Map<String, Object?> body}) async {
    Object? lastError;

    for (var attempt = 1; attempt <= _maxAttempts; attempt++) {
      try {
        final response =
            await _invoker.invoke(name, body: body).timeout(_requestTimeout);
        return response;
      } catch (error) {
        lastError = error;
        if (!_isTransient(error) || attempt == _maxAttempts) {
          rethrow;
        }
        final delay = Duration(milliseconds: 250 * attempt);
        appLogger.warning(
          'Retrying AI invocation',
          context: {
            'function': name,
            'attempt': attempt + 1,
            'delay_ms': delay.inMilliseconds
          },
          error: error,
        );
        await Future<void>.delayed(delay);
      }
    }

    throw Exception('Unknown AI invocation failure: $lastError');
  }

  bool _isTransient(final Object error) {
    final lower = error.toString().toLowerCase();
    return error is TimeoutException ||
        lower.contains('socketexception') ||
        lower.contains('network') ||
        lower.contains('connection') ||
        lower.contains('503') ||
        lower.contains('504');
  }

  String _readTextResponse(final dynamic data, {required final String field}) {
    if (data is! Map<String, dynamic>) {
      throw const FormatException('Unexpected AI response payload');
    }
    final value = data[field];
    if (value is! String || value.trim().isEmpty) {
      throw FormatException('Missing "$field" in AI response');
    }
    return value.trim();
  }
}

AiRepository get aiRepository => locator<AiRepository>();
