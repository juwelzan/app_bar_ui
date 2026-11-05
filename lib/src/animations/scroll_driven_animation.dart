import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Range of numeric values driven by scroll progress.
class ScrollRange<T> {
  /// Creates a scroll value range from [begin] to [end].
  const ScrollRange({
    required this.begin,
    required this.end,
    this.beginProgress = 0.0,
    this.endProgress = 1.0,
    this.curve = Curves.linear,
  }) : assert(
         beginProgress <= endProgress,
         'beginProgress ($beginProgress) must be <= endProgress ($endProgress).',
       );

  /// Starting value at [beginProgress].
  final T begin;

  /// Ending value at [endProgress].
  final T end;

  /// Normalized scroll progress (0.0 to 1.0) where the transition begins.
  final double beginProgress;

  /// Normalized scroll progress (0.0 to 1.0) where the transition ends.
  final double endProgress;

  /// Easing curve applied between [beginProgress] and [endProgress].
  final Curve curve;

  /// Interpolates the value at [progress] (0.0 to 1.0).
  T transform(double progress) {
    if (progress <= beginProgress) return begin;
    if (progress >= endProgress) return end;

    final double range = endProgress - beginProgress;
    final double rawT = range > 0 ? (progress - beginProgress) / range : 1.0;
    final double curvedT = curve.transform(rawT.clamp(0.0, 1.0));

    if (begin is double && end is double) {
      final b = begin as double;
      final e = end as double;
      return (b + (e - b) * curvedT) as T;
    } else if (begin is Offset && end is Offset) {
      final b = begin as Offset;
      final e = end as Offset;
      return Offset.lerp(b, e, curvedT) as T;
    } else if (begin is Color && end is Color) {
      return Color.lerp(begin as Color, end as Color, curvedT) as T;
    }

    return curvedT >= 0.5 ? end : begin;
  }
}

/// A versatile widget applying scroll-linked opacity, scale, translation, and rotation
/// based on a [progressListenable] (0.0 to 1.0).
///
/// Automatically respects reduced-motion accessibility preferences (`disableAnimations`).
class ScrollTransform extends StatelessWidget {
  /// Creates a [ScrollTransform] widget.
  const ScrollTransform({
    super.key,
    required this.progressListenable,
    required this.child,
    this.opacity,
    this.scale,
    this.translation,
    this.rotation,
    this.alignment = Alignment.center,
    this.enableReducedMotionAwareness = true,
  });

  /// The [ValueListenable] emitting scroll progress (0.0 to 1.0).
  final ValueListenable<double> progressListenable;

  /// The widget to transform.
  final Widget child;

  /// Optional opacity range mapping.
  final ScrollRange<double>? opacity;

  /// Optional scale range mapping.
  final ScrollRange<double>? scale;

  /// Optional translation range mapping.
  final ScrollRange<Offset>? translation;

  /// Optional rotation range mapping (in radians).
  final ScrollRange<double>? rotation;

  /// Transformation alignment within the bounding box.
  final Alignment alignment;

  /// Whether to automatically suppress aggressive scaling/rotation when
  /// [MediaQuery.disableAnimationsOf] is true for accessibility.
  final bool enableReducedMotionAwareness;

  @override
  Widget build(BuildContext context) {
    final bool disableMotion =
        enableReducedMotionAwareness &&
        MediaQuery.maybeDisableAnimationsOf(context) == true;

    return ValueListenableBuilder<double>(
      valueListenable: progressListenable,
      builder: (context, progress, _) {
        final clampedProgress = progress.clamp(0.0, 1.0);
        Widget result = child;

        // Translation
        if (translation != null && !disableMotion) {
          final offset = translation!.transform(clampedProgress);
          if (offset != Offset.zero) {
            result = Transform.translate(
              offset: offset,
              child: result,
            );
          }
        }

        // Rotation
        if (rotation != null && !disableMotion) {
          final angle = rotation!.transform(clampedProgress);
          if (angle != 0.0) {
            result = Transform.rotate(
              angle: angle,
              alignment: alignment,
              child: result,
            );
          }
        }

        // Scale
        if (scale != null && !disableMotion) {
          final scaleVal = scale!.transform(clampedProgress);
          if (scaleVal != 1.0) {
            result = Transform.scale(
              scale: scaleVal,
              alignment: alignment,
              child: result,
            );
          }
        }

        // Opacity
        if (opacity != null) {
          final opacityVal = opacity!.transform(clampedProgress).clamp(
            0.0,
            1.0,
          );
          if (opacityVal < 1.0) {
            result = Opacity(
              opacity: opacityVal,
              child: result,
            );
          }
        }

        return result;
      },
    );
  }
}
