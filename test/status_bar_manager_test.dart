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
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(SystemChannels.platform, null);
  });

  group('StatusBarManager - Platform Integration & Logic', () {
    test('initializes with hidden state as false and unmodified system UI', () {
      final manager = StatusBarManager(
        config: const StatusBarConfig(),
        thresholds: const ScrollThresholdConfig(),
      );

      expect(manager.isStatusBarHidden, isFalse);
      expect(manager.hasModifiedSystemUi, isFalse);
      expect(methodCalls, isEmpty);
    });

    test('hides status bar when scrolling past statusBarHideOffset on supported platform', () async {
      StatusBarManager.debugOverrideSupportedPlatform = true;

      final manager = StatusBarManager(
        config: const StatusBarConfig(),
        thresholds: const ScrollThresholdConfig(
          statusBarHideOffset: 100.0,
          statusBarShowOffset: 50.0,
        ),
      );

      // Scroll below threshold - should not hide
      manager.updateScrollOffset(80.0);
      await Future<void>.delayed(Duration.zero);
      expect(manager.isStatusBarHidden, isFalse);
      expect(methodCalls, isEmpty);

      // Scroll past threshold - hides
      manager.updateScrollOffset(110.0);
      await Future<void>.delayed(Duration.zero);
      expect(manager.isStatusBarHidden, isTrue);
      expect(manager.hasModifiedSystemUi, isTrue);
      expect(methodCalls, isNotEmpty);
    });

    test('restores status bar when scrolling back below statusBarShowOffset (hysteresis)', () async {
      StatusBarManager.debugOverrideSupportedPlatform = true;

      final manager = StatusBarManager(
        config: const StatusBarConfig(),
        thresholds: const ScrollThresholdConfig(
          statusBarHideOffset: 100.0,
          statusBarShowOffset: 50.0,
        ),
      );

      // Hide at 120
      manager.updateScrollOffset(120.0);
      await Future<void>.delayed(Duration.zero);
      expect(manager.isStatusBarHidden, isTrue);
      methodCalls.clear();

      // Scroll into deadband (70px) - should remain hidden!
      manager.updateScrollOffset(70.0);
      await Future<void>.delayed(Duration.zero);
      expect(manager.isStatusBarHidden, isTrue);
      expect(methodCalls, isEmpty); // No calls in hysteresis deadband!

      // Scroll below show offset (40px) - restores
      manager.updateScrollOffset(40.0);
      await Future<void>.delayed(Duration.zero);
      expect(manager.isStatusBarHidden, isFalse);
      expect(methodCalls, isNotEmpty);
    });

    test(
      'preserves bottom navigation controls when hiding status bar',
      () async {
        StatusBarManager.debugOverrideSupportedPlatform = true;

        const customOverlays = [SystemUiOverlay.bottom];
        final manager = StatusBarManager(
          config: const StatusBarConfig(
            hiddenUiMode: SystemUiMode.manual,
            hiddenOverlays: customOverlays,
          ),
          thresholds: const ScrollThresholdConfig(statusBarHideOffset: 80.0),
        );

        manager.updateScrollOffset(90.0);
        await Future<void>.delayed(Duration.zero);

        expect(manager.isStatusBarHidden, isTrue);
        // Verify setEnabledSystemUIMode or setEnabledSystemUIOverlays was invoked with bottom overlay
        final overlayCalls = methodCalls.where(
          (c) =>
              c.method == 'SystemChrome.setEnabledSystemUIMode' ||
              c.method == 'SystemChrome.setEnabledSystemUIOverlays',
        );
        expect(overlayCalls, isNotEmpty);
      },
    );

    test('avoids repeated SystemChrome calls on subsequent scroll frames past threshold', () async {
      StatusBarManager.debugOverrideSupportedPlatform = true;

      final manager = StatusBarManager(
        config: const StatusBarConfig(),
        thresholds: const ScrollThresholdConfig(
          statusBarHideOffset: 100.0,
          statusBarShowOffset: 50.0,
        ),
      );

      // Scroll past threshold
      manager.updateScrollOffset(105.0);
      await Future<void>.delayed(Duration.zero);
      final initialCallCount = methodCalls.length;
      expect(initialCallCount, greaterThan(0));

      // Subsequent scroll frames deeper down
      manager.updateScrollOffset(120.0);
      manager.updateScrollOffset(150.0);
      manager.updateScrollOffset(200.0);
      manager.updateScrollOffset(250.0);
      await Future<void>.delayed(Duration.zero);

      // Zero additional platform calls!
      expect(methodCalls.length, initialCallCount);
    });

    test(
      'serialized async queue prevents out-of-order race conditions',
      () async {
        StatusBarManager.debugOverrideSupportedPlatform = true;

        final manager = StatusBarManager(
          config: const StatusBarConfig(),
          thresholds: const ScrollThresholdConfig(
            statusBarHideOffset: 100.0,
            statusBarShowOffset: 50.0,
          ),
        );

        // Rapid conflicting triggers (hide, then show immediately)
        manager.setStatusBarHidden(true);
        manager.setStatusBarHidden(false);
        await Future<void>.delayed(const Duration(milliseconds: 50));

        // Final state must reliably be false (the last requested state)
        expect(manager.isStatusBarHidden, isFalse);
      },
    );

    test(
      'resolves platform-specific overlay styles for Android vs iOS',
      () async {
        StatusBarManager.debugOverrideSupportedPlatform = true;

        const androidHiddenStyle = SystemUiOverlayStyle(
          statusBarColor: Colors.black,
          statusBarIconBrightness: Brightness.light,
          systemNavigationBarColor: Colors.black,
        );

        const iosHiddenStyle = SystemUiOverlayStyle(
          statusBarBrightness: Brightness.dark,
        );

        final config = const StatusBarConfig(
          androidHiddenOverlayStyle: androidHiddenStyle,
          iosHiddenOverlayStyle: iosHiddenStyle,
        );

        // Verify Android resolution
        StatusBarManager.debugOverrideTargetPlatform = TargetPlatform.android;
        expect(
          config.resolveHiddenOverlayStyle(TargetPlatform.android),
          androidHiddenStyle,
        );

        final androidManager = StatusBarManager(
          config: config,
          thresholds: const ScrollThresholdConfig(statusBarHideOffset: 50.0),
        );
        androidManager.updateScrollOffset(60.0);
        await Future<void>.delayed(Duration.zero);

        final styleCalls = methodCalls
            .where((c) => c.method == 'SystemChrome.setSystemUIOverlayStyle')
            .toList();
        expect(styleCalls, isNotEmpty);

        // Verify iOS resolution
        methodCalls.clear();
        StatusBarManager.debugOverrideTargetPlatform = TargetPlatform.iOS;
        expect(
          config.resolveHiddenOverlayStyle(TargetPlatform.iOS),
          iosHiddenStyle,
        );

        final iosManager = StatusBarManager(
          config: config,
          thresholds: const ScrollThresholdConfig(statusBarHideOffset: 50.0),
        );
        iosManager.updateScrollOffset(60.0);
        await Future<void>.delayed(Duration.zero);

        final iosStyleCalls = methodCalls
            .where((c) => c.method == 'SystemChrome.setSystemUIOverlayStyle')
            .toList();
        expect(iosStyleCalls, isNotEmpty);
      },
    );

    test('gracefully falls back on Web and Desktop without throwing exceptions', () async {
      StatusBarManager.debugOverrideSupportedPlatform = false;

      final manager = StatusBarManager(
        config: const StatusBarConfig(),
        thresholds: const ScrollThresholdConfig(statusBarHideOffset: 80.0),
      );

      // Should safely update internal state without invoking platform channels
      manager.updateScrollOffset(100.0);
      await Future<void>.delayed(Duration.zero);
      expect(manager.isStatusBarHidden, isTrue);
      expect(
        methodCalls,
        isEmpty,
      ); // Platform channels never touched on desktop/web!

      manager.updateScrollOffset(20.0);
      await Future<void>.delayed(Duration.zero);
      expect(manager.isStatusBarHidden, isFalse);
      expect(methodCalls, isEmpty);

      await manager.restore();
      expect(methodCalls, isEmpty);
    });

    test(
      'saves and restores previous system UI configuration on restore()',
      () async {
        StatusBarManager.debugOverrideSupportedPlatform = true;

        final manager = StatusBarManager(
          config: const StatusBarConfig(),
          thresholds: const ScrollThresholdConfig(statusBarHideOffset: 100.0),
        );

        // Never modified - restore should do nothing
        await manager.restore();
        expect(methodCalls, isEmpty);

        // Modify by scrolling
        manager.updateScrollOffset(120.0);
        await Future<void>.delayed(Duration.zero);
        expect(manager.hasModifiedSystemUi, isTrue);
        methodCalls.clear();

        // Restore should restore visible overlays
        await manager.restore();
        expect(manager.isStatusBarHidden, isFalse);
        expect(manager.hasModifiedSystemUi, isFalse);
        expect(methodCalls, isNotEmpty);
      },
    );

    test('handles route push and pop transitions seamlessly', () async {
      StatusBarManager.debugOverrideSupportedPlatform = true;

      final manager = StatusBarManager(
        config: const StatusBarConfig(restoreOnRouteTransition: true),
        thresholds: const ScrollThresholdConfig(
          statusBarHideOffset: 100.0,
          statusBarShowOffset: 50.0,
        ),
      );

      // Hide status bar
      manager.updateScrollOffset(120.0);
      await Future<void>.delayed(Duration.zero);
      expect(manager.isStatusBarHidden, isTrue);

      // Route pushed: temporarily restore status bar
      await manager.handleRoutePushed();
      expect(manager.isStatusBarHidden, isFalse);

      // Route popped: return at offset 120 (past threshold) -> reapply hidden state
      await manager.handleRoutePopped(120.0);
      expect(manager.isStatusBarHidden, isTrue);

      // Route popped: return at offset 20 (at top) -> reapply visible state
      await manager.handleRoutePopped(20.0);
      expect(manager.isStatusBarHidden, isFalse);
    });

    test('handles app lifecycle changes cleanly (resumed)', () async {
      StatusBarManager.debugOverrideSupportedPlatform = true;

      final manager = StatusBarManager(
        config: const StatusBarConfig(),
        thresholds: const ScrollThresholdConfig(statusBarHideOffset: 100.0),
      );

      // Scroll to hide
      manager.updateScrollOffset(120.0);
      await Future<void>.delayed(Duration.zero);
      expect(manager.isStatusBarHidden, isTrue);

      // When app resumes while scrolled down, reapplies state
      await manager.handleAppLifecycleStateChanged(
        AppLifecycleState.resumed,
        120.0,
      );
      expect(manager.isStatusBarHidden, isTrue);
    });

    test('disabled configuration ignores all scroll updates', () async {
      StatusBarManager.debugOverrideSupportedPlatform = true;

      final manager = StatusBarManager(
        config: const StatusBarConfig(enabled: false),
        thresholds: const ScrollThresholdConfig(statusBarHideOffset: 50.0),
      );

      manager.updateScrollOffset(200.0);
      await Future<void>.delayed(Duration.zero);

      expect(manager.isStatusBarHidden, isFalse);
      expect(methodCalls, isEmpty);
    });
  });
}
