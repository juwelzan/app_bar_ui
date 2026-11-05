import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:app_bar_ui/app_bar_ui.dart';

void main() {
  group('Phase 10.1: SmartVisibilityController & Config', () {
    test('initializes default rules with valid thresholds', () {
      final config = SmartVisibilityConfig();
      expect(config.rules, isNotEmpty);

      final headerRule = config.getRule(VisibilityTarget.header);
      expect(headerRule.hideOffset, 120.0);
      expect(headerRule.showOffset, 40.0);
      expect(headerRule.hideOnScrollDown, isTrue);

      final fabRule = config.getRule(VisibilityTarget.floatingActionButton);
      expect(fabRule.hideOffset, 80.0);
      expect(fabRule.showOffset, 40.0);
    });

    test('validates rule boundary assertion (showOffset <= hideOffset)', () {
      expect(
        () => VisibilityRule(
          target: VisibilityTarget.header,
          hideOffset: 50.0,
          showOffset: 80.0, // Invalid!
        ),
        throwsAssertionError,
      );
    });

    test('controller initializes with initial visibility values', () {
      final controller = SmartVisibilityController();
      expect(controller.getVisibility(VisibilityTarget.header), 1.0);
      expect(controller.isVisible(VisibilityTarget.header), isTrue);
      expect(controller.getVisibility(VisibilityTarget.floatingActionButton), 1.0);
      expect(controller.getVisibility(VisibilityTarget.bottomNavigationBar), 1.0);
      controller.dispose();
    });

    test('controller hides components when scrolling down past thresholds', () {
      final controller = SmartVisibilityController();

      // Scroll down past 90px (past FAB hideOffset 80px, but before header 120px)
      controller.updateScroll(
        90.0,
        direction: ScrollDirection.reverse,
        delta: 10.0,
      );

      expect(controller.getVisibility(VisibilityTarget.floatingActionButton), 0.0);
      expect(controller.isVisible(VisibilityTarget.floatingActionButton), isFalse);
      // Header has hideOffset 120, so at 90 it is still visible
      expect(controller.getVisibility(VisibilityTarget.header), 1.0);

      // Scroll further down to 130px (past header hideOffset 120px)
      controller.updateScroll(
        130.0,
        direction: ScrollDirection.reverse,
        delta: 10.0,
      );
      expect(controller.getVisibility(VisibilityTarget.header), 0.0);
      expect(controller.isVisible(VisibilityTarget.header), isFalse);

      controller.dispose();
    });

    test('controller restores components on reverse scroll up below showOffset', () {
      final controller = SmartVisibilityController();

      // Scroll down
      controller.updateScroll(
        150.0,
        direction: ScrollDirection.reverse,
        delta: 10.0,
      );
      expect(controller.getVisibility(VisibilityTarget.header), 0.0);

      // Scroll up into deadband (60px) - header showOffset is 40px, so still hidden
      controller.updateScroll(
        60.0,
        direction: ScrollDirection.forward,
        delta: -10.0,
      );
      expect(controller.getVisibility(VisibilityTarget.header), 0.0);

      // Scroll up below showOffset (30px) - restores to 1.0
      controller.updateScroll(
        30.0,
        direction: ScrollDirection.forward,
        delta: -10.0,
      );
      expect(controller.getVisibility(VisibilityTarget.header), 1.0);
      expect(controller.isVisible(VisibilityTarget.header), isTrue);

      controller.dispose();
    });

    test('controller supports programmatic visibility override and reset', () {
      final controller = SmartVisibilityController();
      controller.setVisibility(VisibilityTarget.header, 0.3);
      expect(controller.getVisibility(VisibilityTarget.header), 0.3);

      controller.resetToInitial();
      expect(controller.getVisibility(VisibilityTarget.header), 1.0);

      controller.dispose();
    });
  });

  group('Phase 10.1: Scroll Animation System', () {
    test('ScrollRange interpolates double, Offset, and Color values', () {
      const doubleRange = ScrollRange<double>(
        begin: 0.0,
        end: 100.0,
        beginProgress: 0.2,
        endProgress: 0.6,
      );

      expect(doubleRange.transform(0.1), 0.0);
      expect(doubleRange.transform(0.2), 0.0);
      expect(doubleRange.transform(0.4), closeTo(50.0, 0.001));
      expect(doubleRange.transform(0.6), 100.0);
      expect(doubleRange.transform(0.9), 100.0);

      const offsetRange = ScrollRange<Offset>(
        begin: Offset.zero,
        end: Offset(0.0, 50.0),
      );
      expect(offsetRange.transform(0.5), const Offset(0.0, 25.0));

      const colorRange = ScrollRange<Color>(
        begin: Colors.black,
        end: Colors.white,
      );
      final midColor = colorRange.transform(0.5);
      expect(midColor.r, closeTo(0.5, 0.01));
    });

    testWidgets('ScrollTransform applies opacity, scale, and translation', (
      tester,
    ) async {
      final progressNotifier = ValueNotifier<double>(0.0);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ScrollTransform(
              progressListenable: progressNotifier,
              opacity: const ScrollRange(begin: 1.0, end: 0.0),
              scale: const ScrollRange(begin: 1.0, end: 0.5),
              translation: const ScrollRange(
                begin: Offset.zero,
                end: Offset(0.0, 20.0),
              ),
              child: const Text('Transform Target'),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Transform Target'), findsOneWidget);

      // Advance progress to 1.0 (fully transformed)
      progressNotifier.value = 1.0;
      await tester.pump();

      // Verify opacity is applied
      final opacityWidget = tester.widget<Opacity>(
        find.descendant(
          of: find.byType(ScrollTransform),
          matching: find.byType(Opacity),
        ),
      );
      expect(opacityWidget.opacity, 0.0);

      // Verify scale and translation transforms are applied
      final transforms = tester
          .widgetList<Transform>(
            find.descendant(
              of: find.byType(ScrollTransform),
              matching: find.byType(Transform),
            ),
          )
          .toList();
      expect(transforms.length, 2);
      final hasScale = transforms.any(
        (t) =>
            (t.transform.storage[0] - 0.5).abs() < 0.01 &&
            (t.transform.storage[5] - 0.5).abs() < 0.01,
      );
      final hasTranslation = transforms.any(
        (t) => (t.transform.storage[13] - 20.0).abs() < 0.01,
      );
      expect(hasScale, isTrue);
      expect(hasTranslation, isTrue);
    });

    testWidgets('ScrollTransform respects reduced-motion accessibility preference', (
      tester,
    ) async {
      final progressNotifier = ValueNotifier<double>(1.0);

      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: const MediaQueryData(disableAnimations: true), // User requested reduced motion!
            child: Scaffold(
              body: ScrollTransform(
                progressListenable: progressNotifier,
                scale: const ScrollRange(begin: 1.0, end: 0.5),
                translation: const ScrollRange(
                  begin: Offset.zero,
                  end: Offset(0.0, 50.0),
                ),
                child: const Text('Reduced Motion Target'),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // When disableAnimations is true, Transform.scale and Transform.translate are suppressed!
      expect(
        find.descendant(
          of: find.byType(ScrollTransform),
          matching: find.byType(Transform),
        ),
        findsNothing,
      );
    });

    testWidgets('ScrollColorTransition dynamically interpolates colors', (
      tester,
    ) async {
      final progressNotifier = ValueNotifier<double>(0.0);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ScrollColorTransition(
              progressListenable: progressNotifier,
              beginColor: Colors.red,
              endColor: Colors.blue,
              builder: (context, color, gradient, child) => Container(
                key: const ValueKey('colored_box'),
                color: color,
                child: child,
              ),
              child: const Text('Color Content'),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      var box = tester.widget<Container>(find.byKey(const ValueKey('colored_box')));
      expect(box.color, Colors.red);

      // Advance progress
      progressNotifier.value = 1.0;
      await tester.pump();

      box = tester.widget<Container>(find.byKey(const ValueKey('colored_box')));
      expect(box.color, Colors.blue);
    });

    testWidgets('ScrollMorphBuilder switches hit testing and visibility at switchPoint', (
      tester,
    ) async {
      final progressNotifier = ValueNotifier<double>(0.0);
      bool initialTapped = false;
      bool scrolledTapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ScrollMorphBuilder(
              progressListenable: progressNotifier,
              switchPoint: 0.5,
              initialChild: GestureDetector(
                onTap: () => initialTapped = true,
                child: const Text('Initial Avatar Widget'),
              ),
              scrolledChild: GestureDetector(
                onTap: () => scrolledTapped = true,
                child: const Text('Scrolled Icon Widget'),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // At progress 0.0: initial is hit testable
      await tester.tap(find.text('Initial Avatar Widget'));
      await tester.pump();
      expect(initialTapped, isTrue);
      expect(scrolledTapped, isFalse);

      // Progress past switch point (0.8)
      progressNotifier.value = 0.8;
      await tester.pump();

      initialTapped = false;
      await tester.tap(find.text('Scrolled Icon Widget'));
      await tester.pump();
      expect(initialTapped, isFalse);
      expect(scrolledTapped, isTrue);
    });
  });
}
