import 'package:flutter/material.dart';
import 'experience_configs.dart';

/// Style 13: Sticky-Collapse Dual-Tier Header
///
/// Multi-tiered header where Tier 1 (branding/identity) collapses out of view
/// upon scrolling, while Tier 2 (navigation/search/tabs) locks permanently sticky.
class StickyCollapseDualTierHeaderWidget extends StatelessWidget {
  /// Creates a [StickyCollapseDualTierHeaderWidget].
  const StickyCollapseDualTierHeaderWidget({
    super.key,
    required this.tier1Content,
    required this.tier2Content,
    this.backgroundColor,
    this.config = const StickyCollapseDualTierConfig(),
    this.safeArea = true,
  });

  /// The upper branding/identity tier that collapses out of view.
  final Widget tier1Content;

  /// The lower functional navigation/search tier that remains permanently sticky.
  final Widget tier2Content;

  /// Background color of the header.
  final Color? backgroundColor;

  /// Geometry and collapse configuration.
  final StickyCollapseDualTierConfig config;

  /// Whether to incorporate safe area top insets.
  final bool safeArea;

  @override
  Widget build(BuildContext context) {
    final topPadding = safeArea ? MediaQuery.paddingOf(context).top : 0.0;
    final totalExpanded = config.tier1Height + config.tier2Height + topPadding;
    final totalCollapsed = config.tier2Height + topPadding;

    return SliverPersistentHeader(
      pinned: true,
      delegate: _StickyCollapseDualTierDelegate(
        tier1Content: tier1Content,
        tier2Content: tier2Content,
        backgroundColor: backgroundColor,
        topPadding: topPadding,
        totalExpanded: totalExpanded,
        totalCollapsed: totalCollapsed,
        config: config,
      ),
    );
  }
}

class _StickyCollapseDualTierDelegate
    extends SliverPersistentHeaderDelegate {
  _StickyCollapseDualTierDelegate({
    required this.tier1Content,
    required this.tier2Content,
    required this.backgroundColor,
    required this.topPadding,
    required this.totalExpanded,
    required this.totalCollapsed,
    required this.config,
  });

  final Widget tier1Content;
  final Widget tier2Content;
  final Color? backgroundColor;
  final double topPadding;
  final double totalExpanded;
  final double totalCollapsed;
  final StickyCollapseDualTierConfig config;

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

    // Progress of Tier 1 collapse (0.0 -> 1.0)
    final collapseProgress =
        (shrinkOffset / config.collapseThreshold).clamp(0.0, 1.0);
    final curve = config.resolveCurve(context);
    final t = curve.transform(collapseProgress);

    // Tier 1 vertical translation (slides up underneath status bar / top padding)
    final tier1Offset = isReducedMotion ? 0.0 : -config.tier1Height * t;
    final tier1Opacity = (1.0 - t).clamp(0.0, 1.0);

    final resolvedBgColor = backgroundColor ?? theme.colorScheme.surface;

    return SizedBox.expand(
      child: Material(
        elevation: collapseProgress >= 0.9 ? config.elevation : 0.0,
        color: resolvedBgColor,
        child: ClipRect(
          child: Padding(
            padding: EdgeInsets.only(top: topPadding),
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Tier 1: Collapsing Branding / Identity tier
                if (tier1Opacity > 0.01)
                  Positioned(
                    top: 0.0,
                    left: 0.0,
                    right: 0.0,
                    height: config.tier1Height,
                    child: Opacity(
                      opacity: tier1Opacity,
                      child: Transform.translate(
                        offset: Offset(0.0, tier1Offset),
                        child: tier1Content,
                      ),
                    ),
                  ),

                // Tier 2: Sticky Pinned Secondary Toolbar (Navigation/Search/Tabs)
                Positioned(
                  top: config.tier1Height * (1.0 - t),
                  left: 0.0,
                  right: 0.0,
                  height: config.tier2Height,
                  child: tier2Content,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(covariant _StickyCollapseDualTierDelegate oldDelegate) {
    return oldDelegate.tier1Content != tier1Content ||
        oldDelegate.tier2Content != tier2Content ||
        oldDelegate.backgroundColor != backgroundColor ||
        oldDelegate.topPadding != topPadding ||
        oldDelegate.totalExpanded != totalExpanded ||
        oldDelegate.totalCollapsed != totalCollapsed ||
        oldDelegate.config != config;
  }
}

