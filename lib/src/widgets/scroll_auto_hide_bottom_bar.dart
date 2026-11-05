import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../models/visibility_config.dart';

/// A bottom bar wrapper that automatically conceals itself by sliding downwards
/// offscreen when the user scrolls down, and slides back into view on reverse scrolling.
///
/// Designed to wrap [NavigationBar], [BottomNavigationBar], or custom footer widgets.
class ScrollAutoHideBottomBar extends StatefulWidget {
  /// Creates a [ScrollAutoHideBottomBar] widget.
  const ScrollAutoHideBottomBar({
    super.key,
    required this.child,
    this.visibilityListenable,
    this.scrollController,
    this.visible,
    this.animationDuration = const Duration(milliseconds: 250),
    this.curve = Curves.easeInOutCubic,
    this.hideThreshold = 80.0,
    this.showThreshold = 40.0,
  });

  /// The bottom bar child widget (e.g., [NavigationBar], [BottomNavigationBar]).
  final Widget child;

  /// Optional [ValueListenable] providing visibility (0.0 = hidden, 1.0 = visible).
  ///
  /// Can be obtained via [SmartVisibilityController.visibilityNotifier] using
  /// [VisibilityTarget.bottomNavigationBar].
  final ValueListenable<double>? visibilityListenable;

  /// Optional [ScrollController] to monitor directly for scroll direction.
  final ScrollController? scrollController;

  /// Optional manual visibility override. When non-null, overrides listenables.
  final bool? visible;

  /// Duration of the slide transition animation. Defaults to 250ms.
  final Duration animationDuration;

  /// Easing curve for the slide transition.
  final Curve curve;

  /// Scroll offset threshold in pixels to trigger hiding when scrolling down.
  final double hideThreshold;

  /// Scroll offset threshold in pixels to restore visibility when scrolling up.
  final double showThreshold;

  @override
  State<ScrollAutoHideBottomBar> createState() =>
      _ScrollAutoHideBottomBarState();
}

class _ScrollAutoHideBottomBarState extends State<ScrollAutoHideBottomBar>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Offset> _offsetAnimation;
  double _lastOffset = 0.0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
      value: (widget.visible ?? true) ? 1.0 : 0.0,
    );

    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0.0, 1.0), // Hidden below screen
      end: Offset.zero, // Visible at normal position
    ).animate(CurvedAnimation(parent: _controller, curve: widget.curve));

    widget.visibilityListenable?.addListener(_onVisibilityListenableChanged);
    widget.scrollController?.addListener(_onScrollControllerChanged);
  }

  @override
  void didUpdateWidget(covariant ScrollAutoHideBottomBar oldWidget) {
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
    if (widget.visible != oldWidget.visible && widget.visible != null) {
      _updateAnimation(widget.visible! ? 1.0 : 0.0);
    }
  }

  void _onVisibilityListenableChanged() {
    final value = widget.visibilityListenable?.value ?? 1.0;
    _updateAnimation(value);
  }

  void _onScrollControllerChanged() {
    if (widget.scrollController == null ||
        !widget.scrollController!.hasClients) {
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
    final bool disableAnimations =
        MediaQuery.maybeDisableAnimationsOf(context) ?? false;

    if (disableAnimations) {
      return _controller.value > 0.0 ? widget.child : const SizedBox.shrink();
    }

    return AnimatedBuilder(
      animation: _offsetAnimation,
      builder: (context, child) {
        return ClipRect(
          child: Align(
            alignment: Alignment.topCenter,
            heightFactor: _controller.value,
            child: FractionalTranslation(
              translation: _offsetAnimation.value,
              child: child,
            ),
          ),
        );
      },
      child: widget.child,
    );
  }
}
