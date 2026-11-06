import 'package:app_bar_ui/app_bar_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Batch 8: Genuinely Different Animated AppBar Experiences (36-40)', () {
    testWidgets(
      'Style 36: MagneticAnchorSnapHeaderWidget snaps floating badge and title into docked anchor',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: CustomScrollView(
                slivers: [
                  MagneticAnchorSnapHeaderWidget(
                    heroBadge: const CircleAvatar(
                      radius: 26.0,
                      child: Icon(Icons.flash_on),
                    ),
                    heroTitle: const Text('Quantum Kinetic Grid'),
                    heroSubtitle: const Text('Magnetic Lattice Sector 9'),
                    dockedLeading: const BackButton(),
                    dockedActions: [
                      IconButton(icon: const Icon(Icons.tune), onPressed: () {}),
                    ],
                    config: const MagneticAnchorSnapConfig(
                      expandedHeight: 210.0,
                      collapsedHeight: 64.0,
                      snapThreshold: 100.0,
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => ListTile(title: Text('Flux Line $index')),
                      childCount: 25,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );

        // Expanded state
        expect(find.text('Quantum Kinetic Grid'), findsOneWidget);
        expect(find.text('Magnetic Lattice Sector 9'), findsOneWidget);
        expect(find.byIcon(Icons.flash_on), findsOneWidget);

        // Scroll down past snap threshold
        await tester.drag(find.byType(CustomScrollView), const Offset(0.0, -150.0));
        await tester.pumpAndSettle();

        expect(find.text('Quantum Kinetic Grid'), findsOneWidget);
        expect(find.byIcon(Icons.flash_on), findsOneWidget);
        expect(tester.takeException(), isNull);
      },
    );

    testWidgets(
      'Style 37: CascadingProgressivePinHeaderWidget locks title, search, and actions at cascading milestones',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: CustomScrollView(
                slivers: [
                  CascadingProgressivePinHeaderWidget(
                    title: const Text('Security Ops Center'),
                    searchBar: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      color: Colors.black12,
                      child: const Row(
                        children: [
                          Icon(Icons.search, size: 18.0),
                          SizedBox(width: 4.0),
                          Text('Search firewalls...'),
                        ],
                      ),
                    ),
                    statusPills: const Row(
                      children: [
                        Chip(label: Text('All Clear')),
                        SizedBox(width: 6.0),
                        Chip(label: Text('Threats: 0')),
                      ],
                    ),
                    config: const CascadingProgressivePinConfig(
                      expandedHeight: 240.0,
                      collapsedHeight: 64.0,
                      titlePinOffset: 40.0,
                      searchPinOffset: 80.0,
                      actionsPinOffset: 120.0,
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => ListTile(title: Text('Security Event $index')),
                      childCount: 30,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );

        // Expanded state: all elements present
        expect(find.text('Security Ops Center'), findsOneWidget);
        expect(find.text('Search firewalls...'), findsOneWidget);
        expect(find.text('All Clear'), findsOneWidget);

        // Scroll past milestone 1 (title pins)
        await tester.drag(find.byType(CustomScrollView), const Offset(0.0, -50.0));
        await tester.pumpAndSettle();
        expect(find.text('Security Ops Center'), findsOneWidget);

        // Scroll past milestone 2 (search pins)
        await tester.drag(find.byType(CustomScrollView), const Offset(0.0, -60.0));
        await tester.pumpAndSettle();
        expect(find.text('Search firewalls...'), findsOneWidget);

        // Scroll past milestone 3 (all locked)
        await tester.drag(find.byType(CustomScrollView), const Offset(0.0, -80.0));
        await tester.pumpAndSettle();
        expect(find.text('Security Ops Center'), findsOneWidget);
        expect(tester.takeException(), isNull);
      },
    );

    testWidgets(
      'Style 38: DualMode3DCrossfadeHeaderWidget performs 3D perspective flip between modes',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: CustomScrollView(
                slivers: [
                  DualMode3DCrossfadeHeaderWidget(
                    primaryMode: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.audiotrack, size: 40.0),
                        SizedBox(height: 6.0),
                        Text('Symphony in D Minor - Allegro'),
                        Text('Berlin Philharmonic Orchestra'),
                      ],
                    ),
                    secondaryMode: const Row(
                      children: [
                        Icon(Icons.play_arrow),
                        SizedBox(width: 8.0),
                        Text('Now Playing: Allegro'),
                        Spacer(),
                        Icon(Icons.skip_next),
                      ],
                    ),
                    config: const DualMode3DCrossfadeConfig(
                      expandedHeight: 220.0,
                      collapsedHeight: 64.0,
                      transitionThreshold: 100.0,
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => ListTile(title: Text('Track Item $index')),
                      childCount: 25,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );

        // Primary mode active initially
        expect(find.text('Symphony in D Minor - Allegro'), findsOneWidget);

        // Scroll down to flip 180 degrees into secondary compact mode
        await tester.drag(find.byType(CustomScrollView), const Offset(0.0, -180.0));
        await tester.pumpAndSettle();

        expect(find.text('Now Playing: Allegro'), findsOneWidget);
        expect(tester.takeException(), isNull);
      },
    );

    testWidgets(
      'Style 39: RadialCircularClipperRevealHeaderWidget contracts circular mask into compact bar',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: CustomScrollView(
                slivers: [
                  RadialCircularClipperRevealHeaderWidget(
                    compactBar: const Row(
                      children: [
                        Icon(Icons.menu),
                        SizedBox(width: 8.0),
                        Text('Global Navigation Dock'),
                      ],
                    ),
                    expandedCanvas: const Center(
                      child: Text('Expansive Circular Discovery Canvas'),
                    ),
                    config: const RadialCircularClipperRevealConfig(
                      expandedHeight: 220.0,
                      collapsedHeight: 60.0,
                      revealThreshold: 120.0,
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => ListTile(title: Text('Catalogue Entry $index')),
                      childCount: 25,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );

        // Initially expanded canvas visible
        expect(find.text('Expansive Circular Discovery Canvas'), findsOneWidget);

        // Scroll down to collapse circular aperture into compact bar
        await tester.drag(find.byType(CustomScrollView), const Offset(0.0, -160.0));
        await tester.pumpAndSettle();

        expect(find.text('Global Navigation Dock'), findsOneWidget);
        expect(tester.takeException(), isNull);
      },
    );

    testWidgets(
      'Style 40: DepthOverlapStackedPanelHeaderWidget slides stacked panels forward sequentially',
      (WidgetTester tester) async {
        final cards = [
          const StackedPanelCardItem(
            leadingIcon: Icons.account_balance_wallet,
            title: Text('Primary Cash Account'),
            content: Text('\$48,920.50 Available'),
            color: Colors.indigo,
          ),
          const StackedPanelCardItem(
            leadingIcon: Icons.trending_up,
            title: Text('Growth Index Fund'),
            content: Text('+\$3,410.20 This Month'),
            color: Colors.deepPurple,
          ),
          const StackedPanelCardItem(
            leadingIcon: Icons.security,
            title: Text('Vault Reserve'),
            content: Text('Locked 120-Day Bond'),
            color: Colors.blueGrey,
          ),
        ];

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: CustomScrollView(
                slivers: [
                  DepthOverlapStackedPanelHeaderWidget(
                    cards: cards,
                    actions: [
                      IconButton(icon: const Icon(Icons.add), onPressed: () {}),
                    ],
                    config: const DepthOverlapStackedPanelConfig(
                      expandedHeight: 240.0,
                      collapsedHeight: 64.0,
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => ListTile(title: Text('Transaction $index')),
                      childCount: 25,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );

        // Expanded state: All 3 cards present
        expect(find.text('Primary Cash Account'), findsOneWidget);
        expect(find.text('Growth Index Fund'), findsOneWidget);
        expect(find.text('Vault Reserve'), findsOneWidget);

        // Scroll down to slide cards forward and dock front card
        await tester.drag(find.byType(CustomScrollView), const Offset(0.0, -170.0));
        await tester.pumpAndSettle();

        expect(find.text('Primary Cash Account'), findsOneWidget);
        expect(tester.takeException(), isNull);
      },
    );

    testWidgets(
      'Batch 8: Reduced motion mode provides accessible fallbacks without layout crashes',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: MediaQuery(
              data: const MediaQueryData(disableAnimations: true),
              child: Scaffold(
                body: CustomScrollView(
                  slivers: [
                    const MagneticAnchorSnapHeaderWidget(
                      heroBadge: Icon(Icons.bolt),
                      heroTitle: Text('Accessible Magnetic'),
                    ),
                    const CascadingProgressivePinHeaderWidget(
                      title: Text('Accessible Pin'),
                      searchBar: Text('Search'),
                      statusPills: Text('Pills'),
                    ),
                    const DualMode3DCrossfadeHeaderWidget(
                      primaryMode: Text('Accessible Primary'),
                      secondaryMode: Text('Accessible Secondary'),
                    ),
                    const RadialCircularClipperRevealHeaderWidget(
                      compactBar: Text('Accessible Compact'),
                      expandedCanvas: Text('Accessible Canvas'),
                    ),
                    const DepthOverlapStackedPanelHeaderWidget(
                      cards: [
                        StackedPanelCardItem(
                          title: Text('Accessible Card 1'),
                          content: Text('Card 1 Body'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();
        expect(find.text('Accessible Magnetic'), findsOneWidget);
        expect(find.text('Accessible Pin'), findsOneWidget);
        expect(find.text('Accessible Primary'), findsOneWidget);

        // Scroll down to reveal bottom slivers
        await tester.drag(find.byType(CustomScrollView), const Offset(0.0, -550.0));
        await tester.pumpAndSettle();

        expect(find.text('Accessible Compact'), findsOneWidget);
        expect(find.text('Accessible Card 1'), findsOneWidget);
        expect(tester.takeException(), isNull);
      },
    );
  });
}
