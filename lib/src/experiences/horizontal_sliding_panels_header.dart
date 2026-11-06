import 'package:flutter/material.dart';
import 'experience_configs.dart';

/// Style 6: Horizontal Sliding Multi-Panel Header
///
/// Header composed of multiple horizontal panels that slide out laterally
/// at differential velocities upon scrolling, leaving a streamlined pinned toolbar.
class HorizontalSlidingPanelsHeaderWidget extends StatelessWidget {
  /// Creates a [HorizontalSlidingPanelsHeaderWidget].
  const HorizontalSlidingPanelsHeaderWidget({
    super.key,
    required this.pinnedBar,
    required this.slidingPanelLeft,
    this.slidingPanelRight,
    this.backgroundColor,
    this.config = const HorizontalSlidingPanelsConfig(),
    this.safeArea = true,
  });

  /// The persistent primary toolbar that remains visible when collapsed.
  final Widget pinnedBar;

  /// Secondary panel that slides horizontally to the left during scroll.
  final Widget slidingPanelLeft;

  /// Optional tertiary panel that slides horizontally to the right during scroll.
  final Widget? slidingPanelRight;

  /// Background color of the header canvas.
  final Color? backgroundColor;

  /// Motion and layout configuration.
  final HorizontalSlidingPanelsConfig config;

  /// Whether to incorporate safe area top insets.
  final bool safeArea;

  @override
  Widget build(BuildContext context) {
    final topPadding = safeArea ? MediaQuery.paddingOf(context).top : 0.0;
    final totalExpanded = config.expandedHeight + topPadding;
    final totalCollapsed = config.collapsedHeight + topPadding;

    return SliverPersistentHeader(
      pinned: true,
      delegate: _HorizontalSlidingPanelsDelegate(
        pinnedBar: pinnedBar,
        slidingPanelLeft: slidingPanelLeft,
        slidingPanelRight: slidingPanelRight,
        backgroundColor: backgroundColor,
        topPadding: topPadding,
        totalExpanded: totalExpanded,
        totalCollapsed: totalCollapsed,
        config: config,
      ),
    );
  }
}

class _HorizontalSlidingPanelsDelegate extends SliverPersistentHeaderDelegate {
  _HorizontalSlidingPanelsDelegate({
    required this.pinnedBar,
    required this.slidingPanelLeft,
    required this.slidingPanelRight,
    required this.backgroundColor,
    required this.topPadding,
    required this.totalExpanded,
    required this.totalCollapsed,
    required this.config,
  });

  final Widget pinnedBar;
  final Widget slidingPanelLeft;
  final Widget? slidingPanelRight;
  final Color? backgroundColor;
  final double topPadding;
  final double totalExpanded;
  final double totalCollapsed;
  final HorizontalSlidingPanelsConfig config;

  @override
  double get minExtent => totalCollapsed;

  @override
  double get maxExtent => totalExpanded;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    final theme = Theme.of(context);
    final isReducedMotion = MediaQuery.disableAnimationsOf(context);
    final delta = (maxExtent - minExtent);
    final rawProgress = delta > 0 ? (shrinkOffset / delta).clamp(0.0, 1.0) : 0.0;
    final curve = config.resolveCurve(context);
    final progress = curve.transform(rawProgress);

    // Compute differential slide translations and opacities
    final panelOpacity = ((1.0 - (rawProgress / config.fadeThreshold))).clamp(0.0, 1.0);
    final leftTranslation = isReducedMotion
        ? 0.0
        : -config.panel1SlideDistance * progress;
    final rightTranslation = isReducedMotion
        ? 0.0
        : config.panel2SlideDistance * progress;

    final bgColor = backgroundColor ?? theme.colorScheme.surface;

    return SizedBox.expand(
      child: Material(
        elevation: rawProgress > 0.1 ? config.elevation : 0.0,
        color: bgColor,
        child: ClipRect(
          child: Padding(
            padding: EdgeInsets.only(top: topPadding),
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Top pinned primary toolbar
                Positioned(
                  top: 0.0,
                  left: 0.0,
                  right: 0.0,
                  height: config.collapsedHeight,
                  child: pinnedBar,
                ),

                // Sliding secondary panels (visible when expanded or partially collapsed)
                if (panelOpacity > 0.001) ...[
                  // Sliding Panel 1 (slides left)
                  Positioned(
                    top: config.collapsedHeight,
                    left: 0.0,
                    right: 0.0,
                    child: Opacity(
                      opacity: panelOpacity,
                      child: Transform.translate(
                        offset: Offset(leftTranslation, 0.0),
                        child: slidingPanelLeft,
                      ),
                    ),
                  ),

                  // Sliding Panel 2 (slides right)
                  if (slidingPanelRight != null)
                    Positioned(
                      top: config.collapsedHeight + 42.0,
                      left: 0.0,
                      right: 0.0,
                      child: Opacity(
                        opacity: panelOpacity,
                        child: Transform.translate(
                          offset: Offset(rightTranslation, 0.0),
                          child: slidingPanelRight!,
                        ),
                      ),
                    ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(covariant _HorizontalSlidingPanelsDelegate oldDelegate) {
    return oldDelegate.pinnedBar != pinnedBar ||
        oldDelegate.slidingPanelLeft != slidingPanelLeft ||
        oldDelegate.slidingPanelRight != slidingPanelRight ||
        oldDelegate.backgroundColor != backgroundColor ||
        oldDelegate.topPadding != topPadding ||
        oldDelegate.totalExpanded != totalExpanded ||
        oldDelegate.totalCollapsed != totalCollapsed ||
        oldDelegate.config != config;
  }
}

