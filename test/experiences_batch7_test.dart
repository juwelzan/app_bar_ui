import 'package:app_bar_ui/app_bar_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Batch 7: Genuinely Different Animated AppBar Experiences (31-35)', () {
    testWidgets(
      'Style 31: FloatingOrbitSliverHeaderWidget rotates orbiting satellites and docks into inline toolbar',
      (WidgetTester tester) async {
        int tappedIndex = -1;
        final satellites = [
          OrbitSatelliteItem(
            icon: Icons.search,
            label: 'Search Satellite',
            onTap: () => tappedIndex = 0,
          ),
          OrbitSatelliteItem(
            icon: Icons.notifications,
            label: 'Notifications Satellite',
            onTap: () => tappedIndex = 1,
          ),
          OrbitSatelliteItem(
            icon: Icons.settings,
            label: 'Settings Satellite',
            onTap: () => tappedIndex = 2,
          ),
        ];

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: CustomScrollView(
                slivers: [
                  FloatingOrbitSliverHeaderWidget(
                    centralTitle: const Text('Cosmic Center'),
                    centralSubtitle: const Text('Orbital Hub v4'),
                    centralAvatar: const CircleAvatar(child: Icon(Icons.public)),
                    satellites: satellites,
                    leading: const BackButton(),
                    config: const FloatingOrbitSliverConfig(
                      expandedHeight: 220.0,
                      collapsedHeight: 64.0,
                      orbitRadius: 70.0,
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => ListTile(title: Text('Celestial Object $index')),
                      childCount: 25,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );

        // Expanded state: central title and satellites visible
        expect(find.text('Cosmic Center'), findsOneWidget);
        expect(find.text('Orbital Hub v4'), findsOneWidget);
        expect(find.byIcon(Icons.public), findsOneWidget);
        expect(find.byIcon(Icons.search), findsOneWidget);
        expect(find.byIcon(Icons.notifications), findsOneWidget);
        expect(find.byIcon(Icons.settings), findsOneWidget);

        // Tap satellite in expanded state
        await tester.tap(find.byIcon(Icons.notifications));
        await tester.pumpAndSettle();
        expect(tappedIndex, 1);

        // Scroll down to collapse into docked row
        await tester.drag(find.byType(CustomScrollView), const Offset(0.0, -180.0));
        await tester.pumpAndSettle();

        expect(find.text('Cosmic Center'), findsOneWidget);
        expect(find.byIcon(Icons.search), findsOneWidget);
        expect(tester.takeException(), isNull);
      },
    );

    testWidgets(
      'Style 32: MultiSliceAccordionHeaderWidget collapses independent slices across distinct scroll bands',
      (WidgetTester tester) async {
        final slices = [
          AccordionSliceItem(
            spec: const AccordionSliceSpec(
              id: 'overview',
              height: 50.0,
              collapseStartOffset: 0.0,
              collapseEndOffset: 50.0,
            ),
            builder: (context, factor) => const Center(child: Text('Slice 1: Overview Data')),
          ),
          AccordionSliceItem(
            spec: const AccordionSliceSpec(
              id: 'metrics',
              height: 50.0,
              collapseStartOffset: 40.0,
              collapseEndOffset: 90.0,
            ),
            builder: (context, factor) => const Center(child: Text('Slice 2: Analytics Metrics')),
          ),
          AccordionSliceItem(
            spec: const AccordionSliceSpec(
              id: 'controls',
              height: 50.0,
              collapseStartOffset: 80.0,
              collapseEndOffset: 130.0,
            ),
            builder: (context, factor) => const Center(child: Text('Slice 3: Filter Controls')),
          ),
        ];

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: CustomScrollView(
                slivers: [
                  MultiSliceAccordionHeaderWidget(
                    pinnedBar: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text('Pinned Operations Hub'),
                      ),
                    ),
                    slices: slices,
                    config: const MultiSliceAccordionConfig(
                      pinnedToolbarHeight: 56.0,
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => ListTile(title: Text('Task Record $index')),
                      childCount: 30,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );

        // Fully expanded: all 3 slices and pinned bar are visible
        expect(find.text('Pinned Operations Hub'), findsOneWidget);
        expect(find.text('Slice 1: Overview Data'), findsOneWidget);
        expect(find.text('Slice 2: Analytics Metrics'), findsOneWidget);
        expect(find.text('Slice 3: Filter Controls'), findsOneWidget);

        // Scroll 55px: Slice 1 is completely collapsed, Slice 2 partially collapsed, Slice 3 fully open
        await tester.drag(find.byType(CustomScrollView), const Offset(0.0, -55.0));
        await tester.pumpAndSettle();

        expect(find.text('Pinned Operations Hub'), findsOneWidget);
        expect(find.text('Slice 1: Overview Data'), findsNothing);
        expect(find.text('Slice 3: Filter Controls'), findsOneWidget);

        // Scroll further to collapse all slices
        await tester.drag(find.byType(CustomScrollView), const Offset(0.0, -120.0));
        await tester.pumpAndSettle();

        expect(find.text('Pinned Operations Hub'), findsOneWidget);
        expect(find.text('Slice 1: Overview Data'), findsNothing);
        expect(find.text('Slice 2: Analytics Metrics'), findsNothing);
        expect(tester.takeException(), isNull);
      },
    );

    testWidgets(
      'Style 33: TheaterCurtainRevealHeaderWidget parts curtains sideways to unveil stage canvas',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: CustomScrollView(
                slivers: [
                  TheaterCurtainRevealHeaderWidget(
                    valenceTitle: const Text('Grand Opera Hall'),
                    valenceActions: [
                      IconButton(icon: const Icon(Icons.bookmark_border), onPressed: () {}),
                    ],
                    stageContent: const Center(
                      child: Text('Illuminated Symphonic Stage'),
                    ),
                    config: const TheaterCurtainRevealConfig(
                      expandedHeight: 220.0,
                      collapsedHeight: 60.0,
                      partingThreshold: 120.0,
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => ListTile(title: Text('Performer Row $index')),
                      childCount: 25,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );

        // Pinned valence title and stage content present
        expect(find.text('Grand Opera Hall'), findsOneWidget);
        expect(find.text('Illuminated Symphonic Stage'), findsOneWidget);

        // Scroll to part curtains
        await tester.drag(find.byType(CustomScrollView), const Offset(0.0, -100.0));
        await tester.pumpAndSettle();

        expect(find.text('Grand Opera Hall'), findsOneWidget);
        expect(find.text('Illuminated Symphonic Stage'), findsOneWidget);
        expect(tester.takeException(), isNull);
      },
    );

    testWidgets(
      'Style 34: DivergentVectorParallaxZoomHeaderWidget magnifies background and diverges text along opposing vectors',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: CustomScrollView(
                slivers: [
                  DivergentVectorParallaxZoomHeaderWidget(
                    backgroundImage: Container(color: Colors.blueGrey),
                    title: const Text('Alpine Peak Expedition'),
                    subtitle: const Text('Elevation: 4,810m'),
                    categoryTag: const Chip(label: Text('Extreme Summit')),
                    config: const DivergentVectorParallaxZoomConfig(
                      expandedHeight: 240.0,
                      collapsedHeight: 64.0,
                      zoomScaleFactor: 1.4,
                      divergenceDistance: 40.0,
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => ListTile(title: Text('Expedition Waypoint $index')),
                      childCount: 25,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );

        // Expanded state
        expect(find.text('Alpine Peak Expedition'), findsOneWidget);
        expect(find.text('Elevation: 4,810m'), findsOneWidget);
        expect(find.text('Extreme Summit'), findsOneWidget);

        // Scroll down to activate divergent vector shifts and zoom
        await tester.drag(find.byType(CustomScrollView), const Offset(0.0, -80.0));
        await tester.pump();

        expect(find.text('Alpine Peak Expedition'), findsOneWidget);

        // Scroll completely down to dock title into pinned toolbar
        await tester.drag(find.byType(CustomScrollView), const Offset(0.0, -150.0));
        await tester.pumpAndSettle();

        expect(find.text('Alpine Peak Expedition'), findsOneWidget);
        expect(tester.takeException(), isNull);
      },
    );

    testWidgets(
      'Style 35: DynamicSineWaveCollapseHeaderWidget dampens sinusoidal bottom edge to flat toolbar',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: CustomScrollView(
                slivers: [
                  DynamicSineWaveCollapseHeaderWidget(
                    title: const Text('Oceanic Currents'),
                    subtitle: const Text('Pacific Surface Flow v2'),
                    expandedHero: const Icon(Icons.waves, size: 48.0, color: Colors.white),
                    config: const DynamicSineWaveCollapseConfig(
                      expandedHeight: 200.0,
                      collapsedHeight: 64.0,
                      waveAmplitude: 20.0,
                      waveFrequency: 2.0,
                      dampenThreshold: 120.0,
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => ListTile(title: Text('Buoy Station $index')),
                      childCount: 25,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );

        // Expanded state: Title, subtitle, and wave hero graphic visible
        expect(find.text('Oceanic Currents'), findsOneWidget);
        expect(find.text('Pacific Surface Flow v2'), findsOneWidget);
        expect(find.byIcon(Icons.waves), findsOneWidget);

        // Scroll to dampen the wave edge into a flat toolbar
        await tester.drag(find.byType(CustomScrollView), const Offset(0.0, -150.0));
        await tester.pumpAndSettle();

        expect(find.text('Oceanic Currents'), findsOneWidget);
        expect(tester.takeException(), isNull);
      },
    );

    testWidgets(
      'Batch 7: Reduced motion mode provides accessible fallbacks without layout crashes',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: MediaQuery(
              data: const MediaQueryData(disableAnimations: true),
              child: Scaffold(
                body: CustomScrollView(
                  slivers: [
                    FloatingOrbitSliverHeaderWidget(
                      centralTitle: const Text('Accessible Orbit'),
                      satellites: [
                        OrbitSatelliteItem(
                          icon: Icons.star,
                          label: 'Star',
                          onTap: () {},
                        ),
                      ],
                    ),
                    MultiSliceAccordionHeaderWidget(
                      pinnedBar: const Text('Accessible Accordion Bar'),
                      slices: [
                        AccordionSliceItem(
                          spec: const AccordionSliceSpec(
                            id: 'acc1',
                            height: 40.0,
                            collapseStartOffset: 0.0,
                            collapseEndOffset: 40.0,
                          ),
                          builder: (context, factor) => const Text('Slice A'),
                        ),
                      ],
                    ),
                    const TheaterCurtainRevealHeaderWidget(
                      valenceTitle: Text('Accessible Theater'),
                      stageContent: Text('Accessible Stage Content'),
                    ),
                    DivergentVectorParallaxZoomHeaderWidget(
                      backgroundImage: Container(color: Colors.black12),
                      title: const Text('Accessible Zoom'),
                    ),
                    const DynamicSineWaveCollapseHeaderWidget(
                      title: Text('Accessible Wave'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();
        expect(find.text('Accessible Orbit'), findsOneWidget);
        expect(find.text('Accessible Accordion Bar'), findsOneWidget);
        expect(find.text('Accessible Theater'), findsOneWidget);

        // Scroll down to bring bottom slivers into view
        await tester.drag(find.byType(CustomScrollView), const Offset(0.0, -350.0));
        await tester.pumpAndSettle();

        expect(find.text('Accessible Zoom'), findsOneWidget);
        expect(find.text('Accessible Wave'), findsOneWidget);
        expect(tester.takeException(), isNull);
      },
    );
  });
}
