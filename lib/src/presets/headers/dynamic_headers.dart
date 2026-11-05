import 'package:flutter/material.dart';

import '../../widgets/pinned_action_button.dart';
import '../../widgets/scroll_parallax.dart';
import '../../widgets/sliver_widget_marker.dart';
import '../scroll_header_style.dart';
import 'base_header.dart';

/// Preset 10: Parallax Header
/// Background hero layer moving at fractional speed (e.g. 0.5x) via FlowDelegate with zero rebuilds.
class ParallaxHeaderWidget extends StatelessWidget with SliverWidgetMarker {
  /// Creates a [ParallaxHeaderWidget].
  const ParallaxHeaderWidget({
    super.key,
    required this.background,
    this.title,
    this.subtitle,
    this.leading,
    this.actions,
    this.speedFactor = 0.5,
    this.expandedHeight = 220.0,
    this.collapsedHeight = kToolbarHeight,
    this.style,
    this.safeArea = true,
  });

  /// The background widget to move with parallax.
  final Widget background;

  /// Main title.
  final Widget? title;

  /// Subtitle.
  final Widget? subtitle;

  /// Leading widget.
  final Widget? leading;

  /// Trailing actions.
  final List<Widget>? actions;

  /// Parallax speed factor (0.5 = half speed).
  final double speedFactor;

  /// Expanded height.
  final double expandedHeight;

  /// Collapsed toolbar height.
  final double collapsedHeight;

  /// Style configurations.
  final ScrollHeaderStyle? style;

  /// Whether to pad for top safe insets.
  final bool safeArea;

