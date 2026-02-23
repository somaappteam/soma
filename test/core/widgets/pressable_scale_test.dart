import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:soma/core/widgets/pressable_scale.dart';

void main() {
  testWidgets('PressableScale shrinks on tap down and restores on tap up', (final tester) async {
    bool tapped = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: PressableScale(
              onTap: () => tapped = true,
              pressedScale: 0.8,
              enableHaptics: false, // Turn off haptics for the test to avoid native call issues
              child: const SizedBox(
                width: 100,
                height: 50,
                child: Text('Press Me'),
              ),
            ),
          ),
        ),
      ),
    );

    // Initial scale is 1.0 (AnimatedScale)
    final animatedScaleFinder = find.byType(AnimatedScale);
    expect(animatedScaleFinder, findsOneWidget);
    
    AnimatedScale animatedScale = tester.widget(animatedScaleFinder);
    expect(animatedScale.scale, 1.0);

    // Tap down
    final textFinder = find.text('Press Me');
    final gesture = await tester.startGesture(tester.getCenter(textFinder));
    await tester.pump(); // Start animation

    // Scale should be 0.8 during press (since onTap is active)
    animatedScale = tester.widget(animatedScaleFinder);
    expect(animatedScale.scale, 0.8);

    // Release tap
    await gesture.up();
    await tester.pumpAndSettle(); // Wait for release animation to finish

    // Scale back to 1.0
    animatedScale = tester.widget(animatedScaleFinder);
    expect(animatedScale.scale, 1.0);

    // Tap was registered
    expect(tapped, isTrue);
  });
}
