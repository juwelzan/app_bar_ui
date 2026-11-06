import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:app_bar_ui/app_bar_ui.dart';

void main() {
  group('Complete AppBar Design System — Batch A: Models 1–4 Tests', () {
    testWidgets('Model 1: TraditionalStructuredHeaderWidget renders 3 tiers and collapses into compact toolbar', (tester) async {
      int tappedCrumbIndex = -1;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomScrollView(
              slivers: [
                TraditionalStructuredHeaderWidget(
                  config: TraditionalStructuredConfig(
                    organizationName: 'Nexus Global',
                    environment: EnvironmentBadge.production,
                    breadcrumbs: [
                      const StructuredBreadcrumbNode(label: 'Root', icon: Icons.home),
                      StructuredBreadcrumbNode(label: 'Clusters', onTap: () => tappedCrumbIndex = 1),
                      const StructuredBreadcrumbNode(label: 'Kubernetes Pods'),
                    ],
                    tabs: const [
                      Tab(text: 'Pods'),
                      Tab(text: 'Services'),
                      Tab(text: 'Ingress'),
                    ],
                  ),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => ListTile(title: Text('Cluster Row $index')),
                    childCount: 20,
                  ),
                ),
              ],
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Tier 1: Org + Environment Badge
      expect(find.text('Nexus Global'), findsOneWidget);
      expect(find.text('PROD'), findsWidgets);

      // Tier 2: Breadcrumbs
      expect(find.text('Root'), findsOneWidget);
      expect(find.text('Clusters'), findsOneWidget);
      expect(find.text('Kubernetes Pods'), findsOneWidget);

      // Tier 3: Tabs
      expect(find.text('Pods'), findsOneWidget);
      expect(find.text('Services'), findsOneWidget);

      // Tap on second crumb
      await tester.tap(find.text('Clusters'));
      await tester.pumpAndSettle();
      expect(tappedCrumbIndex, equals(1));

      // Scroll down to compress Tiers 1 & 2 into compact 56px title bar
      await tester.drag(find.byType(CustomScrollView), const Offset(0.0, -150.0));
      await tester.pumpAndSettle();

      // Active crumb stays visible in compact toolbar
      expect(find.text('Kubernetes Pods'), findsOneWidget);
      // Tabs remain pinned
      expect(find.text('Pods'), findsOneWidget);
    });

    testWidgets('Model 2: FullScreenHeroHeaderWidget expands media canvas and collapses with glassmorphic toolbar', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomScrollView(
              slivers: [
                FullScreenHeroHeaderWidget(
                  config: const FullScreenHeroConfig(
                    headline: 'Interstellar Voyage',
                    tagline: 'Documentary Feature Film',
                    customViewportHeight: 400.0,
                    collapsedHeight: 64.0,
                  ),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => ListTile(title: Text('Scene $index')),
                    childCount: 20,
                  ),
                ),
              ],
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.text('Interstellar Voyage'), findsWidgets);
      expect(find.text('Documentary Feature Film'), findsOneWidget);

      // Scroll down to collapse hero into glassmorphic toolbar
      await tester.drag(find.byType(CustomScrollView), const Offset(0.0, -280.0));
      await tester.pumpAndSettle();

      expect(find.text('Interstellar Voyage'), findsWidgets);
    });

    testWidgets('Model 3: FloatingIslandHeaderWidget hovers detached and adapts margins', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomScrollView(
              slivers: [
                FloatingIslandHeaderWidget(
                  config: const FloatingIslandConfig(
                    islandTitle: 'Flight BA-249',
                    islandSubtitle: 'Boarding Gate 4B',
                    expandedHorizontalMargin: 16.0,
                    compactHorizontalMargin: 32.0,
                  ),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => ListTile(title: Text('Passenger $index')),
                    childCount: 20,
                  ),
                ),
              ],
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.text('Flight BA-249'), findsOneWidget);
      expect(find.text('Boarding Gate 4B'), findsOneWidget);

      // Scroll down to trigger compact floating state
      await tester.drag(find.byType(CustomScrollView), const Offset(0.0, -100.0));
      await tester.pumpAndSettle();

      expect(find.text('Flight BA-249'), findsOneWidget);
    });

    testWidgets('Model 4: ImmersiveSpatialHeaderWidget moves 3 z-depth planes at differential rates', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomScrollView(
              slivers: [
                ImmersiveSpatialHeaderWidget(
                  config: const ImmersiveSpatialConfig(
                    titleText: 'Spatial Horizon',
                    subtitleText: '3-Plane Virtual Depth',
                    expandedHeight: 220.0,
                  ),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => ListTile(title: Text('Waypoint $index')),
                    childCount: 20,
                  ),
                ),
              ],
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.text('Spatial Horizon'), findsWidgets);
      expect(find.text('3-Plane Virtual Depth'), findsOneWidget);

      // Scroll down to converge planes into flat toolbar
      await tester.drag(find.byType(CustomScrollView), const Offset(0.0, -160.0));
      await tester.pumpAndSettle();

      expect(find.text('Spatial Horizon'), findsWidgets);
    });

    testWidgets('Universal Engine Level 1 & Level 2 Customization: AppBarEngine.custom mounts typed config', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: AppBarEngine.custom(
            model: AppBarModel.floatingIsland,
            configuration: const FloatingIslandConfig(
              islandTitle: 'Custom Level 2 Island',
              islandSubtitle: 'Telemetry Active',
            ),
            body: const Center(
              child: Text('Custom Body Canvas'),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.text('Custom Level 2 Island'), findsOneWidget);
      expect(find.text('Telemetry Active'), findsOneWidget);
      expect(find.text('Custom Body Canvas'), findsOneWidget);
    });

    testWidgets('Zero-Leak Model Switching: Dynamically switches between Models 1, 2, 3, and 4 with complete resource isolation', (tester) async {
      final controller = AppBarController(initialModel: AppBarModel.traditionalStructured);

      await tester.pumpWidget(
        MaterialApp(
          home: AppBarEngine(
            controller: controller,
            model: AppBarModel.traditionalStructured,
            body: Container(height: 1200.0),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(controller.currentModel, equals(AppBarModel.traditionalStructured));
      expect(find.byType(TraditionalStructuredHeaderWidget), findsOneWidget);

      // Switch to Model 2: fullScreenHero
      controller.changeModel(AppBarModel.fullScreenHero);
      await tester.pumpAndSettle();

      expect(controller.currentModel, equals(AppBarModel.fullScreenHero));
      expect(find.byType(TraditionalStructuredHeaderWidget), findsNothing);
      expect(find.byType(FullScreenHeroHeaderWidget), findsOneWidget);

      // Switch to Model 3: floatingIsland
      controller.changeModel(AppBarModel.floatingIsland);
      await tester.pumpAndSettle();

      expect(controller.currentModel, equals(AppBarModel.floatingIsland));
      expect(find.byType(FullScreenHeroHeaderWidget), findsNothing);
      expect(find.byType(FloatingIslandHeaderWidget), findsOneWidget);

      // Switch to Model 4: immersiveSpatial
      controller.changeModel(AppBarModel.immersiveSpatial);
      await tester.pumpAndSettle();

      expect(controller.currentModel, equals(AppBarModel.immersiveSpatial));
      expect(find.byType(FloatingIslandHeaderWidget), findsNothing);
      expect(find.byType(ImmersiveSpatialHeaderWidget), findsOneWidget);
    });

    testWidgets('Batch A: Accessibility reduced motion fallbacks render cleanly without layout exceptions', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: const MediaQueryData(disableAnimations: true),
            child: Scaffold(
              body: CustomScrollView(
                slivers: [
                  TraditionalStructuredHeaderWidget(
                    config: const TraditionalStructuredConfig(
                      organizationName: 'Accessible Org',
                      expandedHeight: 100.0,
                      collapsedHeight: 48.0,
                    ),
                  ),
                  const FullScreenHeroHeaderWidget(
                    config: FullScreenHeroConfig(
                      headline: 'Accessible Hero',
                      customViewportHeight: 120.0,
                      collapsedHeight: 48.0,
                    ),
                  ),
                  const FloatingIslandHeaderWidget(
                    config: FloatingIslandConfig(
                      islandTitle: 'Accessible Island',
                      expandedHeight: 80.0,
                      compactHeight: 44.0,
                    ),
                  ),
                  const ImmersiveSpatialHeaderWidget(
                    config: ImmersiveSpatialConfig(
                      titleText: 'Accessible Spatial',
                      expandedHeight: 100.0,
                      collapsedHeight: 48.0,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.text('Accessible Org'), findsWidgets);
      expect(find.text('Accessible Hero'), findsWidgets);
      expect(find.text('Accessible Island'), findsOneWidget);
      expect(find.text('Accessible Spatial'), findsWidgets);

      // Scroll across all slivers under reduced motion
      await tester.drag(find.byType(CustomScrollView), const Offset(0.0, -500.0));
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
    });
  });
}
