import 'package:flutter/material.dart';
import 'experience_configs.dart';

/// Data model representing a single breadcrumb node in [BreadcrumbTransformHeaderWidget].
class BreadcrumbNode {
  /// Creates a [BreadcrumbNode].
  const BreadcrumbNode({
    required this.label,
    this.icon,
  });

  /// Breadcrumb label.
  final String label;

  /// Optional leading icon.
  final IconData? icon;
}

/// Style 26: Animated Breadcrumb Transformation Header.
///
/// Multi-level breadcrumbs progressively collapse intermediate parent items into a
/// condensed ellipsis pill on scroll, preserving the root and current leaf node
/// in a slim pinned toolbar.
class BreadcrumbTransformHeaderWidget extends StatelessWidget {
  /// Creates a [BreadcrumbTransformHeaderWidget].
  const BreadcrumbTransformHeaderWidget({
    super.key,
    required this.items,
    required this.onNodeSelected,
    this.title,
    this.actions,
    this.backgroundColor,
    this.safeArea = true,
    this.config = const BreadcrumbTransformConfig(),
  });

  /// Ordered breadcrumb nodes from root to leaf.
  final List<BreadcrumbNode> items;

  /// Callback when a breadcrumb node is tapped.
  final ValueChanged<int> onNodeSelected;

  /// Optional page title.
  final Widget? title;

  /// Optional trailing action widgets.
  final List<Widget>? actions;

  /// Header background color.
  final Color? backgroundColor;

  /// Whether to respect top SafeArea padding.
  final bool safeArea;

  /// Breadcrumb transformation configuration.
  final BreadcrumbTransformConfig config;

  @override
  Widget build(BuildContext context) {
    final topPadding = safeArea ? MediaQuery.paddingOf(context).top : 0.0;
    final totalExpanded = config.expandedHeight + topPadding;
    final totalCollapsed = config.collapsedHeight + topPadding;

    return SliverPersistentHeader(
      pinned: true,
      delegate: _BreadcrumbTransformDelegate(
        items: items,
        onNodeSelected: onNodeSelected,
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

class _BreadcrumbTransformDelegate extends SliverPersistentHeaderDelegate {
  _BreadcrumbTransformDelegate({
    required this.items,
    required this.onNodeSelected,
    required this.title,
    required this.actions,
    required this.backgroundColor,
    required this.topPadding,
    required this.totalExpanded,
    required this.totalCollapsed,
    required this.config,
  });

  final List<BreadcrumbNode> items;
  final ValueChanged<int> onNodeSelected;
  final Widget? title;
  final List<Widget>? actions;
  final Color? backgroundColor;
  final double topPadding;
  final double totalExpanded;
  final double totalCollapsed;
  final BreadcrumbTransformConfig config;

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

                // Transforming Breadcrumb Strip
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: _buildBreadcrumbItems(context, progress, isReducedMotion),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildBreadcrumbItems(
    BuildContext context,
    double progress,
    bool isReducedMotion,
  ) {
    final theme = Theme.of(context);
    final widgets = <Widget>[];

    if (items.isEmpty) return widgets;

    // In fully collapsed state, if items.length > 2:
    // show Root (0) -> "..." -> Leaf (items.length - 1)
    final shouldCollapseIntermediate =
        isReducedMotion ? (progress > 0.5) : (progress > 0.45);

    for (int i = 0; i < items.length; i++) {
      final isRoot = i == 0;
      final isLeaf = i == items.length - 1;
      final isIntermediate = !isRoot && !isLeaf;

      if (isIntermediate && shouldCollapseIntermediate) {
        // Only emit ellipsis once for intermediate group
        if (i == 1) {
          widgets.add(
            PopupMenuButton<int>(
              tooltip: 'Show parent path',
              onSelected: onNodeSelected,
              itemBuilder: (context) {
                return [
                  for (int j = 1; j < items.length - 1; j++)
                    PopupMenuItem(
                      value: j,
                      child: Text(items[j].label),
                    ),
                ];
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: const Text('...', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
          );
          widgets.add(
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.0),
              child: Icon(Icons.chevron_right, size: 16.0, color: Colors.grey),
            ),
          );
        }
        continue;
      }

      // Normal breadcrumb item
      widgets.add(
        InkWell(
          onTap: () => onNodeSelected(i),
          borderRadius: BorderRadius.circular(8.0),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 2.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (items[i].icon != null) ...[
                  Icon(
                    items[i].icon,
                    size: 16.0,
                    color: isLeaf ? theme.colorScheme.primary : theme.colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 4.0),
                ],
                Text(
                  items[i].label,
                  style: TextStyle(
                    fontWeight: isLeaf ? FontWeight.bold : FontWeight.normal,
                    color: isLeaf ? theme.colorScheme.primary : theme.colorScheme.onSurface,
                    fontSize: 13.0,
                  ),
                ),
              ],
            ),
          ),
        ),
      );

      // Separator
      if (!isLeaf) {
        widgets.add(
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 2.0),
            child: Icon(Icons.chevron_right, size: 16.0, color: Colors.grey),
          ),
        );
      }
    }

    return widgets;
  }

  @override
  bool shouldRebuild(covariant _BreadcrumbTransformDelegate oldDelegate) {
    return oldDelegate.items != items ||
        oldDelegate.onNodeSelected != onNodeSelected ||
        oldDelegate.title != title ||
        oldDelegate.actions != actions ||
        oldDelegate.backgroundColor != backgroundColor ||
        oldDelegate.topPadding != topPadding ||
        oldDelegate.totalExpanded != totalExpanded ||
        oldDelegate.totalCollapsed != totalCollapsed ||
        oldDelegate.config != config;
  }
}

