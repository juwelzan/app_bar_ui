import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:app_bar_ui/app_bar_ui.dart';

void main() {
  group('Phase 5: ScrollToTopButton Tests', () {
    testWidgets(
      'remains hidden until threshold is reached, then scrolls to top on tap',
      (tester) async {
        final scrollController = ScrollController();
        bool tapped = false;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Stack(
                children: [
                  ListView.builder(
                    controller: scrollController,
                    itemCount: 50,
                    itemBuilder: (context, index) =>
                        SizedBox(height: 50.0, child: Text('Item $index')),
                  ),
                  Positioned(
                    bottom: 16.0,
                    right: 16.0,
                    child: ScrollToTopButton(
                      scrollController: scrollController,
                      threshold: 200.0,
                      duration: const Duration(milliseconds: 100),
                      onPressed: () => tapped = true,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Initially at offset 0, button should be ignoring pointers / scale 0
        final buttonFinder = find.byType(ScrollToTopButton);
        expect(buttonFinder, findsOneWidget);

        final ignorePointer = tester.widget<IgnorePointer>(
          find.descendant(
            of: buttonFinder,
            matching: find.byType(IgnorePointer),
          ),
        );
        expect(ignorePointer.ignoring, isTrue);

        // Scroll past threshold (300px > 200px threshold)
        scrollController.jumpTo(300.0);
        await tester.pumpAndSettle();

        final visibleIgnorePointer = tester.widget<IgnorePointer>(
          find.descendant(
            of: buttonFinder,
            matching: find.byType(IgnorePointer),
          ),
        );
        expect(visibleIgnorePointer.ignoring, isFalse);

        // Tap scroll to top
        await tester.tap(find.byType(FloatingActionButton));
        await tester.pumpAndSettle();

        expect(tapped, isTrue);
        expect(scrollController.offset, 0.0);
      },
    );

    testWidgets('supports visibilityListenable override', (tester) async {
      final visibilityNotifier = ValueNotifier<double>(0.0);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            floatingActionButton: ScrollToTopButton(
              visibilityListenable: visibilityNotifier,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final buttonFinder = find.byType(ScrollToTopButton);
      final ignoreFinder = find.descendant(
        of: buttonFinder,
        matching: find.byType(IgnorePointer),
      );

      expect(tester.widget<IgnorePointer>(ignoreFinder).ignoring, isTrue);

      visibilityNotifier.value = 1.0;
      await tester.pumpAndSettle();

      expect(tester.widget<IgnorePointer>(ignoreFinder).ignoring, isFalse);
    });
  });

  group('Phase 5: ScrollPositionIndicator Tests', () {
    testWidgets('renders percentage accurately based on scroll position', (
      tester,
    ) async {
      final scrollController = ScrollController();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Stack(
              children: [
                ListView.builder(
                  controller: scrollController,
                  itemCount: 20,
                  itemExtent: 100.0,
                  itemBuilder: (context, index) => Text('Row $index'),
                ),
                Positioned(
                  top: 10.0,
                  right: 10.0,
                  child: ScrollPositionIndicator(
                    scrollController: scrollController,
                    style: ScrollPositionStyle.percentage,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('0%'), findsOneWidget);

      // Max scroll extent is (20 * 100) - 600 (viewport) = 1400.
      // Jump to 700 (50%)
      scrollController.jumpTo(700.0);
      await tester.pumpAndSettle();

      expect(find.text('50%'), findsOneWidget);
    });

    testWidgets('renders fraction mode with total itemCount', (tester) async {
      final scrollController = ScrollController();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Stack(
              children: [
                ListView.builder(
                  controller: scrollController,
                  itemCount: 10,
                  itemExtent: 200.0,
                  itemBuilder: (context, index) => Text('Page $index'),
                ),
                Positioned(
                  top: 10.0,
                  right: 10.0,
                  child: ScrollPositionIndicator(
                    scrollController: scrollController,
                    itemCount: 10,
                    style: ScrollPositionStyle.fraction,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('1 / 10'), findsOneWidget);
    });

    testWidgets('supports custom builder receiving ScrollMetrics', (
      tester,
    ) async {
      final scrollController = ScrollController();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Stack(
              children: [
                ListView.builder(
                  controller: scrollController,
                  itemCount: 20,
                  itemExtent: 100.0,
                  itemBuilder: (context, index) => Text('Item $index'),
                ),
                Positioned(
                  top: 10.0,
                  child: ScrollPositionIndicator(
                    scrollController: scrollController,
                    builder: (context, metrics, progress) =>
                        Text('CUSTOM_${(progress * 100).toInt()}'),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Trigger scroll
      scrollController.jumpTo(200.0);
      await tester.pumpAndSettle();

      expect(find.textContaining('CUSTOM_'), findsOneWidget);
    });
  });

  group('Phase 5: ScrollAwareSideActions Tests', () {
    testWidgets(
      'renders action items and slides offscreen when scrolling down',
      (tester) async {
        final scrollController = ScrollController();

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Stack(
                children: [
                  ListView.builder(
                    controller: scrollController,
                    itemCount: 40,
                    itemExtent: 80.0,
                    itemBuilder: (context, index) => Text('Card $index'),
                  ),
                  ScrollAwareSideActions(
                    scrollController: scrollController,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.share),
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: const Icon(Icons.bookmark),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byIcon(Icons.share), findsOneWidget);
        expect(find.byIcon(Icons.bookmark), findsOneWidget);

        // Scroll down
        scrollController.jumpTo(250.0);
        await tester.pumpAndSettle();

        // Side actions should ignore pointer when hidden
        final ignoreFinder = find.descendant(
          of: find.byType(ScrollAwareSideActions),
          matching: find.byType(IgnorePointer),
        );
        expect(tester.widget<IgnorePointer>(ignoreFinder).ignoring, isTrue);

        // Scroll back up to top
        scrollController.jumpTo(0.0);
        await tester.pumpAndSettle();

        expect(tester.widget<IgnorePointer>(ignoreFinder).ignoring, isFalse);
      },
    );
  });

  group('Phase 5: ScrollExpandableFab Tests', () {
    testWidgets('toggles child action items and auto-collapses on scroll', (
      tester,
    ) async {
      final scrollController = ScrollController();
      bool actionClicked = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ListView.builder(
              controller: scrollController,
              itemCount: 40,
              itemExtent: 80.0,
              itemBuilder: (context, index) => Text('Row $index'),
            ),
            floatingActionButton: ScrollExpandableFab(
              scrollController: scrollController,
              children: [
                ScrollExpandableFabAction(
                  icon: const Icon(Icons.email),
                  label: 'Send Email',
                  onPressed: () => actionClicked = true,
                ),
                ScrollExpandableFabAction(
                  icon: const Icon(Icons.call),
                  label: 'Call Support',
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Main FAB should be visible
      expect(find.byType(ScrollExpandableFab), findsOneWidget);

      // Tap main FAB to expand
      final mainFabFinder = find.byKey(
        const ValueKey('scroll_expandable_fab_main'),
      );
      await tester.tap(mainFabFinder);
      await tester.pumpAndSettle();

      expect(find.text('Send Email'), findsOneWidget);
      expect(find.text('Call Support'), findsOneWidget);

      // Tap an action
      await tester.tap(find.text('Send Email'));
      await tester.pumpAndSettle();

      expect(actionClicked, isTrue);

      // Re-open
      await tester.tap(mainFabFinder);
      await tester.pumpAndSettle();

      expect(find.text('Call Support'), findsOneWidget);

      // Scrolling down should auto-collapse open menu
      scrollController.jumpTo(100.0);
      await tester.pumpAndSettle();

      // Opacity of child action should return to 0.0
      final opacityFinder = find
          .descendant(
            of: find.byType(ScrollExpandableFab),
            matching: find.byType(Opacity),
          )
          .first;
      expect(tester.widget<Opacity>(opacityFinder).opacity, 0.0);
    });
  });

  group('Phase 5: ScrollPageIndicator Tests', () {
    testWidgets('renders all dots and expands active dot dynamically', (
      tester,
    ) async {
      final pageController = PageController();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Stack(
              children: [
                PageView(
                  controller: pageController,
                  children: const [
                    Center(child: Text('Page 1')),
                    Center(child: Text('Page 2')),
                    Center(child: Text('Page 3')),
                  ],
                ),
                Positioned(
                  bottom: 20.0,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: ScrollPageIndicator(
                      controller: pageController,
                      itemCount: 3,
                      dotSize: const Size(8.0, 8.0),
                      activeDotSize: const Size(24.0, 8.0),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(ScrollPageIndicator), findsOneWidget);

      // On Page 0, the first dot container should have width 24.0 (activeDotSize)
      final dotContainers = find.descendant(
        of: find.byType(ScrollPageIndicator),
        matching: find.byType(Container),
      );
      expect(dotContainers, findsNWidgets(3));

      final firstDot = tester.widget<Container>(dotContainers.at(0));
      final secondDot = tester.widget<Container>(dotContainers.at(1));

      expect(firstDot.constraints?.maxWidth, 24.0);
      expect(secondDot.constraints?.maxWidth, 8.0);

      // Animate to page 1
      pageController.jumpToPage(1);
      await tester.pumpAndSettle();

      final firstDotAfter = tester.widget<Container>(dotContainers.at(0));
      final secondDotAfter = tester.widget<Container>(dotContainers.at(1));

      expect(firstDotAfter.constraints?.maxWidth, 8.0);
      expect(secondDotAfter.constraints?.maxWidth, 24.0);
    });

    testWidgets('handles onDotTapped callback', (tester) async {
      int? tappedIndex;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: ScrollPageIndicator(
                itemCount: 4,
                onDotTapped: (index) => tappedIndex = index,
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final dotContainers = find.descendant(
        of: find.byType(ScrollPageIndicator),
        matching: find.byType(GestureDetector),
      );
      expect(dotContainers, findsNWidgets(4));

      // Tap dot 2
      await tester.tap(dotContainers.at(2));
      await tester.pumpAndSettle();

      expect(tappedIndex, 2);
    });
  });
}
