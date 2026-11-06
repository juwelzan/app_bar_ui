import 'package:flutter/material.dart';
import '../../app_bar_model_configuration.dart';

/// Strongly-typed configuration for Model 16: Gesture Elastic Canvas Navigation.
///
/// Features a physics-based rubber-band elastic header canvas that overscrolls downward
/// to reveal rich contextual actions or pull-to-refresh metrics with elastic damping.
/// On scroll up, compresses elastically before locking into a glassmorphic minimal pinned bar.
class GestureElasticCanvasConfig extends AppBarModelConfiguration {
  /// Creates a [GestureElasticCanvasConfig].
  const GestureElasticCanvasConfig({
    this.canvasTitle = 'Elastic Horizon',
    this.canvasSubtitle = 'Pull downward to trigger adaptive refresh',
    this.statusMetric = '99.98% Operational',
    this.expandedHeight = 210.0,
    this.collapsedHeight = 60.0,
    this.elasticTension = 1.2,
    this.accentColor,
    this.onRefreshTriggered,
    super.safeArea = true,
    super.backgroundColor,
    super.surfaceTint,
    super.physics,
    super.elevation = 2.0,
  });

  /// Primary canvas title.
  final String canvasTitle;

  /// Secondary subtitle or elastic hint.
  final String canvasSubtitle;

  /// Operational telemetry or metric chip text.
  final String statusMetric;

  /// Total expanded height.
  final double expandedHeight;

  /// Collapsed pinned toolbar height.
  final double collapsedHeight;

  /// Physics tension multiplier for elastic scaling.
  final double elasticTension;

  /// Custom accent color for glow and indicators.
  final Color? accentColor;

  /// Callback triggered when an overscroll gesture threshold is met.
  final VoidCallback? onRefreshTriggered;
}

