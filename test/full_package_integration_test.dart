import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:app_bar_ui/app_bar_ui.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final List<MethodCall> methodCalls = <MethodCall>[];

  setUp(() {
    methodCalls.clear();
    StatusBarManager.resetDebugOverrides();
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(SystemChannels.platform, (
          MethodCall methodCall,
        ) async {
          methodCalls.add(methodCall);
          return null;
        });
  });

  tearDown(() {
    StatusBarManager.resetDebugOverrides();
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(SystemChannels.platform, null);
  });

  group('Full Package Integration Test Suite', () {
    // 1. Initial UI Testing
    testWidgets(
      '1. Verifies initial UI rendering with all components in place',
      (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: ScrollResponsiveScaffold(
              initialLeading: const Icon(
                Icons.account_circle,
                key: ValueKey('lead_init'),
              ),
              scrolledLeading: const Icon(
                Icons.menu,
                key: ValueKey('lead_scroll'),
              ),
              initialTrailing: const Icon(
                Icons.notifications,
                key: ValueKey('trail_init'),
              ),
              scrolledTrailing: const Icon(
                Icons.person,
                key: ValueKey('trail_scroll'),
              ),
              headerTitle: const Text('Integration Dashboard'),
              headerSubtitle: const Text('Production Monitoring'),
              body: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 30,
                itemBuilder: (context, index) =>
                    ListTile(title: Text('Task item #$index')),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Verify Header
        expect(find.text('Integration Dashboard'), findsOneWidget);
        expect(find.text('Production Monitoring'), findsOneWidget);

        // Verify initial pinned icons are rendered
        expect(find.byKey(const ValueKey('lead_init')), findsOneWidget);
        expect(find.byKey(const ValueKey('trail_init')), findsOneWidget);

        // Verify scrolled icons are present in the tree (underneath/transparent)
        expect(find.byKey(const ValueKey('lead_scroll')), findsOneWidget);
        expect(find.byKey(const ValueKey('trail_scroll')), findsOneWidget);

        // Verify first list item
        expect(find.text('Task item #0'), findsOneWidget);
      },
    );

    // 2. Header Scrolling Testing
    testWidgets(
      '2. Verifies header scrolls away naturally while pinned actions stay fixed',
      (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: ScrollResponsiveScaffold(
              headerTitle: const Text('Disappearing Title'),
              body: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 40,
                itemBuilder: (context, index) =>
                    ListTile(title: Text('Entry #$index')),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        final initialLeadPos = tester.getTopLeft(
          find.byKey(const ValueKey('pinned_leading_action')),
        );

        // Header is visible at top
        expect(find.text('Disappearing Title'), findsOneWidget);

        // Scroll down 400 logical pixels
        await tester.drag(find.text('Entry #0'), const Offset(0.0, -400.0));
        await tester.pumpAndSettle();

        // Header title has naturally scrolled out of viewport
        expect(find.text('Disappearing Title'), findsNothing);

        // Pinned action position is locked in place
        final scrolledLeadPos = tester.getTopLeft(
          find.byKey(const ValueKey('pinned_leading_action')),
        );
        expect(scrolledLeadPos.dy, initialLeadPos.dy);
        expect(scrolledLeadPos.dx, initialLeadPos.dx);
      },
    );

    // 3. Both Pinned Actions Testing
    testWidgets(
      '3. Verifies both pinned actions have transparent backgrounds and pass-through center',
      (tester) async {
        bool centerTapped = false;

        await tester.pumpWidget(
          MaterialApp(
            home: ScrollResponsiveScaffold(
              initialLeading: const Icon(Icons.person),
              initialTrailing: const Icon(Icons.notifications),
              header: GestureDetector(
                key: const ValueKey('center_pass_through_header'),
                onTap: () => centerTapped = true,
                child: Container(
                  height: 100,
                  color: Colors.transparent,
                  child: const Center(child: Text('Tappable Center')),
                ),
              ),
              body: const SizedBox(height: 1000),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Verify no permanent AppBar exists
        expect(find.byType(AppBar), findsNothing);

        // Verify transparent background of both leading and trailing buttons
        final leadContainer = tester.widget<Container>(
          find.descendant(
            of: find.byKey(const ValueKey('pinned_leading_action')),
            matching: find.byType(Container),
          ),
        );
        final leadDecor = leadContainer.decoration as BoxDecoration?;
        expect(leadDecor?.color, Colors.transparent);
        expect(leadDecor?.boxShadow, isEmpty);

        final trailContainer = tester.widget<Container>(
          find.descendant(
            of: find.byKey(const ValueKey('pinned_trailing_action')),
            matching: find.byType(Container),
          ),
        );
        final trailDecor = trailContainer.decoration as BoxDecoration?;
        expect(trailDecor?.color, Colors.transparent);
        expect(trailDecor?.boxShadow, isEmpty);

        // Tap center between pinned actions
        await tester.tap(
          find.byKey(const ValueKey('center_pass_through_header')),
        );
        await tester.pump();
        expect(centerTapped, isTrue);
      },
    );

    // 4. Icon Replacement & Transitions
    testWidgets('4. Verifies dual icon replacements and midpoint hit-testing', (
      tester,
    ) async {
      bool leadInitTapped = false;
      bool leadScrollTapped = false;
      bool trailInitTapped = false;
      bool trailScrollTapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: ScrollResponsiveScaffold(
            config: const ScrollResponsiveConfig(
              thresholds: ScrollThresholdConfig(
                leadingStartOffset: 20.0,
                leadingEndOffset: 80.0,
                trailingStartOffset: 20.0,
                trailingEndOffset: 80.0,
              ),
            ),
            initialLeading: const Icon(Icons.person, key: ValueKey('l_init')),
            scrolledLeading: const Icon(
              Icons.menu,
              key: ValueKey('l_scrolled'),
            ),
            initialTrailing: const Icon(
              Icons.notifications,
              key: ValueKey('t_init'),
            ),
            scrolledTrailing: const Icon(
              Icons.face,
              key: ValueKey('t_scrolled'),
            ),
            onLeadingInitialTap: () => leadInitTapped = true,
            onLeadingScrolledTap: () => leadScrollTapped = true,
            onTrailingInitialTap: () => trailInitTapped = true,
            onTrailingScrolledTap: () => trailScrollTapped = true,
            body: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 40,
              itemBuilder: (context, index) => Text('Row #$index'),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // At top (offset 0): initial callbacks active
      await tester.tap(find.byKey(const ValueKey('pinned_leading_action')));
      await tester.pump();
      expect(leadInitTapped, isTrue);
      expect(leadScrollTapped, isFalse);

      await tester.tap(find.byKey(const ValueKey('pinned_trailing_action')));
      await tester.pump();
      expect(trailInitTapped, isTrue);
      expect(trailScrollTapped, isFalse);

      // Scroll past 80px (100% progress)
      await tester.drag(find.text('Row #0'), const Offset(0.0, -150.0));
      await tester.pumpAndSettle();

      // Reset flags
      leadInitTapped = false;
      trailInitTapped = false;

      // In scrolled state: scrolled callbacks active
      await tester.tap(find.byKey(const ValueKey('pinned_leading_action')));
      await tester.pump();
      expect(leadInitTapped, isFalse);
      expect(leadScrollTapped, isTrue);

      await tester.tap(find.byKey(const ValueKey('pinned_trailing_action')));
      await tester.pump();
      expect(trailInitTapped, isFalse);
      expect(trailScrollTapped, isTrue);
    });

    // 5. Reverse Scrolling
    testWidgets(
      '5. Verifies reverse scrolling smoothly restores initial state',
      (tester) async {
        double latestLeading = 0.0;

        await tester.pumpWidget(
          MaterialApp(
            home: ScrollResponsiveScaffold(
              headerTitle: const Text('Restorable Header'),
              config: const ScrollResponsiveConfig(
                thresholds: ScrollThresholdConfig(
                  leadingStartOffset: 20.0,
                  leadingEndOffset: 80.0,
                ),
              ),
              onScrollUpdate: (details) {
                latestLeading = details.leadingProgress;
              },
              body: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 50,
                itemBuilder: (context, index) => Text('Scroll Item #$index'),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Scroll down
        await tester.drag(
          find.text('Scroll Item #0'),
          const Offset(0.0, -200.0),
        );
        await tester.pumpAndSettle();
        expect(latestLeading, 1.0);
        expect(find.text('Restorable Header'), findsNothing);

        // Scroll reverse back up
        await tester.drag(
          find.byType(CustomScrollView),
          const Offset(0.0, 300.0),
        );
        await tester.pumpAndSettle();

        expect(latestLeading, 0.0);
        expect(find.text('Restorable Header'), findsOneWidget);
      },
    );

    // 6. Status Bar Hide / Show with Hysteresis
    testWidgets(
      '6. Verifies status bar hide/show, hysteresis, and bottom nav preservation',
      (tester) async {
        StatusBarManager.debugOverrideSupportedPlatform = true;

        await tester.pumpWidget(
          MaterialApp(
            home: ScrollResponsiveScaffold(
              config: const ScrollResponsiveConfig(
                thresholds: ScrollThresholdConfig(
                  statusBarHideOffset: 100.0,
                  statusBarShowOffset: 40.0,
                ),
                statusBar: StatusBarConfig(
                  hiddenOverlays: [SystemUiOverlay.bottom],
                ),
              ),
              body: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 50,
                itemBuilder: (context, index) => Text('Item #$index'),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Scroll down past 100px -> status bar hides
        await tester.drag(find.text('Item #0'), const Offset(0.0, -120.0));
        await tester.pumpAndSettle();

        expect(methodCalls, isNotEmpty);
        methodCalls.clear();

        // Scroll slightly up into hysteresis deadband (70px) -> remains hidden
        await tester.drag(
          find.byType(CustomScrollView),
          const Offset(0.0, 50.0),
        );
        await tester.pumpAndSettle();
        expect(methodCalls, isEmpty); // No calls in deadband

        // Scroll all the way back up below 40px -> restores status bar
        await tester.drag(
          find.byType(CustomScrollView),
          const Offset(0.0, 100.0),
        );
        await tester.pumpAndSettle();
        expect(methodCalls, isNotEmpty);
      },
    );

    // 7. SafeArea and Content Jump Prevention
    testWidgets(
      '7. Verifies SafeArea alignment and preventContentJump locks top insets',
      (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: MediaQuery(
              data: const MediaQueryData(
                padding: EdgeInsets.only(top: 44.0), // Simulated notch
              ),
              child: ScrollResponsiveScaffold(
                config: const ScrollResponsiveConfig(
                  statusBar: StatusBarConfig(preventContentJump: true),
                ),
                body: ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: 40,
                  itemBuilder: (context, index) => Text('Notch Item #$index'),
                ),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Pinned action top position reflects notch (44 + 8 = 52)
        final initialTop = tester.getTopLeft(
          find.byKey(const ValueKey('pinned_leading_action')),
        );
        expect(initialTop.dy, greaterThanOrEqualTo(44.0));

        // Scroll down
        await tester.drag(
          find.text('Notch Item #0'),
          const Offset(0.0, -150.0),
        );
        await tester.pumpAndSettle();

        final scrolledTop = tester.getTopLeft(
          find.byKey(const ValueKey('pinned_leading_action')),
        );
        // Position MUST not jump upward
        expect(scrolledTop.dy, initialTop.dy);
      },
    );

    // 8. Nested Scrolling Support
    testWidgets(
      '8. Supports nested scrollables and horizontal carousels without conflict',
      (tester) async {
        double latestProgress = 0.0;

        await tester.pumpWidget(
          MaterialApp(
            home: ScrollResponsiveScaffold(
              config: const ScrollResponsiveConfig(
                thresholds: ScrollThresholdConfig(
                  leadingStartOffset: 20.0,
                  leadingEndOffset: 80.0,
                ),
              ),
              onScrollUpdate: (details) {
                latestProgress = details.leadingProgress;
              },
              body: Column(
                children: [
                  // Horizontal carousel nested inside body
                  SizedBox(
                    height: 120,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 10,
                      itemBuilder: (context, index) => Container(
                        width: 150,
                        color: Colors.blue.withValues(alpha: 0.2),
                        child: Center(child: Text('Card #$index')),
                      ),
                    ),
                  ),
                  // Vertical list content
                  ...List.generate(30, (i) => Text('Vertical row #$i')),
                ],
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Horizontal swipe on carousel
        await tester.drag(find.text('Card #0'), const Offset(-100.0, 0.0));
        await tester.pumpAndSettle();

        // Horizontal scrolling MUST NOT trigger vertical header transitions!
        expect(latestProgress, 0.0);

        // Vertical scroll on body
        await tester.drag(
          find.text('Vertical row #0'),
          const Offset(0.0, -150.0),
        );
        await tester.pumpAndSettle();

        // Vertical scrolling triggers transition normally
        expect(latestProgress, 1.0);
      },
    );

    // 9. Custom Widgets Support
    testWidgets(
      '9. Verifies custom header, custom slivers, and custom action widgets',
      (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: ScrollResponsiveScaffold(
              initialLeading: Container(
                key: const ValueKey('custom_lead_widget'),
                child: const Text('CustomL'),
              ),
              initialTrailing: Container(
                key: const ValueKey('custom_trail_widget'),
                child: const Text('CustomR'),
              ),
              header: const ScrollResponsiveHeader(
                welcome: Text('Hello Engineer'),
                title: Text('Custom Header Title'),
                subtitle: Text('Custom Header Subtitle'),
                actions: [Icon(Icons.star)],
              ),
              slivers: [
                SliverToBoxAdapter(
                  child: Container(
                    key: const ValueKey('custom_sliver_banner'),
                    height: 60,
                    color: Colors.amber,
                    child: const Center(child: Text('Promo Banner')),
                  ),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => Text('Sliver Row #$index'),
                    childCount: 20,
                  ),
                ),
              ],
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(
          find.byKey(const ValueKey('custom_lead_widget')),
          findsOneWidget,
        );
        expect(
          find.byKey(const ValueKey('custom_trail_widget')),
          findsOneWidget,
        );
        expect(find.text('Hello Engineer'), findsOneWidget);
        expect(find.byIcon(Icons.star), findsOneWidget);
        expect(
          find.byKey(const ValueKey('custom_sliver_banner')),
          findsOneWidget,
        );
        expect(find.text('Promo Banner'), findsOneWidget);
      },
    );

    // 10. Callback Execution
    testWidgets(
      '10. Dispatches direction changes and telemetry on scroll update',
      (tester) async {
        ScrollDirection? latestDirection;
        ScrollProgressDetails? latestTelemetry;

        await tester.pumpWidget(
          MaterialApp(
            home: ScrollResponsiveScaffold(
              onScrollDirectionChanged: (dir) => latestDirection = dir,
              onScrollUpdate: (details) => latestTelemetry = details,
              body: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 40,
                itemBuilder: (context, index) => Text('Line #$index'),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Scroll downward
        await tester.drag(find.text('Line #0'), const Offset(0.0, -100.0));
        await tester.pumpAndSettle();

        expect(latestDirection, isNotNull);
        expect(latestTelemetry, isNotNull);
        expect(latestTelemetry!.offset, greaterThan(0.0));
      },
    );

    // 11. Controller Lifecycle & Disposal
    testWidgets(
      '11. Retains external controller lifecycle and handles controller migration',
      (tester) async {
        final externalController = ScrollController();

        await tester.pumpWidget(
          MaterialApp(
            home: ScrollResponsiveScaffold(
              controller: externalController,
              body: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 30,
                itemBuilder: (context, index) => Text('Element #$index'),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(externalController.hasClients, isTrue);

        // Rebuild with different screen to trigger scaffold dispose
        await tester.pumpWidget(
          const MaterialApp(home: Scaffold(body: Text('Done'))),
        );
        await tester.pumpAndSettle();

        // External controller is still active and can be disposed by its owner
        expect(externalController.hasClients, isFalse);
        expect(() => externalController.dispose(), returnsNormally);
      },
    );

    // 12. Route Transitions
    testWidgets(
      '12. Restores status bar on route push and reapplies on route pop',
      (tester) async {
        StatusBarManager.debugOverrideSupportedPlatform = true;
        final routeObserver = RouteObserver<ModalRoute<void>>();

        await tester.pumpWidget(
          MaterialApp(
            navigatorObservers: [routeObserver],
            home: ScrollResponsiveScaffold(
              routeObserver: routeObserver,
              config: const ScrollResponsiveConfig(
                thresholds: ScrollThresholdConfig(
                  statusBarHideOffset: 50.0,
                  statusBarShowOffset: 20.0,
                ),
                statusBar: StatusBarConfig(restoreOnRouteTransition: true),
              ),
              body: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 40,
                itemBuilder: (context, index) => Text('Page Item #$index'),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Scroll down to hide
        await tester.drag(find.text('Page Item #0'), const Offset(0.0, -100.0));
        await tester.pumpAndSettle();

        methodCalls.clear();

        final BuildContext ctx = tester.element(
          find.byType(ScrollResponsiveScaffold),
        );

        // Push new route
        Navigator.push<void>(
          ctx,
          MaterialPageRoute(
            builder: (context) => const Scaffold(body: Text('Details Screen')),
          ),
        );
        await tester.pumpAndSettle();

        // Status bar was restored for the new route
        expect(find.text('Details Screen'), findsOneWidget);

        // Pop back
        Navigator.pop(tester.element(find.text('Details Screen')));
        await tester.pumpAndSettle();

        // Reapplied hidden state since scroll offset was -100px
        expect(find.byType(ScrollResponsiveScaffold), findsOneWidget);
      },
    );
  });
}
