import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'experience_configs.dart';

/// Style 11: Auto-Hiding Velocity-Sensitive Header
///
/// Header that automatically slides away when downward scroll velocity exceeds
/// a sensitivity threshold, and smoothly springs back into view upon upward gestures.
class AutoHidingVelocityHeaderWidget extends StatefulWidget {
  /// Creates an [AutoHidingVelocityHeaderWidget].
  const AutoHidingVelocityHeaderWidget({
    super.key,
    required this.child,
    this.backgroundColor,
    this.config = const AutoHidingVelocityConfig(),
    this.safeArea = true,
  });

  /// The toolbar content.
  final Widget child;

  /// Background color of the header.
  final Color? backgroundColor;

  /// Motion and velocity sensitivity configuration.
  final AutoHidingVelocityConfig config;

  /// Whether to incorporate safe area top insets.
  final bool safeArea;

  @override
  State<AutoHidingVelocityHeaderWidget> createState() =>
      AutoHidingVelocityHeaderWidgetState();
}

class AutoHidingVelocityHeaderWidgetState
    extends State<AutoHidingVelocityHeaderWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _visibilityController;
  late Animation<double> _slideAnimation;
  bool _isVisible = true;

  @override
  void initState() {
    super.initState();
    _visibilityController = AnimationController(
      vsync: this,
      duration: widget.config.animationDuration,
      value: 1.0,
    );
    _slideAnimation = CurvedAnimation(
      parent: _visibilityController,
      curve: widget.config.curve,
    );
  }

  @override
  void dispose() {
    _visibilityController.dispose();
    super.dispose();
  }

  /// Manually show or hide the header.
  void setVisible(bool visible) {
    if (_isVisible == visible) return;
    _isVisible = visible;
    if (visible) {
      _visibilityController.forward();
    } else {
      _visibilityController.reverse();
    }
  }

  /// Updates visibility from scroll telemetry.
  void handleScrollMetrics({
    required double scrollOffset,
    required double velocity,
    required ScrollDirection userScrollDirection,
  }) {
    if (scrollOffset <= 10.0) {
      setVisible(true);
      return;
    }

    if (velocity > widget.config.hideVelocityThreshold ||
        userScrollDirection == ScrollDirection.reverse) {
      setVisible(false);
    } else if (velocity < widget.config.revealVelocityThreshold ||
        userScrollDirection == ScrollDirection.forward) {
      setVisible(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isReducedMotion = MediaQuery.disableAnimationsOf(context);
    final topPadding = widget.safeArea ? MediaQuery.paddingOf(context).top : 0.0;
    final totalHeight = widget.config.height + topPadding;
    final bgColor = widget.backgroundColor ?? theme.colorScheme.surface;

    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        if (notification is ScrollUpdateNotification) {
          final scrollDelta = notification.scrollDelta ?? 0.0;
          if (notification.metrics.pixels <= 10.0) {
            setVisible(true);
          } else if (scrollDelta > 3.0) {
            setVisible(false);
          } else if (scrollDelta < -3.0) {
            setVisible(true);
          }
        }
        return false;
      },
      child: AnimatedBuilder(
        animation: _slideAnimation,
        builder: (context, _) {
          final factor = isReducedMotion ? (_isVisible ? 1.0 : 0.0) : _slideAnimation.value;
          final verticalOffset = (1.0 - factor) * -totalHeight;

          return Transform.translate(
            offset: Offset(0.0, verticalOffset),
            child: Opacity(
              opacity: factor.clamp(0.0, 1.0),
              child: Container(
                margin: EdgeInsets.only(
                  left: widget.config.horizontalMargin,
                  right: widget.config.horizontalMargin,
                  top: widget.config.topMargin,
                ),
                child: Material(
                  elevation: widget.config.elevation,
                  borderRadius: BorderRadius.circular(widget.config.borderRadius),
                  color: bgColor,
                  clipBehavior: Clip.antiAlias,
                  child: Padding(
                    padding: EdgeInsets.only(top: topPadding),
                    child: SizedBox(
                      height: widget.config.height,
                      child: widget.child,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
