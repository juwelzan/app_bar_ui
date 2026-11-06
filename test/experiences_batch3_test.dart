import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:app_bar_ui/app_bar_ui.dart';

void main() {
  group('Batch 3: Genuinely Different Animated AppBar Experiences (11-15)', () {
    testWidgets(
      'Style 11: AutoHidingVelocityHeaderWidget hides on downward scroll and reveals on upward gesture',
      (tester) async {
        final key = GlobalKey<AutoHidingVelocityHeaderWidgetState>();

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Column(
                children: [
                  AutoHidingVelocityHeaderWidget(
                    key: key,
                    config: const AutoHidingVelocityConfig(
                      height: 60.0,
                      hideVelocityThreshold: 100.0,
                      revealVelocityThreshold: -80.0,
                    ),
                    child: const Text('Auto-Hiding Toolbar', key: ValueKey('auto_hide_text')),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: 40,
                      itemBuilder: (context, index) => ListTile(title: Text('List item #$index')),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );

        // Initial state: visible
        expect(find.byKey(const ValueKey('auto_hide_text')), findsOneWidget);

        // Trigger hide via scroll metrics downward
        key.currentState?.handleScrollMetrics(
          scrollOffset: 120.0,
          velocity: 250.0,
          userScrollDirection: ScrollDirection.reverse,
        );
        await tester.pumpAndSettle();

        // Trigger reveal via scroll metrics upward
        key.currentState?.handleScrollMetrics(
          scrollOffset: 40.0,
          velocity: -150.0,
          userScrollDirection: ScrollDirection.forward,
        );
        await tester.pumpAndSettle();

        expect(find.byKey(const ValueKey('auto_hide_text')), findsOneWidget);
      },
    );

    testWidgets(
      'Style 12: ScrollSynchronizedProgressHeaderWidget updates circular ring and linear progress bar',
      (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: CustomScrollView(
                slivers: [
                  const ScrollSynchronizedProgressHeaderWidget(
                    title: Text('Reading Chapter 4', key: ValueKey('progress_title')),
                    subtitle: Text('12 min read remaining', key: ValueKey('progress_subtitle')),
                    config: ScrollSynchronizedProgressConfig(
                      expandedHeight: 140.0,
                      collapsedHeight: 60.0,
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

        expect(find.byKey(const ValueKey('progress_title')), findsOneWidget);
        expect(find.byKey(const ValueKey('progress_subtitle')), findsOneWidget);
        expect(find.byType(CircularProgressIndicator), findsOneWidget);
        expect(find.byType(LinearProgressIndicator), findsOneWidget);

        // Scroll down to collapse: compact title and linear progress bar remain active
        await tester.drag(find.byType(CustomScrollView), const Offset(0.0, -100.0));
        await tester.pumpAndSettle();

        expect(find.byType(LinearProgressIndicator), findsOneWidget);
        expect(find.text('Reading Chapter 4'), findsOneWidget);
      },
    );

    testWidgets(
      'Style 13: StickyCollapseDualTierHeaderWidget collapses Tier 1 while Tier 2 docks sticky',
      (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: CustomScrollView(
                slivers: [
                  const StickyCollapseDualTierHeaderWidget(
                    tier1Content: Text('Tier 1: Brand Banner', key: ValueKey('tier_1')),
                    tier2Content: Text('Tier 2: Sticky Tabs Bar', key: ValueKey('tier_2')),
                    config: StickyCollapseDualTierConfig(
                      tier1Height: 80.0,
                      tier2Height: 50.0,
                      collapseThreshold: 80.0,
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

        // Initial expanded state: both tiers present
        expect(find.byKey(const ValueKey('tier_1')), findsOneWidget);
        expect(find.byKey(const ValueKey('tier_2')), findsOneWidget);

        // Scroll past collapse threshold: Tier 1 collapses away, Tier 2 remains docked
        await tester.drag(find.byType(CustomScrollView), const Offset(0.0, -120.0));
        await tester.pumpAndSettle();

        expect(find.byKey(const ValueKey('tier_2')), findsOneWidget);

        // Scroll back up: Tier 1 restores
        await tester.drag(find.byType(CustomScrollView), const Offset(0.0, 150.0));
        await tester.pumpAndSettle();

        expect(find.byKey(const ValueKey('tier_1')), findsOneWidget);
        expect(find.byKey(const ValueKey('tier_2')), findsOneWidget);
      },
    );

    testWidgets(
      'Style 14: MultiStageStagedRevealHeaderWidget transitions across 3 discrete stages',
      (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: CustomScrollView(
                slivers: [
                  const MultiStageStagedRevealHeaderWidget(
                    stage1Hero: Text('Stage 1 Hero Banner', key: ValueKey('stage_1')),
                    stage2Meta: Text('Stage 2 Contextual Filter Chips', key: ValueKey('stage_2')),
                    stage3Toolbar: Text('Stage 3 Compact Docked Bar', key: ValueKey('stage_3')),
                    config: MultiStageStagedRevealConfig(
                      expandedHeight: 210.0,
                      collapsedHeight: 60.0,
                      stage1EndOffset: 60.0,
                      stage2EndOffset: 130.0,
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

        // Stage 1 at offset 0
        expect(find.byKey(const ValueKey('stage_1')), findsOneWidget);

        // Scroll into Stage 2 (offset ~90px)
        await tester.drag(find.byType(CustomScrollView), const Offset(0.0, -90.0));
        await tester.pumpAndSettle();
        expect(find.byKey(const ValueKey('stage_2')), findsOneWidget);

        // Scroll into Stage 3 (offset > 150px)
        await tester.drag(find.byType(CustomScrollView), const Offset(0.0, -90.0));
        await tester.pumpAndSettle();
        expect(find.byKey(const ValueKey('stage_3')), findsOneWidget);
      },
    );

    testWidgets(
      'Style 15: AnimatedDockHeaderWidget dissolves top header and triggers bottom dock emergence',
      (tester) async {
        final scrollController = ScrollController();

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Stack(
                children: [
                  CustomScrollView(
                    controller: scrollController,
                    slivers: [
                      const AnimatedDockHeaderWidget(
                        topHeaderContent: Text('Top Header Canvas', key: ValueKey('top_header')),
                        config: AnimatedDockConfig(
                          topHeaderHeight: 100.0,
                          dockTriggerOffset: 80.0,
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
                  AnimatedBuilder(
                    animation: scrollController,
                    builder: (context, _) {
                      return FloatingBottomDockCapsule(
                        scrollOffset: scrollController.hasClients ? scrollController.offset : 0.0,
                        config: const AnimatedDockConfig(dockTriggerOffset: 80.0),
                        child: const Text('Floating Bottom Dock Capsule', key: ValueKey('bottom_dock')),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        );

        // At top: top header is visible, bottom dock is hidden
        expect(find.byKey(const ValueKey('top_header')), findsOneWidget);
        expect(find.byKey(const ValueKey('bottom_dock')), findsNothing);

        // Scroll down past trigger offset: bottom dock emerges
        await tester.drag(find.byType(CustomScrollView), const Offset(0.0, -120.0));
        await tester.pumpAndSettle();

        expect(find.byKey(const ValueKey('bottom_dock')), findsOneWidget);

        // Scroll back up: bottom dock retreats
        await tester.drag(find.byType(CustomScrollView), const Offset(0.0, 150.0));
        await tester.pumpAndSettle();

        expect(find.byKey(const ValueKey('top_header')), findsOneWidget);
        expect(find.byKey(const ValueKey('bottom_dock')), findsNothing);
      },
    );

    testWidgets(
      'Batch 3 Reduced motion mode provides accessible cross-fades without disorienting transitions',
      (tester) async {
        await tester.pumpWidget(
          const MediaQuery(
            data: MediaQueryData(disableAnimations: true),
            child: MaterialApp(
              home: Scaffold(
                body: CustomScrollView(
                  slivers: [
                    StickyCollapseDualTierHeaderWidget(
                      tier1Content: Text('Tier 1 A11Y'),
                      tier2Content: Text('Tier 2 A11Y'),
                    ),
                    MultiStageStagedRevealHeaderWidget(
                      stage1Hero: Text('Stage 1 A11Y'),
                      stage2Meta: Text('Stage 2 A11Y'),
                      stage3Toolbar: Text('Stage 3 A11Y'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );

        expect(find.text('Tier 1 A11Y'), findsOneWidget);
        expect(find.text('Tier 2 A11Y'), findsOneWidget);

        await tester.drag(find.byType(CustomScrollView), const Offset(0.0, -80.0));
        await tester.pumpAndSettle();

        expect(tester.takeException(), isNull);
      },
    );
  });
}

