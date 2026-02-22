import 'package:flutter/foundation.dart';

import 'app_logger.dart';

// ─── Optional Sentry import ───────────────────────────────────────────────────
// sentry_flutter is imported conditionally so the app builds even if the
// SENTRY_DSN env var is not set (e.g. during development).
// In release mode with a valid DSN this will capture errors automatically.
import 'package:sentry_flutter/sentry_flutter.dart';

/// Application-wide error reporting service.
///
/// Use [capture] instead of bare `debugPrint` inside catch blocks:
///
/// ```dart
/// } catch (e, stack) {
///   errorReporter.capture(e, stack, hint: 'Loading quiz questions');
/// }
/// ```
///
/// Behaviour:
/// - **Debug / profile** mode → prints to console only (no Sentry traffic).
/// - **Release** mode → forwards to Sentry (if DSN is configured).
class ErrorReporter {
  ErrorReporter._();
  static final ErrorReporter instance = ErrorReporter._();

  /// Captures [error] + [stack] and optionally a human-readable [hint].
  Future<void> capture(
    Object error,
    StackTrace? stack, {
    String? hint,
  }) async {
    appLogger.error(
      hint ?? 'Unhandled error',
      error: error,
      stackTrace: stack,
      context: hint == null ? null : <String, Object?>{'hint': hint},
    );

    // Forward to Sentry only in release builds.
    if (!kDebugMode && !kProfileMode) {
      await Sentry.captureException(
        error,
        stackTrace: stack,
        hint: hint != null ? Hint.withMap({'description': hint}) : null,
      );
    }
  }
}

/// Global singleton convenience accessor.
final errorReporter = ErrorReporter.instance;
