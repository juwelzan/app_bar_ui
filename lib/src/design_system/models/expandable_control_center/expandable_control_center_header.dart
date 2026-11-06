import 'package:flutter/material.dart';
import '../../../widgets/sliver_widget_marker.dart';
import 'expandable_control_center_config.dart';

/// Model 13: Expandable Control Center Navigation Header.
///
/// Features a quick-settings control hub embedded into the header. At rest, displays
/// high-priority interactive quick-setting tiles (Wi-Fi, Bluetooth, VPN, Battery).
/// On upward scroll, tiles collapse into a sleek horizontal row of compact status icons
/// in the pinned toolbar.
class ExpandableControlCenterHeaderWidget extends StatelessWidget with SliverWidgetMarker {
  /// Creates an [ExpandableControlCenterHeaderWidget].
  const ExpandableControlCenterHeaderWidget({
    super.key,
    this.title,
    this.leading,
    this.actions,
    this.config = const ExpandableControlCenterConfig(),
  });

  /// Optional custom title override.
  final Widget? title;

  /// Optional custom leading widget.
  final Widget? leading;

  /// Optional trailing action widgets.
  final List<Widget>? actions;

  /// Strongly-typed configuration for this model.
  final ExpandableControlCenterConfig config;

  @override
  Widget build(BuildContext context) {
    final topPadding = config.safeArea ? MediaQuery.paddingOf(context).top : 0.0;
    final totalExpanded = config.expandedHeight + topPadding;
    final totalCollapsed = config.collapsedHeight + topPadding;

    return SliverPersistentHeader(
      pinned: true,
      delegate: _ExpandableControlCenterDelegate(
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

class _ExpandableControlCenterDelegate extends SliverPersistentHeaderDelegate {
  _ExpandableControlCenterDelegate({
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
  final ExpandableControlCenterConfig config;
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
    final activeColor = config.tileActiveColor ?? theme.colorScheme.primary;
    final inactiveColor = config.tileInactiveColor ?? theme.colorScheme.surfaceContainerHighest;

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
                  // --- EXPANDED CONTROL CENTER TILES ---
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
                            // Header Row: Title & quick metrics
                            Row(
                              children: [
                                if (leading != null) ...[
                                  leading!,
                                  const SizedBox(width: 8.0),
                                ],
                                Expanded(
                                  child: Text(
                                    config.hubTitle,
                                    style: theme.textTheme.titleMedium!.copyWith(
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: -0.3,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 3.0),
                                  decoration: BoxDecoration(
                                    color: activeColor.withValues(alpha: 0.12),
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.tune, size: 12.0, color: activeColor),
                                      const SizedBox(width: 4.0),
                                      Text(
                                        '${config.tiles.where((t) => t.isActive).length} Active',
                                        style: TextStyle(
                                          fontSize: 10.5,
                                          fontWeight: FontWeight.bold,
                                          color: activeColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                ...?actions,
                              ],
                            ),
                            const SizedBox(height: 10.0),

                            // Grid of Quick-Setting Interactive Tiles
                            Expanded(
                              child: LayoutBuilder(
                                builder: (context, constraints) {
                                  final crossCount = constraints.maxWidth > 500 ? 4 : 2;
                                  return GridView.builder(
                                    physics: const NeverScrollableScrollPhysics(),
                                    padding: EdgeInsets.zero,
                                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: crossCount,
                                      crossAxisSpacing: 8.0,
                                      mainAxisSpacing: 8.0,
                                      childAspectRatio: constraints.maxWidth > 500 ? 3.0 : 2.5,
                                    ),
                                    itemCount: config.tiles.length,
                                    itemBuilder: (context, idx) {
                                      final tile = config.tiles[idx];
                                      return InkWell(
                                        onTap: () {
                                          tile.onTap?.call();
                                          config.onTileToggled?.call(idx);
                                        },
                                        borderRadius: BorderRadius.circular(12.0),
                                        child: AnimatedContainer(
                                          duration: const Duration(milliseconds: 200),
                                          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
                                          decoration: BoxDecoration(
                                            color: tile.isActive ? activeColor.withValues(alpha: 0.15) : inactiveColor,
                                            borderRadius: BorderRadius.circular(12.0),
                                            border: Border.all(
                                              color: tile.isActive
                                                  ? activeColor.withValues(alpha: 0.5)
                                                  : theme.colorScheme.outlineVariant.withValues(alpha: 0.3),
                                            ),
                                          ),
                                          child: Row(
                                            children: [
                                              Container(
                                                padding: const EdgeInsets.all(6.0),
                                                decoration: BoxDecoration(
                                                  color: tile.isActive ? activeColor : inactiveColor,
                                                  shape: BoxShape.circle,
                                                ),
                                                child: Icon(
                                                  tile.icon,
                                                  size: 16.0,
                                                  color: tile.isActive
                                                      ? theme.colorScheme.onPrimary
                                                      : theme.colorScheme.onSurfaceVariant,
                                                ),
                                              ),
                                              const SizedBox(width: 8.0),
                                              Expanded(
                                                child: SingleChildScrollView(
                                                  physics: const NeverScrollableScrollPhysics(),
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: [
                                                      Text(
                                                        tile.title,
                                                        style: TextStyle(
                                                          fontSize: 12.0,
                                                          fontWeight: FontWeight.bold,
                                                          color: tile.isActive ? activeColor : theme.colorScheme.onSurface,
                                                        ),
                                                        maxLines: 1,
                                                        overflow: TextOverflow.ellipsis,
                                                      ),
                                                      if (tile.subtitle != null)
                                                        Text(
                                                          tile.subtitle!,
                                                          style: TextStyle(
                                                            fontSize: 10.0,
                                                            color: theme.colorScheme.onSurfaceVariant,
                                                          ),
                                                          maxLines: 1,
                                                          overflow: TextOverflow.ellipsis,
                                                        ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                  // --- COLLAPSED COMPACT PINNED STATUS BAR ---
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
                                child: title ??
                                    Text(
                                      config.hubTitle,
                                      style: theme.textTheme.titleMedium!.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                              ),

                              // Compact collapsed status icons row for active tiles
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: config.tiles.where((t) => t.isActive).map((tile) {
                                  return Padding(
                                    padding: const EdgeInsets.only(left: 6.0),
                                    child: Container(
                                      padding: const EdgeInsets.all(4.0),
                                      decoration: BoxDecoration(
                                        color: activeColor.withValues(alpha: 0.15),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        tile.icon,
                                        size: 14.0,
                                        color: activeColor,
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                              const SizedBox(width: 8.0),
                              IconButton(
                                icon: const Icon(Icons.tune, size: 20.0),
                                onPressed: () {},
                                tooltip: 'Expand Controls',
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
  bool shouldRebuild(covariant _ExpandableControlCenterDelegate oldDelegate) {
    return oldDelegate.totalExpanded != totalExpanded ||
        oldDelegate.totalCollapsed != totalCollapsed ||
        oldDelegate.config != config ||
        oldDelegate.title != title ||
        oldDelegate.actions != actions ||
        oldDelegate.leading != leading ||
        oldDelegate.topPadding != topPadding;
  }
}

