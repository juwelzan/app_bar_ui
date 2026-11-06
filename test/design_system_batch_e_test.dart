import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:app_bar_ui/app_bar_ui.dart';

void main() {
  group('Complete AppBar Design System — Batch E: Models 17–20 Tests', () {
    testWidgets(
      'Model 17: AdaptiveBreakpointNavHeaderWidget adapts layout across compact, medium, and expanded breakpoints',
      (tester) async {
        // Test Compact breakpoint (<600px)
        tester.view.physicalSize = const Size(400, 800);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: CustomScrollView(
                slivers: [
                  const AdaptiveBreakpointNavHeaderWidget(
                    config: AdaptiveBreakpointNavConfig(
                      title: 'Enterprise Hub',
                      compactSubtitle: 'Mobile Viewport Active',
                      mediumSubtitle: 'Tablet Layout Active',
                      expandedSubtitle: 'Desktop Command Active',
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => ListTile(title: Text('Item $index')),
                      childCount: 20,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();
        expect(find.text('Enterprise Hub'), findsOneWidget);
        expect(find.text('Mobile Viewport Active'), findsOneWidget);
        expect(find.text('COMPACT'), findsOneWidget);

        // Resize to Medium breakpoint (800px)
        tester.view.physicalSize = const Size(800, 800);
        await tester.pumpAndSettle();

        expect(find.text('Tablet Layout Active'), findsOneWidget);
        expect(find.text('MEDIUM'), findsOneWidget);

        // Resize to Expanded breakpoint (1200px)
        tester.view.physicalSize = const Size(1200, 800);
        await tester.pumpAndSettle();

        expect(find.text('Desktop Command Active'), findsOneWidget);
        expect(find.text('EXPANDED'), findsOneWidget);

        // Scroll to collapse
        await tester.drag(find.byType(CustomScrollView), const Offset(0.0, -250.0));
        await tester.pumpAndSettle();

        expect(tester.takeException(), isNull);
      },
    );

    testWidgets(
      'Model 18: ContextFocalSwapNavHeaderWidget renders domains, toggles context, and collapses cleanly',
      (tester) async {
        int? selectedIndex;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: CustomScrollView(
                slivers: [
                  ContextFocalSwapNavHeaderWidget(
                    config: ContextFocalSwapNavConfig(
                      activeDomainIndex: 0,
                      domains: const [
                        FocalDomainContext(
                          name: 'Kubernetes Pods',
                          primaryMetric: '128 / 128 Online',
                          metricLabel: 'Active Cluster Status',
                          icon: Icons.memory,
                        ),
                        FocalDomainContext(
                          name: 'Traffic Ingress',
                          primaryMetric: '48.2 k req/sec',
                          metricLabel: 'Peak Gate Throughput',
                          icon: Icons.network_check,
                        ),
                      ],
                      onDomainSwapped: (index) {
                        selectedIndex = index;
                      },
                      expandedHeight: 180.0,
                      collapsedHeight: 58.0,
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => ListTile(title: Text('Log Entry $index')),
                      childCount: 20,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Verify active metric and domain chips
        expect(find.text('128 / 128 Online'), findsOneWidget);
        expect(find.text('Kubernetes Pods'), findsWidgets);
        expect(find.text('Traffic Ingress'), findsOneWidget);

        // Tap the second domain pill
        await tester.tap(find.text('Traffic Ingress'));
        await tester.pumpAndSettle();
        expect(selectedIndex, equals(1));

        // Scroll to collapse
        await tester.drag(find.byType(CustomScrollView), const Offset(0.0, -180.0));
        await tester.pumpAndSettle();

        expect(tester.takeException(), isNull);
      },
    );

    testWidgets(
      'Model 19: LiquidWaveMorphNavHeaderWidget renders sinusoidal crest and dampens on scroll',
      (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: CustomScrollView(
                slivers: [
                  const LiquidWaveMorphNavHeaderWidget(
                    config: LiquidWaveMorphNavConfig(
                      title: 'Fluid Organic Dynamics',
                      subtitle: 'Continuous harmonic wave boundary',
                      waveAmplitude: 24.0,
                      waveFrequency: 2.0,
                      expandedHeight: 190.0,
                      collapsedHeight: 60.0,
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => ListTile(title: Text('Sample $index')),
                      childCount: 20,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();
        expect(find.text('Fluid Organic Dynamics'), findsOneWidget);
        expect(find.text('Continuous harmonic wave boundary'), findsOneWidget);

        // Scroll down to flatten the sinusoidal wave
        await tester.drag(find.byType(CustomScrollView), const Offset(0.0, -180.0));
        await tester.pumpAndSettle();

        expect(find.text('Fluid Organic Dynamics'), findsOneWidget);
        expect(tester.takeException(), isNull);
      },
    );

    testWidgets(
      'Model 20: DeveloperCustomCanvasHeaderWidget renders blueprint inspector grid and executes custom builder',
      (tester) async {
        bool builderExecuted = false;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: CustomScrollView(
                slivers: [
                  DeveloperCustomCanvasHeaderWidget(
                    config: DeveloperCustomCanvasConfig(
                      showBlueprintGrid: true,
                      expandedHeight: 170.0,
                      collapsedHeight: 56.0,
                      builder: (context, shrinkOffset, progress) {
                        builderExecuted = true;
                        return Center(
                          child: Text(
                            'Custom Telemetry: ${(progress * 100).toInt()}%',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        );
                      },
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => ListTile(title: Text('Row $index')),
                      childCount: 20,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();
        expect(builderExecuted, isTrue);
        expect(find.text('Custom Telemetry: 0%'), findsOneWidget);

        // Scroll down to test telemetry update
        await tester.drag(find.byType(CustomScrollView), const Offset(0.0, -250.0));
        await tester.pumpAndSettle();

        expect(find.textContaining('Custom Telemetry:'), findsOneWidget);
        expect(tester.takeException(), isNull);
      },
    );

    testWidgets(
      'Batch E: Universal AppBarEngine renders Batch E models via Preset and Configured Modes',
      (tester) async {
        // Level 1: Preset Mode for Model 17
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: AppBarEngine(
                model: AppBarModel.adaptiveBreakpointNav,
                body: Center(child: Text('Content')),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();
        expect(find.byType(AdaptiveBreakpointNavHeaderWidget), findsOneWidget);

        // Level 2: Configured Mode for Model 18
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: AppBarEngine.custom(
                model: AppBarModel.contextFocalSwapNav,
                configuration: ContextFocalSwapNavConfig(
                  domains: [
                    FocalDomainContext(
                      name: 'Custom Domain',
                      primaryMetric: '999K Ops',
                      metricLabel: 'Peak Load',
                      icon: Icons.flash_on,
                    ),
                  ],
                ),
                body: Center(child: Text('Content')),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();
        expect(find.text('999K Ops'), findsOneWidget);
      },
    );

    testWidgets(
      'Batch E: Zero-leak model switching across Models 17, 18, 19, and 20',
      (tester) async {
        final controller = AppBarController(initialModel: AppBarModel.adaptiveBreakpointNav);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: AppBarEngine(
                controller: controller,
                model: AppBarModel.adaptiveBreakpointNav,
                body: const Center(child: Text('Engine Body')),
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();
        expect(controller.currentModel, equals(AppBarModel.adaptiveBreakpointNav));
        expect(find.byType(AdaptiveBreakpointNavHeaderWidget), findsOneWidget);

        // Switch to Model 18: contextFocalSwapNav
        controller.changeModel(AppBarModel.contextFocalSwapNav);
        await tester.pumpAndSettle();

        expect(controller.currentModel, equals(AppBarModel.contextFocalSwapNav));
        expect(find.byType(AdaptiveBreakpointNavHeaderWidget), findsNothing);
        expect(find.byType(ContextFocalSwapNavHeaderWidget), findsOneWidget);

        // Switch to Model 19: liquidWaveMorphNav
        controller.changeModel(AppBarModel.liquidWaveMorphNav);
        await tester.pumpAndSettle();

        expect(controller.currentModel, equals(AppBarModel.liquidWaveMorphNav));
        expect(find.byType(ContextFocalSwapNavHeaderWidget), findsNothing);
        expect(find.byType(LiquidWaveMorphNavHeaderWidget), findsOneWidget);

        // Switch to Model 20: developerCustomCanvas
        controller.changeModel(AppBarModel.developerCustomCanvas);
        await tester.pumpAndSettle();

        expect(controller.currentModel, equals(AppBarModel.developerCustomCanvas));
        expect(find.byType(LiquidWaveMorphNavHeaderWidget), findsNothing);
        expect(find.byType(DeveloperCustomCanvasHeaderWidget), findsOneWidget);
      },
    );

    testWidgets(
      'Batch E: Accessibility reduced motion fallbacks render cleanly without layout exceptions',
      (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) {
                return MediaQuery(
                  data: MediaQuery.of(context).copyWith(disableAnimations: true),
                  child: Scaffold(
                    body: CustomScrollView(
                      slivers: [
                        const AdaptiveBreakpointNavHeaderWidget(
                          config: AdaptiveBreakpointNavConfig(
                            title: 'Accessible Adaptive',
                            compactHeight: 140.0,
                            collapsedHeight: 50.0,
                          ),
                        ),
                        const ContextFocalSwapNavHeaderWidget(
                          config: ContextFocalSwapNavConfig(
                            expandedHeight: 140.0,
                            collapsedHeight: 50.0,
                          ),
                        ),
                        const LiquidWaveMorphNavHeaderWidget(
                          config: LiquidWaveMorphNavConfig(
                            title: 'Accessible Liquid',
                            expandedHeight: 140.0,
                            collapsedHeight: 50.0,
                          ),
                        ),
                        const DeveloperCustomCanvasHeaderWidget(
                          config: DeveloperCustomCanvasConfig(
                            expandedHeight: 140.0,
                            collapsedHeight: 50.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        );

        await tester.pumpAndSettle();
        expect(find.text('Accessible Adaptive'), findsWidgets);
        expect(find.text('Accessible Liquid'), findsWidgets);

        // Scroll across all slivers under reduced motion
        await tester.drag(find.byType(CustomScrollView), const Offset(0.0, -300.0));
        await tester.pumpAndSettle();

        expect(tester.takeException(), isNull);
      },
    );
  });
}
