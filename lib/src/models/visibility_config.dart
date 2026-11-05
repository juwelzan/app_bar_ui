import 'package:flutter/material.dart';

/// Targets managed by the centralized [SmartVisibilityController].
enum VisibilityTarget {
  /// The main scrollable header.
  header,

  /// The pinned left action button (e.g. avatar / drawer).
  leftAction,

  /// The pinned right action button (e.g. notification / avatar).
  rightAction,

  /// Floating Action Button.
  floatingActionButton,

  /// Bottom Navigation Bar.
  bottomNavigationBar,

  /// Sticky Tab Navigation Bar.
  stickyTab,

  /// System Status Bar.
  statusBar,
}

/// Rule governing visibility, thresholds, and directional behavior for a single target.
class VisibilityRule {
  /// Creates a visibility rule for a [VisibilityTarget].
  const VisibilityRule({
    required this.target,
    this.hideOffset = 100.0,
    this.showOffset = 50.0,
    this.hideOnScrollDown = true,
    this.showOnReverseScroll = true,
    this.priority = 0,
    this.duration = const Duration(milliseconds: 250),
    this.curve = Curves.easeInOut,
    this.initialVisibility = 1.0,
  }) : assert(
         showOffset <= hideOffset,
         'showOffset ($showOffset) must be <= hideOffset ($hideOffset).',
       ),
       assert(
         initialVisibility >= 0.0 && initialVisibility <= 1.0,
         'initialVisibility must be between 0.0 and 1.0.',
       );

  /// The target UI element this rule applies to.
  final VisibilityTarget target;

  /// Scroll offset in logical pixels at or beyond which the target hides.
  final double hideOffset;

  /// Scroll offset in logical pixels at or below which the target shows (hysteresis).
  final double showOffset;

  /// Whether scrolling down hides the target once reaching [hideOffset].
  final bool hideOnScrollDown;

  /// Whether reversing scroll direction upward restores the target.
  final bool showOnReverseScroll;

  /// Priority of this rule when multiple conditions compete (higher value = higher priority).
  final int priority;

  /// Animation duration for triggered visibility changes.
  final Duration duration;

  /// Easing curve for visibility transitions.
  final Curve curve;

  /// Initial visibility value (0.0 = completely hidden, 1.0 = fully visible).
  final double initialVisibility;

  /// Creates a copy of this rule with given parameters updated.
  VisibilityRule copyWith({
    VisibilityTarget? target,
    double? hideOffset,
    double? showOffset,
    bool? hideOnScrollDown,
    bool? showOnReverseScroll,
    int? priority,
    Duration? duration,
    Curve? curve,
    double? initialVisibility,
  }) {
    return VisibilityRule(
      target: target ?? this.target,
      hideOffset: hideOffset ?? this.hideOffset,
      showOffset: showOffset ?? this.showOffset,
      hideOnScrollDown: hideOnScrollDown ?? this.hideOnScrollDown,
      showOnReverseScroll: showOnReverseScroll ?? this.showOnReverseScroll,
      priority: priority ?? this.priority,
      duration: duration ?? this.duration,
      curve: curve ?? this.curve,
      initialVisibility: initialVisibility ?? this.initialVisibility,
    );
  }
}

/// Central configuration managing visibility rules for all [VisibilityTarget]s.
class SmartVisibilityConfig {
  /// Creates a smart visibility configuration with specified or default rules.
  SmartVisibilityConfig({Map<VisibilityTarget, VisibilityRule>? rules})
    : rules = rules ?? _defaultRules();

  /// Map of targets to their respective rules.
  final Map<VisibilityTarget, VisibilityRule> rules;

  /// Returns the rule for a given target, or a fallback default rule.
  VisibilityRule getRule(VisibilityTarget target) {
    return rules[target] ??
        VisibilityRule(
          target: target,
          hideOffset: 100.0,
          showOffset: 50.0,
          hideOnScrollDown: true,
          showOnReverseScroll: true,
        );
  }

  /// Creates standard defaults for all targets.
  static Map<VisibilityTarget, VisibilityRule> _defaultRules() {
    return {
      VisibilityTarget.header: const VisibilityRule(
        target: VisibilityTarget.header,
        hideOffset: 120.0,
        showOffset: 40.0,
        hideOnScrollDown: true,
        showOnReverseScroll: true,
      ),
      VisibilityTarget.leftAction: const VisibilityRule(
        target: VisibilityTarget.leftAction,
        hideOffset: 60.0,
        showOffset: 20.0,
        hideOnScrollDown: false, // Stays pinned
        showOnReverseScroll: true,
      ),
      VisibilityTarget.rightAction: const VisibilityRule(
        target: VisibilityTarget.rightAction,
        hideOffset: 60.0,
        showOffset: 20.0,
        hideOnScrollDown: false, // Stays pinned
        showOnReverseScroll: true,
      ),
      VisibilityTarget.floatingActionButton: const VisibilityRule(
        target: VisibilityTarget.floatingActionButton,
        hideOffset: 80.0,
        showOffset: 40.0,
        hideOnScrollDown: true,
        showOnReverseScroll: true,
      ),
      VisibilityTarget.bottomNavigationBar: const VisibilityRule(
        target: VisibilityTarget.bottomNavigationBar,
        hideOffset: 100.0,
        showOffset: 50.0,
        hideOnScrollDown: true,
        showOnReverseScroll: true,
      ),
      VisibilityTarget.stickyTab: const VisibilityRule(
        target: VisibilityTarget.stickyTab,
        hideOffset: 120.0,
        showOffset: 40.0,
        hideOnScrollDown: false, // Sticky tabs stay visible when pinned
        showOnReverseScroll: true,
      ),
      VisibilityTarget.statusBar: const VisibilityRule(
        target: VisibilityTarget.statusBar,
        hideOffset: 100.0,
        showOffset: 50.0,
        hideOnScrollDown: true,
        showOnReverseScroll: true,
      ),
    };
  }

  /// Creates a copy with specified rules updated.
  SmartVisibilityConfig copyWith({Map<VisibilityTarget, VisibilityRule>? rules}) {
    return SmartVisibilityConfig(
      rules: rules ?? Map<VisibilityTarget, VisibilityRule>.from(this.rules),
    );
  }
}
