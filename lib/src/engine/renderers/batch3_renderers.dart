import 'package:flutter/material.dart';

import '../../experiences/animated_dock_header.dart';
import '../../experiences/auto_hiding_velocity_header.dart';
import '../../experiences/experience_configs.dart';
import '../../experiences/multi_stage_staged_reveal_header.dart';
import '../../experiences/scroll_synchronized_progress_header.dart';
import '../../experiences/sticky_collapse_dual_tier_header.dart';
import '../app_bar_configuration.dart';
import '../app_bar_controller.dart';
import '../app_bar_model_renderer.dart';
import '../element_resolver.dart';
import '../model_capabilities.dart';

/// Renderer for Style 11: Auto-Hiding Velocity Header.
class AutoHidingVelocityRenderer extends AppBarModelRenderer {
  const AutoHidingVelocityRenderer();

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

    final child = Row(
      children: [
        if (configuration.content.leading != null)
          configuration.content.leading!,
        Expanded(child: title),
        ...configuration.content.actions,
      ],
    );

    return SliverToBoxAdapter(
      child: AutoHidingVelocityHeaderWidget(
        config: AutoHidingVelocityConfig(
          height: configuration.layout.collapsedHeight,
          hideVelocityThreshold: configuration.behavior.autoHideVelocityThreshold,
        ),
        child: child,
      ),
    );
  }
}

/// Renderer for Style 12: Scroll-Synchronized Progress Header.
class ScrollSynchronizedProgressRenderer extends AppBarModelRenderer {
  const ScrollSynchronizedProgressRenderer();

  @override
  ModelCapabilities get capabilities => const ModelCapabilities();

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
    final title = ElementResolver.resolve(
      context: context,
      defaultWidget: configuration.content.title,
      elementConfig: configuration.elements.title,
      progress: controller?.scrollProgress ?? 0.0,
    );

    return ScrollSynchronizedProgressHeaderWidget(
      title: title,
      subtitle: configuration.content.subtitle,
      leading: configuration.content.leading,
      actions: configuration.content.actions,
      config: ScrollSynchronizedProgressConfig(
        expandedHeight: configuration.layout.expandedHeight,
        collapsedHeight: configuration.layout.collapsedHeight,
      ),
    );
  }
}

/// Renderer for Style 13: Sticky-Collapse Dual-Tier Header.
class StickyDualTierRenderer extends AppBarModelRenderer {
  const StickyDualTierRenderer();

  @override
  ModelCapabilities get capabilities => const ModelCapabilities(
        supportsSticky: true,
      );

  @override
  AppBarConfiguration get defaultConfiguration => const AppBarConfiguration(
        layout: LayoutConfiguration(expandedHeight: 180.0, collapsedHeight: 56.0),
        behavior: BehaviorConfiguration(sticky: true),
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

    final tier1 = configuration.content.expandedContent ??
        Row(
          children: [
            if (configuration.content.leading != null)
              configuration.content.leading!,
            Expanded(child: title),
            ...configuration.content.actions,
          ],
        );

    final tier2 = configuration.content.tabs ??
        (configuration.content.searchField ??
            configuration.content.navigationControls ??
            const SizedBox.shrink());

    return StickyCollapseDualTierHeaderWidget(
      tier1Content: tier1,
      tier2Content: tier2,
      backgroundColor: configuration.appearance.backgroundColor,
      safeArea: configuration.layout.safeArea,
      config: StickyCollapseDualTierConfig(
        tier1Height: configuration.layout.expandedHeight - configuration.layout.collapsedHeight,
        tier2Height: configuration.layout.collapsedHeight,
      ),
    );
  }
}

/// Renderer for Style 14: Multi-Stage Staged Reveal Header.
class MultiStageRevealRenderer extends AppBarModelRenderer {
  const MultiStageRevealRenderer();

  @override
  ModelCapabilities get capabilities => const ModelCapabilities(
        supportsMultiStage: true,
      );

  @override
  AppBarConfiguration get defaultConfiguration => const AppBarConfiguration(
        layout: LayoutConfiguration(expandedHeight: 240.0, collapsedHeight: 60.0),
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

    final stage1Hero = configuration.content.expandedContent ??
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

    final stage2Meta = configuration.content.searchField ??
        configuration.content.navigationControls ??
        Center(child: title);

    final stage3Toolbar = configuration.content.collapsedContent ??
        Row(
          children: [
            if (configuration.content.leading != null)
              configuration.content.leading!,
            Expanded(child: title),
            ...configuration.content.actions,
          ],
        );

    return MultiStageStagedRevealHeaderWidget(
      stage1Hero: stage1Hero,
      stage2Meta: stage2Meta,
      stage3Toolbar: stage3Toolbar,
      config: MultiStageStagedRevealConfig(
        expandedHeight: configuration.layout.expandedHeight,
        collapsedHeight: configuration.layout.collapsedHeight,
      ),
    );
  }
}

/// Renderer for Style 15: Animated Dock Header.
class AnimatedDockRenderer extends AppBarModelRenderer {
  const AnimatedDockRenderer();

  @override
  ModelCapabilities get capabilities => const ModelCapabilities(
        supportsFloatingDock: true,
      );

  @override
  AppBarConfiguration get defaultConfiguration => const AppBarConfiguration(
        layout: LayoutConfiguration(expandedHeight: 140.0, collapsedHeight: 64.0),
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

    return AnimatedDockHeaderWidget(
      topHeaderContent: configuration.content.expandedContent ??
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              title,
              if (configuration.content.subtitle != null)
                configuration.content.subtitle!,
            ],
          ),
      backgroundColor: configuration.appearance.backgroundColor,
      safeArea: configuration.layout.safeArea,
      config: AnimatedDockConfig(
        topHeaderHeight: configuration.layout.expandedHeight,
      ),
    );
  }
}
