import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:app_bar_ui/app_bar_ui.dart';

void main() {
  group('Complete AppBar Design System — Batch B: Models 5–8 Tests', () {
    testWidgets(
      'Model 5: MultiPanelSplitCurtainHeaderWidget converges lateral panels into fused toolbar on scroll',
      (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: CustomScrollView(
                slivers: [
                  const MultiPanelSplitCurtainHeaderWidget(
                    config: MultiPanelSplitCurtainConfig(
                      leftPanelTitle: 'Enterprise Cluster Alpha',
                      leftPanelSubtitle: 'Multi-Region Routing',
                      splitGap: 40.0,
                      expandedHeight: 180.0,
                      collapsedHeight: 56.0,
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => ListTile(title: Text('Node $index')),
                      childCount: 20,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Expanded state: Brand panel title and subtitle visible
        expect(find.text('Enterprise Cluster Alpha'), findsOneWidget);
        expect(find.text('Multi-Region Routing'), findsOneWidget);

        // Scroll down to converge and fuse into compact toolbar
        await tester.drag(find.byType(CustomScrollView), const Offset(0.0, -160.0));
        await tester.pumpAndSettle();

        // Fused compact state: Title remains visible in fused toolbar
        expect(find.text('Enterprise Cluster Alpha'), findsOneWidget);
        expect(tester.takeException(), isNull);
      },
    );

    testWidgets(
      'Model 6: Spatial3DFlipHeaderWidget rotates 3D perspective to reveal back face toolbar',
      (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: CustomScrollView(
                slivers: [
                  const Spatial3DFlipHeaderWidget(
                    config: Spatial3DFlipConfig(
                      frontTitle: 'Crypto Vault',
                      frontMetricValue: '\$250,000.00',
                      frontMetricLabel: '+28.4% All Time High',
                      backTitle: 'Instant Swap Toolbar',
                      expandedHeight: 200.0,
                      collapsedHeight: 60.0,
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => ListTile(title: Text('Tx $index')),
                      childCount: 20,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Front face rendered at rest
        expect(find.text('Crypto Vault'), findsOneWidget);
        expect(find.text('\$250,000.00'), findsOneWidget);
        expect(find.text('Instant Swap Toolbar'), findsNothing);

        // Scroll down past flip threshold
        await tester.drag(find.byType(CustomScrollView), const Offset(0.0, -180.0));
        await tester.pumpAndSettle();

        // Back face revealed on reverse side
        expect(find.text('Instant Swap Toolbar'), findsOneWidget);
        expect(tester.takeException(), isNull);
      },
    );

    testWidgets(
      'Model 7: VerticalRailTransformHeaderWidget renders destination chips and collapses into icon rail',
      (tester) async {
        int selectedDestIndex = -1;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: CustomScrollView(
                slivers: [
                  VerticalRailTransformHeaderWidget(
                    config: VerticalRailTransformConfig(
                      expandedTitle: 'Engineering Portal',
                      expandedSubtitle: 'Sprint 28 Active',
                      destinations: const [
                        RailNavigationDestination(
                          icon: Icons.code,
                          label: 'Codebase',
                        ),
                        RailNavigationDestination(
                          icon: Icons.bug_report,
                          label: 'Issues',
                        ),
                        RailNavigationDestination(
                          icon: Icons.rocket_launch,
                          label: 'Releases',
                        ),
                      ],
                      onDestinationSelected: (index) => selectedDestIndex = index,
                      expandedHeight: 160.0,
                      collapsedHeight: 56.0,
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => ListTile(title: Text('Issue $index')),
                      childCount: 20,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Expanded hero state: Title, subtitle, and chips visible
        expect(find.text('Engineering Portal'), findsOneWidget);
        expect(find.text('Sprint 28 Active'), findsOneWidget);
        expect(find.text('Codebase'), findsOneWidget);
        expect(find.text('Issues'), findsOneWidget);
        expect(find.text('Releases'), findsOneWidget);

        // Tap on second destination chip ('Issues')
        await tester.tap(find.text('Issues'));
        await tester.pumpAndSettle();
        expect(selectedDestIndex, equals(1));

        // Scroll down to collapse into compact icon rail
        await tester.drag(find.byType(CustomScrollView), const Offset(0.0, -140.0));
        await tester.pumpAndSettle();

        // Compact toolbar keeps title and icon buttons
        expect(find.text('Engineering Portal'), findsOneWidget);
        expect(find.byIcon(Icons.rocket_launch), findsWidgets);
        expect(tester.takeException(), isNull);
      },
    );

    testWidgets(
      'Model 8: RadialDialHeaderWidget positions orbital nodes along trigonometric polar arc',
      (tester) async {
        int tappedNodeIndex = -1;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: CustomScrollView(
                slivers: [
                  RadialDialHeaderWidget(
                    config: RadialDialConfig(
                      dialCenterTitle: 'Solar Exploration',
                      dialCenterSubtitle: 'Select Planet Orbiter',
                      dialItems: [
                        RadialDialItem(
                          icon: Icons.public,
                          label: 'Earth',
                          onTap: () => tappedNodeIndex = 0,
                        ),
                        RadialDialItem(
                          icon: Icons.brightness_low,
                          label: 'Mars',
                          onTap: () => tappedNodeIndex = 1,
                        ),
                        RadialDialItem(
                          icon: Icons.brightness_high,
                          label: 'Jupiter',
                          onTap: () => tappedNodeIndex = 2,
                        ),
                      ],
                      arcRadius: 70.0,
                      expandedHeight: 200.0,
                      collapsedHeight: 56.0,
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => ListTile(title: Text('Telemetry Log $index')),
                      childCount: 20,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Center hub visible
        expect(find.text('Solar Exploration'), findsOneWidget);
        expect(find.text('Select Planet Orbiter'), findsOneWidget);

        // Orbital nodes visible via icons
        expect(find.byIcon(Icons.public), findsOneWidget);
        expect(find.byIcon(Icons.brightness_low), findsOneWidget);
        expect(find.byIcon(Icons.brightness_high), findsOneWidget);

        // Tap on Earth orbital node
        await tester.tap(find.byIcon(Icons.public));
        await tester.pumpAndSettle();
        expect(tappedNodeIndex, equals(0));

        // Scroll to contract arc into compact toolbar
        await tester.drag(find.byType(CustomScrollView), const Offset(0.0, -160.0));
        await tester.pumpAndSettle();

        expect(find.text('Solar Exploration'), findsOneWidget);
        expect(tester.takeException(), isNull);
      },
    );

    testWidgets(
      'Universal Engine Level 1 & Level 2 Customization: AppBarEngine.custom mounts Batch B typed configs',
      (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: AppBarEngine.custom(
              model: AppBarModel.multiPanelSplitCurtain,
              configuration: const MultiPanelSplitCurtainConfig(
                leftPanelTitle: 'Custom Level 2 Curtain',
                splitGap: 24.0,
              ),
              body: const Center(
                child: Text('Custom Body Canvas B'),
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();
        expect(find.text('Custom Level 2 Curtain'), findsOneWidget);
        expect(find.text('Custom Body Canvas B'), findsOneWidget);
      },
    );

    testWidgets(
      'Zero-Leak Model Switching: Dynamically switches between Models 5, 6, 7, and 8 with complete resource isolation',
      (tester) async {
        final controller = AppBarController(initialModel: AppBarModel.multiPanelSplitCurtain);

        await tester.pumpWidget(
          MaterialApp(
            home: AppBarEngine(
              controller: controller,
              model: AppBarModel.multiPanelSplitCurtain,
              body: Container(height: 1200.0),
            ),
          ),
        );

        await tester.pumpAndSettle();
        expect(controller.currentModel, equals(AppBarModel.multiPanelSplitCurtain));
        expect(find.byType(MultiPanelSplitCurtainHeaderWidget), findsOneWidget);

        // Switch to Model 6: spatial3DFlip
        controller.changeModel(AppBarModel.spatial3DFlip);
        await tester.pumpAndSettle();

        expect(controller.currentModel, equals(AppBarModel.spatial3DFlip));
        expect(find.byType(MultiPanelSplitCurtainHeaderWidget), findsNothing);
        expect(find.byType(Spatial3DFlipHeaderWidget), findsOneWidget);

        // Switch to Model 7: verticalRailTransform
        controller.changeModel(AppBarModel.verticalRailTransform);
        await tester.pumpAndSettle();

        expect(controller.currentModel, equals(AppBarModel.verticalRailTransform));
        expect(find.byType(Spatial3DFlipHeaderWidget), findsNothing);
        expect(find.byType(VerticalRailTransformHeaderWidget), findsOneWidget);

        // Switch to Model 8: radialDial
        controller.changeModel(AppBarModel.radialDial);
        await tester.pumpAndSettle();

        expect(controller.currentModel, equals(AppBarModel.radialDial));
        expect(find.byType(VerticalRailTransformHeaderWidget), findsNothing);
        expect(find.byType(RadialDialHeaderWidget), findsOneWidget);
      },
    );

    testWidgets(
      'Batch B: Accessibility reduced motion fallbacks render cleanly without layout exceptions',
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
                        const MultiPanelSplitCurtainHeaderWidget(
                          config: MultiPanelSplitCurtainConfig(
                            leftPanelTitle: 'Accessible Curtain',
                            expandedHeight: 90.0,
                            collapsedHeight: 44.0,
                          ),
                        ),
                        const Spatial3DFlipHeaderWidget(
                          config: Spatial3DFlipConfig(
                            frontTitle: 'Accessible Flip',
                            expandedHeight: 90.0,
                            collapsedHeight: 44.0,
                          ),
                        ),
                        const VerticalRailTransformHeaderWidget(
                          config: VerticalRailTransformConfig(
                            expandedTitle: 'Accessible Rail',
                            expandedHeight: 90.0,
                            collapsedHeight: 44.0,
                          ),
                        ),
                        const RadialDialHeaderWidget(
                          config: RadialDialConfig(
                            dialCenterTitle: 'Accessible Dial',
                            expandedHeight: 90.0,
                            collapsedHeight: 44.0,
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
        expect(find.text('Accessible Curtain'), findsWidgets);
        expect(find.text('Accessible Flip'), findsWidgets);
        expect(find.text('Accessible Rail'), findsWidgets);
        expect(find.text('Accessible Dial'), findsWidgets);

        // Scroll across all slivers under reduced motion
        await tester.drag(find.byType(CustomScrollView), const Offset(0.0, -300.0));
        await tester.pumpAndSettle();

        expect(tester.takeException(), isNull);
      },
    );
  });
}
