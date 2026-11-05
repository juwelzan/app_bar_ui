import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:app_bar_ui/app_bar_ui.dart';

void main() {
  group('Batch 5: Specialized Presets (41-45) Tests', () {
    test('Preset enum metadata and labels exist for presets 41-45', () {
      const presets = [
        ScrollHeaderPreset.mediaPlayer,
        ScrollHeaderPreset.shopping,
        ScrollHeaderPreset.chat,
        ScrollHeaderPreset.detailPage,
        ScrollHeaderPreset.reading,
      ];

      for (final p in presets) {
        expect(p.label.isNotEmpty, isTrue);
        expect(p.description.isNotEmpty, isTrue);
      }

      expect(ScrollHeaderPreset.mediaPlayer.label, 'Media Player Header');
      expect(ScrollHeaderPreset.shopping.label, 'Shopping Header');
      expect(ScrollHeaderPreset.chat.label, 'Chat Header');
      expect(ScrollHeaderPreset.detailPage.label, 'Detail Page Header');
      expect(ScrollHeaderPreset.reading.label, 'Reading Header');
    });

    test('isSliver contract is correct for presets 41-45', () {
      expect(const ScrollHeader.mediaPlayer().isSliver, isFalse);
      expect(const ScrollHeader.shopping().isSliver, isFalse);
      expect(const ScrollHeader.chat().isSliver, isFalse);
      expect(const ScrollHeader.detailPage().isSliver, isTrue);
      expect(const ScrollHeader.reading().isSliver, isFalse);
    });

    testWidgets('Preset 41: MediaPlayerHeaderWidget renders playback controls and fires callbacks',
        (tester) async {
      var playPauseTapped = false;
      var nextTapped = false;
      var previousTapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(72.0),
              child: MediaPlayerHeaderWidget(
                nowPlayingTitle: const Text('Solar Drift'),
                artist: const Text('Cosmic Duo'),
                albumArt: const Icon(Icons.album),
                isPlaying: false,
                onPlayPause: () => playPauseTapped = true,
                onNext: () => nextTapped = true,
                onPrevious: () => previousTapped = true,
                actions: const [
                  Icon(Icons.favorite_border),
                ],
              ),
            ),
            body: const Center(child: Text('Content')),
          ),
        ),
      );

      expect(find.text('Solar Drift'), findsOneWidget);
      expect(find.text('Cosmic Duo'), findsOneWidget);
      expect(find.byIcon(Icons.album), findsOneWidget);
      expect(find.byIcon(Icons.play_circle_filled), findsOneWidget);
      expect(find.byIcon(Icons.skip_next), findsOneWidget);
      expect(find.byIcon(Icons.skip_previous), findsOneWidget);
      expect(find.byIcon(Icons.favorite_border), findsOneWidget);

      await tester.tap(find.byIcon(Icons.play_circle_filled));
      await tester.pump();
      expect(playPauseTapped, isTrue);

      await tester.tap(find.byIcon(Icons.skip_next));
      await tester.pump();
      expect(nextTapped, isTrue);

      await tester.tap(find.byIcon(Icons.skip_previous));
      await tester.pump();
      expect(previousTapped, isTrue);
    });

    testWidgets('Preset 42: ShoppingHeaderWidget displays cart badge and handles tap',
        (tester) async {
      var cartTapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(kToolbarHeight),
              child: ShoppingHeaderWidget(
                title: const Text('Store Front'),
                cartItemCount: 5,
                onCartTap: () => cartTapped = true,
                leading: const Icon(Icons.menu),
                actions: const [Icon(Icons.search)],
              ),
            ),
            body: const Center(child: Text('Content')),
          ),
        ),
      );

      expect(find.text('Store Front'), findsOneWidget);
      expect(find.text('5'), findsOneWidget);
      expect(find.byIcon(Icons.shopping_cart_outlined), findsOneWidget);
      expect(find.byIcon(Icons.menu), findsOneWidget);
      expect(find.byIcon(Icons.search), findsOneWidget);

      await tester.tap(find.byIcon(Icons.shopping_cart_outlined));
      await tester.pump();
      expect(cartTapped, isTrue);
    });

    testWidgets('Preset 43: ChatHeaderWidget renders user presence and call actions',
        (tester) async {
      var callTapped = false;
      var videoTapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(64.0),
              child: ChatHeaderWidget(
                chatUser: const Text('Alice Wonder'),
                onlineStatus: const Text('Online'),
                avatar: const CircleAvatar(child: Text('AW')),
                onCallTap: () => callTapped = true,
                onVideoTap: () => videoTapped = true,
                leading: const Icon(Icons.arrow_back),
              ),
            ),
            body: const Center(child: Text('Chat Content')),
          ),
        ),
      );

      expect(find.text('Alice Wonder'), findsOneWidget);
      expect(find.text('Online'), findsOneWidget);
      expect(find.text('AW'), findsOneWidget);
      expect(find.byIcon(Icons.call_outlined), findsOneWidget);
      expect(find.byIcon(Icons.videocam_outlined), findsOneWidget);
      expect(find.byIcon(Icons.arrow_back), findsOneWidget);

      await tester.tap(find.byIcon(Icons.call_outlined));
      await tester.pump();
      expect(callTapped, isTrue);

      await tester.tap(find.byIcon(Icons.videocam_outlined));
      await tester.pump();
      expect(videoTapped, isTrue);
    });

    testWidgets('Preset 44: DetailPageHeaderWidget renders as sliver and handles scrolling',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomScrollView(
              slivers: [
                const DetailPageHeaderWidget(
                  title: Text('Grand Canyon'),
                  subtitle: Text('Arizona, USA'),
                  heroTag: 'canyon-tag',
                  background: ColoredBox(color: Colors.deepOrange),
                  leading: Icon(Icons.arrow_back),
                  actions: [Icon(Icons.share)],
                  expandedHeight: 250.0,
                  collapsedHeight: 60.0,
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => ListTile(title: Text('Item #$index')),
                    childCount: 40,
                  ),
                ),
              ],
            ),
          ),
        ),
      );

      expect(find.text('Grand Canyon'), findsOneWidget);
      expect(find.text('Arizona, USA'), findsOneWidget);
      expect(find.byIcon(Icons.arrow_back), findsOneWidget);
      expect(find.byIcon(Icons.share), findsOneWidget);

      // Scroll up to trigger collapse
      await tester.drag(find.byType(CustomScrollView), const Offset(0.0, -300.0));
      await tester.pumpAndSettle();

      // Top bar still rendered
      expect(find.byIcon(Icons.arrow_back), findsOneWidget);
    });

    testWidgets('Preset 45: ReadingHeaderWidget renders estimated time and reading progress',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            appBar: const PreferredSize(
              preferredSize: Size.fromHeight(60.0),
              child: ReadingHeaderWidget(
                title: Text('Flutter Deep Dive'),
                estimatedReadTime: '7 min read',
                readingProgress: 0.65,
                leading: Icon(Icons.close),
                actions: [Icon(Icons.bookmark)],
              ),
            ),
            body: const Center(child: Text('Article Body')),
          ),
        ),
      );

      expect(find.text('Flutter Deep Dive'), findsOneWidget);
      expect(find.text('7 min read'), findsOneWidget);
      expect(find.byIcon(Icons.close), findsOneWidget);
      expect(find.byIcon(Icons.bookmark), findsOneWidget);

      final progressFinder = find.byType(LinearProgressIndicator);
      expect(progressFinder, findsOneWidget);
      final indicator = tester.widget<LinearProgressIndicator>(progressFinder);
      expect(indicator.value, closeTo(0.65, 0.001));
    });

    testWidgets('ScrollHeader convenience constructor builds presets 41-45 correctly',
        (tester) async {
      // Test mediaPlayer constructor
      final mediaHeader = ScrollHeader.mediaPlayer(
        nowPlayingTitle: const Text('Title'),
        isPlaying: true,
      );
      expect(mediaHeader.preset, ScrollHeaderPreset.mediaPlayer);

      // Test shopping constructor
      final shopHeader = ScrollHeader.shopping(
        title: const Text('Shop'),
        cartItemCount: 2,
      );
      expect(shopHeader.preset, ScrollHeaderPreset.shopping);

      // Test chat constructor
      final chatHeader = ScrollHeader.chat(
        chatUser: const Text('Chat'),
      );
      expect(chatHeader.preset, ScrollHeaderPreset.chat);

      // Test detailPage constructor
      final detailHeader = ScrollHeader.detailPage(
        title: const Text('Detail'),
      );
      expect(detailHeader.preset, ScrollHeaderPreset.detailPage);
      expect(detailHeader.isSliver, isTrue);

      // Test reading constructor
      final readingHeader = ScrollHeader.reading(
        title: const Text('Reading'),
        readingProgress: 0.5,
      );
      expect(readingHeader.preset, ScrollHeaderPreset.reading);
    });
  });
}
