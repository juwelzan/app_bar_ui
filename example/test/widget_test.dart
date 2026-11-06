import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:app_bar_ui_example/main.dart';

void main() {
  testWidgets(
    '1. Renders ShowcaseHomeScreen and navigates across all 5 destinations',
    (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1200, 900);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(const ScrollResponsiveDemoApp());
      await tester.pumpAndSettle();

      // Destination 1: Dashboard
      expect(find.text('app_bar_ui Studio'), findsWidgets);
      expect(find.text('The Ultimate Universal Flutter AppBar Design System'), findsOneWidget);
      expect(find.text('Explore Model Categories'), findsOneWidget);

      // Switch to Destination 2: Models (21)
      await tester.tap(find.text('Models (21)'));
      await tester.pumpAndSettle();

      expect(find.textContaining('Model Gallery'), findsWidgets);
      expect(find.text('All Categories (21)'), findsOneWidget);

      // Switch to Destination 3: Studio
      await tester.tap(find.text('Studio'));
      await tester.pumpAndSettle();

      expect(find.text('Playground Inspector'), findsOneWidget);
      expect(find.textContaining('Customization Level'), findsOneWidget);

      // Switch to Destination 4: Lab
      await tester.tap(find.text('Lab'));
      await tester.pumpAndSettle();

      expect(find.text('Responsive & Platform Lab'), findsOneWidget);
      expect(find.text('Small Mobile'), findsOneWidget);
      expect(find.text('Standard Mobile'), findsOneWidget);

      // Switch to Destination 5: Motion
      await tester.tap(find.text('Motion'));
      await tester.pumpAndSettle();

      expect(find.text('Animation Playground'), findsOneWidget);
      expect(find.text('Frame-by-Frame Motion Diagnostics'), findsOneWidget);
    },
  );

  testWidgets('2. Supports theme mode toggle cleanly', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1200, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    await tester.pumpWidget(const ScrollResponsiveDemoApp());
    await tester.pumpAndSettle();

    // Verify initial theme toggle button on NavigationRail
    final toggleFinder = find.byType(IconButton);
    expect(toggleFinder, findsWidgets);

    // Tap theme toggle button
    await tester.tap(toggleFinder.first);
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
  });

  testWidgets('3. ModelGalleryScreen filters models and launches into Studio', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1200, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    await tester.pumpWidget(const ScrollResponsiveDemoApp());
    await tester.pumpAndSettle();

    // Jump to Models tab
    await tester.tap(find.text('Models (21)'));
    await tester.pumpAndSettle();

    // Verify search field exists
    final searchFinder = find.byType(TextField);
    expect(searchFinder, findsOneWidget);

    // Enter query "Island"
    await tester.enterText(searchFinder, 'Island');
    await tester.pumpAndSettle();

    expect(find.text('Floating Dynamic Island'), findsOneWidget);

    // Tap Live Studio on the filtered card
    await tester.tap(find.text('Live Studio'));
    await tester.pumpAndSettle();

    // Should navigate into Studio with Floating Dynamic Island active
    expect(find.text('Playground Inspector'), findsOneWidget);
    expect(find.textContaining('Active Model (Floating Dynamic Island)'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('4. StudioScreen interacts with customization levels cleanly', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1200, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    await tester.pumpWidget(const ScrollResponsiveDemoApp());
    await tester.pumpAndSettle();

    // Switch to Studio tab
    await tester.tap(find.text('Studio'));
    await tester.pumpAndSettle();

    // Tap Preset chip
    final presetChip = find.text('Preset');
    expect(presetChip, findsOneWidget);
    await tester.tap(presetChip);
    await tester.pumpAndSettle();
    expect(find.textContaining('Preset Mode'), findsWidgets);

    // Switch to Custom Builder Mode
    final customChip = find.text('Custom');
    expect(customChip, findsOneWidget);
    await tester.tap(customChip);
    await tester.pumpAndSettle();
    expect(find.textContaining('Level 3 Custom Title Override'), findsWidgets);

    // Switch back to Configured Mode
    final configuredChip = find.text('Configured');
    expect(configuredChip, findsOneWidget);
    await tester.tap(configuredChip);
    await tester.pumpAndSettle();
    expect(find.textContaining('Configured Mode'), findsWidgets);

    expect(tester.takeException(), isNull);
  });

  testWidgets('5. ResponsivePlatformLabScreen switches device viewports without overflow', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1200, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    await tester.pumpWidget(const ScrollResponsiveDemoApp());
    await tester.pumpAndSettle();

    // Switch to Lab tab
    await tester.tap(find.text('Lab'));
    await tester.pumpAndSettle();

    // Switch to Small Mobile
    await tester.tap(find.text('Small Mobile'));
    await tester.pumpAndSettle();

    expect(find.textContaining('320px'), findsWidgets);

    // Toggle orientation icon
    final orientationButton = find.byTooltip('Switch to Landscape');
    if (orientationButton.evaluate().isNotEmpty) {
      await tester.tap(orientationButton);
      await tester.pumpAndSettle();
    }

    expect(tester.takeException(), isNull);
  });

  testWidgets('6. AnimationPlaygroundScreen scrubs progress slider cleanly', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1200, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    await tester.pumpWidget(const ScrollResponsiveDemoApp());
    await tester.pumpAndSettle();

    // Switch to Motion tab
    await tester.tap(find.text('Motion'));
    await tester.pumpAndSettle();

    // Find progress slider
    final sliderFinder = find.byType(Slider);
    expect(sliderFinder, findsOneWidget);

    // Drag slider
    await tester.drag(sliderFinder, const Offset(100, 0));
    await tester.pumpAndSettle();

    // Tap reset button
    final resetFinder = find.byTooltip('Reset to Expanded');
    expect(resetFinder, findsOneWidget);
    await tester.tap(resetFinder);
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
  });
}
