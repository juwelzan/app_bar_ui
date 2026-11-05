import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:app_bar_ui/app_bar_ui.dart';

void main() {
  group('Phase 10.3: ScrollParallax Tests', () {
    testWidgets('renders child in Scrollable viewport with parallax offset', (
      tester,
    ) async {
      final scrollController = ScrollController();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              controller: scrollController,
              child: Column(
                children: [
                  const SizedBox(height: 200.0),
                  ScrollParallax(
                    height: 250.0,
                    speedFactor: 0.5,
                    child: Container(
                      height: 250.0,
                      color: Colors.teal,
                      child: const Text('Parallax Card'),
                    ),
                  ),
                  const SizedBox(height: 800.0),
                ],
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Parallax Card'), findsOneWidget);

      // Scroll down
      scrollController.jumpTo(150.0);
      await tester.pump();

      expect(find.text('Parallax Card'), findsOneWidget);
    });
  });

  group('Phase 10.3: ScrollSnap Tests', () {
    test('ScrollSnapConfig calculates effective snap points and nearest target', () {
      const config = ScrollSnapConfig(
        snapOffsets: [300.0],
        snapTolerance: 50.0,
        snapToHeader: true,
        headerExpandedOffset: 0.0,
        headerCollapsedOffset: 120.0,
      );

      expect(config.effectiveSnapPoints, [0.0, 120.0, 300.0]);

      // Within tolerance of 120.0
      expect(config.findNearestSnapTarget(105.0), 120.0);
      expect(config.findNearestSnapTarget(135.0), 120.0);

      // Within tolerance of 0.0
      expect(config.findNearestSnapTarget(30.0), 0.0);

      // Outside all tolerances
      expect(config.findNearestSnapTarget(200.0), isNull);
    });

    testWidgets('ScrollSnapEngine animates to snap target when triggered', (
      tester,
    ) async {
      final scrollController = ScrollController();
      final engine = ScrollSnapEngine(
        controller: scrollController,
        config: const ScrollSnapConfig(
          snapOffsets: [0.0, 200.0],
          snapTolerance: 60.0,
          animationDuration: Duration(milliseconds: 100),
        ),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ListView.builder(
              controller: scrollController,
              itemCount: 50,
              itemBuilder: (context, index) => SizedBox(
                height: 50.0,
                child: Text('Row $index'),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Jump near snap point 200.0 (e.g. 180.0)
      scrollController.jumpTo(180.0);
      engine.handleScrollEnd();
      await tester.pumpAndSettle();

      // Controller should have animated to 200.0
      expect(scrollController.offset, closeTo(200.0, 1.0));
    });
  });

  group('Phase 10.3: ScrollProgressIndicator Tests', () {
    testWidgets('renders linear progress indicator and updates with progressListenable', (
      tester,
    ) async {
      final progressNotifier = ValueNotifier<double>(0.0);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: SizedBox(
                width: 200.0,
                child: ScrollProgressIndicator(
                  progressListenable: progressNotifier,
                  height: 4.0,
                  color: Colors.indigo,
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(ScrollProgressIndicator), findsOneWidget);

      // Advance progress to 50%
      progressNotifier.value = 0.5;
      await tester.pump();

      // Advance progress to 100%
      progressNotifier.value = 1.0;
      await tester.pump();

      expect(find.byType(ScrollProgressIndicator), findsOneWidget);
    });

    testWidgets('renders circular progress indicator style', (tester) async {
      final progressNotifier = ValueNotifier<double>(0.75);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: ScrollProgressIndicator(
                type: ProgressIndicatorType.circular,
                progressListenable: progressNotifier,
                size: 40.0,
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final circularIndicator = tester.widget<CircularProgressIndicator>(
        find.byType(CircularProgressIndicator),
      );
      expect(circularIndicator.value, 0.75);
    });
  });

  group('Phase 10.3: ScrollSectionReveal Tests', () {
    testWidgets('reveals child when within viewport and animates opacity', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ListView(
              children: const [
                ScrollSectionReveal(
                  duration: Duration(milliseconds: 100),
                  child: Text('Revealed Card'),
                ),
              ],
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Revealed Card'), findsOneWidget);
      final opacityWidget = tester.widget<Opacity>(
        find.descendant(
          of: find.byType(ScrollSectionReveal),
          matching: find.byType(Opacity),
        ),
      );
      expect(opacityWidget.opacity, 1.0);
    });

    testWidgets('respects reduced-motion accessibility mode', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: MediaQuery(
            data: MediaQueryData(disableAnimations: true),
            child: Scaffold(
              body: ScrollSectionReveal(
                child: Text('Accessible Revealed Section'),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Accessible Revealed Section'), findsOneWidget);
      // No AnimatedBuilder or Opacity animation wrapped inside
      expect(
        find.descendant(
          of: find.byType(ScrollSectionReveal),
          matching: find.byType(Opacity),
        ),
        findsNothing,
      );
    });
  });
}
