import 'package:app_bar_ui/app_bar_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Batch 3 — Visual & Creative Presets (31–35)', () {
    test('Preset metadata is correctly configured', () {
      expect(ScrollHeaderPreset.glass.label, 'Glass Header');
      expect(ScrollHeaderPreset.glass.description, isNotEmpty);

      expect(
        ScrollHeaderPreset.blurredBackground.label,
        'Blurred Background Header',
      );
      expect(ScrollHeaderPreset.blurredBackground.description, isNotEmpty);

      expect(ScrollHeaderPreset.bordered.label, 'Bordered Header');
      expect(ScrollHeaderPreset.bordered.description, isNotEmpty);

      expect(ScrollHeaderPreset.shadowElevated.label, 'Shadow-Elevated Header');
      expect(ScrollHeaderPreset.shadowElevated.description, isNotEmpty);

      expect(ScrollHeaderPreset.layered.label, 'Layered Header');
      expect(ScrollHeaderPreset.layered.description, isNotEmpty);

      // Verify isSliver contract
      expect(const ScrollHeader.glass().isSliver, isFalse);
      expect(const ScrollHeader.blurredBackground().isSliver, isFalse);
      expect(const ScrollHeader.bordered().isSliver, isFalse);
      expect(const ScrollHeader.shadowElevated().isSliver, isFalse);
      expect(const ScrollHeader.layered().isSliver, isFalse);
    });

    testWidgets('Preset 31: glass renders BackdropFilter and content', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ScrollHeader.glass(
              title: const Text('Glass Title'),
              subtitle: const Text('Glass Subtitle'),
              blurSigma: 16.0,
              leading: const Icon(Icons.arrow_back),
              actions: const [Icon(Icons.more_vert)],
            ),
          ),
        ),
      );

      expect(find.text('Glass Title'), findsOneWidget);
      expect(find.text('Glass Subtitle'), findsOneWidget);
      expect(find.byIcon(Icons.arrow_back), findsOneWidget);
      expect(find.byIcon(Icons.more_vert), findsOneWidget);
      expect(find.byType(BackdropFilter), findsOneWidget);
    });

    testWidgets('Preset 32: blurredBackground renders performance-safe blur', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ScrollHeader.blurredBackground(
              title: const Text('Blurred Title'),
              subtitle: const Text('Blurred Subtitle'),
              blurSigma: 8.0,
              leading: const Icon(Icons.menu),
              actions: const [Icon(Icons.search)],
            ),
          ),
        ),
      );

      expect(find.text('Blurred Title'), findsOneWidget);
      expect(find.text('Blurred Subtitle'), findsOneWidget);
      expect(find.byIcon(Icons.menu), findsOneWidget);
      expect(find.byIcon(Icons.search), findsOneWidget);
      expect(find.byType(BackdropFilter), findsOneWidget);
    });

    testWidgets('Preset 33: bordered renders clean border-separated bar', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ScrollHeader.bordered(
              title: const Text('Bordered Title'),
              subtitle: const Text('Bordered Subtitle'),
              leading: const Icon(Icons.arrow_back),
              actions: const [Icon(Icons.check)],
            ),
          ),
        ),
      );

      expect(find.text('Bordered Title'), findsOneWidget);
      expect(find.text('Bordered Subtitle'), findsOneWidget);
      expect(find.byIcon(Icons.arrow_back), findsOneWidget);
      expect(find.byIcon(Icons.check), findsOneWidget);
    });

    testWidgets('Preset 34: shadowElevated renders elevated drop shadow', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ScrollHeader.shadowElevated(
              title: const Text('Elevated Title'),
              subtitle: const Text('Elevated Subtitle'),
              leading: const Icon(Icons.star),
              actions: const [Icon(Icons.share)],
            ),
          ),
        ),
      );

      expect(find.text('Elevated Title'), findsOneWidget);
      expect(find.text('Elevated Subtitle'), findsOneWidget);
      expect(find.byIcon(Icons.star), findsOneWidget);
      expect(find.byIcon(Icons.share), findsOneWidget);
    });

    testWidgets('Preset 35: layered renders back, middle, and foreground layers', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ScrollHeader.layered(
              title: const Text('Layered Title'),
              subtitle: const Text('Layered Subtitle'),
              backLayer: const Center(child: Text('Background Deco')),
              middleLayer: const Align(
                alignment: Alignment.centerRight,
                child: Text('Middle Chip'),
              ),
              leading: const Icon(Icons.layers),
              actions: const [Icon(Icons.settings)],
            ),
          ),
        ),
      );

      expect(find.text('Background Deco'), findsOneWidget);
      expect(find.text('Middle Chip'), findsOneWidget);
      expect(find.text('Layered Title'), findsOneWidget);
      expect(find.text('Layered Subtitle'), findsOneWidget);
      expect(find.byIcon(Icons.layers), findsOneWidget);
      expect(find.byIcon(Icons.settings), findsOneWidget);
    });

    testWidgets('Direct standalone visual widget instantiation works', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                GlassHeaderWidget(title: Text('W31')),
                BlurredBackgroundHeaderWidget(title: Text('W32')),
                BorderedHeaderWidget(title: Text('W33')),
                ShadowElevatedHeaderWidget(title: Text('W34')),
                LayeredHeaderWidget(title: Text('W35')),
              ],
            ),
          ),
        ),
      );

      expect(find.text('W31'), findsOneWidget);
      expect(find.text('W32'), findsOneWidget);
      expect(find.text('W33'), findsOneWidget);
      expect(find.text('W34'), findsOneWidget);
      expect(find.text('W35'), findsOneWidget);
    });
  });
}
