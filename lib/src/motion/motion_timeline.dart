import 'dart:ui' show lerpDouble;
import 'package:flutter/material.dart';

/// Evaluates normalized multi-stage animation timelines driven by scroll progress.
///
/// Converts a global scroll progress ($0.0 \to 1.0$) or pixel offset into stage-local
/// normalized values with configurable easing curves and accessibility overrides.
class ScrollMotionTimeline {
  /// Creates a [ScrollMotionTimeline].
  const ScrollMotionTimeline();

  /// Evaluates normalized progress within a specific window [[start], [end]].
  ///
  /// Returns a value clamped to $[0.0, 1.0]$, transformed by [curve].
  /// When [reducedMotion] is enabled, sharp elastic or bouncing curves are
  /// flattened into smooth linear transitions.
  static double evaluateStage({
    required double progress,
    required double start,
    required double end,
    Curve curve = Curves.easeInOut,
    bool reducedMotion = false,
  }) {
    assert(end > start, 'Stage end ($end) must be greater than start ($start)');
    if (progress <= start) return 0.0;
    if (progress >= end) return 1.0;

    final localProgress = ((progress - start) / (end - start)).clamp(0.0, 1.0);
    if (reducedMotion) {
      return localProgress;
    }
    return curve.transform(localProgress);
  }

  /// Linearly interpolates between two doubles based on stage evaluation.
  static double lerpDoubleStage({
    required double progress,
    required double start,
    required double end,
    required double beginValue,
    required double endValue,
    Curve curve = Curves.easeInOut,
    bool reducedMotion = false,
  }) {
    final t = evaluateStage(
      progress: progress,
      start: start,
      end: end,
      curve: curve,
      reducedMotion: reducedMotion,
    );
    return lerpDouble(beginValue, endValue, t) ?? beginValue;
  }

  /// Linearly interpolates between two [Offset] values based on stage evaluation.
  static Offset lerpOffsetStage({
    required double progress,
    required double start,
    required double end,
    required Offset beginOffset,
    required Offset endOffset,
    Curve curve = Curves.easeInOut,
    bool reducedMotion = false,
  }) {
    final t = evaluateStage(
      progress: progress,
      start: start,
      end: end,
      curve: curve,
      reducedMotion: reducedMotion,
    );
    return Offset.lerp(beginOffset, endOffset, t) ?? beginOffset;
  }
}
