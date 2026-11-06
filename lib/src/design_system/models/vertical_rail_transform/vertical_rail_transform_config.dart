import 'package:flutter/material.dart';
import '../../app_bar_model_configuration.dart';
import 'rail_destination.dart';

/// Strongly-typed configuration for Model 7: Vertical Rail Transformation Navigation.
///
/// Adaptive layout transforming from an expansive horizontal top hero into a
/// condensed horizontal or vertical rail navigation strip with icon destinations.
class VerticalRailTransformConfig extends AppBarModelConfiguration {
  /// Creates a [VerticalRailTransformConfig].
  const VerticalRailTransformConfig({
    this.destinations = const [
      RailNavigationDestination(icon: Icons.dashboard_outlined, selectedIcon: Icons.dashboard, label: 'Board'),
      RailNavigationDestination(icon: Icons.assignment_outlined, selectedIcon: Icons.assignment, label: 'Tasks'),
      RailNavigationDestination(icon: Icons.pie_chart_outline, selectedIcon: Icons.pie_chart, label: 'Analytics'),
      RailNavigationDestination(icon: Icons.settings_outlined, selectedIcon: Icons.settings, label: 'Settings'),
    ],
    this.selectedIndex = 0,
    this.onDestinationSelected,
    this.expandedTitle = 'Project Hub',
    this.expandedSubtitle = 'Sprint 42 • Active Roadmap',
    this.railWidth = 72.0,
    this.expandedHeight = 160.0,
    this.collapsedHeight = 56.0,
    this.avatar,
    super.safeArea = true,
    super.backgroundColor,
    super.surfaceTint,
    super.physics,
    super.elevation = 2.0,
  });

  /// Ordered navigation destinations rendered in the strip.
  final List<RailNavigationDestination> destinations;

  /// Currently selected destination index.
  final int selectedIndex;

  /// Callback when a destination item is tapped.
  final ValueChanged<int>? onDestinationSelected;

  /// Headline title displayed in the expanded horizontal top tier.
  final String expandedTitle;

  /// Secondary subtitle displayed in the expanded horizontal top tier.
  final String? expandedSubtitle;

  /// Width of the rail layout when transformed.
  final double railWidth;

  /// Total expanded height.
  final double expandedHeight;

  /// Collapsed height of the pinned toolbar.
  final double collapsedHeight;

  /// Optional avatar widget rendered alongside destinations.
  final Widget? avatar;
}
