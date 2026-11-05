import 'dart:async';

import 'package:flutter/material.dart';

/// Display style for the [ScrollPositionIndicator].
enum ScrollPositionStyle {
  /// Displays reading progress percentage (e.g. "45%").
  percentage,

  /// Displays current item/page fraction (e.g. "3 / 10").
  fraction,

  /// Compact page pill (e.g. "Page 3 of 10").
  page,
}

/// A scroll position and depth indicator that visually communicates the reader's
/// exact location within a scrollable view.
///
/// Can display as a percentage ("45%"), item fraction ("3 / 10"), or custom builder.
/// Supports auto-hiding when idle and smoothly animates in upon scroll activity.
class ScrollPositionIndicator extends StatefulWidget {
  /// Creates a [ScrollPositionIndicator] widget.
  const ScrollPositionIndicator({
    super.key,
    this.scrollController,
    this.itemCount,
    this.itemExtent,
    this.style = ScrollPositionStyle.percentage,
    this.builder,
    this.backgroundColor,
    this.textStyle,
    this.padding = const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
    this.borderRadius = const BorderRadius.all(Radius.circular(16.0)),
    this.elevation = 2.0,
    this.autoHide = false,
    this.autoHideDelay = const Duration(milliseconds: 1500),
  });

  /// Optional [ScrollController] to observe.
  final ScrollController? scrollController;

  /// Optional total count of items/pages for fraction/page styling.
  final int? itemCount;

  /// Optional fixed height or width of each item.
  final double? itemExtent;

  /// Visual style of the indicator. Defaults to [ScrollPositionStyle.percentage].
  final ScrollPositionStyle style;

  /// Optional custom builder receiving the current [ScrollMetrics] and normalized progress (0.0 to 1.0).
  final Widget Function(
    BuildContext context,
    ScrollMetrics metrics,
    double progress,
  )?
  builder;

  /// Background color of the indicator pill. Defaults to dark translucent surface.
  final Color? backgroundColor;

  /// Text style for the indicator label.
  final TextStyle? textStyle;

  /// Internal padding inside the indicator container.
  final EdgeInsetsGeometry padding;

  /// Border radius of the indicator container.
  final BorderRadius borderRadius;

  /// Material elevation of the indicator. Defaults to 2.0.
  final double elevation;

  /// Whether to auto-hide the indicator when scrolling is idle. Defaults to false.
  final bool autoHide;

  /// Delay before hiding when [autoHide] is true. Defaults to 1500ms.
  final Duration autoHideDelay;

  @override
  State<ScrollPositionIndicator> createState() =>
      _ScrollPositionIndicatorState();
}

class _ScrollPositionIndicatorState extends State<ScrollPositionIndicator>
    with SingleTickerProviderStateMixin {
  late final AnimationController _fadeController;
  Timer? _idleTimer;
  ScrollMetrics? _lastMetrics;
  double _progress = 0.0;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
      value: widget.autoHide ? 0.0 : 1.0,
    );

    widget.scrollController?.addListener(_onControllerScroll);
  }

  @override
  void didUpdateWidget(covariant ScrollPositionIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.scrollController != oldWidget.scrollController) {
      oldWidget.scrollController?.removeListener(_onControllerScroll);
      widget.scrollController?.addListener(_onControllerScroll);
    }
  }

  void _onControllerScroll() {
    if (!mounted ||
        widget.scrollController == null ||
        !widget.scrollController!.hasClients) {
      return;
    }
    _handleScrollMetrics(widget.scrollController!.position);
  }

  void _handleScrollMetrics(ScrollMetrics metrics) {
    _lastMetrics = metrics;
    final max = metrics.maxScrollExtent;
    final pixels = metrics.pixels.clamp(0.0, max > 0 ? max : 0.0);
    final double progress = max > 0 ? (pixels / max).clamp(0.0, 1.0) : 0.0;

    int index = 0;
    if (widget.itemCount != null && widget.itemCount! > 0) {
      if (widget.itemExtent != null && widget.itemExtent! > 0) {
        index = (pixels / widget.itemExtent!).floor().clamp(
          0,
          widget.itemCount! - 1,
        );
      } else {
        index = (progress * (widget.itemCount! - 1)).round().clamp(
          0,
          widget.itemCount! - 1,
        );
      }
    }

    setState(() {
      _progress = progress;
      _currentIndex = index;
    });

    if (widget.autoHide) {
      _fadeController.forward();
      _idleTimer?.cancel();
      _idleTimer = Timer(widget.autoHideDelay, () {
        if (mounted) {
          _fadeController.reverse();
        }
      });
    }
  }

  @override
  void dispose() {
    _idleTimer?.cancel();
    widget.scrollController?.removeListener(_onControllerScroll);
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget content;

    if (widget.builder != null && _lastMetrics != null) {
      content = widget.builder!(context, _lastMetrics!, _progress);
    } else {
      String label;
      switch (widget.style) {
        case ScrollPositionStyle.percentage:
          label = '${(_progress * 100).toInt()}%';
          break;
        case ScrollPositionStyle.fraction:
          final total = widget.itemCount ?? 1;
          label = '${_currentIndex + 1} / $total';
          break;
        case ScrollPositionStyle.page:
          final total = widget.itemCount ?? 1;
          label = 'Page ${_currentIndex + 1} of $total';
          break;
      }

      final theme = Theme.of(context);
      final defaultBg =
          widget.backgroundColor ??
          theme.colorScheme.inverseSurface.withValues(alpha: 0.85);
      final defaultText =
          widget.textStyle ??
          theme.textTheme.labelMedium?.copyWith(
            color: theme.colorScheme.onInverseSurface,
            fontWeight: FontWeight.bold,
          ) ??
          const TextStyle(color: Colors.white, fontSize: 12.0);

      content = Material(
        elevation: widget.elevation,
        color: defaultBg,
        borderRadius: widget.borderRadius,
        child: Padding(
          padding: widget.padding,
          child: Text(label, style: defaultText),
        ),
      );
    }

    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        if (widget.scrollController == null) {
          _handleScrollMetrics(notification.metrics);
        }
        return false;
      },
      child: FadeTransition(opacity: _fadeController, child: content),
    );
  }
}
