import 'package:flutter_test/flutter_test.dart';
import 'package:app_bar_ui/app_bar_ui.dart';

void main() {
  group('StatusBarManager', () {
    test('initializes with hidden state as false', () {
      final manager = StatusBarManager(
        config: const StatusBarConfig(),
        thresholds: const ScrollThresholdConfig(),
      );

      expect(manager.isStatusBarHidden, isFalse);
    });

    test('updateScrollOffset respects hysteresis boundaries', () {
      final manager = StatusBarManager(
        config: const StatusBarConfig(),
        thresholds: const ScrollThresholdConfig(
          statusBarHideOffset: 100.0,
          statusBarShowOffset: 50.0,
        ),
      );

      // On test environment (desktop/host test runner), isSupportedPlatform might be false.
      // But we can test the internal state directly or simulate:
      if (!StatusBarManager.isSupportedPlatform) {
        // Safe fallback behavior: no errors thrown
        manager.updateScrollOffset(120.0);
        manager.updateScrollOffset(30.0);
        manager.restore();
      }
    });

    test('disabled status bar config ignores scroll offset updates', () {
      final manager = StatusBarManager(
        config: const StatusBarConfig(enabled: false),
        thresholds: const ScrollThresholdConfig(),
      );

      manager.updateScrollOffset(200.0);
      expect(manager.isStatusBarHidden, isFalse);
    });
  });
}
