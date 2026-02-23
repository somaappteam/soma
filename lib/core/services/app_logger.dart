import 'dart:convert';

import 'package:flutter/foundation.dart';

enum AppLogLevel { debug, info, warning, error }

class AppLogger {
  const AppLogger();

  void debug(final String message, {final Map<String, Object?>? context}) {
    _log(AppLogLevel.debug, message, context: context);
  }

  void info(final String message, {final Map<String, Object?>? context}) {
    _log(AppLogLevel.info, message, context: context);
  }

  void warning(final String message, {final Map<String, Object?>? context, final Object? error, final StackTrace? stackTrace}) {
    _log(AppLogLevel.warning, message, context: context, error: error, stackTrace: stackTrace);
  }

  void error(final String message, {final Map<String, Object?>? context, final Object? error, final StackTrace? stackTrace}) {
    _log(AppLogLevel.error, message, context: context, error: error, stackTrace: stackTrace);
  }

  void _log(
    final AppLogLevel level,
    final String message, {
    final Map<String, Object?>? context,
    final Object? error,
    final StackTrace? stackTrace,
  }) {
    if (kReleaseMode && level == AppLogLevel.debug) return;

    final safeContext = _sanitizeContext(context ?? const <String, Object?>{});
    final base = '[${level.name.toUpperCase()}] $message';
    final contextSuffix = safeContext.isEmpty ? '' : ' ${jsonEncode(safeContext)}';
    debugPrint('$base$contextSuffix');

    if (error != null) {
      debugPrint('[${level.name.toUpperCase()}] error=$error');
    }
    if (stackTrace != null && !kReleaseMode) {
      debugPrint(stackTrace.toString());
    }
  }

  Map<String, Object?> _sanitizeContext(final Map<String, Object?> context) {
    return context.map((final key, final value) => MapEntry(key, _sanitizeValue(key, value)));
  }

  Object? _sanitizeValue(final String key, final Object? value) {
    final lowerKey = key.toLowerCase();
    const sensitiveKeys = <String>{
      'token',
      'apikey',
      'api_key',
      'authorization',
      'password',
      'secret',
      'email',
      'phone',
      'body',
      'text',
      'data',
    };

    if (sensitiveKeys.any(lowerKey.contains)) {
      return '<redacted>';
    }

    if (value is String && value.length > 180) {
      return '${value.substring(0, 180)}…';
    }

    if (value is Map<String, Object?>) {
      return _sanitizeContext(value);
    }

    return value;
  }
}

const appLogger = AppLogger();
