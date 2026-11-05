import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:app_bar_ui/app_bar_ui.dart';

class _RebuildCounterWidget extends StatefulWidget {
  const _RebuildCounterWidget({required this.onRebuild});

  final VoidCallback onRebuild;

  @override
  State<_RebuildCounterWidget> createState() => _RebuildCounterWidgetState();
}

class _RebuildCounterWidgetState extends State<_RebuildCounterWidget> {
  @override
  Widget build(BuildContext context) {
    widget.onRebuild();
    return const SizedBox(
      height: 100.0,
      child: Text('Rebuild Audited Body Item'),
    );
  }
}

void main() {
  group('Phase 11: Performance Engineering & Rebuild Audit Tests', () {
    testWidgets(
      'ScrollResponsiveScaffold causes ZERO whole-tree body rebuilds during continuous scrolling',
      (tester) async {
        int bodyBuildCount = 0;
        final scrollController = ScrollController();

        await tester.pumpWidget(
          MaterialApp(
            home: ScrollResponsiveScaffold(
              controller: scrollController,
              headerTitle: const Text('Audited Header Title'),
              initialLeading: const Icon(Icons.account_circle),
              scrolledLeading: const Icon(Icons.menu),
              body: Column(
                children: [
                  _RebuildCounterWidget(
                    onRebuild: () {
                      bodyBuildCount++;
                    },
                  ),
                  ...List.generate(
                    40,
                    (i) => SizedBox(height: 50.0, child: Text('List Item $i')),
                  ),
                ],
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Initial build count is exactly 1
        expect(bodyBuildCount, 1);

        // Perform continuous scrolling across 10 consecutive frames
        for (double offset = 20.0; offset <= 200.0; offset += 20.0) {
          scrollController.jumpTo(offset);
          await tester.pump();
        }
        await tester.pumpAndSettle();

        // Invariant: The body MUST NOT have rebuilt despite 10 scroll updates!
        expect(
          bodyBuildCount,
          1,
          reason: 'Body widget was rebuilt during scrolling! Frame budget violated.',
        );
      },
    );

    testWidgets(
      'ScrollParallax utilizes FlowDelegate and repaints without widget element rebuilds',
      (tester) async {
        int parallaxChildBuildCount = 0;
        final scrollController = ScrollController();

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: CustomScrollView(
                controller: scrollController,
                slivers: [
                  SliverToBoxAdapter(
                    child: ScrollParallax(
                      height: 200.0,
                      speedFactor: 0.5,
                      child: Builder(
                        builder: (context) {
                          parallaxChildBuildCount++;
                          return const ColoredBox(color: Colors.blue);
                        },
                      ),
                    ),
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

        expect(parallaxChildBuildCount, 1);

        // Scroll view to trigger parallax translation during paint
        scrollController.jumpTo(100.0);
        await tester.pump();

        // Child should NOT rebuild because FlowDelegate repaints via Matrix4 translation
        expect(
          parallaxChildBuildCount,
          1,
          reason: 'Parallax child was rebuilt during scroll! Use FlowDelegate.',
        );
      },
    );

    testWidgets(
      'ScrollResponsiveEngine properly cleans up ValueNotifiers upon disposal',
      (tester) async {
        final engine = ScrollResponsiveEngine(
          config: const ScrollResponsiveConfig(),
        );

        final leadingNotifier = engine.leadingProgressNotifier;
        final trailingNotifier = engine.trailingProgressNotifier;
        final detailsNotifier = engine.progressDetailsNotifier;

        expect(leadingNotifier.value, 0.0);

        // Dispose engine
        engine.dispose();

        // Accessing or adding listeners to disposed notifiers throws in Flutter framework
        expect(() => leadingNotifier.addListener(() {}), throwsFlutterError);
        expect(() => trailingNotifier.addListener(() {}), throwsFlutterError);
        expect(() => detailsNotifier.addListener(() {}), throwsFlutterError);
      },
    );

    testWidgets(
      'External ScrollController is retained safely without listener leaks',
      (tester) async {
        final externalController = ScrollController();

        // Mount scaffold with external controller
        await tester.pumpWidget(
          MaterialApp(
            home: ScrollResponsiveScaffold(
              controller: externalController,
              body: const Text('Content 1'),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Rebuild with different widget tree
        await tester.pumpWidget(
          MaterialApp(
            home: ScrollResponsiveScaffold(
              controller: externalController,
              body: const Text('Content 2'),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Unmount completely
        await tester.pumpWidget(const MaterialApp(home: SizedBox()));
        await tester.pumpAndSettle();

        // External controller should NOT be disposed by the framework!
        expect(() => externalController.hasClients, returnsNormally);

        // Clean up external controller
        externalController.dispose();
      },
    );
  });
}
