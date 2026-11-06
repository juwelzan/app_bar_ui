import 'package:flutter/material.dart';
import '../../app_bar_model_configuration.dart';

/// Strongly-typed configuration for Model 6: 3D Spatial Perspective Flip Navigation.
///
/// Implements a true 3D perspective projection flip. The expanded front face presents
/// prominent hero metrics and artwork. As scroll progresses, the card rotates in 3D
/// space around its axis to reveal the reverse face compact toolbar.
class Spatial3DFlipConfig extends AppBarModelConfiguration {
  /// Creates a [Spatial3DFlipConfig].
  const Spatial3DFlipConfig({
    this.frontTitle = 'Portfolio Overview',
    this.frontSubtitle = 'Total Liquid Assets',
    this.frontMetricValue = '\$142,850.00',
    this.frontMetricLabel = '+14.2% Past Month',
    this.frontFace,
    this.backTitle = 'Quick Actions',
    this.backFace,
    this.perspective = 0.0018,
    this.expandedHeight = 200.0,
    this.collapsedHeight = 60.0,
    this.flipAxis = Axis.horizontal,
    this.borderRadius = 20.0,
    super.safeArea = true,
    super.backgroundColor,
    super.surfaceTint,
    super.physics,
    super.elevation = 6.0,
  });

  /// Primary title rendered on the front face card.
  final String frontTitle;

  /// Secondary subtitle rendered on the front face card.
  final String? frontSubtitle;

  /// Primary prominent metric string on the front card.
  final String? frontMetricValue;

  /// Trend or descriptive label accompanying the metric.
  final String? frontMetricLabel;

  /// Optional custom widget tree replacing the built-in front face.
  final Widget? frontFace;

  /// Title rendered on the back face compact toolbar.
  final String backTitle;

  /// Optional custom widget tree replacing the built-in back face.
  final Widget? backFace;

  /// 3D perspective distortion coefficient.
  final double perspective;

  /// Total expanded height in resting state.
  final double expandedHeight;

  /// Total collapsed height when flipped into pinned state.
  final double collapsedHeight;

  /// Rotation axis (horizontal: around Y-axis, vertical: around X-axis).
  final Axis flipAxis;

  /// Corner radius of the 3D rotating card.
  final double borderRadius;
}
