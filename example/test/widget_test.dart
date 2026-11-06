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
    'Animated Experiences Lab switches across Batches 1, 2, 3, 4, 5, 6, and 7 styles',
    (WidgetTester tester) async {
      await tester.pumpWidget(const ScrollResponsiveDemoApp());
      await tester.pumpAndSettle();

      // Navigate to Tab 6: Lab (50)
      await tester.tap(find.text('Lab (50)'));
      await tester.pumpAndSettle();

      // Verify active batches banner
      expect(
        find.text('Batches 1–7 Active (Styles 1–35 of 50)'),
        findsOneWidget,
      );
      expect(find.text('1. Morphing Split'), findsOneWidget);

      // Select Batch 2 filter pill
      final batch2Filter = find.text('Batch 2 (6–10)');
      await tester.ensureVisible(batch2Filter);
      await tester.tap(batch2Filter);
      await tester.pumpAndSettle();

      // Style 6: Horizontal Sliding Panels
      final style6 = find.text('6. Horizontal Sliding Panels');
      await tester.ensureVisible(style6);
      await tester.tap(style6);
      await tester.pumpAndSettle();
      expect(find.text('Explore Catalogs'), findsOneWidget);

      // Select Batch 7 filter pill
      final batch7Filter = find.text('Batch 7 (31–35)');
      await Scrollable.ensureVisible(tester.element(batch7Filter), alignment: 0.5);
      await tester.pumpAndSettle();
      await tester.tap(batch7Filter);
      await tester.pumpAndSettle();

      // Style 31: Floating Orbit Header
      final style31 = find.text('31. Floating Orbit Header');
      await Scrollable.ensureVisible(tester.element(style31), alignment: 0.5);
      await tester.pumpAndSettle();
      await tester.tap(style31);
      await tester.pumpAndSettle();
      expect(find.text('Deep Space Observatory'), findsOneWidget);

      // Style 32: Accordion Multi-Tier Header
      final style32 = find.text('32. Accordion Multi-Tier Header');
      await Scrollable.ensureVisible(tester.element(style32), alignment: 0.5);
      await tester.pumpAndSettle();
      await tester.tap(style32);
      await tester.pumpAndSettle();
      expect(find.text('Multi-Slice Operations Hub'), findsOneWidget);

      // Style 33: Lateral Curtain Reveal Header
      final style33 = find.text('33. Lateral Curtain Reveal Header');
      await Scrollable.ensureVisible(tester.element(style33), alignment: 0.5);
      await tester.pumpAndSettle();
      await tester.tap(style33);
      await tester.pumpAndSettle();
      expect(find.text('Grand Philharmonic Auditorium'), findsOneWidget);

      // Style 34: Parallax Zoom Hero Header
      final style34 = find.text('34. Parallax Zoom Hero Header');
      await Scrollable.ensureVisible(tester.element(style34), alignment: 0.5);
      await tester.pumpAndSettle();
      await tester.tap(style34);
      await tester.pumpAndSettle();
      expect(find.text('Matterhorn Extreme Ridge'), findsOneWidget);

      // Style 35: Dynamic Sine Wave Collapse Header
      final style35 = find.text('35. Dynamic Sine Wave Collapse Header');
      await Scrollable.ensureVisible(tester.element(style35), alignment: 0.5);
      await tester.pumpAndSettle();
      await tester.tap(style35);
      await tester.pumpAndSettle();
      expect(find.text('Maritime Tidal Wave Monitor'), findsOneWidget);

      // Open View Code dialog for Dynamic Sine Wave Collapse Header
      final viewCodeBtn = find.text('View Code');
      await Scrollable.ensureVisible(tester.element(viewCodeBtn), alignment: 0.5);
      await tester.pumpAndSettle();
      await tester.tap(viewCodeBtn);
      await tester.pumpAndSettle();
      expect(find.text('Dynamic Sine Wave Collapse Header Integration Code'), findsOneWidget);
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
}
