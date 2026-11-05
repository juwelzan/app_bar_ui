import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:app_bar_ui/app_bar_ui.dart';

void main() {
  Widget buildTestScaffold({
    Widget? initialLeading = const Icon(
      Icons.person,
      key: ValueKey('initial_avatar'),
    ),
    Widget? scrolledLeading = const Icon(
      Icons.menu,
      key: ValueKey('scrolled_drawer'),
    ),
    Widget? initialTrailing = const Icon(
      Icons.notifications,
      key: ValueKey('initial_bell'),
    ),
    Widget? scrolledTrailing = const Icon(
      Icons.person,
      key: ValueKey('scrolled_avatar'),
    ),
    Widget? header,
    Widget? headerTitle = const Text('Test Header Title'),
    Widget? headerSubtitle = const Text('Test Subtitle'),
    Widget? body,
    List<Widget>? slivers,
    VoidCallback? onLeadingInitialTap,
    VoidCallback? onLeadingScrolledTap,
    VoidCallback? onTrailingInitialTap,
    VoidCallback? onTrailingScrolledTap,
    ScrollController? controller,
    ScrollResponsiveConfig config = const ScrollResponsiveConfig(),
    Widget? drawer,
    ValueChanged<ScrollProgressDetails>? onScrollUpdate,
    ValueChanged<ScrollDirection>? onScrollDirectionChanged,
    RouteObserver<ModalRoute<void>>? routeObserver,
  }) {
    return MaterialApp(
      navigatorObservers: [?routeObserver],
      home: ScrollResponsiveScaffold(
        initialLeading: initialLeading,
        scrolledLeading: scrolledLeading,
        initialTrailing: initialTrailing,
        scrolledTrailing: scrolledTrailing,
        header: header,
        headerTitle: headerTitle,
        headerSubtitle: headerSubtitle,
        body:
            body ??
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 40,
              itemBuilder: (context, index) =>
                  ListTile(title: Text('List item #$index')),
            ),
        slivers: slivers,
        onLeadingInitialTap: onLeadingInitialTap,
        onLeadingScrolledTap: onLeadingScrolledTap,
        onTrailingInitialTap: onTrailingInitialTap,
        onTrailingScrolledTap: onTrailingScrolledTap,
        controller: controller,
        config: config,
        drawer: drawer,
        onScrollUpdate: onScrollUpdate,
        onScrollDirectionChanged: onScrollDirectionChanged,
        routeObserver: routeObserver,
      ),
    );
  }

  group('ScrollResponsiveScaffold', () {
    testWidgets('initial state renders header and initial action icons', (
      tester,
    ) async {
      await tester.pumpWidget(buildTestScaffold());
      await tester.pumpAndSettle();

      // Header is rendered
      expect(find.text('Test Header Title'), findsOneWidget);
      expect(find.text('Test Subtitle'), findsOneWidget);

      // Pinned action icons rendered
      expect(
        find.byKey(const ValueKey('pinned_leading_action')),
        findsOneWidget,
      );
      expect(
        find.byKey(const ValueKey('pinned_trailing_action')),
        findsOneWidget,
      );

      // Check initial leading is visible
      expect(find.byKey(const ValueKey('initial_avatar')), findsOneWidget);
      // Check initial trailing is visible
      expect(find.byKey(const ValueKey('initial_bell')), findsOneWidget);
    });

    testWidgets('pinned icons stay in top position when scrolled down', (
      tester,
    ) async {
      await tester.pumpWidget(buildTestScaffold());
      await tester.pumpAndSettle();

      final initialLeadingPosition = tester.getTopLeft(
        find.byKey(const ValueKey('pinned_leading_action')),
      );
      final initialTrailingPosition = tester.getTopRight(
        find.byKey(const ValueKey('pinned_trailing_action')),
      );

      // Scroll down 200 pixels
      await tester.drag(find.text('List item #0'), const Offset(0.0, -200.0));
      await tester.pumpAndSettle();

      final scrolledLeadingPosition = tester.getTopLeft(
        find.byKey(const ValueKey('pinned_leading_action')),
      );
      final scrolledTrailingPosition = tester.getTopRight(
        find.byKey(const ValueKey('pinned_trailing_action')),
      );

      // Pinned icons MUST stay in their exact same vertical position!
      expect(scrolledLeadingPosition.dy, initialLeadingPosition.dy);
      expect(scrolledTrailingPosition.dy, initialTrailingPosition.dy);

      // Horizontal alignment stays locked
      expect(scrolledLeadingPosition.dx, initialLeadingPosition.dx);
      expect(scrolledTrailingPosition.dx, initialTrailingPosition.dx);
    });

    testWidgets('header scrolls away naturally when scrolled down', (
      tester,
    ) async {
      await tester.pumpWidget(buildTestScaffold());
      await tester.pumpAndSettle();

      expect(find.text('Test Header Title'), findsOneWidget);

      // Scroll down substantially
      await tester.drag(find.text('List item #0'), const Offset(0.0, -400.0));
      await tester.pumpAndSettle();

      // Header title has scrolled out of viewport
      expect(find.text('Test Header Title'), findsNothing);
    });

    testWidgets('left icon transitions from avatar to drawer on scroll down', (
      tester,
    ) async {
      double latestLeadingProgress = 0.0;

      await tester.pumpWidget(
        buildTestScaffold(
          config: const ScrollResponsiveConfig(
            thresholds: ScrollThresholdConfig(
              leadingStartOffset: 20.0,
              leadingEndOffset: 80.0,
            ),
          ),
          onScrollUpdate: (details) {
            latestLeadingProgress = details.leadingProgress;
          },
        ),
      );
      await tester.pumpAndSettle();

      expect(latestLeadingProgress, 0.0);

      // Scroll down past the threshold (100 pixels)
      await tester.drag(find.text('List item #0'), const Offset(0.0, -100.0));
      await tester.pumpAndSettle();

      expect(latestLeadingProgress, 1.0);
    });

    testWidgets(
      'right icon transitions from notification to avatar on scroll down',
      (tester) async {
        double latestTrailingProgress = 0.0;

        await tester.pumpWidget(
          buildTestScaffold(
            config: const ScrollResponsiveConfig(
              thresholds: ScrollThresholdConfig(
                trailingStartOffset: 20.0,
                trailingEndOffset: 80.0,
              ),
            ),
            onScrollUpdate: (details) {
              latestTrailingProgress = details.trailingProgress;
            },
          ),
        );
        await tester.pumpAndSettle();

        expect(latestTrailingProgress, 0.0);

        // Scroll down past threshold
        await tester.drag(find.text('List item #0'), const Offset(0.0, -100.0));
        await tester.pumpAndSettle();

        expect(latestTrailingProgress, 1.0);
      },
    );

    testWidgets('scrolling back up restores initial icons and header', (
      tester,
    ) async {
      double latestLeadingProgress = 0.0;

      await tester.pumpWidget(
        buildTestScaffold(
          config: const ScrollResponsiveConfig(
            thresholds: ScrollThresholdConfig(
              leadingStartOffset: 20.0,
              leadingEndOffset: 80.0,
            ),
          ),
          onScrollUpdate: (details) {
            latestLeadingProgress = details.leadingProgress;
          },
        ),
      );
      await tester.pumpAndSettle();

      // Scroll down
      await tester.drag(find.text('List item #0'), const Offset(0.0, -200.0));
      await tester.pumpAndSettle();
      expect(latestLeadingProgress, 1.0);

      // Scroll back up to top
      await tester.drag(
        find.byType(CustomScrollView),
        const Offset(0.0, 300.0),
      );
      await tester.pumpAndSettle();

      expect(latestLeadingProgress, 0.0);
      expect(find.text('Test Header Title'), findsOneWidget);
    });

    testWidgets('taps trigger initial callbacks when at top', (tester) async {
      bool leadingInitialTapped = false;
      bool trailingInitialTapped = false;
      bool leadingScrolledTapped = false;
      bool trailingScrolledTapped = false;

      await tester.pumpWidget(
        buildTestScaffold(
          onLeadingInitialTap: () => leadingInitialTapped = true,
          onLeadingScrolledTap: () => leadingScrolledTapped = true,
          onTrailingInitialTap: () => trailingInitialTapped = true,
          onTrailingScrolledTap: () => trailingScrolledTapped = true,
        ),
      );
      await tester.pumpAndSettle();

      // Tap leading
      await tester.tap(find.byKey(const ValueKey('pinned_leading_action')));
      await tester.pump();

      expect(leadingInitialTapped, isTrue);
      expect(leadingScrolledTapped, isFalse);

      // Tap trailing
      await tester.tap(find.byKey(const ValueKey('pinned_trailing_action')));
      await tester.pump();

      expect(trailingInitialTapped, isTrue);
      expect(trailingScrolledTapped, isFalse);
    });

    testWidgets(
      'taps trigger scrolled callbacks when scrolled past threshold',
      (tester) async {
        bool leadingInitialTapped = false;
        bool trailingInitialTapped = false;
        bool leadingScrolledTapped = false;
        bool trailingScrolledTapped = false;

        await tester.pumpWidget(
          buildTestScaffold(
            onLeadingInitialTap: () => leadingInitialTapped = true,
            onLeadingScrolledTap: () => leadingScrolledTapped = true,
            onTrailingInitialTap: () => trailingInitialTapped = true,
            onTrailingScrolledTap: () => trailingScrolledTapped = true,
          ),
        );
        await tester.pumpAndSettle();

        // Scroll down past threshold
        await tester.drag(find.text('List item #0'), const Offset(0.0, -200.0));
        await tester.pumpAndSettle();

        // Tap leading
        await tester.tap(find.byKey(const ValueKey('pinned_leading_action')));
        await tester.pump();

        expect(leadingInitialTapped, isFalse);
        expect(leadingScrolledTapped, isTrue);

        // Tap trailing
        await tester.tap(find.byKey(const ValueKey('pinned_trailing_action')));
        await tester.pump();

        expect(trailingInitialTapped, isFalse);
        expect(trailingScrolledTapped, isTrue);
      },
    );

    testWidgets(
      'opens drawer automatically on scrolled leading tap if drawer provided',
      (tester) async {
        await tester.pumpWidget(
          buildTestScaffold(
            drawer: const Drawer(child: Text('Navigation Drawer Opened!')),
          ),
        );
        await tester.pumpAndSettle();

        // Scroll down
        await tester.drag(find.text('List item #0'), const Offset(0.0, -200.0));
        await tester.pumpAndSettle();

        // Tap scrolled leading icon
        await tester.tap(find.byKey(const ValueKey('pinned_leading_action')));
        await tester.pumpAndSettle();

        expect(find.text('Navigation Drawer Opened!'), findsOneWidget);
      },
    );

    testWidgets('supports direct custom slivers list', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ScrollResponsiveScaffold(
            slivers: [
              SliverToBoxAdapter(
                child: Container(
                  height: 100,
                  key: const ValueKey('custom_sliver_box'),
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => Text('Sliver Item #$index'),
                  childCount: 10,
                ),
              ),
            ],
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byKey(const ValueKey('custom_sliver_box')), findsOneWidget);
      expect(find.text('Sliver Item #0'), findsOneWidget);
    });

    testWidgets('handles external ScrollController without disposing it', (
      tester,
    ) async {
      final externalController = ScrollController();

      await tester.pumpWidget(
        buildTestScaffold(controller: externalController),
      );
      await tester.pumpAndSettle();

      expect(externalController.hasClients, isTrue);

      // Rebuild with different widget to trigger dispose
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: Text('New Screen'))),
      );
      await tester.pumpAndSettle();

      // External controller should NOT be disposed by the package!
      expect(externalController.hasClients, isFalse);
      externalController.dispose(); // Should succeed cleanly
    });

    testWidgets('supports thresholdTriggered animation transition type', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildTestScaffold(
          config: const ScrollResponsiveConfig(
            animation: ScrollAnimationConfig(
              transitionType: ScrollTransitionType.thresholdTriggered,
              duration: Duration(milliseconds: 100),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Scroll down
      await tester.drag(find.text('List item #0'), const Offset(0.0, -150.0));
      await tester.pumpAndSettle();

      // Scrolled icon is now active
      expect(
        find.byKey(const ValueKey('pinned_leading_action')),
        findsOneWidget,
      );
    });

    testWidgets(
      'pinned side actions have completely transparent backgrounds with no elevation',
      (tester) async {
        await tester.pumpWidget(buildTestScaffold());
        await tester.pumpAndSettle();

        // Ensure no AppBar exists in the tree
        expect(find.byType(AppBar), findsNothing);

        // Verify each action button container has transparent background
        final leadingContainer = tester.widget<Container>(
          find.descendant(
            of: find.byKey(const ValueKey('pinned_leading_action')),
            matching: find.byType(Container),
          ),
        );
        final leadingDecor = leadingContainer.decoration as BoxDecoration?;
        expect(leadingDecor?.color, Colors.transparent);
        expect(leadingDecor?.boxShadow, isEmpty);

        final trailingContainer = tester.widget<Container>(
          find.descendant(
            of: find.byKey(const ValueKey('pinned_trailing_action')),
            matching: find.byType(Container),
          ),
        );
        final trailingDecor = trailingContainer.decoration as BoxDecoration?;
        expect(trailingDecor?.color, Colors.transparent);
        expect(trailingDecor?.boxShadow, isEmpty);
      },
    );

    testWidgets(
      'center header area passes taps directly to scrollable content',
      (tester) async {
        bool headerTapped = false;

        await tester.pumpWidget(
          buildTestScaffold(
            headerTitle: GestureDetector(
              key: const ValueKey('clickable_header_title'),
              onTap: () => headerTapped = true,
              child: const Text('Tappable Title'),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Tap header title in the center between the pinned actions
        await tester.tap(find.byKey(const ValueKey('clickable_header_title')));
        await tester.pump();

        expect(headerTapped, isTrue);
      },
    );

    testWidgets('restores status bar on widget disposal', (tester) async {
      StatusBarManager.debugOverrideSupportedPlatform = true;
      final List<MethodCall> calls = <MethodCall>[];
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(SystemChannels.platform, (call) async {
            calls.add(call);
            return null;
          });

      await tester.pumpWidget(
        buildTestScaffold(
          config: const ScrollResponsiveConfig(
            thresholds: ScrollThresholdConfig(statusBarHideOffset: 50.0),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Scroll down to hide status bar
      await tester.drag(find.text('List item #0'), const Offset(0.0, -100.0));
      await tester.pumpAndSettle();

      calls.clear();

      // Replace widget to trigger dispose()
      await tester.pumpWidget(const MaterialApp(home: SizedBox()));
      await tester.pumpAndSettle();

      // Verify restore was called
      expect(calls, isNotEmpty);

      StatusBarManager.resetDebugOverrides();
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(SystemChannels.platform, null);
    });

    testWidgets('handles route transitions seamlessly via RouteObserver', (
      tester,
    ) async {
      StatusBarManager.debugOverrideSupportedPlatform = true;
      final routeObserver = RouteObserver<ModalRoute<void>>();

      await tester.pumpWidget(
        buildTestScaffold(
          routeObserver: routeObserver,
          config: const ScrollResponsiveConfig(
            thresholds: ScrollThresholdConfig(
              statusBarHideOffset: 50.0,
              statusBarShowOffset: 20.0,
            ),
            statusBar: StatusBarConfig(restoreOnRouteTransition: true),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Scroll down past threshold
      await tester.drag(find.text('List item #0'), const Offset(0.0, -100.0));
      await tester.pumpAndSettle();

      final BuildContext context = tester.element(
        find.byType(ScrollResponsiveScaffold),
      );

      // Push a new route on top
      Navigator.push<void>(
        context,
        MaterialPageRoute(
          builder: (context) => const Scaffold(body: Text('New Screen Route')),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('New Screen Route'), findsOneWidget);

      // Pop back to original screen
      Navigator.pop(tester.element(find.text('New Screen Route')));
      await tester.pumpAndSettle();

      expect(find.byType(ScrollResponsiveScaffold), findsOneWidget);

      StatusBarManager.resetDebugOverrides();
    });
  });
}
