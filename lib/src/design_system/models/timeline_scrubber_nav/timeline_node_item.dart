import 'package:flutter/material.dart';

/// Single milestone node in [TimelineScrubberNavConfig].
class TimelineNodeItem {
  /// Creates a [TimelineNodeItem].
  const TimelineNodeItem({
    required this.label,
    required this.date,
    this.icon,
    this.isCompleted = false,
    this.badge,
    this.onTap,
  });

  /// Milestone headline (e.g. 'Kickoff', 'Alpha Release', 'Security Audit').
  final String label;

  /// Date or sprint timeline text (e.g. 'Oct 12', 'Week 4').
  final String date;

  /// Optional icon.
  final IconData? icon;

  /// Whether this milestone has been completed.
  final bool isCompleted;

  /// Optional status badge tag (e.g. 'Live', 'Pending').
  final String? badge;

  /// Optional tap callback.
  final VoidCallback? onTap;
}
