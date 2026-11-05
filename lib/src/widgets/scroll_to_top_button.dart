import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// A scroll-aware button that smoothly animates into view once the user scrolls
/// past a configured [threshold], and animates the scroll position back to the top
/// when pressed.
///
/// Can observe an explicit [scrollController], an ambient [PrimaryScrollController],
/// or listen to an optional [visibilityListenable].
class ScrollToTopButton extends StatefulWidget {
  /// Creates a [ScrollToTopButton] widget.
  const ScrollToTopButton({
    super.key,
    this.scrollController,
    this.visibilityListenable,
    this.threshold = 300.0,
    this.duration = const Duration(milliseconds: 500),
    this.curve = Curves.easeOutCubic,
    this.animationDuration = const Duration(milliseconds: 250),
    this.child,
    this.tooltip = 'Scroll to top',
    this.backgroundColor,
    this.foregroundColor,
    this.elevation = 4.0,
    this.shape,
    this.onPressed,
  });

  /// Optional explicit [ScrollController] to observe and scroll to top.
  /// If omitted, attempts to find the ambient [PrimaryScrollController].
  final ScrollController? scrollController;

  /// Optional [ValueListenable] providing visibility progress directly (0.0 = hidden, 1.0 = visible).
  final ValueListenable<double>? visibilityListenable;

  /// Scroll offset in pixels after which the button becomes visible. Defaults to 300.0.
  final double threshold;

  /// Duration of the scroll-to-top animation. Defaults to 500ms.
  final Duration duration;

  /// Curve for the scroll-to-top animation. Defaults to [Curves.easeOutCubic].
  final Curve curve;

  /// Duration for the fade/scale entrance and exit transition. Defaults to 250ms.
  final Duration animationDuration;

  /// Custom child widget. If null, a standard [Icon] with [Icons.keyboard_arrow_up] is displayed.
  final Widget? child;

  /// Accessibility tooltip text. Defaults to 'Scroll to top'.
  final String tooltip;

  /// Background color for the button. Defaults to theme's primary/floatingActionButton theme color.
  final Color? backgroundColor;

  /// Foreground/icon color for the button.
  final Color? foregroundColor;

  /// Button elevation. Defaults to 4.0.
  final double elevation;

  /// Custom shape for the button. Defaults to standard stadium/circular FAB border.
  final ShapeBorder? shape;

  /// Optional callback invoked after triggering scroll-to-top.
  final VoidCallback? onPressed;

  @override
  State<ScrollToTopButton> createState() => _ScrollToTopButtonState();
}

class _ScrollToTopButtonState extends State<ScrollToTopButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animController;
  late final Animation<double> _scaleAnimation;
  ScrollController? _resolvedController;
  bool _isVisible = false;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
    );
    _scaleAnimation = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOutBack,
      reverseCurve: Curves.easeInBack,
    );

    widget.visibilityListenable?.addListener(_onVisibilityListenableChanged);
    if (widget.visibilityListenable != null) {
      _isVisible = widget.visibilityListenable!.value > 0.5;
      if (_isVisible) _animController.value = 1.0;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _attachController();
  }

  @override
  void didUpdateWidget(covariant ScrollToTopButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.visibilityListenable != oldWidget.visibilityListenable) {
      oldWidget.visibilityListenable?.removeListener(
        _onVisibilityListenableChanged,
      );
      widget.visibilityListenable?.addListener(_onVisibilityListenableChanged);
    }
    if (widget.scrollController != oldWidget.scrollController) {
      _detachController();
      _attachController();
    }
    if (widget.animationDuration != oldWidget.animationDuration) {
      _animController.duration = widget.animationDuration;
    }
  }

  void _attachController() {
    final controller =
        widget.scrollController ?? PrimaryScrollController.maybeOf(context);
    if (_resolvedController != controller) {
      _detachController();
      _resolvedController = controller;
      _resolvedController?.addListener(_onScrollChanged);
      _checkScrollPosition();
    }
  }

  void _detachController() {
    _resolvedController?.removeListener(_onScrollChanged);
    _resolvedController = null;
  }

  void _onVisibilityListenableChanged() {
    if (!mounted || widget.visibilityListenable == null) return;
    final targetVisible = widget.visibilityListenable!.value > 0.5;
    _updateVisibility(targetVisible);
  }

  void _onScrollChanged() {
    if (!mounted ||
        _resolvedController == null ||
        !_resolvedController!.hasClients) {
      return;
    }
    _checkScrollPosition();
  }

  void _checkScrollPosition() {
    if (_resolvedController == null || !_resolvedController!.hasClients) return;
    final currentOffset = _resolvedController!.offset;
    final targetVisible = currentOffset >= widget.threshold;
    _updateVisibility(targetVisible);
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

  void _handleTap() {
    if (_resolvedController != null && _resolvedController!.hasClients) {
      _resolvedController!.animateTo(
        0.0,
        duration: widget.duration,
        curve: widget.curve,
      );
    }
    widget.onPressed?.call();
  }

  @override
  void dispose() {
    widget.visibilityListenable?.removeListener(_onVisibilityListenableChanged);
    _detachController();
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final buttonChild =
        widget.child ?? const Icon(Icons.keyboard_arrow_up, size: 24.0);

    return IgnorePointer(
      ignoring: !_isVisible,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: FadeTransition(
          opacity: _animController,
          child: FloatingActionButton.small(
            tooltip: widget.tooltip,
            backgroundColor: widget.backgroundColor,
            foregroundColor: widget.foregroundColor,
            elevation: widget.elevation,
            shape: widget.shape,
            onPressed: _isVisible ? _handleTap : null,
            child: buttonChild,
          ),
        ),
      ),
    );
  }
}
