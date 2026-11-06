import 'package:flutter/material.dart';

import '../../experiences/divergent_vector_parallax_zoom_header.dart';
import '../../experiences/dynamic_sine_wave_collapse_header.dart';
import '../../experiences/experience_configs.dart';
import '../../experiences/floating_orbit_sliver_header.dart';
import '../../experiences/multi_slice_accordion_header.dart';
import '../../experiences/theater_curtain_reveal_header.dart';
import '../app_bar_configuration.dart';
import '../app_bar_controller.dart';
import '../app_bar_model_renderer.dart';
import '../element_resolver.dart';
import '../model_capabilities.dart';

/// Renderer for Style 31: Floating Orbit Header.
class FloatingOrbitRenderer extends AppBarModelRenderer {
  const FloatingOrbitRenderer();

  @override
  ModelCapabilities get capabilities => const ModelCapabilities(
        supportsRadialActions: true,
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
      defaultWidget: configuration.content.title ?? const Text('Orbit Header'),
      elementConfig: configuration.elements.title,
      progress: controller?.scrollProgress ?? 0.0,
    );

    final avatar = ElementResolver.resolve(
      context: context,
      defaultWidget: configuration.content.avatar,
      elementConfig: configuration.elements.avatar,
      progress: controller?.scrollProgress ?? 0.0,
    );

    final satellites = <OrbitSatelliteItem>[
      OrbitSatelliteItem(
        icon: Icons.flash_on,
        label: 'Action 1',
        onTap: () {},
      ),
      OrbitSatelliteItem(
        icon: Icons.shield,
        label: 'Action 2',
        onTap: () {},
      ),
      OrbitSatelliteItem(
        icon: Icons.stars,
        label: 'Action 3',
        onTap: () {},
      ),
    ];

    return FloatingOrbitSliverHeaderWidget(
      centralTitle: title,
      centralSubtitle: configuration.content.subtitle,
      centralAvatar: configuration.content.avatar != null ? avatar : null,
      leading: configuration.content.leading,
      satellites: satellites,
      backgroundColor: configuration.appearance.backgroundColor,
      safeArea: configuration.layout.safeArea,
      config: FloatingOrbitSliverConfig(
        expandedHeight: configuration.layout.expandedHeight,
      ),
    );
  }
}

/// Renderer for Style 32: Accordion Multi-Tier Header.
class MultiSliceAccordionRenderer extends AppBarModelRenderer {
  const MultiSliceAccordionRenderer();

  @override
  ModelCapabilities get capabilities => const ModelCapabilities(
        supportsAccordionSlices: true,
      );

  @override
  AppBarConfiguration get defaultConfiguration => const AppBarConfiguration(
        layout: LayoutConfiguration(expandedHeight: 240.0, collapsedHeight: 64.0),
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

    final pinnedBar = Row(
      children: [
        if (configuration.content.leading != null)
          configuration.content.leading!,
        Expanded(child: title),
        ...configuration.content.actions,
      ],
    );

    final slices = <AccordionSliceItem>[
      AccordionSliceItem(
        spec: const AccordionSliceSpec(
          id: 'tier1',
          height: 48.0,
          collapseStartOffset: 0.0,
          collapseEndOffset: 60.0,
        ),
        builder: (ctx, factor) => Center(
          child: Text(
            'Accordion Tier 1',
            style: TextStyle(color: configuration.appearance.foregroundColor),
          ),
        ),
      ),
      AccordionSliceItem(
        spec: const AccordionSliceSpec(
          id: 'tier2',
          height: 48.0,
          collapseStartOffset: 40.0,
          collapseEndOffset: 120.0,
        ),
        builder: (ctx, factor) => Center(
          child: Text(
            'Accordion Tier 2',
            style: TextStyle(color: configuration.appearance.foregroundColor),
          ),
        ),
      ),
    ];

    return MultiSliceAccordionHeaderWidget(
      pinnedBar: pinnedBar,
      slices: slices,
      backgroundColor: configuration.appearance.backgroundColor,
      safeArea: configuration.layout.safeArea,
      config: const MultiSliceAccordionConfig(),
    );
  }
}

/// Renderer for Style 33: Lateral Theater Curtain Reveal Header.
class TheaterCurtainRenderer extends AppBarModelRenderer {
  const TheaterCurtainRenderer();

  @override
  ModelCapabilities get capabilities => const ModelCapabilities(
        supportsCurtainSplit: true,
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
      defaultWidget: configuration.content.title ?? const Text('Stage Hall'),
      elementConfig: configuration.elements.title,
      progress: controller?.scrollProgress ?? 0.0,
    );

    return TheaterCurtainRevealHeaderWidget(
      valenceTitle: title,
      valenceActions: configuration.content.actions,
      stageContent: configuration.content.expandedContent ??
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                title,
                if (configuration.content.subtitle != null)
                  configuration.content.subtitle!,
              ],
            ),
          ),
      config: TheaterCurtainRevealConfig(
        expandedHeight: configuration.layout.expandedHeight,
      ),
    );
  }
}

/// Renderer for Style 34: Divergent Vector Parallax Zoom Hero Header.
class DivergentVectorZoomRenderer extends AppBarModelRenderer {
  const DivergentVectorZoomRenderer();

  @override
  ModelCapabilities get capabilities => const ModelCapabilities(
        supportsParallax: true,
      );

  @override
  AppBarConfiguration get defaultConfiguration => const AppBarConfiguration(
        layout: LayoutConfiguration(expandedHeight: 300.0, collapsedHeight: 64.0),
      );

  @override
  Widget buildSliver({
    required BuildContext context,
    required ResolvedAppBarConfiguration configuration,
    required AppBarController? controller,
  }) {
    final title = ElementResolver.resolve(
      context: context,
      defaultWidget: configuration.content.title ?? const Text('Parallax Zoom'),
      elementConfig: configuration.elements.title,
      progress: controller?.scrollProgress ?? 0.0,
    );

    final backgroundImage = configuration.content.background ??
        Container(
          color: configuration.appearance.backgroundColor ?? Colors.deepPurple,
        );

    return DivergentVectorParallaxZoomHeaderWidget(
      backgroundImage: backgroundImage,
      title: title,
      subtitle: configuration.content.subtitle,
      actions: configuration.content.actions,
      config: const DivergentVectorParallaxZoomConfig(),
    );
  }
}

/// Renderer for Style 35: Dynamic Sine Wave Collapse Header.
class DynamicSineWaveRenderer extends AppBarModelRenderer {
  const DynamicSineWaveRenderer();

  @override
  ModelCapabilities get capabilities => const ModelCapabilities(
        supportsShapeMorph: true,
      );

  @override
  AppBarConfiguration get defaultConfiguration => const AppBarConfiguration(
        layout: LayoutConfiguration(expandedHeight: 240.0, collapsedHeight: 64.0),
      );

  @override
  Widget buildSliver({
    required BuildContext context,
    required ResolvedAppBarConfiguration configuration,
    required AppBarController? controller,
  }) {
    final title = ElementResolver.resolve(
      context: context,
      defaultWidget: configuration.content.title ?? const Text('Tidal Wave'),
      elementConfig: configuration.elements.title,
      progress: controller?.scrollProgress ?? 0.0,
    );

    return DynamicSineWaveCollapseHeaderWidget(
      title: title,
      subtitle: configuration.content.subtitle,
      expandedHero: configuration.content.expandedContent,
      actions: configuration.content.actions,
      config: const DynamicSineWaveCollapseConfig(),
    );
  }
}
