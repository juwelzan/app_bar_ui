import 'package:flutter/material.dart';
import '../../app_bar_model_configuration.dart';

/// Signature for custom developer canvas rendering callback.
typedef CustomCanvasBuilder = Widget Function(
  BuildContext context,
  double shrinkOffset,
  double progress,
);

/// Strongly-typed configuration for Model 20: Developer Custom Canvas Navigation.
///
/// Provides a blank slate canvas granting full architectural liberty to developers.
/// If no custom [builder] is provided, renders an architectural blueprint inspection grid
/// displaying real-time coordinate readouts, progress telemetry, and dimension guides.
class DeveloperCustomCanvasConfig extends AppBarModelConfiguration {
  /// Creates a [DeveloperCustomCanvasConfig].
  const DeveloperCustomCanvasConfig({
    this.canvasName = 'Architectural Canvas 20',
    this.builder,
    this.expandedHeight = 200.0,
    this.collapsedHeight = 60.0,
    this.showBlueprintGrid = true,
    this.gridColor,
    super.safeArea = true,
    super.backgroundColor,
    super.surfaceTint,
    super.physics,
    super.elevation = 2.0,
  });

  /// Name of this custom canvas instance.
  final String canvasName;

  /// Optional custom builder callback rendering full header content with live scroll metrics.
  final CustomCanvasBuilder? builder;

  /// Total expanded height.
  final double expandedHeight;

  /// Collapsed pinned toolbar height.
  final double collapsedHeight;

  /// Whether to render blueprint coordinate grid lines when using default canvas.
  final bool showBlueprintGrid;

  /// Custom grid stroke color.
  final Color? gridColor;
}

