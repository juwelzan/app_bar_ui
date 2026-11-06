import 'package:flutter/material.dart';
import '../widgets/sliver_widget_marker.dart';
import 'experience_configs.dart';

/// Style 46: Interactive Timeline Scrubber Header.
///
/// A scroll-driven timeline scrubber where chronological milestone pins slide
/// horizontally across an active time track synchronized with scroll depth,
/// highlighting the active milestone and compressing into a pinned mini-tracker.
class InteractiveTimelineScrubberHeaderWidget extends StatelessWidget
    with SliverWidgetMarker {
  /// Creates an [InteractiveTimelineScrubberHeaderWidget].
  const InteractiveTimelineScrubberHeaderWidget({
    super.key,
    required this.title,
    this.milestones = const ['Phase 1', 'Phase 2', 'Phase 3', 'Phase 4', 'Launch'],
    this.subtitle,
    this.leading,
    this.actions,
    this.backgroundColor,
    this.safeArea = true,
    this.config = const InteractiveTimelineScrubberConfig(),
  });

  /// The primary title widget.
  final Widget title;

  /// List of text milestone labels along the timeline track.
  final List<String> milestones;

  /// Optional subtitle.
  final Widget? subtitle;

  /// Optional leading widget.
  final Widget? leading;

  /// Optional trailing action widgets.
  final List<Widget>? actions;

  /// Header canvas background color.
  final Color? backgroundColor;

  /// Whether to respect status bar safe area.
  final bool safeArea;

  /// Timeline scrubber configuration.
  final InteractiveTimelineScrubberConfig config;

  @override
  Widget build(BuildContext context) {
    final topPadding = safeArea ? MediaQuery.paddingOf(context).top : 0.0;
    final totalExpanded = config.expandedHeight + topPadding;
    final totalCollapsed = config.collapsedHeight + topPadding;

    return SliverPersistentHeader(
      pinned: true,
      delegate: _TimelineScrubberDelegate(
        title: title,
        milestones: milestones,
        subtitle: subtitle,
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

class _TimelineScrubberDelegate extends SliverPersistentHeaderDelegate {
  _TimelineScrubberDelegate({
    required this.title,
    required this.milestones,
    required this.subtitle,
    required this.leading,
    required this.actions,
    required this.backgroundColor,
    required this.topPadding,
    required this.totalExpanded,
    required this.totalCollapsed,
    required this.config,
  });

  final Widget title;
  final List<String> milestones;
  final Widget? subtitle;
  final Widget? leading;
  final List<Widget>? actions;
  final Color backgroundColor;
  final double topPadding;
  final double totalExpanded;
  final double totalCollapsed;
  final InteractiveTimelineScrubberConfig config;

  @override
  double get minExtent => totalCollapsed;

  @override
  double get maxExtent => totalExpanded;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    final isReducedMotion = MediaQuery.disableAnimationsOf(context);
    final theme = Theme.of(context);
    final progress = ((shrinkOffset) / (totalExpanded - totalCollapsed)).clamp(0.0, 1.0);

    // Active milestone index based on progress
    final milestoneCount = milestones.isEmpty ? 1 : milestones.length;
    final activeIndex = (progress * (milestoneCount - 1)).round().clamp(0, milestoneCount - 1);
    final activeMilestone = milestones.isEmpty ? '' : milestones[activeIndex];

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
              // Top Pinned Navigation Toolbar
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
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            DefaultTextStyle(
                              style: theme.textTheme.titleMedium!.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                              child: title,
                            ),
                            if (progress > 0.5)
                              Text(
                                'Milestone: $activeMilestone',
                                style: theme.textTheme.bodySmall!.copyWith(
                                  color: theme.colorScheme.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              )
                            else if (subtitle != null)
                              DefaultTextStyle(
                                style: theme.textTheme.bodySmall!,
                                child: subtitle!,
                              ),
                          ],
                        ),
                      ),
                      ...?actions,
                    ],
                  ),
                ),
              ),

              // Expanded Timeline Track & Milestones
              Positioned(
                bottom: 16.0,
                left: 20.0,
                right: 20.0,
                child: Opacity(
                  opacity: isReducedMotion ? 1.0 : (1.0 - progress * 1.5).clamp(0.0, 1.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Active Milestone Badge
                      if (config.showActiveMilestonePill)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primaryContainer,
                              borderRadius: BorderRadius.circular(16.0),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.flag, size: 14.0, color: theme.colorScheme.primary),
                                const SizedBox(width: 6.0),
                                Text(
                                  activeMilestone,
                                  style: TextStyle(
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.bold,
                                    color: theme.colorScheme.onPrimaryContainer,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                      // Horizontal Scrubber Track with Milestones
                      LayoutBuilder(
                        builder: (context, constraints) {
                          final trackWidth = constraints.maxWidth;
                          final indicatorLeft = isReducedMotion
                              ? 0.0
                              : (trackWidth - config.indicatorSize) * progress;

                          return Stack(
                            alignment: Alignment.centerLeft,
                            children: [
                              // Inactive baseline track
                              Container(
                                width: trackWidth,
                                height: config.trackHeight,
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.surfaceContainerHighest,
                                  borderRadius: BorderRadius.circular(config.trackHeight / 2),
                                ),
                              ),

                              // Active progress track
                              Container(
                                width: isReducedMotion ? trackWidth : trackWidth * progress,
                                height: config.trackHeight,
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.primary,
                                  borderRadius: BorderRadius.circular(config.trackHeight / 2),
                                ),
                              ),

                              // Milestone Tick Dots
                              if (milestones.length > 1)
                                SizedBox(
                                  width: trackWidth,
                                  height: config.indicatorSize,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: List.generate(milestones.length, (index) {
                                      final isPassed = index <= activeIndex;
                                      return Container(
                                        width: 8.0,
                                        height: 8.0,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: isPassed
                                              ? theme.colorScheme.primary
                                              : theme.colorScheme.outlineVariant,
                                        ),
                                      );
                                    }),
                                  ),
                                ),

                              // Scrubber Indicator Ball
                              if (!isReducedMotion)
                                Positioned(
                                  left: indicatorLeft,
                                  child: Container(
                                    width: config.indicatorSize,
                                    height: config.indicatorSize,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: theme.colorScheme.primary,
                                      border: Border.all(color: Colors.white, width: 2.0),
                                      boxShadow: [
                                        BoxShadow(
                                          color: theme.colorScheme.primary.withValues(alpha: 0.4),
                                          blurRadius: 6.0,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                            ],
                          );
                        },
                      ),

                      // Milestone Text Labels
                      if (milestones.length > 1)
                        Padding(
                          padding: const EdgeInsets.only(top: 6.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: milestones.map((m) {
                              final isCurrent = m == activeMilestone;
                              return Text(
                                m,
                                style: theme.textTheme.bodySmall!.copyWith(
                                  fontSize: 10.0,
                                  fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
                                  color: isCurrent
                                      ? theme.colorScheme.primary
                                      : theme.colorScheme.onSurfaceVariant,
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                    ],
                  ),
                ),
              ),

              // Pinned Bottom Progress Strip when collapsed
              if (progress > 0.8)
                Positioned(
                  bottom: 0.0,
                  left: 0.0,
                  right: 0.0,
                  height: 3.0,
                  child: LinearProgressIndicator(
                    value: progress,
                    backgroundColor: Colors.transparent,
                    valueColor: AlwaysStoppedAnimation<Color>(theme.colorScheme.primary),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(covariant _TimelineScrubberDelegate oldDelegate) {
    return oldDelegate.totalExpanded != totalExpanded ||
        oldDelegate.totalCollapsed != totalCollapsed ||
        oldDelegate.title != title ||
        oldDelegate.milestones != milestones ||
        oldDelegate.subtitle != subtitle ||
        oldDelegate.leading != leading ||
        oldDelegate.actions != actions ||
        oldDelegate.backgroundColor != backgroundColor ||
        oldDelegate.topPadding != topPadding ||
        oldDelegate.config != config;
  }
}
