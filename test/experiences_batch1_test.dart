import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:app_bar_ui/app_bar_ui.dart';

void main() {
  group('Batch 1: Genuinely Different Animated AppBar Experiences (1-5)', () {
    testWidgets('Style 1: MorphingSplitHeaderWidget diverges and merges on scroll',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomScrollView(
              slivers: [
                const MorphingSplitHeaderWidget(
                  leftModule: Text('Left Navigation'),
                  rightModule: Text('Right Actions'),
                  compactPill: Text('Merged Center Pill'),
                  config: MorphingSplitConfig(
                    expandedHeight: 140.0,
                    collapsedHeight: 60.0,
                    splitDistance: 50.0,
                    mergeThreshold: 0.5,
                  ),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => ListTile(title: Text('Item #$index')),
                    childCount: 40,
                  ),
                ),
              ],
            ),
          ),
        ),
      );

      // Initial expanded state: left and right modules visible
      expect(find.text('Left Navigation'), findsOneWidget);
      expect(find.text('Right Actions'), findsOneWidget);

      // Scroll down past merge threshold: modules fade out and center pill emerges
      await tester.drag(find.byType(CustomScrollView), const Offset(0.0, -120.0));
      await tester.pumpAndSettle();

      expect(find.text('Merged Center Pill'), findsOneWidget);

      // Scroll back up: center pill dissolves, modules restore
      await tester.drag(find.byType(CustomScrollView), const Offset(0.0, 150.0));
      await tester.pumpAndSettle();

      expect(find.text('Left Navigation'), findsOneWidget);
      expect(find.text('Right Actions'), findsOneWidget);
    });

    testWidgets('Style 2: ElasticFloatingHeaderWidget handles overscroll stretch and spring recoil',
        (tester) async {
      final key = GlobalKey();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                ElasticFloatingHeaderWidget(
                  key: key,
                  compactChild: const Text('Compact Capsule Content'),
                  config: const ElasticFloatingConfig(
                    height: 70.0,
                    compactHeight: 50.0,
                    maxOverscrollStretch: 40.0,
                  ),
                  child: const Text('Expanded Island Content'),
                ),
                const Expanded(child: Center(child: Text('Body Content'))),
              ],
            ),
          ),
        ),
      );

      expect(find.text('Expanded Island Content'), findsOneWidget);

      final state = tester.state(find.byKey(key)) as dynamic;

      // Simulate pull overscroll
      state.updateScrollMetrics(scrollOffset: 0.0, overscrollDelta: 50.0);
      await tester.pump();

      // Release gesture -> spring settles
      state.settleElasticSpring(0.0);
      await tester.pumpAndSettle();

      // Forward scroll -> compact state
      state.updateScrollMetrics(scrollOffset: 90.0, overscrollDelta: 0.0);
      await tester.pumpAndSettle();

      expect(find.text('Compact Capsule Content'), findsOneWidget);
    });

    testWidgets('Style 3: DisappearingFloatingActionsHeaderWidget detaches actions into floating pills',
        (tester) async {
      var actionTapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomScrollView(
              slivers: [
                DisappearingFloatingActionsHeaderWidget(
                  title: const Text('Scrolling Article Header'),
                  subtitle: const Text('Published 2 hours ago'),
                  leading: const Icon(Icons.arrow_back),
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.share),
                      onPressed: () => actionTapped = true,
                    ),
                  ],
                  config: const DisappearingFloatingActionsConfig(
                    expandedHeight: 160.0,
                    detachOffset: 40.0,
                    fadeOffset: 70.0,
                  ),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => ListTile(title: Text('Paragraph #$index')),
                    childCount: 40,
                  ),
                ),
              ],
            ),
          ),
        ),
      );

      expect(find.text('Scrolling Article Header'), findsOneWidget);
      expect(find.text('Published 2 hours ago'), findsOneWidget);
      expect(find.byIcon(Icons.share), findsOneWidget);

      // Scroll past fade and detach threshold
      await tester.drag(find.byType(CustomScrollView), const Offset(0.0, -180.0));
      await tester.pumpAndSettle();

      // Title should have scrolled away / faded out
      expect(find.text('Scrolling Article Header'), findsNothing);

      // Detached floating action button remains pinned and interactive
      expect(find.byIcon(Icons.share), findsOneWidget);
      await tester.tap(find.byIcon(Icons.share));
      await tester.pump();
      expect(actionTapped, isTrue);
    });

    testWidgets('Style 4: CircularMorphHeaderWidget morphs from full rect into circular floating avatar',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomScrollView(
              slivers: [
                const CircularMorphHeaderWidget(
                  expandedChild: Text('Rectangular Banner Header'),
                  circularChild: Icon(Icons.person, key: ValueKey('avatar_icon')),
                  config: CircularMorphConfig(
                    expandedHeight: 120.0,
                    targetDiameter: 50.0,
                    anchorAlignment: Alignment.topRight,
                  ),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => ListTile(title: Text('Feed #$index')),
                    childCount: 30,
                  ),
                ),
              ],
            ),
          ),
        ),
      );

      expect(find.text('Rectangular Banner Header'), findsOneWidget);
      expect(find.byKey(const ValueKey('avatar_icon')), findsNothing);

      // Scroll down to complete the circular morph
      await tester.drag(find.byType(CustomScrollView), const Offset(0.0, -150.0));
      await tester.pumpAndSettle();

      expect(find.byKey(const ValueKey('avatar_icon')), findsOneWidget);

      // Scroll up to revert back to rectangular
      await tester.drag(find.byType(CustomScrollView), const Offset(0.0, 180.0));
      await tester.pumpAndSettle();

      expect(find.text('Rectangular Banner Header'), findsOneWidget);
    });

    testWidgets('Style 5: Flip3DHeaderWidget executes 180-degree 3D perspective card flip',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomScrollView(
              slivers: [
                const Flip3DHeaderWidget(
                  frontCard: Text('Front Hero Card', key: ValueKey('front_text')),
                  backToolbar: Text('Back Navigation Bar', key: ValueKey('back_text')),
                  config: Flip3DConfig(
                    expandedHeight: 160.0,
                    collapsedHeight: 60.0,
                    flipAxis: Axis.horizontal,
                  ),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => ListTile(title: Text('Card item #$index')),
                    childCount: 40,
                  ),
                ),
              ],
            ),
          ),
        ),
      );

      // Initial state: front card is visible
      expect(find.byKey(const ValueKey('front_text')), findsOneWidget);

      // Scroll down to flip past 90 degrees to 180 degrees
      await tester.drag(find.byType(CustomScrollView), const Offset(0.0, -140.0));
      await tester.pumpAndSettle();

      // Back toolbar should now be facing user
      expect(find.byKey(const ValueKey('back_text')), findsOneWidget);

      // Scroll back up: returns to front card
      await tester.drag(find.byType(CustomScrollView), const Offset(0.0, 160.0));
      await tester.pumpAndSettle();

      expect(find.byKey(const ValueKey('front_text')), findsOneWidget);
    });

    testWidgets('Reduced motion mode provides accessible cross-fades for 3D and morphing styles',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: const MediaQueryData(disableAnimations: true),
            child: Scaffold(
              body: CustomScrollView(
                slivers: [
                  const Flip3DHeaderWidget(
                    frontCard: Text('Accessible Front'),
                    backToolbar: Text('Accessible Back'),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => ListTile(title: Text('Item $index')),
                      childCount: 20,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      expect(find.text('Accessible Front'), findsOneWidget);

      await tester.drag(find.byType(CustomScrollView), const Offset(0.0, -150.0));
      await tester.pumpAndSettle();

      expect(find.text('Accessible Back'), findsOneWidget);
    });
  });
}
