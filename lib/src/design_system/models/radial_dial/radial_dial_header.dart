import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../widgets/sliver_widget_marker.dart';
import 'radial_dial_config.dart';

/// Model 8: Radial Polar Dial Navigation Header.
///
/// Distributes navigation nodes along a polar arc around a central hub.
/// On scroll, the arc contracts inward and collapses into a compact pinned toolbar.
class RadialDialHeaderWidget extends StatelessWidget with SliverWidgetMarker {
  /// Creates a [RadialDialHeaderWidget].
  const RadialDialHeaderWidget({
    super.key,
    this.title,
    this.leading,
    this.actions,
    this.config = const RadialDialConfig(),
  });

  /// Optional custom title override.
  final Widget? title;

  /// Optional custom leading widget.
  final Widget? leading;

  /// Optional trailing action widgets.
  final List<Widget>? actions;

  /// Strongly-typed configuration for this model.
  final RadialDialConfig config;

  @override
  Widget build(BuildContext context) {
    final topPadding = config.safeArea ? MediaQuery.paddingOf(context).top : 0.0;
    final totalExpanded = config.expandedHeight + topPadding;
    final totalCollapsed = config.collapsedHeight + topPadding;

    return SliverPersistentHeader(
      pinned: true,
      delegate: _RadialDialDelegate(
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

class _RadialDialDelegate extends SliverPersistentHeaderDelegate {
  _RadialDialDelegate({
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
  final RadialDialConfig config;
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
                  // --- EXPANDED POLAR RADIAL DIAL CANVAS ---
                  if (progress < 0.9)
                    Opacity(
                      opacity: isReducedMotion
                          ? (progress > 0.5 ? 0.0 : 1.0)
                          : (1.0 - progress * 1.3).clamp(0.0, 1.0),
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          final centerX = constraints.maxWidth / 2;
                          final centerY = constraints.maxHeight / 2;
                          final contractionFactor = (1.0 - progress * 0.75).clamp(0.1, 1.0);
                          final currentRadius = config.arcRadius * contractionFactor;

                          return Stack(
                            children: [
                              // Central Hub Information Card
                              Center(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.explore,
                                      size: 32.0,
                                      color: theme.colorScheme.primary,
                                    ),
                                    const SizedBox(height: 4.0),
                                    FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: Text(
                                        config.dialCenterTitle,
                                        style: theme.textTheme.titleMedium!.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    if (config.dialCenterSubtitle != null)
                                      FittedBox(
                                        fit: BoxFit.scaleDown,
                                        child: Text(
                                          config.dialCenterSubtitle!,
                                          style: theme.textTheme.bodySmall!.copyWith(
                                            color: theme.colorScheme.onSurfaceVariant,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),

                              // Trigonometric Polar Arc Nodes
                              if (config.dialItems.isNotEmpty)
                                ...List.generate(config.dialItems.length, (i) {
                                  final count = config.dialItems.length;
                                  // Spread nodes along a top half-arc: -math.pi -> 0.0
                                  final angle = -math.pi + (i / (count - 1).clamp(1, 999)) * math.pi;
                                  final nodeX = centerX + currentRadius * math.cos(angle) - (config.nodeSize / 2);
                                  final nodeY = centerY + (currentRadius * 0.85) * math.sin(angle) - (config.nodeSize / 2);

                                  final item = config.dialItems[i];
                                  final isSelected = i == config.selectedDialIndex;

                                  return Positioned(
                                    left: nodeX,
                                    top: nodeY,
                                    child: Transform.scale(
                                      scale: contractionFactor,
                                      child: Tooltip(
                                        message: item.label,
                                        child: InkWell(
                                          onTap: () {
                                            item.onTap?.call();
                                            config.onDialItemSelected?.call(i);
                                          },
                                          customBorder: const CircleBorder(),
                                          child: Container(
                                            width: config.nodeSize,
                                            height: config.nodeSize,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: isSelected
                                                  ? (item.color ?? theme.colorScheme.primary)
                                                  : theme.colorScheme.surfaceContainerHighest,
                                              border: Border.all(
                                                color: isSelected
                                                    ? theme.colorScheme.onPrimary
                                                    : theme.colorScheme.outlineVariant,
                                                width: isSelected ? 2.0 : 1.0,
                                              ),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black.withValues(alpha: 0.1),
                                                  blurRadius: 4.0,
                                                  offset: const Offset(0.0, 2.0),
                                                ),
                                              ],
                                            ),
                                            child: Icon(
                                              item.icon,
                                              size: 20.0,
                                              color: isSelected
                                                  ? theme.colorScheme.onPrimary
                                                  : theme.colorScheme.onSurfaceVariant,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                            ],
                          );
                        },
                      ),
                    ),

                  // --- COLLAPSED COMPACT PINNED TOOLBAR ---
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
                              ] else
                                Icon(Icons.explore, size: 20.0, color: theme.colorScheme.primary),
                              const SizedBox(width: 8.0),
                              Expanded(
                                flex: 4,
                                child: title ??
                                    Text(
                                      config.dialCenterTitle,
                                      style: theme.textTheme.titleMedium!.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                              ),
                              // Condensed mini dial nodes row
                              Flexible(
                                flex: 6,
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: List.generate(config.dialItems.length, (i) {
                                      final item = config.dialItems[i];
                                      final isSelected = i == config.selectedDialIndex;
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 2.0),
                                        child: IconButton(
                                          icon: Icon(
                                            item.icon,
                                            size: 18.0,
                                            color: isSelected
                                                ? theme.colorScheme.primary
                                                : theme.colorScheme.onSurfaceVariant,
                                          ),
                                          style: isSelected
                                              ? IconButton.styleFrom(
                                                  backgroundColor: theme.colorScheme.primaryContainer,
                                                )
                                              : null,
                                          onPressed: () {
                                            item.onTap?.call();
                                            config.onDialItemSelected?.call(i);
                                          },
                                          tooltip: item.label,
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
  bool shouldRebuild(covariant _RadialDialDelegate oldDelegate) {
    return oldDelegate.totalExpanded != totalExpanded ||
        oldDelegate.totalCollapsed != totalCollapsed ||
        oldDelegate.config != config ||
        oldDelegate.title != title ||
        oldDelegate.actions != actions ||
        oldDelegate.leading != leading ||
        oldDelegate.topPadding != topPadding;
  }
}
