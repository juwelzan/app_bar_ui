import 'package:flutter/material.dart';

import '../../experiences/detached_damped_island_header.dart';
import '../../experiences/dispersing_letter_scatter_header.dart';
import '../../experiences/experience_configs.dart';
import '../../experiences/full_bleed_hero_scale_header.dart';
import '../../experiences/perspective_velocity_tilt_header.dart';
import '../../experiences/polygon_to_rectangle_morph_header.dart';
import '../app_bar_configuration.dart';
import '../app_bar_controller.dart';
import '../app_bar_model_renderer.dart';
import '../element_resolver.dart';
import '../model_capabilities.dart';

/// Renderer for Style 41: Perspective Depth Velocity Tilt Header.
class PerspectiveVelocityTiltRenderer extends AppBarModelRenderer {
  const PerspectiveVelocityTiltRenderer();

  @override
  ModelCapabilities get capabilities => const ModelCapabilities(
        supports3DTransform: true,
      );

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
      defaultWidget: configuration.content.title ?? const Text('Velocity Tilt'),
      elementConfig: configuration.elements.title,
      progress: controller?.scrollProgress ?? 0.0,
    );

    return PerspectiveVelocityTiltHeaderWidget(
      title: title,
      subtitle: configuration.content.subtitle,
      leading: configuration.content.leading,
      actions: configuration.content.actions,
      expandedContent: configuration.content.expandedContent,
      backgroundColor: configuration.appearance.backgroundColor,
      safeArea: configuration.layout.safeArea,
      config: PerspectiveVelocityTiltConfig(
        expandedHeight: configuration.layout.expandedHeight,
        collapsedHeight: configuration.layout.collapsedHeight,
      ),
    );
  }
}

/// Renderer for Style 42: Animated Typography Dispersing Letter Scatter Header.
class DispersingLetterScatterRenderer extends AppBarModelRenderer {
  const DispersingLetterScatterRenderer();

  @override
  ModelCapabilities get capabilities => const ModelCapabilities();

  @override
  AppBarConfiguration get defaultConfiguration => const AppBarConfiguration(
        layout: LayoutConfiguration(expandedHeight: 200.0, collapsedHeight: 64.0),
      );

  @override
  Widget buildSliver({
    required BuildContext context,
    required ResolvedAppBarConfiguration configuration,
    required AppBarController? controller,
  }) {
    final titleText = configuration.content.title is Text
        ? (configuration.content.title as Text).data ?? 'SCATTER'
        : 'SCATTER';

    return DispersingLetterScatterHeaderWidget(
      titleText: titleText,
      subtitle: configuration.content.subtitle,
      leading: configuration.content.leading,
      actions: configuration.content.actions,
      backgroundColor: configuration.appearance.backgroundColor,
      safeArea: configuration.layout.safeArea,
      config: DispersingLetterScatterConfig(
        expandedHeight: configuration.layout.expandedHeight,
        collapsedHeight: configuration.layout.collapsedHeight,
      ),
    );
  }
}

/// Renderer for Style 43: Scroll-Driven Shape Polygon-To-Rectangle Morph Header.
class PolygonToRectangleMorphRenderer extends AppBarModelRenderer {
  const PolygonToRectangleMorphRenderer();

  @override
  ModelCapabilities get capabilities => const ModelCapabilities(
        supportsShapeMorph: true,
      );

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
      defaultWidget: configuration.content.title ?? const Text('Polygon Morph'),
      elementConfig: configuration.elements.title,
      progress: controller?.scrollProgress ?? 0.0,
    );

    final polygonContent = configuration.content.expandedContent ??
        Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              title,
              if (configuration.content.subtitle != null)
                configuration.content.subtitle!,
            ],
          ),
        );

    final dockedContent = configuration.content.collapsedContent ??
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: [
              if (configuration.content.leading != null)
                configuration.content.leading!,
              Expanded(child: title),
              ...configuration.content.actions,
            ],
          ),
        );

    return PolygonToRectangleMorphHeaderWidget(
      polygonContent: polygonContent,
      dockedContent: dockedContent,
      backgroundColor: configuration.appearance.backgroundColor,
      safeArea: configuration.layout.safeArea,
      config: PolygonToRectangleMorphConfig(
        expandedHeight: configuration.layout.expandedHeight,
        collapsedHeight: configuration.layout.collapsedHeight,
      ),
    );
  }
}

/// Renderer for Style 44: Detached Damped Floating Island Header.
class DetachedDampedIslandRenderer extends AppBarModelRenderer {
  const DetachedDampedIslandRenderer();

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
      defaultWidget: configuration.content.title ?? const Text('Floating Island'),
      elementConfig: configuration.elements.title,
      progress: controller?.scrollProgress ?? 0.0,
    );

    final child = configuration.content.expandedContent ??
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: [
              if (configuration.content.leading != null)
                configuration.content.leading!,
              Expanded(child: title),
              ...configuration.content.actions,
            ],
          ),
        );

    final compactChild = configuration.content.collapsedContent ??
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.circle, size: 14.0, color: Colors.teal),
              const SizedBox(width: 6.0),
              title,
            ],
          ),
        );

    return DetachedDampedIslandHeaderWidget(
      compactChild: compactChild,
      backgroundColor: configuration.appearance.backgroundColor,
      safeArea: configuration.layout.safeArea,
      config: DetachedDampedIslandConfig(
        expandedHeight: configuration.layout.expandedHeight,
        collapsedHeight: configuration.layout.collapsedHeight,
      ),
      child: child,
    );
  }
}

/// Renderer for Style 45: Full Bleed Edge-To-Edge Hero Scale Header.
class FullBleedHeroScaleRenderer extends AppBarModelRenderer {
  const FullBleedHeroScaleRenderer();

  @override
  ModelCapabilities get capabilities => const ModelCapabilities(
        supportsParallax: true,
      );

  @override
  AppBarConfiguration get defaultConfiguration => const AppBarConfiguration(
        layout: LayoutConfiguration(expandedHeight: 280.0, collapsedHeight: 64.0),
      );

  @override
  Widget buildSliver({
    required BuildContext context,
    required ResolvedAppBarConfiguration configuration,
    required AppBarController? controller,
  }) {
    final title = ElementResolver.resolve(
      context: context,
      defaultWidget: configuration.content.title ?? const Text('Full Bleed Hero'),
      elementConfig: configuration.elements.title,
      progress: controller?.scrollProgress ?? 0.0,
    );

    final heroCover = configuration.content.background ??
        Container(
          color: configuration.appearance.backgroundColor ?? Colors.deepOrange.shade900,
          child: const Center(
            child: Icon(Icons.panorama, size: 100.0, color: Colors.white24),
          ),
        );

    return FullBleedHeroScaleHeaderWidget(
      heroCover: heroCover,
      title: title,
      subtitle: configuration.content.subtitle,
      leading: configuration.content.leading,
      actions: configuration.content.actions,
      config: FullBleedHeroScaleConfig(
        expandedHeight: configuration.layout.expandedHeight,
        collapsedHeight: configuration.layout.collapsedHeight,
      ),
    );
  }
}
