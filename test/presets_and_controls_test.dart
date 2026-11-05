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
      expect(config.effectiveAnimation.transitionType, ScrollTransitionType.scrollProgress);
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

    test('transparentFloating preset provides lightweight floating thresholds', () {
      final config = ScrollResponsivePresets.transparentFloating();
      expect(config.thresholds.leadingStartOffset, 30.0);
      expect(config.thresholds.leadingEndOffset, 90.0);
    });

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
              itemBuilder: (context, index) => SizedBox(
                height: 50.0,
                child: Text('Item $index'),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(controller.offset, 0.0);
      expect(controller.progress, 0.0);

      // Programmatic collapse header
      await controller.collapseHeader(
        duration: const Duration(milliseconds: 50),
      );
      await tester.pumpAndSettle();
      expect(controller.offset, closeTo(150.0, 1.0));

      // Programmatic scroll to top / expand header
      await controller.expandHeader(
        duration: const Duration(milliseconds: 50),
      );
      await tester.pumpAndSettle();
      expect(controller.offset, 0.0);

      // Programmatic scroll to bottom
      await controller.scrollToBottom(
        duration: const Duration(milliseconds: 50),
      );
      await tester.pumpAndSettle();
      expect(controller.offset, controller.position.maxScrollExtent);
      expect(controller.progress, 1.0);

      // Programmatic scroll to top
      await controller.scrollToTop(
        duration: const Duration(milliseconds: 50),
      );
      await tester.pumpAndSettle();
      expect(controller.offset, 0.0);

      controller.dispose();
    });

    testWidgets('synchronizes with SmartVisibilityController', (tester) async {
      final controller = ScrollResponsiveController();

      expect(controller.visibilityController.isVisible(VisibilityTarget.header), isTrue);

      controller.setVisibility(VisibilityTarget.header, 0.0);
      expect(controller.visibilityController.isVisible(VisibilityTarget.header), isFalse);

      controller.dispose();
    });
  });

  group('Phase 10.4: Scaffold Slots & Advanced Integration Tests', () {
    testWidgets('renders stickyTabBar, progressIndicator, scrollAwareFab, and autoHideBottomBar', (
      tester,
    ) async {
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
    });
  });
}

