import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// A scroll-driven avatar transformation widget that smoothly morphs an avatar
/// or profile picture between an expanded header state and a compact pinned toolbar state.
///
/// Smoothly interpolates:
/// - Size ([beginSize] $\to$ [endSize])
/// - Corner rounding / shape ([beginRadius] $\to$ [endRadius])
/// - Translation offset ([beginOffset] $\to$ [endOffset])
/// - Elevation and borders
///
/// Fully reversible upon scroll-back, zero redundant rebuilds, and reduced-motion compliant.
class ScrollAvatarTransform extends StatelessWidget {
  /// Creates a [ScrollAvatarTransform] widget.
  const ScrollAvatarTransform({
    super.key,
    required this.progressListenable,
    required this.child,
    this.beginSize = 72.0,
    this.endSize = 36.0,
    this.beginRadius,
    this.endRadius,
    this.beginOffset = Offset.zero,
    this.endOffset = Offset.zero,
    this.beginElevation = 0.0,
    this.endElevation = 0.0,
    this.beginBorder,
    this.endBorder,
    this.curve = Curves.easeInOutCubic,
    this.onTap,
  });

  /// The [ValueListenable] emitting normalized scroll progress (0.0 to 1.0).
  final ValueListenable<double> progressListenable;

  /// The inner avatar image or icon to transform.
  final Widget child;

  /// Avatar diameter in fully expanded state. Defaults to 72.0.
  final double beginSize;

  /// Avatar diameter in fully collapsed state. Defaults to 36.0.
  final double endSize;

  /// Starting border radius. Defaults to circular pill radius (`beginSize / 2`).
  final BorderRadius? beginRadius;

  /// Ending border radius. Defaults to circular pill radius (`endSize / 2`).
  final BorderRadius? endRadius;

  /// Translation offset when fully expanded. Defaults to [Offset.zero].
  final Offset beginOffset;

  /// Translation offset when fully collapsed. Defaults to [Offset.zero].
  final Offset endOffset;

  /// Material elevation when expanded. Defaults to 0.0.
  final double beginElevation;

  /// Material elevation when collapsed. Defaults to 0.0.
  final double endElevation;

  /// Starting border decoration.
  final Border? beginBorder;

  /// Ending border decoration.
  final Border? endBorder;

  /// Interpolation curve. Defaults to [Curves.easeInOutCubic].
  final Curve curve;

  /// Optional tap callback on the avatar.
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final bool disableMotion =
        MediaQuery.maybeDisableAnimationsOf(context) == true;

    final defaultBeginRadius =
        beginRadius ?? BorderRadius.circular(beginSize / 2);
    final defaultEndRadius = endRadius ?? BorderRadius.circular(endSize / 2);

    return ValueListenableBuilder<double>(
      valueListenable: progressListenable,
      builder: (context, progress, _) {
        final clamped = progress.clamp(0.0, 1.0);
        final curved = curve.transform(clamped);

        final double currentSize = disableMotion
            ? (clamped >= 0.5 ? endSize : beginSize)
            : beginSize + (endSize - beginSize) * curved;

        final BorderRadius currentRadius = disableMotion
            ? (clamped >= 0.5 ? defaultEndRadius : defaultBeginRadius)
            : BorderRadius.lerp(defaultBeginRadius, defaultEndRadius, curved) ??
                  defaultBeginRadius;

        final Offset currentOffset = disableMotion
            ? (clamped >= 0.5 ? endOffset : beginOffset)
            : Offset.lerp(beginOffset, endOffset, curved) ?? beginOffset;

        final double currentElevation = disableMotion
            ? (clamped >= 0.5 ? endElevation : beginElevation)
            : beginElevation + (endElevation - beginElevation) * curved;

        final Border? currentBorder = disableMotion
            ? (clamped >= 0.5 ? endBorder : beginBorder)
            : Border.lerp(beginBorder, endBorder, curved);

        Widget avatar = Material(
          elevation: currentElevation,
          borderRadius: currentRadius,
          clipBehavior: Clip.antiAlias,
          color: Colors.transparent,
          child: Container(
            width: currentSize,
            height: currentSize,
            decoration: currentBorder != null
                ? BoxDecoration(
                    borderRadius: currentRadius,
                    border: currentBorder,
                  )
                : null,
            child: SizedBox.expand(child: child),
          ),
        );

        if (onTap != null) {
          avatar = GestureDetector(
            onTap: onTap,
            behavior: HitTestBehavior.opaque,
            child: avatar,
          );
        }

        if (currentOffset != Offset.zero) {
          avatar = Transform.translate(offset: currentOffset, child: avatar);
        }

        return avatar;
      },
    );
  }
}
