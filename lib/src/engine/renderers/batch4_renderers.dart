import 'package:flutter/material.dart';

import '../../experiences/experience_configs.dart';
import '../../experiences/magnetic_scroll_snap_header.dart';
import '../../experiences/parallax_zoom_hero_header.dart';
import '../../experiences/pull_down_disclosure_canvas_header.dart';
import '../../experiences/radial_orbital_action_header.dart';
import '../../experiences/split_screen_lateral_reveal_header.dart';
import '../app_bar_configuration.dart';
import '../app_bar_controller.dart';
import '../app_bar_model_renderer.dart';
import '../element_resolver.dart';
import '../model_capabilities.dart';

/// Renderer for Style 16: Radial / Orbital Action Header.
class RadialOrbitRenderer extends AppBarModelRenderer {
  const RadialOrbitRenderer();

  @override
  ModelCapabilities get capabilities => const ModelCapabilities(
        supportsRadialActions: true,
      );

  @override
  AppBarConfiguration get defaultConfiguration => const AppBarConfiguration(
        layout: LayoutConfiguration(expandedHeight: 180.0, collapsedHeight: 60.0),
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

    final anchor = ElementResolver.resolve(
      context: context,
      defaultWidget: configuration.content.avatar ??
          const CircleAvatar(
            radius: 28.0,
            child: Icon(Icons.hub_outlined),
          ),
      elementConfig: configuration.elements.avatar,
      progress: controller?.scrollProgress ?? 0.0,
    );

    return RadialOrbitalActionHeaderWidget(
      centerAnchor: anchor,
      title: title,
      actions: configuration.content.actions,
      backgroundColor: configuration.appearance.backgroundColor,
      safeArea: configuration.layout.safeArea,
      config: RadialOrbitalActionConfig(
        expandedHeight: configuration.layout.expandedHeight,
        collapsedHeight: configuration.layout.collapsedHeight,
      ),
    );
  }
}

/// Renderer for Style 17: Split-Screen Lateral Reveal Header.
class SplitCurtainRenderer extends AppBarModelRenderer {
  const SplitCurtainRenderer();

  @override
  ModelCapabilities get capabilities => const ModelCapabilities(
        supportsCurtainSplit: true,
      );

