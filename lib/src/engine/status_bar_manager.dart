import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import '../models/scroll_responsive_config.dart';

/// Manages native mobile System Status Bar visibility with threshold-based
/// hysteresis, avoiding per-frame platform channel calls.
class StatusBarManager {
  /// Creates a [StatusBarManager] with the given configuration.
  StatusBarManager({required this.config, required this.thresholds});

  /// The active status bar configuration.
  StatusBarConfig config;

  /// The active threshold configuration.
  ScrollThresholdConfig thresholds;

  bool _isStatusBarHidden = false;
  bool _hasModifiedSystemUi = false;

  /// Whether the status bar is currently hidden.
  bool get isStatusBarHidden => _isStatusBarHidden;

  /// Whether the host platform supports native status bar manipulation.
  static bool get isSupportedPlatform {
    if (kIsWeb) return false;
    try {
      return Platform.isAndroid || Platform.isIOS;
    } catch (_) {
      return false;
    }
  }

  /// Evaluates the scroll [offset] against thresholds and updates status bar
  /// visibility when crossing boundaries.
  ///
  /// Uses hysteresis ([ScrollThresholdConfig.statusBarHideOffset] vs
  /// [ScrollThresholdConfig.statusBarShowOffset]) to prevent rapid flickering.
  void updateScrollOffset(double offset) {
    if (!config.enabled || !config.hideOnScroll || !isSupportedPlatform) {
      return;
    }

    if (offset >= thresholds.statusBarHideOffset && !_isStatusBarHidden) {
      setStatusBarHidden(true);
    } else if (offset <= thresholds.statusBarShowOffset && _isStatusBarHidden) {
      setStatusBarHidden(false);
    }
  }

  /// Sets the status bar hidden state.
  ///
  /// Protected against duplicate invocations and unsupported platforms.
  Future<void> setStatusBarHidden(bool hidden) async {
    if (!config.enabled || !isSupportedPlatform) return;
    if (_isStatusBarHidden == hidden && _hasModifiedSystemUi) return;

    _isStatusBarHidden = hidden;
    _hasModifiedSystemUi = true;

    try {
      if (hidden) {
        await SystemChrome.setEnabledSystemUIMode(
          config.hiddenUiMode,
          overlays: config.hiddenOverlays,
        );
        if (config.hiddenOverlayStyle != null) {
          SystemChrome.setSystemUIOverlayStyle(config.hiddenOverlayStyle!);
        }
      } else {
        await SystemChrome.setEnabledSystemUIMode(
          config.visibleUiMode,
          overlays: config.visibleOverlays,
        );
        if (config.visibleOverlayStyle != null) {
          SystemChrome.setSystemUIOverlayStyle(config.visibleOverlayStyle!);
        }
      }
    } catch (e) {
      // Graceful fallback on environments where SystemChrome calls fail.
      debugPrint('StatusBarManager notice: $e');
    }
  }

  /// Restores initial status bar configuration if it was modified.
  Future<void> restore() async {
    if (!config.enabled || !config.restoreOnDispose || !isSupportedPlatform) {
      return;
    }
    if (!_hasModifiedSystemUi && !_isStatusBarHidden) return;

    try {
      await SystemChrome.setEnabledSystemUIMode(
        config.visibleUiMode,
        overlays: config.visibleOverlays,
      );
      if (config.visibleOverlayStyle != null) {
        SystemChrome.setSystemUIOverlayStyle(config.visibleOverlayStyle!);
      }
      _isStatusBarHidden = false;
      _hasModifiedSystemUi = false;
    } catch (e) {
      debugPrint('StatusBarManager restore notice: $e');
    }
  }
}
