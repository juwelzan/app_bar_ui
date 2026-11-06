import 'package:flutter/material.dart';

import '../../experiences/context_aware_focal_swap_header.dart';
import '../../experiences/experience_configs.dart';
import '../../experiences/interactive_timeline_scrubber_header.dart';
import '../../experiences/multi_anchor_dock_header.dart';
import '../../experiences/sliver_to_rail_transform_header.dart';
import '../../experiences/spline_curved_motion_path_header.dart';
import '../app_bar_configuration.dart';
import '../app_bar_controller.dart';
import '../app_bar_model_renderer.dart';
import '../element_resolver.dart';
import '../model_capabilities.dart';

/// Renderer for Style 46: Interactive Timeline Scrubber Header.
class InteractiveTimelineScrubberRenderer extends AppBarModelRenderer {
  const InteractiveTimelineScrubberRenderer();

  @override
  ModelCapabilities get capabilities => const ModelCapabilities();

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
      defaultWidget: configuration.content.title ?? const Text('Timeline Scrubber'),
      elementConfig: configuration.elements.title,
      progress: controller?.scrollProgress ?? 0.0,
    );

    return InteractiveTimelineScrubberHeaderWidget(
      title: title,
      subtitle: configuration.content.subtitle,
      leading: configuration.content.leading,
      actions: configuration.content.actions,
      backgroundColor: configuration.appearance.backgroundColor,
      safeArea: configuration.layout.safeArea,
      config: InteractiveTimelineScrubberConfig(
        expandedHeight: configuration.layout.expandedHeight,
        collapsedHeight: configuration.layout.collapsedHeight,
      ),
    );
  }
}

/// Renderer for Style 47: Multi-Anchor Dock Header.
class MultiAnchorDockRenderer extends AppBarModelRenderer {
  const MultiAnchorDockRenderer();

  @override
  ModelCapabilities get capabilities => const ModelCapabilities(
        supportsDragToExpand: true,
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
      defaultWidget: configuration.content.title ?? const Text('Multi-Anchor Dock'),
      elementConfig: configuration.elements.title,
      progress: controller?.scrollProgress ?? 0.0,
    );

    final dockContent = configuration.content.expandedContent ??
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.flash_on, size: 16.0, color: Colors.amber),
              const SizedBox(width: 8.0),
              title,
            ],
          ),
        );

    return MultiAnchorDockHeaderWidget(
      dockContent: dockContent,
      expandedBackground: configuration.content.expandedContent,
      title: title,
      leading: configuration.content.leading,
      actions: configuration.content.actions,
      backgroundColor: configuration.appearance.backgroundColor,
      safeArea: configuration.layout.safeArea,
      config: MultiAnchorDockConfig(
        expandedHeight: configuration.layout.expandedHeight,
        collapsedHeight: configuration.layout.collapsedHeight,
      ),
    );
  }
}

/// Renderer for Style 48: Sliver-to-Rail Transform Header.
class SliverToRailTransformRenderer extends AppBarModelRenderer {
  const SliverToRailTransformRenderer();

  @override
  ModelCapabilities get capabilities => const ModelCapabilities();

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
      defaultWidget: configuration.content.title ?? const Text('Sliver to Rail'),
      elementConfig: configuration.elements.title,
      progress: controller?.scrollProgress ?? 0.0,
    );

    return SliverToRailTransformHeaderWidget(
      title: title,
      leading: configuration.content.leading,
      actions: configuration.content.actions,
      backgroundColor: configuration.appearance.backgroundColor,
      safeArea: configuration.layout.safeArea,
      config: SliverToRailTransformConfig(
        expandedHeight: configuration.layout.expandedHeight,
        collapsedHeight: configuration.layout.collapsedHeight,
      ),
    );
  }
}

/// Renderer for Style 49: Context-Aware Focal Swap Header.
class ContextAwareFocalSwapRenderer extends AppBarModelRenderer {
  const ContextAwareFocalSwapRenderer();

  @override
  ModelCapabilities get capabilities => const ModelCapabilities(
        supportsMultiStage: true,
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
      defaultWidget: configuration.content.title ?? const Text('Focal Swap'),
      elementConfig: configuration.elements.title,
      progress: controller?.scrollProgress ?? 0.0,
    );

    final primaryHero = configuration.content.expandedContent ??
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            title,
            if (configuration.content.subtitle != null) ...[
              const SizedBox(height: 6.0),
              configuration.content.subtitle!,
            ],
          ],
        );

    final contextualToolbar = configuration.content.collapsedContent ??
        Row(
          children: [
            if (configuration.content.leading != null) ...[
              configuration.content.leading!,
              const SizedBox(width: 8.0),
            ],
            Expanded(child: title),
            ...configuration.content.actions,
          ],
        );

    return ContextAwareFocalSwapHeaderWidget(
      primaryHero: primaryHero,
      contextualToolbar: contextualToolbar,
      backgroundColor: configuration.appearance.backgroundColor,
      safeArea: configuration.layout.safeArea,
      config: ContextAwareFocalSwapConfig(
        expandedHeight: configuration.layout.expandedHeight,
        collapsedHeight: configuration.layout.collapsedHeight,
      ),
    );
  }
}

/// Renderer for Style 50: Spline Curved Motion Path Header.
class SplineCurvedMotionPathRenderer extends AppBarModelRenderer {
  const SplineCurvedMotionPathRenderer();

  @override
  ModelCapabilities get capabilities => const ModelCapabilities(
        supports3DTransform: true,
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
      defaultWidget: configuration.content.title ?? const Text('Spline Motion Path'),
      elementConfig: configuration.elements.title,
      progress: controller?.scrollProgress ?? 0.0,
    );

    final avatar = ElementResolver.resolve(
      context: context,
      defaultWidget: configuration.content.avatar ??
          CircleAvatar(
            backgroundColor: Theme.of(context).colorScheme.primary,
            child: const Icon(Icons.person, color: Colors.white),
          ),
      elementConfig: configuration.elements.avatar,
      progress: controller?.scrollProgress ?? 0.0,
    );

    return SplineCurvedMotionPathHeaderWidget(
      avatar: avatar,
      title: title,
      subtitle: configuration.content.subtitle,
      leading: configuration.content.leading,
      actions: configuration.content.actions,
      backgroundColor: configuration.appearance.backgroundColor,
      safeArea: configuration.layout.safeArea,
      config: SplineCurvedMotionPathConfig(
        expandedHeight: configuration.layout.expandedHeight,
        collapsedHeight: configuration.layout.collapsedHeight,
      ),
    );
  }
}
