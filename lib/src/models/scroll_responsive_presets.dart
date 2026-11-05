import 'package:flutter/material.dart';

import 'scroll_responsive_config.dart';

/// Pre-configured architectural presets for [ScrollResponsiveScaffold] and the
/// Scroll-Driven UI Framework.
///
/// Presets supply complete [ScrollResponsiveConfig] instances with harmonious thresholds,
/// easing curves, and status bar synchronization. Developers can use presets as-is or
/// customize them via parameter overrides.
class ScrollResponsivePresets {
  const ScrollResponsivePresets._();

  /// Standard Material Design preset with balanced thresholds, Material curves,
  /// and standard status bar integration.
  static ScrollResponsiveConfig material({
    double thresholdStart = 40.0,
    double thresholdEnd = 120.0,
    Curve curve = Curves.easeInOut,
    Duration duration = const Duration(milliseconds: 300),
    bool enableStatusBarSync = true,
  }) {
    return ScrollResponsiveConfig(
      thresholds: ScrollThresholdConfig(
        leadingStartOffset: thresholdStart,
        leadingEndOffset: thresholdEnd,
        trailingStartOffset: thresholdStart,
        trailingEndOffset: thresholdEnd,
        statusBarHideOffset: thresholdEnd,
        statusBarShowOffset: thresholdStart,
      ),
      animation: ScrollAnimationConfig(
        curve: curve,
        duration: duration,
        transitionType: ScrollTransitionType.scrollProgress,
      ),
      statusBar: StatusBarConfig(
        enabled: enableStatusBarSync,
        hideOnScroll: enableStatusBarSync,
      ),
      pinnedActions: const PinnedActionsConfig(),
    );
  }

  /// Clean, ultra-lightweight minimal preset with quick fade thresholds,
  /// no elevation, and swift transitions.
  static ScrollResponsiveConfig minimal({
    double thresholdStart = 20.0,
    double thresholdEnd = 70.0,
    Curve curve = Curves.easeOut,
    Duration duration = const Duration(milliseconds: 200),
    bool enableStatusBarSync = false,
  }) {
    return ScrollResponsiveConfig(
      thresholds: ScrollThresholdConfig(
        leadingStartOffset: thresholdStart,
        leadingEndOffset: thresholdEnd,
        trailingStartOffset: thresholdStart,
        trailingEndOffset: thresholdEnd,
        statusBarHideOffset: thresholdEnd,
        statusBarShowOffset: thresholdStart,
      ),
      animation: ScrollAnimationConfig(
        curve: curve,
        duration: duration,
        transitionType: ScrollTransitionType.scrollProgress,
      ),
      statusBar: StatusBarConfig(
        enabled: enableStatusBarSync,
        hideOnScroll: enableStatusBarSync,
      ),
      pinnedActions: const PinnedActionsConfig(),
    );
  }

  /// Smooth iOS-inspired preset with cubic easing, broader hysteresis thresholds,
  /// and native iOS status bar style.
  static ScrollResponsiveConfig iosInspired({
    double thresholdStart = 50.0,
    double thresholdEnd = 140.0,
    Curve curve = Curves.easeInOutCubic,
    Duration duration = const Duration(milliseconds: 350),
    bool enableStatusBarSync = true,
  }) {
    return ScrollResponsiveConfig(
      thresholds: ScrollThresholdConfig(
        leadingStartOffset: thresholdStart,
        leadingEndOffset: thresholdEnd,
        trailingStartOffset: thresholdStart,
        trailingEndOffset: thresholdEnd,
        statusBarHideOffset: thresholdEnd,
        statusBarShowOffset: thresholdStart,
      ),
      animation: ScrollAnimationConfig(
        curve: curve,
        duration: duration,
        transitionType: ScrollTransitionType.scrollProgress,
      ),
      statusBar: StatusBarConfig(
        enabled: enableStatusBarSync,
        hideOnScroll: enableStatusBarSync,
      ),
      pinnedActions: const PinnedActionsConfig(),
    );
  }

