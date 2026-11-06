import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:app_bar_ui/app_bar_ui.dart';

void main() {
  group('Batch 10: Genuinely Different Animated AppBar Experiences (46-50)', () {
    testWidgets('Style 46: InteractiveTimelineScrubberHeaderWidget scrubs timeline and updates milestones', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomScrollView(
              slivers: [
                InteractiveTimelineScrubberHeaderWidget(
                  title: const Text('Roadmap Horizon'),
                  subtitle: const Text('Q1 to Q4 Roadmap'),
                  milestones: const ['Alpha', 'Beta', 'RC', 'GA'],
                  config: const InteractiveTimelineScrubberConfig(
                    expandedHeight: 200.0,
                    collapsedHeight: 60.0,
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
      expect(find.text('Roadmap Horizon'), findsOneWidget);
      expect(find.text('Alpha'), findsWidgets);
      expect(find.text('GA'), findsOneWidget);

      // Scroll down to scrub across milestones
      await tester.drag(find.byType(CustomScrollView), const Offset(0.0, -180.0));
      await tester.pumpAndSettle();

      expect(find.text('Roadmap Horizon'), findsOneWidget);
      expect(find.textContaining('Milestone:'), findsOneWidget);
    });

    testWidgets('Style 47: MultiAnchorDockHeaderWidget glides capsule between anchor positions', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomScrollView(
              slivers: [
                MultiAnchorDockHeaderWidget(
                  title: const Text('Dock Title'),
                  dockContent: const Text('Action Capsule'),
                  expandedBackground: const Center(child: Text('Canvas Background')),
                  config: const MultiAnchorDockConfig(
                    expandedHeight: 220.0,
                    collapsedHeight: 64.0,
                  ),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => ListTile(title: Text('Data Item $index')),
                    childCount: 20,
                  ),
                ),
              ],
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.text('Canvas Background'), findsOneWidget);
      expect(find.text('Action Capsule'), findsOneWidget);

      // Scroll down to collapse into pinned toolbar anchor
      await tester.drag(find.byType(CustomScrollView), const Offset(0.0, -160.0));
      await tester.pumpAndSettle();

      expect(find.text('Action Capsule'), findsOneWidget);
    });

    testWidgets('Style 48: SliverToRailTransformHeaderWidget condenses horizontal items into rail', (tester) async {
      int tappedIndex = -1;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomScrollView(
              slivers: [
                SliverToRailTransformHeaderWidget(
                  title: const Text('Adaptive Console'),
                  items: const [
                    RailNavigationItem(icon: Icons.dashboard, label: 'Dash'),
                    RailNavigationItem(icon: Icons.bar_chart, label: 'Analytics'),
                    RailNavigationItem(icon: Icons.person, label: 'Profile'),
                  ],
                  onItemSelected: (index) => tappedIndex = index,
                  config: const SliverToRailTransformConfig(
                    expandedHeight: 200.0,
                    collapsedHeight: 60.0,
                  ),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => ListTile(title: Text('Feed $index')),
                    childCount: 20,
                  ),
                ),
              ],
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.text('Adaptive Console'), findsOneWidget);
      expect(find.text('Dash'), findsOneWidget);
      expect(find.text('Analytics'), findsOneWidget);

      // Tap an item
      await tester.tap(find.text('Analytics'));
      await tester.pumpAndSettle();
      expect(tappedIndex, equals(1));

      // Scroll down to collapse
      await tester.drag(find.byType(CustomScrollView), const Offset(0.0, -150.0));
      await tester.pumpAndSettle();

      expect(find.byType(SliverToRailTransformHeaderWidget), findsOneWidget);
    });

    testWidgets('Style 49: ContextAwareFocalSwapHeaderWidget swaps hero for contextual toolset', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomScrollView(
              slivers: [
                const ContextAwareFocalSwapHeaderWidget(
                  primaryHero: Text('Primary Portfolio Hero'),
                  contextualToolbar: Text('Operational Search Bar'),
                  config: ContextAwareFocalSwapConfig(
                    expandedHeight: 220.0,
                    collapsedHeight: 64.0,
                    swapThreshold: 80.0,
                  ),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => ListTile(title: Text('Asset $index')),
                    childCount: 20,
                  ),
                ),
              ],
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.text('Primary Portfolio Hero'), findsOneWidget);

      // Scroll past swapThreshold to trigger contextual toolset
      await tester.drag(find.byType(CustomScrollView), const Offset(0.0, -160.0));
      await tester.pumpAndSettle();

      expect(find.text('Operational Search Bar'), findsOneWidget);
    });

    testWidgets('Style 50: SplineCurvedMotionPathHeaderWidget glides avatar along Bézier spline path', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomScrollView(
              slivers: [
                SplineCurvedMotionPathHeaderWidget(
                  avatar: Container(
                    key: const Key('spline-avatar'),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.deepPurple,
                    ),
                  ),
                  title: const Text('Dr. Evelyn Reed'),
                  subtitle: const Text('Chief Neuroscientist'),
                  config: const SplineCurvedMotionPathConfig(
                    expandedHeight: 240.0,
                    collapsedHeight: 64.0,
                    controlPointXOffset: 60.0,
                    controlPointYOffset: -30.0,
                  ),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => ListTile(title: Text('Publication $index')),
                    childCount: 20,
                  ),
                ),
              ],
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.text('Dr. Evelyn Reed'), findsWidgets);
      expect(find.text('Chief Neuroscientist'), findsOneWidget);
      expect(find.byKey(const Key('spline-avatar')), findsOneWidget);

      // Scroll down: avatar moves along spline to pinned toolbar
      await tester.drag(find.byType(CustomScrollView), const Offset(0.0, -180.0));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('spline-avatar')), findsOneWidget);
      expect(find.text('Dr. Evelyn Reed'), findsWidgets);
    });

    testWidgets('Batch 10: Reduced motion mode provides accessible fallbacks without layout crashes', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: const MediaQueryData(disableAnimations: true),
            child: Scaffold(
              body: CustomScrollView(
                slivers: [
                  InteractiveTimelineScrubberHeaderWidget(
                    title: const Text('Accessible Timeline'),
                    milestones: const ['M1', 'M2'],
                    config: const InteractiveTimelineScrubberConfig(expandedHeight: 120.0),
                  ),
                  MultiAnchorDockHeaderWidget(
                    dockContent: const Text('Accessible Dock'),
                    config: const MultiAnchorDockConfig(expandedHeight: 120.0),
                  ),
                  const SliverToRailTransformHeaderWidget(
                    title: Text('Accessible Rail'),
                    config: SliverToRailTransformConfig(expandedHeight: 120.0),
                  ),
                  const ContextAwareFocalSwapHeaderWidget(
                    primaryHero: Text('Accessible Swap Hero'),
                    contextualToolbar: Text('Accessible Swap Bar'),
                    config: ContextAwareFocalSwapConfig(expandedHeight: 120.0),
                  ),
                  SplineCurvedMotionPathHeaderWidget(
                    avatar: const Icon(Icons.star),
                    title: const Text('Accessible Spline'),
                    config: const SplineCurvedMotionPathConfig(expandedHeight: 120.0),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.text('Accessible Timeline'), findsWidgets);
      expect(find.text('Accessible Dock'), findsOneWidget);
      expect(find.text('Accessible Rail'), findsOneWidget);
      expect(find.text('Accessible Swap Hero'), findsOneWidget);
      expect(find.text('Accessible Spline'), findsWidgets);

      // Scroll down across all accessible slivers
      await tester.drag(find.byType(CustomScrollView), const Offset(0.0, -500.0));
      await tester.pumpAndSettle();

      expect(find.text('Accessible Spline'), findsWidgets);
    });
  });
}
