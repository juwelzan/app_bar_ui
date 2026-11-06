import 'package:flutter/material.dart';
import '../../app_bar_model_configuration.dart';
import 'timeline_node_item.dart';

/// Strongly-typed configuration for Model 14: Interactive Timeline Scrubber Navigation.
///
/// Features a chronological milestone scrubber embedded along a horizontal track.
/// At rest, displays milestone nodes with completion states, connecting progress track,
/// and interactive scrubbing. On scroll, collapses into a compact milestone indicator
/// with current date/period chip and previous/next stepping arrows.
class TimelineScrubberNavConfig extends AppBarModelConfiguration {
  /// Creates a [TimelineScrubberNavConfig].
  const TimelineScrubberNavConfig({
    this.timelineTitle = 'Project Roadmap',
    this.nodes = const [
      TimelineNodeItem(
        label: 'Discovery & Spec',
        date: 'Q1 • Jan',
        icon: Icons.search,
        isCompleted: true,
      ),
      TimelineNodeItem(
        label: 'Core Architecture',
        date: 'Q2 • Apr',
        icon: Icons.account_tree,
        isCompleted: true,
      ),
      TimelineNodeItem(
        label: 'Public Beta',
        date: 'Q3 • Jul',
        icon: Icons.rocket_launch,
        isCompleted: false,
        badge: 'Current',
      ),
      TimelineNodeItem(
        label: 'Global Launch',
        date: 'Q4 • Nov',
        icon: Icons.public,
        isCompleted: false,
      ),
    ],
    this.activeNodeIndex = 2,
    this.expandedHeight = 190.0,
    this.collapsedHeight = 58.0,
    this.trackColor,
    this.activeNodeColor,
    this.onNodeSelected,
    super.safeArea = true,
    super.backgroundColor,
    super.surfaceTint,
    super.physics,
    super.elevation = 2.0,
  });

  /// Primary roadmap or project title.
  final String timelineTitle;

  /// Ordered milestone nodes on the timeline.
  final List<TimelineNodeItem> nodes;

  /// Index of the currently active milestone.
  final int activeNodeIndex;

  /// Total expanded height.
  final double expandedHeight;

  /// Collapsed pinned toolbar height.
  final double collapsedHeight;

  /// Custom background track color.
  final Color? trackColor;

  /// Custom color for the active milestone node and progress fill.
  final Color? activeNodeColor;

  /// Callback when user selects a milestone node.
  final ValueChanged<int>? onNodeSelected;
}

