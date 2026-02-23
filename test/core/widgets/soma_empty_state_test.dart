import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:soma/core/widgets/soma_empty_state.dart';

void main() {
  testWidgets('SomaEmptyState renders emoji, title, subtitle, and action', (final tester) async {
    bool actionTapped = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SomaEmptyState(
            emoji: '🚀',
            title: 'Test Title',
            subtitle: 'This is a test subtitle.',
            action: ElevatedButton(
              onPressed: () => actionTapped = true,
              child: const Text('Action Button'),
            ),
          ),
        ),
      ),
    );

    await tester.pump();

    expect(find.text('🚀'), findsOneWidget);
    expect(find.text('Test Title'), findsOneWidget);
    expect(find.text('This is a test subtitle.'), findsOneWidget);
    expect(find.text('Action Button'), findsOneWidget);

    await tester.tap(find.text('Action Button'));
    await tester.pump();

    expect(actionTapped, isTrue);
  });
}
