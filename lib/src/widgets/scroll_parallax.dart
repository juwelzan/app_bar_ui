import 'package:flutter/material.dart';

/// A high-performance parallax container that moves its child at a different speed
/// relative to the enclosing [Scrollable] viewport.
///
/// Uses [Flow] with repaint listenable to achieve 60/120fps parallax with zero widget rebuilds.
class ScrollParallax extends StatefulWidget {
  /// Creates a [ScrollParallax] widget.
  const ScrollParallax({
    super.key,
    required this.child,
    this.height,
    this.speedFactor = 0.5,
    this.scrollable,
  });

  /// The widget to render with parallax (e.g., Image, Gradient, Card).
  final Widget child;

  /// Optional fixed height for the parallax container.
  /// If null and parent height is unbounded (e.g. in a ListView), defaults to 200.0.
  final double? height;

  /// Speed multiplier for the parallax effect.
  ///
  /// - `0.5`: Moves at half speed (classic slow background effect).
  /// - `1.0`: Moves normally with scroll.
  /// - `< 0.0`: Reverse parallax (moves in opposite direction).
  final double speedFactor;

  /// Optional explicit [ScrollableState]. If null, [Scrollable.maybeOf] is used.
  final ScrollableState? scrollable;

  @override
  State<ScrollParallax> createState() => _ScrollParallaxState();
}

class _ScrollParallaxState extends State<ScrollParallax> {
  final GlobalKey _backgroundImageKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final scrollable = widget.scrollable ?? Scrollable.maybeOf(context);

    if (scrollable == null) {
      return widget.child;
    }

    return ClipRect(
      child: Flow(
        delegate: _ParallaxFlowDelegate(
          scrollable: scrollable,
          listItemContext: context,
          backgroundImageKey: _backgroundImageKey,
          speedFactor: widget.speedFactor,
          height: widget.height,
        ),
        children: [
          Container(
            key: _backgroundImageKey,
            child: widget.child,
          ),
        ],
      ),
    );
  }
}

class _ParallaxFlowDelegate extends FlowDelegate {
  _ParallaxFlowDelegate({
    required this.scrollable,
    required this.listItemContext,
    required this.backgroundImageKey,
    required this.speedFactor,
    this.height,
  }) : super(repaint: scrollable.position);

  final ScrollableState scrollable;
  final BuildContext listItemContext;
  final GlobalKey backgroundImageKey;
  final double speedFactor;
  final double? height;

  @override
  Size getSize(BoxConstraints constraints) {
    return Size(
      constraints.maxWidth,
      constraints.hasBoundedHeight ? constraints.maxHeight : (height ?? 200.0),
    );
  }

  @override
  BoxConstraints getConstraintsForChild(int i, BoxConstraints constraints) {
    final parentHeight =
        constraints.hasBoundedHeight ? constraints.maxHeight : (height ?? 200.0);
    return BoxConstraints.tightFor(
      width: constraints.maxWidth,
      height: parentHeight * (1.0 + speedFactor.abs()),
    );
  }

  @override
  void paintChildren(FlowPaintingContext context) {
    final scrollableBox = scrollable.context.findRenderObject() as RenderBox?;
    final itemBox = listItemContext.findRenderObject() as RenderBox?;

    if (scrollableBox == null || itemBox == null || !itemBox.hasSize) {
      context.paintChild(0);
      return;
    }

    final itemOffset = itemBox.localToGlobal(
      Offset.zero,
      ancestor: scrollableBox,
    );

    final viewportDimension = scrollable.position.viewportDimension;
    if (viewportDimension <= 0) {
      context.paintChild(0);
      return;
    }

    final double scrollFraction =
        (itemOffset.dy / viewportDimension).clamp(-1.0, 1.0);
    final double maxOffsetY = context.size.height * speedFactor;
    final double yOffset = -scrollFraction * maxOffsetY;

    context.paintChild(
      0,
      transform: Matrix4.translationValues(0.0, yOffset, 0.0),
    );
  }

  @override
  bool shouldRepaint(covariant _ParallaxFlowDelegate oldDelegate) {
    return oldDelegate.scrollable != scrollable ||
        oldDelegate.listItemContext != listItemContext ||
        oldDelegate.backgroundImageKey != backgroundImageKey ||
        oldDelegate.speedFactor != speedFactor ||
        oldDelegate.height != height;
  }
}
