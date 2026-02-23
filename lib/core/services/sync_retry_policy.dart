import 'package:soma/data/content_sync_service.dart';

typedef SyncRunner = Future<ContentSyncResult> Function();

typedef RetryScheduled = Future<void> Function(int attempt, List<String> failedSteps);

class SyncRetryPolicy {
  static const int maxAttempts = 3;
  static const int baseDelayMs = 700;

  Future<ContentSyncResult> execute({
    required final SyncRunner runSync,
    required final RetryScheduled onRetryScheduled,
    final Future<void> Function(Duration delay)? wait,
  }) async {
    final waiter = wait ?? Future<void>.delayed;
    ContentSyncResult? result;

    for (var attempt = 1; attempt <= maxAttempts; attempt++) {
      result = await runSync();
      if (result.success) return result;

      if (attempt == maxAttempts) break;

      await onRetryScheduled(attempt + 1, result.failedSteps);
      final delayMs = baseDelayMs * (1 << (attempt - 1));
      await waiter(Duration(milliseconds: delayMs));
    }

    return result ?? const ContentSyncResult(
      duration: Duration.zero,
      failedSteps: <String>['unknown'],
      stepDurationsMs: <String, int>{},
    );
  }
}
