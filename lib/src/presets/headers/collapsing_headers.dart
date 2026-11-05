import 'package:flutter/material.dart';

import '../../widgets/scroll_collapsing_header.dart';
import '../../widgets/sliver_widget_marker.dart';
import '../scroll_header_style.dart';
import 'base_header.dart';

/// Preset 7: Large Title Header
/// Large expanded typography that collapses smoothly into a compact inline title.
class LargeTitleHeaderWidget extends StatelessWidget with SliverWidgetMarker {
  /// Creates a [LargeTitleHeaderWidget].
  const LargeTitleHeaderWidget({
    super.key,
    this.title,
    this.leading,
    this.actions,
    this.style,
    this.expandedHeight = 140.0,
    this.collapsedHeight = kToolbarHeight,
    this.safeArea = true,
  });

  /// Main title (typically [Text]).
  final Widget? title;

  /// Leading widget.
  final Widget? leading;

  /// Trailing actions.
  final List<Widget>? actions;

  /// Style configurations.
  final ScrollHeaderStyle? style;

  /// Expanded height of the header.
  final double expandedHeight;

  /// Collapsed toolbar height.
  final double collapsedHeight;

  /// Whether to pad for top safe insets.
  final bool safeArea;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final topPadding = safeArea ? MediaQuery.paddingOf(context).top : 0.0;
    final totalExpanded = expandedHeight + topPadding;
    final totalCollapsed = collapsedHeight + topPadding;
    final s = style ?? const ScrollHeaderStyle();

