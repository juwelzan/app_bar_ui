import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'experience_configs.dart';

/// Style 28: Reveal-From-Edge Header.
///
/// An edge-anchored navigation bar that smoothly slides in from beyond the top
/// edge of the screen upon upward scroll gestures or flings, and withdraws
/// smoothly off-screen when the user scrolls downward.
class RevealFromEdgeHeaderWidget extends StatefulWidget {
  /// Creates a [RevealFromEdgeHeaderWidget].
  const RevealFromEdgeHeaderWidget({
    super.key,
    required this.child,
    this.backgroundColor,
    this.safeArea = true,
    this.config = const RevealFromEdgeConfig(),
  });

  /// Header toolbar content.
  final Widget child;

  /// Background color.
  final Color? backgroundColor;

  /// Whether to respect top SafeArea padding.
  final bool safeArea;

  /// Reveal-from-edge configuration.
  final RevealFromEdgeConfig config;

  @override
  State<RevealFromEdgeHeaderWidget> createState() =>
      RevealFromEdgeHeaderWidgetState();
}

/// State for [RevealFromEdgeHeaderWidget] providing programmatic reveal/hide methods.
class RevealFromEdgeHeaderWidgetState extends State<RevealFromEdgeHeaderWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animController;
  late final Animation<Offset> _slideAnimation;
  bool _isVisible = true;

  /// Whether the header is currently visible on screen.
  bool get isVisible => _isVisible;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 260),
      value: 1.0,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.0, -1.0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animController,
        curve: widget.config.curve,
      ),
    );
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  /// Programmatically shows the header.
  void show() {
    if (!_isVisible) {
      _isVisible = true;
      _animController.forward();
    }
  }

  /// Programmatically hides the header.
  void hide() {
    if (_isVisible) {
      _isVisible = false;
      _animController.reverse();
    }
  }

  /// Handles scroll delta notifications.
  bool handleScrollNotification(ScrollNotification notification) {
    if (notification is UserScrollNotification) {
      if (notification.direction == ScrollDirection.forward) {
        show();
      } else if (notification.direction == ScrollDirection.reverse) {
        if (notification.metrics.pixels > 30.0) {
          hide();
        }
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final topPadding = widget.safeArea ? MediaQuery.paddingOf(context).top : 0.0;
    final totalHeight = widget.config.headerHeight + topPadding;
    final isReducedMotion = MediaQuery.disableAnimationsOf(context);

    return NotificationListener<ScrollNotification>(
      onNotification: handleScrollNotification,
      child: isReducedMotion
          ? Visibility(
              visible: _isVisible,
              child: _buildHeader(theme, topPadding, totalHeight),
            )
          : SlideTransition(
              position: _slideAnimation,
              child: _buildHeader(theme, topPadding, totalHeight),
            ),
    );
  }

  Widget _buildHeader(ThemeData theme, double topPadding, double totalHeight) {
    return Material(
      elevation: widget.config.elevation,
      color: widget.backgroundColor ?? theme.colorScheme.surface,
      child: Container(
        height: totalHeight,
        padding: EdgeInsets.only(top: topPadding),
        child: SizedBox.expand(
          child: widget.child,
        ),
      ),
    );
  }
}

