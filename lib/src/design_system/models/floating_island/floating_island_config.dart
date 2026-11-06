import 'package:flutter/material.dart';
import '../../app_bar_model_configuration.dart';
import '../../../engine/app_bar_configuration.dart';

/// Strongly-typed configuration for Model 3: Floating Dynamic Island Navigation.
class FloatingIslandConfig extends AppBarModelConfiguration {
  /// Creates a [FloatingIslandConfig].
  const FloatingIslandConfig({
    this.expandedHorizontalMargin = 20.0,
    this.compactHorizontalMargin = 36.0,
    this.expandedHeight = 76.0,
    this.compactHeight = 48.0,
    this.borderRadius = 28.0,
    this.springPhysics = const SpringPhysicsSpec(stiffness: 300.0, damping: 20.0),
    this.statusChips = const [],
    this.islandTitle = 'Dynamic Island',
    this.islandSubtitle = 'Active Telemetry',
    this.leadingIcon = Icons.bubble_chart_outlined,
    this.accentColor,
    super.safeArea = true,
    super.backgroundColor,
    super.surfaceTint,
    super.physics,
    super.elevation = 8.0,
  });

  /// Horizontal margin on left and right in resting expanded state.
  final double expandedHorizontalMargin;

  /// Horizontal margin on left and right in compact pinned state.
  final double compactHorizontalMargin;

  /// Vertical height of the island in resting expanded state.
  final double expandedHeight;

  /// Vertical height of the island in compact pinned state.
  final double compactHeight;

  /// Corner radius of the detached island capsule.
  final double borderRadius;

  /// Mathematical spring physics parameters for interactive recoil.
  final SpringPhysicsSpec springPhysics;

  /// Contextual status widgets (e.g. Flight chip, Playback mini-controller).
  final List<Widget> statusChips;

  /// Primary headline title displayed in the island.
  final String islandTitle;

  /// Secondary telemetry or status subtitle.
  final String? islandSubtitle;

  /// Icon badge rendered in the leading anchor of the island.
  final IconData leadingIcon;

  /// Highlight accent color for live indicators.
  final Color? accentColor;
}
