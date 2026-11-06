import 'package:flutter/material.dart';

import '../../experiences/avatar_to_profile_header.dart';
import '../../experiences/expanding_search_header.dart';
import '../../experiences/experience_configs.dart';
import '../../experiences/progressive_disclosure_header.dart';
import '../../experiences/sideways_collapse_header.dart';
import '../../experiences/tab_transform_header.dart';
import '../app_bar_configuration.dart';
import '../app_bar_controller.dart';
import '../app_bar_model_renderer.dart';
import '../element_resolver.dart';
import '../model_capabilities.dart';

/// Renderer for Style 21: Tab-Transform Header.
class TabTransformRenderer extends AppBarModelRenderer {
  const TabTransformRenderer();

  @override
  ModelCapabilities get capabilities => const ModelCapabilities(
        supportsSticky: true,
      );

  @override
  AppBarConfiguration get defaultConfiguration => const AppBarConfiguration(
        layout: LayoutConfiguration(expandedHeight: 220.0, collapsedHeight: 64.0),
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

    return TabTransformHeaderWidget(
      tabs: const [
        TabTransformItem(label: 'Home', icon: Icons.home),
        TabTransformItem(label: 'Explore', icon: Icons.explore),
        TabTransformItem(label: 'Profile', icon: Icons.person),
      ],
      selectedIndex: 0,
      onTabSelected: (_) {},
      title: title,
      actions: configuration.content.actions,
      backgroundColor: configuration.appearance.backgroundColor,
      safeArea: configuration.layout.safeArea,
      config: TabTransformConfig(
        expandedHeight: configuration.layout.expandedHeight,
        compactTabHeight: configuration.layout.collapsedHeight,
      ),
    );
  }
}

/// Renderer for Style 22: Avatar-to-Profile Header.
class AvatarToProfileRenderer extends AppBarModelRenderer {
  const AvatarToProfileRenderer();

  @override
  ModelCapabilities get capabilities => const ModelCapabilities(
        supportsParallax: true,
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
      defaultWidget: configuration.content.title ?? const Text('User Profile'),
      elementConfig: configuration.elements.title,
      progress: controller?.scrollProgress ?? 0.0,
    );

    final avatar = ElementResolver.resolve(
      context: context,
      defaultWidget: configuration.content.avatar ??
          const CircleAvatar(
            radius: 38.0,
            child: Icon(Icons.person, size: 38.0),
          ),
      elementConfig: configuration.elements.avatar,
      progress: controller?.scrollProgress ?? 0.0,
    );

    return AvatarToProfileHeaderWidget(
      avatar: avatar,
      name: title,
      handle: configuration.content.subtitle,
      bio: configuration.content.expandedContent,
      leading: configuration.content.leading,
      actions: configuration.content.actions,
      backgroundColor: configuration.appearance.backgroundColor,
      safeArea: configuration.layout.safeArea,
      config: const AvatarToProfileConfig(),
    );
  }
}

/// Renderer for Style 23: Progressive Disclosure Header.
class ProgressiveDisclosureRenderer extends AppBarModelRenderer {
  const ProgressiveDisclosureRenderer();

  @override
  ModelCapabilities get capabilities => const ModelCapabilities(
        supportsMultiStage: true,
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
      defaultWidget: configuration.content.title ?? const Text('Market Discovery'),
      elementConfig: configuration.elements.title,
      progress: controller?.scrollProgress ?? 0.0,
    );

    final searchBar = configuration.content.searchField ??
        Container(
          height: 40.0,
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          decoration: BoxDecoration(
            color: Colors.grey.withAlpha(40),
            borderRadius: BorderRadius.circular(20.0),
          ),
          alignment: Alignment.centerLeft,
          child: const Text('Search components...', style: TextStyle(fontSize: 13.0)),
        );

    final filterRow = configuration.content.navigationControls ??
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: [
              FilterChip(selected: true, label: const Text('All Items'), onSelected: (_) {}),
              const SizedBox(width: 6.0),
              FilterChip(selected: false, label: const Text('Verified'), onSelected: (_) {}),
            ],
          ),
        );

    return ProgressiveDisclosureHeaderWidget(
      title: title,
      searchBar: searchBar,
      filterRow: filterRow,
      actions: configuration.content.actions,
      backgroundColor: configuration.appearance.backgroundColor,
      safeArea: configuration.layout.safeArea,
      config: const ProgressiveDisclosureConfig(),
    );
  }
}

/// Renderer for Style 24: Sideways-Collapse Header.
class SidewaysCollapseRenderer extends AppBarModelRenderer {
  const SidewaysCollapseRenderer();

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

    final expandedContent = configuration.content.expandedContent ??
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

    final compactRail = configuration.content.collapsedContent ??
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.hub, size: 20.0),
            const SizedBox(width: 6.0),
            title,
          ],
        );

    return SidewaysCollapseHeaderWidget(
      expandedContent: expandedContent,
      compactRailContent: compactRail,
      backgroundColor: configuration.appearance.backgroundColor,
      safeArea: configuration.layout.safeArea,
      config: const SidewaysCollapseConfig(),
    );
  }
}

/// Renderer for Style 25: Expanding Search Transformation Header.
class ExpandingSearchRenderer extends AppBarModelRenderer {
  const ExpandingSearchRenderer();

  @override
  ModelCapabilities get capabilities => const ModelCapabilities();

  @override
  AppBarConfiguration get defaultConfiguration => const AppBarConfiguration(
        layout: LayoutConfiguration(expandedHeight: 130.0, collapsedHeight: 60.0),
      );

  @override
  Widget buildSliver({
    required BuildContext context,
    required ResolvedAppBarConfiguration configuration,
    required AppBarController? controller,
  }) {
    final title = ElementResolver.resolve(
      context: context,
      defaultWidget: configuration.content.title ?? const Text('Search'),
      elementConfig: configuration.elements.title,
      progress: controller?.scrollProgress ?? 0.0,
    );

    return ExpandingSearchHeaderWidget(
      title: title,
      subtitle: configuration.content.subtitle,
      leading: configuration.content.leading,
      actions: configuration.content.actions,
      backgroundColor: configuration.appearance.backgroundColor,
      safeArea: configuration.layout.safeArea,
      config: ExpandingSearchConfig(
        expandedHeight: configuration.layout.expandedHeight,
        collapsedHeight: configuration.layout.collapsedHeight,
      ),
    );
  }
}
