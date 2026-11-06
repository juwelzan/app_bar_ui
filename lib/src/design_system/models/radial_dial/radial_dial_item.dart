import 'package:flutter/material.dart';

/// Interactive node item along the polar arc in [RadialDialConfig].
class RadialDialItem {
  /// Creates a [RadialDialItem].
  const RadialDialItem({
    required this.icon,
    required this.label,
    this.color,
    this.onTap,
  });

  /// Display icon for this dial node.
  final IconData icon;

  /// Display text label.
  final String label;

  /// Optional accent color for this node item.
  final Color? color;

  /// Tap callback when this dial item is selected.
  final VoidCallback? onTap;
}

