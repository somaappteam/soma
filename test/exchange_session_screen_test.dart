import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:soma/features/circles/exchange_session_screen.dart';

void main() {
  testWidgets('ExchangeSessionScreen renders round header', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: ExchangeSessionScreen(
          partnerUserId: 'u1',
          partnerName: 'Alex',
          myLearningLanguage: 'French',
          partnerLearningLanguage: 'English',
        ),
      ),
    );

    expect(find.textContaining('Round 1/10'), findsOneWidget);
    expect(find.textContaining('Exchange with Alex'), findsOneWidget);
  });
}
