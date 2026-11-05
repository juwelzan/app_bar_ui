import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:app_bar_ui/app_bar_ui.dart';

void main() {
  group('Phase 10.2: ScrollCollapsingHeader Tests', () {
    test('validates expandedHeight >= collapsedHeight assertion', () {
      expect(
        () => ScrollCollapsingHeader(
          expandedHeight: 50.0,
          collapsedHeight: 100.0,
        ),
        throwsAssertionError,
      );
    });

    testWidgets('renders expanded state and collapses as user scrolls', (
      tester,
    ) async {
      final scrollController = ScrollController();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomScrollView(
              controller: scrollController,
              slivers: [
                ScrollCollapsingHeader(
                  expandedHeight: 200.0,
                  collapsedHeight: 60.0,
                  flexibleSpace: const Center(
                    key: ValueKey('expanded_banner'),
                    child: Text('Expanded Banner'),
                  ),
                  collapsedTitle: const Text('Collapsed Title'),
                  collapsedLeading: const Icon(Icons.arrow_back),
                  collapsedActions: const [Icon(Icons.more_vert)],
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) =>
                        SizedBox(height: 50.0, child: Text('Item $index')),
                    childCount: 30,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // At rest (offset 0), banner should be rendered
      expect(find.byKey(const ValueKey('expanded_banner')), findsOneWidget);
      expect(find.text('Expanded Banner'), findsOneWidget);

      // Scroll down by 200px (fully collapsing header)
      scrollController.jumpTo(200.0);
      await tester.pumpAndSettle();

      // Collapsed title and actions are rendered
      expect(find.text('Collapsed Title'), findsOneWidget);
      expect(find.byIcon(Icons.arrow_back), findsOneWidget);
      expect(find.byIcon(Icons.more_vert), findsOneWidget);
    });

    testWidgets('supports custom builder receiving collapseProgress', (
      tester,
    ) async {
      final scrollController = ScrollController();
      double? lastProgress;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomScrollView(
              controller: scrollController,
              slivers: [
                ScrollCollapsingHeader(
                  expandedHeight: 200.0,
                  collapsedHeight: 50.0,
                  builder: (context, progress) {
                    lastProgress = progress;
                    return Text('Progress: ${progress.toStringAsFixed(2)}');
                  },
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => const SizedBox(height: 100),
                    childCount: 20,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(lastProgress, 0.0);
      expect(find.text('Progress: 0.00'), findsOneWidget);

      // Scroll halfway (75px of 150px range)
      scrollController.jumpTo(75.0);
      await tester.pumpAndSettle();

      expect(lastProgress, closeTo(0.5, 0.05));
    });

    testWidgets(
      'ScrollCollapsingHeader.parallax applies parallax translation to flexible space',
      (tester) async {
        final scrollController = ScrollController();

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: CustomScrollView(
                controller: scrollController,
                slivers: [
                  const ScrollCollapsingHeader.parallax(
                    expandedHeight: 200.0,
                    collapsedHeight: 60.0,
                    parallaxFactor: 0.5,
                    background: Text('Parallax Background'),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) =>
                          SizedBox(height: 50.0, child: Text('Item $index')),
                      childCount: 30,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('Parallax Background'), findsOneWidget);

        // Scroll halfway: shrinkOffset = 70.0 (out of 140.0)
        scrollController.jumpTo(70.0);
        await tester.pumpAndSettle();

        // Flexible space should have Transform.translate applied with offset: 70 * (1 - 0.5) = 35.0
        final transformFinder = find.descendant(
          of: find.byType(ScrollCollapsingHeader),
          matching: find.byType(Transform),
        );
        expect(transformFinder, findsOneWidget);
        final transformWidget = tester.widget<Transform>(transformFinder);
        expect(
          transformWidget.transform.getTranslation().y,
          closeTo(35.0, 1.0),
        );
      },
    );

    testWidgets(
      'ScrollCollapsingHeader.transparentFloating configures floating and unpinned state',
      (tester) async {
        const header = ScrollCollapsingHeader.transparentFloating(
          expandedHeight: 180.0,
          collapsedHeight: 60.0,
          collapsedTitle: Text('Floating Title'),
        );

        expect(header.pinned, isFalse);
        expect(header.floating, isTrue);
        expect(header.backgroundColor, Colors.transparent);
        expect(header.elevation, 0.0);
      },
    );
  });

  group('Phase 4: ScrollStickyHeader Tests', () {
    testWidgets('renders child and stays pinned when scrolled', (tester) async {
      final scrollController = ScrollController();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomScrollView(
              controller: scrollController,
              slivers: [
                const SliverToBoxAdapter(
                  child: SizedBox(
                    height: 120.0,
                    child: Text('Leading Sliver Content'),
                  ),
                ),
                const ScrollStickyHeader(
                  height: 56.0,
                  child: Center(child: Text('Sticky Bar Child')),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) =>
                        SizedBox(height: 40.0, child: Text('Row $index')),
                    childCount: 40,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Sticky Bar Child'), findsOneWidget);
      expect(find.text('Leading Sliver Content'), findsOneWidget);

      // Scroll past the 120px leading sliver
      scrollController.jumpTo(200.0);
      await tester.pumpAndSettle();

      // Sticky header remains pinned and visible in viewport
      expect(find.text('Sticky Bar Child'), findsOneWidget);
    });

    testWidgets('supports dynamic builder with isPinned state', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomScrollView(
              slivers: [
                ScrollStickyHeader.builder(
                  height: 50.0,
                  builder: (context, isPinned) =>
                      Text(isPinned ? 'HEADER_PINNED' : 'HEADER_UNPINNED'),
                ),
              ],
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('HEADER_UNPINNED'), findsOneWidget);
    });

    testWidgets(
      'resolves height automatically from PreferredSizeWidget if omitted',
      (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: CustomScrollView(
                slivers: [
                  ScrollStickyHeader(
                    child: PreferredSize(
                      preferredSize: const Size.fromHeight(68.0),
                      child: Container(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        final headerFinder = find.byType(SliverPersistentHeader);
        expect(headerFinder, findsOneWidget);
        final sliverHeader = tester.widget<SliverPersistentHeader>(
          headerFinder,
        );
        expect(sliverHeader.delegate.maxExtent, 68.0);
        expect(sliverHeader.delegate.minExtent, 68.0);
      },
    );
  });

  group('Phase 10.2: ScrollPullToExpandHeader Tests', () {
    testWidgets('renders background and content with expanded height', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CustomScrollView(
              slivers: [
                ScrollPullToExpandHeader(
                  expandedHeight: 220.0,
                  content: Center(child: Text('Cover Content')),
                  child: ColoredBox(
                    key: ValueKey('header_bg'),
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byKey(const ValueKey('header_bg')), findsOneWidget);
      expect(find.text('Cover Content'), findsOneWidget);
    });

    testWidgets('supports custom builder', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomScrollView(
              slivers: [
                ScrollPullToExpandHeader(
                  expandedHeight: 180.0,
                  builder: (context, progress, currentHeight) =>
                      Text('Height: ${currentHeight.toInt()}'),
                ),
              ],
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Height: 180'), findsOneWidget);
    });
  });

  group('Phase 10.2: ScrollStickyTabBar Tests', () {
    testWidgets('renders TabBar and pins when scrolled', (tester) async {
      final scrollController = ScrollController();

      await tester.pumpWidget(
        MaterialApp(
          home: DefaultTabController(
            length: 2,
            child: Scaffold(
              body: CustomScrollView(
                controller: scrollController,
                slivers: [
                  const SliverToBoxAdapter(
                    child: SizedBox(
                      height: 150.0,
                      child: Text('Pre-tab Header Content'),
                    ),
                  ),
                  const ScrollStickyTabBar(
                    child: TabBar(
                      tabs: [
                        Tab(text: 'Tab 1'),
                        Tab(text: 'Tab 2'),
                      ],
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) =>
                          SizedBox(height: 50.0, child: Text('Row $index')),
                      childCount: 40,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Tab 1'), findsOneWidget);
      expect(find.text('Tab 2'), findsOneWidget);
      expect(find.text('Pre-tab Header Content'), findsOneWidget);

      // Scroll past the 150px header
      scrollController.jumpTo(250.0);
      await tester.pumpAndSettle();

      // Tab bar is still pinned and visible in viewport
      expect(find.text('Tab 1'), findsOneWidget);
      expect(find.text('Tab 2'), findsOneWidget);
    });

    testWidgets('supports dynamic builder with isPinned indicator', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomScrollView(
              slivers: [
                ScrollStickyTabBar.builder(
                  height: 50.0,
                  builder: (context, isPinned) =>
                      Text(isPinned ? 'STUCK' : 'UNPINNED'),
                ),
              ],
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('UNPINNED'), findsOneWidget);
    });
  });

  group('Phase 10.2: ScrollAwareFab Tests', () {
    testWidgets('hides and shows via visibilityListenable', (tester) async {
      final visibilityNotifier = ValueNotifier<double>(1.0);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            floatingActionButton: ScrollAwareFab(
              visibilityListenable: visibilityNotifier,
              child: const FloatingActionButton(
                onPressed: null,
                child: Icon(Icons.add),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.add), findsOneWidget);

      // Hide FAB
      visibilityNotifier.value = 0.0;
      await tester.pumpAndSettle();

      final scaleWidget = tester.widget<ScaleTransition>(
        find
            .descendant(
              of: find.byType(ScrollAwareFab),
              matching: find.byType(ScaleTransition),
            )
            .first,
      );
      expect(scaleWidget.scale.value, 0.0);

      // Restore FAB
      visibilityNotifier.value = 1.0;
      await tester.pumpAndSettle();

      final restoredScaleWidget = tester.widget<ScaleTransition>(
        find
            .descendant(
              of: find.byType(ScrollAwareFab),
              matching: find.byType(ScaleTransition),
            )
            .first,
      );
      expect(restoredScaleWidget.scale.value, 1.0);
    });

    testWidgets('cross-fades extendedChild when provided', (tester) async {
      final visibilityNotifier = ValueNotifier<double>(1.0);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            floatingActionButton: ScrollAwareFab(
              visibilityListenable: visibilityNotifier,
              extendedChild: const Text('Extended Action'),
              child: const Icon(Icons.add),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Extended Action'), findsOneWidget);
    });

    testWidgets('respects reduced-motion accessibility preference', (
      tester,
    ) async {
      final visibilityNotifier = ValueNotifier<double>(1.0);

      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: const MediaQueryData(disableAnimations: true),
            child: Scaffold(
              floatingActionButton: ScrollAwareFab(
                visibilityListenable: visibilityNotifier,
                child: const Text('Accessible FAB'),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Accessible FAB'), findsOneWidget);
      // No ScaleTransition or SlideTransition applied inside ScrollAwareFab when disableAnimations is true
      expect(
        find.descendant(
          of: find.byType(ScrollAwareFab),
          matching: find.byType(ScaleTransition),
        ),
        findsNothing,
      );
    });
  });

  group('Phase 10.2: ScrollAutoHideBottomBar Tests', () {
    testWidgets('slides down when hidden and slides back up', (tester) async {
      final visibilityNotifier = ValueNotifier<double>(1.0);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            bottomNavigationBar: ScrollAutoHideBottomBar(
              visibilityListenable: visibilityNotifier,
              child: const BottomAppBar(child: Text('Bottom Bar Content')),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Bottom Bar Content'), findsOneWidget);

      // Hide bottom bar
      visibilityNotifier.value = 0.0;
      await tester.pumpAndSettle();

      // Verify Align heightFactor is 0.0
      final alignWidget = tester.widget<Align>(
        find.descendant(
          of: find.byType(ScrollAutoHideBottomBar),
          matching: find.byType(Align),
        ),
      );
      expect(alignWidget.heightFactor, 0.0);

      // Restore bottom bar
      visibilityNotifier.value = 1.0;
      await tester.pumpAndSettle();

      final restoredAlignWidget = tester.widget<Align>(
        find.descendant(
          of: find.byType(ScrollAutoHideBottomBar),
          matching: find.byType(Align),
        ),
      );
      expect(restoredAlignWidget.heightFactor, 1.0);
    });

    testWidgets('respects reduced-motion accessibility mode', (tester) async {
      final visibilityNotifier = ValueNotifier<double>(1.0);

      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: const MediaQueryData(disableAnimations: true),
            child: Scaffold(
              bottomNavigationBar: ScrollAutoHideBottomBar(
                visibilityListenable: visibilityNotifier,
                child: const Text('Static Bottom Nav'),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Static Bottom Nav'), findsOneWidget);
      // AnimatedBuilder / FractionalTranslation is bypassed inside ScrollAutoHideBottomBar
      expect(
        find.descendant(
          of: find.byType(ScrollAutoHideBottomBar),
          matching: find.byType(FractionalTranslation),
        ),
        findsNothing,
      );
    });
  });
}
