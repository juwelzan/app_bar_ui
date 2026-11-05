import 'package:flutter/material.dart';

/// A scroll-linked pagination indicator that dynamically animates active dot expansion
/// and color transitions as the user scrolls through pages or carousel items.
///
/// Can observe either a [PageController] or a standard [ScrollController] (with [itemExtent]).
class ScrollPageIndicator extends StatefulWidget {
  /// Creates a [ScrollPageIndicator] widget.
  const ScrollPageIndicator({
    super.key,
    this.controller,
    required this.itemCount,
    this.itemExtent,
    this.axis = Axis.horizontal,
    this.dotSize = const Size(8.0, 8.0),
    this.activeDotSize = const Size(22.0, 8.0),
    this.dotColor,
    this.activeDotColor,
    this.spacing = 6.0,
    this.borderRadius,
    this.onDotTapped,
  }) : assert(itemCount > 0, 'itemCount must be greater than 0.');

  /// The scroll controller to observe (either a [PageController] or a [ScrollController]).
  final ScrollController? controller;

  /// Total count of pages or items.
  final int itemCount;

  /// Fixed width or height of each item in the scrollable view.
  /// Automatically inferred if [controller] is a [PageController].
  final double? itemExtent;

  /// Orientation of the indicator. Defaults to [Axis.horizontal].
  final Axis axis;

  /// Normal inactive dot dimensions. Defaults to 8x8.
  final Size dotSize;

  /// Active expanded dot dimensions. Defaults to 22x8.
  final Size activeDotSize;

  /// Color of inactive dots. Defaults to theme's outlineVariant/grey.
  final Color? dotColor;

  /// Color of the active dot. Defaults to theme's primary color.
  final Color? activeDotColor;

  /// Spacing between dots. Defaults to 6.0.
  final double spacing;

  /// Border radius for dots. Defaults to circular pill radius.
  final BorderRadius? borderRadius;

  /// Callback when a dot is tapped.
  final ValueChanged<int>? onDotTapped;

  @override
  State<ScrollPageIndicator> createState() => _ScrollPageIndicatorState();
}

class _ScrollPageIndicatorState extends State<ScrollPageIndicator> {
  double _currentPage = 0.0;

  @override
  void initState() {
    super.initState();
    widget.controller?.addListener(_onScrollChanged);
  }

  @override
  void didUpdateWidget(covariant ScrollPageIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      oldWidget.controller?.removeListener(_onScrollChanged);
      widget.controller?.addListener(_onScrollChanged);
    }
  }

  void _onScrollChanged() {
    if (!mounted ||
        widget.controller == null ||
        !widget.controller!.hasClients) {
      return;
    }

    final ctrl = widget.controller!;
    double page = 0.0;

    if (ctrl is PageController &&
        ctrl.hasClients &&
        ctrl.position.haveDimensions) {
      page = ctrl.page ?? (ctrl.offset / ctrl.position.viewportDimension);
    } else if (ctrl.hasClients && ctrl.position.haveDimensions) {
      final extent = widget.itemExtent ?? ctrl.position.viewportDimension;
      if (extent > 0) {
        page = ctrl.offset / extent;
      }
    }

    final clampedPage = page.clamp(0.0, (widget.itemCount - 1).toDouble());
    if ((clampedPage - _currentPage).abs() > 0.001) {
      setState(() {
        _currentPage = clampedPage;
      });
    }
  }

  void _handleDotTap(int index) {
    if (widget.onDotTapped != null) {
      widget.onDotTapped!(index);
      return;
    }

    if (widget.controller != null && widget.controller!.hasClients) {
      if (widget.controller is PageController) {
        (widget.controller as PageController).animateToPage(
          index,
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeInOutCubic,
        );
      } else if (widget.itemExtent != null) {
        widget.controller!.animateTo(
          index * widget.itemExtent!,
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeInOutCubic,
        );
      }
    }
  }

  @override
  void dispose() {
    widget.controller?.removeListener(_onScrollChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveDotColor =
        widget.dotColor ?? theme.colorScheme.outlineVariant;
    final effectiveActiveColor =
        widget.activeDotColor ?? theme.colorScheme.primary;
    final defaultRadius =
        widget.borderRadius ?? BorderRadius.circular(widget.dotSize.height);

    final List<Widget> dots = [];

    for (int i = 0; i < widget.itemCount; i++) {
      // Calculate interpolation factor between 0.0 and 1.0 for dot i
      final double distance = (_currentPage - i).abs();
      final double progress = (1.0 - distance).clamp(0.0, 1.0);

      final double width = widget.axis == Axis.horizontal
          ? widget.dotSize.width +
                (widget.activeDotSize.width - widget.dotSize.width) * progress
          : widget.dotSize.width;

      final double height = widget.axis == Axis.vertical
          ? widget.dotSize.height +
                (widget.activeDotSize.height - widget.dotSize.height) * progress
          : widget.dotSize.height;

      final Color color =
          Color.lerp(effectiveDotColor, effectiveActiveColor, progress) ??
          effectiveDotColor;

      final dot = GestureDetector(
        onTap: () => _handleDotTap(i),
        behavior: HitTestBehavior.opaque,
        child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(color: color, borderRadius: defaultRadius),
        ),
      );

      dots.add(dot);

      if (i < widget.itemCount - 1) {
        dots.add(
          widget.axis == Axis.horizontal
              ? SizedBox(width: widget.spacing)
              : SizedBox(height: widget.spacing),
        );
      }
    }

    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        if (widget.controller == null) {
          final extent =
              widget.itemExtent ?? notification.metrics.viewportDimension;
          if (extent > 0) {
            final page = (notification.metrics.pixels / extent).clamp(
              0.0,
              (widget.itemCount - 1).toDouble(),
            );
            setState(() {
              _currentPage = page;
            });
          }
        }
        return false;
      },
      child: widget.axis == Axis.horizontal
          ? Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: dots,
            )
          : Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: dots,
            ),
    );
  }
}
