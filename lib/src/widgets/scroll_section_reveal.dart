import 'package:flutter/material.dart';

/// An animated reveal wrapper that triggers smooth fade and slide animations
/// as elements scroll into the active viewport.
///
/// Supports staggered delays for list cascades and automatically honors
/// the user's reduced-motion accessibility settings.
class ScrollSectionReveal extends StatefulWidget {
  /// Creates a [ScrollSectionReveal] widget.
  const ScrollSectionReveal({
    super.key,
    required this.child,
    this.slideOffset = const Offset(0.0, 30.0),
    this.initialScale = 1.0,
    this.duration = const Duration(milliseconds: 350),
    this.staggerDelay = Duration.zero,
    this.curve = Curves.easeOutCubic,
    this.triggerOnce = true,
  });

  /// The child widget to reveal.
  final Widget child;

  /// Starting translation offset for the slide-in effect. Defaults to 30px downwards.
  final Offset slideOffset;

  /// Starting scale factor. Defaults to 1.0 (no scale change).
  final double initialScale;

  /// Duration of the entrance animation. Defaults to 350ms.
  final Duration duration;

  /// Staggered delay before starting animation (ideal for list item cascades).
  final Duration staggerDelay;

  /// Easing curve for the animation.
  final Curve curve;

  /// Whether the reveal triggers only the first time it enters view. Defaults to `true`.
  final bool triggerOnce;

  @override
  State<ScrollSectionReveal> createState() => _ScrollSectionRevealState();
}

class _ScrollSectionRevealState extends State<ScrollSectionReveal>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeAnimation;
  late final Animation<Offset> _slideAnimation;
  late final Animation<double> _scaleAnimation;

  bool _hasRevealed = false;
  ScrollPosition? _attachedPosition;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    final curvedAnimation = CurvedAnimation(
      parent: _controller,
      curve: widget.curve,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(curvedAnimation);
    _slideAnimation = Tween<Offset>(
      begin: widget.slideOffset,
      end: Offset.zero,
    ).animate(curvedAnimation);
    _scaleAnimation = Tween<double>(
      begin: widget.initialScale,
      end: 1.0,
    ).animate(curvedAnimation);

    // Initial check after frame rendering
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkVisibility();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final scrollable = Scrollable.maybeOf(context);
    final position = scrollable?.position;
    if (position != _attachedPosition) {
      _attachedPosition?.removeListener(_onScrollChanged);
      _attachedPosition = position;
      _attachedPosition?.addListener(_onScrollChanged);
    }
  }

  void _onScrollChanged() {
    if (!mounted) return;
    if (_hasRevealed && widget.triggerOnce) return;
    _checkVisibility();
  }

  void _checkVisibility() {
    if (!mounted) return;
    final renderObject = context.findRenderObject() as RenderBox?;
    if (renderObject == null || !renderObject.hasSize) return;

    final scrollable = Scrollable.maybeOf(context);
    final viewportBox = scrollable?.context.findRenderObject() as RenderBox?;

    bool isVisibleInViewport = true;
    if (viewportBox != null && viewportBox.hasSize) {
      final itemPosition = renderObject.localToGlobal(Offset.zero, ancestor: viewportBox);
      final itemHeight = renderObject.size.height;
      final viewportHeight = viewportBox.size.height;

      // Check if any portion of the item is within viewport
      isVisibleInViewport = (itemPosition.dy + itemHeight > 0) && (itemPosition.dy < viewportHeight);
    }

    if (isVisibleInViewport) {
      if (!_hasRevealed || !widget.triggerOnce) {
        _hasRevealed = true;
        if (widget.staggerDelay > Duration.zero) {
          Future.delayed(widget.staggerDelay, () {
            if (mounted) _controller.forward();
          });
        } else {
          _controller.forward();
        }
      }
    } else if (!widget.triggerOnce && _hasRevealed) {
      _hasRevealed = false;
      _controller.reset();
    }
  }

  @override
  void dispose() {
    _attachedPosition?.removeListener(_onScrollChanged);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool disableAnimations = MediaQuery.maybeDisableAnimationsOf(context) ?? false;

    if (disableAnimations) {
      return widget.child;
    }

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Opacity(
          opacity: _fadeAnimation.value,
          child: Transform.translate(
            offset: _slideAnimation.value,
            child: Transform.scale(
              scale: _scaleAnimation.value,
              child: child,
            ),
          ),
        );
      },
      child: widget.child,
    );
  }
}

