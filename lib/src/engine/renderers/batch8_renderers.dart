import 'package:flutter/material.dart';

import '../../experiences/cascading_progressive_pin_header.dart';
import '../../experiences/depth_overlap_stacked_panel_header.dart';
import '../../experiences/dual_mode_3d_crossfade_header.dart';
import '../../experiences/experience_configs.dart';
import '../../experiences/magnetic_anchor_snap_header.dart';
import '../../experiences/radial_circular_clipper_reveal_header.dart';
import '../app_bar_configuration.dart';
import '../app_bar_controller.dart';
import '../app_bar_model_renderer.dart';
import '../element_resolver.dart';
import '../model_capabilities.dart';

/// Renderer for Style 36: Magnetic Anchor Snap Header.
class MagneticAnchorSnapRenderer extends AppBarModelRenderer {
  const MagneticAnchorSnapRenderer();

  @override
  ModelCapabilities get capabilities => const ModelCapabilities(
        supportsMagneticSnap: true,
      );

  @override
  AppBarConfiguration get defaultConfiguration => const AppBarConfiguration(
        layout: LayoutConfiguration(expandedHeight: 240.0, collapsedHeight: 64.0),
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
      defaultWidget: configuration.content.title ?? const Text('Magnetic Anchor'),
      elementConfig: configuration.elements.title,
      progress: controller?.scrollProgress ?? 0.0,
    );

    final badge = ElementResolver.resolve(
      context: context,
      defaultWidget: configuration.content.avatar ??
          const CircleAvatar(
            radius: 26.0,
            backgroundColor: Colors.teal,
            child: Icon(Icons.flash_on, color: Colors.white),
          ),
      elementConfig: configuration.elements.avatar,
      progress: controller?.scrollProgress ?? 0.0,
    );

    return MagneticAnchorSnapHeaderWidget(
      heroTitle: title,
      heroBadge: badge,
      heroSubtitle: configuration.content.subtitle,
      dockedLeading: configuration.content.leading,
      dockedActions: configuration.content.actions,
      backgroundColor: configuration.appearance.backgroundColor,
      safeArea: configuration.layout.safeArea,
      config: MagneticAnchorSnapConfig(
        expandedHeight: configuration.layout.expandedHeight,
      ),
    );
  }
}

/// Renderer for Style 37: Cascading Progressive Pin Header.
class CascadingProgressivePinRenderer extends AppBarModelRenderer {
  const CascadingProgressivePinRenderer();

  @override
  ModelCapabilities get capabilities => const ModelCapabilities(
        supportsMultiStage: true,
        supportsSticky: true,
      );

  @override
  AppBarConfiguration get defaultConfiguration => const AppBarConfiguration(
        layout: LayoutConfiguration(expandedHeight: 260.0, collapsedHeight: 64.0),
      );

  @override
  Widget buildSliver({
    required BuildContext context,
    required ResolvedAppBarConfiguration configuration,
    required AppBarController? controller,
  }) {
    final title = ElementResolver.resolve(
      context: context,
      defaultWidget: configuration.content.title ?? const Text('Security Ops Center'),
      elementConfig: configuration.elements.title,
      progress: controller?.scrollProgress ?? 0.0,
    );

    final searchBar = configuration.content.searchField ??
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          decoration: BoxDecoration(
            color: Colors.grey.withAlpha(40),
            borderRadius: BorderRadius.circular(19.0),
          ),
          child: const Row(
            children: [
              Icon(Icons.search, size: 18.0),
              SizedBox(width: 6.0),
              Expanded(
                child: Text('Search...', style: TextStyle(fontSize: 12.0)),
              ),
            ],
          ),
        );

    final statusPills = Row(
      mainAxisSize: MainAxisSize.min,
      children: configuration.content.actions.isNotEmpty
          ? configuration.content.actions
          : const [
              Chip(label: Text('Active')),
              SizedBox(width: 6.0),
              Chip(label: Text('Zero Threats')),
            ],
    );

    return CascadingProgressivePinHeaderWidget(
      title: title,
      searchBar: searchBar,
      statusPills: statusPills,
      leading: configuration.content.leading,
      backgroundColor: configuration.appearance.backgroundColor,
      safeArea: configuration.layout.safeArea,
      config: CascadingProgressivePinConfig(
        expandedHeight: configuration.layout.expandedHeight,
      ),
    );
  }
}

