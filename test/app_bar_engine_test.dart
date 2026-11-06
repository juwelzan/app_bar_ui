import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:app_bar_ui/app_bar_ui.dart';

void main() {
  group('Universal AppBar API — AppBarEngine & Core Architecture Tests', () {
    testWidgets('1. Single Public Entry Point: Renders full page with AppBarEngine and body', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: AppBarEngine(
            model: AppBarModel.classic,
            configuration: AppBarConfiguration(
              content: ContentConfiguration.text(
                title: 'Global Dashboard',
                subtitle: 'Unified API Hub',
                actions: [
                  IconButton(
                    icon: const Icon(Icons.notifications),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
            body: const Center(
              child: Text('Main Body Content'),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Global Dashboard'), findsOneWidget);
      expect(find.text('Main Body Content'), findsOneWidget);
      expect(find.byIcon(Icons.notifications), findsOneWidget);
    });

    testWidgets('2. Sliver Mode: AppBarEngine.sliver renders cleanly inside CustomScrollView', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomScrollView(
              slivers: [
                AppBarEngine.sliver(
                  model: AppBarModel.morphingSplit,
                  configuration: AppBarConfiguration(
                    content: ContentConfiguration.text(
                      title: 'Split View',
                      actions: [
                        IconButton(icon: const Icon(Icons.search), onPressed: () {}),
                      ],
                    ),
                  ),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => ListTile(title: Text('Sliver Item $index')),
                    childCount: 10,
                  ),
                ),
              ],
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Split View'), findsWidgets);
      expect(find.text('Sliver Item 0'), findsOneWidget);
    });

    testWidgets('3. Model Selection: Selects and builds distinct models through identical API', (tester) async {
      final modelsToTest = [
        AppBarModel.classic,
        AppBarModel.morphingSplit,
        AppBarModel.elasticFloating,
        AppBarModel.disappearingActions,
        AppBarModel.circularMorph,
        AppBarModel.tabTransform,
        AppBarModel.magneticAnchorSnap,
        AppBarModel.perspectiveVelocityTilt,
        AppBarModel.dispersingLetterScatter,
        AppBarModel.polygonToRectangleMorph,
        AppBarModel.detachedDampedIsland,
        AppBarModel.fullBleedHeroScale,
      ];

      for (final model in modelsToTest) {
        await tester.pumpWidget(
          MaterialApp(
            key: ValueKey(model),
            home: AppBarEngine(
              model: model,
              configuration: AppBarConfiguration(
                content: ContentConfiguration.text(
                  title: 'Testing Model $model',
                ),
              ),
              body: Container(height: 1200.0),
            ),
          ),
        );

        await tester.pump();
        expect(find.byType(AppBarEngine), findsOneWidget);
      }
    });

    testWidgets('4. Runtime Model Switching: Dynamically switches model via controller with state preservation', (tester) async {
      final controller = AppBarController(initialModel: AppBarModel.classic);

      await tester.pumpWidget(
        MaterialApp(
          home: AppBarEngine(
            controller: controller,
            model: AppBarModel.classic,
            configuration: AppBarConfiguration(
              content: ContentConfiguration.text(title: 'Switchable Header'),
            ),
            body: Container(height: 1200.0),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(controller.currentModel, equals(AppBarModel.classic));

      // Dynamically switch to elasticFloating
      controller.changeModel(AppBarModel.elasticFloating);
      await tester.pumpAndSettle();

      expect(controller.currentModel, equals(AppBarModel.elasticFloating));

      // Dynamically switch to magneticAnchorSnap
      controller.changeModel(AppBarModel.magneticAnchorSnap);
      await tester.pumpAndSettle();

      expect(controller.currentModel, equals(AppBarModel.magneticAnchorSnap));
    });

    testWidgets('5. Complete Element-Level Control: Custom builder, visibility, and overrides', (tester) async {
      bool tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: AppBarEngine(
            model: AppBarModel.classic,
            configuration: AppBarConfiguration(
              content: ContentConfiguration.text(title: 'Default Title'),
              elements: ElementOverrideConfiguration(
                title: ElementConfiguration(
                  builder: (context, state) => Text(
                    'Custom Element Title (Progress: ${state.progress.toStringAsFixed(1)})',
                    style: const TextStyle(fontWeight: FontWeight.w900),
                  ),
                ),
                actions: ElementConfiguration(
                  interaction: ElementInteractionSpec(
                    onTap: () => tapped = true,
                  ),
                  builder: (context, state) => const Icon(Icons.star, key: Key('custom-action')),
                ),
              ),
            ),
            body: Container(height: 800.0),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.textContaining('Custom Element Title'), findsOneWidget);
      expect(find.byKey(const Key('custom-action')), findsOneWidget);

      await tester.tap(find.byKey(const Key('custom-action')));
      expect(tapped, isTrue);
    });

    testWidgets('6. Controller Commands: Programmatic expand, collapse, and progress telemetry', (tester) async {
      final controller = AppBarController();
      final scrollController = ScrollController();

      await tester.pumpWidget(
        MaterialApp(
          home: AppBarEngine(
            controller: controller,
            scrollController: scrollController,
            model: AppBarModel.classic,
            configuration: const AppBarConfiguration(
              layout: LayoutConfiguration(expandedHeight: 200.0, collapsedHeight: 60.0),
              content: ContentConfiguration(title: Text('Progress Header')),
            ),
            body: Column(
              children: List.generate(
                40,
                (i) => ListTile(title: Text('List Item $i')),
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(controller.isExpanded, isTrue);

      // Programmatic scroll down
      scrollController.jumpTo(140.0);
      await tester.pumpAndSettle();

      expect(controller.scrollProgress, closeTo(1.0, 0.05));
      expect(controller.isCollapsed, isTrue);

      // Programmatic collapse command
      controller.collapse();
      await tester.pumpAndSettle();
      expect(controller.scrollProgress, closeTo(1.0, 0.05));

      // Programmatic expand command
      controller.expand();
      await tester.pumpAndSettle();
      expect(controller.scrollProgress, closeTo(0.0, 0.05));
    });

    testWidgets('7. Model Capability Validation: Detects unsupported configurations without crash', (tester) async {
      final warnings = CapabilityValidator.validate(
        model: AppBarModel.classic,
        capabilities: ModelCapabilities.standard,
        configuration: const AppBarConfiguration(
          behavior: BehaviorConfiguration(
            dragToExpand: true,
            directionAwareAutoHide: true,
            snap: true,
          ),
        ),
      );

      expect(warnings.length, equals(3));
      expect(warnings[0], contains('dragToExpand'));
      expect(warnings[1], contains('directionAwareAutoHide'));
      expect(warnings[2], contains('snap'));
    });

    testWidgets('8. Accessibility: Handles disableAnimationsOf cleanly without assertions', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: MediaQuery(
            data: MediaQueryData(disableAnimations: true),
            child: AppBarEngine(
              model: AppBarModel.morphingSplit,
              configuration: AppBarConfiguration(
                content: ContentConfiguration(
                  title: Text('Accessible Universal Header'),
                ),
              ),
              body: Center(child: Text('Accessible Body')),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.text('Accessible Universal Header'), findsWidgets);
      expect(find.text('Accessible Body'), findsOneWidget);
    });
  });
}