  @override
  AppBarConfiguration get defaultConfiguration => const AppBarConfiguration(
        layout: LayoutConfiguration(expandedHeight: 190.0, collapsedHeight: 60.0),
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

    final centerShowcase = configuration.content.expandedContent ??
        Container(
          width: 140.0,
          height: 140.0,
          decoration: BoxDecoration(
            color: configuration.appearance.backgroundColor ?? Colors.amber.shade700,
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: const Center(
            child: Icon(Icons.movie_creation, size: 54.0, color: Colors.white),
          ),
        );

    final leftCurtain = Container(
      color: Colors.blueGrey.shade800,
      padding: const EdgeInsets.all(16.0),
      alignment: Alignment.centerLeft,
      child: const Text('LEFT\nWING', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
    );

    final rightCurtain = Container(
      color: Colors.blueGrey.shade700,
      padding: const EdgeInsets.all(16.0),
      alignment: Alignment.centerRight,
      child: const Text('RIGHT\nWING', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
    );

    final compactToolbar = Row(
      children: [
        if (configuration.content.leading != null)
          configuration.content.leading!,
        Expanded(child: title),
        ...configuration.content.actions,
      ],
    );

    return SplitScreenLateralRevealHeaderWidget(
      centerShowcase: centerShowcase,
      leftCurtain: leftCurtain,
      rightCurtain: rightCurtain,
      compactToolbar: compactToolbar,
      safeArea: configuration.layout.safeArea,
      config: SplitScreenLateralRevealConfig(
        expandedHeight: configuration.layout.expandedHeight,
        collapsedHeight: configuration.layout.collapsedHeight,
      ),
    );
  }
}

/// Renderer for Style 18: Scroll-Snap Header.
class MagneticSnapRenderer extends AppBarModelRenderer {
  const MagneticSnapRenderer();

  @override
  ModelCapabilities get capabilities => const ModelCapabilities(
        supportsMagneticSnap: true,
      );

  @override
  AppBarConfiguration get defaultConfiguration => const AppBarConfiguration(
        layout: LayoutConfiguration(expandedHeight: 200.0, collapsedHeight: 60.0),
        behavior: BehaviorConfiguration(snap: true),
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

    final expandedContent = configuration.content.expandedContent ??
        Center(child: title);

    final collapsedContent = configuration.content.collapsedContent ??
        Row(
          children: [
            if (configuration.content.leading != null)
              configuration.content.leading!,
            Expanded(child: title),
            ...configuration.content.actions,
          ],
        );

    return MagneticScrollSnapHeaderWidget(
      expandedContent: expandedContent,
      collapsedContent: collapsedContent,
      safeArea: configuration.layout.safeArea,
      config: MagneticScrollSnapConfig(
        expandedHeight: configuration.layout.expandedHeight,
        collapsedHeight: configuration.layout.collapsedHeight,
      ),
    );
  }
}

/// Renderer for Style 19: Parallax Zoom Hero Header.
class ParallaxZoomRenderer extends AppBarModelRenderer {
  const ParallaxZoomRenderer();

  @override
  ModelCapabilities get capabilities => const ModelCapabilities(
        supportsParallax: true,
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
    final title = ElementResolver.resolve(
      context: context,
      defaultWidget: configuration.content.title,
      elementConfig: configuration.elements.title,
      progress: controller?.scrollProgress ?? 0.0,
    );

    final heroVisual = configuration.content.background ??
        Container(
          color: configuration.appearance.backgroundColor ?? Colors.deepPurple,
          child: const Center(
            child: Icon(Icons.camera_alt, size: 72.0, color: Colors.white38),
          ),
        );

    final foregroundOverlay = configuration.content.expandedContent ??
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              title,
              if (configuration.content.subtitle != null)
                configuration.content.subtitle!,
            ],
          ),
        );

    return ParallaxZoomHeroHeaderWidget(
      heroVisual: heroVisual,
      foregroundOverlay: foregroundOverlay,
      compactTitle: configuration.content.collapsedContent ?? title,
      safeArea: configuration.layout.safeArea,
      config: ParallaxZoomHeroConfig(
        expandedHeight: configuration.layout.expandedHeight,
        collapsedHeight: configuration.layout.collapsedHeight,
      ),
    );
  }
}

/// Renderer for Style 20: Pull-Down Disclosure Canvas Header.
class PullDownDisclosureRenderer extends AppBarModelRenderer {
  const PullDownDisclosureRenderer();

  @override
  ModelCapabilities get capabilities => const ModelCapabilities(
        supportsDragToExpand: true,
      );

  @override
  AppBarConfiguration get defaultConfiguration => const AppBarConfiguration(
        layout: LayoutConfiguration(expandedHeight: 200.0, collapsedHeight: 64.0),
        behavior: BehaviorConfiguration(pullToExpand: true),
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

    final restingHeader = configuration.content.collapsedContent ??
        Row(
          children: [
            if (configuration.content.leading != null)
              configuration.content.leading!,
            Expanded(child: title),
            ...configuration.content.actions,
          ],
        );

    final disclosureCanvas = configuration.content.expandedContent ??
        Center(
          child: Text(
            'Pull down to reveal hidden controls',
            style: TextStyle(color: configuration.appearance.foregroundColor),
          ),
        );

    return SliverToBoxAdapter(
      child: PullDownDisclosureCanvasHeaderWidget(
        restingHeaderContent: restingHeader,
        disclosureCanvasContent: disclosureCanvas,
        safeArea: configuration.layout.safeArea,
        config: PullDownDisclosureCanvasConfig(
          restingHeight: configuration.layout.collapsedHeight,
          disclosureCanvasHeight: configuration.layout.expandedHeight,
        ),
      ),
    );
  }
}
