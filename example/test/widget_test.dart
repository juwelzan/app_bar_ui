import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:app_bar_ui_example/main.dart';

void main() {
  testWidgets('Renders dashboard screen and handles scroll responsive system', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const ScrollResponsiveDemoApp());
    await tester.pumpAndSettle();

    // Verify initial header content
    expect(find.text('Project Overview'), findsOneWidget);
    expect(find.text('Welcome back, Alex 👋'), findsOneWidget);

    // Verify initial pinned actions rendered
    expect(find.byTooltip('View Profile'), findsOneWidget);
    expect(find.byTooltip('View Notifications'), findsOneWidget);

    // Tap notification action in initial state
    await tester.tap(find.byTooltip('View Notifications'));
    await tester.pumpAndSettle();

    // Verify bottom sheet appeared
    expect(find.text('Notifications (3)'), findsOneWidget);

    // Dismiss bottom sheet by tapping barrier
    await tester.tapAt(const Offset(20, 20));
    await tester.pumpAndSettle();
    expect(find.text('Notifications (3)'), findsNothing);

    // Drag the scroll view upward to scroll down
    await tester.drag(
      find.text('Live Transition Telemetry'),
      const Offset(0.0, -350.0),
    );
    await tester.pumpAndSettle();

    // Header scrolled away
    expect(find.text('Project Overview'), findsNothing);

    // Left transitioned to drawer icon
    expect(find.byTooltip('Open Navigation Drawer'), findsOneWidget);

    // Right transitioned to profile avatar
    expect(find.byTooltip('Quick Profile Access'), findsOneWidget);

    // Tap scrolled leading icon to open drawer
    await tester.tap(find.byTooltip('Open Navigation Drawer'));
    await tester.pumpAndSettle();

    // Verify navigation drawer opened
    expect(find.text('Workspace Menu'), findsOneWidget);

    // Close drawer
    await tester.tapAt(const Offset(350, 200));
    await tester.pumpAndSettle();
    expect(find.text('Workspace Menu'), findsNothing);

    // Scroll back up to the top using the floating action button
    expect(find.byType(FloatingActionButton), findsOneWidget);
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();

    // Verify header restored
    expect(find.text('Project Overview'), findsOneWidget);
    expect(find.byTooltip('View Profile'), findsOneWidget);
    expect(find.byTooltip('View Notifications'), findsOneWidget);
  });

  testWidgets(
    'Supports theme mode switching and config controls in real-time',
    (WidgetTester tester) async {
      await tester.pumpWidget(const ScrollResponsiveDemoApp());
      await tester.pumpAndSettle();

      // Toggle theme mode to Dark
      themeModeNotifier.value = ThemeMode.dark;
      await tester.pumpAndSettle();
      expect(themeModeNotifier.value, ThemeMode.dark);

      // Toggle theme mode to Light
      themeModeNotifier.value = ThemeMode.light;
      await tester.pumpAndSettle();
      expect(themeModeNotifier.value, ThemeMode.light);

      // Reset to system
      themeModeNotifier.value = ThemeMode.system;
      await tester.pumpAndSettle();

      // Verify config controls card exists
      expect(find.text('Interactive Config Controls'), findsOneWidget);
      expect(find.text('Hide Status Bar on Scroll'), findsOneWidget);
      expect(find.text('Fade Animation'), findsOneWidget);
      expect(find.text('Scale Animation'), findsOneWidget);
      expect(find.text('Slide Animation'), findsOneWidget);
    },
  );
}
