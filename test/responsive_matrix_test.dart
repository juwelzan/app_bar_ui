import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:app_bar_ui/app_bar_ui.dart';

void main() {
  const models = [
    AppBarModel.classic,
    AppBarModel.traditionalStructured,
    AppBarModel.fullScreenHero,
    AppBarModel.floatingIsland,
    AppBarModel.immersiveSpatial,
    AppBarModel.multiPanelSplitCurtain,
    AppBarModel.spatial3DFlip,
    AppBarModel.verticalRailTransform,
    AppBarModel.radialDial,
    AppBarModel.editorialTypography,
    AppBarModel.cardDeckStacked,
    AppBarModel.minimalistMicroBar,
    AppBarModel.profileIdentity,
    AppBarModel.expandableControlCenter,
    AppBarModel.timelineScrubberNav,
    AppBarModel.searchSpotlight,
    AppBarModel.gestureElasticCanvas,
    AppBarModel.adaptiveBreakpointNav,
    AppBarModel.contextFocalSwapNav,
    AppBarModel.liquidWaveMorphNav,
    AppBarModel.developerCustomCanvas,
  ];

  group('Phase 7: Comprehensive Responsive & Overflow Matrix Tests', () {
    testWidgets('1. Small Mobile (320px) Viewport: Zero RenderFlex Overflow across all 21 models', (tester) async {
      tester.view.physicalSize = const Size(320, 568);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      for (final model in models) {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: CustomScrollView(
                slivers: [
                  AppBarEngine.sliver(
                    model: model,
                    title: 'Small Mobile Long Title Text for Resilience',
                    subtitle: 'Subtitle on Small Mobile Viewport',
                    leading: const Icon(Icons.menu),
                    actions: const [
                      Icon(Icons.search),
                      Icon(Icons.more_vert),
                    ],
                  ),
                  SliverToBoxAdapter(
                    child: Container(height: 800, color: Colors.grey.shade200),
                  ),
                ],
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(tester.takeException(), isNull, reason: 'Failed on expanded state for model $model at 320px');

        // Scroll to collapse
        await tester.drag(find.byType(CustomScrollView), const Offset(0, -350));
        await tester.pumpAndSettle();

        expect(tester.takeException(), isNull, reason: 'Failed on collapsed state for model $model at 320px');
      }
    });

    testWidgets('2. Large Text Scale (2.0x Accessibility): Zero Overflow across all 21 models', (tester) async {
      tester.view.physicalSize = const Size(375, 812);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      for (final model in models) {
        await tester.pumpWidget(
          MaterialApp(
            home: MediaQuery(
              data: const MediaQueryData(
                size: Size(375, 812),
                textScaler: TextScaler.linear(2.0),
              ),
              child: Scaffold(
                body: CustomScrollView(
                  slivers: [
                    AppBarEngine.sliver(
                      model: model,
                      title: 'Large 2.0x Scaled Accessible Header Title',
                      subtitle: 'Accessible Large Scale Subtitle',
                      leading: const Icon(Icons.arrow_back),
                      actions: const [
                        Icon(Icons.tune),
                      ],
                    ),
                    SliverToBoxAdapter(
                      child: Container(height: 800, color: Colors.grey.shade100),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(tester.takeException(), isNull, reason: 'Failed on 2.0x text scale for model $model');
      }
    });

    testWidgets('3. Landscape Orientation (812x375): Zero Overflow across all 21 models', (tester) async {
      tester.view.physicalSize = const Size(812, 375);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      for (final model in models) {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: CustomScrollView(
                slivers: [
                  AppBarEngine.sliver(
                    model: model,
                    title: 'Landscape Orientation Header',
                    subtitle: 'Landscape Viewport',
                    leading: const Icon(Icons.menu),
                    actions: const [
                      Icon(Icons.notifications),
                    ],
                  ),
                  SliverToBoxAdapter(
                    child: Container(height: 500, color: Colors.grey.shade300),
                  ),
                ],
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(tester.takeException(), isNull, reason: 'Failed on landscape for model $model');
      }
    });

    testWidgets('4. Ultrawide Desktop (1920x1080): Validates layout stability across all 21 models', (tester) async {
      tester.view.physicalSize = const Size(1920, 1080);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      for (final model in models) {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: CustomScrollView(
                slivers: [
                  AppBarEngine.sliver(
                    model: model,
                    title: 'Ultrawide Desktop Enterprise Workspace',
                    subtitle: 'Production Grade High-Resolution Viewport',
                    leading: const Icon(Icons.menu_open),
                    actions: const [
                      Icon(Icons.search),
                      Icon(Icons.filter_list),
                      Icon(Icons.settings),
                    ],
                  ),
                  SliverToBoxAdapter(
                    child: Container(height: 1200, color: Colors.grey.shade50),
                  ),
                ],
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(tester.takeException(), isNull, reason: 'Failed on ultrawide 1920px for model $model');
      }
    });
  });
}

