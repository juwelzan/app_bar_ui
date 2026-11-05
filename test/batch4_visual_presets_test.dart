import 'package:app_bar_ui/app_bar_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Batch 4 — Visual & Creative Presets (36–40)', () {
    test('Preset metadata and isSliver contracts are correctly configured', () {
      expect(ScrollHeaderPreset.shapeMorphing.label, 'Shape-Morphing Header');
      expect(ScrollHeaderPreset.shapeMorphing.description, isNotEmpty);

      expect(
        ScrollHeaderPreset.animatedGradient.label,
        'Animated Gradient Header',
      );
      expect(ScrollHeaderPreset.animatedGradient.description, isNotEmpty);

      expect(
        ScrollHeaderPreset.colorTransition.label,
        'Color-Transition Header',
      );
      expect(ScrollHeaderPreset.colorTransition.description, isNotEmpty);

      expect(ScrollHeaderPreset.illustrated.label, 'Illustrated Header');
      expect(ScrollHeaderPreset.illustrated.description, isNotEmpty);

      expect(ScrollHeaderPreset.edgeToEdge.label, 'Edge-to-Edge Header');
      expect(ScrollHeaderPreset.edgeToEdge.description, isNotEmpty);

      // Verify isSliver contract
      expect(const ScrollHeader.shapeMorphing().isSliver, isTrue);
      expect(const ScrollHeader.animatedGradient().isSliver, isFalse);
      expect(const ScrollHeader.colorTransition().isSliver, isTrue);
      expect(
        const ScrollHeader.illustrated(illustration: SizedBox()).isSliver,
        isTrue,
      );
      expect(const ScrollHeader.edgeToEdge().isSliver, isFalse);
    });

    testWidgets('Preset 36: shapeMorphing renders and morphs on scroll', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomScrollView(
              slivers: [
                ScrollHeader.shapeMorphing(
                  title: const Text('Morphing Title'),
                  subtitle: const Text('Morphing Subtitle'),
                  initialBorderRadius: BorderRadius.circular(24.0),
                  scrolledBorderRadius: BorderRadius.zero,
                  expandedHeight: 120.0,
                  leading: const Icon(Icons.arrow_back),
                  actions: const [Icon(Icons.more_vert)],
                ),
                SliverToBoxAdapter(
                  child: Container(height: 1000.0, color: Colors.blueGrey),
                ),
              ],
            ),
          ),
        ),
      );

      expect(find.text('Morphing Title'), findsOneWidget);
      expect(find.text('Morphing Subtitle'), findsOneWidget);
      expect(find.byIcon(Icons.arrow_back), findsOneWidget);
      expect(find.byIcon(Icons.more_vert), findsOneWidget);

      // Scroll down to trigger shape morph
      await tester.drag(find.byType(CustomScrollView), const Offset(0, -60.0));
      await tester.pumpAndSettle();

      expect(find.text('Morphing Title'), findsOneWidget);
    });

    testWidgets('Preset 37: animatedGradient renders and animates gradient', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ScrollHeader.animatedGradient(
              title: const Text('Gradient Title'),
              subtitle: const Text('Gradient Subtitle'),
              animatedColors: const [Colors.purple, Colors.blue, Colors.teal],
              leading: const Icon(Icons.arrow_back),
              actions: const [Icon(Icons.palette)],
            ),
          ),
        ),
      );

      expect(find.text('Gradient Title'), findsOneWidget);
      expect(find.text('Gradient Subtitle'), findsOneWidget);
      expect(find.byIcon(Icons.arrow_back), findsOneWidget);
      expect(find.byIcon(Icons.palette), findsOneWidget);

      // Advance animation timer
      await tester.pump(const Duration(milliseconds: 500));
      expect(find.text('Gradient Title'), findsOneWidget);
    });

    testWidgets(
      'Preset 38: colorTransition renders and interpolates colors on scroll',
      (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: CustomScrollView(
                slivers: [
                  ScrollHeader.colorTransition(
                    title: const Text('Color Title'),
                    subtitle: const Text('Color Subtitle'),
                    startBackgroundColor: Colors.black,
                    endBackgroundColor: Colors.white,
                    startForegroundColor: Colors.white,
                    endForegroundColor: Colors.black,
                    expandedHeight: 120.0,
                    leading: const Icon(Icons.menu),
                    actions: const [Icon(Icons.search)],
                  ),
                  SliverToBoxAdapter(
                    child: Container(height: 1000.0, color: Colors.amber),
                  ),
                ],
              ),
            ),
          ),
        );

        expect(find.text('Color Title'), findsOneWidget);
        expect(find.text('Color Subtitle'), findsOneWidget);
        expect(find.byIcon(Icons.menu), findsOneWidget);
        expect(find.byIcon(Icons.search), findsOneWidget);

        // Scroll down
        await tester.drag(find.byType(CustomScrollView), const Offset(0, -50.0));
        await tester.pumpAndSettle();

        expect(find.text('Color Title'), findsOneWidget);
      },
    );

    testWidgets('Preset 39: illustrated renders illustration and collapses', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomScrollView(
              slivers: [
                ScrollHeader.illustrated(
                  illustration: const Icon(Icons.rocket_launch, size: 64.0),
                  title: const Text('Illustrated Title'),
                  subtitle: const Text('Illustrated Subtitle'),
                  expandedHeight: 200.0,
                  leading: const Icon(Icons.arrow_back),
                  actions: const [Icon(Icons.share)],
                ),
                SliverToBoxAdapter(
                  child: Container(height: 1000.0, color: Colors.teal),
                ),
              ],
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.rocket_launch), findsOneWidget);
      expect(find.byIcon(Icons.arrow_back), findsOneWidget);
      expect(find.byIcon(Icons.share), findsOneWidget);

      // Scroll down to collapse banner
      await tester.drag(find.byType(CustomScrollView), const Offset(0, -160.0));
      await tester.pumpAndSettle();

      expect(find.text('Illustrated Title'), findsOneWidget);
    });

    testWidgets('Preset 40: edgeToEdge renders full-bleed bar', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ScrollHeader.edgeToEdge(
              title: const Text('Edge Title'),
              subtitle: const Text('Edge Subtitle'),
              leading: const Icon(Icons.arrow_back),
              actions: const [Icon(Icons.settings)],
            ),
          ),
        ),
      );

      expect(find.text('Edge Title'), findsOneWidget);
      expect(find.text('Edge Subtitle'), findsOneWidget);
      expect(find.byIcon(Icons.arrow_back), findsOneWidget);
      expect(find.byIcon(Icons.settings), findsOneWidget);
    });

    testWidgets('Direct standalone visual widget instantiation works for Batch 4', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                AnimatedGradientHeaderWidget(title: Text('W37')),
                EdgeToEdgeHeaderWidget(title: Text('W40')),
              ],
            ),
          ),
        ),
      );

      expect(find.text('W37'), findsOneWidget);
      expect(find.text('W40'), findsOneWidget);
    });
  });
}

