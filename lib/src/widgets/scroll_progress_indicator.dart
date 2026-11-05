import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Style of the [ScrollProgressIndicator].
enum ProgressIndicatorType {
  /// Linear reading progress bar.
  linear,

  /// Circular progress indicator.
  circular,
}

/// A visual scroll progress indicator that dynamically tracks reading/scroll depth (0.0 to 1.0).
///
/// Can be pinned at the top of the viewport or embedded anywhere. Can listen to an explicit
/// [ScrollController], a [ValueListenable], or resolve the ambient [Scrollable] automatically.
class ScrollProgressIndicator extends StatefulWidget {
  /// Creates a [ScrollProgressIndicator] widget.
  const ScrollProgressIndicator({
    super.key,
    this.scrollController,
    this.progressListenable,
    this.type = ProgressIndicatorType.linear,
    this.height = 3.0,
    this.size = 32.0,
    this.color,
    this.backgroundColor,
    this.gradient,
    this.borderRadius,
    this.curve = Curves.linear,
  });

  /// Optional explicit [ScrollController] to observe.
  final ScrollController? scrollController;

  /// Optional [ValueListenable] providing normalized progress directly.
  final ValueListenable<double>? progressListenable;

  /// Display type: [ProgressIndicatorType.linear] or [ProgressIndicatorType.circular].
  final ProgressIndicatorType type;

  /// Thickness of the linear progress bar. Defaults to 3.0.
  final double height;

  /// Size (diameter) for circular progress indicators. Defaults to 32.0.
  final double size;

  /// Progress bar fill color. Defaults to theme's primary color.
  final Color? color;

  /// Track background color. Defaults to transparent.
  final Color? backgroundColor;

  /// Optional gradient fill for the progress bar.
  final Gradient? gradient;

  /// Optional border radius for rounded progress bars.
  final BorderRadius? borderRadius;

  /// Easing curve applied to progress calculation.
  final Curve curve;

  @override
  State<ScrollProgressIndicator> createState() =>
      _ScrollProgressIndicatorState();
}

class _ScrollProgressIndicatorState extends State<ScrollProgressIndicator> {
  double _progress = 0.0;

  @override
  void initState() {
    super.initState();
    widget.progressListenable?.addListener(_onProgressListenableChanged);
    widget.scrollController?.addListener(_onScrollControllerChanged);
    if (widget.progressListenable != null) {
      _progress = widget.progressListenable!.value;
    }
  }

  @override
  void didUpdateWidget(covariant ScrollProgressIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.progressListenable != oldWidget.progressListenable) {
      oldWidget.progressListenable?.removeListener(_onProgressListenableChanged);
      widget.progressListenable?.addListener(_onProgressListenableChanged);
    }
    if (widget.scrollController != oldWidget.scrollController) {
      oldWidget.scrollController?.removeListener(_onScrollControllerChanged);
      widget.scrollController?.addListener(_onScrollControllerChanged);
    }
  }

  void _onProgressListenableChanged() {
    if (!mounted || widget.progressListenable == null) return;
    setState(() {
      _progress = widget.progressListenable!.value.clamp(0.0, 1.0);
    });
  }

  void _onScrollControllerChanged() {
    if (!mounted || widget.scrollController == null || !widget.scrollController!.hasClients) {
      return;
    }
    final position = widget.scrollController!.position;
    final max = position.maxScrollExtent;
    final double rawProgress = max > 0 ? (position.pixels / max).clamp(0.0, 1.0) : 0.0;
    setState(() {
      _progress = rawProgress;
    });
  }

  @override
  void dispose() {
    widget.progressListenable?.removeListener(_onProgressListenableChanged);
    widget.scrollController?.removeListener(_onScrollControllerChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final effectiveColor = widget.color ?? Theme.of(context).colorScheme.primary;
    final effectiveBg = widget.backgroundColor ?? Colors.transparent;
    final curvedProgress = widget.curve.transform(_progress);

    if (widget.type == ProgressIndicatorType.circular) {
      return SizedBox(
        width: widget.size,
        height: widget.size,
        child: CircularProgressIndicator(
          value: curvedProgress,
          valueColor: AlwaysStoppedAnimation<Color>(effectiveColor),
          backgroundColor: effectiveBg,
          strokeWidth: widget.height,
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final totalWidth = constraints.maxWidth;
        final fillWidth = totalWidth * curvedProgress;

        return Container(
          width: totalWidth,
          height: widget.height,
          decoration: BoxDecoration(
            color: effectiveBg,
            borderRadius: widget.borderRadius,
          ),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Container(
              width: fillWidth,
              height: widget.height,
              decoration: BoxDecoration(
                color: widget.gradient == null ? effectiveColor : null,
                gradient: widget.gradient,
                borderRadius: widget.borderRadius,
              ),
            ),
          ),
        );
      },
    );
  }
}

