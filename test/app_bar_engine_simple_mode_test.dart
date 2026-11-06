import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:app_bar_ui/app_bar_ui.dart';

void main() {
  group('Universal AppBarEngine — Simple Mode & Direct Parameter Integration Tests', () {
    testWidgets(
      'Simple Mode: Renders with direct String title and subtitle without any configuration object',
      (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: AppBarEngine(
                model: AppBarModel.floatingIsland,
                title: 'Quick Dashboard',
                subtitle: 'Active Session',
                body: Center(child: Text('Dashboard Content')),
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        expect(find.text('Quick Dashboard'), findsOneWidget);
        expect(find.text('Active Session'), findsOneWidget);
        expect(find.text('Dashboard Content'), findsOneWidget);
        expect(tester.takeException(), isNull);
      },
    );

    testWidgets(
      'Simple Mode: Direct leading widget and onLeadingTap callback trigger cleanly',
      (tester) async {
        bool leadingTapped = false;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: AppBarEngine(
                model: AppBarModel.floatingIsland,
                title: 'Leading Test',
                leading: const Icon(Icons.arrow_back),
                onLeadingTap: () {
                  leadingTapped = true;
                },
                body: const Center(child: Text('Body')),
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        final iconFinder = find.byIcon(Icons.arrow_back);
        expect(iconFinder, findsOneWidget);

        await tester.tap(iconFinder);
        await tester.pumpAndSettle();

        expect(leadingTapped, isTrue);
      },
    );

    testWidgets(
      'Simple Mode: Direct actions list and background color are applied cleanly',
      (tester) async {
        bool notificationTapped = false;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: AppBarEngine(
                model: AppBarModel.traditionalStructured,
                title: 'Production Nexus',
                backgroundColor: Colors.deepPurple,
                actions: [
                  IconButton(
                    icon: const Icon(Icons.notifications),
                    onPressed: () {
                      notificationTapped = true;
                    },
                  ),
                ],
                body: const Center(child: Text('Body')),
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        expect(find.text('Production Nexus'), findsWidgets);
        final actionFinder = find.byIcon(Icons.notifications);
        expect(actionFinder, findsOneWidget);

        await tester.tap(actionFinder);
        await tester.pumpAndSettle();

        expect(notificationTapped, isTrue);
      },
    );

    testWidgets(
      'Advanced Mode: Accepts strongly-typed model config directly in configuration: parameter',
      (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: AppBarEngine(
                model: AppBarModel.floatingIsland,
                configuration: FloatingIslandConfig(
                  islandTitle: 'Flight AG-204',
                  islandSubtitle: 'Gate 42B • On Time',
                  expandedHorizontalMargin: 24.0,
                  compactHorizontalMargin: 32.0,
                ),
                body: Center(child: Text('Flight Tracker')),
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        expect(find.text('Flight AG-204'), findsOneWidget);
        expect(find.text('Gate 42B • On Time'), findsOneWidget);
        expect(find.text('Flight Tracker'), findsOneWidget);
        expect(tester.takeException(), isNull);
      },
    );

    testWidgets(
      'Sliver Mode: AppBarEngine.sliver supports direct title and subtitle inside CustomScrollView',
      (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: CustomScrollView(
                slivers: [
                  const AppBarEngine.sliver(
                    model: AppBarModel.floatingIsland,
                    title: 'Sliver Simple Mode',
                    subtitle: 'Nested inside CustomScrollView',
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => ListTile(title: Text('Item $index')),
                      childCount: 10,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        expect(find.text('Sliver Simple Mode'), findsOneWidget);
        expect(find.text('Nested inside CustomScrollView'), findsOneWidget);
        expect(find.text('Item 0'), findsOneWidget);
        expect(tester.takeException(), isNull);
      },
    );
  });
}

