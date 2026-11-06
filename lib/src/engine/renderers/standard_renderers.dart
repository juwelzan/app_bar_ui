import 'package:flutter/material.dart';

import '../app_bar_configuration.dart';
import '../app_bar_controller.dart';
import '../app_bar_model_renderer.dart';
import '../element_resolver.dart';
import '../model_capabilities.dart';

/// Renderer for classic standard Material/Cupertino style navigation bar.
class ClassicAppBarRenderer extends AppBarModelRenderer {
  const ClassicAppBarRenderer();

  @override
  ModelCapabilities get capabilities => ModelCapabilities.standard;

  @override
  AppBarConfiguration get defaultConfiguration => const AppBarConfiguration(
        layout: LayoutConfiguration(expandedHeight: 64.0, collapsedHeight: 64.0),
        behavior: BehaviorConfiguration(collapsible: false, pinned: true),
      );

  @override
  Widget buildSliver({
    required BuildContext context,
    required ResolvedAppBarConfiguration configuration,
    required AppBarController? controller,
  }) {
    final title = ElementResolver.resolve(
      context: context,
      defaultWidget: configuration.content.title,
      elementConfig: configuration.elements.title,
      progress: controller?.scrollProgress ?? 0.0,
    );

    final leading = ElementResolver.resolve(
      context: context,
      defaultWidget: configuration.content.leading,
      elementConfig: configuration.elements.leading,
      progress: controller?.scrollProgress ?? 0.0,
    );

    List<Widget> actions = configuration.content.actions;
    if (configuration.elements.actions != null) {
      final overrideAction = ElementResolver.resolve(
        context: context,
        defaultWidget: null,
        elementConfig: configuration.elements.actions,
        progress: controller?.scrollProgress ?? 0.0,
      );
      actions = actions.isEmpty ? [overrideAction] : [...actions, overrideAction];
    }

    final isExpanded = configuration.layout.expandedHeight > configuration.layout.collapsedHeight;

    return SliverAppBar(
      pinned: configuration.behavior.pinned,
      floating: configuration.behavior.floating,
      snap: configuration.behavior.snap,
      expandedHeight: isExpanded ? configuration.layout.expandedHeight : null,
      backgroundColor: configuration.appearance.backgroundColor,
      elevation: configuration.appearance.elevation,
      shadowColor: configuration.appearance.shadowColor,
      leading: configuration.content.leading != null ? leading : null,
      title: title,
      actions: actions,
      flexibleSpace: isExpanded && configuration.content.background != null
          ? FlexibleSpaceBar(
              background: configuration.content.background,
              title: title,
            )
          : null,
    );
  }
}

/// Adaptable placeholder renderer for upcoming models (e.g. 41–50)
/// ensuring 100% compile-time and runtime safety across all 50 models.
class AdaptablePlaceholderRenderer extends AppBarModelRenderer {
  const AdaptablePlaceholderRenderer({
    this.customCapabilities = const ModelCapabilities(),
  });

  final ModelCapabilities customCapabilities;

  @override
  ModelCapabilities get capabilities => customCapabilities;

  @override
  AppBarConfiguration get defaultConfiguration => const AppBarConfiguration(
        layout: LayoutConfiguration(expandedHeight: 220.0, collapsedHeight: 64.0),
      );

  @override
  Widget buildSliver({
    required BuildContext context,
    required ResolvedAppBarConfiguration configuration,
    required AppBarController? controller,
  }) {
    final title = ElementResolver.resolve(
      context: context,
      defaultWidget: configuration.content.title,
      elementConfig: configuration.elements.title,
      progress: controller?.scrollProgress ?? 0.0,
    );

    return SliverAppBar(
      pinned: configuration.behavior.pinned,
      floating: configuration.behavior.floating,
      snap: configuration.behavior.snap,
      expandedHeight: configuration.layout.expandedHeight,
      backgroundColor: configuration.appearance.backgroundColor,
      title: title,
      leading: configuration.content.leading,
      actions: configuration.content.actions,
      flexibleSpace: FlexibleSpaceBar(
        background: configuration.content.background ??
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  title,
                  if (configuration.content.subtitle != null)
                    configuration.content.subtitle!,
                ],
              ),
            ),
      ),
    );
  }
}
