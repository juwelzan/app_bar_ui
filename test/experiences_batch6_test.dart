import 'package:app_bar_ui/app_bar_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Batch 6: Genuinely Different Animated AppBar Experiences (26-30)', () {
    testWidgets(
      'Style 26: BreadcrumbTransformHeaderWidget collapses intermediate crumbs into ellipsis dropdown',
      (WidgetTester tester) async {
        int selectedIndex = -1;
        final nodes = [
          const BreadcrumbNode(label: 'Home', icon: Icons.home),
          const BreadcrumbNode(label: 'Infrastructure'),
          const BreadcrumbNode(label: 'Kubernetes'),
          const BreadcrumbNode(label: 'Production Pods'),
        ];

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: CustomScrollView(
                slivers: [
                  BreadcrumbTransformHeaderWidget(
                    title: const Text('Pod Details'),
                    items: nodes,
                    onNodeSelected: (idx) => selectedIndex = idx,
                    config: const BreadcrumbTransformConfig(
                      expandedHeight: 130.0,
                      collapsedHeight: 56.0,
                      collapseThreshold: 80.0,
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => ListTile(title: Text('Pod Metric $index')),
                      childCount: 30,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );

        // Expanded state: all breadcrumb labels and title are visible
        expect(find.text('Pod Details'), findsOneWidget);
        expect(find.text('Home'), findsOneWidget);
        expect(find.text('Infrastructure'), findsOneWidget);
        expect(find.text('Kubernetes'), findsOneWidget);
        expect(find.text('Production Pods'), findsOneWidget);

        // Scroll down to collapse intermediate crumbs into ellipsis
        await tester.drag(find.byType(CustomScrollView), const Offset(0.0, -100.0));
        await tester.pumpAndSettle();

        // Intermediate nodes collapsed into '...'
        expect(find.text('...'), findsOneWidget);
        expect(find.text('Home'), findsOneWidget);
        expect(find.text('Production Pods'), findsOneWidget);

        // Tap home crumb
        await tester.tap(find.text('Home'));
        await tester.pumpAndSettle();
        expect(selectedIndex, 0);
      },
    );

    testWidgets(
      'Style 27: CardToHeaderMorphHeaderWidget morphs floating card into flush top bar',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: CustomScrollView(
                slivers: [
                  CardToHeaderMorphHeaderWidget(
                    heroCardContent: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text('Hero Launch Card', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0)),
                          const SizedBox(height: 4.0),
                          const Text('Floating inset card morphing flush on scroll'),
                        ],
                      ),
                    ),
                    dockedToolbar: const Row(
                      children: [
                        Icon(Icons.rocket_launch, size: 20.0),
                        SizedBox(width: 8.0),
                        Text('Launch Mission Active', style: TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                    config: const CardToHeaderMorphConfig(
                      cardExpandedHeight: 160.0,
                      dockedHeight: 60.0,
                      morphThreshold: 75.0,
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => ListTile(title: Text('Mission Log $index')),
                      childCount: 30,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );

        // Initial expanded state: Hero card text visible
        expect(find.text('Hero Launch Card'), findsOneWidget);
        expect(find.text('Floating inset card morphing flush on scroll'), findsOneWidget);

        // Scroll down to drive card flush to the top
        await tester.drag(find.byType(CustomScrollView), const Offset(0.0, -120.0));
        await tester.pumpAndSettle();

        // Docked toolbar content is visible
        expect(find.text('Launch Mission Active'), findsOneWidget);
      },
    );

    testWidgets(
      'Style 28: RevealFromEdgeHeaderWidget toggles visibility programmatically and on scroll',
      (WidgetTester tester) async {
        final key = GlobalKey<RevealFromEdgeHeaderWidgetState>();

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Column(
                children: [
                  RevealFromEdgeHeaderWidget(
                    key: key,
                    child: const Center(
                      child: Text('Edge Emerging Navigation'),
                    ),
                  ),
                  const Expanded(
                    child: Center(child: Text('Page Content Body')),
                  ),
                ],
              ),
            ),
          ),
        );

        // Initial state is visible
        expect(find.text('Edge Emerging Navigation'), findsOneWidget);
        expect(key.currentState?.isVisible, isTrue);

        // Programmatically hide
        key.currentState?.hide();
        await tester.pumpAndSettle();
        expect(key.currentState?.isVisible, isFalse);

        // Programmatically show
        key.currentState?.show();
        await tester.pumpAndSettle();
        expect(key.currentState?.isVisible, isTrue);
      },
    );

    testWidgets(
      'Style 29: GestureDrivenDragExpansionHeaderWidget expands canvas on vertical drag pull',
      (WidgetTester tester) async {
        final key = GlobalKey<GestureDrivenDragExpansionHeaderWidgetState>();

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Column(
                children: [
                  GestureDrivenDragExpansionHeaderWidget(
                    key: key,
                    restingContent: const Text('Touch & Drag Pull Handle'),
                    expandedCanvasContent: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Expanded Control Canvas'),
                        Text('Secondary Quick Utilities Panel'),
                      ],
                    ),
                    config: const GestureDrivenDragExpansionConfig(
                      restingHeight: 70.0,
                      maxDragExpandedHeight: 220.0,
                      latchThreshold: 130.0,
                    ),
                  ),
                  const Expanded(child: Center(child: Text('Body'))),
                ],
              ),
            ),
          ),
        );

        // Initial resting state
        expect(find.text('Touch & Drag Pull Handle'), findsOneWidget);
        expect(key.currentState?.isLatched, isFalse);

        // Programmatic expand
        key.currentState?.expand();
        await tester.pumpAndSettle();
        expect(key.currentState?.isLatched, isTrue);
        expect(find.text('Expanded Control Canvas'), findsOneWidget);

        // Programmatic collapse
        key.currentState?.collapse();
        await tester.pumpAndSettle();
        expect(key.currentState?.isLatched, isFalse);
      },
    );

    testWidgets(
      'Style 30: AdaptiveMultiDeviceHeaderWidget adapts cleanly across Mobile, Tablet, and Desktop',
      (WidgetTester tester) async {
        // 1. Mobile screen (< 600)
        tester.view.physicalSize = const Size(420, 800);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: AdaptiveMultiDeviceHeaderWidget(
                title: const Text('Responsive Cloud Hub'),
                searchBar: const Text('Search Bar Input'),
                tabs: const [Text('Overview Tab'), Text('Metrics Tab')],
                actions: [
                  IconButton(icon: const Icon(Icons.settings), onPressed: () {}),
                ],
                avatar: const Icon(Icons.account_circle),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Mobile mode: drawer menu icon is visible, title is visible
        expect(find.byIcon(Icons.menu), findsOneWidget);
        expect(find.text('Responsive Cloud Hub'), findsOneWidget);

        // 2. Desktop screen (> 900)
        tester.view.physicalSize = const Size(1200, 800);
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: AdaptiveMultiDeviceHeaderWidget(
                title: const Text('Responsive Cloud Hub'),
                searchBar: const Text('Search Bar Input'),
                tabs: const [Text('Overview Tab'), Text('Metrics Tab')],
                actions: [
                  IconButton(icon: const Icon(Icons.settings), onPressed: () {}),
                ],
                avatar: const Icon(Icons.account_circle),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Desktop mode: 3-column with Search Bar and Navigation Tabs
        expect(find.text('Responsive Cloud Hub'), findsOneWidget);
        expect(find.text('Search Bar Input'), findsOneWidget);
        expect(find.text('Overview Tab'), findsOneWidget);
      },
    );

    testWidgets(
      'Batch 6 Reduced motion mode provides accessible fallbacks without layout crashes',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: MediaQuery(
              data: MediaQueryData.fromView(tester.view).copyWith(disableAnimations: true),
              child: Scaffold(
                body: CustomScrollView(
                  slivers: [
                    BreadcrumbTransformHeaderWidget(
                      title: const Text('Accessible Breadcrumbs'),
                      items: const [
                        BreadcrumbNode(label: 'Root'),
                        BreadcrumbNode(label: 'Leaf'),
                      ],
                      onNodeSelected: (_) {},
                    ),
                    CardToHeaderMorphHeaderWidget(
                      heroCardContent: const Text('Card Content'),
                      dockedToolbar: const Text('Toolbar Content'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );

        expect(find.text('Accessible Breadcrumbs'), findsOneWidget);
        expect(find.text('Card Content'), findsOneWidget);

        await tester.drag(find.byType(CustomScrollView), const Offset(0.0, -100.0));
        await tester.pumpAndSettle();

        expect(tester.takeException(), isNull);
      },
    );
  });
}

