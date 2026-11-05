import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// A floating action dock or rail widget that positions interactive actions
/// on the screen margin (left, right, or vertical/horizontal) and intelligently
/// auto-hides or slides offscreen when the user scrolls down, restoring visibility
/// when scrolling up.
class ScrollAwareSideActions extends StatefulWidget {
  /// Creates a [ScrollAwareSideActions] widget.
  const ScrollAwareSideActions({
    super.key,
    required this.children,
    this.alignment = Alignment.centerRight,
    this.scrollController,
    this.visibilityListenable,
    this.autoHideOnScrollDown = true,
    this.direction = Axis.vertical,
    this.spacing = 8.0,
    this.padding = const EdgeInsets.all(16.0),
    this.animationDuration = const Duration(milliseconds: 250),
    this.curve = Curves.easeInOutCubic,
    this.slideOffset = const Offset(1.5, 0.0),
  });

  /// The interactive action widgets to display in the dock.
  final List<Widget> children;

  /// Dock placement on the viewport. Defaults to [Alignment.centerRight].
  final Alignment alignment;

  /// Optional [ScrollController] to observe for scroll direction changes.
  final ScrollController? scrollController;

  /// Optional [ValueListenable] providing normalized visibility (0.0 = hidden, 1.0 = visible).
  final ValueListenable<double>? visibilityListenable;

  /// Whether to automatically hide when scrolling down and restore when scrolling up. Defaults to true.
  final bool autoHideOnScrollDown;

  /// Layout axis of the actions. Defaults to [Axis.vertical].
  final Axis direction;

  /// Spacing between action items. Defaults to 8.0.
  final double spacing;

  /// Padding around the dock. Defaults to 16.0.
  final EdgeInsetsGeometry padding;

  /// Animation duration for entrance and exit transitions. Defaults to 250ms.
  final Duration animationDuration;

  /// Easing curve for animations. Defaults to [Curves.easeInOutCubic].
  final Curve curve;

  /// Fractional translation offset when hidden. Defaults to [Offset(1.5, 0.0)] (slides off right edge).
  final Offset slideOffset;

  @override
  State<ScrollAwareSideActions> createState() => _ScrollAwareSideActionsState();
}

class _ScrollAwareSideActionsState extends State<ScrollAwareSideActions>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animController;
  late final Animation<Offset> _slideAnimation;
  late final Animation<double> _fadeAnimation;
  double _lastOffset = 0.0;
  bool _isVisible = true;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
      value: 1.0,
    );

    _slideAnimation = Tween<Offset>(
      begin: widget.slideOffset,
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animController, curve: widget.curve));

    _fadeAnimation = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeIn,
    );

    widget.visibilityListenable?.addListener(_onVisibilityListenableChanged);
    widget.scrollController?.addListener(_onScrollControllerChanged);
  }

  @override
  void didUpdateWidget(covariant ScrollAwareSideActions oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.visibilityListenable != oldWidget.visibilityListenable) {
      oldWidget.visibilityListenable?.removeListener(
        _onVisibilityListenableChanged,
      );
      widget.visibilityListenable?.addListener(_onVisibilityListenableChanged);
    }
    if (widget.scrollController != oldWidget.scrollController) {
      oldWidget.scrollController?.removeListener(_onScrollControllerChanged);
      widget.scrollController?.addListener(_onScrollControllerChanged);
    }
    if (widget.animationDuration != oldWidget.animationDuration) {
      _animController.duration = widget.animationDuration;
    }
  }

  void _onVisibilityListenableChanged() {
    if (!mounted || widget.visibilityListenable == null) return;
    final targetVisible = widget.visibilityListenable!.value > 0.5;
    _updateVisibility(targetVisible);
  }

  void _onScrollControllerChanged() {
    if (!mounted ||
        !widget.autoHideOnScrollDown ||
        widget.scrollController == null ||
        !widget.scrollController!.hasClients) {
      return;
    }

    final currentOffset = widget.scrollController!.offset;
    final delta = currentOffset - _lastOffset;
    _lastOffset = currentOffset;

    // At top of scrollable, always reveal
    if (currentOffset <= 0.0) {
      _updateVisibility(true);
      return;
    }

    // Scroll down hides, scroll up reveals
    if (delta > 3.0) {
      _updateVisibility(false);
    } else if (delta < -3.0) {
      _updateVisibility(true);
    }
  }

  void _updateVisibility(bool targetVisible) {
    if (_isVisible == targetVisible) return;
    setState(() {
      _isVisible = targetVisible;
    });

    final bool disableAnimations =
        MediaQuery.maybeDisableAnimationsOf(context) ?? false;
    if (disableAnimations) {
      _animController.value = targetVisible ? 1.0 : 0.0;
    } else {
      if (targetVisible) {
        _animController.forward();
      } else {
        _animController.reverse();
      }
    }
  }

  @override
  void dispose() {
    widget.visibilityListenable?.removeListener(_onVisibilityListenableChanged);
    widget.scrollController?.removeListener(_onScrollControllerChanged);
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.children.isEmpty) return const SizedBox.shrink();

    final List<Widget> spacedChildren = [];
    for (int i = 0; i < widget.children.length; i++) {
      spacedChildren.add(widget.children[i]);
      if (i < widget.children.length - 1) {
        spacedChildren.add(
          widget.direction == Axis.vertical
              ? SizedBox(height: widget.spacing)
              : SizedBox(width: widget.spacing),
        );
      }
    }

    final content = widget.direction == Axis.vertical
        ? Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: spacedChildren,
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: spacedChildren,
          );

    return Align(
      alignment: widget.alignment,
      child: Padding(
        padding: widget.padding,
        child: IgnorePointer(
          ignoring: !_isVisible,
          child: SlideTransition(
            position: _slideAnimation,
            child: FadeTransition(opacity: _fadeAnimation, child: content),
          ),
        ),
      ),
    );
  }
}
