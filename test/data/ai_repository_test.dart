import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:soma/data/ai_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class _FakeInvoker implements EdgeFunctionInvoker {
  _FakeInvoker(this._handler);

  final Future<FunctionResponse> Function(String name, Object? body) _handler;

  @override
  Future<FunctionResponse> invoke(final String name, {final Object? body}) =>
      _handler(name, body);
}

FunctionResponse _response(final dynamic data) =>
    FunctionResponse(data: data, status: 200);

void main() {
  test('translateText returns expected value', () async {
    final repo = AiRepository(
        _FakeInvoker((final _, final __) async => _response({'text': 'Hola'})));

    final translated = await repo.translateText('Hello', 'Spanish');

    expect(translated, 'Hola');
  });

  test('translateText retries transient timeout and succeeds', () async {
    var attempts = 0;
    final repo = AiRepository(
      _FakeInvoker((final _, final __) async {
        attempts++;
        if (attempts == 1) {
          throw TimeoutException('timed out');
        }
        return _response({'text': 'Bonjour'});
      }),
    );

    final translated = await repo.translateText('Hello', 'French');

    expect(translated, 'Bonjour');
    expect(attempts, 2);
  });

  test('translateText throws on invalid payload', () async {
    final repo = AiRepository(_FakeInvoker(
        (final _, final __) async => _response({'value': 'missing'})));

    expect(() => repo.translateText('Hello', 'Spanish'),
        throwsA(isA<FormatException>()));
  });

  test('translateText enforces output max length', () async {
    final repo = AiRepository(
      _FakeInvoker((final _, final __) async =>
          _response({'text': List.filled(1201, 'x').join()})),
    );

    expect(() => repo.translateText('Hello', 'Spanish'),
        throwsA(isA<FormatException>()));
  });

  test('analyzePronunciation throws on schema mismatch', () async {
    final repo = AiRepository(
      _FakeInvoker((final _, final __) async =>
          _response({'score': 180, 'difficult_words': 'bad', 'tip': 1})),
    );

    expect(() => repo.analyzePronunciation('test transcript'),
        throwsA(isA<FormatException>()));
  });
}
