import 'package:flutter/material.dart';

/// Navigation destination milestone for [VerticalRailTransformConfig].
class RailNavigationDestination {
  /// Creates a [RailNavigationDestination].
  const RailNavigationDestination({
    required this.icon,
    this.selectedIcon,
    required this.label,
    this.badge,
  });

  /// Inactive unselected icon.
  final IconData icon;

  /// Optional active selected icon.
  final IconData? selectedIcon;

  /// Display text label.
  final String label;

  /// Optional notification or count badge string.
  final String? badge;
}

