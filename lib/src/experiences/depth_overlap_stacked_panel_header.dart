import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'experience_configs.dart';

/// Representation of a single panel card in [DepthOverlapStackedPanelHeaderWidget].
class StackedPanelCardItem {
  /// Creates a [StackedPanelCardItem].
  const StackedPanelCardItem({
    required this.title,
    required this.content,
    this.leadingIcon,
    this.color,
  });

  /// Card header title.
  final Widget title;

  /// Card body content.
  final Widget content;

  /// Optional leading icon.
  final IconData? leadingIcon;

  /// Optional card background color.
  final Color? color;
}

/// Style 40: Depth Overlap Stacked Panel Header.
///
/// Features three card panels stacked with optical z-axis depth overlap. As the user
/// scrolls, the cards slide forward sequentially—the foreground panel docks cleanly into
/// the top navigation slot while background cards step forward with perspective scale
/// and shadow elevation changes.
class DepthOverlapStackedPanelHeaderWidget extends StatelessWidget {
  /// Creates a [DepthOverlapStackedPanelHeaderWidget].
  const DepthOverlapStackedPanelHeaderWidget({
    super.key,
    required this.cards,
    this.actions,
    this.backgroundColor,
    this.safeArea = true,
    this.config = const DepthOverlapStackedPanelConfig(),
  });

  /// The 3 stacked panel card items (ordered front to back).
  final List<StackedPanelCardItem> cards;

  /// Optional trailing action widgets.
  final List<Widget>? actions;

  /// Header canvas background color.
  final Color? backgroundColor;

  /// Whether to respect top SafeArea.
  final bool safeArea;

  /// Stacked panel configuration.
  final DepthOverlapStackedPanelConfig config;

  @override
  Widget build(BuildContext context) {
    final topPadding = safeArea ? MediaQuery.paddingOf(context).top : 0.0;
    final totalExpanded = config.expandedHeight + topPadding;
    final totalCollapsed = config.collapsedHeight + topPadding;

    return SliverPersistentHeader(
      pinned: true,
      delegate: _DepthOverlapStackedPanelDelegate(
        cards: cards,
        actions: actions,
        backgroundColor: backgroundColor ?? Theme.of(context).colorScheme.surface,
        topPadding: topPadding,
        totalExpanded: math.max(totalExpanded, totalCollapsed + 1.0),
        totalCollapsed: totalCollapsed,
        config: config,
      ),
    );
  }
}

class _DepthOverlapStackedPanelDelegate extends SliverPersistentHeaderDelegate {
  _DepthOverlapStackedPanelDelegate({
    required this.cards,
    required this.actions,
    required this.backgroundColor,
    required this.topPadding,
    required this.totalExpanded,
    required this.totalCollapsed,
    required this.config,
  });

  final List<StackedPanelCardItem> cards;
  final List<Widget>? actions;
  final Color backgroundColor;
  final double topPadding;
  final double totalExpanded;
  final double totalCollapsed;
  final DepthOverlapStackedPanelConfig config;

  @override
  double get minExtent => totalCollapsed;

  @override
  double get maxExtent => totalExpanded;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    final reducedMotion = MediaQuery.disableAnimationsOf(context);
    final delta = maxExtent - minExtent;
    final progress = delta > 0 ? (shrinkOffset / delta).clamp(0.0, 1.0) : 0.0;
    final curvedProgress = reducedMotion ? progress : config.curve.transform(progress);

    final width = MediaQuery.sizeOf(context).width;
    final safeWidth = width > 0 ? width : 360.0;
    final theme = Theme.of(context);

    final count = math.min(3, cards.length);
    final isCollapsed = curvedProgress > 0.75;

    return Material(
      elevation: isCollapsed ? 3.0 : 1.0,
      color: backgroundColor,
      child: ClipRect(
        child: OverflowBox(
          minWidth: 0.0,
          maxWidth: safeWidth,
          minHeight: 0.0,
          maxHeight: totalExpanded,
          alignment: Alignment.topLeft,
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Render cards in reverse order (Card 3 first, then Card 2, then Card 1 on top)
              for (int i = count - 1; i >= 0; i--) ...[
                _buildCardLayer(
                  index: i,
                  total: count,
                  safeWidth: safeWidth,
                  curvedProgress: curvedProgress,
                  reducedMotion: reducedMotion,
                  theme: theme,
                ),
              ],

              // Pinned Actions
              if (actions != null && actions!.isNotEmpty)
                Positioned(
                  right: 8.0,
                  top: topPadding + (totalCollapsed - topPadding - 48.0) / 2.0,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: actions!,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCardLayer({
    required int index,
    required int total,
    required double safeWidth,
    required double curvedProgress,
    required bool reducedMotion,
    required ThemeData theme,
  }) {
    final card = cards[index];

    // Resting stacked metrics
    final baseOffset = index * config.panelOverlap;
    final baseScale = 1.0 - (index * (1.0 - config.depthScaleFactor));
    final baseOpacity = (1.0 - (index * 0.15)).clamp(0.0, 1.0);

    // Dynamic sequence progression
    // As scroll increases, cards step forward: index 1 moves toward index 0 metrics
    final currentOffset = reducedMotion
        ? (curvedProgress > 0.5 ? 0.0 : baseOffset)
        : (baseOffset * (1.0 - curvedProgress));
    final currentScale = reducedMotion
        ? (curvedProgress > 0.5 ? 1.0 : baseScale)
        : (baseScale + (1.0 - baseScale) * curvedProgress);
    final currentOpacity = (index == 0)
        ? 1.0
        : (baseOpacity + (1.0 - baseOpacity) * curvedProgress);

    // Front card (index == 0) morphs into docked toolbar
    final isFront = index == 0;
    final cardMarginH = isFront ? (16.0 * (1.0 - curvedProgress)) : 16.0;
    final cardRadius = isFront ? (16.0 * (1.0 - curvedProgress)) : 14.0;
    final cardElevation = isFront ? (4.0 * (1.0 - curvedProgress) + 1.0) : 2.0;

    return Positioned(
      left: cardMarginH,
      right: cardMarginH,
      top: topPadding + 10.0 + currentOffset,
      child: Transform.scale(
        scale: currentScale,
        alignment: Alignment.topCenter,
        child: Opacity(
          opacity: currentOpacity.clamp(0.0, 1.0),
          child: Material(
            elevation: cardElevation,
            borderRadius: BorderRadius.circular(cardRadius),
            color: card.color ?? theme.colorScheme.surfaceContainerHighest,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 10.0),
              child: Row(
                children: [
                  if (card.leadingIcon != null) ...[
                    Icon(card.leadingIcon, size: 22.0, color: theme.colorScheme.primary),
                    const SizedBox(width: 10.0),
                  ],
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        DefaultTextStyle(
                          style: theme.textTheme.titleMedium!.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          child: card.title,
                        ),
                        if (!isFront || curvedProgress < 0.6)
                          Opacity(
                            opacity: isFront
                                ? (1.0 - (curvedProgress / 0.6)).clamp(0.0, 1.0)
                                : 1.0,
                            child: DefaultTextStyle(
                              style: theme.textTheme.bodySmall!,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              child: card.content,
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(covariant _DepthOverlapStackedPanelDelegate oldDelegate) {
    return cards != oldDelegate.cards ||
        actions != oldDelegate.actions ||
        backgroundColor != oldDelegate.backgroundColor ||
        topPadding != oldDelegate.topPadding ||
        totalExpanded != oldDelegate.totalExpanded ||
        totalCollapsed != oldDelegate.totalCollapsed ||
        config != oldDelegate.config;
  }
}
