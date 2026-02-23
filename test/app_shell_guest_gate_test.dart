import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:soma/features/home/app_shell.dart';
import 'package:soma/l10n/gen/app_localizations.dart';

void main() {
  testWidgets('guest sees value bullets when tapping circles tab', (final tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: AppShell(),
      ),
    );

    await tester.tap(find.byIcon(Icons.public_rounded).first);
    await tester.pumpAndSettle();

    expect(find.textContaining('Live circles with real learners'), findsOneWidget);
    expect(find.textContaining('Voice rooms with instant practice'), findsOneWidget);
  });
}
