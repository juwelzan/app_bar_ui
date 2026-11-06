import 'package:flutter/material.dart';
import '../../../engine/app_bar_configuration.dart';
import '../../../engine/app_bar_controller.dart';
import '../../../engine/app_bar_model_renderer.dart';
import '../../../engine/model_capabilities.dart';
import 'context_focal_swap_nav_config.dart';
import 'context_focal_swap_nav_header.dart';

/// Universal Engine Renderer for Model 18: Context Focal Swap Navigation.
class ContextFocalSwapNavRenderer extends AppBarModelRenderer {
  /// Creates a [ContextFocalSwapNavRenderer].
  const ContextFocalSwapNavRenderer();

  @override
  ModelCapabilities get capabilities => const ModelCapabilities(
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
    final typedConfig = configuration.typedConfig is ContextFocalSwapNavConfig
        ? configuration.typedConfig! as ContextFocalSwapNavConfig
        : ContextFocalSwapNavConfig(
            expandedHeight: configuration.layout.expandedHeight,
            collapsedHeight: configuration.layout.collapsedHeight,
            backgroundColor: configuration.appearance.backgroundColor,
            safeArea: configuration.layout.safeArea,
          );

    return ContextFocalSwapNavHeaderWidget(
      title: configuration.content.title,
      leading: configuration.content.leading,
      actions: configuration.content.actions,
      config: typedConfig,
    );
  }
}

