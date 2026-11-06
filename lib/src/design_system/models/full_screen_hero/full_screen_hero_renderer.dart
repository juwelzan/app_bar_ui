import 'package:flutter/material.dart';
import '../../../engine/app_bar_configuration.dart';
import '../../../engine/app_bar_controller.dart';
import '../../../engine/app_bar_model_renderer.dart';
import '../../../engine/model_capabilities.dart';
import 'full_screen_hero_config.dart';
import 'full_screen_hero_header.dart';

/// Universal Engine Renderer for Model 2: Full-Screen Hero Cinematic Navigation.
class FullScreenHeroRenderer extends AppBarModelRenderer {
  const FullScreenHeroRenderer();

  @override
  ModelCapabilities get capabilities => const ModelCapabilities(
        supportsParallax: true,
        supportsDragToExpand: true,
      );

  @override
  AppBarConfiguration get defaultConfiguration => const AppBarConfiguration(
        layout: LayoutConfiguration(expandedHeight: 480.0, collapsedHeight: 64.0),
      );

  @override
  Widget buildSliver({
    required BuildContext context,
    required ResolvedAppBarConfiguration configuration,
    required AppBarController? controller,
  }) {
    final typedConfig = configuration.typedConfig is FullScreenHeroConfig
        ? configuration.typedConfig! as FullScreenHeroConfig
        : FullScreenHeroConfig(
            customViewportHeight: configuration.layout.expandedHeight,
            collapsedHeight: configuration.layout.collapsedHeight,
            backgroundColor: configuration.appearance.backgroundColor ?? Colors.black,
            heroMedia: configuration.content.background,
            headline: configuration.content.title is Text
                ? (configuration.content.title as Text).data ?? 'Cinematic Hero'
                : 'Cinematic Hero',
            tagline: configuration.content.subtitle is Text
                ? (configuration.content.subtitle as Text).data
                : null,
          );

    return FullScreenHeroHeaderWidget(
      title: configuration.content.title,
      leading: configuration.content.leading,
      actions: configuration.content.actions,
      config: typedConfig,
    );
  }
}
