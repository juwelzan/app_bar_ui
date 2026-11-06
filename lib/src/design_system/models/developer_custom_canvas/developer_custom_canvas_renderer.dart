import 'package:flutter/material.dart';
import '../../../engine/app_bar_configuration.dart';
import '../../../engine/app_bar_controller.dart';
import '../../../engine/app_bar_model_renderer.dart';
import '../../../engine/model_capabilities.dart';
import 'developer_custom_canvas_config.dart';
import 'developer_custom_canvas_header.dart';

/// Universal Engine Renderer for Model 20: Developer Custom Canvas Navigation.
class DeveloperCustomCanvasRenderer extends AppBarModelRenderer {
  /// Creates a [DeveloperCustomCanvasRenderer].
  const DeveloperCustomCanvasRenderer();

  @override
  ModelCapabilities get capabilities => const ModelCapabilities(
        supportsSticky: true,
        supportsMultiStage: true,
      );

  @override
  AppBarConfiguration get defaultConfiguration => const AppBarConfiguration(
        layout: LayoutConfiguration(expandedHeight: 200.0, collapsedHeight: 60.0),
      );

  @override
  Widget buildSliver({
    required BuildContext context,
    required ResolvedAppBarConfiguration configuration,
    required AppBarController? controller,
  }) {
    final typedConfig = configuration.typedConfig is DeveloperCustomCanvasConfig
        ? configuration.typedConfig! as DeveloperCustomCanvasConfig
        : DeveloperCustomCanvasConfig(
            expandedHeight: configuration.layout.expandedHeight,
            collapsedHeight: configuration.layout.collapsedHeight,
            backgroundColor: configuration.appearance.backgroundColor,
            safeArea: configuration.layout.safeArea,
          );

    return DeveloperCustomCanvasHeaderWidget(
      title: configuration.content.title,
      leading: configuration.content.leading,
      actions: configuration.content.actions,
      config: typedConfig,
    );
  }
}

