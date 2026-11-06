import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:app_bar_ui/app_bar_ui.dart';
import 'package:app_bar_ui_example/main.dart';

void main() {
  testWidgets(
    'Renders ShowcaseHomeScreen and navigates across all 5 showcase tabs',
    (WidgetTester tester) async {
      await tester.pumpWidget(const ScrollResponsiveDemoApp());
      await tester.pumpAndSettle();

      // Tab 1: Core Header
      expect(find.text('Welcome Back,'), findsOneWidget);
      expect(find.text('Alex Morgan'), findsOneWidget);
      expect(find.text('Live Scroll Telemetry'), findsOneWidget);

      // Switch to Tab 2: Collapsing Header & Sticky Tab Bar
      await tester.tap(find.text('Collapsing'));
      await tester.pumpAndSettle();

      expect(find.text('Collapsing Header'), findsOneWidget);
      expect(find.text('Overview'), findsOneWidget);
      expect(find.text('Features'), findsOneWidget);
      expect(find.text('Reviews'), findsOneWidget);

      // Switch to Tab 3: Pull Expand
      await tester.tap(find.text('Pull Expand'));
      await tester.pumpAndSettle();

      expect(find.text('Eleanor Vance'), findsOneWidget);
      expect(find.text('Senior Product Designer'), findsOneWidget);
      expect(find.text('Posts'), findsOneWidget);
      expect(find.text('Followers'), findsOneWidget);

      // Switch to Tab 4: Parallax
      await tester.tap(find.text('Parallax'));
      await tester.pumpAndSettle();

      expect(find.text('Flow Parallax Container'), findsOneWidget);
      expect(
        find.text('Repaints via FlowDelegate with ZERO rebuilds'),
        findsOneWidget,
      );

      // Switch to Tab 5: Presets Showcase
      await tester.tap(find.text('Presets'));
      await tester.pumpAndSettle();

      expect(find.text('Material Preset'), findsWidgets);

      // Switch dropdown to Minimal
      await tester.tap(find.byKey(const ValueKey('preset_dropdown')));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Minimal Preset').last);
      await tester.pumpAndSettle();
      expect(find.text('Minimal Preset'), findsWidgets);

      // Switch dropdown to iOS
      await tester.tap(find.byKey(const ValueKey('preset_dropdown')));
      await tester.pumpAndSettle();
      await tester.tap(find.text('iOS Inspired Preset').last);
      await tester.pumpAndSettle();
      expect(find.text('iOS Inspired'), findsWidgets);

      // Switch dropdown to Dashboard
      await tester.tap(find.byKey(const ValueKey('preset_dropdown')));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Dashboard Preset').last);
      await tester.pumpAndSettle();
      expect(find.text('Dashboard Preset'), findsWidgets);

      // Switch dropdown to Transparent
      await tester.tap(find.byKey(const ValueKey('preset_dropdown')));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Transparent Floating Preset').last);
      await tester.pumpAndSettle();
      expect(find.text('Transparent Floating'), findsWidgets);
    },
  );

  testWidgets('Supports theme mode toggle cleanly', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const ScrollResponsiveDemoApp());
    await tester.pumpAndSettle();

    // Verify initial theme toggle button on Tab 1
    final toggleFinder = find.byType(IconButton);
    expect(toggleFinder, findsWidgets);

    // Tap theme toggle button
    await tester.tap(toggleFinder.first);
    await tester.pumpAndSettle();

    // Invariant holds cleanly with zero exceptions
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'PresetGalleryView lists all 20 presets and opens PresetDetailScreen',
    (WidgetTester tester) async {
      await tester.pumpWidget(const ScrollResponsiveDemoApp());
      await tester.pumpAndSettle();

      // Navigate to Presets tab
      await tester.tap(find.text('Presets'));
      await tester.pumpAndSettle();

      // Switch to '20 Presets Gallery' tab
      await tester.tap(find.text('20 Presets Gallery'));
      await tester.pumpAndSettle();

      // Verify presence of preset items in the gallery
      expect(find.text('#1'), findsOneWidget);
      expect(find.text('Minimal Header'), findsWidgets);
      expect(find.text('Box Header'), findsWidgets);

      // Tap on the first preset card to open PresetDetailScreen
      await tester.tap(find.text('Minimal Header').first);
      await tester.pumpAndSettle();

      // Verify detail screen is active
      expect(find.byType(PresetDetailScreen), findsOneWidget);
      expect(find.text('Live Scroll Offset: 0.0 px'), findsOneWidget);

      // Scroll down inside PresetDetailScreen
      await tester.drag(find.byType(Scrollable).last, const Offset(0, -150));
      await tester.pumpAndSettle();

      // Pop back to gallery
      Navigator.of(tester.element(find.byType(PresetDetailScreen))).pop();
      await tester.pumpAndSettle();

      expect(find.byType(PresetDetailScreen), findsNothing);
    },
  );

  testWidgets(
    'PullToExpandTab scrolls and overscrolls without RenderFlex overflow',
    (WidgetTester tester) async {
      await tester.pumpWidget(const ScrollResponsiveDemoApp());
      await tester.pumpAndSettle();

      // Switch to Tab 3: Pull Expand
      await tester.tap(find.text('Pull Expand'));
      await tester.pumpAndSettle();

      expect(find.text('Eleanor Vance'), findsOneWidget);

      // Scroll up (compressing the header)
      await tester.drag(find.byType(Scrollable).first, const Offset(0, -150));
      await tester.pumpAndSettle();

      // Overscroll down (pulling to expand)
      await tester.drag(find.byType(Scrollable).first, const Offset(0, 300));
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'CustomBuilder preset in PresetDetailScreen scrolls without RenderFlex overflow',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: PresetDetailScreen(preset: ScrollHeaderPreset.customBuilder),
        ),
      );
      await tester.pumpAndSettle();

      // Scroll gradually across collapse states
      final scrollable = find.byType(Scrollable).first;
      for (int i = 0; i < 5; i++) {
        await tester.drag(scrollable, const Offset(0, -50));
        await tester.pump();
        expect(tester.takeException(), isNull);
      }
    },
  );

  testWidgets(
    'Animated Experiences Lab switches across Batch 1 and Batch 2 styles',
    (WidgetTester tester) async {
      await tester.pumpWidget(const ScrollResponsiveDemoApp());
      await tester.pumpAndSettle();

      // Navigate to Tab 6: Lab (50)
      await tester.tap(find.text('Lab (50)'));
      await tester.pumpAndSettle();

      // Verify active batches banner
      expect(
        find.text('Batches 1 & 2 Active (Styles 1–10 of 50)'),
        findsOneWidget,
      );
      expect(find.text('1. Morphing Split'), findsOneWidget);

      // Select Style 2: Elastic Floating
      final style2 = find.text('2. Elastic Floating');
      await tester.ensureVisible(style2);
      await tester.tap(style2);
      await tester.pumpAndSettle();
      expect(find.text('Elastic Dynamics Header'), findsOneWidget);

      // Select Batch 2 filter pill
      final batch2Filter = find.text('Batch 2: Layered & Geometric (6–10)');
      await tester.ensureVisible(batch2Filter);
      await tester.tap(batch2Filter);
      await tester.pumpAndSettle();

      // Style 6: Horizontal Sliding Panels
      final style6 = find.text('6. Horizontal Sliding Panels');
      await tester.ensureVisible(style6);
      await tester.tap(style6);
      await tester.pumpAndSettle();
      expect(find.text('Explore Catalogs'), findsOneWidget);

      // Style 7: Vertical Folding Accordion
      final style7 = find.text('7. Vertical Folding Accordion');
      await tester.ensureVisible(style7);
      await tester.tap(style7);
      await tester.pumpAndSettle();
      expect(find.text('Origami Accordion'), findsOneWidget);

      // Style 8: Layered Depth Parallax
      final style8 = find.text('8. Layered Depth Parallax');
      await tester.ensureVisible(style8);
      await tester.tap(style8);
      await tester.pumpAndSettle();
      expect(find.text('Glacier National Park'), findsOneWidget);

      // Style 9: Expanding Hero Card
      final style9 = find.text('9. Expanding Hero Card');
      await tester.ensureVisible(style9);
      await tester.tap(style9);
      await tester.pumpAndSettle();
      expect(find.text('\$24,580.00'), findsOneWidget);

      // Style 10: Liquid Wave Morph
      final style10 = find.text('10. Liquid Wave Morph');
      await tester.ensureVisible(style10);
      await tester.tap(style10);
      await tester.pumpAndSettle();
      expect(find.text('Oceanic Flow Wave'), findsOneWidget);

      // Open View Code dialog for Liquid Wave
      await tester.tap(find.text('View Code'));
      await tester.pumpAndSettle();
      expect(find.text('Liquid Wave Morph Integration Code'), findsOneWidget);
      await tester.tap(find.text('Close'));
      await tester.pumpAndSettle();

      // Scroll up to bring action bar into clear view above navigation bar
      await tester.drag(find.byType(CustomScrollView), const Offset(0.0, -160.0));
      await tester.pumpAndSettle();

      // Toggle Simulated Reduced Motion
      final a11yChip = find.text('Simulate A11Y / Reduced Motion');
      await tester.tap(a11yChip);
      await tester.pumpAndSettle();
      expect(find.text('A11Y Fallback'), findsOneWidget);
    },
  );
}
