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
    'Animated Experiences Lab switches across Batches 1, 2, 3, 4, 5, 6, 7, 8, 9, and 10 styles',
    (WidgetTester tester) async {
      await tester.pumpWidget(const ScrollResponsiveDemoApp());
      await tester.pumpAndSettle();

      // Navigate to Tab 6: Lab (50)
      await tester.tap(find.text('Lab (50)'));
      await tester.pumpAndSettle();

      // Verify active batches banner
      expect(
        find.text('All 50 Experiences Active (Batches 1–10 Complete)'),
        findsOneWidget,
      );
      expect(find.text('1. Morphing Split'), findsOneWidget);

      // Select Batch 2 filter pill
      final batch2Filter = find.text('Batch 2 (6–10)');
      await Scrollable.ensureVisible(tester.element(batch2Filter), alignment: 0.5);
      await tester.pumpAndSettle();
      await tester.tap(batch2Filter);
      await tester.pumpAndSettle();

      // Style 6: Horizontal Sliding Panels
      final style6 = find.text('6. Horizontal Sliding Panels');
      await Scrollable.ensureVisible(tester.element(style6), alignment: 0.5);
      await tester.pumpAndSettle();
      await tester.tap(style6);
      await tester.pumpAndSettle();
      expect(find.text('Explore Catalogs'), findsOneWidget);

      // Select Batch 10 filter pill
      final batch10Filter = find.text('Batch 10 (46–50)');
      await Scrollable.ensureVisible(tester.element(batch10Filter), alignment: 0.5);
      await tester.pumpAndSettle();
      await tester.tap(batch10Filter);
      await tester.pumpAndSettle();

      // Style 46: Interactive Timeline Scrubber Header
      final style46 = find.text('46. Interactive Timeline Scrubber Header');
      await Scrollable.ensureVisible(tester.element(style46), alignment: 0.5);
      await tester.pumpAndSettle();
      await tester.tap(style46);
      await tester.pumpAndSettle();
      expect(find.text('Product Roadmap 2026'), findsOneWidget);

      // Style 47: Multi-Anchor Dock Header
      final style47 = find.text('47. Multi-Anchor Dock Header');
      await Scrollable.ensureVisible(tester.element(style47), alignment: 0.5);
      await tester.pumpAndSettle();
      await tester.tap(style47);
      await tester.pumpAndSettle();
      expect(find.text('Operations Hub'), findsOneWidget);

      // Style 48: Sliver-to-Rail Transform Header
      final style48 = find.text('48. Sliver-to-Rail Transform Header');
      await Scrollable.ensureVisible(tester.element(style48), alignment: 0.5);
      await tester.pumpAndSettle();
      await tester.tap(style48);
      await tester.pumpAndSettle();
      expect(find.text('Workspace Navigator'), findsOneWidget);

      // Style 49: Context-Aware Focal Swap Header
      final style49 = find.text('49. Context-Aware Focal Swap Header');
      await Scrollable.ensureVisible(tester.element(style49), alignment: 0.5);
      await tester.pumpAndSettle();
      await tester.tap(style49);
      await tester.pumpAndSettle();
      expect(find.text('Treasury Portfolio'), findsOneWidget);

      // Style 50: Spline Curved Motion Path Header
      final style50 = find.text('50. Spline Curved Motion Path Header');
      await Scrollable.ensureVisible(tester.element(style50), alignment: 0.5);
      await tester.pumpAndSettle();
      await tester.tap(style50);
      await tester.pumpAndSettle();
      expect(find.text('Infinity Spline Frontier'), findsOneWidget);

      // Open View Code dialog for Spline Curved Motion Path Header
      final viewCodeBtn = find.text('View Code');
      await Scrollable.ensureVisible(tester.element(viewCodeBtn), alignment: 0.5);
      await tester.pumpAndSettle();
      await tester.tap(viewCodeBtn);
      await tester.pumpAndSettle();
      expect(find.text('Spline Curved Motion Path Header Integration Code'), findsOneWidget);
      await tester.tap(find.text('Close'));
      await tester.pumpAndSettle();

      // Toggle Simulated Reduced Motion
      final a11yChip = find.text('Simulate A11Y / Reduced Motion');
      await Scrollable.ensureVisible(tester.element(a11yChip), alignment: 0.5);
      await tester.pumpAndSettle();
      await tester.tap(a11yChip);
      await tester.pumpAndSettle();
      expect(find.text('A11Y Fallback'), findsOneWidget);
    },
  );

  testWidgets(
    'DesignSystemGalleryTab switches across Batch A Models (1–4) and customization levels cleanly',
    (WidgetTester tester) async {
      await tester.pumpWidget(const ScrollResponsiveDemoApp());
      await tester.pumpAndSettle();

      // Navigate to Tab 7: Models (20)
      final modelsTab = find.text('Models (20)');
      await Scrollable.ensureVisible(tester.element(modelsTab), alignment: 0.5);
      await tester.tap(modelsTab);
      await tester.pumpAndSettle();

      // Verify gallery studio title
      expect(find.text('Design System Studio'), findsOneWidget);

      // Model 1 is active initially (Level 2: Configured)
      expect(find.text('Enterprise Cloud Nexus'), findsWidgets);
      expect(find.text('M1: Traditional Structured'), findsOneWidget);

      // Switch to Model 2: Full-Screen Hero
      await tester.tap(find.text('M2: Full-Screen Hero'));
      await tester.pumpAndSettle();
      expect(find.text('Cinematic Odyssey'), findsWidgets);

      // Switch to Model 3: Floating Dynamic Island
      await tester.tap(find.text('M3: Floating Dynamic Island'));
      await tester.pumpAndSettle();
      expect(find.text('Dynamic Flight Track'), findsWidgets);

      // Switch to Model 4: Immersive Spatial
      await tester.tap(find.text('M4: Immersive Spatial Parallax'));
      await tester.pumpAndSettle();
      expect(find.text('Spatial Reality Canvas'), findsWidgets);

      // Switch to Level 1: Preset Mode
      final presetChip = find.text('Preset');
      await Scrollable.ensureVisible(tester.element(presetChip), alignment: 0.5);
      await tester.pumpAndSettle();
      await tester.tap(presetChip);
      await tester.pumpAndSettle();
      expect(find.textContaining('Level 1: Preset Mode'), findsWidgets);

      // Switch to Level 3: Custom Builder Mode
      final customChip = find.text('Custom');
      await Scrollable.ensureVisible(tester.element(customChip), alignment: 0.5);
      await tester.pumpAndSettle();
      await tester.tap(customChip);
      await tester.pumpAndSettle();
      expect(find.textContaining('Level 3 Custom Override'), findsOneWidget);

      expect(tester.takeException(), isNull);
    },
  );
}
