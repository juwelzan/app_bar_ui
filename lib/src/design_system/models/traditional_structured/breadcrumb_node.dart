import 'package:flutter/material.dart';

/// Represents a single navigational milestone within the structured breadcrumb tree.
class StructuredBreadcrumbNode {
  /// Creates a [StructuredBreadcrumbNode].
  const StructuredBreadcrumbNode({
    required this.label,
    this.icon,
    this.onTap,
    this.dropdownItems = const [],
    this.onDropdownSelected,
  });

  /// Text display label for this node.
  final String label;

  /// Optional leading icon for this milestone.
  final IconData? icon;

  /// Callback when this breadcrumb node is tapped directly.
  final VoidCallback? onTap;

  /// Optional alternative sub-routes for contextual dropdown selection.
  final List<String> dropdownItems;

  /// Callback when a dropdown sub-route is selected.
  final ValueChanged<String>? onDropdownSelected;
}

/// Deployment environment indicator badge for enterprise application headers.
enum EnvironmentBadge {
  /// Production environment.
  production('PROD', Colors.green),

  /// Staging / Pre-release environment.
  staging('STAGE', Colors.amber),

  /// Development environment.
  development('DEV', Colors.blue),

  /// Isolated sandbox testing environment.
  sandbox('SANDBOX', Colors.deepPurple);

  const EnvironmentBadge(this.label, this.color);

  /// Abbreviated label string.
  final String label;

  /// Accent highlight color.
  final MaterialColor color;
}
