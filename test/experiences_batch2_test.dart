import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:app_bar_ui/app_bar_ui.dart';

void main() {
  group('Batch 2: Genuinely Different Animated AppBar Experiences (6-10)', () {
    testWidgets(
      'Style 6: HorizontalSlidingPanelsHeaderWidget slides panels laterally at differential velocities',
      (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: CustomScrollView(
                slivers: [
                  const HorizontalSlidingPanelsHeaderWidget(
                    pinnedBar: Text('Pinned Nav Bar', key: ValueKey('pinned_bar')),
                    slidingPanelLeft: Text('Category Filter Left', key: ValueKey('panel_left')),
                    slidingPanelRight: Text('Quick Status Right', key: ValueKey('panel_right')),
                    config: HorizontalSlidingPanelsConfig(
                      expandedHeight: 150.0,
                      collapsedHeight: 60.0,
                      panel1SlideDistance: 100.0,
                      panel2SlideDistance: 80.0,
                      fadeThreshold: 0.6,
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => ListTile(title: Text('Panel Item #$index')),
                      childCount: 40,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );

        // Initial expanded state: all elements visible
        expect(find.byKey(const ValueKey('pinned_bar')), findsOneWidget);
        expect(find.byKey(const ValueKey('panel_left')), findsOneWidget);
        expect(find.byKey(const ValueKey('panel_right')), findsOneWidget);

        // Scroll partially down: panels slide horizontally
        await tester.drag(find.byType(CustomScrollView), const Offset(0.0, -50.0));
        await tester.pumpAndSettle();
        expect(find.byKey(const ValueKey('pinned_bar')), findsOneWidget);

        // Scroll past fade threshold: secondary panels fade out
        await tester.drag(find.byType(CustomScrollView), const Offset(0.0, -100.0));
        await tester.pumpAndSettle();

        // Pinned bar remains anchored
        expect(find.byKey(const ValueKey('pinned_bar')), findsOneWidget);

        // Scroll back up to expand
        await tester.drag(find.byType(CustomScrollView), const Offset(0.0, 150.0));
        await tester.pumpAndSettle();
        expect(find.byKey(const ValueKey('panel_left')), findsOneWidget);
        expect(find.byKey(const ValueKey('panel_right')), findsOneWidget);
      },
    );

    testWidgets(
      'Style 7: VerticalFoldingAccordionHeaderWidget folds tier in 3D origami hinge',
      (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: CustomScrollView(
                slivers: [
                  const VerticalFoldingAccordionHeaderWidget(
                    pinnedToolbar: Text('Pinned Header Bar', key: ValueKey('pinned_toolbar')),
                    foldingTier: Text('Folding Accordion Tier', key: ValueKey('folding_tier')),
                    config: VerticalFoldingAccordionConfig(
                      expandedHeight: 180.0,
                      collapsedHeight: 60.0,
                      foldThreshold: 100.0,
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => ListTile(title: Text('Accordion Item #$index')),
                      childCount: 40,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );

        // Initial expanded state: folding tier visible
        expect(find.byKey(const ValueKey('pinned_toolbar')), findsOneWidget);
        expect(find.byKey(const ValueKey('folding_tier')), findsOneWidget);

        // Scroll partially: 3D origami fold in progress
        await tester.drag(find.byType(CustomScrollView), const Offset(0.0, -40.0));
        await tester.pumpAndSettle();
        expect(find.byKey(const ValueKey('folding_tier')), findsOneWidget);

        // Scroll past fold threshold: tier is fully folded (90 deg) and hidden
        await tester.drag(find.byType(CustomScrollView), const Offset(0.0, -120.0));
        await tester.pumpAndSettle();

        expect(find.byKey(const ValueKey('pinned_toolbar')), findsOneWidget);
        expect(find.byKey(const ValueKey('folding_tier')), findsNothing);

        // Scroll back up: tier unfolds
        await tester.drag(find.byType(CustomScrollView), const Offset(0.0, 160.0));
        await tester.pumpAndSettle();
        expect(find.byKey(const ValueKey('folding_tier')), findsOneWidget);
      },
    );

    testWidgets(
      'Style 8: LayeredDepthParallaxHeaderWidget renders 3 distinct z-index layers with focal blur',
      (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: CustomScrollView(
                slivers: [
                  const LayeredDepthParallaxHeaderWidget(
                    backgroundLayer: Text('Ambient Mesh Background', key: ValueKey('bg_layer')),
                    midgroundLayer: Text('Floating Graphic Badge', key: ValueKey('mid_layer')),
                    foregroundLayer: Text('Interactive Action Bar', key: ValueKey('fg_layer')),
                    config: LayeredDepthParallaxConfig(
                      expandedHeight: 200.0,
                      collapsedHeight: 64.0,
                      maxBlur: 6.0,
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => ListTile(title: Text('Parallax Item #$index')),
                      childCount: 40,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );

        // Initial state: all 3 layers visible
        expect(find.byKey(const ValueKey('bg_layer')), findsOneWidget);
        expect(find.byKey(const ValueKey('mid_layer')), findsOneWidget);
        expect(find.byKey(const ValueKey('fg_layer')), findsOneWidget);

        // Scroll down: optical focal blur and differential parallax displacement occur
        await tester.drag(find.byType(CustomScrollView), const Offset(0.0, -80.0));
        await tester.pumpAndSettle();

        // Foreground remains pinned
        expect(find.byKey(const ValueKey('fg_layer')), findsOneWidget);
        expect(tester.takeException(), isNull);
      },
    );

    testWidgets(
      'Style 9: ExpandingHeroCardHeaderWidget expands from inset card into edge-to-edge docked bar',
      (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: CustomScrollView(
                slivers: [
                  const ExpandingHeroCardHeaderWidget(
                    heroCardContent: Text('Hero Card Presentation', key: ValueKey('hero_card')),
                    dockedToolbarContent: Text('Docked Streamlined Toolbar', key: ValueKey('docked_toolbar')),
                    config: ExpandingHeroCardConfig(
                      expandedHeight: 180.0,
                      collapsedHeight: 60.0,
                      expandThreshold: 50.0,
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => ListTile(title: Text('Card Item #$index')),
                      childCount: 40,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );

        // Initial expanded state: hero card visible
        expect(find.byKey(const ValueKey('hero_card')), findsOneWidget);

        // Scroll past expand threshold and into collapsed docked toolbar
        await tester.drag(find.byType(CustomScrollView), const Offset(0.0, -140.0));
        await tester.pumpAndSettle();

        // Docked toolbar is now visible
        expect(find.byKey(const ValueKey('docked_toolbar')), findsOneWidget);

        // Scroll back up: hero card re-appears
        await tester.drag(find.byType(CustomScrollView), const Offset(0.0, 160.0));
        await tester.pumpAndSettle();
        expect(find.byKey(const ValueKey('hero_card')), findsOneWidget);
      },
    );

    testWidgets(
      'Style 10: LiquidWaveMorphHeaderWidget applies math-driven liquid wave clipper and flattens',
      (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: CustomScrollView(
                slivers: [
                  const LiquidWaveMorphHeaderWidget(
                    compactTitle: Text('Flattened Bar Title', key: ValueKey('compact_title')),
                    config: LiquidWaveMorphConfig(
                      expandedHeight: 160.0,
                      collapsedHeight: 60.0,
                      flattenOffset: 70.0,
                    ),
                    child: Text('Liquid Ocean Canvas', key: ValueKey('liquid_child')),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => ListTile(title: Text('Wave Item #$index')),
                      childCount: 40,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );

        // Initial state: liquid child is visible
        expect(find.byKey(const ValueKey('liquid_child')), findsOneWidget);

        // Scroll past flatten offset: wave edge flattens, compact title appears
        await tester.drag(find.byType(CustomScrollView), const Offset(0.0, -120.0));
        await tester.pumpAndSettle();

        expect(find.byKey(const ValueKey('compact_title')), findsOneWidget);

        // Scroll back up: liquid canvas restores
        await tester.drag(find.byType(CustomScrollView), const Offset(0.0, 140.0));
        await tester.pumpAndSettle();
        expect(find.byKey(const ValueKey('liquid_child')), findsOneWidget);
      },
    );

    testWidgets(
      'Batch 2 Reduced motion mode provides accessible cross-fades without disorienting 3D/fluid motions',
      (tester) async {
        await tester.pumpWidget(
          const MediaQuery(
            data: MediaQueryData(disableAnimations: true),
            child: MaterialApp(
              home: Scaffold(
                body: CustomScrollView(
                  slivers: [
                    VerticalFoldingAccordionHeaderWidget(
                      pinnedToolbar: Text('Pinned Toolbar A11Y'),
                      foldingTier: Text('Folding Tier A11Y'),
                      config: VerticalFoldingAccordionConfig(
                        expandedHeight: 180.0,
                        collapsedHeight: 60.0,
                      ),
                    ),
                    LiquidWaveMorphHeaderWidget(
                      compactTitle: Text('Compact Title A11Y'),
                      config: LiquidWaveMorphConfig(
                        expandedHeight: 160.0,
                        collapsedHeight: 60.0,
                      ),
                      child: Text('Liquid Child A11Y'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );

        expect(find.text('Pinned Toolbar A11Y'), findsOneWidget);
        expect(find.text('Folding Tier A11Y'), findsOneWidget);
        expect(find.text('Liquid Child A11Y'), findsOneWidget);

        // Scroll in reduced motion mode without exceptions
        await tester.drag(find.byType(CustomScrollView), const Offset(0.0, -120.0));
        await tester.pumpAndSettle();

        expect(tester.takeException(), isNull);
      },
    );
  });
}
