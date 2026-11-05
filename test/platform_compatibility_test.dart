import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:app_bar_ui/app_bar_ui.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final List<MethodCall> methodCalls = <MethodCall>[];

  setUp(() {
    methodCalls.clear();
    StatusBarManager.resetDebugOverrides();
    debugDefaultTargetPlatformOverride = null;
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(SystemChannels.platform, (
          MethodCall methodCall,
        ) async {
          methodCalls.add(methodCall);
          return null;
        });
  });

  tearDown(() {
    StatusBarManager.resetDebugOverrides();
    debugDefaultTargetPlatformOverride = null;
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(SystemChannels.platform, null);
  });

  Iterable<MethodCall> getStatusBarCalls() {
    return methodCalls.where(
      (c) =>
          c.method == 'SystemChrome.setEnabledSystemUIMode' ||
          c.method == 'SystemChrome.setEnabledSystemUIOverlays' ||
          c.method == 'SystemChrome.setSystemUIOverlayStyle',
    );
  }

  Widget buildSlivers(String label) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) =>
            SizedBox(height: 60.0, child: Text('$label #$index')),
        childCount: 40,
      ),
    );
  }

  group('Phase 12: Cross-Platform Compatibility Matrix Tests', () {
    testWidgets(
      'Platform 1: Android - Full status bar integration and bottom nav preservation',
      (tester) async {
        try {
          debugDefaultTargetPlatformOverride = TargetPlatform.android;
          StatusBarManager.debugOverrideSupportedPlatform = true;
          StatusBarManager.debugOverrideTargetPlatform = TargetPlatform.android;

          expect(StatusBarManager.isSupportedPlatform, isTrue);

          final controller = ScrollController();
          await tester.pumpWidget(
            MaterialApp(
              theme: ThemeData(platform: TargetPlatform.android),
              home: ScrollResponsiveScaffold(
                controller: controller,
                config: const ScrollResponsiveConfig(
                  statusBar: StatusBarConfig(
                    enabled: true,
                    visibleOverlayStyle: SystemUiOverlayStyle.dark,
                  ),
                  thresholds: ScrollThresholdConfig(
                    statusBarHideOffset: 80.0,
                    statusBarShowOffset: 40.0,
                  ),
                ),
                header: const SizedBox(
                  height: 120.0,
                  child: Text('Android Header'),
                ),
                slivers: [buildSlivers('Android Item')],
              ),
            ),
          );
          await tester.pumpAndSettle();

          // Drag to scroll down past 80.0 threshold
          await tester.drag(
            find.text('Android Item #0'),
            const Offset(0.0, -150.0),
          );
          await tester.pumpAndSettle();

          // Android must call SystemChrome with bottom overlay preserved
          final overlayCalls = methodCalls.where(
            (c) =>
                c.method == 'SystemChrome.setEnabledSystemUIMode' ||
                c.method == 'SystemChrome.setEnabledSystemUIOverlays',
          );
          expect(overlayCalls, isNotEmpty);
          final lastCall = overlayCalls.last;
          // Overlays argument must include bottom overlay so 3-button navigation / gesture pill is preserved
          expect(
            lastCall.arguments.toString(),
            contains('SystemUiOverlay.bottom'),
          );
          expect(
            lastCall.arguments.toString(),
            isNot(contains('SystemUiOverlay.top')),
          );

          controller.dispose();
        } finally {
          debugDefaultTargetPlatformOverride = null;
        }
      },
    );

    testWidgets(
      'Platform 2: iOS - Preserves home indicator and prevents safe-area content jump',
      (tester) async {
        try {
          debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
          StatusBarManager.debugOverrideSupportedPlatform = true;
          StatusBarManager.debugOverrideTargetPlatform = TargetPlatform.iOS;

          expect(StatusBarManager.isSupportedPlatform, isTrue);

          final controller = ScrollController();
          await tester.pumpWidget(
            MaterialApp(
              theme: ThemeData(platform: TargetPlatform.iOS),
              home: MediaQuery(
                data: const MediaQueryData(
                  padding: EdgeInsets.only(top: 47.0, bottom: 34.0),
                ),
                child: ScrollResponsiveScaffold(
                  controller: controller,
                  config: const ScrollResponsiveConfig(
                    statusBar: StatusBarConfig(
                      enabled: true,
                      preventContentJump: true,
                    ),
                    thresholds: ScrollThresholdConfig(
                      statusBarHideOffset: 80.0,
                      statusBarShowOffset: 40.0,
                    ),
                  ),
                  header: const SizedBox(
                    height: 120.0,
                    child: Text('iOS Header'),
                  ),
                  slivers: [buildSlivers('iOS Item')],
                ),
              ),
            ),
          );
          await tester.pumpAndSettle();

          // Verify header rendered with top safe area
          expect(find.text('iOS Header'), findsOneWidget);

          // Drag past threshold to trigger hide
          await tester.drag(
            find.text('iOS Item #0'),
            const Offset(0.0, -150.0),
          );
          await tester.pumpAndSettle();

          // Overlays call on iOS must also preserve bottom (home indicator)
          final overlayCalls = methodCalls.where(
            (c) =>
                c.method == 'SystemChrome.setEnabledSystemUIMode' ||
                c.method == 'SystemChrome.setEnabledSystemUIOverlays',
          );
          expect(overlayCalls, isNotEmpty);
          final lastCall = overlayCalls.last;
          expect(
            lastCall.arguments.toString(),
            contains('SystemUiOverlay.bottom'),
          );
          expect(
            lastCall.arguments.toString(),
            isNot(contains('SystemUiOverlay.top')),
          );

          // Now simulate OS status bar collapsing top padding from 47.0 to 0.0
          await tester.pumpWidget(
            MaterialApp(
              theme: ThemeData(platform: TargetPlatform.iOS),
              home: MediaQuery(
                data: const MediaQueryData(
                  padding: EdgeInsets.only(top: 0.0, bottom: 34.0),
                ),
                child: ScrollResponsiveScaffold(
                  controller: controller,
                  config: const ScrollResponsiveConfig(
                    statusBar: StatusBarConfig(
                      enabled: true,
                      preventContentJump: true,
                    ),
                    thresholds: ScrollThresholdConfig(
                      statusBarHideOffset: 80.0,
                      statusBarShowOffset: 40.0,
                    ),
                  ),
                  header: const SizedBox(
                    height: 120.0,
                    child: Text('iOS Header'),
                  ),
                  slivers: [buildSlivers('iOS Item')],
                ),
              ),
            ),
          );
          await tester.pumpAndSettle();

          // Scroll back to top to verify header is rendered smoothly with safe padding preserved
          controller.jumpTo(0.0);
          await tester.pumpAndSettle();

          expect(find.text('iOS Header'), findsOneWidget);

          controller.dispose();
        } finally {
          debugDefaultTargetPlatformOverride = null;
        }
      },
    );

    testWidgets(
      'Platform 3: iPadOS - Responsive viewport adaptation during Split View / Stage Manager resize',
      (tester) async {
        try {
          debugDefaultTargetPlatformOverride = TargetPlatform.iOS;

          // Full tablet screen (1024 x 768)
          tester.view.physicalSize = const Size(1024, 768);
          tester.view.devicePixelRatio = 1.0;
          addTearDown(() {
            tester.view.resetPhysicalSize();
            tester.view.resetDevicePixelRatio();
          });

          final controller = ScrollController();
          await tester.pumpWidget(
            MaterialApp(
              theme: ThemeData(platform: TargetPlatform.iOS),
              home: ScrollResponsiveScaffold(
                controller: controller,
                header: const SizedBox(
                  height: 140.0,
                  child: Text('iPad Header'),
                ),
                slivers: [buildSlivers('iPad Item')],
              ),
            ),
          );
          await tester.pumpAndSettle();
          expect(find.text('iPad Header'), findsOneWidget);

          // Simulate entering Split View 50/50 resize (500 x 768)
          tester.view.physicalSize = const Size(500, 768);
          await tester.pumpAndSettle();

          // UI should gracefully adapt with zero errors
          expect(find.text('iPad Header'), findsOneWidget);
          expect(tester.takeException(), isNull);

          controller.dispose();
        } finally {
          debugDefaultTargetPlatformOverride = null;
        }
      },
    );

    testWidgets(
      'Platform 4: macOS - Safe no-op status bar and mouse wheel scroll support',
      (tester) async {
        try {
          debugDefaultTargetPlatformOverride = TargetPlatform.macOS;
          StatusBarManager.debugOverrideSupportedPlatform = false;

          expect(StatusBarManager.isSupportedPlatform, isFalse);

          final controller = ScrollController();
          double? reportedProgress;

          await tester.pumpWidget(
            MaterialApp(
              theme: ThemeData(platform: TargetPlatform.macOS),
              home: ScrollResponsiveScaffold(
                controller: controller,
                onScrollUpdate: (details) {
                  reportedProgress = details.leadingProgress;
                },
                config: const ScrollResponsiveConfig(
                  thresholds: ScrollThresholdConfig(
                    leadingStartOffset: 0.0,
                    leadingEndOffset: 100.0,
                  ),
                  statusBar: StatusBarConfig(enabled: true),
                ),
                header: const SizedBox(
                  height: 100.0,
                  child: Text('macOS Header'),
                ),
                slivers: [buildSlivers('macOS Row')],
              ),
            ),
          );
          await tester.pumpAndSettle();

          // Simulate mouse wheel pointer scroll event
          final pointer = TestPointer(1, PointerDeviceKind.mouse);
          await tester.sendEventToBinding(
            pointer.hover(const Offset(200, 200)),
          );
          await tester.sendEventToBinding(
            pointer.scroll(const Offset(0, 60.0)),
          );
          await tester.pumpAndSettle();

          // Progress should update smoothly from mouse wheel input
          expect(reportedProgress, isNotNull);
          expect(reportedProgress!, greaterThan(0.0));

          // macOS window chrome is managed by AppKit - SystemChrome status bar calls must be zero
          expect(getStatusBarCalls(), isEmpty);
          expect(tester.takeException(), isNull);

          controller.dispose();
        } finally {
          debugDefaultTargetPlatformOverride = null;
        }
      },
    );

    testWidgets(
      'Platform 5: Windows - Graceful fallback and desktop mouse interactions',
      (tester) async {
        try {
          debugDefaultTargetPlatformOverride = TargetPlatform.windows;
          StatusBarManager.debugOverrideSupportedPlatform = false;

          expect(StatusBarManager.isSupportedPlatform, isFalse);

          final controller = ScrollController();
          await tester.pumpWidget(
            MaterialApp(
              theme: ThemeData(platform: TargetPlatform.windows),
              home: ScrollResponsiveScaffold(
                controller: controller,
                config: const ScrollResponsiveConfig(
                  statusBar: StatusBarConfig(enabled: true),
                ),
                header: const SizedBox(
                  height: 80.0,
                  child: Text('Windows Header'),
                ),
                slivers: [buildSlivers('Win Item')],
              ),
            ),
          );
          await tester.pumpAndSettle();

          await tester.drag(
            find.text('Win Item #0'),
            const Offset(0.0, -150.0),
          );
          await tester.pumpAndSettle();

          // Windows system UI is managed by DWM - zero status bar channel calls, zero exceptions
          expect(getStatusBarCalls(), isEmpty);
          expect(tester.takeException(), isNull);

          controller.dispose();
        } finally {
          debugDefaultTargetPlatformOverride = null;
        }
      },
    );

    testWidgets(
      'Platform 6: Linux - Graceful fallback for window-manager managed UI',
      (tester) async {
        try {
          debugDefaultTargetPlatformOverride = TargetPlatform.linux;
          StatusBarManager.debugOverrideSupportedPlatform = false;

          expect(StatusBarManager.isSupportedPlatform, isFalse);

          final controller = ScrollController();
          await tester.pumpWidget(
            MaterialApp(
              theme: ThemeData(platform: TargetPlatform.linux),
              home: ScrollResponsiveScaffold(
                controller: controller,
                config: const ScrollResponsiveConfig(
                  statusBar: StatusBarConfig(enabled: true),
                ),
                header: const SizedBox(
                  height: 80.0,
                  child: Text('Linux Header'),
                ),
                slivers: [buildSlivers('Linux Item')],
              ),
            ),
          );
          await tester.pumpAndSettle();

          await tester.drag(
            find.text('Linux Item #0'),
            const Offset(0.0, -150.0),
          );
          await tester.pumpAndSettle();

          // Zero status bar calls on Linux
          expect(getStatusBarCalls(), isEmpty);
          expect(tester.takeException(), isNull);

          controller.dispose();
        } finally {
          debugDefaultTargetPlatformOverride = null;
        }
      },
    );

    testWidgets(
      'Platform 7: Web - Browser chrome no-op and pointer events compatibility',
      (tester) async {
        // Simulate Web environment
        StatusBarManager.debugOverrideSupportedPlatform = false;

        final controller = ScrollController();
        double? currentLeadingProgress;

        await tester.pumpWidget(
          MaterialApp(
            home: ScrollResponsiveScaffold(
              controller: controller,
              onScrollUpdate: (details) {
                currentLeadingProgress = details.leadingProgress;
              },
              config: const ScrollResponsiveConfig(
                thresholds: ScrollThresholdConfig(
                  leadingStartOffset: 0.0,
                  leadingEndOffset: 100.0,
                ),
                statusBar: StatusBarConfig(enabled: true),
              ),
              header: const SizedBox(height: 100.0, child: Text('Web Header')),
              slivers: [buildSlivers('Web Row')],
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Web mouse wheel scroll
        final pointer = TestPointer(1, PointerDeviceKind.mouse);
        await tester.sendEventToBinding(pointer.hover(const Offset(300, 300)));
        await tester.sendEventToBinding(pointer.scroll(const Offset(0, 80.0)));
        await tester.pumpAndSettle();

        expect(currentLeadingProgress, isNotNull);
        expect(currentLeadingProgress!, closeTo(0.8, 0.05));

        // No platform exceptions or unauthorized status bar changes
        expect(getStatusBarCalls(), isEmpty);
        expect(tester.takeException(), isNull);

        controller.dispose();
      },
    );

    testWidgets(
      'Accessibility & Reduced Motion: suppresses scale and slide when disableAnimations is active',
      (tester) async {
        bool tappedInitial = false;

        await tester.pumpWidget(
          MaterialApp(
            home: MediaQuery(
              // Simulate user setting "Reduce Motion" in system accessibility preferences
              data: const MediaQueryData(disableAnimations: true),
              child: Scaffold(
                body: Center(
                  child: PinnedActionButton(
                    progress: 0.0,
                    initialWidget: const Icon(Icons.menu),
                    scrolledWidget: const Icon(Icons.arrow_back),
                    onInitialTap: () => tappedInitial = true,
                    animationConfig: const ScrollAnimationConfig(
                      enableScale: true,
                      enableSlide: true,
                      enableFade: true,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Under reduced motion: scale and slide transforms are safely suppressed
        expect(find.byKey(const ValueKey('pinned_action_scale')), findsNothing);
        expect(find.byKey(const ValueKey('pinned_action_slide')), findsNothing);

        // But opacity cross-fade (both initial and scrolled layers) and full interactivity remain intact
        expect(
          find.byKey(const ValueKey('pinned_action_fade')),
          findsNWidgets(2),
        );
        await tester.tap(find.byIcon(Icons.menu));
        expect(tappedInitial, isTrue);
      },
    );

    testWidgets(
      'ScrollTransform suppresses translation, rotation and scale when disableAnimations is active',
      (tester) async {
        final notifier = ValueNotifier<double>(0.5);

        await tester.pumpWidget(
          MaterialApp(
            home: MediaQuery(
              data: const MediaQueryData(disableAnimations: true),
              child: Center(
                child: ScrollTransform(
                  progressListenable: notifier,
                  enableReducedMotionAwareness: true,
                  translation: const ScrollRange(
                    begin: Offset.zero,
                    end: Offset(50, 50),
                  ),
                  scale: const ScrollRange(begin: 1.0, end: 1.5),
                  rotation: const ScrollRange(begin: 0.0, end: 3.14),
                  child: const Text('Accessible Content'),
                ),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('Accessible Content'), findsOneWidget);
        // Transforms are suppressed, content renders directly without Transform.translate/rotate/scale
        expect(find.byType(Transform), findsNothing);

        notifier.dispose();
      },
    );
  });
}
