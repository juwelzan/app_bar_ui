import 'package:flutter/material.dart';
import 'experience_configs.dart';

/// Data model representing a tab item within [TabTransformHeaderWidget].
class TabTransformItem {
  /// Creates a [TabTransformItem].
  const TabTransformItem({
    required this.label,
    this.icon,
    this.subtitle,
    this.badge,
  });

  /// Primary label of the tab.
  final String label;

  /// Optional leading icon.
  final IconData? icon;

  /// Optional secondary subtitle description displayed only in expanded state.
  final String? subtitle;

  /// Optional notification badge count or text.
  final String? badge;
}

/// Style 21: Animated Tab-Transform Header.
///
/// Full-sized tab cards with rich icons, subtitles, and badges smoothly
/// compress into a slim pinned horizontal navigation tab strip on scroll.
class TabTransformHeaderWidget extends StatelessWidget {
  /// Creates a [TabTransformHeaderWidget].
  const TabTransformHeaderWidget({
    super.key,
    required this.tabs,
    required this.selectedIndex,
    required this.onTabSelected,
    this.title,
    this.actions,
    this.backgroundColor,
    this.safeArea = true,
    this.config = const TabTransformConfig(),
  });

  /// List of tab items.
  final List<TabTransformItem> tabs;

  /// Currently selected tab index.
  final int selectedIndex;

  /// Callback when a tab is tapped.
  final ValueChanged<int> onTabSelected;

  /// Optional branding title widget.
  final Widget? title;

  /// Optional trailing action widgets.
  final List<Widget>? actions;

  /// Header background color.
  final Color? backgroundColor;

  /// Whether to respect top SafeArea padding.
  final bool safeArea;

  /// Tab transformation configuration.
  final TabTransformConfig config;

  @override
  Widget build(BuildContext context) {
    final topPadding = safeArea ? MediaQuery.paddingOf(context).top : 0.0;
    final totalExpanded = config.expandedHeight + topPadding;
    final totalCollapsed = config.collapsedHeight + topPadding;

    return SliverPersistentHeader(
      pinned: true,
      delegate: _TabTransformDelegate(
        tabs: tabs,
        selectedIndex: selectedIndex,
        onTabSelected: onTabSelected,
        title: title,
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

class _TabTransformDelegate extends SliverPersistentHeaderDelegate {
  _TabTransformDelegate({
    required this.tabs,
    required this.selectedIndex,
    required this.onTabSelected,
    required this.title,
    required this.actions,
    required this.backgroundColor,
    required this.topPadding,
    required this.totalExpanded,
    required this.totalCollapsed,
    required this.config,
  });

  final List<TabTransformItem> tabs;
  final int selectedIndex;
  final ValueChanged<int> onTabSelected;
  final Widget? title;
  final List<Widget>? actions;
  final Color? backgroundColor;
  final double topPadding;
  final double totalExpanded;
  final double totalCollapsed;
  final TabTransformConfig config;

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

    final rawProgress =
        (shrinkOffset / config.collapseThreshold).clamp(0.0, 1.0);
    final curve = config.resolveCurve(context);
    final progress = curve.transform(rawProgress);

    final resolvedBg = backgroundColor ?? theme.colorScheme.surface;
    final titleOpacity = (1.0 - progress * 1.5).clamp(0.0, 1.0);
    final currentTabHeight = isReducedMotion
        ? (progress > 0.5 ? config.compactTabHeight : config.expandedTabHeight)
        : (config.expandedTabHeight -
            (config.expandedTabHeight - config.compactTabHeight) * progress);

    return SizedBox.expand(
      child: Material(
        elevation: shrinkOffset > 5.0 ? config.elevation : 0.0,
        color: resolvedBg,
        child: ClipRect(
          child: Padding(
            padding: EdgeInsets.only(top: topPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Title & Actions Row (Collapses away)
                if (titleOpacity > 0.01)
                  Expanded(
                    child: Opacity(
                      opacity: titleOpacity,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Row(
                          children: [
                            if (title != null)
                              Expanded(
                                child: DefaultTextStyle(
                                  style: theme.textTheme.titleMedium!.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  child: title!,
                                ),
                              ),
                            ...?actions,
                          ],
                        ),
                      ),
                    ),
                  ),

                // Transforming Tab Strip
                SizedBox(
                  height: currentTabHeight,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        for (int i = 0; i < tabs.length; i++)
                          _buildTabItem(context, i, progress, isReducedMotion),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 6.0),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTabItem(
    BuildContext context,
    int index,
    double progress,
    bool isReducedMotion,
  ) {
    final theme = Theme.of(context);
    final item = tabs[index];
    final isSelected = index == selectedIndex;

    final selectedBg = theme.colorScheme.primaryContainer;
    final unselectedBg = theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5);

    final showSubtitle = progress < 0.4 && item.subtitle != null && !isReducedMotion;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: InkWell(
        onTap: () => onTabSelected(index),
        borderRadius: BorderRadius.circular(progress > 0.5 ? 20.0 : 12.0),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: EdgeInsets.symmetric(
            horizontal: progress > 0.5 ? 12.0 : 16.0,
            vertical: progress > 0.5 ? 6.0 : 8.0,
          ),
          decoration: BoxDecoration(
            color: isSelected ? selectedBg : unselectedBg,
            borderRadius: BorderRadius.circular(progress > 0.5 ? 20.0 : 12.0),
            border: isSelected
                ? Border.all(color: theme.colorScheme.primary, width: 1.5)
                : null,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (item.icon != null) ...[
                Icon(
                  item.icon,
                  size: progress > 0.5 ? 16.0 : 20.0,
                  color: isSelected
                      ? theme.colorScheme.primary
                      : theme.colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 6.0),
              ],
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    item.label,
                    style: TextStyle(
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                      fontSize: progress > 0.5 ? 12.0 : 13.0,
                      color: isSelected
                          ? theme.colorScheme.onPrimaryContainer
                          : theme.colorScheme.onSurface,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (showSubtitle) ...[
                    const SizedBox(height: 2.0),
                    Text(
                      item.subtitle!,
                      style: theme.textTheme.bodySmall!.copyWith(
                        fontSize: 10.0,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
              if (item.badge != null) ...[
                const SizedBox(width: 6.0),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 1.5),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Text(
                    item.badge!,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(covariant _TabTransformDelegate oldDelegate) {
    return oldDelegate.tabs != tabs ||
        oldDelegate.selectedIndex != selectedIndex ||
        oldDelegate.onTabSelected != onTabSelected ||
        oldDelegate.title != title ||
        oldDelegate.actions != actions ||
        oldDelegate.backgroundColor != backgroundColor ||
        oldDelegate.topPadding != topPadding ||
        oldDelegate.totalExpanded != totalExpanded ||
        oldDelegate.totalCollapsed != totalCollapsed ||
        oldDelegate.config != config;
  }
}
