import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:app_bar_ui/app_bar_ui.dart';

final Uint8List _transparentPng = Uint8List.fromList(const <int>[
  0x89,
  0x50,
  0x4E,
  0x47,
  0x0D,
  0x0A,
  0x1A,
  0x0A,
  0x00,
  0x00,
  0x00,
  0x0D,
  0x49,
  0x48,
  0x44,
  0x52,
  0x00,
  0x00,
  0x00,
  0x01,
  0x00,
  0x00,
  0x00,
  0x01,
  0x08,
  0x06,
  0x00,
  0x00,
  0x00,
  0x1F,
  0x15,
  0xC4,
  0x89,
  0x00,
  0x00,
  0x00,
  0x0A,
  0x49,
  0x44,
  0x41,
  0x54,
  0x78,
  0x9C,
  0x63,
  0x00,
  0x01,
  0x00,
  0x00,
  0x05,
  0x00,
  0x01,
  0x0D,
  0x0A,
  0x2D,
  0xB4,
  0x00,
  0x00,
  0x00,
  0x00,
  0x49,
  0x45,
  0x4E,
  0x44,
  0xAE,
  0x42,
  0x60,
  0x82,
]);

void main() {
  group('ScrollHeaderPreset Enum & Model Verification', () {
    test('ScrollHeaderPreset contains all required presets', () {
      expect(ScrollHeaderPreset.values.length, 25);
      expect(ScrollHeaderPreset.values, [
        ScrollHeaderPreset.minimal,
        ScrollHeaderPreset.transparent,
        ScrollHeaderPreset.floating,
        ScrollHeaderPreset.material,
        ScrollHeaderPreset.ios,
        ScrollHeaderPreset.centerTitle,
        ScrollHeaderPreset.largeTitle,
        ScrollHeaderPreset.flexibleSpace,
        ScrollHeaderPreset.collapsing,
        ScrollHeaderPreset.parallax,
        ScrollHeaderPreset.gradient,
        ScrollHeaderPreset.image,
        ScrollHeaderPreset.profile,
        ScrollHeaderPreset.dashboard,
        ScrollHeaderPreset.search,
        ScrollHeaderPreset.segmented,
        ScrollHeaderPreset.stickyTab,
        ScrollHeaderPreset.compactScroll,
        ScrollHeaderPreset.sideActionTransition,
        ScrollHeaderPreset.customBuilder,
        ScrollHeaderPreset.bottomAlignedTitle,
        ScrollHeaderPreset.asymmetric,
        ScrollHeaderPreset.split,
        ScrollHeaderPreset.twoRow,
        ScrollHeaderPreset.multiAction,
      ]);
    });

    test('All presets provide distinct labels and non-empty descriptions', () {
      final labels = <String>{};
      for (final preset in ScrollHeaderPreset.values) {
        expect(preset.label.isNotEmpty, isTrue);
        expect(preset.description.isNotEmpty, isTrue);
        expect(
          labels.contains(preset.label),
          isFalse,
          reason: '${preset.label} is duplicated',
        );
        labels.add(preset.label);
      }
      expect(labels.length, ScrollHeaderPreset.values.length);
    });

    test('ScrollHeaderStyle defaults and copyWith operate correctly', () {
      const style = ScrollHeaderStyle();
      expect(style.elevation, 0.0);
      expect(style.pinned, isTrue);
      expect(style.floating, isFalse);

      final custom = style.copyWith(
        elevation: 4.0,
        backgroundColor: Colors.blue,
        pinned: false,
        floating: true,
        borderRadius: BorderRadius.circular(16.0),
      );

      expect(custom.elevation, 4.0);
      expect(custom.backgroundColor, Colors.blue);
      expect(custom.pinned, isFalse);
      expect(custom.floating, isTrue);
      expect(custom.borderRadius, BorderRadius.circular(16.0));
    });
  });

  group('Preset 1-6: Box Headers (Minimal, Transparent, Floating, Material, iOS, CenterTitle)', () {
    testWidgets(
      'Preset 1: Minimal Header renders title, subtitle, leading and actions',
      (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: ScrollHeader.minimal(
                title: const Text('Minimal Title'),
                subtitle: const Text('Minimal Subtitle'),
                leading: const Icon(Icons.arrow_back),
                actions: const [Icon(Icons.more_vert)],
              ),
            ),
          ),
        );

        expect(find.text('Minimal Title'), findsOneWidget);
        expect(find.text('Minimal Subtitle'), findsOneWidget);
        expect(find.byIcon(Icons.arrow_back), findsOneWidget);
        expect(find.byIcon(Icons.more_vert), findsOneWidget);
        expect(const ScrollHeader.minimal().isSliver, isFalse);
      },
    );

    testWidgets('Preset 2: Transparent Header renders transparent background', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ScrollHeader.transparent(
              title: const Text('Transparent Title'),
              leading: const Icon(Icons.close),
            ),
          ),
        ),
      );

      expect(find.text('Transparent Title'), findsOneWidget);
      expect(find.byIcon(Icons.close), findsOneWidget);
      expect(const ScrollHeader.transparent().isSliver, isFalse);
    });

    testWidgets(
      'Preset 3: Floating Header renders with margin and custom elevation',
      (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: ScrollHeader.floating(
                title: const Text('Floating Title'),
                actions: const [Icon(Icons.favorite)],
                style: const ScrollHeaderStyle(
                  elevation: 6.0,
                  margin: EdgeInsets.all(12.0),
                ),
              ),
            ),
          ),
        );

        expect(find.text('Floating Title'), findsOneWidget);
        expect(find.byIcon(Icons.favorite), findsOneWidget);
        expect(const ScrollHeader.floating().isSliver, isFalse);
      },
    );

    testWidgets(
      'Preset 4: Material Header renders Material layout and elevation',
      (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: ScrollHeader.material(
                title: const Text('Material Title'),
                leading: const Icon(Icons.menu),
                style: const ScrollHeaderStyle(elevation: 4.0),
              ),
            ),
          ),
        );

        expect(find.text('Material Title'), findsOneWidget);
        expect(find.byIcon(Icons.menu), findsOneWidget);
        expect(const ScrollHeader.material().isSliver, isFalse);
      },
    );

    testWidgets(
      'Preset 5: iOS Header renders compact navigation bar with backdrop blur',
      (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: ScrollHeader.ios(
                title: const Text('iOS Title'),
                leading: const Text('Back'),
                actions: const [Icon(Icons.edit)],
              ),
            ),
          ),
        );

        expect(find.text('iOS Title'), findsOneWidget);
        expect(find.text('Back'), findsOneWidget);
        expect(find.byIcon(Icons.edit), findsOneWidget);
        expect(find.byType(BackdropFilter), findsOneWidget);
        expect(const ScrollHeader.ios().isSliver, isFalse);
      },
    );

    testWidgets('Preset 6: Center Title Header centers the title widget', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ScrollHeader.centerTitle(
              title: const Text('Center Title'),
              leading: const Icon(Icons.arrow_back_ios),
              actions: const [Icon(Icons.share)],
            ),
          ),
        ),
      );

      expect(find.text('Center Title'), findsOneWidget);
      expect(find.byIcon(Icons.arrow_back_ios), findsOneWidget);
      expect(find.byIcon(Icons.share), findsOneWidget);
      expect(const ScrollHeader.centerTitle().isSliver, isFalse);
    });
  });

  group('Preset 7-10: Collapsible & Dynamic Slivers (LargeTitle, FlexibleSpace, Collapsing, Parallax)', () {
    testWidgets('Preset 7: Large Title Header collapses on scroll', (
      tester,
    ) async {
      final header = ScrollHeader.largeTitle(
        title: const Text('Large Title'),
        leading: const Icon(Icons.menu),
      );
      expect(header.isSliver, isTrue);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomScrollView(
              slivers: [
                header,
                SliverToBoxAdapter(
                  child: Container(height: 1000, color: Colors.blueGrey),
                ),
              ],
            ),
          ),
        ),
      );

      expect(find.text('Large Title'), findsWidgets);
      // Scroll down by 100 pixels
      await tester.drag(find.byType(CustomScrollView), const Offset(0, -100));
      await tester.pumpAndSettle();
      expect(find.text('Large Title'), findsWidgets);
    });

    testWidgets(
      'Preset 8: Flexible Space Header renders flexible space content',
      (tester) async {
        final header = ScrollHeader.flexibleSpace(
          title: const Text('Title'),
          flexibleSpace: Container(
            key: const Key('custom_flexible_space'),
            color: Colors.amber,
            child: const Center(child: Text('Custom Flexible Content')),
          ),
        );
        expect(header.isSliver, isTrue);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: CustomScrollView(
                slivers: [
                  header,
                  SliverToBoxAdapter(
                    child: Container(height: 1000, color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
        );

        expect(find.byKey(const Key('custom_flexible_space')), findsOneWidget);
        expect(find.text('Custom Flexible Content'), findsOneWidget);
      },
    );

    testWidgets('Preset 9: Collapsing Header smoothly collapses', (
      tester,
    ) async {
      final header = ScrollHeader.collapsing(
        title: const Text('Collapsing Title'),
        subtitle: const Text('Collapsing Subtitle'),
      );
      expect(header.isSliver, isTrue);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomScrollView(
              slivers: [
                header,
                SliverToBoxAdapter(
                  child: Container(height: 1200, color: Colors.indigo),
                ),
              ],
            ),
          ),
        ),
      );

      expect(find.text('Collapsing Title'), findsOneWidget);
      expect(find.text('Collapsing Subtitle'), findsOneWidget);

      await tester.drag(find.byType(CustomScrollView), const Offset(0, -150));
      await tester.pumpAndSettle();
      // Should still be present and collapsed
      expect(find.text('Collapsing Title'), findsOneWidget);
    });

    testWidgets(
      'Preset 10: Parallax Header renders background behind content',
      (tester) async {
        final header = ScrollHeader.parallax(
          background: Container(
            key: const Key('parallax_bg'),
            color: Colors.deepPurple,
          ),
          title: const Text('Parallax Header'),
        );
        expect(header.isSliver, isTrue);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: CustomScrollView(
                slivers: [
                  header,
                  SliverToBoxAdapter(
                    child: Container(height: 1000, color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
        );

        expect(find.byKey(const Key('parallax_bg')), findsOneWidget);
        expect(find.text('Parallax Header'), findsOneWidget);

        await tester.drag(find.byType(CustomScrollView), const Offset(0, -80));
        await tester.pump();
        expect(find.byKey(const Key('parallax_bg')), findsOneWidget);
      },
    );
  });

  group('Preset 11-16: Gradient, Image, Profile, Dashboard, Search, Segmented', () {
    testWidgets('Preset 11: Gradient Header renders gradient background', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ScrollHeader.gradient(
              title: const Text('Gradient Header'),
              gradient: const LinearGradient(
                colors: [Colors.purple, Colors.blue],
              ),
            ),
          ),
        ),
      );

      expect(find.text('Gradient Header'), findsOneWidget);
      expect(const ScrollHeader.gradient().isSliver, isFalse);
    });

    testWidgets('Preset 12: Image Header renders overlay scrim', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ScrollHeader.image(
              title: const Text('Image Header'),
              image: MemoryImage(_transparentPng),
              overlayColor: Colors.black54,
            ),
          ),
        ),
      );

      expect(find.text('Image Header'), findsOneWidget);
      expect(
        ScrollHeader.image(image: MemoryImage(_transparentPng)).isSliver,
        isFalse,
      );
    });

    testWidgets(
      'Preset 13: Profile Header renders avatar, stats, and handles avatar tap',
      (tester) async {
        var tapped = false;
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: ScrollHeader.profile(
                name: const Text('Jane Doe'),
                handleOrRole: const Text('@janedoe • Product Lead'),
                avatar: const CircleAvatar(child: Text('JD')),
                stats: const Row(
                  children: [
                    Text('1.2K Followers'),
                    SizedBox(width: 16),
                    Text('480 Following'),
                  ],
                ),
                onAvatarTap: () => tapped = true,
                actions: const [Icon(Icons.more_horiz)],
              ),
            ),
          ),
        );

        expect(find.text('Jane Doe'), findsOneWidget);
        expect(find.text('@janedoe • Product Lead'), findsOneWidget);
        expect(find.text('1.2K Followers'), findsOneWidget);
        expect(find.byIcon(Icons.more_horiz), findsOneWidget);

        await tester.tap(find.text('JD'));
        expect(tapped, isTrue);
        expect(
          const ScrollHeader.profile(name: Text('Test')).isSliver,
          isFalse,
        );
      },
    );

    testWidgets(
      'Preset 14: Dashboard Header renders greeting, username, and metrics',
      (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: ScrollHeader.dashboard(
                greeting: const Text('Good Morning'),
                userName: const Text('Alex Smith'),
                dateOrSubtitle: const Text('Oct 24, 2026'),
                metricsRow: const Row(children: [Text('\$14,250 Revenue')]),
                actions: const [Icon(Icons.notifications_outlined)],
              ),
            ),
          ),
        );

        expect(find.text('Good Morning'), findsOneWidget);
        expect(find.text('Alex Smith'), findsOneWidget);
        expect(find.text('Oct 24, 2026'), findsOneWidget);
        expect(find.text('\$14,250 Revenue'), findsOneWidget);
        expect(find.byIcon(Icons.notifications_outlined), findsOneWidget);
        expect(
          const ScrollHeader.dashboard(greeting: Text('Hi')).isSliver,
          isFalse,
        );
      },
    );

    testWidgets(
      'Preset 15: Search Header binds text editing controller and triggers callbacks',
      (tester) async {
        final controller = TextEditingController();
        String changedText = '';
        String submittedText = '';

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: ScrollHeader.search(
                searchController: controller,
                searchHint: 'Find products...',
                onSearchChanged: (v) => changedText = v,
                onSearchSubmitted: (v) => submittedText = v,
                actions: const [Icon(Icons.filter_list)],
              ),
            ),
          ),
        );

        expect(find.text('Find products...'), findsOneWidget);
        expect(find.byIcon(Icons.filter_list), findsOneWidget);

        await tester.enterText(find.byType(TextField), 'Flutter Presets');
        expect(changedText, 'Flutter Presets');

        await tester.testTextInput.receiveAction(TextInputAction.done);
        expect(submittedText, 'Flutter Presets');
        expect(const ScrollHeader.search().isSliver, isFalse);
      },
    );

    testWidgets('Preset 16: Segmented Header renders segments widget', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ScrollHeader.segmented(
              title: const Text('Category View'),
              segments: const Row(
                children: [Text('All'), Text('Active'), Text('Archived')],
              ),
            ),
          ),
        ),
      );

      expect(find.text('Category View'), findsOneWidget);
      expect(find.text('All'), findsOneWidget);
      expect(find.text('Active'), findsOneWidget);
      expect(find.text('Archived'), findsOneWidget);
      expect(
        const ScrollHeader.segmented(segments: SizedBox()).isSliver,
        isFalse,
      );
    });
  });

  group('Preset 17-20: StickyTab, CompactScroll, SideActionTransition, CustomBuilder', () {
    testWidgets(
      'Preset 17: Sticky Tab Header renders tab bar and is a sliver',
      (tester) async {
        final header = ScrollHeader.stickyTab(
          title: const Text('Sticky Tabs'),
          tabBar: const TabBar(
            tabs: [
              Tab(text: 'Overview'),
              Tab(text: 'Analytics'),
            ],
          ),
        );
        expect(header.isSliver, isTrue);

        await tester.pumpWidget(
          MaterialApp(
            home: DefaultTabController(
              length: 2,
              child: Scaffold(
                body: CustomScrollView(
                  slivers: [
                    header,
                    SliverToBoxAdapter(
                      child: Container(height: 1000, color: Colors.teal),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );

        expect(find.text('Sticky Tabs'), findsOneWidget);
        expect(find.text('Overview'), findsOneWidget);
        expect(find.text('Analytics'), findsOneWidget);
      },
    );

    testWidgets(
      'Preset 18: Compact Scroll Header renders compact bar and is a sliver',
      (tester) async {
        final header = ScrollHeader.compactScroll(
          title: const Text('Compact Scroll Header'),
          subtitle: const Text('Subtitle'),
        );
        expect(header.isSliver, isTrue);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: CustomScrollView(
                slivers: [
                  header,
                  SliverToBoxAdapter(
                    child: Container(height: 1000, color: Colors.blue),
                  ),
                ],
              ),
            ),
          ),
        );

        expect(find.text('Compact Scroll Header'), findsOneWidget);
        expect(find.text('Subtitle'), findsOneWidget);
      },
    );

    testWidgets(
      'Preset 19: Side Action Transition Header transforms leading/trailing icons',
      (tester) async {
        var leadingTapped = false;
        var trailingTapped = false;

        final header = ScrollHeader.sideActionTransition(
          title: const Text('Side Actions'),
          initialLeading: const Icon(
            Icons.arrow_back,
            key: Key('init_leading'),
          ),
          scrolledLeading: const Icon(
            Icons.close,
            key: Key('scrolled_leading'),
          ),
          initialTrailing: const Icon(Icons.share, key: Key('init_trailing')),
          scrolledTrailing: const Icon(
            Icons.check,
            key: Key('scrolled_trailing'),
          ),
          onLeadingTap: () => leadingTapped = true,
          onTrailingTap: () => trailingTapped = true,
        );
        expect(header.isSliver, isFalse);

        await tester.pumpWidget(MaterialApp(home: Scaffold(body: header)));

        expect(find.text('Side Actions'), findsOneWidget);
        expect(find.byKey(const Key('init_leading')), findsOneWidget);
        expect(find.byKey(const Key('init_trailing')), findsOneWidget);

        await tester.tap(find.byKey(const Key('init_leading')));
        expect(leadingTapped, isTrue);

        await tester.tap(find.byKey(const Key('init_trailing')));
        expect(trailingTapped, isTrue);
      },
    );

    testWidgets(
      'Preset 20: Custom Builder Header executes builder with scroll progress',
      (tester) async {
        double lastProgress = -1;
        final header = ScrollHeader.customBuilder(
          expandedHeight: 180.0,
          collapsedHeight: 60.0,
          builder: (context, progress, overlaps) {
            lastProgress = progress;
            return Container(
              key: const Key('custom_builder_container'),
              color: Colors.amber,
              child: Center(
                child: Text('Progress: ${progress.toStringAsFixed(1)}'),
              ),
            );
          },
        );
        expect(header.isSliver, isTrue);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: CustomScrollView(
                slivers: [
                  header,
                  SliverToBoxAdapter(
                    child: Container(height: 1200, color: Colors.black),
                  ),
                ],
              ),
            ),
          ),
        );

        expect(
          find.byKey(const Key('custom_builder_container')),
          findsOneWidget,
        );
        expect(lastProgress, 0.0);
        expect(find.text('Progress: 0.0'), findsOneWidget);

        // Scroll down
        await tester.drag(find.byType(CustomScrollView), const Offset(0, -60));
        await tester.pump();
        expect(lastProgress, greaterThan(0.0));
      },
    );
  });

  group('Developer Experience & Non-destructive Guarantees', () {
    testWidgets('ScrollHeader never replaces developer custom widgets', (
      tester,
    ) async {
      final customLeading = const SizedBox(
        key: Key('my_custom_leading'),
        width: 24,
        height: 24,
      );
      final customTitle = Container(
        key: const Key('my_custom_title'),
        child: const Text('Custom'),
      );
      final customAction = const SizedBox(
        key: Key('my_custom_action'),
        width: 32,
        height: 32,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ScrollHeader(
              preset: ScrollHeaderPreset.minimal,
              leading: customLeading,
              title: customTitle,
              actions: [customAction],
            ),
          ),
        ),
      );

      expect(find.byKey(const Key('my_custom_leading')), findsOneWidget);
      expect(find.byKey(const Key('my_custom_title')), findsOneWidget);
      expect(find.byKey(const Key('my_custom_action')), findsOneWidget);
    });

    testWidgets('ScrollHeader respects safeArea padding configuration', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MediaQuery(
          data: MediaQueryData(padding: EdgeInsets.only(top: 44.0)),
          child: MaterialApp(
            home: Scaffold(
              body: ScrollHeader.minimal(
                title: Text('Safe Area Test'),
                safeArea: true,
              ),
            ),
          ),
        ),
      );

      expect(find.text('Safe Area Test'), findsOneWidget);
    });
  });

  group('ScrollResponsiveScaffold Integration with Header Presets', () {
    testWidgets(
      'ScrollResponsiveScaffold seamlessly mounts Box header preset',
      (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: ScrollResponsiveScaffold(
              header: ScrollHeader.floating(
                title: const Text('Floating in Scaffold'),
              ),
              body: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 50,
                itemBuilder: (context, i) => ListTile(title: Text('Item $i')),
              ),
            ),
          ),
        );

        expect(find.text('Floating in Scaffold'), findsOneWidget);
        expect(find.text('Item 0'), findsOneWidget);

        final initialOffset = tester.getTopLeft(find.text('Item 0')).dy;
        await tester.drag(find.byType(Scrollable).first, const Offset(0, -300));
        await tester.pumpAndSettle();
        final scrolledOffset = tester.getTopLeft(find.text('Item 0')).dy;
        expect(scrolledOffset, lessThan(initialOffset));
      },
    );

    testWidgets(
      'ScrollResponsiveScaffold seamlessly mounts Sliver header preset without assertion error',
      (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: ScrollResponsiveScaffold(
              header: ScrollHeader.collapsing(
                title: const Text('Collapsing in Scaffold'),
              ),
              body: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 50,
                itemBuilder: (context, i) => ListTile(title: Text('Item $i')),
              ),
            ),
          ),
        );

        expect(find.text('Collapsing in Scaffold'), findsOneWidget);
        expect(find.text('Item 0'), findsOneWidget);

        // Scroll down
        await tester.drag(find.byType(Scrollable).first, const Offset(0, -200));
        await tester.pumpAndSettle();
        expect(find.text('Collapsing in Scaffold'), findsOneWidget);
      },
    );
  });
}
