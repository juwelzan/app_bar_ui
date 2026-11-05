import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:app_bar_ui/app_bar_ui.dart';

void main() {
  group('Phase 10.4: ScrollResponsivePresets Tests', () {
    test('material preset generates valid configuration', () {
      final config = ScrollResponsivePresets.material();
      expect(config.thresholds.leadingStartOffset, 40.0);
      expect(config.thresholds.leadingEndOffset, 120.0);
      expect(config.effectiveStatusBar.enabled, isTrue);
      expect(
        config.effectiveAnimation.transitionType,
        ScrollTransitionType.scrollProgress,
      );
    });

    test('minimal preset disables status bar sync by default', () {
      final config = ScrollResponsivePresets.minimal();
      expect(config.effectiveStatusBar.enabled, isFalse);
      expect(config.thresholds.leadingEndOffset, 70.0);
    });

    test('iosInspired preset uses cubic curve and wider thresholds', () {
      final config = ScrollResponsivePresets.iosInspired();
      expect(config.thresholds.leadingEndOffset, 140.0);
      expect(config.effectiveAnimation.curve, Curves.easeInOutCubic);
    });

    test('collapsingHeader preset accommodates 200px header', () {
      final config = ScrollResponsivePresets.collapsingHeader();
      expect(config.thresholds.leadingEndOffset, 200.0);
    });

    test(
      'transparentFloating preset provides lightweight floating thresholds',
      () {
        final config = ScrollResponsivePresets.transparentFloating();
        expect(config.thresholds.leadingStartOffset, 30.0);
        expect(config.thresholds.leadingEndOffset, 90.0);
      },
    );

    test('dashboard preset generates valid thresholds', () {
      final config = ScrollResponsivePresets.dashboard();
      expect(config.thresholds.leadingEndOffset, 100.0);
    });

    test('custom preset allows overriding individual parameters', () {
      final config = ScrollResponsivePresets.custom(
        leadingStartOffset: 15.0,
        leadingEndOffset: 65.0,
        enableStatusBarSync: false,
      );
      expect(config.thresholds.leadingStartOffset, 15.0);
      expect(config.thresholds.leadingEndOffset, 65.0);
      expect(config.effectiveStatusBar.enabled, isFalse);
    });
  });

  group('Phase 10.4: ScrollResponsiveController Tests', () {
    testWidgets('provides programmatic scroll controls', (tester) async {
      final controller = ScrollResponsiveController(
        headerCollapsedOffset: 150.0,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ListView.builder(
              controller: controller,
              itemCount: 100,
              itemBuilder: (context, index) =>
                  SizedBox(height: 50.0, child: Text('Item $index')),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(controller.offset, 0.0);
      expect(controller.progress, 0.0);

      // Programmatic collapse header
      // ignore: unawaited_futures
      controller.collapseHeader(duration: const Duration(milliseconds: 50));
      await tester.pumpAndSettle();
      expect(controller.offset, closeTo(150.0, 1.0));

      // Programmatic scroll to top / expand header
      // ignore: unawaited_futures
      controller.expandHeader(duration: const Duration(milliseconds: 50));
      await tester.pumpAndSettle();
      expect(controller.offset, 0.0);

      // Programmatic scroll to bottom
      // ignore: unawaited_futures
      controller.scrollToBottom(duration: const Duration(milliseconds: 50));
      await tester.pumpAndSettle();
      expect(controller.offset, controller.position.maxScrollExtent);

      // Programmatic scroll to top
      // ignore: unawaited_futures
      controller.scrollToTop(duration: const Duration(milliseconds: 50));
      await tester.pumpAndSettle();
      expect(controller.offset, 0.0);

      controller.dispose();
    });

    testWidgets(
      'provides telemetry getters, relative scrollBy, and scrollToItem',
      (tester) async {
        final controller = ScrollResponsiveController(
          headerCollapsedOffset: 100.0,
        );

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: ListView.builder(
                controller: controller,
                itemCount: 40,
                itemExtent: 50.0,
                itemBuilder: (context, index) => Text('Item $index'),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(controller.isAtTop, isTrue);
        expect(controller.isHeaderExpanded, isTrue);
        expect(controller.isHeaderCollapsed, isFalse);
        expect(controller.currentOffset, 0.0);
        expect(controller.maxScrollExtent, greaterThan(0.0));

        // scrollBy 120px
        // ignore: unawaited_futures
        controller.scrollBy(120.0, duration: const Duration(milliseconds: 50));
        await tester.pumpAndSettle();

        expect(controller.offset, closeTo(120.0, 1.0));
        expect(controller.isAtTop, isFalse);
        expect(controller.isHeaderCollapsed, isTrue);

        // scrollToItem 5 (5 * 50 = 250px)
        // ignore: unawaited_futures
        controller.scrollToItem(
          5,
          itemExtent: 50.0,
          duration: const Duration(milliseconds: 50),
        );
        await tester.pumpAndSettle();

        expect(controller.offset, closeTo(250.0, 1.0));

        // Test visibility forwarding methods
        controller.hide(VisibilityTarget.header);
        expect(
          controller.visibilityController.isVisible(VisibilityTarget.header),
          isFalse,
        );

        controller.show(VisibilityTarget.header);
        expect(
          controller.visibilityController.isVisible(VisibilityTarget.header),
          isTrue,
        );

        controller.lock(VisibilityTarget.header);
        expect(
          controller.visibilityController.isLocked(VisibilityTarget.header),
          isTrue,
        );

        controller.unlock(VisibilityTarget.header);
        expect(
          controller.visibilityController.isLocked(VisibilityTarget.header),
          isFalse,
        );

        controller.dispose();
      },
    );

    testWidgets('synchronizes with SmartVisibilityController', (tester) async {
      final controller = ScrollResponsiveController();

      expect(
        controller.visibilityController.isVisible(VisibilityTarget.header),
        isTrue,
      );

      controller.setVisibility(VisibilityTarget.header, 0.0);
      expect(
        controller.visibilityController.isVisible(VisibilityTarget.header),
        isFalse,
      );

      controller.dispose();
    });
  });

  group('Phase 10.4: Scaffold Slots & Advanced Integration Tests', () {
    testWidgets(
      'renders stickyTabBar, progressIndicator, scrollAwareFab, and autoHideBottomBar',
      (tester) async {
        final controller = ScrollResponsiveController();

        await tester.pumpWidget(
          MaterialApp(
            home: ScrollResponsiveScaffold(
              controller: controller,
              stickyTabBar: const PreferredSize(
                preferredSize: Size.fromHeight(48.0),
                child: Text('Sticky Tab Header'),
              ),
              progressIndicator: const SizedBox(
                height: 3.0,
                child: Text('Progress Bar'),
              ),
              floatingActionButton: const FloatingActionButton(
                onPressed: null,
                child: Icon(Icons.add),
              ),
              scrollAwareFab: true,
              bottomNavigationBar: const BottomAppBar(
                child: Text('Bottom Navigation'),
              ),
              autoHideBottomBar: true,
              body: Column(
                children: List.generate(
                  30,
                  (i) => SizedBox(height: 60.0, child: Text('Row $i')),
                ),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('Sticky Tab Header'), findsOneWidget);
        expect(find.text('Progress Bar'), findsOneWidget);
        expect(find.text('Bottom Navigation'), findsOneWidget);
        expect(find.byType(ScrollAwareFab), findsOneWidget);
        expect(find.byType(ScrollAutoHideBottomBar), findsOneWidget);

        controller.dispose();
      },
    );
  });

  group('Phase 8: ScrollResponsiveScope & Developer Experience Tests', () {
    testWidgets('provides context.scrollResponsive to any descendant widget', (
      tester,
    ) async {
      final controller = ScrollResponsiveController();
      double? capturedOffset;
      bool? capturedIsAtTop;

      await tester.pumpWidget(
        MaterialApp(
          home: ScrollResponsiveScaffold(
            controller: controller,
            headerTitle: const Text('Title'),
            floatingActionButton: Builder(
              builder: (context) => FloatingActionButton(
                onPressed: () {
                  // ignore: unawaited_futures
                  context.scrollResponsive.scrollToTop(
                    duration: const Duration(milliseconds: 50),
                  );
                },
                child: const Icon(Icons.arrow_upward),
              ),
            ),
            body: Builder(
              builder: (context) {
                // Access via BuildContext extension!
                capturedOffset = context.scrollResponsive.offset;
                capturedIsAtTop = context.scrollResponsive.isAtTop;

                return Column(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        // ignore: unawaited_futures
                        context.scrollResponsive.scrollToBottom(
                          duration: const Duration(milliseconds: 50),
                        );
                      },
                      child: const Text('Scroll to Bottom Button'),
                    ),
                    ...List.generate(
                      40,
                      (i) =>
                          SizedBox(height: 50.0, child: Text('Descendant $i')),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(capturedOffset, 0.0);
      expect(capturedIsAtTop, isTrue);

      // Tap 'Scroll to Bottom Button' inside descendant widget
      await tester.tap(find.text('Scroll to Bottom Button'));
      await tester.pumpAndSettle();

      expect(controller.offset, controller.position.maxScrollExtent);
      expect(controller.isAtTop, isFalse);

      // Tap 'Scroll to Top' FloatingActionButton via context.scrollResponsive
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      expect(controller.offset, 0.0);
      expect(controller.isAtTop, isTrue);

      controller.dispose();
    });

    testWidgets('supports scroll restorationId', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          restorationScopeId: 'test_scope',
          home: ScrollResponsiveScaffold(
            restorationId: 'main_scaffold',
            body: Column(
              children: List.generate(
                30,
                (i) => SizedBox(height: 60.0, child: Text('Row $i')),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(ScrollResponsiveScaffold), findsOneWidget);
      expect(find.byType(CustomScrollView), findsOneWidget);

      final scrollView = tester.widget<CustomScrollView>(
        find.byType(CustomScrollView),
      );
      expect(scrollView.restorationId, 'main_scaffold_scroll');
    });
  });
}
