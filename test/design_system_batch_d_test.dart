import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:app_bar_ui/app_bar_ui.dart';

void main() {
  group('Complete AppBar Design System — Batch D: Models 13–16 Tests', () {
    testWidgets(
      'Model 13: ExpandableControlCenterHeaderWidget renders tile grid and collapses into status icons in pinned toolbar',
      (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: CustomScrollView(
                slivers: [
                  const ExpandableControlCenterHeaderWidget(
                    config: ExpandableControlCenterConfig(
                      hubTitle: 'Control Center Pro',
                      tiles: [
                        ControlCenterTile(
                          title: 'Wi-Fi 6E',
                          subtitle: 'Connected',
                          icon: Icons.wifi,
                          isActive: true,
                        ),
                        ControlCenterTile(
                          title: 'Bluetooth 5.3',
                          subtitle: 'Paired',
                          icon: Icons.bluetooth,
                          isActive: true,
                        ),
                        ControlCenterTile(
                          title: 'Secure Shield',
                          subtitle: 'Active',
                          icon: Icons.shield,
                          isActive: false,
                        ),
                      ],
                      expandedHeight: 220.0,
                      collapsedHeight: 60.0,
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => ListTile(title: Text('Setting $index')),
                      childCount: 20,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Expanded state: Hub title, active count pill, and tiles are visible
        expect(find.text('Control Center Pro'), findsOneWidget);
        expect(find.text('2 Active'), findsOneWidget);
        expect(find.text('Wi-Fi 6E'), findsOneWidget);
        expect(find.text('Bluetooth 5.3'), findsOneWidget);
        expect(find.text('Secure Shield'), findsOneWidget);

        // Scroll down to collapse into compact status toolbar
        await tester.drag(find.byType(CustomScrollView), const Offset(0.0, -180.0));
        await tester.pumpAndSettle();

        // Collapsed state: Compact hub title remains visible
        expect(find.text('Control Center Pro'), findsOneWidget);
        expect(tester.takeException(), isNull);
      },
    );

    testWidgets(
      'Model 14: TimelineScrubberNavHeaderWidget renders milestones track and collapses into milestone indicator',
      (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: CustomScrollView(
                slivers: [
                  const TimelineScrubberNavHeaderWidget(
                    config: TimelineScrubberNavConfig(
                      timelineTitle: 'Engineering Roadmap',
                      nodes: [
                        TimelineNodeItem(
                          label: 'Sprint Planning',
                          date: 'Week 1',
                          icon: Icons.flag,
                          isCompleted: true,
                        ),
                        TimelineNodeItem(
                          label: 'Release Candidate',
                          date: 'Week 3',
                          icon: Icons.rocket,
                          isCompleted: false,
                        ),
                      ],
                      activeNodeIndex: 1,
                      expandedHeight: 190.0,
                      collapsedHeight: 58.0,
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => ListTile(title: Text('Task $index')),
                      childCount: 20,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Expanded state: Roadmap title, date chip, and milestone labels
        expect(find.text('Engineering Roadmap'), findsOneWidget);
        expect(find.text('Week 3'), findsOneWidget);
        expect(find.text('Sprint Planning'), findsOneWidget);
        expect(find.text('Release Candidate'), findsOneWidget);

        // Scroll down to collapse into compact indicator bar
        await tester.drag(find.byType(CustomScrollView), const Offset(0.0, -160.0));
        await tester.pumpAndSettle();

        // Collapsed state: Roadmap title with active milestone label
        expect(find.text('Engineering Roadmap • Release Candidate'), findsOneWidget);
        expect(tester.takeException(), isNull);
      },
    );

    testWidgets(
      'Model 15: SearchSpotlightHeaderWidget renders spotlight search box, suggestions, and morphs into inline query bar',
      (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: CustomScrollView(
                slivers: [
                  const SearchSpotlightHeaderWidget(
                    config: SearchSpotlightConfig(
                      searchPrompt: 'Search design systems...',
                      suggestedPills: ['AppBar', 'Hero'],
                      filterChips: ['All', 'Widgets'],
                      expandedHeight: 180.0,
                      collapsedHeight: 60.0,
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => ListTile(title: Text('Result $index')),
                      childCount: 20,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Expanded state: Spotlight title, search prompt, suggestions, and filter chips
        expect(find.text('Spotlight Search'), findsOneWidget);
        expect(find.text('Search design systems...'), findsOneWidget);
        expect(find.text('AppBar'), findsOneWidget);
        expect(find.text('All'), findsOneWidget);

        // Scroll down to collapse into inline query bar
        await tester.drag(find.byType(CustomScrollView), const Offset(0.0, -150.0));
        await tester.pumpAndSettle();

        // Collapsed state: Compact inline query search bar
        expect(find.text('Search design systems...'), findsOneWidget);
        expect(find.byIcon(Icons.filter_list), findsOneWidget);
        expect(tester.takeException(), isNull);
      },
    );

    testWidgets(
      'Model 16: GestureElasticCanvasHeaderWidget renders elastic canvas, metric, and collapses into pinned bar',
      (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: CustomScrollView(
                slivers: [
                  const GestureElasticCanvasHeaderWidget(
                    config: GestureElasticCanvasConfig(
                      canvasTitle: 'Elastic Horizon Hub',
                      canvasSubtitle: 'Pull down to inspect telemetry',
                      statusMetric: '100% Up',
                      expandedHeight: 210.0,
                      collapsedHeight: 60.0,
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => ListTile(title: Text('Telemetry $index')),
                      childCount: 20,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Expanded state: Canvas title, subtitle, status metric, spring indicator
        expect(find.text('Elastic Horizon Hub'), findsOneWidget);
        expect(find.text('Pull down to inspect telemetry'), findsOneWidget);
        expect(find.text('100% Up'), findsOneWidget);
        expect(find.text('Elastic Pull Gesture Active'), findsOneWidget);

        // Scroll down past collapse threshold
        await tester.drag(find.byType(CustomScrollView), const Offset(0.0, -170.0));
        await tester.pumpAndSettle();

        // Collapsed state: Compact pinned bar with title and refresh button
        expect(find.text('Elastic Horizon Hub'), findsOneWidget);
        expect(find.byIcon(Icons.refresh), findsOneWidget);
        expect(tester.takeException(), isNull);
      },
    );

    testWidgets(
      'Universal Engine: Level 1 and Level 2 instantiation for Batch D models',
      (tester) async {
        // Level 1: Default preset instantiation
        await tester.pumpWidget(
          MaterialApp(
            home: AppBarEngine(
              model: AppBarModel.expandableControlCenter,
              body: const Center(
                child: Text('Control Center Body'),
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();
        expect(find.byType(ExpandableControlCenterHeaderWidget), findsOneWidget);
        expect(find.text('Control Center Body'), findsOneWidget);

        // Level 2: Strongly-typed custom configuration
        await tester.pumpWidget(
          MaterialApp(
            home: AppBarEngine.custom(
              model: AppBarModel.searchSpotlight,
              configuration: const SearchSpotlightConfig(
                searchPrompt: 'Search Level 2 Custom Engine',
              ),
              body: const Center(
                child: Text('Search Spotlight Body'),
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();
        expect(find.text('Search Level 2 Custom Engine'), findsOneWidget);
        expect(find.text('Search Spotlight Body'), findsOneWidget);
      },
    );

    testWidgets(
      'Zero-Leak Model Switching: Dynamically switches between Models 13, 14, 15, and 16 with complete resource isolation',
      (tester) async {
        final controller = AppBarController(initialModel: AppBarModel.expandableControlCenter);

        await tester.pumpWidget(
          MaterialApp(
            home: AppBarEngine(
              controller: controller,
              model: AppBarModel.expandableControlCenter,
              body: Container(height: 1200.0),
            ),
          ),
        );

        await tester.pumpAndSettle();
        expect(controller.currentModel, equals(AppBarModel.expandableControlCenter));
        expect(find.byType(ExpandableControlCenterHeaderWidget), findsOneWidget);

        // Switch to Model 14: timelineScrubberNav
        controller.changeModel(AppBarModel.timelineScrubberNav);
        await tester.pumpAndSettle();

        expect(controller.currentModel, equals(AppBarModel.timelineScrubberNav));
        expect(find.byType(ExpandableControlCenterHeaderWidget), findsNothing);
        expect(find.byType(TimelineScrubberNavHeaderWidget), findsOneWidget);

        // Switch to Model 15: searchSpotlight
        controller.changeModel(AppBarModel.searchSpotlight);
        await tester.pumpAndSettle();

        expect(controller.currentModel, equals(AppBarModel.searchSpotlight));
        expect(find.byType(TimelineScrubberNavHeaderWidget), findsNothing);
        expect(find.byType(SearchSpotlightHeaderWidget), findsOneWidget);

        // Switch to Model 16: gestureElasticCanvas
        controller.changeModel(AppBarModel.gestureElasticCanvas);
        await tester.pumpAndSettle();

        expect(controller.currentModel, equals(AppBarModel.gestureElasticCanvas));
        expect(find.byType(SearchSpotlightHeaderWidget), findsNothing);
        expect(find.byType(GestureElasticCanvasHeaderWidget), findsOneWidget);
      },
    );

    testWidgets(
      'Batch D: Accessibility reduced motion fallbacks render cleanly without layout exceptions',
      (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) {
                return MediaQuery(
                  data: MediaQuery.of(context).copyWith(disableAnimations: true),
                  child: Scaffold(
                    body: CustomScrollView(
                      slivers: [
                        const ExpandableControlCenterHeaderWidget(
                          config: ExpandableControlCenterConfig(
                            hubTitle: 'Accessible Hub',
                            expandedHeight: 180.0,
                            collapsedHeight: 50.0,
                          ),
                        ),
                        const TimelineScrubberNavHeaderWidget(
                          config: TimelineScrubberNavConfig(
                            timelineTitle: 'Accessible Timeline',
                            expandedHeight: 160.0,
                            collapsedHeight: 50.0,
                          ),
                        ),
                        const SearchSpotlightHeaderWidget(
                          config: SearchSpotlightConfig(
                            searchPrompt: 'Accessible Search',
                            expandedHeight: 160.0,
                            collapsedHeight: 50.0,
                          ),
                        ),
                        const GestureElasticCanvasHeaderWidget(
                          config: GestureElasticCanvasConfig(
                            canvasTitle: 'Accessible Elastic',
                            expandedHeight: 160.0,
                            collapsedHeight: 50.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        );

        await tester.pumpAndSettle();
        expect(find.text('Accessible Hub'), findsWidgets);
        expect(find.text('Accessible Timeline'), findsWidgets);
        expect(find.text('Accessible Search'), findsWidgets);
        expect(find.text('Accessible Elastic'), findsWidgets);

        // Scroll across all slivers under reduced motion
        await tester.drag(find.byType(CustomScrollView), const Offset(0.0, -300.0));
        await tester.pumpAndSettle();

        expect(tester.takeException(), isNull);
      },
    );
  });
}

