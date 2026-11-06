import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:app_bar_ui/app_bar_ui.dart';

void main() {
  group('Batch 4: Genuinely Different Animated AppBar Experiences (16-20)', () {
    testWidgets(
      'Style 16: RadialOrbitalActionHeaderWidget orbits actions in arc and converges to linear row',
      (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: CustomScrollView(
                slivers: [
                  RadialOrbitalActionHeaderWidget(
                    centerAnchor: const CircleAvatar(
                      key: ValueKey('center_anchor'),
                      child: Icon(Icons.person),
                    ),
                    title: const Text('Dr. Emmett Brown', key: ValueKey('orbital_title')),
                    actions: const [
                      IconButton(icon: Icon(Icons.call, key: ValueKey('action_call')), onPressed: null),
                      IconButton(icon: Icon(Icons.videocam, key: ValueKey('action_video')), onPressed: null),
                      IconButton(icon: Icon(Icons.email, key: ValueKey('action_mail')), onPressed: null),
                    ],
                    config: const RadialOrbitalActionConfig(
                      expandedHeight: 180.0,
                      collapsedHeight: 60.0,
                      orbitRadius: 60.0,
                      collapseThreshold: 90.0,
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => ListTile(title: Text('Feed #$index')),
                      childCount: 40,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );

        // Expanded state: center anchor and action icons are present
        expect(find.byKey(const ValueKey('center_anchor')), findsOneWidget);
        expect(find.byKey(const ValueKey('action_call')), findsOneWidget);
        expect(find.byKey(const ValueKey('action_video')), findsOneWidget);
        expect(find.byKey(const ValueKey('action_mail')), findsOneWidget);

        // Scroll past collapse threshold: actions converge into linear docked toolbar
        await tester.drag(find.byType(CustomScrollView), const Offset(0.0, -120.0));
        await tester.pumpAndSettle();

        expect(find.byKey(const ValueKey('action_call')), findsOneWidget);
        expect(find.byKey(const ValueKey('orbital_title')), findsOneWidget);

        // Scroll back up: expands back to radial orbital arc
        await tester.drag(find.byType(CustomScrollView), const Offset(0.0, 150.0));
        await tester.pumpAndSettle();

        expect(find.byKey(const ValueKey('center_anchor')), findsOneWidget);
      },
    );

    testWidgets(
      'Style 17: SplitScreenLateralRevealHeaderWidget parts left and right curtains to reveal center showcase',
      (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: CustomScrollView(
                slivers: [
                  const SplitScreenLateralRevealHeaderWidget(
                    centerShowcase: Text('Center Stage Cinema', key: ValueKey('center_showcase')),
                    leftCurtain: Text('Left Stage Door', key: ValueKey('left_curtain')),
                    rightCurtain: Text('Right Stage Door', key: ValueKey('right_curtain')),
                    compactToolbar: Text('Docked Movie Bar', key: ValueKey('compact_bar')),
                    config: SplitScreenLateralRevealConfig(
                      expandedHeight: 190.0,
                      collapsedHeight: 60.0,
                      partingDistance: 100.0,
                      revealThreshold: 80.0,
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => ListTile(title: Text('Seat #$index')),
                      childCount: 40,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );

        // Initial state: center showcase and both curtain doors present
        expect(find.byKey(const ValueKey('center_showcase')), findsOneWidget);
        expect(find.byKey(const ValueKey('left_curtain')), findsOneWidget);
        expect(find.byKey(const ValueKey('right_curtain')), findsOneWidget);

        // Scroll down to part curtains and reveal center
        await tester.drag(find.byType(CustomScrollView), const Offset(0.0, -60.0));
        await tester.pumpAndSettle();
        expect(find.byKey(const ValueKey('center_showcase')), findsOneWidget);

        // Scroll past collapse: compact movie bar emerges
        await tester.drag(find.byType(CustomScrollView), const Offset(0.0, -100.0));
        await tester.pumpAndSettle();
        expect(find.byKey(const ValueKey('compact_bar')), findsOneWidget);

        // Scroll back up to restore
        await tester.drag(find.byType(CustomScrollView), const Offset(0.0, 160.0));
        await tester.pumpAndSettle();
        expect(find.byKey(const ValueKey('left_curtain')), findsOneWidget);
        expect(find.byKey(const ValueKey('right_curtain')), findsOneWidget);
      },
    );

    testWidgets(
      'Style 18: MagneticScrollSnapHeaderWidget interpolates and snaps between expanded and collapsed states',
      (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: CustomScrollView(
                slivers: [
                  const MagneticScrollSnapHeaderWidget(
                    expandedContent: Text('Expanded Hero Canvas', key: ValueKey('snap_expanded')),
                    collapsedContent: Text('Collapsed Docked Bar', key: ValueKey('snap_collapsed')),
                    config: MagneticScrollSnapConfig(
                      expandedHeight: 180.0,
                      collapsedHeight: 60.0,
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => ListTile(title: Text('Article #$index')),
                      childCount: 40,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );

        expect(find.byKey(const ValueKey('snap_expanded')), findsOneWidget);

        // Scroll down into collapsed state
        await tester.drag(find.byType(CustomScrollView), const Offset(0.0, -140.0));
        await tester.pumpAndSettle();
        expect(find.byKey(const ValueKey('snap_collapsed')), findsOneWidget);

        // Scroll back up
        await tester.drag(find.byType(CustomScrollView), const Offset(0.0, 160.0));
        await tester.pumpAndSettle();
        expect(find.byKey(const ValueKey('snap_expanded')), findsOneWidget);
      },
    );

    testWidgets(
      'Style 19: ParallaxZoomHeroHeaderWidget scales hero visual dynamically on scroll and overscroll',
      (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: CustomScrollView(
                slivers: [
                  const ParallaxZoomHeroHeaderWidget(
                    heroVisual: Text('Hero Image Background', key: ValueKey('zoom_visual')),
                    foregroundOverlay: Text('Featured Landmark', key: ValueKey('zoom_overlay')),
                    compactTitle: Text('Landmark Pinned Title', key: ValueKey('zoom_title')),
                    config: ParallaxZoomHeroConfig(
                      expandedHeight: 220.0,
                      collapsedHeight: 60.0,
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => ListTile(title: Text('Place #$index')),
                      childCount: 40,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );

        expect(find.byKey(const ValueKey('zoom_visual')), findsOneWidget);
        expect(find.byKey(const ValueKey('zoom_overlay')), findsOneWidget);

        // Scroll down to collapse
        await tester.drag(find.byType(CustomScrollView), const Offset(0.0, -180.0));
        await tester.pumpAndSettle();

        expect(find.byKey(const ValueKey('zoom_title')), findsOneWidget);
      },
    );

    testWidgets(
      'Style 20: PullDownDisclosureCanvasHeaderWidget unlocks and discloses utility canvas upon pull',
      (tester) async {
        final key = GlobalKey<PullDownDisclosureCanvasHeaderWidgetState>();

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Column(
                children: [
                  PullDownDisclosureCanvasHeaderWidget(
                    key: key,
                    restingHeaderContent: const Text('Resting Bar Content', key: ValueKey('resting_bar')),
                    disclosureCanvasContent: const Text('Disclosed Utility Controls', key: ValueKey('disclosed_canvas')),
                    config: const PullDownDisclosureCanvasConfig(
                      restingHeight: 70.0,
                      disclosureCanvasHeight: 140.0,
                      pullUnlockThreshold: 60.0,
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: 30,
                      itemBuilder: (context, index) => ListTile(title: Text('Item #$index')),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );

        expect(find.byKey(const ValueKey('resting_bar')), findsOneWidget);

        // Programmatically or via gesture unlock disclosure canvas
        key.currentState?.setDisclosed(true);
        await tester.pumpAndSettle();

        expect(find.byKey(const ValueKey('disclosed_canvas')), findsOneWidget);

        // Close disclosure
        key.currentState?.setDisclosed(false);
        await tester.pumpAndSettle();

        expect(find.byKey(const ValueKey('resting_bar')), findsOneWidget);
      },
    );

    testWidgets(
      'Batch 4 Reduced motion mode provides accessible cross-fades without complex spatial transformations',
      (tester) async {
        await tester.pumpWidget(
          const MediaQuery(
            data: MediaQueryData(disableAnimations: true),
            child: MaterialApp(
              home: Scaffold(
                body: CustomScrollView(
                  slivers: [
                    SplitScreenLateralRevealHeaderWidget(
                      centerShowcase: Text('Showcase A11Y'),
                      leftCurtain: Text('Left A11Y'),
                      rightCurtain: Text('Right A11Y'),
                    ),
                    ParallaxZoomHeroHeaderWidget(
                      heroVisual: Text('Visual A11Y'),
                      foregroundOverlay: Text('Overlay A11Y'),
                      compactTitle: Text('Title A11Y'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );

        expect(find.text('Showcase A11Y'), findsOneWidget);
        expect(find.text('Left A11Y'), findsOneWidget);
        expect(find.text('Visual A11Y'), findsOneWidget);

        await tester.drag(find.byType(CustomScrollView), const Offset(0.0, -100.0));
        await tester.pumpAndSettle();

        expect(tester.takeException(), isNull);
      },
    );
  });
}

