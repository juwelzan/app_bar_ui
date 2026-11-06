import 'package:flutter/material.dart';
import 'experience_configs.dart';

/// Style 18: Magnetic Scroll-Snap Header
///
/// Header that applies magnetic physical snapping when scroll gestures end
/// in proximity of discrete resting bounds, locking seamlessly into expanded or collapsed states.
class MagneticScrollSnapHeaderWidget extends StatelessWidget {
  /// Creates a [MagneticScrollSnapHeaderWidget].
  const MagneticScrollSnapHeaderWidget({
    super.key,
    required this.expandedContent,
    required this.collapsedContent,
    this.backgroundColor,
    this.config = const MagneticScrollSnapConfig(),
    this.safeArea = true,
  });

  /// Widget displayed in the expanded resting state.
  final Widget expandedContent;

  /// Widget displayed in the collapsed docked state.
  final Widget collapsedContent;

  /// Background color of the header canvas.
  final Color? backgroundColor;

  /// Snap geometry and spring configuration.
  final MagneticScrollSnapConfig config;

  /// Whether to incorporate safe area top insets.
  final bool safeArea;

  @override
  Widget build(BuildContext context) {
    final topPadding = safeArea ? MediaQuery.paddingOf(context).top : 0.0;
    final totalExpanded = config.expandedHeight + topPadding;
    final totalCollapsed = config.collapsedHeight + topPadding;

    return SliverPersistentHeader(
      pinned: true,
      delegate: _MagneticScrollSnapDelegate(
        expandedContent: expandedContent,
        collapsedContent: collapsedContent,
        backgroundColor: backgroundColor,
        topPadding: topPadding,
        totalExpanded: totalExpanded,
        totalCollapsed: totalCollapsed,
        config: config,
      ),
    );
  }
}

class _MagneticScrollSnapDelegate extends SliverPersistentHeaderDelegate {
  _MagneticScrollSnapDelegate({
    required this.expandedContent,
    required this.collapsedContent,
    required this.backgroundColor,
    required this.topPadding,
    required this.totalExpanded,
    required this.totalCollapsed,
    required this.config,
  });

  final Widget expandedContent;
  final Widget collapsedContent;
  final Color? backgroundColor;
  final double topPadding;
  final double totalExpanded;
  final double totalCollapsed;
  final MagneticScrollSnapConfig config;

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
    final delta = maxExtent - minExtent;
    final rawRatio = delta > 0 ? (shrinkOffset / delta).clamp(0.0, 1.0) : 0.0;
    final curve = config.resolveCurve(context);
    final t = curve.transform(rawRatio);

    final resolvedBgColor = backgroundColor ?? theme.colorScheme.surface;

    // Cross-fade between expanded presentation and compact collapsed state
    final expandedOpacity = (1.0 - t * 1.3).clamp(0.0, 1.0);
    final collapsedOpacity = ((t - 0.25) / 0.75).clamp(0.0, 1.0);

    return SizedBox.expand(
      child: Material(
        elevation: shrinkOffset > 5.0 ? config.elevation : 0.0,
        color: resolvedBgColor,
        child: ClipRect(
          child: Padding(
            padding: EdgeInsets.only(top: topPadding),
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Expanded Content
                if (expandedOpacity > 0.01)
                  Positioned.fill(
                    child: Opacity(
                      opacity: expandedOpacity,
                      child: expandedContent,
                    ),
                  ),

                // Collapsed Compact Content
                if (collapsedOpacity > 0.01)
                  Positioned(
                    top: 0.0,
                    left: 0.0,
                    right: 0.0,
                    height: config.collapsedHeight,
                    child: Opacity(
                      opacity: collapsedOpacity,
                      child: collapsedContent,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(covariant _MagneticScrollSnapDelegate oldDelegate) {
    return oldDelegate.expandedContent != expandedContent ||
        oldDelegate.collapsedContent != collapsedContent ||
        oldDelegate.backgroundColor != backgroundColor ||
        oldDelegate.topPadding != topPadding ||
        oldDelegate.totalExpanded != totalExpanded ||
        oldDelegate.totalCollapsed != totalCollapsed ||
        oldDelegate.config != config;
  }
}
