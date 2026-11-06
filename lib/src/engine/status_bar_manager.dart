import 'dart:ui' show AppLifecycleState;

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import '../models/scroll_responsive_config.dart';

/// Manages native mobile System Status Bar visibility with threshold-based
/// hysteresis, serialized asynchronous platform channel invocation, route awareness,
/// and separate handling for Android and iOS.
class StatusBarManager {
  /// Creates a [StatusBarManager] with the given configuration.
  StatusBarManager({required this.config, required this.thresholds});

  /// The active status bar configuration.
  StatusBarConfig config;

  /// The active threshold configuration.
  ScrollThresholdConfig thresholds;

  bool _isStatusBarHidden = false;
  bool _hasModifiedSystemUi = false;

  /// In-flight processing lock to prevent race conditions during rapid scrolling.
  bool _isProcessing = false;
  bool? _pendingTargetState;

  /// Test hook to simulate supported platform in unit and widget tests.
  @visibleForTesting
  static bool? debugOverrideSupportedPlatform;

  /// Test hook to simulate target platform (Android vs iOS) in tests.
  @visibleForTesting
  static TargetPlatform? debugOverrideTargetPlatform;

  /// Resets test overrides.
  @visibleForTesting
  static void resetDebugOverrides() {
    debugOverrideSupportedPlatform = null;
    debugOverrideTargetPlatform = null;
  }

  /// Whether the status bar is currently hidden.
  bool get isStatusBarHidden => _isStatusBarHidden;

  /// Whether system UI has been modified from its initial configuration.
  bool get hasModifiedSystemUi => _hasModifiedSystemUi;

  /// Whether the host platform supports native status bar manipulation.
  static bool get isSupportedPlatform {
    if (debugOverrideSupportedPlatform != null) {
      return debugOverrideSupportedPlatform!;
    }
    if (kIsWeb) return false;
    return defaultTargetPlatform == TargetPlatform.android ||
        defaultTargetPlatform == TargetPlatform.iOS;
  }

  /// Current target platform resolved safely across test and production environments.
  static TargetPlatform get currentPlatform {
    if (debugOverrideTargetPlatform != null) {
      return debugOverrideTargetPlatform!;
    }
    return defaultTargetPlatform;
  }

  /// Evaluates the scroll [offset] against thresholds and updates status bar
  /// visibility when crossing boundaries.
  ///
  /// Uses hysteresis ([ScrollThresholdConfig.statusBarHideOffset] vs
  /// [ScrollThresholdConfig.statusBarShowOffset]) to prevent rapid flickering.
  void updateScrollOffset(double offset) {
    if (!config.enabled || !config.hideOnScroll) {
      return;
    }

    if (offset >= thresholds.statusBarHideOffset && !_isStatusBarHidden) {
      setStatusBarHidden(true);
    } else if (offset <= thresholds.statusBarShowOffset && _isStatusBarHidden) {
      setStatusBarHidden(false);
    }
  }

  /// Reapplies status bar state based on the provided scroll [offset].
  ///
  /// Useful when returning from another route or waking up from app pause.
  Future<void> reapplyCurrentState(double offset) async {
    if (!config.enabled || !config.hideOnScroll) return;

    if (offset >= thresholds.statusBarHideOffset) {
      await setStatusBarHidden(true);
    } else if (offset <= thresholds.statusBarShowOffset) {
      await setStatusBarHidden(false);
    }
  }

  /// Handles route push transition: temporarily restores status bar if configured.
  Future<void> handleRoutePushed() async {
    if (!config.enabled || !config.restoreOnRouteTransition) return;
    if (_isStatusBarHidden) {
      await setStatusBarHidden(false);
    }
  }

  /// Handles route pop transition: re-evaluates status bar based on [currentOffset].
  Future<void> handleRoutePopped(double currentOffset) async {
    if (!config.enabled || !config.restoreOnRouteTransition) return;
    await reapplyCurrentState(currentOffset);
  }

  /// Handles app lifecycle state transitions (e.g. app paused or resumed).
  Future<void> handleAppLifecycleStateChanged(
    AppLifecycleState state,
    double currentOffset,
  ) async {
    if (!config.enabled) return;
    if (state == AppLifecycleState.resumed && _hasModifiedSystemUi) {
      await reapplyCurrentState(currentOffset);
    }
  }

  /// Sets the status bar hidden state.
  ///
  /// Serializes asynchronous calls to prevent race conditions during rapid scroll fling
  /// or reverse bounces. On unsupported platforms (Web/Desktop), updates the logical
  /// state safely without calling [SystemChrome].
  Future<void> setStatusBarHidden(bool hidden) async {
    if (!config.enabled) return;

    // On unsupported platforms (Web, macOS, Windows, Linux), update logical state only.
    if (!isSupportedPlatform) {
      _isStatusBarHidden = hidden;
      return;
    }

    // If already in target state and no operation is in flight, skip redundant invocation.
    if (_isStatusBarHidden == hidden &&
        _hasModifiedSystemUi &&
        !_isProcessing) {
      return;
    }

    // Queue request if another platform channel call is currently in flight.
    if (_isProcessing) {
      _pendingTargetState = hidden;
      return;
    }

    _isProcessing = true;
    bool targetState = hidden;

    try {
      while (true) {
        _isStatusBarHidden = targetState;
        _hasModifiedSystemUi = true;

        final platform = currentPlatform;

        if (targetState) {
          // Hide top status bar while preserving bottom navigation
          await SystemChrome.setEnabledSystemUIMode(
            config.hiddenUiMode,
            overlays: config.hiddenOverlays,
          );

          final style = config.resolveHiddenOverlayStyle(platform);
          if (style != null) {
            SystemChrome.setSystemUIOverlayStyle(style);
          }
        } else {
          // Restore visible status bar
          await SystemChrome.setEnabledSystemUIMode(
            config.visibleUiMode,
            overlays: config.visibleOverlays,
          );

          final style = config.resolveVisibleOverlayStyle(platform);
          if (style != null) {
            SystemChrome.setSystemUIOverlayStyle(style);
          }
        }

        // Check if another state was requested while in flight
        if (_pendingTargetState != null &&
            _pendingTargetState != _isStatusBarHidden) {
          targetState = _pendingTargetState!;
          _pendingTargetState = null;
        } else {
          _pendingTargetState = null;
          break;
        }
      }
    } catch (e) {
      // Graceful fallback on environments where SystemChrome calls fail
      debugPrint('StatusBarManager notice: $e');
    } finally {
      _isProcessing = false;
    }
  }

  /// Restores initial status bar configuration if it was modified.
  Future<void> restore() async {
    if (!config.enabled || !config.restoreOnDispose) {
      return;
    }
    if (!isSupportedPlatform) {
      _isStatusBarHidden = false;
      _hasModifiedSystemUi = false;
      return;
    }
    if (!_hasModifiedSystemUi && !_isStatusBarHidden) return;

    try {
      final platform = currentPlatform;
      await SystemChrome.setEnabledSystemUIMode(
        config.visibleUiMode,
        overlays: config.visibleOverlays,
      );

      final style = config.resolveVisibleOverlayStyle(platform);
      if (style != null) {
        SystemChrome.setSystemUIOverlayStyle(style);
      }
      _isStatusBarHidden = false;
      _hasModifiedSystemUi = false;
    } catch (e) {
      debugPrint('StatusBarManager restore notice: $e');
    }
  }
}
