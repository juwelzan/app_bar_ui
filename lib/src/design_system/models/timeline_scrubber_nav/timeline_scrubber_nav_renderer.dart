import 'package:flutter/material.dart';
import '../../../engine/app_bar_configuration.dart';
import '../../../engine/app_bar_controller.dart';
import '../../../engine/app_bar_model_renderer.dart';
import '../../../engine/model_capabilities.dart';
import 'timeline_scrubber_nav_config.dart';
import 'timeline_scrubber_nav_header.dart';

/// Universal Engine Renderer for Model 14: Interactive Timeline Scrubber Navigation.
class TimelineScrubberNavRenderer extends AppBarModelRenderer {
  /// Creates a [TimelineScrubberNavRenderer].
  const TimelineScrubberNavRenderer();

  @override
  ModelCapabilities get capabilities => const ModelCapabilities(
        supportsSticky: true,
        supportsMultiStage: true,
      );

  @override
  AppBarConfiguration get defaultConfiguration => const AppBarConfiguration(
        layout: LayoutConfiguration(expandedHeight: 190.0, collapsedHeight: 58.0),
      );

  @override
  Widget buildSliver({
    required BuildContext context,
    required ResolvedAppBarConfiguration configuration,
    required AppBarController? controller,
  }) {
    final typedConfig = configuration.typedConfig is TimelineScrubberNavConfig
        ? configuration.typedConfig! as TimelineScrubberNavConfig
        : TimelineScrubberNavConfig(
            expandedHeight: configuration.layout.expandedHeight,
            collapsedHeight: configuration.layout.collapsedHeight,
            backgroundColor: configuration.appearance.backgroundColor,
            safeArea: configuration.layout.safeArea,
          );

    return TimelineScrubberNavHeaderWidget(
      title: configuration.content.title,
      leading: configuration.content.leading,
      actions: configuration.content.actions,
      config: typedConfig,
    );
  }
}

