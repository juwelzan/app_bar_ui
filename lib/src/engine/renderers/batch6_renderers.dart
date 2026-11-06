import 'package:flutter/material.dart';

import '../../experiences/adaptive_multi_device_header.dart';
import '../../experiences/breadcrumb_transform_header.dart';
import '../../experiences/card_to_header_morph_header.dart';
import '../../experiences/experience_configs.dart';
import '../../experiences/gesture_driven_drag_expansion_header.dart';
import '../../experiences/reveal_from_edge_header.dart';
import '../app_bar_configuration.dart';
import '../app_bar_controller.dart';
import '../app_bar_model_renderer.dart';
import '../element_resolver.dart';
import '../model_capabilities.dart';

/// Renderer for Style 26: Breadcrumb Transformation Header.
class BreadcrumbTransformRenderer extends AppBarModelRenderer {
  const BreadcrumbTransformRenderer();

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
    final title = ElementResolver.resolve(
      context: context,
      defaultWidget: configuration.content.title,
      elementConfig: configuration.elements.title,
      progress: controller?.scrollProgress ?? 0.0,
    );

    return BreadcrumbTransformHeaderWidget(
      items: const [
        BreadcrumbNode(label: 'Home', icon: Icons.home),
        BreadcrumbNode(label: 'Workspace', icon: Icons.workspaces_outlined),
        BreadcrumbNode(label: 'Active Project', icon: Icons.folder),
      ],
      onNodeSelected: (_) {},
      title: title,
      actions: configuration.content.actions,
      backgroundColor: configuration.appearance.backgroundColor,
      safeArea: configuration.layout.safeArea,
      config: const BreadcrumbTransformConfig(),
    );
  }
}

/// Renderer for Style 27: Card-to-Header Morph Header.
class CardToHeaderMorphRenderer extends AppBarModelRenderer {
  const CardToHeaderMorphRenderer();

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
      defaultWidget: configuration.content.title,
      elementConfig: configuration.elements.title,
      progress: controller?.scrollProgress ?? 0.0,
    );

    final heroCardContent = configuration.content.expandedContent ??
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              title,
              if (configuration.content.subtitle != null)
                configuration.content.subtitle!,
            ],
          ),
        );

    final dockedToolbar = configuration.content.collapsedContent ??
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

    return CardToHeaderMorphHeaderWidget(
      heroCardContent: heroCardContent,
      dockedToolbar: dockedToolbar,
      safeArea: configuration.layout.safeArea,
      config: const CardToHeaderMorphConfig(),
    );
  }
}

/// Renderer for Style 28: Reveal-From-Edge Header.
class RevealFromEdgeRenderer extends AppBarModelRenderer {
  const RevealFromEdgeRenderer();

  @override
  ModelCapabilities get capabilities => const ModelCapabilities(
        supportsVelocityAutoHide: true,
      );

  @override
  AppBarConfiguration get defaultConfiguration => const AppBarConfiguration(
        layout: LayoutConfiguration(expandedHeight: 64.0, collapsedHeight: 64.0),
        behavior: BehaviorConfiguration(directionAwareAutoHide: true),
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

    final child = Padding(
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

    return SliverToBoxAdapter(
      child: RevealFromEdgeHeaderWidget(
        config: RevealFromEdgeConfig(
          headerHeight: configuration.layout.collapsedHeight,
        ),
        child: child,
      ),
    );
  }
}

/// Renderer for Style 29: Gesture-Driven Drag Expansion Header.
class GestureDrivenDragRenderer extends AppBarModelRenderer {
  const GestureDrivenDragRenderer();

  @override
  ModelCapabilities get capabilities => const ModelCapabilities(
        supportsDragToExpand: true,
      );

  @override
  AppBarConfiguration get defaultConfiguration => const AppBarConfiguration(
        layout: LayoutConfiguration(expandedHeight: 280.0, collapsedHeight: 64.0),
        behavior: BehaviorConfiguration(dragToExpand: true),
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

    final restingContent = configuration.content.collapsedContent ??
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

    final expandedCanvasContent = configuration.content.expandedContent ??
        Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              title,
              const SizedBox(height: 8.0),
              const Text('Control Canvas'),
            ],
          ),
        );

    return SliverToBoxAdapter(
      child: GestureDrivenDragExpansionHeaderWidget(
        restingContent: restingContent,
        expandedCanvasContent: expandedCanvasContent,
        backgroundColor: configuration.appearance.backgroundColor,
        safeArea: configuration.layout.safeArea,
        config: const GestureDrivenDragExpansionConfig(),
      ),
    );
  }
}

/// Renderer for Style 30: Adaptive Multi-Device Header.
class AdaptiveMultiDeviceRenderer extends AppBarModelRenderer {
  const AdaptiveMultiDeviceRenderer();

  @override
  ModelCapabilities get capabilities => const ModelCapabilities(
        supportsCustomLayoutBuilder: true,
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
    final title = ElementResolver.resolve(
      context: context,
      defaultWidget: configuration.content.title ?? const Text('Multi-Device Hub'),
      elementConfig: configuration.elements.title,
      progress: controller?.scrollProgress ?? 0.0,
    );

    return AdaptiveMultiDeviceHeaderWidget(
      title: title,
      actions: configuration.content.actions,
      searchBar: configuration.content.searchField,
      avatar: configuration.content.avatar,
      backgroundColor: configuration.appearance.backgroundColor,
      safeArea: configuration.layout.safeArea,
      config: const AdaptiveMultiDeviceConfig(),
    );
  }
}
