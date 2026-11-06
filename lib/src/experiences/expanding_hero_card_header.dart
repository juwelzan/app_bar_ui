import 'package:flutter/material.dart';
import 'experience_configs.dart';

/// Style 9: Expanding Hero Card Header
///
/// Header that begins as a floating inset hero card with rounded corners and margins,
/// and dynamically expands edge-to-edge into a full-bleed docked toolbar as scroll begins.
class ExpandingHeroCardHeaderWidget extends StatelessWidget {
  /// Creates an [ExpandingHeroCardHeaderWidget].
  const ExpandingHeroCardHeaderWidget({
    super.key,
    required this.heroCardContent,
    required this.dockedToolbarContent,
    this.cardColor,
    this.backgroundColor,
    this.config = const ExpandingHeroCardConfig(),
    this.safeArea = true,
  });

  /// The rich presentation content displayed inside the floating card.
  final Widget heroCardContent;

  /// The streamlined navigation content displayed when docked edge-to-edge.
  final Widget dockedToolbarContent;

  /// Color of the hero card container.
  final Color? cardColor;

  /// Color of the underlying scaffolding behind the card.
  final Color? backgroundColor;

  /// Geometry and transition configuration.
  final ExpandingHeroCardConfig config;

  /// Whether to incorporate safe area top insets.
  final bool safeArea;

  @override
  Widget build(BuildContext context) {
    final topPadding = safeArea ? MediaQuery.paddingOf(context).top : 0.0;
    final totalExpanded = config.expandedHeight + topPadding;
    final totalCollapsed = config.collapsedHeight + topPadding;

    return SliverPersistentHeader(
      pinned: true,
      delegate: _ExpandingHeroCardDelegate(
        heroCardContent: heroCardContent,
        dockedToolbarContent: dockedToolbarContent,
        cardColor: cardColor,
        backgroundColor: backgroundColor,
        topPadding: topPadding,
        totalExpanded: totalExpanded,
        totalCollapsed: totalCollapsed,
        config: config,
      ),
    );
  }
}

class _ExpandingHeroCardDelegate
    extends SliverPersistentHeaderDelegate {
  _ExpandingHeroCardDelegate({
    required this.heroCardContent,
    required this.dockedToolbarContent,
    required this.cardColor,
    required this.backgroundColor,
    required this.topPadding,
    required this.totalExpanded,
    required this.totalCollapsed,
    required this.config,
  });

  final Widget heroCardContent;
  final Widget dockedToolbarContent;
  final Color? cardColor;
  final Color? backgroundColor;
  final double topPadding;
  final double totalExpanded;
  final double totalCollapsed;
  final ExpandingHeroCardConfig config;

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

    // Stage 1: Card expansion from inset to full-bleed (0.0 -> expandThreshold)
    final expandProgress =
        (shrinkOffset / config.expandThreshold).clamp(0.0, 1.0);
    final curve = config.resolveCurve(context);
    final tExpand = curve.transform(expandProgress);

    // Stage 2: Total height collapse (0.0 -> maxExtent - minExtent)
    final delta = maxExtent - minExtent;
    final totalProgress =
        delta > 0 ? (shrinkOffset / delta).clamp(0.0, 1.0) : 0.0;

    // Margins and border radius collapse to zero as card expands full-bleed
    final currentHMargin =
        isReducedMotion ? 0.0 : config.cardHorizontalMargin * (1.0 - tExpand);
    final currentVMargin =
        isReducedMotion ? 0.0 : config.cardVerticalMargin * (1.0 - tExpand);
    final currentRadius =
        isReducedMotion ? 0.0 : config.cardBorderRadius * (1.0 - tExpand);
    final currentElevation =
        expandProgress >= 1.0 ? config.dockElevation : config.cardElevation;

    final resolvedCardColor = cardColor ?? theme.colorScheme.primaryContainer;
    final resolvedBgColor = backgroundColor ?? theme.colorScheme.surface;

    // Cross-fade between hero presentation and compact toolbar
    final heroOpacity = (1.0 - (totalProgress * 1.5)).clamp(0.0, 1.0);
    final dockedOpacity = ((totalProgress - 0.4) / 0.6).clamp(0.0, 1.0);

    return SizedBox.expand(
      child: Container(
        color: resolvedBgColor,
        padding: EdgeInsets.only(
          top: topPadding + currentVMargin,
          bottom: currentVMargin,
          left: currentHMargin,
          right: currentHMargin,
        ),
        child: Material(
          elevation: currentElevation,
          borderRadius: BorderRadius.circular(currentRadius),
          color: resolvedCardColor,
          clipBehavior: Clip.antiAlias,
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Hero card rich presentation
              if (heroOpacity > 0.01)
                Opacity(
                  opacity: heroOpacity,
                  child: heroCardContent,
                ),

              // Docked compact navigation toolbar
              if (dockedOpacity > 0.01)
                Positioned(
                  top: 0.0,
                  left: 0.0,
                  right: 0.0,
                  height: config.collapsedHeight,
                  child: Opacity(
                    opacity: dockedOpacity,
                    child: dockedToolbarContent,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(covariant _ExpandingHeroCardDelegate oldDelegate) {
    return oldDelegate.heroCardContent != heroCardContent ||
        oldDelegate.dockedToolbarContent != dockedToolbarContent ||
        oldDelegate.cardColor != cardColor ||
        oldDelegate.backgroundColor != backgroundColor ||
        oldDelegate.topPadding != topPadding ||
        oldDelegate.totalExpanded != totalExpanded ||
        oldDelegate.totalCollapsed != totalCollapsed ||
        oldDelegate.config != config;
  }
}

