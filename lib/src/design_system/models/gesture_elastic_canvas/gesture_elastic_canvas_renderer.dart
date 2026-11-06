import 'package:flutter/material.dart';
import '../../../engine/app_bar_configuration.dart';
import '../../../engine/app_bar_controller.dart';
import '../../../engine/app_bar_model_renderer.dart';
import '../../../engine/model_capabilities.dart';
import 'gesture_elastic_canvas_config.dart';
import 'gesture_elastic_canvas_header.dart';

/// Universal Engine Renderer for Model 16: Gesture Elastic Canvas Navigation.
class GestureElasticCanvasRenderer extends AppBarModelRenderer {
  /// Creates a [GestureElasticCanvasRenderer].
  const GestureElasticCanvasRenderer();

  @override
  ModelCapabilities get capabilities => const ModelCapabilities(
        supportsDragToExpand: true,
        supportsSticky: true,
        supportsMultiStage: true,
      );

  @override
  AppBarConfiguration get defaultConfiguration => const AppBarConfiguration(
        layout: LayoutConfiguration(expandedHeight: 210.0, collapsedHeight: 60.0),
      );

  @override
  Widget buildSliver({
    required BuildContext context,
    required ResolvedAppBarConfiguration configuration,
    required AppBarController? controller,
  }) {
    final typedConfig = configuration.typedConfig is GestureElasticCanvasConfig
        ? configuration.typedConfig! as GestureElasticCanvasConfig
        : GestureElasticCanvasConfig(
            expandedHeight: configuration.layout.expandedHeight,
            collapsedHeight: configuration.layout.collapsedHeight,
            backgroundColor: configuration.appearance.backgroundColor,
            safeArea: configuration.layout.safeArea,
          );

    return GestureElasticCanvasHeaderWidget(
      title: configuration.content.title,
      leading: configuration.content.leading,
      actions: configuration.content.actions,
      config: typedConfig,
    );
  }
}
