import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:app_bar_ui/app_bar_ui.dart';

void main() {
  group('Batch 9: Genuinely Different Animated AppBar Experiences (41-45)', () {
    testWidgets('Style 41: PerspectiveVelocityTiltHeaderWidget tilts 3D pitch on scroll velocity', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomScrollView(
              slivers: [
                PerspectiveVelocityTiltHeaderWidget(
                  title: const Text('Quantum Kinetic Grid'),
                  subtitle: const Text('Pitch/Roll Velocity Tilt'),
                  config: const PerspectiveVelocityTiltConfig(
                    expandedHeight: 200.0,
                    collapsedHeight: 60.0,
                    maxTiltAngle: 0.25,
                  ),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => ListTile(title: Text('Data Stream $index')),
                    childCount: 20,
                  ),
                ),
              ],
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.text('Quantum Kinetic Grid'), findsOneWidget);

      // Scroll downward to simulate velocity tilt
      await tester.drag(find.byType(CustomScrollView), const Offset(0.0, -120.0));
      await tester.pump();

      // Header remains pinned and valid
      expect(find.byType(PerspectiveVelocityTiltHeaderWidget), findsOneWidget);
    });

    testWidgets('Style 42: DispersingLetterScatterHeaderWidget scatters glyphs and reconverges', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomScrollView(
              slivers: [
                const DispersingLetterScatterHeaderWidget(
                  titleText: 'QUANTUM',
                  config: DispersingLetterScatterConfig(
                    expandedHeight: 180.0,
                    collapsedHeight: 60.0,
                    scatterRadius: 60.0,
                  ),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => ListTile(title: Text('Particle $index')),
                    childCount: 20,
                  ),
                ),
              ],
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.text('Q'), findsOneWidget);
      expect(find.text('U'), findsNWidgets(2)); // 'U' appears twice in 'QUANTUM'
      expect(find.text('M'), findsOneWidget);

      // Scroll to collapse header and reconverge glyphs
      await tester.drag(find.byType(CustomScrollView), const Offset(0.0, -140.0));
      await tester.pumpAndSettle();

      expect(find.byType(DispersingLetterScatterHeaderWidget), findsOneWidget);
    });

    testWidgets('Style 43: PolygonToRectangleMorphHeaderWidget morphs polygon into rectangle', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomScrollView(
              slivers: [
                const PolygonToRectangleMorphHeaderWidget(
                  polygonContent: Text('Hexagonal Core'),
                  dockedContent: Text('Rectangular Dock'),
                  config: PolygonToRectangleMorphConfig(
                    expandedHeight: 200.0,
                    collapsedHeight: 60.0,
                    polygonSides: 6,
                  ),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => ListTile(title: Text('Crystal $index')),
                    childCount: 20,
                  ),
                ),
              ],
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.text('Hexagonal Core'), findsOneWidget);

      // Scroll down to morph into rectangular dock
      await tester.drag(find.byType(CustomScrollView), const Offset(0.0, -150.0));
      await tester.pumpAndSettle();

      expect(find.text('Rectangular Dock'), findsOneWidget);
    });

    testWidgets('Style 44: DetachedDampedIslandHeaderWidget adjusts margins with damped floating physics', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomScrollView(
              slivers: [
                DetachedDampedIslandHeaderWidget(
                  compactChild: const Text('Floating Island Compact'),
                  config: const DetachedDampedIslandConfig(
                    expandedHeight: 70.0,
                    collapsedHeight: 54.0,
                    expandedHorizontalMargin: 16.0,
                    collapsedHorizontalMargin: 32.0,
                  ),
                  child: const Text('Floating Island Expanded'),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => ListTile(title: Text('Island Item $index')),
                    childCount: 20,
                  ),
                ),
              ],
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.text('Floating Island Expanded'), findsOneWidget);

      // Scroll down to trigger compact floating state
      await tester.drag(find.byType(CustomScrollView), const Offset(0.0, -100.0));
      await tester.pumpAndSettle();

      expect(find.text('Floating Island Compact'), findsOneWidget);
    });

    testWidgets('Style 45: FullBleedHeroScaleHeaderWidget scales media and contracts into pinned bar', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomScrollView(
              slivers: [
                FullBleedHeroScaleHeaderWidget(
                  heroCover: Container(key: const Key('hero-image'), color: Colors.blueGrey),
                  title: const Text('Alpine Horizon'),
                  subtitle: const Text('Summit Peak 4,200m'),
                  config: const FullBleedHeroScaleConfig(
                    expandedHeight: 260.0,
                    collapsedHeight: 60.0,
                  ),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => ListTile(title: Text('Trail Marker $index')),
                    childCount: 20,
                  ),
                ),
              ],
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.text('Alpine Horizon'), findsWidgets);
      expect(find.text('Summit Peak 4,200m'), findsOneWidget);
      expect(find.byKey(const Key('hero-image')), findsOneWidget);

      // Scroll down to collapse hero into compact toolbar
      await tester.drag(find.byType(CustomScrollView), const Offset(0.0, -200.0));
      await tester.pumpAndSettle();

      expect(find.byType(FullBleedHeroScaleHeaderWidget), findsOneWidget);
    });

    testWidgets('Batch 9: Reduced motion mode provides accessible fallbacks without layout crashes', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: const MediaQueryData(disableAnimations: true),
            child: Scaffold(
              body: CustomScrollView(
                slivers: [
                  PerspectiveVelocityTiltHeaderWidget(
                    title: const Text('Accessible Tilt'),
                    config: const PerspectiveVelocityTiltConfig(expandedHeight: 120.0),
                  ),
                  const DispersingLetterScatterHeaderWidget(
                    titleText: 'ACCESS',
                    config: DispersingLetterScatterConfig(expandedHeight: 120.0),
                  ),
                  const PolygonToRectangleMorphHeaderWidget(
                    polygonContent: Text('Accessible Polygon'),
                    dockedContent: Text('Accessible Rect'),
                    config: PolygonToRectangleMorphConfig(expandedHeight: 120.0),
                  ),
                  DetachedDampedIslandHeaderWidget(
                    config: const DetachedDampedIslandConfig(expandedHeight: 60.0),
                    child: const Text('Accessible Island'),
                  ),
                  FullBleedHeroScaleHeaderWidget(
                    heroCover: Container(color: Colors.black),
                    title: const Text('Accessible FullBleed'),
                    config: const FullBleedHeroScaleConfig(expandedHeight: 140.0),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.text('Accessible Tilt'), findsWidgets);
      expect(find.text('A'), findsOneWidget);
      expect(find.text('Accessible Polygon'), findsOneWidget);
      expect(find.text('Accessible Island'), findsOneWidget);

      // Scroll down across all accessible slivers
      await tester.drag(find.byType(CustomScrollView), const Offset(0.0, -500.0));
      await tester.pumpAndSettle();

      expect(find.text('Accessible FullBleed'), findsWidgets);
    });
  });
}
