import 'package:flutter/material.dart';
import '../../../engine/app_bar_configuration.dart';
import '../../../engine/app_bar_controller.dart';
import '../../../engine/app_bar_model_renderer.dart';
import '../../../engine/model_capabilities.dart';
import 'floating_island_config.dart';
import 'floating_island_header.dart';

/// Universal Engine Renderer for Model 3: Floating Dynamic Island Navigation.
class FloatingIslandRenderer extends AppBarModelRenderer {
  const FloatingIslandRenderer();

  @override
  ModelCapabilities get capabilities => const ModelCapabilities(
        supportsDragToExpand: true,
      );

  @override
  AppBarConfiguration get defaultConfiguration => const AppBarConfiguration(
        layout: LayoutConfiguration(expandedHeight: 80.0, collapsedHeight: 52.0),
      );

  @override
  Widget buildSliver({
    required BuildContext context,
    required ResolvedAppBarConfiguration configuration,
    required AppBarController? controller,
  }) {
    final typedConfig = configuration.typedConfig is FloatingIslandConfig
        ? configuration.typedConfig! as FloatingIslandConfig
        : FloatingIslandConfig(
            expandedHeight: configuration.layout.expandedHeight,
            compactHeight: configuration.layout.collapsedHeight,
            backgroundColor: configuration.appearance.backgroundColor,
            islandTitle: configuration.content.title is Text
                ? (configuration.content.title as Text).data ?? 'Dynamic Island'
                : 'Dynamic Island',
            islandSubtitle: configuration.content.subtitle is Text
                ? (configuration.content.subtitle as Text).data
                : null,
          );

    return FloatingIslandHeaderWidget(
      title: configuration.content.title,
      leading: configuration.content.leading,
      actions: configuration.content.actions,
      config: typedConfig,
    );
  }
}