  /// Preset tuned specifically for collapsing hero banners and large headers (200px+ height).
  static ScrollResponsiveConfig collapsingHeader({
    double thresholdStart = 80.0,
    double thresholdEnd = 200.0,
    Curve curve = Curves.easeOutCubic,
    Duration duration = const Duration(milliseconds: 300),
    bool enableStatusBarSync = true,
  }) {
    return ScrollResponsiveConfig(
      thresholds: ScrollThresholdConfig(
        leadingStartOffset: thresholdStart,
        leadingEndOffset: thresholdEnd,
        trailingStartOffset: thresholdStart,
        trailingEndOffset: thresholdEnd,
        statusBarHideOffset: thresholdEnd,
        statusBarShowOffset: thresholdStart,
      ),
      animation: ScrollAnimationConfig(
        curve: curve,
        duration: duration,
        transitionType: ScrollTransitionType.scrollProgress,
      ),
      statusBar: StatusBarConfig(
        enabled: enableStatusBarSync,
        hideOnScroll: enableStatusBarSync,
      ),
      pinnedActions: const PinnedActionsConfig(),
    );
  }

  /// Preset where only transparent floating actions remain, with no permanent app bar background.
  static ScrollResponsiveConfig transparentFloating({
    double thresholdStart = 30.0,
    double thresholdEnd = 90.0,
    Curve curve = Curves.easeOut,
    Duration duration = const Duration(milliseconds: 250),
    bool enableStatusBarSync = true,
  }) {
    return ScrollResponsiveConfig(
      thresholds: ScrollThresholdConfig(
        leadingStartOffset: thresholdStart,
        leadingEndOffset: thresholdEnd,
        trailingStartOffset: thresholdStart,
        trailingEndOffset: thresholdEnd,
        statusBarHideOffset: thresholdEnd,
        statusBarShowOffset: thresholdStart,
      ),
      animation: ScrollAnimationConfig(
        curve: curve,
        duration: duration,
        transitionType: ScrollTransitionType.scrollProgress,
      ),
      statusBar: StatusBarConfig(
        enabled: enableStatusBarSync,
        hideOnScroll: enableStatusBarSync,
      ),
      pinnedActions: const PinnedActionsConfig(),
    );
  }

  /// Preset for dense dashboards featuring tabs, FABs, and reading progress indicators.
  static ScrollResponsiveConfig dashboard({
    double thresholdStart = 35.0,
    double thresholdEnd = 100.0,
    Curve curve = Curves.easeOutQuart,
    Duration duration = const Duration(milliseconds: 300),
    bool enableStatusBarSync = true,
  }) {
    return ScrollResponsiveConfig(
      thresholds: ScrollThresholdConfig(
        leadingStartOffset: thresholdStart,
        leadingEndOffset: thresholdEnd,
        trailingStartOffset: thresholdStart,
        trailingEndOffset: thresholdEnd,
        statusBarHideOffset: thresholdEnd,
        statusBarShowOffset: thresholdStart,
      ),
      animation: ScrollAnimationConfig(
        curve: curve,
        duration: duration,
        transitionType: ScrollTransitionType.scrollProgress,
      ),
      statusBar: StatusBarConfig(
        enabled: enableStatusBarSync,
        hideOnScroll: enableStatusBarSync,
      ),
      pinnedActions: const PinnedActionsConfig(),
    );
  }

  /// Flexible builder preset allowing developers to customize thresholds while inheriting standard defaults.
  static ScrollResponsiveConfig custom({
    double leadingStartOffset = 40.0,
    double leadingEndOffset = 120.0,
    double trailingStartOffset = 40.0,
    double trailingEndOffset = 120.0,
    double statusBarHideOffset = 100.0,
    double statusBarShowOffset = 50.0,
    Curve animationCurve = Curves.easeInOut,
    Duration animationDuration = const Duration(milliseconds: 300),
    ScrollTransitionType transitionType = ScrollTransitionType.scrollProgress,
    bool enableStatusBarSync = true,
  }) {
    return ScrollResponsiveConfig(
      thresholds: ScrollThresholdConfig(
        leadingStartOffset: leadingStartOffset,
        leadingEndOffset: leadingEndOffset,
        trailingStartOffset: trailingStartOffset,
        trailingEndOffset: trailingEndOffset,
        statusBarHideOffset: statusBarHideOffset,
        statusBarShowOffset: statusBarShowOffset,
      ),
      animation: ScrollAnimationConfig(
        curve: animationCurve,
        duration: animationDuration,
        transitionType: transitionType,
      ),
      statusBar: StatusBarConfig(
        enabled: enableStatusBarSync,
        hideOnScroll: enableStatusBarSync,
      ),
      pinnedActions: const PinnedActionsConfig(),
    );
  }
}
