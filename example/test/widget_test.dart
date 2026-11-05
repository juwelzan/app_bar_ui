import 'package:flutter_test/flutter_test.dart';
import 'package:app_bar_ui_example/main.dart';

void main() {
  testWidgets('Renders dashboard screen and handles scroll responsive system', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const ScrollResponsiveDemoApp());
    await tester.pumpAndSettle();

    // Verify header content
    expect(find.text('Project Overview'), findsOneWidget);
    expect(find.text('Welcome back, Alex 👋'), findsOneWidget);

    // Verify pinned actions rendered
    expect(find.byTooltip('View Profile'), findsOneWidget);
    expect(find.byTooltip('View Notifications'), findsOneWidget);

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
  });
}
