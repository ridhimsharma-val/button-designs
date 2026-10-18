import 'package:button_lab/widgets/reusable_squishy_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ReusableSquishyButton Unit and Gesture Tests', () {
    testWidgets('Tapping compresses and triggers callback on release', (
      WidgetTester tester,
    ) async {
      int pressCount = 0;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: ReusableSquishyButton(
                label: 'Test Button',
                onPressed: () => pressCount++,
              ),
            ),
          ),
        ),
      );

      final Finder buttonFinder = find.byType(ReusableSquishyButton);
      expect(buttonFinder, findsOneWidget);

      // Resting scale should be 1.0
      Transform transform = tester.widget<Transform>(
        find
            .descendant(of: buttonFinder, matching: find.byType(Transform))
            .first,
      );
      expect(transform.transform.storage[0], closeTo(1.0, 0.01));

      // Press down (start gesture)
      final TestGesture gesture = await tester.startGesture(
        tester.getCenter(buttonFinder),
      );
      // Wait for press compression to settle while still holding down
      await tester.pumpAndSettle();

      transform = tester.widget<Transform>(
        find
            .descendant(of: buttonFinder, matching: find.byType(Transform))
            .first,
      );
      expect(transform.transform.storage[0], lessThan(0.96));
      expect(pressCount, equals(0));

      // Release gesture
      await gesture.up();
      expect(pressCount, equals(1));

      // Wait for spring back
      await tester.pumpAndSettle();

      transform = tester.widget<Transform>(
        find
            .descendant(of: buttonFinder, matching: find.byType(Transform))
            .first,
      );
      expect(transform.transform.storage[0], closeTo(1.0, 0.01));
    });

    testWidgets('Pointer cancellation restores scale without firing callback', (
      WidgetTester tester,
    ) async {
      int pressCount = 0;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: ReusableSquishyButton(
                label: 'Test Cancel',
                onPressed: () => pressCount++,
              ),
            ),
          ),
        ),
      );

      final Finder buttonFinder = find.byType(ReusableSquishyButton);

      // Start gesture
      final TestGesture gesture = await tester.startGesture(
        tester.getCenter(buttonFinder),
      );
      await tester.pumpAndSettle();

      // Cancel gesture (simulates drag away or OS gesture interruption)
      await gesture.cancel();
      await tester.pumpAndSettle();

      // Callback should NOT be invoked
      expect(pressCount, equals(0));

      // Scale must return to rest (1.0)
      final Transform transform = tester.widget<Transform>(
        find
            .descendant(of: buttonFinder, matching: find.byType(Transform))
            .first,
      );
      expect(transform.transform.storage[0], closeTo(1.0, 0.01));
    });

    testWidgets('Rapid repeated taps do not desync or lock state', (
      WidgetTester tester,
    ) async {
      int pressCount = 0;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: ReusableSquishyButton(
                label: 'Rapid Tap',
                onPressed: () => pressCount++,
              ),
            ),
          ),
        ),
      );

      final Finder buttonFinder = find.byType(ReusableSquishyButton);

      // Perform 5 rapid taps
      for (int i = 0; i < 5; i++) {
        await tester.tap(buttonFinder);
        await tester.pump(const Duration(milliseconds: 30));
      }

      await tester.pumpAndSettle();

      expect(pressCount, equals(5));

      final Transform transform = tester.widget<Transform>(
        find
            .descendant(of: buttonFinder, matching: find.byType(Transform))
            .first,
      );
      expect(transform.transform.storage[0], closeTo(1.0, 0.01));
    });

    testWidgets('Disabled button ignores gestures', (
      WidgetTester tester,
    ) async {
      int pressCount = 0;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: ReusableSquishyButton(
                label: 'Disabled',
                enabled: false,
                onPressed: () => pressCount++,
              ),
            ),
          ),
        ),
      );

      final Finder buttonFinder = find.byType(ReusableSquishyButton);

      await tester.tap(buttonFinder);
      await tester.pumpAndSettle();

      expect(pressCount, equals(0));
    });
  });
}
