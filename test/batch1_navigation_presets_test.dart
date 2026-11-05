import 'package:app_bar_ui/app_bar_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Batch 1 — Navigation & Layout Presets (21–25)', () {
    test('Preset metadata is correctly configured', () {
      expect(
        ScrollHeaderPreset.bottomAlignedTitle.label,
        'Bottom-Aligned Title Header',
      );
      expect(
        ScrollHeaderPreset.bottomAlignedTitle.description,
        isNotEmpty,
      );

      expect(ScrollHeaderPreset.asymmetric.label, 'Asymmetric Header');
      expect(ScrollHeaderPreset.asymmetric.description, isNotEmpty);

      expect(ScrollHeaderPreset.split.label, 'Split Header');
      expect(ScrollHeaderPreset.split.description, isNotEmpty);

      expect(ScrollHeaderPreset.twoRow.label, 'Two-Row Header');
      expect(ScrollHeaderPreset.twoRow.description, isNotEmpty);

      expect(ScrollHeaderPreset.multiAction.label, 'Multi-Action Header');
      expect(ScrollHeaderPreset.multiAction.description, isNotEmpty);

      // Verify isSliver contract
      expect(const ScrollHeader.bottomAlignedTitle().isSliver, isFalse);
      expect(const ScrollHeader.asymmetric().isSliver, isFalse);
      expect(const ScrollHeader.split().isSliver, isFalse);
      expect(const ScrollHeader.twoRow().isSliver, isFalse);
      expect(const ScrollHeader.multiAction().isSliver, isFalse);
    });

    testWidgets('Preset 21: bottomAlignedTitle renders title and navigation', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ScrollHeader.bottomAlignedTitle(
              title: const Text('Bottom Title'),
              subtitle: const Text('Bottom Subtitle'),
              leading: const Icon(Icons.arrow_back),
              actions: const [Icon(Icons.more_vert)],
            ),
          ),
        ),
      );

      expect(find.text('Bottom Title'), findsOneWidget);
      expect(find.text('Bottom Subtitle'), findsOneWidget);
      expect(find.byIcon(Icons.arrow_back), findsOneWidget);
      expect(find.byIcon(Icons.more_vert), findsOneWidget);
    });

    testWidgets('Preset 22: asymmetric renders accented layout', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ScrollHeader.asymmetric(
              title: const Text('Asymmetric Title'),
              subtitle: const Text('Asymmetric Subtitle'),
              leading: const Icon(Icons.menu),
              actions: const [Icon(Icons.search)],
            ),
          ),
        ),
      );

      expect(find.text('Asymmetric Title'), findsOneWidget);
      expect(find.text('Asymmetric Subtitle'), findsOneWidget);
      expect(find.byIcon(Icons.menu), findsOneWidget);
      expect(find.byIcon(Icons.search), findsOneWidget);
    });

    testWidgets('Preset 23: split renders separate compartments', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ScrollHeader.split(
              title: const Text('Split Left Title'),
              subtitle: const Text('Split Left Subtitle'),
              leading: const Icon(Icons.dashboard),
              actions: const [Icon(Icons.notifications), Icon(Icons.settings)],
            ),
          ),
        ),
      );

      expect(find.text('Split Left Title'), findsOneWidget);
      expect(find.text('Split Left Subtitle'), findsOneWidget);
      expect(find.byIcon(Icons.dashboard), findsOneWidget);
      expect(find.byIcon(Icons.notifications), findsOneWidget);
      expect(find.byIcon(Icons.settings), findsOneWidget);
    });

    testWidgets('Preset 24: twoRow renders upper toolbar and bottomRow', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ScrollHeader.twoRow(
              title: const Text('Top Row Title'),
              subtitle: const Text('Top Row Subtitle'),
              leading: const Icon(Icons.arrow_back),
              actions: const [Icon(Icons.share)],
              bottomRow: const Row(
                children: [
                  Chip(label: Text('Filter 1')),
                  Chip(label: Text('Filter 2')),
                ],
              ),
            ),
          ),
        ),
      );

      expect(find.text('Top Row Title'), findsOneWidget);
      expect(find.text('Top Row Subtitle'), findsOneWidget);
      expect(find.byIcon(Icons.arrow_back), findsOneWidget);
      expect(find.byIcon(Icons.share), findsOneWidget);
      expect(find.text('Filter 1'), findsOneWidget);
      expect(find.text('Filter 2'), findsOneWidget);
    });

    testWidgets(
      'Preset 25: multiAction shows visible actions and overflow popup menu',
      (tester) async {
        bool action4Tapped = false;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: ScrollHeader.multiAction(
                title: const Text('Multi-Action Title'),
                maxVisibleActions: 2,
                actions: [
                  const IconButton(
                    icon: Icon(Icons.share),
                    onPressed: null,
                  ),
                  const IconButton(
                    icon: Icon(Icons.favorite),
                    onPressed: null,
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      action4Tapped = true;
                    },
                  ),
                ],
              ),
            ),
          ),
        );

        expect(find.text('Multi-Action Title'), findsOneWidget);
        // Action 1 and 2 visible
        expect(find.byIcon(Icons.share), findsOneWidget);
        expect(find.byIcon(Icons.favorite), findsOneWidget);
        // Action 3 collapsed into overflow
        expect(find.byIcon(Icons.more_vert), findsOneWidget);
        expect(find.byIcon(Icons.delete), findsNothing);

        // Open overflow popup menu
        await tester.tap(find.byIcon(Icons.more_vert));
        await tester.pumpAndSettle();

        // Now action 3 is visible in menu
        expect(find.byIcon(Icons.delete), findsOneWidget);

        // Tap action 3 in menu
        await tester.tap(find.byIcon(Icons.delete));
        await tester.pumpAndSettle();

        expect(action4Tapped, isTrue);
      },
    );

    testWidgets('Direct standalone widget instantiation works', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                BottomAlignedTitleHeaderWidget(title: Text('W21')),
                AsymmetricHeaderWidget(title: Text('W22')),
                SplitHeaderWidget(title: Text('W23')),
                TwoRowHeaderWidget(title: Text('W24')),
                MultiActionHeaderWidget(title: Text('W25')),
              ],
            ),
          ),
        ),
      );

      expect(find.text('W21'), findsOneWidget);
      expect(find.text('W22'), findsOneWidget);
      expect(find.text('W23'), findsOneWidget);
      expect(find.text('W24'), findsOneWidget);
      expect(find.text('W25'), findsOneWidget);
    });
  });
}