/// Renderer for Style 38: Dual-Mode 3D Crossfade Header.
class DualMode3DCrossfadeRenderer extends AppBarModelRenderer {
  const DualMode3DCrossfadeRenderer();

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
      defaultWidget: configuration.content.title ?? const Text('3D Mode'),
      elementConfig: configuration.elements.title,
      progress: controller?.scrollProgress ?? 0.0,
    );

    final primaryMode = configuration.content.expandedContent ??
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

    final secondaryMode = configuration.content.collapsedContent ??
        Row(
          children: [
            if (configuration.content.leading != null)
              configuration.content.leading!,
            Expanded(child: title),
            ...configuration.content.actions,
          ],
        );

    return DualMode3DCrossfadeHeaderWidget(
      primaryMode: primaryMode,
      secondaryMode: secondaryMode,
      backgroundColor: configuration.appearance.backgroundColor,
      safeArea: configuration.layout.safeArea,
      config: DualMode3DCrossfadeConfig(
        transitionThreshold: configuration.layout.expandedHeight / 2.0,
      ),
    );
  }
}

/// Renderer for Style 39: Radial Circular Clipper Reveal Header.
class RadialCircularClipperRevealRenderer extends AppBarModelRenderer {
  const RadialCircularClipperRevealRenderer();

  @override
  ModelCapabilities get capabilities => const ModelCapabilities(
        supportsCircularClipper: true,
        supportsShapeMorph: true,
      );

  @override
  AppBarConfiguration get defaultConfiguration => const AppBarConfiguration(
        layout: LayoutConfiguration(expandedHeight: 260.0, collapsedHeight: 64.0),
      );

  @override
  Widget buildSliver({
    required BuildContext context,
    required ResolvedAppBarConfiguration configuration,
    required AppBarController? controller,
  }) {
    final title = ElementResolver.resolve(
      context: context,
      defaultWidget: configuration.content.title ?? const Text('Radial Explorer'),
      elementConfig: configuration.elements.title,
      progress: controller?.scrollProgress ?? 0.0,
    );

    final compactBar = configuration.content.collapsedContent ??
        Row(
          children: [
            if (configuration.content.leading != null)
              configuration.content.leading!,
            Expanded(child: title),
            ...configuration.content.actions,
          ],
        );

    final expandedCanvas = configuration.content.expandedContent ??
        (configuration.content.background ??
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  title,
                  if (configuration.content.subtitle != null)
                    configuration.content.subtitle!,
                ],
              ),
            ));

    return RadialCircularClipperRevealHeaderWidget(
      compactBar: compactBar,
      expandedCanvas: expandedCanvas,
      safeArea: configuration.layout.safeArea,
      config: const RadialCircularClipperRevealConfig(),
    );
  }
}

/// Renderer for Style 40: Depth Overlap Stacked Panel Header.
class DepthOverlapStackedPanelRenderer extends AppBarModelRenderer {
  const DepthOverlapStackedPanelRenderer();

  @override
  ModelCapabilities get capabilities => const ModelCapabilities(
        supportsStackedPanels: true,
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
      defaultWidget: configuration.content.title ?? const Text('Primary Card'),
      elementConfig: configuration.elements.title,
      progress: controller?.scrollProgress ?? 0.0,
    );

    final cards = <StackedPanelCardItem>[
      StackedPanelCardItem(
        leadingIcon: Icons.account_balance_wallet,
        title: title,
        content: configuration.content.subtitle ?? const Text('Active Details'),
        color: configuration.appearance.backgroundColor ?? Colors.deepPurple.shade900,
      ),
      StackedPanelCardItem(
        leadingIcon: Icons.trending_up,
        title: const Text('Secondary Panel'),
        content: const Text('Gain Metrics'),
        color: Colors.deepPurple.shade700,
      ),
      StackedPanelCardItem(
        leadingIcon: Icons.lock_clock,
        title: const Text('Tertiary Panel'),
        content: const Text('Institutional Reserve'),
        color: Colors.deepPurple.shade500,
      ),
    ];

    return DepthOverlapStackedPanelHeaderWidget(
      cards: cards,
      actions: configuration.content.actions,
      safeArea: configuration.layout.safeArea,
      config: DepthOverlapStackedPanelConfig(
        expandedHeight: configuration.layout.expandedHeight,
        collapsedHeight: configuration.layout.collapsedHeight,
      ),
    );
  }
}
