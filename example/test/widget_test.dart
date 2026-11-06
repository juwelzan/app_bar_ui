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
    'Animated Experiences Lab switches across Batches 1, 2, 3, and 4 styles',
    (WidgetTester tester) async {
      await tester.pumpWidget(const ScrollResponsiveDemoApp());
      await tester.pumpAndSettle();

      // Navigate to Tab 6: Lab (50)
      await tester.tap(find.text('Lab (50)'));
      await tester.pumpAndSettle();

      // Verify active batches banner
      expect(
        find.text('Batches 1–4 Active (Styles 1–20 of 50)'),
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

      // Select Batch 3 filter pill
      final batch3Filter = find.text('Batch 3 (11–15)');
      await tester.ensureVisible(batch3Filter);
      await tester.tap(batch3Filter);
      await tester.pumpAndSettle();

      // Style 11: Auto-Hiding Velocity Header
      final style11 = find.text('11. Auto-Hiding Velocity Header');
      await tester.ensureVisible(style11);
      await tester.tap(style11);
      await tester.pumpAndSettle();
      expect(find.text('Auto-Hiding Velocity Bar'), findsOneWidget);

      // Select Batch 4 filter pill
      final batch4Filter = find.text('Batch 4 (16–20)');
      await tester.ensureVisible(batch4Filter);
      await tester.tap(batch4Filter);
      await tester.pumpAndSettle();

      // Style 16: Radial Orbital Action Header
      final style16 = find.text('16. Radial / Orbital Action Header');
      await tester.ensureVisible(style16);
      await tester.tap(style16);
      await tester.pumpAndSettle();
      expect(find.text('Dr. Emmett Brown'), findsOneWidget);

      // Style 17: Split-Screen Lateral Reveal Header
      final style17 = find.text('17. Split-Screen Lateral Reveal');
      await tester.ensureVisible(style17);
      await tester.tap(style17);
      await tester.pumpAndSettle();
      expect(find.text('WEST\nWING'), findsOneWidget);

      // Style 18: Magnetic Scroll-Snap Header
      final style18 = find.text('18. Magnetic Scroll-Snap Header');
      await tester.ensureVisible(style18);
      await tester.tap(style18);
      await tester.pumpAndSettle();
      expect(find.text('Magnetic Snap Header'), findsOneWidget);

      // Style 19: Parallax Zoom Hero Header
      final style19 = find.text('19. Parallax Zoom Hero Header');
      await tester.ensureVisible(style19);
      await tester.tap(style19);
      await tester.pumpAndSettle();
      expect(find.text('Yosemite Valley Peak'), findsWidgets);

      // Drag CustomScrollView up so style chips are well above bottom navigation bar
      await tester.drag(find.byType(CustomScrollView), const Offset(0.0, -200.0));
      await tester.pumpAndSettle();

      // Style 20: Pull-Down Disclosure Canvas
      final chip20 = find.byKey(const ValueKey('style_chip_20'));
      await tester.scrollUntilVisible(
        chip20,
        50.0,
        scrollable: find.descendant(
          of: find.byKey(const ValueKey('styles_choice_scroll')),
          matching: find.byType(Scrollable),
        ),
      );
      await tester.tap(chip20);
      await tester.pumpAndSettle();
      expect(find.text('Pull-Down Disclosure Header'), findsOneWidget);

      // Open View Code dialog for Pull-Down Disclosure Canvas
      await tester.tap(find.text('View Code'));
      await tester.pumpAndSettle();
      expect(find.text('Pull-Down Disclosure Canvas Integration Code'), findsOneWidget);
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
