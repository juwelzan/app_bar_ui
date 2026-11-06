import 'package:flutter/material.dart';
import '../../../engine/app_bar_configuration.dart';
import '../../../engine/app_bar_controller.dart';
import '../../../engine/app_bar_model_renderer.dart';
import '../../../engine/model_capabilities.dart';
import 'immersive_spatial_config.dart';
import 'immersive_spatial_header.dart';

/// Universal Engine Renderer for Model 4: Edge-to-Edge Immersive Spatial Navigation.
class ImmersiveSpatialRenderer extends AppBarModelRenderer {
  const ImmersiveSpatialRenderer();

  @override
  ModelCapabilities get capabilities => const ModelCapabilities(
        supportsParallax: true,
        supports3DTransform: true,
      );

  @override
  AppBarConfiguration get defaultConfiguration => const AppBarConfiguration(
        layout: LayoutConfiguration(expandedHeight: 260.0, collapsedHeight: 64.0),
      );

  @override
  Widget buildSliver({
    required BuildContext context,
    required ResolvedAppBarConfiguration configuration,
    required AppBarController? controller,
  }) {
    final typedConfig = configuration.typedConfig is ImmersiveSpatialConfig
        ? configuration.typedConfig! as ImmersiveSpatialConfig
        : ImmersiveSpatialConfig(
            expandedHeight: configuration.layout.expandedHeight,
            collapsedHeight: configuration.layout.collapsedHeight,
            backgroundColor: configuration.appearance.backgroundColor,
            titleText: configuration.content.title is Text
                ? (configuration.content.title as Text).data ?? 'Immersive Spatial'
                : 'Immersive Spatial',
            subtitleText: configuration.content.subtitle is Text
                ? (configuration.content.subtitle as Text).data
                : null,
            backgroundLayer: configuration.content.background,
            midgroundLayer: configuration.content.expandedContent,
          );

    return ImmersiveSpatialHeaderWidget(
      title: configuration.content.title,
      leading: configuration.content.leading,
      actions: configuration.content.actions,
      config: typedConfig,
    );
  }
}
