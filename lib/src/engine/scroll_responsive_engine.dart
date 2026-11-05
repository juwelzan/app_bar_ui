import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../models/scroll_responsive_config.dart';

/// A reusable engine managing scroll tracking, direction detection, threshold
/// calculation, reverse scroll detection, and controller lifecycles.
///
/// Designed to be decoupled from the widget tree and fully unit-testable.
class ScrollResponsiveEngine {
  /// Creates a [ScrollResponsiveEngine].
  ScrollResponsiveEngine({
    required this.config,
    ScrollController? customController,
    this.onProgressChanged,
    this.onDirectionChanged,
  }) {
    _initController(customController);
  }

  /// The active configuration.
  ScrollResponsiveConfig config;

  /// Updates the configuration and recalculates progress.
  void updateConfig(ScrollResponsiveConfig newConfig) {
    config = newConfig;
    _evaluateProgress();
  }

  late ScrollController _scrollController;
  bool _ownsController = false;

  /// The active [ScrollController] (either user-supplied or internally created).
  ScrollController get controller => _scrollController;

  /// Whether this engine owns and is responsible for disposing the [ScrollController].
  bool get ownsController => _ownsController;

  /// Notifier for leading (left) action transition progress (0.0 to 1.0).
  final ValueNotifier<double> leadingProgressNotifier = ValueNotifier<double>(
    0.0,
  );

  /// Notifier for trailing (right) action transition progress (0.0 to 1.0).
  final ValueNotifier<double> trailingProgressNotifier = ValueNotifier<double>(
    0.0,
  );

  /// Notifier for comprehensive real-time scroll details.
  final ValueNotifier<ScrollProgressDetails> progressDetailsNotifier =
      ValueNotifier<ScrollProgressDetails>(
        const ScrollProgressDetails(
          offset: 0.0,
          leadingProgress: 0.0,
          trailingProgress: 0.0,
          isStatusBarHidden: false,
          scrollDirection: ScrollDirection.idle,
        ),
      );

  /// Optional callback invoked whenever progress or offset changes.
  final ValueChanged<ScrollProgressDetails>? onProgressChanged;

  /// Optional callback invoked whenever scroll direction changes.
  final ValueChanged<ScrollDirection>? onDirectionChanged;

  double _currentOffset = 0.0;
  double _lastOffset = 0.0;
  ScrollDirection _currentDirection = ScrollDirection.idle;
  bool _isReverseScroll = false;
  bool _isDisposed = false;
  bool _hasEvaluatedInitial = false;

  /// Current scroll offset in logical pixels (clamped to non-negative for calculations).
  double get currentOffset => _currentOffset;

  /// Current user scroll direction.
  ScrollDirection get currentDirection => _currentDirection;

  /// Whether the user is currently scrolling in reverse (scrolling up toward top).
  bool get isReverseScroll => _isReverseScroll;

  /// Whether the scroll position is at the very top (offset <= 0).
  bool get isAtTop => _currentOffset <= 0.0;

  /// Current normalized leading progress (0.0 to 1.0).
  double get leadingProgress => leadingProgressNotifier.value;

  /// Current normalized trailing progress (0.0 to 1.0).
  double get trailingProgress => trailingProgressNotifier.value;

  void _initController(ScrollController? customController) {
    if (customController != null) {
      _scrollController = customController;
      _ownsController = false;
    } else {
      _scrollController = ScrollController();
      _ownsController = true;
    }
    _scrollController.addListener(_onControllerScroll);
  }

  /// Migrates to a new [ScrollController] without memory leaks.
  void updateController(ScrollController? newCustomController) {
    if (_isDisposed) return;
    if (_scrollController == newCustomController) return;

    _detachController();
    _initController(newCustomController);
    _evaluateProgress();
  }

  void _detachController() {
    _scrollController.removeListener(_onControllerScroll);
    if (_ownsController) {
      _scrollController.dispose();
    }
  }

  void _onControllerScroll() {
    if (!_scrollController.hasClients) return;
    updateScrollOffset(_scrollController.offset);
  }

