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
    this.onStateChanged,
  }) : config = config ?? SmartVisibilityConfig() {
    _initNotifiers();
  }

  /// The active configuration.
  SmartVisibilityConfig config;

  /// Optional callback invoked whenever any target's normalized visibility changes (0.0 to 1.0).
  final void Function(VisibilityTarget target, double visibility)?
  onVisibilityChanged;

  /// Optional callback invoked only when a target's boolean state flips between visible and hidden.
  final void Function(VisibilityTarget target, bool isVisible)? onStateChanged;

  final Map<VisibilityTarget, ValueNotifier<double>> _notifiers = {};
  final Set<VisibilityTarget> _lockedTargets = {};
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
      // If target is locked, skip automatic scroll adjustments
      if (_lockedTargets.contains(target)) continue;

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

  /// Convenience method to set target visibility to 1.0.
  void show(VisibilityTarget target) => setVisibility(target, 1.0);

  /// Convenience method to set target visibility to 0.0.
  void hide(VisibilityTarget target) => setVisibility(target, 0.0);

  /// Toggles visibility between 0.0 and 1.0.
  void toggle(VisibilityTarget target) =>
      setVisibility(target, isVisible(target) ? 0.0 : 1.0);

  /// Reveals all targets simultaneously.
  void showAll() {
    if (_isDisposed) return;
    for (final target in VisibilityTarget.values) {
      _applyVisibility(target, 1.0);
    }
  }

  /// Hides all targets that are configured to be hideable on scroll down.
  void hideAll() {
    if (_isDisposed) return;
    for (final target in VisibilityTarget.values) {
      if (config.getRule(target).hideOnScrollDown) {
        _applyVisibility(target, 0.0);
      }
    }
  }

  /// Locks a target's visibility so subsequent scroll events will not modify it.
  void lock(VisibilityTarget target, [double? visibility]) {
    if (_isDisposed) return;
    _lockedTargets.add(target);
    if (visibility != null) {
      _applyVisibility(target, visibility.clamp(0.0, 1.0));
    }
  }

  /// Unlocks a target, allowing scroll events to govern its visibility again.
  void unlock(VisibilityTarget target) {
    if (_isDisposed) return;
    _lockedTargets.remove(target);
  }

  /// Whether [target] is currently locked against scroll modifications.
  bool isLocked(VisibilityTarget target) => _lockedTargets.contains(target);

  /// Unlocks all locked targets.
  void unlockAll() {
    _lockedTargets.clear();
  }

  /// Returns targets sorted by rule priority (higher priority first by default).
  List<VisibilityTarget> getTargetsByPriority({bool ascending = false}) {
    final list = List<VisibilityTarget>.from(VisibilityTarget.values);
    list.sort((a, b) {
      final pA = config.getRule(a).priority;
      final pB = config.getRule(b).priority;
      return ascending ? pA.compareTo(pB) : pB.compareTo(pA);
    });
    return list;
  }

  /// Adds a listener to a specific target's visibility stream.
  void addTargetListener(VisibilityTarget target, VoidCallback listener) {
    _notifiers[target]?.addListener(listener);
  }

  /// Removes a listener from a specific target's visibility stream.
  void removeTargetListener(VisibilityTarget target, VoidCallback listener) {
    _notifiers[target]?.removeListener(listener);
  }

  void _applyVisibility(VisibilityTarget target, double newVisibility) {
    final notifier = _notifiers[target];
    if (notifier != null && notifier.value != newVisibility) {
      final bool wasVisible = notifier.value > 0.5;
      final bool nowVisible = newVisibility > 0.5;

      notifier.value = newVisibility;
      onVisibilityChanged?.call(target, newVisibility);

      if (wasVisible != nowVisible) {
        onStateChanged?.call(target, nowVisible);
      }
    }
  }

  /// Resets all targets to their initial visibility states.
  void resetToInitial() {
    if (_isDisposed) return;
    _lockedTargets.clear();
    for (final target in VisibilityTarget.values) {
      final initial = config.getRule(target).initialVisibility;
      _applyVisibility(target, initial);
    }
    _lastOffset = 0.0;
  }

  /// Disposes all internal ValueNotifiers and clears state.
  void dispose() {
    if (_isDisposed) return;
    _isDisposed = true;
    _lockedTargets.clear();
    for (final notifier in _notifiers.values) {
      notifier.dispose();
    }
    _notifiers.clear();
  }
}
