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
      expect(
        controller.getVisibility(VisibilityTarget.floatingActionButton),
        1.0,
      );
      expect(
        controller.getVisibility(VisibilityTarget.bottomNavigationBar),
        1.0,
      );
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

      expect(
        controller.getVisibility(VisibilityTarget.floatingActionButton),
        0.0,
      );
      expect(
        controller.isVisible(VisibilityTarget.floatingActionButton),
        isFalse,
      );
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

    test(
      'controller restores components on reverse scroll up below showOffset',
      () {
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
      },
    );

    test('controller supports programmatic visibility override and reset', () {
      final controller = SmartVisibilityController();
      controller.setVisibility(VisibilityTarget.header, 0.3);
      expect(controller.getVisibility(VisibilityTarget.header), 0.3);

      controller.resetToInitial();
      expect(controller.getVisibility(VisibilityTarget.header), 1.0);

      controller.dispose();
    });

    test('controller supports show, hide, toggle, showAll, and hideAll', () {
      final controller = SmartVisibilityController();

      // Show, hide, toggle
      controller.hide(VisibilityTarget.floatingActionButton);
      expect(
        controller.getVisibility(VisibilityTarget.floatingActionButton),
        0.0,
      );
      expect(
        controller.isVisible(VisibilityTarget.floatingActionButton),
        isFalse,
      );

      controller.show(VisibilityTarget.floatingActionButton);
      expect(
        controller.getVisibility(VisibilityTarget.floatingActionButton),
        1.0,
      );
      expect(
        controller.isVisible(VisibilityTarget.floatingActionButton),
        isTrue,
      );

      controller.toggle(VisibilityTarget.floatingActionButton);
      expect(
        controller.getVisibility(VisibilityTarget.floatingActionButton),
        0.0,
      );

      // showAll & hideAll
      controller.showAll();
      expect(controller.getVisibility(VisibilityTarget.header), 1.0);
      expect(
        controller.getVisibility(VisibilityTarget.floatingActionButton),
        1.0,
      );

      controller.hideAll();
      expect(controller.getVisibility(VisibilityTarget.header), 0.0);
      expect(
        controller.getVisibility(VisibilityTarget.floatingActionButton),
        0.0,
      );

      controller.dispose();
    });

    test(
      'controller lock prevents scroll updates from altering locked targets',
      () {
        final controller = SmartVisibilityController();

        // Lock FAB at visible (1.0)
        controller.lock(VisibilityTarget.floatingActionButton, 1.0);
        expect(
          controller.isLocked(VisibilityTarget.floatingActionButton),
          isTrue,
        );

        // Scroll down past threshold (150px)
        controller.updateScroll(
          150.0,
          direction: ScrollDirection.reverse,
          delta: 10.0,
        );

        // Header is not locked, so it hides (0.0)
        expect(controller.getVisibility(VisibilityTarget.header), 0.0);
        // FAB IS locked, so it stays visible (1.0)
        expect(
          controller.getVisibility(VisibilityTarget.floatingActionButton),
          1.0,
        );

        // Unlock FAB and update scroll
        controller.unlock(VisibilityTarget.floatingActionButton);
        expect(
          controller.isLocked(VisibilityTarget.floatingActionButton),
          isFalse,
        );

        controller.updateScroll(
          150.0,
          direction: ScrollDirection.reverse,
          delta: 10.0,
        );
        expect(
          controller.getVisibility(VisibilityTarget.floatingActionButton),
          0.0,
        );

        controller.dispose();
      },
    );

    test('controller notifies onStateChanged only when boolean visibility state flips', () {
      final stateChanges = <VisibilityTarget, bool>{};
      int callbackCount = 0;

      final controller = SmartVisibilityController(
        onStateChanged: (target, isVisible) {
          stateChanges[target] = isVisible;
          callbackCount++;
        },
      );

      // Change from 1.0 to 0.8 (both > 0.5): should NOT trigger onStateChanged
      controller.setVisibility(VisibilityTarget.header, 0.8);
      expect(callbackCount, 0);

      // Change from 0.8 to 0.2 (crosses 0.5): should trigger onStateChanged(false)
      controller.setVisibility(VisibilityTarget.header, 0.2);
      expect(callbackCount, 1);
      expect(stateChanges[VisibilityTarget.header], isFalse);

      // Change from 0.2 to 0.0: should NOT trigger again
      controller.setVisibility(VisibilityTarget.header, 0.0);
      expect(callbackCount, 1);

      // Change from 0.0 to 1.0: should trigger onStateChanged(true)
      controller.setVisibility(VisibilityTarget.header, 1.0);
      expect(callbackCount, 2);
      expect(stateChanges[VisibilityTarget.header], isTrue);

      controller.dispose();
    });

    test('controller sorts targets by priority', () {
      final config = SmartVisibilityConfig(
        rules: {
          VisibilityTarget.header: const VisibilityRule(
            target: VisibilityTarget.header,
            priority: 10,
          ),
          VisibilityTarget.floatingActionButton: const VisibilityRule(
            target: VisibilityTarget.floatingActionButton,
            priority: 5,
          ),
          VisibilityTarget.statusBar: const VisibilityRule(
            target: VisibilityTarget.statusBar,
            priority: 20,
          ),
        },
      );
      final controller = SmartVisibilityController(config: config);

      final targetsDesc = controller.getTargetsByPriority(ascending: false);
      expect(targetsDesc.first, VisibilityTarget.statusBar);

      final targetsAsc = controller.getTargetsByPriority(ascending: true);
      expect(targetsAsc.first, isNot(VisibilityTarget.statusBar));

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

    testWidgets(
      'ScrollTransform respects reduced-motion accessibility preference',
      (tester) async {
        final progressNotifier = ValueNotifier<double>(1.0);

        await tester.pumpWidget(
          MaterialApp(
            home: MediaQuery(
              data: const MediaQueryData(
                disableAnimations: true,
              ), // User requested reduced motion!
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
      },
    );

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

      var box = tester.widget<Container>(
        find.byKey(const ValueKey('colored_box')),
      );
      expect(box.color, Colors.red);

      // Advance progress
      progressNotifier.value = 1.0;
      await tester.pump();

      box = tester.widget<Container>(find.byKey(const ValueKey('colored_box')));
      expect(box.color, Colors.blue);
    });

    testWidgets(
      'ScrollMorphBuilder switches hit testing and visibility at switchPoint',
      (tester) async {
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
      },
    );
  });

  group('Phase 7: SmartVisibilityTransition Tests', () {
    testWidgets('animates fade and disables pointer hits when hidden', (
      tester,
    ) async {
      final controller = SmartVisibilityController();
      bool tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: SmartVisibilityTransition(
                controller: controller,
                target: VisibilityTarget.floatingActionButton,
                transition: VisibilityTransitionType.fade,
                child: GestureDetector(
                  onTap: () => tapped = true,
                  child: const Text('Visible FAB Target'),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Visible FAB Target'), findsOneWidget);

      // Tap when visible
      await tester.tap(find.text('Visible FAB Target'));
      await tester.pump();
      expect(tapped, isTrue);

      // Hide target
      controller.hide(VisibilityTarget.floatingActionButton);
      await tester.pumpAndSettle();

      final ignoreFinder = find.descendant(
        of: find.byType(SmartVisibilityTransition),
        matching: find.byType(IgnorePointer),
      );
      expect(tester.widget<IgnorePointer>(ignoreFinder).ignoring, isTrue);

      controller.dispose();
    });

    testWidgets('handles scaleAndFade transition cleanly', (tester) async {
      final controller = SmartVisibilityController();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: SmartVisibilityTransition(
                controller: controller,
                target: VisibilityTarget.header,
                transition: VisibilityTransitionType.scaleAndFade,
                child: const Text('Header Widget'),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Header Widget'), findsOneWidget);

      controller.hide(VisibilityTarget.header);
      await tester.pumpAndSettle();

      final scaleWidget = tester.widget<AnimatedScale>(
        find.descendant(
          of: find.byType(SmartVisibilityTransition),
          matching: find.byType(AnimatedScale),
        ),
      );
      expect(scaleWidget.scale, 0.0);

      controller.dispose();
    });

    testWidgets('respects reduced-motion accessibility preference', (
      tester,
    ) async {
      final controller = SmartVisibilityController();

      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: const MediaQueryData(disableAnimations: true),
            child: Scaffold(
              body: Center(
                child: SmartVisibilityTransition(
                  controller: controller,
                  target: VisibilityTarget.bottomNavigationBar,
                  transition: VisibilityTransitionType.slideAndFade,
                  child: const Text('Bottom Nav Bar'),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Bottom Nav Bar'), findsOneWidget);

      // In reduced motion, AnimatedSlide is bypassed in favor of basic Visibility
      expect(
        find.descendant(
          of: find.byType(SmartVisibilityTransition),
          matching: find.byType(AnimatedSlide),
        ),
        findsNothing,
      );

      controller.dispose();
    });
  });
}
