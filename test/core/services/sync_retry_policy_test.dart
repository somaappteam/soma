import 'package:flutter_test/flutter_test.dart';
import 'package:soma/core/services/sync_retry_policy.dart';
import 'package:soma/data/content_sync_service.dart';

void main() {
  test('retries and eventually succeeds', () async {
    final policy = SyncRetryPolicy();
    var attempts = 0;
    final scheduled = <int>[];

    final result = await policy.execute(
      runSync: () async {
        attempts++;
        if (attempts < 3) {
          return const ContentSyncResult(
            duration: Duration(milliseconds: 10),
            failedSteps: ['offline_queue'],
            stepDurationsMs: {'offline_queue': 10},
          );
        }
        return const ContentSyncResult(
          duration: Duration(milliseconds: 10),
          failedSteps: <String>[],
          stepDurationsMs: {'offline_queue': 10},
        );
      },
      onRetryScheduled: (final attempt, final _) async => scheduled.add(attempt),
      wait: (final _) async {},
    );

    expect(result.success, isTrue);
    expect(attempts, 3);
    expect(scheduled, [2, 3]);
  });

  test('returns failed result after max attempts', () async {
    final policy = SyncRetryPolicy();
    var attempts = 0;

    final result = await policy.execute(
      runSync: () async {
        attempts++;
        return const ContentSyncResult(
          duration: Duration(milliseconds: 10),
          failedSteps: ['courses'],
          stepDurationsMs: {'courses': 10},
        );
      },
      onRetryScheduled: (final _, final __) async {},
      wait: (final _) async {},
    );

    expect(result.success, isFalse);
    expect(attempts, SyncRetryPolicy.maxAttempts);
  });
}
