import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:app_bar_ui/app_bar_ui.dart';

void main() {
  group('Phase 6: Universal ScrollRange Tests', () {
    test('interpolates Size, BorderRadius, and EdgeInsets accurately', () {
      const sizeRange = ScrollRange<Size>(
        begin: Size(100.0, 50.0),
        end: Size(200.0, 80.0),
      );
      expect(sizeRange.transform(0.0), const Size(100.0, 50.0));
      expect(sizeRange.transform(0.5), const Size(150.0, 65.0));
      expect(sizeRange.transform(1.0), const Size(200.0, 80.0));

      final radiusRange = ScrollRange<BorderRadius>(
        begin: BorderRadius.circular(50.0),
        end: BorderRadius.circular(10.0),
      );
      expect(radiusRange.transform(0.0), BorderRadius.circular(50.0));
      expect(radiusRange.transform(0.5), BorderRadius.circular(30.0));
      expect(radiusRange.transform(1.0), BorderRadius.circular(10.0));

      const insetsRange = ScrollRange<EdgeInsets>(
        begin: EdgeInsets.all(10.0),
        end: EdgeInsets.all(30.0),
      );
      expect(insetsRange.transform(0.0), const EdgeInsets.all(10.0));
      expect(insetsRange.transform(0.5), const EdgeInsets.all(20.0));
      expect(insetsRange.transform(1.0), const EdgeInsets.all(30.0));
    });
  });

  group('Phase 6: ScrollAvatarTransform Tests', () {
    testWidgets('smoothly morphs size, radius, and offset based on progress', (
      tester,
    ) async {
      final progressNotifier = ValueNotifier<double>(0.0);
      bool avatarTapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: ScrollAvatarTransform(
                progressListenable: progressNotifier,
                beginSize: 80.0,
                endSize: 40.0,
                beginRadius: BorderRadius.circular(40.0),
                endRadius: BorderRadius.circular(8.0),
                beginOffset: Offset.zero,
                endOffset: const Offset(50.0, -20.0),
                onTap: () => avatarTapped = true,
                child: const Text('AVATAR'),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // At progress 0.0: size is 80x80
      final initialContainer = tester.widget<Container>(
        find.descendant(
          of: find.byType(ScrollAvatarTransform),
          matching: find.byType(Container),
        ),
      );
      expect(initialContainer.constraints?.maxWidth, 80.0);
      expect(initialContainer.constraints?.maxHeight, 80.0);

      // Tap avatar
      await tester.tap(find.text('AVATAR'));
      await tester.pumpAndSettle();
      expect(avatarTapped, isTrue);

      // Advance progress to 1.0 (fully collapsed)
      progressNotifier.value = 1.0;
      await tester.pumpAndSettle();

      final collapsedContainer = tester.widget<Container>(
        find.descendant(
          of: find.byType(ScrollAvatarTransform),
          matching: find.byType(Container),
        ),
      );
      expect(collapsedContainer.constraints?.maxWidth, 40.0);
      expect(collapsedContainer.constraints?.maxHeight, 40.0);

      // Check translation
      final transformFinder = find.descendant(
        of: find.byType(ScrollAvatarTransform),
        matching: find.byType(Transform),
      );
      expect(transformFinder, findsOneWidget);
      final transformWidget = tester.widget<Transform>(transformFinder);
      expect(transformWidget.transform.getTranslation().x, closeTo(50.0, 0.1));
      expect(transformWidget.transform.getTranslation().y, closeTo(-20.0, 0.1));

      // Reversibility check: return to 0.0
      progressNotifier.value = 0.0;
      await tester.pumpAndSettle();

      final revertedContainer = tester.widget<Container>(
        find.descendant(
          of: find.byType(ScrollAvatarTransform),
          matching: find.byType(Container),
        ),
      );
      expect(revertedContainer.constraints?.maxWidth, 80.0);
    });

    testWidgets('respects reduced-motion accessibility mode', (tester) async {
      final progressNotifier = ValueNotifier<double>(0.0);

      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: const MediaQueryData(disableAnimations: true),
            child: Scaffold(
              body: ScrollAvatarTransform(
                progressListenable: progressNotifier,
                beginSize: 80.0,
                endSize: 40.0,
                endOffset: const Offset(50.0, -20.0),
                child: const Text('AVATAR'),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      progressNotifier.value = 1.0;
      await tester.pumpAndSettle();

      final container = tester.widget<Container>(
        find.descendant(
          of: find.byType(ScrollAvatarTransform),
          matching: find.byType(Container),
        ),
      );
      expect(container.constraints?.maxWidth, 40.0);
    });
  });

  group('Phase 6: ScrollStaggeredBuilder Tests', () {
    testWidgets('calculates cascading progress across sequential items', (
      tester,
    ) async {
      final progressNotifier = ValueNotifier<double>(0.0);
      final recordedProgress = <int, double>{};

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ScrollStaggeredBuilder(
              progressListenable: progressNotifier,
              itemCount: 4,
              staggerInterval: 0.1,
              itemDuration: 0.2,
              builder: (context, index, itemProgress) {
                recordedProgress[index] = itemProgress;
                return Text('Item $index: ${itemProgress.toStringAsFixed(2)}');
              },
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // At progress 0.0: all items are at 0.0
      expect(recordedProgress[0], 0.0);
      expect(recordedProgress[1], 0.0);
      expect(recordedProgress[2], 0.0);
      expect(recordedProgress[3], 0.0);

      // Advance to 0.15:
      // Item 0 (starts 0.0): (0.15 - 0.0) / 0.2 = 0.75
      // Item 1 (starts 0.1): (0.15 - 0.1) / 0.2 = 0.25
      // Item 2 (starts 0.2): 0.0
      progressNotifier.value = 0.15;
      await tester.pumpAndSettle();

      expect(recordedProgress[0], greaterThan(0.5));
      expect(recordedProgress[1], greaterThan(0.0));
      expect(recordedProgress[2], 0.0);
      expect(recordedProgress[3], 0.0);

      // Advance to 1.0: all items complete (1.0)
      progressNotifier.value = 1.0;
      await tester.pumpAndSettle();

      expect(recordedProgress[0], 1.0);
      expect(recordedProgress[1], 1.0);
      expect(recordedProgress[2], 1.0);
      expect(recordedProgress[3], 1.0);
    });
  });

  group('Phase 6: ScrollAnimatedBuilder Tests', () {
    testWidgets(
      'interpolates multiple properties simultaneously and reversibly',
      (tester) async {
        final progressNotifier = ValueNotifier<double>(0.0);
        ScrollAnimatedValues? capturedValues;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: ScrollAnimatedBuilder(
                progressListenable: progressNotifier,
                opacity: const ScrollRange<double>(begin: 1.0, end: 0.2),
                scale: const ScrollRange<double>(begin: 1.0, end: 0.5),
                translation: const ScrollRange<Offset>(
                  begin: Offset.zero,
                  end: Offset(0.0, -40.0),
                ),
                rotation: const ScrollRange<double>(begin: 0.0, end: 1.57),
                color: const ScrollRange<Color>(
                  begin: Colors.red,
                  end: Colors.blue,
                ),
                size: const ScrollRange<Size>(
                  begin: Size(100.0, 50.0),
                  end: Size(200.0, 100.0),
                ),
                builder: (context, values, child) {
                  capturedValues = values;
                  return Text('Progress: ${values.progress}');
                },
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(capturedValues, isNotNull);
        expect(capturedValues!.opacity, 1.0);
        expect(capturedValues!.scale, 1.0);
        expect(capturedValues!.translation, Offset.zero);
        expect(capturedValues!.rotation, 0.0);
        expect(capturedValues!.color, Colors.red);
        expect(capturedValues!.size, const Size(100.0, 50.0));

        // Advance to 1.0
        progressNotifier.value = 1.0;
        await tester.pumpAndSettle();

        expect(capturedValues!.opacity, closeTo(0.2, 0.01));
        expect(capturedValues!.scale, closeTo(0.5, 0.01));
        expect(capturedValues!.translation.dy, closeTo(-40.0, 0.01));
        expect(capturedValues!.rotation, closeTo(1.57, 0.01));
        expect(capturedValues!.color, Colors.blue);
        expect(capturedValues!.size, const Size(200.0, 100.0));

        // Reversibility: return halfway to 0.5
        progressNotifier.value = 0.5;
        await tester.pumpAndSettle();

        expect(capturedValues!.opacity, closeTo(0.6, 0.02));
        expect(capturedValues!.scale, closeTo(0.75, 0.02));
        expect(capturedValues!.translation.dy, closeTo(-20.0, 0.02));
        expect(capturedValues!.size, const Size(150.0, 75.0));
      },
    );
  });
}
