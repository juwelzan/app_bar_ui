import 'package:flutter/material.dart';
import 'experience_configs.dart';

/// Style 23: Progressive Disclosure Header.
///
/// A stepwise header that progressively reveals deeper utility tiers as the user
/// scrolls: Title/Branding -> Search Bar disclosure -> Sticky Pinned Filter Strip.
class ProgressiveDisclosureHeaderWidget extends StatelessWidget {
  /// Creates a [ProgressiveDisclosureHeaderWidget].
  const ProgressiveDisclosureHeaderWidget({
    super.key,
    required this.title,
    required this.searchBar,
    required this.filterRow,
    this.actions,
    this.backgroundColor,
    this.safeArea = true,
    this.config = const ProgressiveDisclosureConfig(),
  });

  /// Primary branding / title widget.
  final Widget title;

  /// Disclosed search input widget (Tier 2).
  final Widget searchBar;

  /// Disclosed filter chips strip (Tier 3).
  final Widget filterRow;

  /// Optional trailing action buttons.
  final List<Widget>? actions;

  /// Header background color.
  final Color? backgroundColor;

  /// Whether to respect top SafeArea padding.
  final bool safeArea;

  /// Progressive disclosure configuration.
  final ProgressiveDisclosureConfig config;

  @override
  Widget build(BuildContext context) {
    final topPadding = safeArea ? MediaQuery.paddingOf(context).top : 0.0;
    final totalExpanded = config.expandedHeight + topPadding;
    final totalCollapsed = config.collapsedHeight + topPadding;

    return SliverPersistentHeader(
      pinned: true,
      delegate: _ProgressiveDisclosureDelegate(
        title: title,
        searchBar: searchBar,
        filterRow: filterRow,
        actions: actions,
        backgroundColor: backgroundColor,
        topPadding: topPadding,
        totalExpanded: totalExpanded,
        totalCollapsed: totalCollapsed,
        config: config,
      ),
    );
  }
}

class _ProgressiveDisclosureDelegate extends SliverPersistentHeaderDelegate {
  _ProgressiveDisclosureDelegate({
    required this.title,
    required this.searchBar,
    required this.filterRow,
    required this.actions,
    required this.backgroundColor,
    required this.topPadding,
    required this.totalExpanded,
    required this.totalCollapsed,
    required this.config,
  });

  final Widget title;
  final Widget searchBar;
  final Widget filterRow;
  final List<Widget>? actions;
  final Color? backgroundColor;
  final double topPadding;
  final double totalExpanded;
  final double totalCollapsed;
  final ProgressiveDisclosureConfig config;

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

    // Stage 1 Progress: Title compress [0 -> stage1Threshold]
    final s1Raw = (shrinkOffset / config.stage1Threshold).clamp(0.0, 1.0);
    // Stage 2 Progress: Search reveal [stage1Threshold -> stage2Threshold]
    final s2Raw = ((shrinkOffset - config.stage1Threshold) /
            (config.stage2Threshold - config.stage1Threshold))
        .clamp(0.0, 1.0);
    // Stage 3 Progress: Filter strip reveal & pin [>= stage2Threshold]
    final s3Raw = (shrinkOffset >= config.stage2Threshold) ? 1.0 : s2Raw;

    final curve = config.resolveCurve(context);
    final t1 = curve.transform(s1Raw);
    final t2 = curve.transform(s2Raw);

    final resolvedBg = backgroundColor ?? theme.colorScheme.surface;

    // Stage 1 Title opacity and scale
    final titleOpacity = (1.0 - t1 * 1.2).clamp(0.0, 1.0);

    // Stage 2 Search slide offset
    final searchSlide = isReducedMotion ? 0.0 : (1.0 - t2) * 16.0;

    return SizedBox.expand(
      child: Material(
        elevation: shrinkOffset > 5.0 ? config.elevation : 0.0,
        color: resolvedBg,
        child: ClipRect(
          child: Padding(
            padding: EdgeInsets.only(top: topPadding),
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Top Action Buttons
                Positioned(
                  top: 6.0,
                  right: 12.0,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ...?actions,
                    ],
                  ),
                ),

                // Stage 1: Brand Title & Welcome Header
                if (titleOpacity > 0.01)
                  Positioned(
                    top: 14.0,
                    left: 20.0,
                    right: 80.0,
                    child: Opacity(
                      opacity: titleOpacity,
                      child: DefaultTextStyle(
                        style: theme.textTheme.headlineSmall!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        child: title,
                      ),
                    ),
                  ),

                // Stage 2: Disclosed Search Bar Capsule
                Positioned(
                  top: isReducedMotion
                      ? (shrinkOffset > config.stage1Threshold ? 8.0 : 54.0)
                      : (54.0 - (54.0 - 8.0) * t1),
                  left: 16.0,
                  right: 16.0,
                  child: Transform.translate(
                    offset: Offset(0.0, searchSlide),
                    child: searchBar,
                  ),
                ),

                // Stage 3: Sticky Pinned Filter Row
                if (shrinkOffset >= config.stage1Threshold * 0.8)
                  Positioned(
                    bottom: 4.0,
                    left: 0.0,
                    right: 0.0,
                    height: 44.0,
                    child: Opacity(
                      opacity: isReducedMotion ? (s3Raw > 0.5 ? 1.0 : 0.0) : t2,
                      child: filterRow,
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
  bool shouldRebuild(covariant _ProgressiveDisclosureDelegate oldDelegate) {
    return oldDelegate.title != title ||
        oldDelegate.searchBar != searchBar ||
        oldDelegate.filterRow != filterRow ||
        oldDelegate.actions != actions ||
        oldDelegate.backgroundColor != backgroundColor ||
        oldDelegate.topPadding != topPadding ||
        oldDelegate.totalExpanded != totalExpanded ||
        oldDelegate.totalCollapsed != totalCollapsed ||
        oldDelegate.config != config;
  }
}
