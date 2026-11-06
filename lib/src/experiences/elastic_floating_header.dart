import 'package:flutter/material.dart';

import '../motion/spring_coordinator.dart';
import 'experience_configs.dart';

/// Style 2: Elastic Floating Header
///
/// Floating header that responds elastically to pull gestures with damped spring resistance,
/// and compresses into a floating capsule upon forward scrolling.
class ElasticFloatingHeaderWidget extends StatefulWidget {
  /// Creates an [ElasticFloatingHeaderWidget].
  const ElasticFloatingHeaderWidget({
    super.key,
    required this.child,
    this.compactChild,
    this.backgroundColor,
    this.config = const ElasticFloatingConfig(),
    this.safeArea = true,
  });

  /// Primary content displayed in expanded state.
  final Widget child;

  /// Optional compact content displayed when settled into compact capsule.
  final Widget? compactChild;

  /// Background color of the floating card.
  final Color? backgroundColor;

  /// Elastic motion and geometry configuration.
  final ElasticFloatingConfig config;

  /// Whether to respect status bar top insets.
  final bool safeArea;

  @override
  State<ElasticFloatingHeaderWidget> createState() =>
      _ElasticFloatingHeaderWidgetState();
}

class _ElasticFloatingHeaderWidgetState
    extends State<ElasticFloatingHeaderWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _springController;
  double _overscrollDisplacement = 0.0;
  double _scrollOffset = 0.0;

  @override
  void initState() {
    super.initState();
    _springController = AnimationController.unbounded(vsync: this)
      ..addListener(() {
        setState(() {
          _overscrollDisplacement = _springController.value;
        });
      });
  }

  @override
  void dispose() {
    _springController.dispose();
    super.dispose();
  }

  /// Updates the header state based on scroll metrics.
  void updateScrollMetrics({
    required double scrollOffset,
    required double overscrollDelta,
  }) {
    if (overscrollDelta != 0.0) {
      final raw = _overscrollDisplacement + overscrollDelta;
      _overscrollDisplacement = ElasticSpringCoordinator.computeElasticResistance(
        rawDisplacement: raw,
        maxStretch: widget.config.maxOverscrollStretch,
      );
      setState(() {});
    } else if (scrollOffset != _scrollOffset) {
      setState(() {
        _scrollOffset = scrollOffset;
      });
    }
  }

  /// Triggers a spring recoil when a pull gesture is released.
  void settleElasticSpring([double velocity = 0.0]) {
    if (_overscrollDisplacement > 0.0) {
      final sim = ElasticSpringCoordinator.createSettleSimulation(
        startDisplacement: _overscrollDisplacement,
        initialVelocity: velocity,
      );
      _springController.animateWith(sim);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isReducedMotion = MediaQuery.disableAnimationsOf(context);
    final topPadding = widget.safeArea ? MediaQuery.paddingOf(context).top : 0.0;

    // Compact ratio based on scroll-down offset [0.0 -> 80.0]
    final compactRatio = (_scrollOffset / 80.0).clamp(0.0, 1.0);
    final currentHeight = isReducedMotion
        ? (compactRatio > 0.5 ? widget.config.compactHeight : widget.config.height)
        : (widget.config.height -
            (widget.config.height - widget.config.compactHeight) * compactRatio +
            _overscrollDisplacement);

    final currentRadius = isReducedMotion
        ? widget.config.borderRadius
        : (widget.config.borderRadius +
            (widget.config.compactBorderRadius - widget.config.borderRadius) *
                compactRatio);

    final currentElevation = compactRatio > 0.5
        ? widget.config.compactElevation
        : widget.config.restingElevation;

    return Padding(
      padding: EdgeInsets.only(
        top: topPadding + widget.config.verticalMargin,
        left: widget.config.horizontalMargin,
        right: widget.config.horizontalMargin,
        bottom: widget.config.verticalMargin,
      ),
      child: Material(
        elevation: currentElevation,
        borderRadius: BorderRadius.circular(currentRadius),
        color: widget.backgroundColor ?? theme.colorScheme.surface,
        clipBehavior: Clip.antiAlias,
        child: SizedBox(
          height: currentHeight,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: compactRatio > 0.6 && widget.compactChild != null
                ? KeyedSubtree(
                    key: const ValueKey('compact'),
                    child: widget.compactChild!,
                  )
                : KeyedSubtree(
                    key: const ValueKey('expanded'),
                    child: widget.child,
                  ),
          ),
        ),
      ),
    );
  }
}

