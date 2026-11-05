import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';

import '../models/visibility_config.dart';

/// Centralized visibility management controller coordinating visibility,
/// thresholds, directional hysteresis, and priorities across all UI components.
class SmartVisibilityController {
  /// Creates a [SmartVisibilityController].
  SmartVisibilityController({
    SmartVisibilityConfig? config,
    this.onVisibilityChanged,
  }) : config = config ?? SmartVisibilityConfig() {
    _initNotifiers();
  }

  /// The active configuration.
  SmartVisibilityConfig config;

  /// Optional callback invoked when any target visibility changes.
  final void Function(VisibilityTarget target, double visibility)?
  onVisibilityChanged;

  final Map<VisibilityTarget, ValueNotifier<double>> _notifiers = {};
  double _lastOffset = 0.0;
  bool _isDisposed = false;

  /// The most recent scroll offset recorded by this controller.
  double get lastOffset => _lastOffset;

  void _initNotifiers() {
    for (final target in VisibilityTarget.values) {
      final rule = config.getRule(target);
      _notifiers[target] = ValueNotifier<double>(rule.initialVisibility);
    }
  }

  /// Replaces the configuration and re-evaluates all targets.
  void updateConfig(SmartVisibilityConfig newConfig) {
    config = newConfig;
    for (final target in VisibilityTarget.values) {
      if (!_notifiers.containsKey(target)) {
        _notifiers[target] = ValueNotifier<double>(
          config.getRule(target).initialVisibility,
        );
      }
    }
  }

  /// Gets the [ValueListenable] for a specific target's visibility (0.0 = hidden, 1.0 = visible).
  ValueListenable<double> visibilityNotifier(VisibilityTarget target) {
    return _notifiers[target] ??= ValueNotifier<double>(
      config.getRule(target).initialVisibility,
    );
  }

  /// Current visibility value of [target] (0.0 to 1.0).
  double getVisibility(VisibilityTarget target) {
    return _notifiers[target]?.value ??
        config.getRule(target).initialVisibility;
  }

  /// Whether [target] is currently considered visible (visibility > 0.5).
  bool isVisible(VisibilityTarget target) {
    return getVisibility(target) > 0.5;
  }

  /// Evaluates scroll updates and transitions target visibilities according to their rules.
  void updateScroll(
    double offset, {
    ScrollDirection direction = ScrollDirection.idle,
    double delta = 0.0,
  }) {
    if (_isDisposed) return;

    final isScrollingDown = direction == ScrollDirection.reverse || delta > 0;
    final isScrollingUp = direction == ScrollDirection.forward || delta < 0;
    final isAtTop = offset <= 0.0;

    for (final target in VisibilityTarget.values) {
      final rule = config.getRule(target);
      final currentVisibility = getVisibility(target);
      double newVisibility = currentVisibility;

      if (isAtTop) {
        newVisibility = 1.0;
      } else if (isScrollingDown && rule.hideOnScrollDown) {
        if (offset >= rule.hideOffset) {
          newVisibility = 0.0;
        }
      } else if (isScrollingUp && rule.showOnReverseScroll) {
        if (offset <= rule.showOffset) {
          newVisibility = 1.0;
        }
      }

      _applyVisibility(target, newVisibility);
    }

    _lastOffset = offset;
  }

  /// Programmatically overrides the visibility of a specific [target].
  void setVisibility(VisibilityTarget target, double visibility) {
    if (_isDisposed) return;
    _applyVisibility(target, visibility.clamp(0.0, 1.0));
  }

  void _applyVisibility(VisibilityTarget target, double newVisibility) {
    final notifier = _notifiers[target];
    if (notifier != null && notifier.value != newVisibility) {
      notifier.value = newVisibility;
      onVisibilityChanged?.call(target, newVisibility);
    }
  }

  /// Resets all targets to their initial visibility states.
  void resetToInitial() {
    if (_isDisposed) return;
    for (final target in VisibilityTarget.values) {
      final initial = config.getRule(target).initialVisibility;
      _applyVisibility(target, initial);
    }
    _lastOffset = 0.0;
  }

  /// Disposes all internal ValueNotifiers.
  void dispose() {
    if (_isDisposed) return;
    _isDisposed = true;
    for (final notifier in _notifiers.values) {
      notifier.dispose();
    }
    _notifiers.clear();
  }
}
