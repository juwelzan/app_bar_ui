import 'package:app_bar_ui/app_bar_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Batch 2 — Navigation & Layout Presets (26–30)', () {
    test('Preset metadata is correctly configured', () {
      expect(ScrollHeaderPreset.compactIcon.label, 'Compact Icon Header');
      expect(ScrollHeaderPreset.compactIcon.description, isNotEmpty);

      expect(ScrollHeaderPreset.breadcrumb.label, 'Breadcrumb Header');
      expect(ScrollHeaderPreset.breadcrumb.description, isNotEmpty);

      expect(ScrollHeaderPreset.backTitle.label, 'Back-Title Header');
      expect(ScrollHeaderPreset.backTitle.description, isNotEmpty);

      expect(
        ScrollHeaderPreset.contextualSelection.label,
        'Contextual Selection Header',
      );
      expect(ScrollHeaderPreset.contextualSelection.description, isNotEmpty);

      expect(
        ScrollHeaderPreset.adaptiveNavigation.label,
        'Adaptive Navigation Header',
      );
      expect(ScrollHeaderPreset.adaptiveNavigation.description, isNotEmpty);

      // Verify isSliver contract
      expect(const ScrollHeader.compactIcon().isSliver, isFalse);
      expect(
        const ScrollHeader.breadcrumb(breadcrumbs: []).isSliver,
        isFalse,
      );
      expect(const ScrollHeader.backTitle().isSliver, isFalse);
      expect(
        const ScrollHeader.contextualSelection(selectedCount: 1).isSliver,
        isFalse,
      );
      expect(
        const ScrollHeader.adaptiveNavigation(
          compactHeader: SizedBox(),
          expandedHeader: SizedBox(),
        ).isSliver,
        isFalse,
      );
    });

    testWidgets('Preset 26: compactIcon renders minimal icon toolbar', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ScrollHeader.compactIcon(
              title: const Text('Compact'),
              leading: const Icon(Icons.arrow_back),
              actions: const [Icon(Icons.search), Icon(Icons.share)],
            ),
          ),
        ),
      );

      expect(find.text('Compact'), findsOneWidget);
      expect(find.byIcon(Icons.arrow_back), findsOneWidget);
      expect(find.byIcon(Icons.search), findsOneWidget);
      expect(find.byIcon(Icons.share), findsOneWidget);
    });

    testWidgets('Preset 27: breadcrumb renders items and triggers tap', (
      tester,
    ) async {
      int tappedIndex = -1;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ScrollHeader.breadcrumb(
              breadcrumbs: const [
                Text('Root'),
                Text('Category'),
                Text('Item'),
              ],
              onBreadcrumbTap: (index) {
                tappedIndex = index;
              },
            ),
          ),
        ),
      );

      expect(find.text('Root'), findsOneWidget);
      expect(find.text('Category'), findsOneWidget);
      expect(find.text('Item'), findsOneWidget);
      expect(find.byIcon(Icons.chevron_right), findsNWidgets(2));

      await tester.tap(find.text('Category'));
      await tester.pumpAndSettle();

      expect(tappedIndex, 1);
    });

    testWidgets('Preset 28: backTitle handles back button tap', (tester) async {
      bool backTapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ScrollHeader.backTitle(
              title: const Text('Detail Screen'),
              subtitle: const Text('Subtitle info'),
              onBackTap: () {
                backTapped = true;
              },
              actions: const [Icon(Icons.bookmark)],
            ),
          ),
        ),
      );

      expect(find.text('Detail Screen'), findsOneWidget);
      expect(find.text('Subtitle info'), findsOneWidget);
      expect(find.byIcon(Icons.arrow_back), findsOneWidget);
      expect(find.byIcon(Icons.bookmark), findsOneWidget);

      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();

      expect(backTapped, isTrue);
    });

    testWidgets('Preset 29: contextualSelection renders count and triggers clear', (
      tester,
    ) async {
      bool cleared = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ScrollHeader.contextualSelection(
              selectedCount: 5,
              onClearSelection: () {
                cleared = true;
              },
              selectionActions: const [
                Icon(Icons.delete),
                Icon(Icons.archive),
              ],
            ),
          ),
        ),
      );

      expect(find.text('5 selected'), findsOneWidget);
      expect(find.byIcon(Icons.close), findsOneWidget);
      expect(find.byIcon(Icons.delete), findsOneWidget);
      expect(find.byIcon(Icons.archive), findsOneWidget);

      await tester.tap(find.byIcon(Icons.close));
      await tester.pumpAndSettle();

      expect(cleared, isTrue);
    });

    testWidgets(
      'Preset 30: adaptiveNavigation renders compact on mobile and expanded on tablet/desktop',
      (tester) async {
        // Set mobile viewport (400 x 800)
        tester.view.physicalSize = const Size(400, 800);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(() => tester.view.resetPhysicalSize());

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: ScrollHeader.adaptiveNavigation(
                breakpoint: 600.0,
                compactHeader: const Text('Compact Mobile Layout'),
                expandedHeader: const Text('Expanded Desktop Layout'),
              ),
            ),
          ),
        );

        expect(find.text('Compact Mobile Layout'), findsOneWidget);
        expect(find.text('Expanded Desktop Layout'), findsNothing);

        // Switch to desktop/tablet viewport (900 x 800)
        tester.view.physicalSize = const Size(900, 800);
        await tester.pumpAndSettle();

        expect(find.text('Compact Mobile Layout'), findsNothing);
        expect(find.text('Expanded Desktop Layout'), findsOneWidget);
      },
    );

    testWidgets('Direct standalone widget instantiation works for Batch 2', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                CompactIconHeaderWidget(title: Text('W26')),
                BreadcrumbHeaderWidget(breadcrumbs: [Text('W27')]),
                BackTitleHeaderWidget(title: Text('W28')),
                ContextualSelectionHeaderWidget(selectedCount: 3),
                AdaptiveNavigationHeaderWidget(
                  compactHeader: Text('W30-Compact'),
                  expandedHeader: Text('W30-Expanded'),
                ),
              ],
            ),
          ),
        ),
      );

      expect(find.text('W26'), findsOneWidget);
      expect(find.text('W27'), findsOneWidget);
      expect(find.text('W28'), findsOneWidget);
      expect(find.text('3 selected'), findsOneWidget);
      expect(find.text('W30-Expanded'), findsOneWidget);
    });
  });
}
