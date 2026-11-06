import 'package:flutter/material.dart';

/// Base contract for all AppBar motion and transition configurations.
abstract class AppBarMotionConfig {
  /// Const constructor.
  const AppBarMotionConfig({
    this.curve = Curves.easeInOutCubic,
    this.reducedMotionCurve = Curves.linear,
  });

  /// Primary easing curve for animations.
  final Curve curve;

  /// Fallback easing curve when user requests reduced motion.
  final Curve reducedMotionCurve;

  /// Resolves the effective curve based on context accessibility preferences.
  Curve resolveCurve(BuildContext context) {
    if (MediaQuery.disableAnimationsOf(context)) {
      return reducedMotionCurve;
    }
    return curve;
  }
}

