import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Coordinates staggered, cascading animations across multiple widgets linked
/// to normalized scroll progress.
///
/// Each item $i$ begins animating after a delay of $i \times$ [staggerInterval]
/// and completes over [itemDuration].
class ScrollStaggeredBuilder extends StatelessWidget {
  /// Creates a [ScrollStaggeredBuilder] widget.
  const ScrollStaggeredBuilder({
    super.key,
    required this.progressListenable,
    required this.itemCount,
    required this.builder,
    this.staggerInterval = 0.08,
    this.itemDuration = 0.35,
    this.curve = Curves.easeOutCubic,
    this.direction = Axis.vertical,
    this.mainAxisSize = MainAxisSize.min,
    this.crossAxisAlignment = CrossAxisAlignment.start,
  }) : assert(itemCount > 0, 'itemCount must be greater than 0.'),
       assert(staggerInterval >= 0.0, 'staggerInterval must be >= 0.0.'),
       assert(itemDuration > 0.0, 'itemDuration must be > 0.0.');

  /// The [ValueListenable] emitting normalized progress (0.0 to 1.0).
  final ValueListenable<double> progressListenable;

  /// Total number of items to animate.
  final int itemCount;

  /// Builder receiving item index and that item's individual progress (0.0 to 1.0).
  final Widget Function(BuildContext context, int index, double itemProgress)
  builder;

  /// Progress offset between the start of successive items. Defaults to 0.08.
  final double staggerInterval;

  /// Progress span taken by each item to complete its animation. Defaults to 0.35.
  final double itemDuration;

  /// Easing curve for each item's animation. Defaults to [Curves.easeOutCubic].
  final Curve curve;

  /// Layout axis. Defaults to [Axis.vertical].
  final Axis direction;

  /// Main axis sizing. Defaults to [MainAxisSize.min].
  final MainAxisSize mainAxisSize;

  /// Cross axis alignment. Defaults to [CrossAxisAlignment.start].
  final CrossAxisAlignment crossAxisAlignment;

  @override
  Widget build(BuildContext context) {
    final bool disableMotion =
        MediaQuery.maybeDisableAnimationsOf(context) == true;

    return ValueListenableBuilder<double>(
      valueListenable: progressListenable,
      builder: (context, progress, _) {
        final clampedProgress = progress.clamp(0.0, 1.0);
        final List<Widget> items = [];

        for (int i = 0; i < itemCount; i++) {
          double itemProgress;

          if (disableMotion) {
            itemProgress = clampedProgress > 0.5 ? 1.0 : 0.0;
          } else {
            final double itemStart = i * staggerInterval;
            final double rawT = ((clampedProgress - itemStart) / itemDuration)
                .clamp(0.0, 1.0);
            itemProgress = curve.transform(rawT);
          }

          items.add(builder(context, i, itemProgress));
        }

        return direction == Axis.vertical
            ? Column(
                mainAxisSize: mainAxisSize,
                crossAxisAlignment: crossAxisAlignment,
                children: items,
              )
            : Row(
                mainAxisSize: mainAxisSize,
                crossAxisAlignment: crossAxisAlignment,
                children: items,
              );
      },
    );
  }
}
