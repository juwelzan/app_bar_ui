import 'package:flutter/material.dart';
import '../../../widgets/sliver_widget_marker.dart';
import 'card_deck_stacked_config.dart';

/// Model 10: Card Deck Stacked Navigation Header.
///
/// Physical stacked card deck fanning out vertically in expanded resting state,
/// and tucking sequentially under the active card to snap into a consolidated
/// compact toolbar on scroll.
class CardDeckStackedHeaderWidget extends StatelessWidget with SliverWidgetMarker {
  /// Creates a [CardDeckStackedHeaderWidget].
  const CardDeckStackedHeaderWidget({
    super.key,
    this.title,
    this.leading,
    this.actions,
    this.config = const CardDeckStackedConfig(),
  });

  /// Optional custom title override.
  final Widget? title;

  /// Optional custom leading widget.
  final Widget? leading;

  /// Optional trailing action widgets.
  final List<Widget>? actions;

  /// Strongly-typed configuration for this model.
  final CardDeckStackedConfig config;

  @override
  Widget build(BuildContext context) {
    final topPadding = config.safeArea ? MediaQuery.paddingOf(context).top : 0.0;
    final totalExpanded = config.expandedHeight + topPadding;
    final totalCollapsed = config.collapsedHeight + topPadding;

    return SliverPersistentHeader(
      pinned: true,
      delegate: _CardDeckStackedDelegate(
        title: title,
        leading: leading,
        actions: actions,
        config: config,
        topPadding: topPadding,
        totalExpanded: totalExpanded,
        totalCollapsed: totalCollapsed,
      ),
    );
  }
}

class _CardDeckStackedDelegate extends SliverPersistentHeaderDelegate {
  _CardDeckStackedDelegate({
    required this.title,
    required this.leading,
    required this.actions,
    required this.config,
    required this.topPadding,
    required this.totalExpanded,
    required this.totalCollapsed,
  });

  final Widget? title;
  final Widget? leading;
  final List<Widget>? actions;
  final CardDeckStackedConfig config;
  final double topPadding;
  final double totalExpanded;
  final double totalCollapsed;

  @override
  double get minExtent => totalCollapsed;

  @override
  double get maxExtent => totalExpanded;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    final theme = Theme.of(context);
    final isReducedMotion = MediaQuery.disableAnimationsOf(context);
    final collapseRange = totalExpanded - totalCollapsed;
    final progress = collapseRange > 0.0 ? (shrinkOffset / collapseRange).clamp(0.0, 1.0) : 0.0;

    final currentHeight = (totalExpanded - shrinkOffset).clamp(totalCollapsed, totalExpanded);
    final activeCard = config.cards.isNotEmpty
        ? config.cards[config.activeCardIndex.clamp(0, config.cards.length - 1)]
        : null;

