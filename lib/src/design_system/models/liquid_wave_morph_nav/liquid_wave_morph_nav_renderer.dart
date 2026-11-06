import 'package:flutter/material.dart';
import '../../../engine/app_bar_configuration.dart';
import '../../../engine/app_bar_controller.dart';
import '../../../engine/app_bar_model_renderer.dart';
import '../../../engine/model_capabilities.dart';
import 'liquid_wave_morph_nav_config.dart';
import 'liquid_wave_morph_nav_header.dart';

/// Universal Engine Renderer for Model 19: Liquid Wave Morph Navigation.
class LiquidWaveMorphNavRenderer extends AppBarModelRenderer {
  /// Creates a [LiquidWaveMorphNavRenderer].
  const LiquidWaveMorphNavRenderer();

  @override
  ModelCapabilities get capabilities => const ModelCapabilities(
        supportsShapeMorph: true,
        supportsSticky: true,
      );

  @override
  AppBarConfiguration get defaultConfiguration => const AppBarConfiguration(
        layout: LayoutConfiguration(expandedHeight: 220.0, collapsedHeight: 60.0),
      );

  @override
  Widget buildSliver({
    required BuildContext context,
    required ResolvedAppBarConfiguration configuration,
    required AppBarController? controller,
  }) {
    final typedConfig = configuration.typedConfig is LiquidWaveMorphNavConfig
        ? configuration.typedConfig! as LiquidWaveMorphNavConfig
        : LiquidWaveMorphNavConfig(
            expandedHeight: configuration.layout.expandedHeight,
            collapsedHeight: configuration.layout.collapsedHeight,
            backgroundColor: configuration.appearance.backgroundColor,
            safeArea: configuration.layout.safeArea,
          );

    return LiquidWaveMorphNavHeaderWidget(
      title: configuration.content.title,
      leading: configuration.content.leading,
      actions: configuration.content.actions,
      config: typedConfig,
    );
  }
}

