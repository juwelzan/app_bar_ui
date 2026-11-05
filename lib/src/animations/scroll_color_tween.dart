import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Dynamically interpolates colors or gradients based on scroll progress.
class ScrollColorTransition extends StatelessWidget {
  /// Creates a [ScrollColorTransition] widget.
  const ScrollColorTransition({
    super.key,
    required this.progressListenable,
    this.beginColor,
    this.endColor,
    this.beginGradient,
    this.endGradient,
    this.beginProgress = 0.0,
    this.endProgress = 1.0,
    this.curve = Curves.linear,
    required this.builder,
    this.child,
  });

  /// The [ValueListenable] providing normalized scroll progress (0.0 to 1.0).
  final ValueListenable<double> progressListenable;

  /// Starting color at [beginProgress].
  final Color? beginColor;

  /// Ending color at [endProgress].
  final Color? endColor;

  /// Starting gradient at [beginProgress].
  final Gradient? beginGradient;

  /// Ending gradient at [endProgress].
  final Gradient? endGradient;

  /// Scroll progress value where transition begins.
  final double beginProgress;

  /// Scroll progress value where transition ends.
  final double endProgress;

  /// Easing curve for color interpolation.
  final Curve curve;

  /// Child widget passed to builder for optimization.
  final Widget? child;

  /// Builder receiving interpolated color and gradient.
  final Widget Function(
    BuildContext context,
    Color? color,
    Gradient? gradient,
    Widget? child,
  )
  builder;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<double>(
      valueListenable: progressListenable,
      builder: (context, progress, _) {
        final clamped = progress.clamp(0.0, 1.0);
        final range = endProgress - beginProgress;
        final rawT = range > 0 ? (clamped - beginProgress) / range : 1.0;
        final curvedT = curve.transform(rawT.clamp(0.0, 1.0));

        Color? resolvedColor;
        if (curvedT <= 0.0) {
          resolvedColor = beginColor;
        } else if (curvedT >= 1.0) {
          resolvedColor = endColor;
        } else if (beginColor != null && endColor != null) {
          resolvedColor = Color.lerp(beginColor, endColor, curvedT);
        } else {
          resolvedColor = beginColor ?? endColor;
        }

        Gradient? resolvedGradient;
        if (curvedT <= 0.0) {
          resolvedGradient = beginGradient;
        } else if (curvedT >= 1.0) {
          resolvedGradient = endGradient;
        } else if (beginGradient != null && endGradient != null) {
          resolvedGradient = Gradient.lerp(
            beginGradient,
            endGradient,
            curvedT,
          );
        } else {
          resolvedGradient = beginGradient ?? endGradient;
        }

        return builder(context, resolvedColor, resolvedGradient, child);
      },
    );
  }
}
