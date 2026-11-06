import 'package:flutter/material.dart';

import '../../experiences/circular_morph_header.dart';
import '../../experiences/disappearing_floating_actions_header.dart';
import '../../experiences/elastic_floating_header.dart';
import '../../experiences/experience_configs.dart';
import '../../experiences/flip_3d_header.dart';
import '../../experiences/morphing_split_header.dart';
import '../app_bar_configuration.dart';
import '../app_bar_controller.dart';
import '../app_bar_model_renderer.dart';
import '../element_resolver.dart';
import '../model_capabilities.dart';

/// Renderer for Style 1: Morphing Split Header.
class MorphingSplitRenderer extends AppBarModelRenderer {
  const MorphingSplitRenderer();

  @override
  ModelCapabilities get capabilities => const ModelCapabilities(
        supportsCurtainSplit: true,
      );

  @override
  AppBarConfiguration get defaultConfiguration => const AppBarConfiguration(
        layout: LayoutConfiguration(expandedHeight: 140.0, collapsedHeight: 60.0),
      );

  @override
  Widget buildSliver({
    required BuildContext context,
    required ResolvedAppBarConfiguration configuration,
    required AppBarController? controller,
  }) {
    final titleWidget = ElementResolver.resolve(
      context: context,
      defaultWidget: configuration.content.title,
      elementConfig: configuration.elements.title,
      progress: controller?.scrollProgress ?? 0.0,
    );

    final leadingWidget = ElementResolver.resolve(
      context: context,
      defaultWidget: configuration.content.leading,
      elementConfig: configuration.elements.leading,
      progress: controller?.scrollProgress ?? 0.0,
    );

    final leftModule = configuration.content.expandedContent ??
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (configuration.content.leading != null) leadingWidget,
            if (configuration.content.title != null)
              Flexible(child: titleWidget),
          ],
        );

    final rightModule = Row(
      mainAxisSize: MainAxisSize.min,
      children: configuration.content.actions,
    );

    return MorphingSplitHeaderWidget(
      leftModule: leftModule,
      rightModule: rightModule,
      compactPill: configuration.content.collapsedContent ??
          (configuration.content.title != null ? titleWidget : null),
      backgroundColor: configuration.appearance.backgroundColor,
      collapsedBackgroundColor: configuration.appearance.collapsedBackgroundColor,
      safeArea: configuration.layout.safeArea,
      config: MorphingSplitConfig(
        expandedHeight: configuration.layout.expandedHeight,
        collapsedHeight: configuration.layout.collapsedHeight,
      ),
    );
  }
}

/// Renderer for Style 2: Elastic Floating Header.
class ElasticFloatingRenderer extends AppBarModelRenderer {
  const ElasticFloatingRenderer();

  @override
  ModelCapabilities get capabilities => const ModelCapabilities(
        supportsDragToExpand: true,
      );

  @override
  AppBarConfiguration get defaultConfiguration => const AppBarConfiguration(
        layout: LayoutConfiguration(expandedHeight: 72.0, collapsedHeight: 56.0),
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

    final subtitle = ElementResolver.resolve(
      context: context,
      defaultWidget: configuration.content.subtitle,
      elementConfig: configuration.elements.subtitle,
      progress: controller?.scrollProgress ?? 0.0,
    );

    final expandedChild = configuration.content.expandedContent ??
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            title,
            if (configuration.content.subtitle != null) subtitle,
          ],
        );

    return SliverToBoxAdapter(
      child: ElasticFloatingHeaderWidget(
        compactChild: configuration.content.collapsedContent ?? title,
        backgroundColor: configuration.appearance.backgroundColor,
        safeArea: configuration.layout.safeArea,
        config: ElasticFloatingConfig(
          height: configuration.layout.expandedHeight,
          compactHeight: configuration.layout.collapsedHeight,
          stiffness: configuration.motion.springPhysics.stiffness,
          damping: configuration.motion.springPhysics.damping,
        ),
        child: expandedChild,
      ),
    );
  }
}

/// Renderer for Style 3: Disappearing Header with Floating Actions.
class DisappearingActionsRenderer extends AppBarModelRenderer {
  const DisappearingActionsRenderer();

  @override
  ModelCapabilities get capabilities => const ModelCapabilities(
        supportsVelocityAutoHide: true,
      );

  @override
  AppBarConfiguration get defaultConfiguration => const AppBarConfiguration(
        layout: LayoutConfiguration(expandedHeight: 180.0, collapsedHeight: 64.0),
      );

  @override
  Widget buildSliver({
    required BuildContext context,
    required ResolvedAppBarConfiguration configuration,
    required AppBarController? controller,
  }) {
    return DisappearingFloatingActionsHeaderWidget(
      title: configuration.content.title ?? const SizedBox.shrink(),
      subtitle: configuration.content.subtitle,
      leading: configuration.content.leading,
      actions: configuration.content.actions,
      safeArea: configuration.layout.safeArea,
      config: DisappearingFloatingActionsConfig(
        expandedHeight: configuration.layout.expandedHeight,
      ),
    );
  }
}

/// Renderer for Style 4: Circular Morph Header.
class CircularMorphRenderer extends AppBarModelRenderer {
  const CircularMorphRenderer();

  @override
  ModelCapabilities get capabilities => const ModelCapabilities(
        supportsShapeMorph: true,
      );

  @override
  AppBarConfiguration get defaultConfiguration => const AppBarConfiguration(
        layout: LayoutConfiguration(expandedHeight: 130.0, collapsedHeight: 54.0),
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

    return CircularMorphHeaderWidget(
      expandedChild: configuration.content.expandedContent ??
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (configuration.content.avatar != null)
                configuration.content.avatar!,
              title,
            ],
          ),
      circularChild: configuration.content.collapsedContent ??
          (configuration.content.avatar ?? const Icon(Icons.circle)),
      backgroundColor: configuration.appearance.backgroundColor,
      safeArea: configuration.layout.safeArea,
      config: CircularMorphConfig(
        expandedHeight: configuration.layout.expandedHeight,
        targetDiameter: configuration.layout.collapsedHeight,
      ),
    );
  }
}

/// Renderer for Style 5: 3D Flip Header.
class Flip3DRenderer extends AppBarModelRenderer {
  const Flip3DRenderer();

  @override
  ModelCapabilities get capabilities => const ModelCapabilities(
        supports3DTransform: true,
      );

  @override
  AppBarConfiguration get defaultConfiguration => const AppBarConfiguration(
        layout: LayoutConfiguration(expandedHeight: 140.0, collapsedHeight: 56.0),
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

    return Flip3DHeaderWidget(
      frontCard: configuration.content.expandedContent ??
          Center(child: title),
      backToolbar: configuration.content.collapsedContent ??
          Row(
            children: [
              if (configuration.content.leading != null)
                configuration.content.leading!,
              Expanded(child: title),
              ...configuration.content.actions,
            ],
          ),
      safeArea: configuration.layout.safeArea,
      config: Flip3DConfig(
        expandedHeight: configuration.layout.expandedHeight,
        collapsedHeight: configuration.layout.collapsedHeight,
      ),
    );
  }
}
