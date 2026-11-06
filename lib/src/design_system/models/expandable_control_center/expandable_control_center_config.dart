import 'package:flutter/material.dart';
import '../../app_bar_model_configuration.dart';
import 'control_center_tile.dart';

/// Strongly-typed configuration for Model 13: Expandable Control Center Navigation.
///
/// Features a quick-settings control hub embedded into the header. At rest, displays
/// high-priority interactive quick-setting tiles (Wi-Fi, Bluetooth, VPN, Battery).
/// On upward scroll, tiles collapse into a sleek horizontal row of compact status icons
/// in the pinned toolbar.
class ExpandableControlCenterConfig extends AppBarModelConfiguration {
  /// Creates an [ExpandableControlCenterConfig].
  const ExpandableControlCenterConfig({
    this.hubTitle = 'Control Center',
    this.tiles = const [
      ControlCenterTile(
        title: 'Wi-Fi 6E',
        subtitle: 'Enterprise-Secure',
        icon: Icons.wifi,
        isActive: true,
      ),
      ControlCenterTile(
        title: 'Bluetooth 5.3',
        subtitle: '4 Connected',
        icon: Icons.bluetooth,
        isActive: true,
      ),
      ControlCenterTile(
        title: 'Global VPN',
        subtitle: 'US-East Fast-Lane',
        icon: Icons.vpn_lock,
        isActive: true,
      ),
      ControlCenterTile(
        title: 'Battery Saver',
        subtitle: 'Optimal Efficiency',
        icon: Icons.battery_saver,
        isActive: false,
      ),
    ],
    this.expandedHeight = 220.0,
    this.collapsedHeight = 60.0,
    this.tileActiveColor,
    this.tileInactiveColor,
    this.onTileToggled,
    super.safeArea = true,
    super.backgroundColor,
    super.surfaceTint,
    super.physics,
    super.elevation = 2.0,
  });

  /// Primary title for the control center hub.
  final String hubTitle;

  /// Ordered quick-settings tiles.
  final List<ControlCenterTile> tiles;

  /// Total expanded height.
  final double expandedHeight;

  /// Collapsed pinned toolbar height.
  final double collapsedHeight;

  /// Custom active tile highlight color.
  final Color? tileActiveColor;

  /// Custom inactive tile background color.
  final Color? tileInactiveColor;

  /// Optional callback invoked when a tile is tapped by index.
  final ValueChanged<int>? onTileToggled;
}

