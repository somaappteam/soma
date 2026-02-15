import 'package:flutter_test/flutter_test.dart';
import 'package:soma/data/soma_plus_repository.dart';

void main() {
  test('DM limits increase with subscription tiers', () {
    final free = SomaPlusRepository.dmLimitsForTier(SomaSubscriptionTier.free);
    final plus = SomaPlusRepository.dmLimitsForTier(SomaSubscriptionTier.plus);
    final pro = SomaPlusRepository.dmLimitsForTier(SomaSubscriptionTier.pro);

    expect(plus.maxImageBytes, greaterThan(free.maxImageBytes));
    expect(pro.maxImageBytes, greaterThan(plus.maxImageBytes));
    expect(plus.maxFileBytes, greaterThan(free.maxFileBytes));
    expect(pro.maxFileBytes, greaterThan(plus.maxFileBytes));
    expect(plus.maxTextChars, greaterThan(free.maxTextChars));
    expect(pro.maxTextChars, greaterThan(plus.maxTextChars));
  });
}
