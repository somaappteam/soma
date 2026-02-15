import 'package:flutter_test/flutter_test.dart';
import 'package:soma/features/circles/exchange_session_controller.dart';

void main() {
  test('controller enforces turn and correction limit', () async {
    final controller = ExchangeSessionController(
      partnerName: 'Alex',
      partnerUserId: 'u1',
      sessionKey: 'k',
    );

    expect(controller.isMyTurn, isTrue);
    final sent = await controller.sendMessage('Salut');
    expect(sent, isTrue);
    expect(controller.isMyTurn, isFalse);

    final sentAgain = await controller.sendMessage('Encore');
    expect(sentAgain, isFalse);

    expect(controller.canUseCorrection(), isTrue);
    final used = await controller.markCorrectionUsed();
    expect(used, isTrue);
    expect(controller.canUseCorrection(), isFalse);
  });

  test('controller blocks out-of-round language and supports round switch', () async {
    final controller = ExchangeSessionController(
      partnerName: 'Alex',
      partnerUserId: 'u2',
      sessionKey: 'k2',
    );

    final blocked = await controller.sendMessage('hello my friend');
    expect(blocked, isFalse);

    await controller.nextRound();
    expect(controller.activeLanguage, ExchangeRoundLanguage.english);

    final blockedFrench = await controller.sendMessage('bonjour mon ami');
    expect(blockedFrench, isFalse);

    final okEnglish = await controller.sendMessage('Thanks for your message');
    expect(okEnglish, isTrue);
  });

  test('round switch resets correction budget and turn', () async {
    final controller = ExchangeSessionController(
      partnerName: 'Alex',
      partnerUserId: 'u3',
      sessionKey: 'k3',
    );

    await controller.markCorrectionUsed();
    expect(controller.myCorrectionsUsed, 1);

    await controller.nextRound();
    expect(controller.myCorrectionsUsed, 0);
    expect(controller.isMyTurn, isTrue);
  });
}