    return Material(
      color: config.backgroundColor ?? theme.colorScheme.surface,
      elevation: overlapsContent || progress > 0.8 ? config.elevation : 0.0,
      surfaceTintColor: config.surfaceTint,
      child: SafeArea(
        top: false,
        bottom: false,
        child: Padding(
          padding: EdgeInsets.only(top: topPadding),
          child: SizedBox(
            height: currentHeight - topPadding,
            child: ClipRect(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // --- EXPANDED FANNED CARD DECK ---
                  if (progress < 0.9)
                    Opacity(
                      opacity: isReducedMotion
                          ? (progress > 0.5 ? 0.0 : 1.0)
                          : (1.0 - progress * 1.3).clamp(0.0, 1.0),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Top Deck Toolbar Title Row
                            Row(
                              children: [
                                if (leading != null) ...[
                                  leading!,
                                  const SizedBox(width: 8.0),
                                ],
                                Expanded(
                                  child: Text(
                                    config.deckTitle,
                                    style: theme.textTheme.titleMedium!.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
                                  decoration: BoxDecoration(
                                    color: theme.colorScheme.primaryContainer,
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  child: Text(
                                    '${config.cards.length} Cards',
                                    style: TextStyle(
                                      fontSize: 10.0,
                                      fontWeight: FontWeight.bold,
                                      color: theme.colorScheme.onPrimaryContainer,
                                    ),
                                  ),
                                ),
                                ...?actions,
                              ],
                            ),
                            const SizedBox(height: 8.0),

                            // Fanned Overlapping Card Stack
                            Expanded(
                              child: Stack(
                                children: List.generate(config.cards.length, (index) {
                                  // Reverse rendering order so top card is painted on top
                                  final reverseIdx = config.cards.length - 1 - index;
                                  final card = config.cards[reverseIdx];
                                  final fanStep = (1.0 - progress);
                                  final topOffset = reverseIdx * config.cardOverlap * fanStep;
                                  final scale = 1.0 - (reverseIdx * 0.04 * fanStep);

                                  return Positioned(
                                    left: 0.0,
                                    right: 0.0,
                                    top: topOffset,
                                    child: Transform.scale(
                                      scale: scale,
                                      alignment: Alignment.topCenter,
                                      child: Card(
                                        elevation: config.cardElevation,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(config.cardBorderRadius),
                                        ),
                                        color: card.backgroundColor ?? theme.colorScheme.surfaceContainerHighest,
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                                          child: Row(
                                            children: [
                                              if (card.icon != null) ...[
                                                Icon(
                                                  card.icon,
                                                  size: 28.0,
                                                  color: card.foregroundColor ?? theme.colorScheme.onSurface,
                                                ),
                                                const SizedBox(width: 12.0),
                                              ],
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    Text(
                                                      card.title,
                                                      style: TextStyle(
                                                        fontSize: 14.0,
                                                        fontWeight: FontWeight.bold,
                                                        color: card.foregroundColor ?? theme.colorScheme.onSurface,
                                                      ),
                                                      maxLines: 1,
                                                      overflow: TextOverflow.ellipsis,
                                                    ),
                                                    if (card.subtitle != null) ...[
                                                      const SizedBox(height: 2.0),
                                                      Text(
                                                        card.subtitle!,
                                                        style: TextStyle(
                                                          fontSize: 11.0,
                                                          color: (card.foregroundColor ?? theme.colorScheme.onSurface)
                                                              .withValues(alpha: 0.8),
                                                        ),
                                                        maxLines: 1,
                                                        overflow: TextOverflow.ellipsis,
                                                      ),
                                                    ],
                                                  ],
                                                ),
                                              ),
                                              if (card.badge != null)
                                                Container(
                                                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 3.0),
                                                  decoration: BoxDecoration(
                                                    color: Colors.white24,
                                                    borderRadius: BorderRadius.circular(8.0),
                                                  ),
                                                  child: Text(
                                                    card.badge!,
                                                    style: const TextStyle(
                                                      fontSize: 10.0,
                                                      fontWeight: FontWeight.bold,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                  // --- COLLAPSED CONSOLIDATED PINNED TOOLBAR ---
                  if (progress > 0.4)
                    Positioned(
                      left: 0.0,
                      right: 0.0,
                      top: 0.0,
                      height: config.collapsedHeight,
                      child: Opacity(
                        opacity: isReducedMotion
                            ? (progress > 0.5 ? 1.0 : 0.0)
                            : ((progress - 0.4) / 0.6).clamp(0.0, 1.0),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Row(
                            children: [
                              if (leading != null) ...[
                                leading!,
                                const SizedBox(width: 8.0),
                              ] else if (activeCard?.icon != null) ...[
                                Icon(activeCard!.icon, size: 22.0, color: theme.colorScheme.primary),
                                const SizedBox(width: 8.0),
                              ],
                              Expanded(
                                child: title ??
                                    Text(
                                      activeCard != null ? activeCard.title : config.deckTitle,
                                      style: theme.textTheme.titleMedium!.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                              ),
                              if (activeCard?.badge != null)
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 2.0),
                                  decoration: BoxDecoration(
                                    color: theme.colorScheme.primaryContainer,
                                    borderRadius: BorderRadius.circular(6.0),
                                  ),
                                  child: Text(
                                    activeCard!.badge!,
                                    style: TextStyle(
                                      fontSize: 9.0,
                                      fontWeight: FontWeight.bold,
                                      color: theme.colorScheme.onPrimaryContainer,
                                    ),
                                  ),
                                ),
                              ...?actions,
                            ],
                          ),
                        ),
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
  bool shouldRebuild(covariant _CardDeckStackedDelegate oldDelegate) {
    return oldDelegate.totalExpanded != totalExpanded ||
        oldDelegate.totalCollapsed != totalCollapsed ||
        oldDelegate.config != config ||
        oldDelegate.title != title ||
        oldDelegate.actions != actions ||
        oldDelegate.leading != leading ||
        oldDelegate.topPadding != topPadding;
  }
}

