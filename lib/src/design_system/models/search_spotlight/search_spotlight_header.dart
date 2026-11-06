import 'package:flutter/material.dart';
import '../../../widgets/sliver_widget_marker.dart';
import 'search_spotlight_config.dart';

/// Model 15: Search Spotlight First Navigation Header.
///
/// Embodies a search-first user journey. At rest, renders an expansive search input
/// canvas with suggested query pills and category filter chips. On scroll, morphs
/// into a compact inline query bar with quick search icon and clear actions.
class SearchSpotlightHeaderWidget extends StatelessWidget with SliverWidgetMarker {
  /// Creates a [SearchSpotlightHeaderWidget].
  const SearchSpotlightHeaderWidget({
    super.key,
    this.title,
    this.leading,
    this.actions,
    this.config = const SearchSpotlightConfig(),
  });

  /// Optional custom title override.
  final Widget? title;

  /// Optional custom leading widget.
  final Widget? leading;

  /// Optional trailing action widgets.
  final List<Widget>? actions;

  /// Strongly-typed configuration for this model.
  final SearchSpotlightConfig config;

  @override
  Widget build(BuildContext context) {
    final topPadding = config.safeArea ? MediaQuery.paddingOf(context).top : 0.0;
    final totalExpanded = config.expandedHeight + topPadding;
    final totalCollapsed = config.collapsedHeight + topPadding;

    return SliverPersistentHeader(
      pinned: true,
      delegate: _SearchSpotlightDelegate(
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

class _SearchSpotlightDelegate extends SliverPersistentHeaderDelegate {
  _SearchSpotlightDelegate({
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
  final SearchSpotlightConfig config;
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
                  // --- EXPANDED SEARCH SPOTLIGHT CANVAS ---
                  if (progress < 0.88)
                    Opacity(
                      opacity: isReducedMotion
                          ? (progress > 0.5 ? 0.0 : 1.0)
                          : (1.0 - progress * 1.3).clamp(0.0, 1.0),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Top leading / actions row
                            Row(
                              children: [
                                if (leading != null) ...[
                                  leading!,
                                  const SizedBox(width: 8.0),
                                ],
                                Expanded(
                                  child: Text(
                                    'Spotlight Search',
                                    style: theme.textTheme.titleMedium!.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                ...?actions,
                              ],
                            ),
                            const SizedBox(height: 10.0),

                            // Expansive Search Input Field Box
                            Container(
                              height: 44.0,
                              padding: const EdgeInsets.symmetric(horizontal: 12.0),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.surfaceContainerHighest,
                                borderRadius: BorderRadius.circular(12.0),
                                border: Border.all(
                                  color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(Icons.search, size: 20.0, color: theme.colorScheme.primary),
                                  const SizedBox(width: 10.0),
                                  Expanded(
                                    child: Text(
                                      config.initialQuery.isNotEmpty
                                          ? config.initialQuery
                                          : config.searchPrompt,
                                      style: TextStyle(
                                        fontSize: 13.0,
                                        color: config.initialQuery.isNotEmpty
                                            ? theme.colorScheme.onSurface
                                            : theme.colorScheme.onSurfaceVariant,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  if (config.initialQuery.isNotEmpty)
                                    Icon(Icons.clear, size: 18.0, color: theme.colorScheme.outline),
                                ],
                              ),
                            ),
                            const SizedBox(height: 10.0),

                            // Suggested Query Pills & Filters Row
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  for (int i = 0; i < config.filterChips.length; i++) ...[
                                    Padding(
                                      padding: const EdgeInsets.only(right: 6.0),
                                      child: InkWell(
                                        onTap: () => config.onFilterSelected?.call(i),
                                        borderRadius: BorderRadius.circular(8.0),
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
                                          decoration: BoxDecoration(
                                            color: i == config.selectedFilterIndex
                                                ? theme.colorScheme.primary
                                                : theme.colorScheme.surfaceContainerHigh,
                                            borderRadius: BorderRadius.circular(8.0),
                                          ),
                                          child: Text(
                                            config.filterChips[i],
                                            style: TextStyle(
                                              fontSize: 11.0,
                                              fontWeight: FontWeight.bold,
                                              color: i == config.selectedFilterIndex
                                                  ? theme.colorScheme.onPrimary
                                                  : theme.colorScheme.onSurfaceVariant,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                  const SizedBox(width: 4.0),
                                  for (final pill in config.suggestedPills) ...[
                                    Padding(
                                      padding: const EdgeInsets.only(right: 6.0),
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                                        decoration: BoxDecoration(
                                          color: theme.colorScheme.surfaceContainerLow,
                                          borderRadius: BorderRadius.circular(8.0),
                                          border: Border.all(
                                            color: theme.colorScheme.outlineVariant.withValues(alpha: 0.4),
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(Icons.history, size: 12.0, color: theme.colorScheme.outline),
                                            const SizedBox(width: 4.0),
                                            Text(
                                              pill,
                                              style: TextStyle(
                                                fontSize: 10.5,
                                                color: theme.colorScheme.onSurfaceVariant,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                  // --- COLLAPSED COMPACT PINNED QUERY BAR ---
                  if (progress > 0.35)
                    Positioned(
                      left: 0.0,
                      right: 0.0,
                      top: 0.0,
                      height: config.collapsedHeight,
                      child: Opacity(
                        opacity: isReducedMotion
                            ? (progress > 0.5 ? 1.0 : 0.0)
                            : ((progress - 0.35) / 0.65).clamp(0.0, 1.0),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Row(
                            children: [
                              if (leading != null) ...[
                                leading!,
                                const SizedBox(width: 8.0),
                              ],
                              Expanded(
                                child: Container(
                                  height: 38.0,
                                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                                  decoration: BoxDecoration(
                                    color: theme.colorScheme.surfaceContainerHighest,
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(Icons.search, size: 18.0, color: theme.colorScheme.primary),
                                      const SizedBox(width: 8.0),
                                      Expanded(
                                        child: Text(
                                          config.initialQuery.isNotEmpty
                                              ? config.initialQuery
                                              : config.searchPrompt,
                                          style: TextStyle(
                                            fontSize: 12.0,
                                            color: config.initialQuery.isNotEmpty
                                                ? theme.colorScheme.onSurface
                                                : theme.colorScheme.onSurfaceVariant,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8.0),
                              IconButton(
                                icon: const Icon(Icons.filter_list, size: 20.0),
                                onPressed: () {},
                                tooltip: 'Filter Options',
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
  bool shouldRebuild(covariant _SearchSpotlightDelegate oldDelegate) {
    return oldDelegate.totalExpanded != totalExpanded ||
        oldDelegate.totalCollapsed != totalCollapsed ||
        oldDelegate.config != config ||
        oldDelegate.title != title ||
        oldDelegate.actions != actions ||
        oldDelegate.leading != leading ||
        oldDelegate.topPadding != topPadding;
  }
}
