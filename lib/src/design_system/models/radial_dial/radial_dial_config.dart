import 'package:flutter/material.dart';
import '../../app_bar_model_configuration.dart';
import 'radial_dial_item.dart';

/// Strongly-typed configuration for Model 8: Radial Polar Dial Navigation.
///
/// Features a polar coordinate radial dial with interactive navigational nodes
/// distributed along an arc. On scroll, the arc rotates and contracts inward
/// toward the center, collapsing the dial items into a compact segmented pill.
class RadialDialConfig extends AppBarModelConfiguration {
  /// Creates a [RadialDialConfig].
  const RadialDialConfig({
    this.dialItems = const [
      RadialDialItem(icon: Icons.explore_outlined, label: 'Explore'),
      RadialDialItem(icon: Icons.trending_up, label: 'Trending'),
      RadialDialItem(icon: Icons.bookmark_border, label: 'Saved'),
      RadialDialItem(icon: Icons.category_outlined, label: 'Topics'),
      RadialDialItem(icon: Icons.star_border, label: 'Favorites'),
    ],
    this.selectedDialIndex = 0,
    this.onDialItemSelected,
    this.dialCenterTitle = 'Radial Navigator',
    this.dialCenterSubtitle = 'Tap any orbital node',
    this.arcRadius = 88.0,
    this.nodeSize = 44.0,
    this.expandedHeight = 220.0,
    this.collapsedHeight = 56.0,
    super.safeArea = true,
    super.backgroundColor,
    super.surfaceTint,
    super.physics,
    super.elevation = 4.0,
  });

  /// Navigational milestones distributed along the polar arc.
  final List<RadialDialItem> dialItems;

  /// Currently active or selected dial index.
  final int selectedDialIndex;

  /// Callback when a dial item node is tapped.
  final ValueChanged<int>? onDialItemSelected;

  /// Central headline title displayed in the radial hub.
  final String dialCenterTitle;

  /// Central subtitle description in the radial hub.
  final String? dialCenterSubtitle;

  /// Radial distance from the dial center in logical pixels.
  final double arcRadius;

  /// Diameter of each radial node button.
  final double nodeSize;

  /// Total expanded height.
  final double expandedHeight;

  /// Collapsed height of the compact pinned toolbar.
  final double collapsedHeight;
}

