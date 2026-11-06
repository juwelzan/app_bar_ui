import 'package:flutter/material.dart';
import '../../../widgets/sliver_widget_marker.dart';
import 'vertical_rail_transform_config.dart';

/// Model 7: Vertical Rail Transformation Navigation Header.
///
/// An adaptive navigational header that transitions from an expansive hero tier
/// with destination chips into a compact pinned toolbar featuring an icon-rail
/// navigation strip.
class VerticalRailTransformHeaderWidget extends StatelessWidget with SliverWidgetMarker {
  /// Creates a [VerticalRailTransformHeaderWidget].
  const VerticalRailTransformHeaderWidget({
    super.key,
    this.title,
    this.leading,
    this.actions,
    this.config = const VerticalRailTransformConfig(),
  });

  /// Optional custom title override.
  final Widget? title;

  /// Optional custom leading widget.
  final Widget? leading;

  /// Optional trailing action widgets.
  final List<Widget>? actions;

  /// Strongly-typed configuration for this model.
  final VerticalRailTransformConfig config;

  @override
  Widget build(BuildContext context) {
    final topPadding = config.safeArea ? MediaQuery.paddingOf(context).top : 0.0;
    final totalExpanded = config.expandedHeight + topPadding;
    final totalCollapsed = config.collapsedHeight + topPadding;

    return SliverPersistentHeader(
      pinned: true,
      delegate: _VerticalRailTransformDelegate(
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

class _VerticalRailTransformDelegate extends SliverPersistentHeaderDelegate {
  _VerticalRailTransformDelegate({
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
  final VerticalRailTransformConfig config;
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
                children: [
                  // --- EXPANDED HERO & CHIP STRIP ---
                  if (progress < 0.85)
                    Positioned(
                      left: 16.0,
                      right: 16.0,
                      top: 8.0,
                      child: Opacity(
                        opacity: isReducedMotion
                            ? (progress > 0.5 ? 0.0 : 1.0)
                            : (1.0 - progress * 1.3).clamp(0.0, 1.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Tier 1: Identity & Avatar
                            Row(
                              children: [
                                if (leading != null) ...[
                                  leading!,
                                  const SizedBox(width: 8.0),
                                ],
                                if (config.avatar != null) ...[
                                  config.avatar!,
                                  const SizedBox(width: 10.0),
                                ],
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        config.expandedTitle,
                                        style: theme.textTheme.titleMedium!.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      if (config.expandedSubtitle != null)
                                        Text(
                                          config.expandedSubtitle!,
                                          style: theme.textTheme.bodySmall!.copyWith(
                                            color: theme.colorScheme.onSurfaceVariant,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                    ],
                                  ),
                                ),
                                ...?actions,
                              ],
                            ),
                            const SizedBox(height: 12.0),

                            // Tier 2: Destination Navigation Chips
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: List.generate(config.destinations.length, (index) {
                                  final dest = config.destinations[index];
                                  final isSelected = index == config.selectedIndex;
                                  return Padding(
                                    padding: const EdgeInsets.only(right: 8.0),
                                    child: ChoiceChip(
                                      label: Text(dest.label),
                                      avatar: Icon(
                                        isSelected && dest.selectedIcon != null
                                            ? dest.selectedIcon
                                            : dest.icon,
                                        size: 16.0,
                                      ),
                                      selected: isSelected,
                                      onSelected: (selected) {
                                        if (selected) {
                                          config.onDestinationSelected?.call(index);
                                        }
                                      },
                                    ),
                                  );
                                }),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                  // --- COLLAPSED COMPACT PINNED RAIL TOOLBAR ---
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
                              ],
                              Expanded(
                                flex: 4,
                                child: title ??
                                    Text(
                                      config.expandedTitle,
                                      style: theme.textTheme.titleMedium!.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                              ),
                              const SizedBox(width: 8.0),
                              // Condensed Icon Rail Strip
                              Flexible(
                                flex: 6,
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: List.generate(config.destinations.length, (index) {
                                      final dest = config.destinations[index];
                                      final isSelected = index == config.selectedIndex;
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 2.0),
                                        child: IconButton(
                                          icon: Icon(
                                            isSelected && dest.selectedIcon != null
                                                ? dest.selectedIcon
                                                : dest.icon,
                                            size: 20.0,
                                            color: isSelected
                                                ? theme.colorScheme.primary
                                                : theme.colorScheme.onSurfaceVariant,
                                          ),
                                          style: isSelected
                                              ? IconButton.styleFrom(
                                                  backgroundColor: theme.colorScheme.primaryContainer,
                                                )
                                              : null,
                                          onPressed: () => config.onDestinationSelected?.call(index),
                                          tooltip: dest.label,
                                        ),
                                      );
                                    }),
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
  bool shouldRebuild(covariant _VerticalRailTransformDelegate oldDelegate) {
    return oldDelegate.totalExpanded != totalExpanded ||
        oldDelegate.totalCollapsed != totalCollapsed ||
        oldDelegate.config != config ||
        oldDelegate.title != title ||
        oldDelegate.actions != actions ||
        oldDelegate.leading != leading ||
        oldDelegate.topPadding != topPadding;
  }
}