  /// Updates the engine state with a raw scroll [offset].
  ///
  /// Automatically detects reverse scrolling, calculates normalized progress
  /// across independent thresholds, and notifies listeners.
  void updateScrollOffset(double offset) {
    if (_isDisposed) return;
    if (_currentOffset == offset && _hasEvaluatedInitial) return;

    _hasEvaluatedInitial = true;
    _lastOffset = _currentOffset;
    _currentOffset = offset;

    // Detect reverse scrolling (scrolling up toward top)
    if (_currentOffset < _lastOffset) {
      _isReverseScroll = true;
    } else if (_currentOffset > _lastOffset) {
      _isReverseScroll = false;
    }

    _evaluateProgress();
  }

  /// Handles incoming [ScrollNotification]s from nested or primary scrollables.
  ///
  /// Returns `false` to permit the notification to continue bubbling up the widget tree.
  bool handleScrollNotification(ScrollNotification notification) {
    if (_isDisposed) return false;
    updateScrollOffset(notification.metrics.pixels);
    return false;
  }

  /// Handles [UserScrollNotification] to update scroll direction.
  ///
  /// Returns `false` to permit bubbling.
  bool handleUserScrollNotification(UserScrollNotification notification) {
    if (_isDisposed) return false;
    if (notification.direction != _currentDirection) {
      _currentDirection = notification.direction;
      onDirectionChanged?.call(_currentDirection);
    }
    return false;
  }

  void _evaluateProgress() {
    // Clamp offset to 0.0 to safely handle bounce/overscroll on iOS/macOS
    final double safeOffset = math.max(0.0, _currentOffset);
    final thresholds = config.thresholds;

    // Calculate leading progress
    final double lRange =
        thresholds.leadingEndOffset - thresholds.leadingStartOffset;
    final double lRaw = lRange > 0
        ? (safeOffset - thresholds.leadingStartOffset) / lRange
        : (safeOffset >= thresholds.leadingStartOffset ? 1.0 : 0.0);
    final double newLeadingProgress = lRaw.clamp(0.0, 1.0);

    // Calculate trailing progress
    final double tRange =
        thresholds.trailingEndOffset - thresholds.trailingStartOffset;
    final double tRaw = tRange > 0
        ? (safeOffset - thresholds.trailingStartOffset) / tRange
        : (safeOffset >= thresholds.trailingStartOffset ? 1.0 : 0.0);
    final double newTrailingProgress = tRaw.clamp(0.0, 1.0);

    // Check status bar visibility boundary
    final bool isStatusBarHidden = safeOffset >= thresholds.statusBarHideOffset;

    // Only update ValueNotifiers if values have actually changed to avoid spurious rebuilds
    if (leadingProgressNotifier.value != newLeadingProgress) {
      leadingProgressNotifier.value = newLeadingProgress;
    }
    if (trailingProgressNotifier.value != newTrailingProgress) {
      trailingProgressNotifier.value = newTrailingProgress;
    }

    final details = ScrollProgressDetails(
      offset: _currentOffset,
      leadingProgress: newLeadingProgress,
      trailingProgress: newTrailingProgress,
      isStatusBarHidden: isStatusBarHidden,
      scrollDirection: _currentDirection,
    );

    progressDetailsNotifier.value = details;
    onProgressChanged?.call(details);
  }

  /// Resets the engine state and animates/jumps the controller back to offset 0.
  Future<void> resetToInitialState({bool animate = false}) async {
    if (_isDisposed) return;
    if (_scrollController.hasClients) {
      if (animate) {
        await _scrollController.animateTo(
          0.0,
          duration: config.effectiveAnimation.duration,
          curve: config.effectiveAnimation.curve,
        );
      } else {
        _scrollController.jumpTo(0.0);
      }
    }
    updateScrollOffset(0.0);
  }

  /// Disposes notifiers and internal controller.
  void dispose() {
    if (_isDisposed) return;
    _isDisposed = true;

    _detachController();
    leadingProgressNotifier.dispose();
    trailingProgressNotifier.dispose();
    progressDetailsNotifier.dispose();
  }
}
