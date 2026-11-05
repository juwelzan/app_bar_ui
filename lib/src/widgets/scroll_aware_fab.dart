import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../models/visibility_config.dart';

/// Animation style for [ScrollAwareFab] transitions.
enum FabTransitionType {
  /// Scales the FAB in and out.
  scale,

  /// Slides the FAB downward into/out of view.
  slide,

  /// Fades the FAB opacity in and out.
  fade,
}

/// A scroll-aware Floating Action Button that automatically conceals itself
/// when the user scrolls downward and reappears on reverse scrolling or at the top.
///
/// Can be driven by a [SmartVisibilityController], a [ValueListenable], or directly
/// attached to a [ScrollController].
class ScrollAwareFab extends StatefulWidget {
  /// Creates a [ScrollAwareFab] widget.
  const ScrollAwareFab({
    super.key,
    required this.child,
    this.visibilityListenable,
    this.scrollController,
    this.visible,
    this.transitionType = FabTransitionType.scale,
    this.animationDuration = const Duration(milliseconds: 250),
    this.curve = Curves.easeOutCubic,
    this.hideThreshold = 80.0,
    this.showThreshold = 40.0,
    this.extendedChild,
  });

  /// The primary floating action button widget.
  final Widget child;

  /// Optional [ValueListenable] providing visibility (0.0 = hidden, 1.0 = visible).
  ///
  /// Can be obtained via [SmartVisibilityController.visibilityNotifier] using
  /// [VisibilityTarget.floatingActionButton].
  final ValueListenable<double>? visibilityListenable;

  /// Optional [ScrollController] to monitor directly for scroll direction.
  final ScrollController? scrollController;

  /// Optional manual visibility override. When non-null, overrides listenables.
  final bool? visible;

  /// The animation type applied when hiding/revealing. Defaults to [FabTransitionType.scale].
  final FabTransitionType transitionType;

  /// Duration of the transition animation. Defaults to 250ms.
  final Duration animationDuration;

  /// Easing curve for the transition animation.
  final Curve curve;

  /// Scroll offset threshold in pixels to trigger hiding when scrolling down.
  final double hideThreshold;

  /// Scroll offset threshold in pixels to restore visibility when scrolling up.
  final double showThreshold;

  /// Optional extended FAB widget (e.g., [FloatingActionButton.extended]).
  /// When provided, the FAB cross-fades between extended and compact styles.
  final Widget? extendedChild;

  @override
  State<ScrollAwareFab> createState() => _ScrollAwareFabState();
}

class _ScrollAwareFabState extends State<ScrollAwareFab>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;
  double _lastOffset = 0.0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
      value: (widget.visible ?? true) ? 1.0 : 0.0,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: widget.curve,
    );

    widget.visibilityListenable?.addListener(_onVisibilityListenableChanged);
    widget.scrollController?.addListener(_onScrollControllerChanged);
  }

  @override
  void didUpdateWidget(covariant ScrollAwareFab oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.visibilityListenable != oldWidget.visibilityListenable) {
      oldWidget.visibilityListenable?.removeListener(_onVisibilityListenableChanged);
      widget.visibilityListenable?.addListener(_onVisibilityListenableChanged);
    }
    if (widget.scrollController != oldWidget.scrollController) {
      oldWidget.scrollController?.removeListener(_onScrollControllerChanged);
      widget.scrollController?.addListener(_onScrollControllerChanged);
    }
    if (widget.visible != oldWidget.visible && widget.visible != null) {
      _updateAnimation(widget.visible! ? 1.0 : 0.0);
    }
  }

  void _onVisibilityListenableChanged() {
    final value = widget.visibilityListenable?.value ?? 1.0;
    _updateAnimation(value);
  }

  void _onScrollControllerChanged() {
    if (widget.scrollController == null || !widget.scrollController!.hasClients) {
      return;
    }
    final offset = widget.scrollController!.offset;
    final delta = offset - _lastOffset;
    _lastOffset = offset;

    if (offset <= widget.showThreshold) {
      _updateAnimation(1.0);
    } else if (delta > 2.0 && offset >= widget.hideThreshold) {
      _updateAnimation(0.0);
    } else if (delta < -2.0) {
      _updateAnimation(1.0);
    }
  }

  void _updateAnimation(double targetValue) {
    if (targetValue >= 0.5) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  @override
  void dispose() {
    widget.visibilityListenable?.removeListener(_onVisibilityListenableChanged);
    widget.scrollController?.removeListener(_onScrollControllerChanged);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool disableAnimations = MediaQuery.maybeDisableAnimationsOf(context) ?? false;

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        if (disableAnimations) {
          return _controller.value > 0.0 ? _buildFabContent() : const SizedBox.shrink();
        }

        Widget animatedWidget = _buildFabContent();

        switch (widget.transitionType) {
          case FabTransitionType.scale:
            animatedWidget = ScaleTransition(
              scale: _animation,
              alignment: Alignment.center,
              child: animatedWidget,
            );
          case FabTransitionType.slide:
            animatedWidget = SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0.0, 1.5),
                end: Offset.zero,
              ).animate(_animation),
              child: animatedWidget,
            );
          case FabTransitionType.fade:
            animatedWidget = FadeTransition(
              opacity: _animation,
              child: animatedWidget,
            );
        }

        return IgnorePointer(
          ignoring: _controller.value == 0.0,
          child: animatedWidget,
        );
      },
    );
  }

  Widget _buildFabContent() {
    if (widget.extendedChild == null) {
      return widget.child;
    }

    // Cross-fade between compact and extended when extendedChild is provided
    return AnimatedCrossFade(
      firstChild: widget.extendedChild!,
      secondChild: widget.child,
      crossFadeState: _controller.value > 0.8
          ? CrossFadeState.showFirst
          : CrossFadeState.showSecond,
      duration: widget.animationDuration,
    );
  }
}
