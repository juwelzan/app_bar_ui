import 'package:flutter/material.dart';
import '../../../engine/app_bar_configuration.dart';
import '../../../engine/app_bar_controller.dart';
import '../../../engine/app_bar_model_renderer.dart';
import '../../../engine/model_capabilities.dart';
import 'adaptive_breakpoint_nav_config.dart';
import 'adaptive_breakpoint_nav_header.dart';

/// Universal Engine Renderer for Model 17: Adaptive Breakpoint Navigation.
class AdaptiveBreakpointNavRenderer extends AppBarModelRenderer {
  /// Creates an [AdaptiveBreakpointNavRenderer].
  const AdaptiveBreakpointNavRenderer();

  @override
  ModelCapabilities get capabilities => const ModelCapabilities(
        supportsSticky: true,
        supportsMultiStage: true,
      );

  @override
  AppBarConfiguration get defaultConfiguration => const AppBarConfiguration(
        layout: LayoutConfiguration(expandedHeight: 180.0, collapsedHeight: 58.0),
      );

  @override
  Widget buildSliver({
    required BuildContext context,
    required ResolvedAppBarConfiguration configuration,
    required AppBarController? controller,
  }) {
    final typedConfig = configuration.typedConfig is AdaptiveBreakpointNavConfig
        ? configuration.typedConfig! as AdaptiveBreakpointNavConfig
        : AdaptiveBreakpointNavConfig(
            compactHeight: configuration.layout.expandedHeight,
            mediumHeight: configuration.layout.expandedHeight,
            expandedHeight: configuration.layout.expandedHeight,
            collapsedHeight: configuration.layout.collapsedHeight,
            backgroundColor: configuration.appearance.backgroundColor,
            safeArea: configuration.layout.safeArea,
          );

    return AdaptiveBreakpointNavHeaderWidget(
      title: configuration.content.title,
      leading: configuration.content.leading,
      actions: configuration.content.actions,
      config: typedConfig,
    );
  }
}
