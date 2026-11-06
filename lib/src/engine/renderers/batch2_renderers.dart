import 'package:flutter/material.dart';

import '../../experiences/expanding_hero_card_header.dart';
import '../../experiences/experience_configs.dart';
import '../../experiences/horizontal_sliding_panels_header.dart';
import '../../experiences/layered_depth_parallax_header.dart';
import '../../experiences/liquid_wave_morph_header.dart';
import '../../experiences/vertical_folding_accordion_header.dart';
import '../app_bar_configuration.dart';
import '../app_bar_controller.dart';
import '../app_bar_model_renderer.dart';
import '../element_resolver.dart';
import '../model_capabilities.dart';

/// Renderer for Style 6: Horizontal Sliding Header.
class HorizontalSlidingRenderer extends AppBarModelRenderer {
  const HorizontalSlidingRenderer();

  @override
  ModelCapabilities get capabilities => const ModelCapabilities();

  @override
  AppBarConfiguration get defaultConfiguration => const AppBarConfiguration(
        layout: LayoutConfiguration(expandedHeight: 155.0, collapsedHeight: 60.0),
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

    final panelLeft = configuration.content.expandedContent ??
        (configuration.content.subtitle ?? const Text('Sliding Panel Left'));

    return HorizontalSlidingPanelsHeaderWidget(
      pinnedBar: pinnedBar,
      slidingPanelLeft: panelLeft,
      slidingPanelRight: configuration.content.decorative.isNotEmpty
          ? configuration.content.decorative.first
          : null,
      backgroundColor: configuration.appearance.backgroundColor,
      safeArea: configuration.layout.safeArea,
      config: HorizontalSlidingPanelsConfig(
        expandedHeight: configuration.layout.expandedHeight,
        collapsedHeight: configuration.layout.collapsedHeight,
      ),
    );
  }
}

/// Renderer for Style 7: Vertical Folding Accordion Header.
class VerticalFoldingRenderer extends AppBarModelRenderer {
  const VerticalFoldingRenderer();

  @override
  ModelCapabilities get capabilities => const ModelCapabilities(
        supportsAccordionSlices: true,
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

    final pinnedToolbar = Row(
      children: [
        if (configuration.content.leading != null)
          configuration.content.leading!,
        Expanded(child: title),
        ...configuration.content.actions,
      ],
    );

    final foldingTier = configuration.content.expandedContent ??
        (configuration.content.subtitle != null
            ? Padding(
                padding: const EdgeInsets.all(16.0),
                child: configuration.content.subtitle!,
              )
            : const SizedBox.shrink());

    return VerticalFoldingAccordionHeaderWidget(
      pinnedToolbar: pinnedToolbar,
      foldingTier: foldingTier,
      backgroundColor: configuration.appearance.backgroundColor,
      safeArea: configuration.layout.safeArea,
      config: VerticalFoldingAccordionConfig(
        expandedHeight: configuration.layout.expandedHeight,
        collapsedHeight: configuration.layout.collapsedHeight,
      ),
    );
  }
}

/// Renderer for Style 8: Layered Depth Parallax Header.
class LayeredDepthRenderer extends AppBarModelRenderer {
  const LayeredDepthRenderer();

  @override
  ModelCapabilities get capabilities => const ModelCapabilities(
        supportsParallax: true,
      );

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
    final title = ElementResolver.resolve(
      context: context,
      defaultWidget: configuration.content.title,
      elementConfig: configuration.elements.title,
      progress: controller?.scrollProgress ?? 0.0,
    );

    final foreground = Row(
      children: [
        if (configuration.content.leading != null)
          configuration.content.leading!,
        Expanded(child: title),
        ...configuration.content.actions,
      ],
    );

    return LayeredDepthParallaxHeaderWidget(
      backgroundLayer: configuration.content.background ??
          Container(
            color: configuration.appearance.backgroundColor ?? Colors.blueGrey.shade900,
          ),
      midgroundLayer: configuration.content.decorative.isNotEmpty
          ? configuration.content.decorative.first
          : const SizedBox.shrink(),
      foregroundLayer: configuration.content.expandedContent ?? foreground,
      backgroundColor: configuration.appearance.backgroundColor,
      safeArea: configuration.layout.safeArea,
      config: LayeredDepthParallaxConfig(
        expandedHeight: configuration.layout.expandedHeight,
        collapsedHeight: configuration.layout.collapsedHeight,
      ),
    );
  }
}

/// Renderer for Style 9: Expanding Hero-to-Toolbar Header.
class ExpandingHeroRenderer extends AppBarModelRenderer {
  const ExpandingHeroRenderer();

  @override
  ModelCapabilities get capabilities => const ModelCapabilities(
        supportsParallax: true,
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

    final heroCardContent = configuration.content.expandedContent ??
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              title,
              if (configuration.content.subtitle != null)
                configuration.content.subtitle!,
            ],
          ),
        );

    final dockedToolbarContent = configuration.content.collapsedContent ??
        Row(
          children: [
            if (configuration.content.leading != null)
              configuration.content.leading!,
            Expanded(child: title),
            ...configuration.content.actions,
          ],
        );

    return ExpandingHeroCardHeaderWidget(
      heroCardContent: heroCardContent,
      dockedToolbarContent: dockedToolbarContent,
      cardColor: configuration.appearance.backgroundColor,
      safeArea: configuration.layout.safeArea,
      config: ExpandingHeroCardConfig(
        expandedHeight: configuration.layout.expandedHeight,
        collapsedHeight: configuration.layout.collapsedHeight,
      ),
    );
  }
}

/// Renderer for Style 10: Liquid Wave Morph Header.
class LiquidWaveRenderer extends AppBarModelRenderer {
  const LiquidWaveRenderer();

  @override
  ModelCapabilities get capabilities => const ModelCapabilities(
        supportsShapeMorph: true,
      );

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
    final title = ElementResolver.resolve(
      context: context,
      defaultWidget: configuration.content.title,
      elementConfig: configuration.elements.title,
      progress: controller?.scrollProgress ?? 0.0,
    );

    final child = configuration.content.expandedContent ??
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

    return LiquidWaveMorphHeaderWidget(
      compactTitle: configuration.content.collapsedContent ?? title,
      backgroundColor: configuration.appearance.backgroundColor,
      safeArea: configuration.layout.safeArea,
      config: LiquidWaveMorphConfig(
        expandedHeight: configuration.layout.expandedHeight,
        collapsedHeight: configuration.layout.collapsedHeight,
      ),
      child: child,
    );
  }
}
