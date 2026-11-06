import 'package:flutter/material.dart';
import '../widgets/sliver_widget_marker.dart';
import 'experience_configs.dart';

/// Style 44: Detached Damped Floating Island Header.
///
/// A decoupled, floating island header that hovers over scroll content with
/// rounded geometry, dynamic margins, and damped spring recoil physics.
class DetachedDampedIslandHeaderWidget extends StatelessWidget
    with SliverWidgetMarker {
  /// Creates a [DetachedDampedIslandHeaderWidget].
  const DetachedDampedIslandHeaderWidget({
    super.key,
    required this.child,
    this.compactChild,
    this.backgroundColor,
    this.safeArea = true,
    this.config = const DetachedDampedIslandConfig(),
  });

  /// The primary content inside the floating island in expanded state.
  final Widget child;

  /// Optional compact content displayed when settled in compact state.
  final Widget? compactChild;

  /// Island background fill color.
  final Color? backgroundColor;

  /// Whether to respect status bar top insets.
  final bool safeArea;

  /// Floating island geometry and spring physics configuration.
  final DetachedDampedIslandConfig config;

  @override
  Widget build(BuildContext context) {
    final topPadding = safeArea ? MediaQuery.paddingOf(context).top : 0.0;
    final totalExpanded = config.expandedHeight + topPadding + 16.0;
    final totalCollapsed = config.collapsedHeight + topPadding + 8.0;

    return SliverPersistentHeader(
      pinned: true,
      delegate: _FloatingIslandDelegate(
        child: child,
        compactChild: compactChild,
        backgroundColor: backgroundColor ?? Theme.of(context).colorScheme.surfaceContainerHighest,
        topPadding: topPadding,
        totalExpanded: totalExpanded,
        totalCollapsed: totalCollapsed,
        config: config,
      ),
    );
  }
}

class _FloatingIslandDelegate extends SliverPersistentHeaderDelegate {
  _FloatingIslandDelegate({
    required this.child,
    required this.compactChild,
    required this.backgroundColor,
    required this.topPadding,
    required this.totalExpanded,
    required this.totalCollapsed,
    required this.config,
  });

  final Widget child;
  final Widget? compactChild;
  final Color backgroundColor;
  final double topPadding;
  final double totalExpanded;
  final double totalCollapsed;
  final DetachedDampedIslandConfig config;

  @override
  double get minExtent => totalCollapsed;

  @override
  double get maxExtent => totalExpanded;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    final isReducedMotion = MediaQuery.disableAnimationsOf(context);
    final progress = ((shrinkOffset) / (totalExpanded - totalCollapsed)).clamp(0.0, 1.0);

    final currentMargin = isReducedMotion
        ? config.expandedHorizontalMargin
        : (config.expandedHorizontalMargin +
            (config.collapsedHorizontalMargin - config.expandedHorizontalMargin) * progress);

    final currentRadius = isReducedMotion
        ? config.expandedBorderRadius
        : (config.expandedBorderRadius +
            (config.collapsedBorderRadius - config.expandedBorderRadius) * progress);

    final currentHeight = (totalExpanded - shrinkOffset).clamp(totalCollapsed, totalExpanded) - topPadding - 8.0;

    return Padding(
      padding: EdgeInsets.only(top: topPadding + 4.0),
      child: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: currentMargin),
          child: Material(
            elevation: config.islandElevation,
            color: backgroundColor,
            borderRadius: BorderRadius.circular(currentRadius),
            clipBehavior: Clip.antiAlias,
            child: SizedBox(
              height: currentHeight.clamp(config.collapsedHeight, config.expandedHeight),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: progress > 0.6 && compactChild != null
                    ? KeyedSubtree(
                        key: const ValueKey('compact'),
                        child: Center(child: compactChild!),
                      )
                    : KeyedSubtree(
                        key: const ValueKey('expanded'),
                        child: OverflowBox(
                          minHeight: 0.0,
                          maxHeight: config.expandedHeight + config.maxOverscrollStretch,
                          alignment: Alignment.center,
                          child: child,
                        ),
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(covariant _FloatingIslandDelegate oldDelegate) {
    return oldDelegate.totalExpanded != totalExpanded ||
        oldDelegate.totalCollapsed != totalCollapsed ||
        oldDelegate.backgroundColor != backgroundColor;
  }
}
