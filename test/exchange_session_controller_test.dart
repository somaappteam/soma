import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:soma/features/circles/exchange_session_controller.dart';

void main() {
  test('controller enforces request, turn, and correction limit', () async {
    final controller = ExchangeSessionController(
      partnerName: 'Alex',
      partnerUserId: 'u1',
      sessionKey: 'k',
      firstLanguageCode: 'fr',
      secondLanguageCode: 'en',
    );

    expect(controller.isMyTurn, isTrue);
    final blockedBeforeAccept = await controller.sendMessage('Salut');
    expect(blockedBeforeAccept, isFalse);

    await controller.acceptRequest();
    final sent = await controller.sendMessage('Salut merci');
    expect(sent, isTrue);
    expect(controller.isMyTurn, isFalse);

    final sentAgain = await controller.sendMessage('Encore');
    expect(sentAgain, isFalse);

    expect(controller.canUseCorrection(), isTrue);
    final used = await controller.markCorrectionUsed();
    expect(used, isTrue);
    expect(controller.canUseCorrection(), isFalse);
  });

  test('controller supports dynamic round switch', () async {
    final controller = ExchangeSessionController(
      partnerName: 'Alex',
      partnerUserId: 'u2',
      sessionKey: 'k2',
      firstLanguageCode: 'fr',
      secondLanguageCode: 'en',
    );

    await controller.acceptRequest();
    expect(controller.activeLanguageCode, 'en');

    await controller.nextRound();
    expect(controller.activeLanguageCode, 'fr');

    final okFrench = await controller.sendMessage('bonjour merci comment');
    expect(okFrench, isTrue);
  });

  test('round switch resets correction budget and turn', () async {
    final controller = ExchangeSessionController(
      partnerName: 'Alex',
      partnerUserId: 'u3',
      sessionKey: 'k3',
      firstLanguageCode: 'fr',
      secondLanguageCode: 'en',
    );

    await controller.acceptRequest();
    await controller.markCorrectionUsed();
    expect(controller.myCorrectionsUsed, 1);

    await controller.nextRound();
    expect(controller.myCorrectionsUsed, 0);
    expect(controller.isMyTurn, isTrue);
  });

  test('rate limit blocks after max messages per minute', () async {
    final controller = ExchangeSessionController(
      partnerName: 'Alex',
      partnerUserId: 'u4',
      sessionKey: 'k4',
      firstLanguageCode: 'fr',
      secondLanguageCode: 'en',
    );

    await controller.acceptRequest();
    for (var i = 0; i < ExchangeSessionController.maxMessagesPerMinute; i++) {
      final ok = await controller.sendMessage('bonjour merci $i');
      expect(ok, isTrue);
      await controller.receivePartnerMessage('ok');
    }

    final blocked = await controller.sendMessage('bonjour extra');
    expect(blocked, isFalse);
    expect(controller.isInCooldown, isTrue);
  });

  test('declined request blocks messages', () async {
    final controller = ExchangeSessionController(
      partnerName: 'Alex',
      partnerUserId: 'u5',
      sessionKey: 'k5',
      firstLanguageCode: 'fr',
      secondLanguageCode: 'en',
    );

    await controller.declineRequest();
    final blocked = await controller.sendMessage('bonjour');
    expect(blocked, isFalse);
    expect(controller.requestStatus, 'declined');
  });

  test('pending request becomes expired after ttl when ticking', () async {
    SharedPreferences.setMockInitialValues({
      'exchange_session_expire':
          '{"requestStatus":"pending","requestCreatedAt":"2000-01-01T00:00:00.000Z","turnStartedAt":"2000-01-01T00:00:00.000Z"}',
    });
    final controller = ExchangeSessionController(
      partnerName: 'Alex',
      partnerUserId: 'u6',
      sessionKey: 'expire',
      firstLanguageCode: 'fr',
      secondLanguageCode: 'en',
    );

    await controller.hydrate();
    await controller.tickTurnAndAutoSkipIfNeeded();
    expect(controller.requestStatus, 'expired');
  });

  test('hydrate restores accepted request status', () async {
    SharedPreferences.setMockInitialValues({
      'exchange_session_hydrate':
          '{"requestStatus":"accepted","activeLanguageCode":"es","turnStartedAt":"2030-01-01T00:00:00.000Z"}',
    });
    final controller = ExchangeSessionController(
      partnerName: 'Alex',
      partnerUserId: 'u7',
      sessionKey: 'hydrate',
      firstLanguageCode: 'fr',
      secondLanguageCode: 'en',
    );

    await controller.hydrate();
    expect(controller.requestStatus, 'accepted');
    expect(controller.activeLanguageCode, 'es');
  });

  test('turn timeout auto-skip triggers when timer elapsed', () async {
    SharedPreferences.setMockInitialValues({
      'exchange_session_timeout':
          '{"requestStatus":"accepted","isMyTurn":true,"turnStartedAt":"2000-01-01T00:00:00.000Z"}',
    });
    final controller = ExchangeSessionController(
      partnerName: 'Alex',
      partnerUserId: 'u8',
      sessionKey: 'timeout',
      firstLanguageCode: 'fr',
      secondLanguageCode: 'en',
    );

    await controller.hydrate();
    final skipped = await controller.tickTurnAndAutoSkipIfNeeded();
    expect(skipped, isTrue);
    expect(controller.isMyTurn, isFalse);
  });
}
