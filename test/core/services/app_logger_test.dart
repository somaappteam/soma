import 'package:flutter_test/flutter_test.dart';
import 'package:soma/core/services/app_logger.dart';

void main() {
  test('logger methods execute without throwing', () {
    const logger = AppLogger();

    expect(
      () {
        logger.debug('debug', context: {'token': 'secret', 'count': 1});
        logger.info('info', context: {'email': 'person@example.com'});
        logger.warning('warning', context: {'text': 'hello'});
        logger.error('error', error: Exception('boom'));
      },
      returnsNormally,
    );
  });
}
