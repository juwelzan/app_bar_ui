import 'package:flutter/material.dart';
import '../../app_bar_model_configuration.dart';

/// Strongly-typed configuration for Model 4: Edge-to-Edge Immersive Spatial Navigation.
class ImmersiveSpatialConfig extends AppBarModelConfiguration {
  /// Creates an [ImmersiveSpatialConfig].
  const ImmersiveSpatialConfig({
    this.backgroundLayer,
    this.midgroundLayer,
    this.foregroundLayer,
    this.expandedHeight = 260.0,
    this.collapsedHeight = 64.0,
    this.backgroundParallaxFactor = 0.25,
    this.midgroundParallaxFactor = 0.60,
    this.focalDepthBlur = 8.0,
    this.convergenceThreshold = 140.0,
    this.titleText = 'Virtual Spatial Horizon',
    this.subtitleText = 'Multi-Plane Z-Depth Navigation',
    super.safeArea = true,
    super.backgroundColor,
    super.surfaceTint,
    super.physics,
    super.elevation = 4.0,
  });

  /// Deep background layer (-100 virtual z-depth) moving at slower velocity.
  final Widget? backgroundLayer;

  /// Midground layer (0 virtual z-depth) presenting primary focal imagery.
  final Widget? midgroundLayer;

  /// Foreground layer (+50 virtual z-depth) floating closest to the viewer.
  final Widget? foregroundLayer;

  /// Expanded height of the spatial viewport.
  final double expandedHeight;

  /// Collapsed height of the converged pinned toolbar.
  final double collapsedHeight;

  /// Movement rate multiplier for the deep background plane.
  final double backgroundParallaxFactor;

  /// Movement rate multiplier for the midground plane.
  final double midgroundParallaxFactor;

  /// Maximum gaussian blur sigma applied to background/midground upon convergence.
  final double focalDepthBlur;

  /// Scroll distance required to converge all 3 spatial planes into the flat toolbar.
  final double convergenceThreshold;

  /// Primary title string.
  final String titleText;

  /// Secondary subtitle string.
  final String? subtitleText;
}

