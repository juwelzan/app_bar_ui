import 'package:app_bar_ui/app_bar_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Batch 5: Genuinely Different Animated AppBar Experiences (21-25)', () {
    testWidgets(
      'Style 21: TabTransformHeaderWidget compresses rich cards into slim pinned tab strip',
      (WidgetTester tester) async {
        int selected = 0;
        final tabs = [
          const TabTransformItem(label: 'All Books', icon: Icons.book, subtitle: 'Library catalog'),
          const TabTransformItem(label: 'Tech', icon: Icons.laptop, subtitle: 'Engineering & AI'),
          const TabTransformItem(label: 'Fiction', icon: Icons.auto_stories, badge: 'New'),
        ];

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: StatefulBuilder(
                builder: (context, setState) {
                  return CustomScrollView(
                    physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                    slivers: [
                      TabTransformHeaderWidget(
                        title: const Text('Digital Library'),
                        tabs: tabs,
                        selectedIndex: selected,
                        onTabSelected: (index) {
                          setState(() => selected = index);
                        },
                        config: const TabTransformConfig(
                          expandedHeight: 150.0,
                          collapsedHeight: 56.0,
                          expandedTabHeight: 64.0,
                          compactTabHeight: 40.0,
                          collapseThreshold: 80.0,
                        ),
                      ),
                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) => ListTile(title: Text('Book Item $index')),
                          childCount: 30,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        );

        // Expanded state: rich cards with subtitles visible
        expect(find.text('Digital Library'), findsOneWidget);
        expect(find.text('All Books'), findsOneWidget);
        expect(find.text('Library catalog'), findsOneWidget);
        expect(find.text('New'), findsOneWidget);

        // Scroll down to compress tabs
        await tester.drag(find.byType(CustomScrollView), const Offset(0.0, -100.0));
        await tester.pumpAndSettle();

        // Compressed state: title faded, tabs remain pinned, tapped tab triggers callback
        await tester.tap(find.text('Tech'));
        await tester.pumpAndSettle();
        expect(selected, 1);
      },
    );

    testWidgets(
      'Style 22: AvatarToProfileHeaderWidget glides avatar along arc trajectory into leading slot',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: CustomScrollView(
                slivers: [
                  AvatarToProfileHeaderWidget(
                    avatar: const CircleAvatar(
                      radius: 38.0,
                      backgroundColor: Colors.indigo,
                      child: Icon(Icons.person, color: Colors.white),
                    ),
                    name: const Text('Sarah Connor'),
                    handle: const Text('@sarah_connor'),
                    bio: const Text('Cybernetics Defense Specialist'),
                    leading: IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () {},
                    ),
                    actions: [
                      IconButton(
                        icon: const Icon(Icons.more_vert),
                        onPressed: () {},
                      ),
                    ],
                    config: const AvatarToProfileConfig(
                      expandedHeight: 190.0,
                      collapsedHeight: 60.0,
                      initialAvatarDiameter: 76.0,
                      compactAvatarDiameter: 36.0,
                      collapseThreshold: 100.0,
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => ListTile(title: Text('Activity $index')),
                      childCount: 30,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );

        // Expanded state: Avatar, name, handle, bio all present
        expect(find.text('Sarah Connor'), findsOneWidget);
        expect(find.text('@sarah_connor'), findsOneWidget);
        expect(find.text('Cybernetics Defense Specialist'), findsOneWidget);

        // Scroll down to drive avatar along Bezier arc into compact leading slot
        await tester.drag(find.byType(CustomScrollView), const Offset(0.0, -120.0));
        await tester.pumpAndSettle();

        // Compact state: name is still visible in docked toolbar, bio has faded out
        expect(find.text('Sarah Connor'), findsOneWidget);
        expect(find.text('Cybernetics Defense Specialist'), findsNothing);
      },
    );

    testWidgets(
      'Style 23: ProgressiveDisclosureHeaderWidget reveals search and filter tiers sequentially',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: CustomScrollView(
                slivers: [
                  ProgressiveDisclosureHeaderWidget(
                    title: const Text('Discover Stores'),
                    searchBar: Container(
                      height: 40.0,
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.search, size: 20.0),
                          SizedBox(width: 8.0),
                          Text('Search groceries, bakeries...'),
                        ],
                      ),
                    ),
                    filterRow: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          Chip(label: const Text('Organic')),
                          const SizedBox(width: 8.0),
                          Chip(label: const Text('Nearby')),
                          const SizedBox(width: 8.0),
                          Chip(label: const Text('Open Now')),
                        ],
                      ),
                    ),
                    config: const ProgressiveDisclosureConfig(
                      expandedHeight: 165.0,
                      collapsedHeight: 56.0,
                      stage1Threshold: 45.0,
                      stage2Threshold: 95.0,
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => ListTile(title: Text('Store $index')),
                      childCount: 30,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );

        // Initial state: Title visible
        expect(find.text('Discover Stores'), findsOneWidget);
        expect(find.text('Search groceries, bakeries...'), findsOneWidget);

        // Scroll past Stage 1 and Stage 2
        await tester.drag(find.byType(CustomScrollView), const Offset(0.0, -110.0));
        await tester.pumpAndSettle();

        // Stage 3 pinned filter row is revealed and interactive
        expect(find.text('Organic'), findsOneWidget);
        expect(find.text('Nearby'), findsOneWidget);
      },
    );

    testWidgets(
      'Style 24: SidewaysCollapseHeaderWidget collapses horizontally into compact anchored rail',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: CustomScrollView(
                slivers: [
                  SidewaysCollapseHeaderWidget(
                    expandedContent: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        children: [
                          const Icon(Icons.explore, size: 32.0),
                          const SizedBox(width: 12.0),
                          const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Global Explorer Hub', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0)),
                              Text('1,240 Destinations Online', style: TextStyle(fontSize: 12.0)),
                            ],
                          ),
                          const Spacer(),
                          FilledButton.tonal(
                            onPressed: () {},
                            child: const Text('Explore'),
                          ),
                        ],
                      ),
                    ),
                    compactRailContent: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.explore, size: 24.0),
                        SizedBox(width: 4.0),
                        Text('Hub', style: TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                    config: const SidewaysCollapseConfig(
                      expandedHeight: 120.0,
                      collapsedHeight: 60.0,
                      compactRailWidth: 90.0,
                      collapseThreshold: 90.0,
                      anchorAlignment: Alignment.centerLeft,
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => ListTile(title: Text('Destination $index')),
                      childCount: 30,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );

        // Expanded state: Full width explorer hub banner
        expect(find.text('Global Explorer Hub'), findsOneWidget);
        expect(find.text('1,240 Destinations Online'), findsOneWidget);

        // Scroll down to collapse horizontally
        await tester.drag(find.byType(CustomScrollView), const Offset(0.0, -110.0));
        await tester.pumpAndSettle();

        // Compact anchored rail pill is rendered
        expect(find.text('Hub'), findsOneWidget);
      },
    );

    testWidgets(
      'Style 25: ExpandingSearchHeaderWidget expands search bar and takes user input',
      (WidgetTester tester) async {
        String searchQuery = '';
        final key = GlobalKey<ExpandingSearchHeaderWidgetState>();

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: CustomScrollView(
                slivers: [
                  ExpandingSearchHeaderWidget(
                    key: key,
                    title: const Text('Marketplace Catalog'),
                    subtitle: const Text('Browse verified vendors'),
                    hintText: 'Search products...',
                    onSearchChanged: (q) => searchQuery = q,
                    config: const ExpandingSearchConfig(
                      expandedHeight: 130.0,
                      collapsedHeight: 60.0,
                      searchBarHeight: 46.0,
                      expandThreshold: 70.0,
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => ListTile(title: Text('Vendor $index')),
                      childCount: 30,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );

        // Resting state: Title & subtitle visible, search icon button present
        expect(find.text('Marketplace Catalog'), findsOneWidget);
        expect(find.text('Browse verified vendors'), findsOneWidget);
        expect(find.byTooltip('Search'), findsOneWidget);

        // Tap search icon to expand search bar
        await tester.tap(find.byTooltip('Search'));
        await tester.pumpAndSettle();

        // Full search input field is now active
        expect(find.text('Search products...'), findsOneWidget);

        // Enter search text
        await tester.enterText(find.byType(TextField), 'Flutter');
        await tester.pumpAndSettle();
        expect(searchQuery, 'Flutter');

        // Tap close search button to collapse back
        await tester.tap(find.byTooltip('Close Search'));
        await tester.pumpAndSettle();
        expect(find.text('Marketplace Catalog'), findsOneWidget);
      },
    );

    testWidgets(
      'Batch 5 Reduced motion mode provides accessible fallbacks without layout crashes',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: MediaQuery(
              data: MediaQueryData.fromView(tester.view).copyWith(disableAnimations: true),
              child: Scaffold(
                body: CustomScrollView(
                  slivers: [
                    TabTransformHeaderWidget(
                      title: const Text('Accessible Tabs'),
                      tabs: const [
                        TabTransformItem(label: 'Tab 1'),
                        TabTransformItem(label: 'Tab 2'),
                      ],
                      selectedIndex: 0,
                      onTabSelected: (_) {},
                    ),
                    const SliverToBoxAdapter(
                      child: SizedBox(
                        height: 60.0,
                        child: Center(child: Text('Content Spacer')),
                      ),
                    ),
                    SidewaysCollapseHeaderWidget(
                      expandedContent: const Text('Expanded Content'),
                      compactRailContent: const Text('Rail'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );

        expect(find.text('Accessible Tabs'), findsOneWidget);
        expect(find.text('Expanded Content'), findsOneWidget);

        // Scroll without exceptions
        await tester.drag(find.byType(CustomScrollView), const Offset(0.0, -200.0));
        await tester.pumpAndSettle();

        expect(tester.takeException(), isNull);
      },
    );
  });
}
