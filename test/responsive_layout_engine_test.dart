import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:app_bar_ui/app_bar_ui.dart';

void main() {
  group('Phase 6: Universal Responsive Engine & Optical Slot Tests', () {
    test('1. Breakpoint Categories: Resolves correct categories across the spectrum', () {
      expect(AppBarResponsiveMetrics.resolveCategory(320.0), equals(AppBarScreenCategory.smallMobile));
      expect(AppBarResponsiveMetrics.resolveCategory(359.9), equals(AppBarScreenCategory.smallMobile));
      expect(AppBarResponsiveMetrics.resolveCategory(360.0), equals(AppBarScreenCategory.standardMobile));
      expect(AppBarResponsiveMetrics.resolveCategory(430.0), equals(AppBarScreenCategory.standardMobile));
      expect(AppBarResponsiveMetrics.resolveCategory(599.9), equals(AppBarScreenCategory.standardMobile));
      expect(AppBarResponsiveMetrics.resolveCategory(600.0), equals(AppBarScreenCategory.tablet));
      expect(AppBarResponsiveMetrics.resolveCategory(768.0), equals(AppBarScreenCategory.tablet));
      expect(AppBarResponsiveMetrics.resolveCategory(1023.9), equals(AppBarScreenCategory.tablet));
      expect(AppBarResponsiveMetrics.resolveCategory(1024.0), equals(AppBarScreenCategory.desktop));
      expect(AppBarResponsiveMetrics.resolveCategory(1439.9), equals(AppBarScreenCategory.desktop));
      expect(AppBarResponsiveMetrics.resolveCategory(1440.0), equals(AppBarScreenCategory.ultrawide));
      expect(AppBarResponsiveMetrics.resolveCategory(1920.0), equals(AppBarScreenCategory.ultrawide));
    });

    test('2. Adaptive Metrics: Calculates margins and content limits appropriately', () {
      // Small Mobile
      final small = AppBarResponsiveMetrics.of(
        DummyBuildContext(const Size(320, 600)),
        const BoxConstraints(maxWidth: 320, maxHeight: 600),
      );
      expect(small.category, equals(AppBarScreenCategory.smallMobile));
      expect(small.horizontalMargin, equals(8.0));
      expect(small.actionSpacing, equals(4.0));
      expect(small.isLandscape, isFalse);

      // Ultrawide Desktop
      final ultrawide = AppBarResponsiveMetrics.of(
        DummyBuildContext(const Size(1920, 1080)),
        const BoxConstraints(maxWidth: 1920, maxHeight: 1080),
      );
      expect(ultrawide.category, equals(AppBarScreenCategory.ultrawide));
      expect(ultrawide.horizontalMargin, equals(48.0));
      expect(ultrawide.actionSpacing, equals(16.0));
      expect(ultrawide.maxContentWidth, equals(1440.0));
      expect(ultrawide.isLandscape, isTrue);
    });

    testWidgets('3. Responsive Container: Centers and constrains content on Ultrawide display (1920px)', (tester) async {
      tester.view.physicalSize = const Size(1920, 1080);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AppBarResponsiveContainer(
              child: SizedBox(
                height: 100,
                child: Text('Ultrawide Bounded Content'),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final box = tester.renderObject<RenderBox>(find.text('Ultrawide Bounded Content'));
      expect(box.size.width, lessThanOrEqualTo(1440.0));
    });

    testWidgets('4. Optical Slot: Optical centering without drifting on asymmetric action clusters', (tester) async {
      // Standard mobile test
      tester.view.physicalSize = const Size(375, 812);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 375,
              height: 56,
              child: AppBarOpticalSlot(
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {},
                ),
                title: const Text('Optical Center'),
                subtitle: const Text('Active Subtitle'),
                // Asymmetric 2 action buttons on right:
                actions: [
                  IconButton(icon: const Icon(Icons.search), onPressed: () {}),
                  IconButton(icon: const Icon(Icons.more_vert), onPressed: () {}),
                ],
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Optical Center'), findsOneWidget);
      expect(find.text('Active Subtitle'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('5. Optical Slot on 320px Small Mobile with 2.0x Text Scale: Zero overflow', (tester) async {
      tester.view.physicalSize = const Size(320, 568);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: const MediaQueryData(
              size: Size(320, 568),
              textScaler: TextScaler.linear(2.0),
            ),
            child: Scaffold(
              body: SizedBox(
                width: 320,
                height: 64,
                child: AppBarOpticalSlot(
                  leading: const Icon(Icons.menu),
                  title: const Text('Very Long Title Exceeding Width Gracefully'),
                  actions: const [
                    Icon(Icons.tune),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Very Long Title Exceeding Width Gracefully'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });
}

class DummyBuildContext implements BuildContext {
  DummyBuildContext(this.size);
  @override
  final Size size;

  @override
  dynamic noSuchMethod(Invocation invocation) {
    if (invocation.memberName == #dependOnInheritedWidgetOfExactType) {
      return null;
    }
    return super.noSuchMethod(invocation);
  }
}
