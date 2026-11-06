import 'package:flutter/material.dart';
import '../../../widgets/sliver_widget_marker.dart';
import 'timeline_scrubber_nav_config.dart';

/// Model 14: Interactive Timeline Scrubber Navigation Header.
///
/// Features a chronological milestone scrubber embedded along a horizontal track.
/// At rest, displays milestone nodes with completion states, connecting progress track,
/// and interactive scrubbing. On scroll, collapses into a compact milestone indicator
/// with current date/period chip and previous/next stepping arrows.
class TimelineScrubberNavHeaderWidget extends StatelessWidget with SliverWidgetMarker {
  /// Creates a [TimelineScrubberNavHeaderWidget].
  const TimelineScrubberNavHeaderWidget({
    super.key,
    this.title,
    this.leading,
    this.actions,
    this.config = const TimelineScrubberNavConfig(),
  });

  /// Optional custom title override.
  final Widget? title;

  /// Optional custom leading widget.
  final Widget? leading;

  /// Optional trailing action widgets.
  final List<Widget>? actions;

  /// Strongly-typed configuration for this model.
  final TimelineScrubberNavConfig config;

  @override
  Widget build(BuildContext context) {
    final topPadding = config.safeArea ? MediaQuery.paddingOf(context).top : 0.0;
    final totalExpanded = config.expandedHeight + topPadding;
    final totalCollapsed = config.collapsedHeight + topPadding;

    return SliverPersistentHeader(
      pinned: true,
      delegate: _TimelineScrubberNavDelegate(
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

class _TimelineScrubberNavDelegate extends SliverPersistentHeaderDelegate {
  _TimelineScrubberNavDelegate({
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
  final TimelineScrubberNavConfig config;
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
    final activeColor = config.activeNodeColor ?? theme.colorScheme.primary;
    final trackColor = config.trackColor ?? theme.colorScheme.outlineVariant.withValues(alpha: 0.4);

    final activeNode = config.nodes.isNotEmpty
        ? config.nodes[config.activeNodeIndex.clamp(0, config.nodes.length - 1)]
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
                  // --- EXPANDED HORIZONTAL TIMELINE SCRUBBER ---
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
                            // Top Row: Roadmap title & active milestone chip
                            Row(
                              children: [
                                if (leading != null) ...[
                                  leading!,
                                  const SizedBox(width: 8.0),
                                ],
                                Expanded(
                                  child: Text(
                                    config.timelineTitle,
                                    style: theme.textTheme.titleMedium!.copyWith(
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: -0.2,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                if (activeNode != null)
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 3.0),
                                    decoration: BoxDecoration(
                                      color: activeColor.withValues(alpha: 0.12),
                                      borderRadius: BorderRadius.circular(12.0),
                                      border: Border.all(color: activeColor.withValues(alpha: 0.3)),
                                    ),
                                    child: Text(
                                      activeNode.date,
                                      style: TextStyle(
                                        fontSize: 10.5,
                                        fontWeight: FontWeight.bold,
                                        color: activeColor,
                                      ),
                                    ),
                                  ),
                                ...?actions,
                              ],
                            ),
                            const Spacer(),

                            // Horizontal Connecting Progress Track with Milestone Nodes
                            SizedBox(
                              height: 80.0,
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  // Continuous Background Line
                                  Positioned(
                                    left: 24.0,
                                    right: 24.0,
                                    top: 24.0,
                                    child: Container(
                                      height: 3.0,
                                      decoration: BoxDecoration(
                                        color: trackColor,
                                        borderRadius: BorderRadius.circular(1.5),
                                      ),
                                    ),
                                  ),

                                  // Horizontal Nodes Row
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: List.generate(config.nodes.length, (idx) {
                                      final node = config.nodes[idx];
                                      final isSelected = idx == config.activeNodeIndex;
                                      final isDone = node.isCompleted;

                                      return InkWell(
                                        onTap: () {
                                          node.onTap?.call();
                                          config.onNodeSelected?.call(idx);
                                        },
                                        borderRadius: BorderRadius.circular(10.0),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 4.0),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              // Node Circle
                                              Container(
                                                width: isSelected ? 34.0 : 26.0,
                                                height: isSelected ? 34.0 : 26.0,
                                                decoration: BoxDecoration(
                                                  color: isSelected
                                                      ? activeColor
                                                      : isDone
                                                          ? activeColor.withValues(alpha: 0.2)
                                                          : theme.colorScheme.surface,
                                                  shape: BoxShape.circle,
                                                  border: Border.all(
                                                    color: isSelected || isDone
                                                        ? activeColor
                                                        : theme.colorScheme.outlineVariant,
                                                    width: isSelected ? 2.5 : 1.5,
                                                  ),
                                                  boxShadow: isSelected
                                                      ? [
                                                          BoxShadow(
                                                            color: activeColor.withValues(alpha: 0.35),
                                                            blurRadius: 8.0,
                                                            spreadRadius: 1.0,
                                                          )
                                                        ]
                                                      : null,
                                                ),
                                                child: Center(
                                                  child: Icon(
                                                    node.icon ?? (isDone ? Icons.check : Icons.circle),
                                                    size: isSelected ? 16.0 : 12.0,
                                                    color: isSelected
                                                        ? theme.colorScheme.onPrimary
                                                        : isDone
                                                            ? activeColor
                                                            : theme.colorScheme.outline,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(height: 6.0),

                                              // Node Label
                                              Text(
                                                node.label,
                                                style: TextStyle(
                                                  fontSize: isSelected ? 11.0 : 10.0,
                                                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                                                  color: isSelected
                                                      ? theme.colorScheme.onSurface
                                                      : theme.colorScheme.onSurfaceVariant,
                                                ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    }),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                  // --- COLLAPSED COMPACT PINNED SCRUBBER BAR ---
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
                                      activeNode != null
                                          ? '${config.timelineTitle} • ${activeNode.label}'
                                          : config.timelineTitle,
                                      style: theme.textTheme.titleMedium!.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                              ),
                              if (activeNode != null)
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 3.0),
                                  decoration: BoxDecoration(
                                    color: activeColor.withValues(alpha: 0.12),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  child: Text(
                                    activeNode.date,
                                    style: TextStyle(
                                      fontSize: 10.5,
                                      fontWeight: FontWeight.bold,
                                      color: activeColor,
                                    ),
                                  ),
                                ),
                              const SizedBox(width: 4.0),
                              IconButton(
                                icon: const Icon(Icons.chevron_left, size: 20.0),
                                onPressed: config.activeNodeIndex > 0
                                    ? () => config.onNodeSelected?.call(config.activeNodeIndex - 1)
                                    : null,
                                tooltip: 'Previous Milestone',
                              ),
                              IconButton(
                                icon: const Icon(Icons.chevron_right, size: 20.0),
                                onPressed: config.activeNodeIndex < config.nodes.length - 1
                                    ? () => config.onNodeSelected?.call(config.activeNodeIndex + 1)
                                    : null,
                                tooltip: 'Next Milestone',
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
  bool shouldRebuild(covariant _TimelineScrubberNavDelegate oldDelegate) {
    return oldDelegate.totalExpanded != totalExpanded ||
        oldDelegate.totalCollapsed != totalCollapsed ||
        oldDelegate.config != config ||
        oldDelegate.title != title ||
        oldDelegate.actions != actions ||
        oldDelegate.leading != leading ||
        oldDelegate.topPadding != topPadding;
  }
}
