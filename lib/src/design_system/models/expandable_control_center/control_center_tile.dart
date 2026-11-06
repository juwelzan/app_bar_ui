import 'package:flutter/material.dart';

/// Interactive quick-settings tile inside [ExpandableControlCenterConfig].
class ControlCenterTile {
  /// Creates a [ControlCenterTile].
  const ControlCenterTile({
    required this.title,
    this.subtitle,
    required this.icon,
    this.isActive = false,
    this.onTap,
  });

  /// Primary name of the setting or device.
  final String title;

  /// Secondary status description (e.g. 'Connected', 'Optimal').
  final String? subtitle;

  /// Icon representing the setting.
  final IconData icon;

  /// Whether the tile is currently toggled on / active.
  final bool isActive;

  /// Callback when user taps or toggles this tile.
  final VoidCallback? onTap;
}