  @override
  Widget build(BuildContext context) {
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
          return ClipRect(
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Parallax background layer
                ScrollParallax(
                  speedFactor: speedFactor,
                  child: SizedBox(height: totalExpanded, child: background),
                ),

                // Scrim / gradient overlay for text readability
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.black.withValues(alpha: 0.5 * (1.0 - progress)),
                        Colors.black.withValues(
                          alpha: 0.2 * (1.0 - progress) + 0.4 * progress,
                        ),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),

                // Top Navigation Bar
                Positioned(
                  top: topPadding,
                  left: 0,
                  right: 0,
                  child: SizedBox(
                    height: collapsedHeight,
                    child: Padding(
                      padding:
                          s.padding ??
                          const EdgeInsets.symmetric(horizontal: 16.0),
                      child: NavigationToolbar(
                        leading: leading != null
                            ? IconTheme(
                                data: const IconThemeData(color: Colors.white),
                                child: leading!,
                              )
                            : null,
                        middle: progress >= 0.7 && title != null
                            ? Opacity(
                                opacity: ((progress - 0.7) / 0.3).clamp(
                                  0.0,
                                  1.0,
                                ),
                                child: DefaultTextStyle(
                                  style:
                                      s.titleStyle ??
                                      const TextStyle(
                                        color: Colors.white,
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  child: title!,
                                ),
                              )
                            : null,
                        trailing: actions != null && actions!.isNotEmpty
                            ? IconTheme(
                                data: const IconThemeData(color: Colors.white),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: actions!,
                                ),
                              )
                            : null,
                        centerMiddle: s.centerTitle ?? false,
                      ),
                    ),
                  ),
                ),

                // Bottom Title & Subtitle when expanded
                if ((title != null || subtitle != null) && progress < 0.7)
                  Positioned(
                    left: 20.0,
                    right: 20.0,
                    bottom: 20.0 * (1.0 - progress),
                    child: Opacity(
                      opacity: (1.0 - progress / 0.7).clamp(0.0, 1.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (title != null)
                            DefaultTextStyle(
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 24.0,
                                fontWeight: FontWeight.bold,
                              ),
                              child: title!,
                            ),
                          if (subtitle != null) ...[
                            const SizedBox(height: 4.0),
                            DefaultTextStyle(
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 13.0,
                              ),
                              child: subtitle!,
                            ),
                          ],
                        ],
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

/// Preset 19: Side Action Transition Header
/// Header highlighting dual-state synchronized icon morphing with independent thresholds.
class SideActionTransitionHeaderWidget extends StatelessWidget {
  /// Creates a [SideActionTransitionHeaderWidget].
  const SideActionTransitionHeaderWidget({
    super.key,
    this.title,
    this.subtitle,
    this.initialLeading,
    this.scrolledLeading,
    this.initialTrailing,
    this.scrolledTrailing,
    this.progress = 0.0,
    this.onLeadingTap,
    this.onTrailingTap,
    this.style,
    this.safeArea = true,
  });

  /// Main title.
  final Widget? title;

  /// Subtitle.
  final Widget? subtitle;

  /// Initial leading icon (e.g. Profile Avatar).
  final Widget? initialLeading;

  /// Scrolled leading icon (e.g. Back/Drawer button).
  final Widget? scrolledLeading;

  /// Initial trailing icon (e.g. Notification Bell).
  final Widget? initialTrailing;

  /// Scrolled trailing icon (e.g. Profile Avatar).
  final Widget? scrolledTrailing;

  /// Current normalized progress (0.0 to 1.0).
  final double progress;

  /// Callback when leading icon is tapped.
  final VoidCallback? onLeadingTap;

  /// Callback when trailing icon is tapped.
  final VoidCallback? onTrailingTap;

  /// Style configurations.
  final ScrollHeaderStyle? style;

  /// Whether to pad for top safe insets.
  final bool safeArea;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final topPadding = safeArea ? MediaQuery.paddingOf(context).top : 0.0;
    final s = style ?? const ScrollHeaderStyle();

    return Container(
      color: s.backgroundColor ?? theme.colorScheme.surface,
      padding: EdgeInsets.fromLTRB(16.0, topPadding + 8.0, 16.0, 12.0),
      child: NavigationToolbar(
        leading: PinnedActionButton(
          progress: progress,
          initialWidget: initialLeading,
          scrolledWidget: scrolledLeading,
          onInitialTap: onLeadingTap,
          onScrolledTap: onLeadingTap,
        ),
        middle: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: s.centerTitle == true
              ? CrossAxisAlignment.center
              : CrossAxisAlignment.start,
          children: [
            if (title != null)
              DefaultTextStyle(
                style:
                    s.titleStyle ??
                    theme.textTheme.titleMedium!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                child: title!,
              ),
            if (subtitle != null) ...[
              const SizedBox(height: 2.0),
              DefaultTextStyle(
                style:
                    s.subtitleStyle ??
                    theme.textTheme.bodySmall!.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                child: subtitle!,
              ),
            ],
          ],
        ),
        trailing: PinnedActionButton(
          progress: progress,
          initialWidget: initialTrailing,
          scrolledWidget: scrolledTrailing,
          onInitialTap: onTrailingTap,
          onScrolledTap: onTrailingTap,
        ),
        centerMiddle: s.centerTitle ?? false,
      ),
    );
  }
}

/// Preset 20: Custom Builder Header
/// 100% developer-controlled custom layout using a builder callback receiving real-time progress.
class CustomBuilderHeaderWidget extends StatelessWidget
    with SliverWidgetMarker {
  /// Creates a [CustomBuilderHeaderWidget].
  const CustomBuilderHeaderWidget({
    super.key,
    required this.builder,
    this.expandedHeight = 200.0,
    this.collapsedHeight = kToolbarHeight,
    this.pinned = true,
    this.floating = false,
  });

  /// Custom layout builder receiving [context], scroll [progress] (0.0 to 1.0),
  /// and [overlapsContent].
  final Widget Function(
    BuildContext context,
    double progress,
    bool overlapsContent,
  )
  builder;

  /// Expanded height for sliver mode.
  final double expandedHeight;

  /// Collapsed height for sliver mode.
  final double collapsedHeight;

  /// Whether the header pins at the top.
  final bool pinned;

  /// Whether the header floats into view on reverse scroll.
  final bool floating;

  @override
  Widget build(BuildContext context) {
    return SliverPersistentHeader(
      pinned: pinned,
      floating: floating,
      delegate: PresetSliverHeaderDelegate(
        expandedHeight: expandedHeight,
        collapsedHeight: collapsedHeight,
        builder: builder,
      ),
    );
  }
}
