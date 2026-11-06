import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'experience_configs.dart';

/// Style 29: Gesture-Driven Drag Expansion Header.
///
/// Direct touch manipulation header that tracks the user's vertical pan gesture
/// in real time, expanding into a deep secondary canvas with spring recoil and
/// latching physics.
class GestureDrivenDragExpansionHeaderWidget extends StatefulWidget {
  /// Creates a [GestureDrivenDragExpansionHeaderWidget].
  const GestureDrivenDragExpansionHeaderWidget({
    super.key,
    required this.restingContent,
    required this.expandedCanvasContent,
    this.backgroundColor,
    this.safeArea = true,
    this.config = const GestureDrivenDragExpansionConfig(),
  });

  /// Compact content displayed in resting state.
  final Widget restingContent;

  /// Secondary control canvas displayed when dragged open.
  final Widget expandedCanvasContent;

  /// Background color.
  final Color? backgroundColor;

  /// Whether to respect top SafeArea padding.
  final bool safeArea;

  /// Gesture expansion configuration.
  final GestureDrivenDragExpansionConfig config;

  @override
  State<GestureDrivenDragExpansionHeaderWidget> createState() =>
      GestureDrivenDragExpansionHeaderWidgetState();
}

/// State for [GestureDrivenDragExpansionHeaderWidget] with programmatic expansion controls.
class GestureDrivenDragExpansionHeaderWidgetState
    extends State<GestureDrivenDragExpansionHeaderWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animController;
  double _currentHeight = 0.0;
  bool _isLatched = false;

  /// Whether the expansion canvas is currently latched open.
  bool get isLatched => _isLatched;

  @override
  void initState() {
    super.initState();
    _currentHeight = widget.config.restingHeight;
    _animController = AnimationController.unbounded(vsync: this)
      ..addListener(() {
        setState(() {
          _currentHeight = _animController.value;
        });
      });
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _onVerticalDragUpdate(DragUpdateDetails details) {
    setState(() {
      _currentHeight = (_currentHeight + details.primaryDelta!)
          .clamp(widget.config.restingHeight, widget.config.maxDragExpandedHeight);
    });
  }

  void _onVerticalDragEnd(DragEndDetails details) {
    final velocity = details.primaryVelocity ?? 0.0;
    if (_currentHeight >= widget.config.latchThreshold || velocity > 300.0) {
      _animateTo(widget.config.maxDragExpandedHeight, velocity);
      _isLatched = true;
    } else {
      _animateTo(widget.config.restingHeight, velocity);
      _isLatched = false;
    }
  }

  void _animateTo(double target, double velocity) {
    final spring = SpringDescription(
      mass: 1.0,
      stiffness: widget.config.springStiffness,
      damping: widget.config.springDamping,
    );
    final simulation = SpringSimulation(
      spring,
      _currentHeight,
      target,
      velocity / 100.0,
    );
    _animController.animateWith(simulation);
  }

  /// Programmatically expands the header.
  void expand() {
    _isLatched = true;
    _animateTo(widget.config.maxDragExpandedHeight, 0.0);
  }

  /// Programmatically collapses the header to resting height.
  void collapse() {
    _isLatched = false;
    _animateTo(widget.config.restingHeight, 0.0);
  }

  /// Programmatically toggles the expansion state.
  void toggleExpansion() {
    if (_isLatched) {
      collapse();
    } else {
      expand();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final topPadding = widget.safeArea ? MediaQuery.paddingOf(context).top : 0.0;
    final totalHeight = _currentHeight + topPadding;

    final expandRatio = ((_currentHeight - widget.config.restingHeight) /
            (widget.config.maxDragExpandedHeight - widget.config.restingHeight))
        .clamp(0.0, 1.0);

    return GestureDetector(
      onVerticalDragUpdate: _onVerticalDragUpdate,
      onVerticalDragEnd: _onVerticalDragEnd,
      child: Material(
        elevation: widget.config.elevation,
        color: widget.backgroundColor ?? theme.colorScheme.surface,
        child: Container(
          height: totalHeight,
          padding: EdgeInsets.only(top: topPadding),
          child: ClipRect(
            child: Stack(
              children: [
                // Resting Header Bar
                Positioned(
                  top: 0.0,
                  left: 0.0,
                  right: 0.0,
                  height: widget.config.restingHeight,
                  child: Row(
                    children: [
                      Expanded(child: widget.restingContent),
                      IconButton(
                        icon: AnimatedRotation(
                          turns: expandRatio * 0.5,
                          duration: const Duration(milliseconds: 150),
                          child: const Icon(Icons.expand_more),
                        ),
                        tooltip: _isLatched ? 'Collapse' : 'Expand Drawer',
                        onPressed: toggleExpansion,
                      ),
                    ],
                  ),
                ),

                // Expanded Drawer Canvas
                if (_currentHeight > widget.config.restingHeight)
                  Positioned(
                    top: widget.config.restingHeight,
                    left: 0.0,
                    right: 0.0,
                    bottom: 0.0,
                    child: Opacity(
                      opacity: expandRatio,
                      child: OverflowBox(
                        minHeight: 0.0,
                        maxHeight: widget.config.maxDragExpandedHeight -
                            widget.config.restingHeight,
                        alignment: Alignment.topLeft,
                        child: widget.expandedCanvasContent,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
