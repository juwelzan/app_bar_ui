import 'package:flutter/material.dart';
import '../widgets/sliver_widget_marker.dart';
import 'experience_configs.dart';

/// Navigation item model for [SliverToRailTransformHeaderWidget].
class RailNavigationItem {
  /// Creates a [RailNavigationItem].
  const RailNavigationItem({
    required this.icon,
    required this.label,
    this.badgeCount,
  });

  /// Primary icon.
  final IconData icon;

  /// Text title label.
  final String label;

  /// Optional notification badge count.
  final int? badgeCount;
}

/// Style 48: Sliver-to-Rail Transform Header.
///
/// An adaptive header toolbar that transforms from an expansive horizontal top
/// bar with rich category chips/labels into a condensed, compact icon rail strip
/// as the user scrolls into the pinned navigation state.
class SliverToRailTransformHeaderWidget extends StatelessWidget
    with SliverWidgetMarker {
  /// Creates a [SliverToRailTransformHeaderWidget].
  const SliverToRailTransformHeaderWidget({
    super.key,
    required this.title,
    this.items = const [
      RailNavigationItem(icon: Icons.dashboard_outlined, label: 'Overview'),
      RailNavigationItem(icon: Icons.analytics_outlined, label: 'Metrics'),
      RailNavigationItem(icon: Icons.folder_open_outlined, label: 'Assets'),
      RailNavigationItem(icon: Icons.tune_outlined, label: 'Settings'),
    ],
    this.selectedIndex = 0,
    this.onItemSelected,
    this.leading,
    this.actions,
    this.backgroundColor,
    this.safeArea = true,
    this.config = const SliverToRailTransformConfig(),
  });

  /// The main header title widget.
  final Widget title;

  /// List of navigation items that compress into rail icons.
  final List<RailNavigationItem> items;

  /// The currently active selected item index.
  final int selectedIndex;

  /// Callback when a navigation item is tapped.
  final ValueChanged<int>? onItemSelected;

  /// Optional leading navigation control.
  final Widget? leading;

  /// Optional trailing action widgets.
  final List<Widget>? actions;

  /// Header canvas background color.
  final Color? backgroundColor;

  /// Whether to respect status bar safe area.
  final bool safeArea;

  /// Rail transformation physics and geometry configuration.
  final SliverToRailTransformConfig config;

  @override
  Widget build(BuildContext context) {
    final topPadding = safeArea ? MediaQuery.paddingOf(context).top : 0.0;
    final totalExpanded = config.expandedHeight + topPadding;
    final totalCollapsed = config.collapsedHeight + topPadding;

    return SliverPersistentHeader(
      pinned: true,
      delegate: _SliverToRailDelegate(
        title: title,
        items: items,
        selectedIndex: selectedIndex,
        onItemSelected: onItemSelected,
        leading: leading,
        actions: actions,
        backgroundColor: backgroundColor ?? Theme.of(context).colorScheme.surface,
        topPadding: topPadding,
        totalExpanded: totalExpanded,
        totalCollapsed: totalCollapsed,
        config: config,
      ),
    );
  }
}

class _SliverToRailDelegate extends SliverPersistentHeaderDelegate {
  _SliverToRailDelegate({
    required this.title,
    required this.items,
    required this.selectedIndex,
    required this.onItemSelected,
    required this.leading,
    required this.actions,
    required this.backgroundColor,
    required this.topPadding,
    required this.totalExpanded,
    required this.totalCollapsed,
    required this.config,
  });

  final Widget title;
  final List<RailNavigationItem> items;
  final int selectedIndex;
  final ValueChanged<int>? onItemSelected;
  final Widget? leading;
  final List<Widget>? actions;
  final Color backgroundColor;
  final double topPadding;
  final double totalExpanded;
  final double totalCollapsed;
  final SliverToRailTransformConfig config;

  @override
  double get minExtent => totalCollapsed;

  @override
  double get maxExtent => totalExpanded;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    final isReducedMotion = MediaQuery.disableAnimationsOf(context);
    final theme = Theme.of(context);
    final progress = ((shrinkOffset) / (totalExpanded - totalCollapsed)).clamp(0.0, 1.0);

    return Container(
      color: backgroundColor,
      child: SafeArea(
        top: false,
        bottom: false,
        child: Padding(
          padding: EdgeInsets.only(top: topPadding),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Top Bar with Title and Actions
              Positioned(
                top: 0.0,
                left: 0.0,
                right: 0.0,
                height: config.collapsedHeight,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    children: [
                      if (leading != null) ...[
                        leading!,
                        const SizedBox(width: 8.0),
                      ],
                      Expanded(
                        child: DefaultTextStyle(
                          style: theme.textTheme.titleMedium!.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                          child: title,
                        ),
                      ),
                      ...?actions,
                    ],
                  ),
                ),
              ),

              // Horizontal Items in Expanded Canvas vs Condensed Rail in Collapsed Toolbar
              Positioned(
                bottom: 12.0,
                left: 16.0,
                right: 16.0,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(items.length, (index) {
                      final item = items[index];
                      final isSelected = index == selectedIndex;
                      final labelOpacity = isReducedMotion
                          ? (progress > 0.5 ? 0.0 : 1.0)
                          : (1.0 - progress * 2.0).clamp(0.0, 1.0);

                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: InkWell(
                          onTap: onItemSelected != null ? () => onItemSelected!(index) : null,
                          borderRadius: BorderRadius.circular(16.0),
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8.0 + (1.0 - progress) * 6.0,
                              vertical: 6.0,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? theme.colorScheme.primaryContainer
                                  : theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                              borderRadius: BorderRadius.circular(16.0),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  item.icon,
                                  size: 18.0,
                                  color: isSelected
                                      ? theme.colorScheme.primary
                                      : theme.colorScheme.onSurfaceVariant,
                                ),
                                if (labelOpacity > 0.05) ...[
                                  const SizedBox(width: 6.0),
                                  Opacity(
                                    opacity: labelOpacity,
                                    child: Text(
                                      item.label,
                                      style: TextStyle(
                                        fontSize: 12.0,
                                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                        color: isSelected
                                            ? theme.colorScheme.primary
                                            : theme.colorScheme.onSurfaceVariant,
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(covariant _SliverToRailDelegate oldDelegate) {
    return oldDelegate.totalExpanded != totalExpanded ||
        oldDelegate.totalCollapsed != totalCollapsed ||
        oldDelegate.title != title ||
        oldDelegate.items != items ||
        oldDelegate.selectedIndex != selectedIndex ||
        oldDelegate.leading != leading ||
        oldDelegate.actions != actions ||
        oldDelegate.backgroundColor != backgroundColor ||
        oldDelegate.topPadding != topPadding ||
        oldDelegate.config != config;
  }
}
