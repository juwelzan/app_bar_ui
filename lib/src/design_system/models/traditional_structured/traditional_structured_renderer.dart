import 'package:flutter/material.dart';
import '../../../engine/app_bar_configuration.dart';
import '../../../engine/app_bar_controller.dart';
import '../../../engine/app_bar_model_renderer.dart';
import '../../../engine/model_capabilities.dart';
import 'traditional_structured_config.dart';
import 'traditional_structured_header.dart';

/// Universal Engine Renderer for Model 1: Traditional Structured Navigation.
class TraditionalStructuredRenderer extends AppBarModelRenderer {
  const TraditionalStructuredRenderer();

  @override
  ModelCapabilities get capabilities => const ModelCapabilities(
        supportsSticky: true,
        supportsMultiStage: true,
      );

  @override
  AppBarConfiguration get defaultConfiguration => const AppBarConfiguration(
        layout: LayoutConfiguration(expandedHeight: 170.0, collapsedHeight: 56.0),
      );

  @override
  Widget buildSliver({
    required BuildContext context,
    required ResolvedAppBarConfiguration configuration,
    required AppBarController? controller,
  }) {
    // If developer passed a strongly-typed TraditionalStructuredConfig, respect it directly
    final typedConfig = configuration.typedConfig is TraditionalStructuredConfig
        ? configuration.typedConfig! as TraditionalStructuredConfig
        : TraditionalStructuredConfig(
            expandedHeight: configuration.layout.expandedHeight,
            collapsedHeight: configuration.layout.collapsedHeight,
            backgroundColor: configuration.appearance.backgroundColor,
            organizationName: (configuration.content.title is Text
                    ? (configuration.content.title as Text).data
                    : null) ??
                'Organization',
            safeArea: configuration.layout.safeArea,
          );

    return TraditionalStructuredHeaderWidget(
      title: configuration.content.title,
      leading: configuration.content.leading,
      actions: configuration.content.actions,
      config: typedConfig,
    );
  }
}
