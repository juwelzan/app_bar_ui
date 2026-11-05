import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'scroll_driven_animation.dart';

/// Resolved values for a multi-property scroll animation at a specific point in time.
class ScrollAnimatedValues {
  /// Creates a snapshot of resolved animation values.
  const ScrollAnimatedValues({
    required this.progress,
    this.opacity = 1.0,
    this.scale = 1.0,
    this.translation = Offset.zero,
    this.rotation = 0.0,
    this.color,
    this.size,
    this.borderRadius,
  });

  /// Current raw normalized scroll progress (0.0 to 1.0).
  final double progress;

  /// Interpolated opacity (0.0 to 1.0).
  final double opacity;

  /// Interpolated scale factor.
  final double scale;

  /// Interpolated translation offset.
  final Offset translation;

  /// Interpolated rotation in radians.
  final double rotation;

  /// Interpolated color.
  final Color? color;

  /// Interpolated size.
  final Size? size;

  /// Interpolated border radius.
  final BorderRadius? borderRadius;
}

/// A unified, multi-property scroll-driven animation builder.
///
/// Rather than nesting multiple individual animation widgets, [ScrollAnimatedBuilder]
/// interpolates all configured [ScrollRange] properties simultaneously from a single
/// [progressListenable], passing the resolved [ScrollAnimatedValues] to [builder].
class ScrollAnimatedBuilder extends StatelessWidget {
  /// Creates a [ScrollAnimatedBuilder] widget.
  const ScrollAnimatedBuilder({
    super.key,
    required this.progressListenable,
    required this.builder,
    this.opacity,
    this.scale,
    this.translation,
    this.rotation,
    this.color,
    this.size,
    this.borderRadius,
    this.child,
  });

  /// The [ValueListenable] emitting normalized progress (0.0 to 1.0).
  final ValueListenable<double> progressListenable;

  /// Builder receiving the context, interpolated values, and optional static child.
  final Widget Function(
    BuildContext context,
    ScrollAnimatedValues values,
    Widget? child,
  )
  builder;

  /// Optional opacity range.
  final ScrollRange<double>? opacity;

  /// Optional scale range.
  final ScrollRange<double>? scale;

  /// Optional translation range.
  final ScrollRange<Offset>? translation;

  /// Optional rotation range in radians.
  final ScrollRange<double>? rotation;

  /// Optional color range.
  final ScrollRange<Color>? color;

  /// Optional size range.
  final ScrollRange<Size>? size;

  /// Optional border radius range.
  final ScrollRange<BorderRadius>? borderRadius;

  /// Optional static child widget passed to [builder] to avoid rebuilding static subtree.
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final bool disableMotion =
        MediaQuery.maybeDisableAnimationsOf(context) == true;

    return ValueListenableBuilder<double>(
      valueListenable: progressListenable,
      builder: (context, progress, _) {
        final clamped = progress.clamp(0.0, 1.0);

        final double resolvedOpacity = opacity != null
            ? opacity!.transform(clamped).clamp(0.0, 1.0)
            : 1.0;

        final double resolvedScale = (scale != null && !disableMotion)
            ? scale!.transform(clamped)
            : 1.0;

        final Offset resolvedTranslation =
            (translation != null && !disableMotion)
            ? translation!.transform(clamped)
            : Offset.zero;

        final double resolvedRotation = (rotation != null && !disableMotion)
            ? rotation!.transform(clamped)
            : 0.0;

        final Color? resolvedColor = color?.transform(clamped);
        final Size? resolvedSize = size?.transform(clamped);
        final BorderRadius? resolvedRadius = borderRadius?.transform(clamped);

        final values = ScrollAnimatedValues(
          progress: clamped,
          opacity: resolvedOpacity,
          scale: resolvedScale,
          translation: resolvedTranslation,
          rotation: resolvedRotation,
          color: resolvedColor,
          size: resolvedSize,
          borderRadius: resolvedRadius,
        );

        return builder(context, values, child);
      },
    );
  }
}