    return SliverPersistentHeader(
      pinned: s.pinned,
      floating: s.floating,
      delegate: PresetSliverHeaderDelegate(
        expandedHeight: totalExpanded,
        collapsedHeight: totalCollapsed,
        builder: (context, progress, overlapsContent) {
          final isCollapsed = progress >= 0.8;
          final bgColor =
              Color.lerp(
                s.backgroundColor ?? theme.colorScheme.surface,
                s.scrolledBackgroundColor ??
                    theme.colorScheme.surfaceContainerHighest,
                progress,
              ) ??
              theme.colorScheme.surface;

          return Container(
            color: bgColor,
            padding: EdgeInsets.only(top: topPadding),
            child: Stack(
              children: [
                // Top Navigation Bar (Always in place)
                SizedBox(
                  height: collapsedHeight,
                  child: Padding(
                    padding:
                        s.padding ??
                        const EdgeInsets.symmetric(horizontal: 16.0),
                    child: NavigationToolbar(
                      leading: leading,
                      middle: isCollapsed && title != null
                          ? Opacity(
                              opacity: ((progress - 0.8) / 0.2).clamp(0.0, 1.0),
                              child: DefaultTextStyle(
                                style:
                                    s.collapsedTitleStyle ??
                                    theme.textTheme.titleMedium!.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                child: title!,
                              ),
                            )
                          : null,
                      trailing: actions != null && actions!.isNotEmpty
                          ? Row(
                              mainAxisSize: MainAxisSize.min,
                              children: actions!,
                            )
                          : null,
                      centerMiddle: s.centerTitle ?? false,
                    ),
                  ),
                ),

                // Large Title in Expanded Area
                if (title != null && progress < 0.9)
                  Positioned(
                    left: 16.0,
                    right: 16.0,
                    bottom: 12.0 + (1.0 - progress) * 4.0,
                    child: Opacity(
                      opacity: (1.0 - progress / 0.8).clamp(0.0, 1.0),
                      child: DefaultTextStyle(
                        style:
                            s.largeTitleStyle ??
                            theme.textTheme.headlineMedium!.copyWith(
                              fontWeight: FontWeight.w800,
                              letterSpacing: -0.5,
                            ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        child: title!,
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}

/// Preset 8: Flexible Space Header
/// Expandable header content accommodating custom widgets that shrink and fade gracefully.
class FlexibleSpaceHeaderWidget extends StatelessWidget
    with SliverWidgetMarker {
  /// Creates a [FlexibleSpaceHeaderWidget].
  const FlexibleSpaceHeaderWidget({
    super.key,
    this.title,
    this.flexibleSpace,
    this.leading,
    this.actions,
    this.style,
    this.expandedHeight = 220.0,
    this.collapsedHeight = kToolbarHeight,
    this.safeArea = true,
  });

  /// Main title.
  final Widget? title;

  /// Custom flexible space widget.
  final Widget? flexibleSpace;

  /// Leading widget.
  final Widget? leading;

  /// Trailing actions.
  final List<Widget>? actions;

  /// Style configurations.
  final ScrollHeaderStyle? style;

  /// Expanded height.
  final double expandedHeight;

  /// Collapsed height.
  final double collapsedHeight;

  /// Whether to pad for top safe insets.
  final bool safeArea;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final topPadding = safeArea ? MediaQuery.paddingOf(context).top : 0.0;
    final totalExpanded = expandedHeight + topPadding;
    final totalCollapsed = collapsedHeight + topPadding;
    final s = style ?? const ScrollHeaderStyle();

    return SliverPersistentHeader(
      pinned: s.pinned,
      floating: s.floating,
      delegate: PresetSliverHeaderDelegate(
        expandedHeight: totalExpanded,
        collapsedHeight: totalCollapsed,
        builder: (context, progress, overlapsContent) {
          final bgColor =
              Color.lerp(
                s.backgroundColor ?? theme.colorScheme.surface,
                s.scrolledBackgroundColor ?? theme.colorScheme.surfaceContainer,
                progress,
              ) ??
              theme.colorScheme.surface;

          return Container(
            color: bgColor,
            padding: EdgeInsets.only(top: topPadding),
            child: Stack(
              children: [
                // Flexible space content
                if (flexibleSpace != null)
                  Positioned.fill(
                    child: Padding(
                      padding: EdgeInsets.only(top: collapsedHeight),
                      child: Opacity(
                        opacity: (1.0 - progress).clamp(0.0, 1.0),
                        child: flexibleSpace!,
                      ),
                    ),
                  ),

                // Pinned Toolbar on top
                SizedBox(
                  height: collapsedHeight,
                  child: Padding(
                    padding:
                        s.padding ??
                        const EdgeInsets.symmetric(horizontal: 16.0),
                    child: NavigationToolbar(
                      leading: leading,
                      middle: title != null
                          ? DefaultTextStyle(
                              style:
                                  s.titleStyle ??
                                  theme.textTheme.titleMedium!.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              child: title!,
                            )
                          : null,
                      trailing: actions != null && actions!.isNotEmpty
                          ? Row(
                              mainAxisSize: MainAxisSize.min,
                              children: actions!,
                            )
                          : null,
                      centerMiddle: s.centerTitle ?? false,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

/// Preset 9: Collapsing Header
/// Smoothly collapses from hero height down to toolbar height with sticky pinning.
class CollapsingHeaderPresetWidget extends StatelessWidget
    with SliverWidgetMarker {
  /// Creates a [CollapsingHeaderPresetWidget].
  const CollapsingHeaderPresetWidget({
    super.key,
    this.title,
    this.subtitle,
    this.leading,
    this.actions,
    this.builder,
    this.style,
    this.expandedHeight = 200.0,
    this.collapsedHeight = kToolbarHeight,
    this.safeArea = true,
  });

  /// Main title.
  final Widget? title;

  /// Subtitle.
  final Widget? subtitle;

  /// Leading widget.
  final Widget? leading;

  /// Trailing actions.
  final List<Widget>? actions;

  /// Custom layout builder.
  final Widget Function(BuildContext context, double progress)? builder;

  /// Style configurations.
  final ScrollHeaderStyle? style;

  /// Expanded height.
  final double expandedHeight;

  /// Collapsed height.
  final double collapsedHeight;

  /// Whether to pad for top safe insets.
  final bool safeArea;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final topPadding = safeArea ? MediaQuery.paddingOf(context).top : 0.0;
    final totalExpanded = expandedHeight + topPadding;
    final totalCollapsed = collapsedHeight + topPadding;
    final s = style ?? const ScrollHeaderStyle();

    return ScrollCollapsingHeader(
      expandedHeight: totalExpanded,
      collapsedHeight: totalCollapsed,
      pinned: s.pinned,
      floating: s.floating,
      backgroundColor: s.backgroundColor ?? theme.colorScheme.surface,
      collapsedBackgroundColor:
          s.scrolledBackgroundColor ?? theme.colorScheme.surfaceContainer,
      builder:
          builder ??
          (context, progress) {
            return Container(
              padding: EdgeInsets.only(top: topPadding),
              child: Stack(
                children: [
                  // Collapsed Toolbar
                  SizedBox(
                    height: collapsedHeight,
                    child: Padding(
                      padding:
                          s.padding ??
                          const EdgeInsets.symmetric(horizontal: 16.0),
                      child: NavigationToolbar(
                        leading: leading,
                        trailing: actions != null && actions!.isNotEmpty
                            ? Row(
                                mainAxisSize: MainAxisSize.min,
                                children: actions!,
                              )
                            : null,
                      ),
                    ),
                  ),

                  // Interpolated Title
                  if (title != null)
                    Positioned(
                      left: 16.0 + progress * 40.0,
                      bottom:
                          16.0 * (1.0 - progress) +
                          progress * (collapsedHeight / 4),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          DefaultTextStyle(
                            style:
                                TextStyle.lerp(
                                  theme.textTheme.headlineSmall!.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                  theme.textTheme.titleMedium!.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                  progress,
                                ) ??
                                const TextStyle(),
                            child: title!,
                          ),
                          if (subtitle != null && progress < 0.5) ...[
                            const SizedBox(height: 2.0),
                            Opacity(
                              opacity: (1.0 - progress * 2).clamp(0.0, 1.0),
                              child: DefaultTextStyle(
                                style: theme.textTheme.bodySmall!.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                                child: subtitle!,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                ],
              ),
            );
          },
    );
  }
}

/// Preset 18: Compact Scroll Header
/// Space-saving header that immediately collapses into a 48px micro-bar on slight scroll.
class CompactScrollHeaderWidget extends StatelessWidget
    with SliverWidgetMarker {
  /// Creates a [CompactScrollHeaderWidget].
  const CompactScrollHeaderWidget({
    super.key,
    this.title,
    this.subtitle,
    this.leading,
    this.actions,
    this.style,
    this.expandedHeight = 90.0,
    this.collapsedHeight = 48.0,
    this.safeArea = true,
  });

  /// Main title.
  final Widget? title;

  /// Subtitle.
  final Widget? subtitle;

  /// Leading widget.
  final Widget? leading;

  /// Trailing actions.
  final List<Widget>? actions;

  /// Style configurations.
  final ScrollHeaderStyle? style;

  /// Expanded height. Defaults to 90.0.
  final double expandedHeight;

  /// Collapsed height. Defaults to 48.0.
  final double collapsedHeight;

  /// Whether to pad for top safe insets.
  final bool safeArea;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final topPadding = safeArea ? MediaQuery.paddingOf(context).top : 0.0;
    final totalExpanded = expandedHeight + topPadding;
    final totalCollapsed = collapsedHeight + topPadding;
    final s = style ?? const ScrollHeaderStyle();

    return SliverPersistentHeader(
      pinned: s.pinned,
      floating: s.floating,
      delegate: PresetSliverHeaderDelegate(
        expandedHeight: totalExpanded,
        collapsedHeight: totalCollapsed,
        builder: (context, progress, overlapsContent) {
          final bgColor =
              Color.lerp(
                s.backgroundColor ?? theme.colorScheme.surface,
                s.scrolledBackgroundColor ??
                    theme.colorScheme.surfaceContainerHighest,
                progress,
              ) ??
              theme.colorScheme.surface;

          return Container(
            color: bgColor,
            padding: EdgeInsets.only(top: topPadding),
            child: SizedBox(
              height:
                  collapsedHeight +
                  (expandedHeight - collapsedHeight) * (1.0 - progress),
              child: Padding(
                padding:
                    s.padding ?? const EdgeInsets.symmetric(horizontal: 16.0),
                child: NavigationToolbar(
                  leading: leading,
                  middle: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (title != null)
                        DefaultTextStyle(
                          style:
                              TextStyle.lerp(
                                theme.textTheme.titleMedium!.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                                theme.textTheme.titleSmall!.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                                progress,
                              ) ??
                              const TextStyle(),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          child: title!,
                        ),
                      if (subtitle != null && progress < 0.4) ...[
                        const SizedBox(height: 1.0),
                        Opacity(
                          opacity: (1.0 - progress / 0.4).clamp(0.0, 1.0),
                          child: DefaultTextStyle(
                            style: theme.textTheme.bodySmall!.copyWith(
                              fontSize: 11.0,
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            child: subtitle!,
                          ),
                        ),
                      ],
                    ],
                  ),
                  trailing: actions != null && actions!.isNotEmpty
                      ? Row(mainAxisSize: MainAxisSize.min, children: actions!)
                      : null,
                  centerMiddle: false,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
