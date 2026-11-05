import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:app_bar_ui/app_bar_ui.dart';

void main() {
  group('ScrollResponsiveEngine', () {
    test('creates and owns internal ScrollController when none provided', () {
      final engine = ScrollResponsiveEngine(
        config: const ScrollResponsiveConfig(),
      );

      expect(engine.ownsController, isTrue);
      expect(engine.controller, isNotNull);
      expect(engine.currentOffset, 0.0);
      expect(engine.isAtTop, isTrue);

      engine.dispose();
    });

    test('accepts external ScrollController and does not own it', () {
      final externalController = ScrollController();
      final engine = ScrollResponsiveEngine(
        config: const ScrollResponsiveConfig(),
        customController: externalController,
      );

      expect(engine.ownsController, isFalse);
      expect(engine.controller, same(externalController));

      engine.dispose();
      // External controller should still be functional and undisposed
      expect(() => externalController.addListener(() {}), returnsNormally);
      externalController.dispose();
    });

    test('migrates to new controller without leaks', () {
      final controller1 = ScrollController();
      final controller2 = ScrollController();

      final engine = ScrollResponsiveEngine(
        config: const ScrollResponsiveConfig(),
        customController: controller1,
      );

      expect(engine.controller, same(controller1));

      engine.updateController(controller2);
      expect(engine.controller, same(controller2));

      engine.dispose();
      controller1.dispose();
      controller2.dispose();
    });

    test('calculates independent leading and trailing progress accurately', () {
      final engine = ScrollResponsiveEngine(
        config: const ScrollResponsiveConfig(
          thresholds: ScrollThresholdConfig(
            leadingStartOffset: 20.0,
            leadingEndOffset: 60.0,
            trailingStartOffset: 40.0,
            trailingEndOffset: 100.0,
          ),
        ),
      );

      // At top (offset 0)
      expect(engine.leadingProgress, 0.0);
      expect(engine.trailingProgress, 0.0);

      // At offset 20: leading starts, trailing not started
      engine.updateScrollOffset(20.0);
      expect(engine.leadingProgress, 0.0);
      expect(engine.trailingProgress, 0.0);

      // At offset 40: leading is 50%, trailing starts (0%)
      engine.updateScrollOffset(40.0);
      expect(engine.leadingProgress, closeTo(0.5, 0.001));
      expect(engine.trailingProgress, 0.0);

      // At offset 60: leading is 100%, trailing is 33.3%
      engine.updateScrollOffset(60.0);
      expect(engine.leadingProgress, 1.0);
      expect(engine.trailingProgress, closeTo(0.333, 0.01));

      // At offset 100: both are 100%
      engine.updateScrollOffset(100.0);
      expect(engine.leadingProgress, 1.0);
      expect(engine.trailingProgress, 1.0);

      engine.dispose();
    });

    test(
      'handles negative bounce/overscroll safely without negative progress',
      () {
        final engine = ScrollResponsiveEngine(
          config: const ScrollResponsiveConfig(
            thresholds: ScrollThresholdConfig(
              leadingStartOffset: 20.0,
              leadingEndOffset: 80.0,
            ),
          ),
        );

        // Simulated iOS pull-down negative bounce (-50px)
        engine.updateScrollOffset(-50.0);
        expect(engine.currentOffset, -50.0);
        expect(engine.leadingProgress, 0.0);
        expect(engine.trailingProgress, 0.0);
        expect(engine.isAtTop, isTrue);

        engine.dispose();
      },
    );

    test('detects reverse scroll direction accurately', () {
      final engine = ScrollResponsiveEngine(
        config: const ScrollResponsiveConfig(),
      );

      expect(engine.isReverseScroll, isFalse);

      // Scroll down (0 -> 100)
      engine.updateScrollOffset(100.0);
      expect(engine.isReverseScroll, isFalse);

      // Scroll down further (100 -> 150)
      engine.updateScrollOffset(150.0);
      expect(engine.isReverseScroll, isFalse);

      // Scroll up toward top (150 -> 120)
      engine.updateScrollOffset(120.0);
      expect(engine.isReverseScroll, isTrue);

      engine.dispose();
    });

    testWidgets(
      'dispatches direction changes via handleUserScrollNotification',
      (tester) async {
        await tester.pumpWidget(const SizedBox());
        final element = tester.element(find.byType(SizedBox));

        ScrollDirection? detectedDirection;
        final engine = ScrollResponsiveEngine(
          config: const ScrollResponsiveConfig(),
          onDirectionChanged: (direction) {
            detectedDirection = direction;
          },
        );

        final metrics = FixedScrollMetrics(
          minScrollExtent: 0.0,
          maxScrollExtent: 500.0,
          pixels: 50.0,
          viewportDimension: 300.0,
          axisDirection: AxisDirection.down,
          devicePixelRatio: 1.0,
        );

        engine.handleUserScrollNotification(
          UserScrollNotification(
            metrics: metrics,
            context: element,
            direction: ScrollDirection.reverse,
          ),
        );

        expect(detectedDirection, ScrollDirection.reverse);
        expect(engine.currentDirection, ScrollDirection.reverse);

        engine.dispose();
      },
    );

    testWidgets('supports nested scrolling via handleScrollNotification', (
      tester,
    ) async {
      await tester.pumpWidget(const SizedBox());
      final element = tester.element(find.byType(SizedBox));

      final engine = ScrollResponsiveEngine(
        config: const ScrollResponsiveConfig(
          thresholds: ScrollThresholdConfig(
            leadingStartOffset: 10.0,
            leadingEndOffset: 50.0,
          ),
        ),
      );

      final metrics = FixedScrollMetrics(
        minScrollExtent: 0.0,
        maxScrollExtent: 1000.0,
        pixels: 30.0,
        viewportDimension: 400.0,
        axisDirection: AxisDirection.down,
        devicePixelRatio: 1.0,
      );

      final notification = ScrollUpdateNotification(
        metrics: metrics,
        context: element,
        scrollDelta: 10.0,
      );

      final handled = engine.handleScrollNotification(notification);
      expect(handled, isFalse); // Allows bubbling
      expect(engine.currentOffset, 30.0);
      expect(engine.leadingProgress, closeTo(0.5, 0.001));

      engine.dispose();
    });

    test('resets to initial state cleanly', () async {
      final engine = ScrollResponsiveEngine(
        config: const ScrollResponsiveConfig(),
      );

      engine.updateScrollOffset(150.0);
      expect(engine.leadingProgress, 1.0);
      expect(engine.trailingProgress, 1.0);

      await engine.resetToInitialState(animate: false);
      expect(engine.currentOffset, 0.0);
      expect(engine.leadingProgress, 0.0);
      expect(engine.trailingProgress, 0.0);
      expect(engine.isAtTop, isTrue);

      engine.dispose();
    });

    test('notifiers broadcast updates to listenable subscribers', () {
      final engine = ScrollResponsiveEngine(
        config: const ScrollResponsiveConfig(
          thresholds: ScrollThresholdConfig(
            leadingStartOffset: 20.0,
            leadingEndOffset: 80.0,
          ),
        ),
      );

      double? notifiedLeading;
      ScrollProgressDetails? notifiedDetails;

      engine.leadingProgressNotifier.addListener(() {
        notifiedLeading = engine.leadingProgressNotifier.value;
      });

      engine.progressDetailsNotifier.addListener(() {
        notifiedDetails = engine.progressDetailsNotifier.value;
      });

      engine.updateScrollOffset(50.0);

      expect(notifiedLeading, closeTo(0.5, 0.001));
      expect(notifiedDetails, isNotNull);
      expect(notifiedDetails?.offset, 50.0);
      expect(notifiedDetails?.leadingProgress, closeTo(0.5, 0.001));

      engine.dispose();
    });
  });
}
