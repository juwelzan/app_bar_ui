import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import '../../widgets/sliver_widget_marker.dart';
import '../scroll_header_style.dart';
import 'base_header.dart';

/// Preset 31: Glass Header
///
/// Translucent frosted glass effect using [BackdropFilter] with configurable
/// blur radius, subtle translucent tint, hairline border, and platform-compatible fallback.
class GlassHeaderWidget extends StatelessWidget {
  /// Creates a [GlassHeaderWidget].
  const GlassHeaderWidget({
    super.key,
    this.title,
    this.subtitle,
    this.leading,
    this.actions,
    this.blurSigma = 12.0,
    this.tintColor,
    this.borderColor,
    this.borderRadius,
    this.style,
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

  /// Frosted glass blur sigma. Defaults to 12.0.
  final double blurSigma;

  /// Custom translucent tint overlay color.
  final Color? tintColor;

  /// Hairline border color.
  final Color? borderColor;

  /// Optional border radius for floating glass islands.
  final BorderRadius? borderRadius;

  /// Style configurations.
  final ScrollHeaderStyle? style;

  /// Whether to pad for top safe insets.
  final bool safeArea;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final topPadding = safeArea ? MediaQuery.paddingOf(context).top : 0.0;
    final effectiveRadius =
        borderRadius ?? style?.borderRadius ?? BorderRadius.zero;
    final bgTint = tintColor ??
        (style?.backgroundColor ?? theme.colorScheme.surface)
            .withValues(alpha: 0.65);
    final border = borderColor ??
        theme.colorScheme.outlineVariant.withValues(alpha: 0.35);

    final content = NavigationToolbar(
      leading: leading,
      middle: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: style?.centerTitle == true
            ? CrossAxisAlignment.center
            : CrossAxisAlignment.start,
        children: [
          if (title != null)
            DefaultTextStyle(
              style:
                  style?.titleStyle ??
                  theme.textTheme.titleMedium!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              child: title!,
            ),
          if (subtitle != null) ...[
            const SizedBox(height: 1.0),
            DefaultTextStyle(
              style:
                  style?.subtitleStyle ??
                  theme.textTheme.bodySmall!.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              child: subtitle!,
            ),
          ],
        ],
      ),
      trailing: actions != null && actions!.isNotEmpty
          ? Row(mainAxisSize: MainAxisSize.min, children: actions!)
          : null,
      centerMiddle: style?.centerTitle ?? false,
    );

    return RepaintBoundary(
      child: Container(
        margin: style?.margin,
        child: ClipRRect(
          borderRadius: effectiveRadius,
          child: BackdropFilter(
            filter: ui.ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
            child: Container(
              decoration: BoxDecoration(
                color: bgTint,
                borderRadius: effectiveRadius,
                border: Border.all(color: border, width: 0.8),
              ),
              child: Padding(
                padding: EdgeInsets.only(top: topPadding),
                child: SizedBox(
                  height: style?.height ?? 56.0,
                  child: Padding(
                    padding:
                        style?.padding ??
                        const EdgeInsets.symmetric(horizontal: 16.0),
                    child: content,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Preset 32: Blurred Background Header
///
/// Performance-isolated background blur header designed to maintain 60/120 FPS
/// when content scrolls beneath the navigation bar.
class BlurredBackgroundHeaderWidget extends StatelessWidget {
  /// Creates a [BlurredBackgroundHeaderWidget].
  const BlurredBackgroundHeaderWidget({
    super.key,
    this.title,
    this.subtitle,
    this.leading,
    this.actions,
    this.blurSigma = 10.0,
    this.style,
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

  /// Blur sigma radius. Defaults to 10.0.
  final double blurSigma;

  /// Style configurations.
  final ScrollHeaderStyle? style;

  /// Whether to pad for top safe insets.
  final bool safeArea;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final s = (style ?? const ScrollHeaderStyle()).copyWith(
      backgroundColor: (style?.backgroundColor ?? theme.colorScheme.surface)
          .withValues(alpha: 0.8),
      scrolledBackgroundColor:
          (style?.scrolledBackgroundColor ??
                  theme.colorScheme.surfaceContainer)
              .withValues(alpha: 0.9),
      blurBackground: true,
      blurSigma: blurSigma,
      elevation: style?.elevation ?? 0.0,
      scrolledElevation: style?.scrolledElevation ?? 2.0,
      showDivider: style?.showDivider ?? true,
    );

    return RepaintBoundary(
      child: HeaderContainer(
        style: s,
        safeArea: safeArea,
        child: NavigationToolbar(
          leading: leading,
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
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  child: title!,
                ),
              if (subtitle != null) ...[
                const SizedBox(height: 1.0),
                DefaultTextStyle(
                  style:
                      s.subtitleStyle ??
                      theme.textTheme.bodySmall!.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  child: subtitle!,
                ),
              ],
            ],
          ),
          trailing: actions != null && actions!.isNotEmpty
              ? Row(mainAxisSize: MainAxisSize.min, children: actions!)
              : null,
          centerMiddle: s.centerTitle ?? false,
        ),
      ),
    );
  }
}

/// Preset 33: Bordered Header
///
/// Ultra-clean, elevation-free header that relies strictly on subtle hairline borders
/// for content separation rather than drop shadows.
class BorderedHeaderWidget extends StatelessWidget {
  /// Creates a [BorderedHeaderWidget].
  const BorderedHeaderWidget({
    super.key,
    this.title,
    this.subtitle,
    this.leading,
    this.actions,
    this.borderColor,
    this.borderWidth = 1.0,
    this.style,
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

  /// Custom border color. Defaults to theme outlineVariant.
  final Color? borderColor;

  /// Bottom border line thickness. Defaults to 1.0.
  final double borderWidth;

  /// Style configurations.
  final ScrollHeaderStyle? style;

  /// Whether to pad for top safe insets.
  final bool safeArea;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final topPadding = safeArea ? MediaQuery.paddingOf(context).top : 0.0;
    final border = borderColor ??
        style?.dividerColor ??
        theme.colorScheme.outlineVariant.withValues(alpha: 0.6);

    return Container(
      decoration: BoxDecoration(
        color: style?.backgroundColor ?? theme.colorScheme.surface,
        border: Border(
          bottom: BorderSide(color: border, width: borderWidth),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.only(top: topPadding),
        child: SizedBox(
          height: style?.height ?? 56.0,
          child: Padding(
            padding:
                style?.padding ?? const EdgeInsets.symmetric(horizontal: 16.0),
            child: NavigationToolbar(
              leading: leading,
              middle: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: style?.centerTitle == true
                    ? CrossAxisAlignment.center
                    : CrossAxisAlignment.start,
                children: [
                  if (title != null)
                    DefaultTextStyle(
                      style:
                          style?.titleStyle ??
                          theme.textTheme.titleMedium!.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      child: title!,
                    ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 1.0),
                    DefaultTextStyle(
                      style:
                          style?.subtitleStyle ??
                          theme.textTheme.bodySmall!.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      child: subtitle!,
                    ),
                  ],
                ],
              ),
              trailing: actions != null && actions!.isNotEmpty
                  ? Row(mainAxisSize: MainAxisSize.min, children: actions!)
                  : null,
              centerMiddle: style?.centerTitle ?? false,
            ),
          ),
        ),
      ),
    );
  }
}

/// Preset 34: Shadow-Elevated Header
///
/// Premium elevated header featuring customizable deep, multi-stop drop shadows
/// with smooth elevation intensity scaling on scroll.
class ShadowElevatedHeaderWidget extends StatelessWidget {
  /// Creates a [ShadowElevatedHeaderWidget].
  const ShadowElevatedHeaderWidget({
    super.key,
    this.title,
    this.subtitle,
    this.leading,
    this.actions,
    this.style,
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

  /// Whether to pad for top safe insets.
  final bool safeArea;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final topPadding = safeArea ? MediaQuery.paddingOf(context).top : 0.0;
    final elevation = style?.elevation ?? 4.0;

    return Container(
      margin: style?.margin,
      decoration: BoxDecoration(
        color: style?.backgroundColor ?? theme.colorScheme.surface,
        borderRadius: style?.borderRadius,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: elevation * 3,
            spreadRadius: 1.0,
            offset: Offset(0, elevation),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: elevation,
            offset: Offset(0, elevation / 2),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.only(top: topPadding),
        child: SizedBox(
          height: style?.height ?? 56.0,
          child: Padding(
            padding:
                style?.padding ?? const EdgeInsets.symmetric(horizontal: 16.0),
            child: NavigationToolbar(
              leading: leading,
              middle: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: style?.centerTitle == true
                    ? CrossAxisAlignment.center
                    : CrossAxisAlignment.start,
                children: [
                  if (title != null)
                    DefaultTextStyle(
                      style:
                          style?.titleStyle ??
                          theme.textTheme.titleMedium!.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      child: title!,
                    ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 1.0),
                    DefaultTextStyle(
                      style:
                          style?.subtitleStyle ??
                          theme.textTheme.bodySmall!.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      child: subtitle!,
                    ),
                  ],
                ],
              ),
              trailing: actions != null && actions!.isNotEmpty
                  ? Row(mainAxisSize: MainAxisSize.min, children: actions!)
                  : null,
              centerMiddle: style?.centerTitle ?? false,
            ),
          ),
        ),
      ),
    );
  }
}

/// Preset 35: Layered Header
///
/// Multi-layer visual depth header composed of a decorative back layer,
/// a contextual middle layer, and a foreground toolbar.
class LayeredHeaderWidget extends StatelessWidget {
  /// Creates a [LayeredHeaderWidget].
  const LayeredHeaderWidget({
    super.key,
    this.title,
    this.subtitle,
    this.leading,
    this.actions,
    this.backLayer,
    this.middleLayer,
    this.style,
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

  /// Decorative background layer (e.g. geometric pattern, mesh, or watermark).
  final Widget? backLayer;

  /// Secondary contextual middle layer (e.g. accent strip or status badge).
  final Widget? middleLayer;

  /// Style configurations.
  final ScrollHeaderStyle? style;

  /// Whether to pad for top safe insets.
  final bool safeArea;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final topPadding = safeArea ? MediaQuery.paddingOf(context).top : 0.0;
    final totalHeight = (style?.height ?? 64.0) + topPadding;

    return Container(
      margin: style?.margin,
      height: totalHeight,
      decoration: BoxDecoration(
        color: style?.backgroundColor ?? theme.colorScheme.surface,
        borderRadius: style?.borderRadius,
      ),
      child: ClipRRect(
        borderRadius: style?.borderRadius ?? BorderRadius.zero,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Layer 1: Background decoration
            if (backLayer != null)
              Positioned.fill(
                child: Opacity(
                  opacity: 0.85,
                  child: backLayer!,
                ),
              ),

            // Layer 2: Middle contextual layer
            if (middleLayer != null)
              Positioned.fill(
                child: middleLayer!,
              ),

            // Layer 3: Foreground toolbar
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              height: style?.height ?? 64.0,
              child: Padding(
                padding:
                    style?.padding ?? const EdgeInsets.symmetric(horizontal: 16.0),
                child: NavigationToolbar(
                  leading: leading,
                  middle: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: style?.centerTitle == true
                        ? CrossAxisAlignment.center
                        : CrossAxisAlignment.start,
                    children: [
                      if (title != null)
                        DefaultTextStyle(
                          style:
                              style?.titleStyle ??
                              theme.textTheme.titleMedium!.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          child: title!,
                        ),
                      if (subtitle != null) ...[
                        const SizedBox(height: 1.0),
                        DefaultTextStyle(
                          style:
                              style?.subtitleStyle ??
                              theme.textTheme.bodySmall!.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          child: subtitle!,
                        ),
                      ],
                    ],
                  ),
                  trailing: actions != null && actions!.isNotEmpty
                      ? Row(mainAxisSize: MainAxisSize.min, children: actions!)
                      : null,
                  centerMiddle: style?.centerTitle ?? false,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Preset 36: Shape-Morphing Header
///
/// Persistent header that dynamically transforms its geometric shape,
/// corner radius, and margins as the user scrolls from expanded down to collapsed.
class ShapeMorphingHeaderWidget extends StatelessWidget
    with SliverWidgetMarker {
  /// Creates a [ShapeMorphingHeaderWidget].
  const ShapeMorphingHeaderWidget({
    super.key,
    this.title,
    this.subtitle,
    this.leading,
    this.actions,
    this.initialBorderRadius,
    this.scrolledBorderRadius,
    this.initialMargin,
    this.style,
    this.expandedHeight = 120.0,
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

  /// Initial border radius when expanded (defaults to 24px rounded card).
  final BorderRadius? initialBorderRadius;

  /// Scrolled border radius when collapsed (defaults to zero / rectangular).
  final BorderRadius? scrolledBorderRadius;

  /// Initial margin when expanded.
  final EdgeInsetsGeometry? initialMargin;

  /// Style configurations.
  final ScrollHeaderStyle? style;

  /// Expanded height of the morphing header.
  final double expandedHeight;

  /// Minimum collapsed toolbar height.
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

    final initRadius =
        initialBorderRadius ?? s.borderRadius ?? BorderRadius.circular(24.0);
    final finalRadius = scrolledBorderRadius ?? BorderRadius.zero;
    final initMargin =
        initialMargin ??
        s.margin ??
        const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0);

    return SliverPersistentHeader(
      pinned: s.pinned,
      floating: s.floating,
      delegate: PresetSliverHeaderDelegate(
        expandedHeight: totalExpanded,
        collapsedHeight: totalCollapsed,
        builder: (context, progress, overlapsContent) {
          final curRadius =
              BorderRadius.lerp(initRadius, finalRadius, progress) ??
              finalRadius;
          final curMargin =
              EdgeInsetsGeometry.lerp(initMargin, EdgeInsets.zero, progress) ??
              EdgeInsets.zero;
          final elevation =
              s.elevation + (s.scrolledElevation - s.elevation) * progress;

          return Container(
            color: theme.colorScheme.surface,
            child: Padding(
              padding: EdgeInsets.only(top: topPadding),
              child: Container(
                margin: curMargin,
                decoration: BoxDecoration(
                  color: s.backgroundColor ?? theme.colorScheme.surfaceContainer,
                  borderRadius: curRadius,
                  boxShadow: elevation > 0
                      ? [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.06),
                            blurRadius: elevation * 2,
                            offset: Offset(0, elevation),
                          ),
                        ]
                      : null,
                ),
                child: ClipRRect(
                  borderRadius: curRadius,
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: SizedBox(
                      height: collapsedHeight,
                      child: Padding(
                        padding: s.padding ??
                            const EdgeInsets.symmetric(horizontal: 16.0),
                        child: NavigationToolbar(
                          leading: leading,
                          middle: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: s.centerTitle == true
                                ? CrossAxisAlignment.center
                                : CrossAxisAlignment.start,
                            children: [
                              if (title != null)
                                DefaultTextStyle(
                                  style: s.titleStyle ??
                                      theme.textTheme.titleMedium!.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  child: title!,
                                ),
                              if (subtitle != null) ...[
                                const SizedBox(height: 1.0),
                                DefaultTextStyle(
                                  style: s.subtitleStyle ??
                                      theme.textTheme.bodySmall!.copyWith(
                                        color: theme
                                            .colorScheme.onSurfaceVariant,
                                      ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  child: subtitle!,
                                ),
                              ],
                            ],
                          ),
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
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

/// Preset 37: Animated Gradient Header
///
/// Header with a shifting linear gradient progression providing
/// vibrant ambient visual depth with low battery and CPU footprint.
class AnimatedGradientHeaderWidget extends StatefulWidget {
  /// Creates an [AnimatedGradientHeaderWidget].
  const AnimatedGradientHeaderWidget({
    super.key,
    this.title,
    this.subtitle,
    this.leading,
    this.actions,
    this.animatedColors,
    this.animationDuration = const Duration(seconds: 4),
    this.style,
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

  /// List of gradient colors to animate across.
  final List<Color>? animatedColors;

  /// Duration of one complete gradient loop.
  final Duration animationDuration;

  /// Style configurations.
  final ScrollHeaderStyle? style;

  /// Whether to pad for top safe insets.
  final bool safeArea;

  @override
  State<AnimatedGradientHeaderWidget> createState() =>
      _AnimatedGradientHeaderWidgetState();
}

class _AnimatedGradientHeaderWidgetState
    extends State<AnimatedGradientHeaderWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
    )..repeat(reverse: true);
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final topPadding = widget.safeArea ? MediaQuery.paddingOf(context).top : 0.0;
    final colors = widget.animatedColors ??
        [
          theme.colorScheme.primary,
          theme.colorScheme.tertiary,
          theme.colorScheme.secondary,
        ];

    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, _) {
          final t = _animation.value;
          final beginAlign = Alignment.lerp(
            Alignment.topLeft,
            Alignment.topRight,
            t,
          )!;
          final endAlign = Alignment.lerp(
            Alignment.bottomRight,
            Alignment.bottomLeft,
            t,
          )!;

          return Container(
            margin: widget.style?.margin,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: colors,
                begin: beginAlign,
                end: endAlign,
              ),
              borderRadius: widget.style?.borderRadius,
            ),
            child: Padding(
              padding: EdgeInsets.only(top: topPadding),
              child: SizedBox(
                height: widget.style?.height ?? 56.0,
                child: Padding(
                  padding: widget.style?.padding ??
                      const EdgeInsets.symmetric(horizontal: 16.0),
                  child: NavigationToolbar(
                    leading: widget.leading != null
                        ? IconTheme(
                            data: const IconThemeData(color: Colors.white),
                            child: widget.leading!,
                          )
                        : null,
                    middle: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: widget.style?.centerTitle == true
                          ? CrossAxisAlignment.center
                          : CrossAxisAlignment.start,
                      children: [
                        if (widget.title != null)
                          DefaultTextStyle(
                            style: widget.style?.titleStyle ??
                                theme.textTheme.titleMedium!.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            child: widget.title!,
                          ),
                        if (widget.subtitle != null) ...[
                          const SizedBox(height: 1.0),
                          DefaultTextStyle(
                            style: widget.style?.subtitleStyle ??
                                theme.textTheme.bodySmall!.copyWith(
                                  color: Colors.white70,
                                ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            child: widget.subtitle!,
                          ),
                        ],
                      ],
                    ),
                    trailing: widget.actions != null &&
                            widget.actions!.isNotEmpty
                        ? IconTheme(
                            data: const IconThemeData(color: Colors.white),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: widget.actions!,
                            ),
                          )
                        : null,
                    centerMiddle: widget.style?.centerTitle ?? false,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

/// Preset 38: Color-Transition Header
///
/// Persistent header whose background and foreground typography/icons
/// smoothly interpolate across a color gradient based on scroll depth.
class ColorTransitionHeaderWidget extends StatelessWidget
    with SliverWidgetMarker {
  /// Creates a [ColorTransitionHeaderWidget].
  const ColorTransitionHeaderWidget({
    super.key,
    this.title,
    this.subtitle,
    this.leading,
    this.actions,
    this.startBackgroundColor,
    this.endBackgroundColor,
    this.startForegroundColor,
    this.endForegroundColor,
    this.style,
    this.expandedHeight = 120.0,
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

  /// Background color when fully unscroll-expanded.
  final Color? startBackgroundColor;

  /// Background color when fully scrolled.
  final Color? endBackgroundColor;

  /// Foreground icon/text color when unscroll-expanded.
  final Color? startForegroundColor;

  /// Foreground icon/text color when scrolled.
  final Color? endForegroundColor;

  /// Style configurations.
  final ScrollHeaderStyle? style;

  /// Expanded height.
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

    final bgStart =
        startBackgroundColor ?? s.backgroundColor ?? theme.colorScheme.primary;
    final bgEnd = endBackgroundColor ??
        s.scrolledBackgroundColor ??
        theme.colorScheme.surface;
    final fgStart = startForegroundColor ?? Colors.white;
    final fgEnd = endForegroundColor ?? theme.colorScheme.onSurface;

    return SliverPersistentHeader(
      pinned: s.pinned,
      floating: s.floating,
      delegate: PresetSliverHeaderDelegate(
        expandedHeight: totalExpanded,
        collapsedHeight: totalCollapsed,
        builder: (context, progress, overlapsContent) {
          final curBg = Color.lerp(bgStart, bgEnd, progress) ?? bgStart;
          final curFg = Color.lerp(fgStart, fgEnd, progress) ?? fgStart;

          return Container(
            color: curBg,
            child: Padding(
              padding: EdgeInsets.only(top: topPadding),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: SizedBox(
                  height: collapsedHeight,
                  child: Padding(
                    padding: s.padding ??
                        const EdgeInsets.symmetric(horizontal: 16.0),
                    child: IconTheme(
                      data: IconThemeData(color: curFg),
                      child: NavigationToolbar(
                        leading: leading,
                        middle: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: s.centerTitle == true
                              ? CrossAxisAlignment.center
                              : CrossAxisAlignment.start,
                          children: [
                            if (title != null)
                              DefaultTextStyle(
                                style: s.titleStyle ??
                                    theme.textTheme.titleMedium!.copyWith(
                                      color: curFg,
                                      fontWeight: FontWeight.bold,
                                    ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                child: title!,
                              ),
                            if (subtitle != null) ...[
                              const SizedBox(height: 1.0),
                              DefaultTextStyle(
                                style: s.subtitleStyle ??
                                    theme.textTheme.bodySmall!.copyWith(
                                      color: curFg.withValues(alpha: 0.8),
                                    ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                child: subtitle!,
                              ),
                            ],
                          ],
                        ),
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
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

/// Preset 39: Illustrated Header
///
/// Collapsing persistent header showcasing a prominent vector/image illustration
/// in the expanded banner that smoothly fades and scales down on scroll.
class IllustratedHeaderWidget extends StatelessWidget with SliverWidgetMarker {
  /// Creates an [IllustratedHeaderWidget].
  const IllustratedHeaderWidget({
    super.key,
    required this.illustration,
    this.title,
    this.subtitle,
    this.leading,
    this.actions,
    this.style,
    this.expandedHeight = 220.0,
    this.collapsedHeight = kToolbarHeight,
    this.safeArea = true,
  });

  /// The decorative illustration widget shown in the expanded area.
  final Widget illustration;

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

  /// Expanded height of the illustrated banner.
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
          final fadeOpacity = (1.0 - progress * 1.3).clamp(0.0, 1.0);
          final scale = (1.0 - progress * 0.15).clamp(0.85, 1.0);

          return Container(
            color: s.backgroundColor ?? theme.colorScheme.surface,
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Illustration Layer
                if (fadeOpacity > 0.01)
                  Positioned(
                    top: topPadding + 20.0,
                    left: 24.0,
                    right: 24.0,
                    bottom: collapsedHeight,
                    child: Opacity(
                      opacity: fadeOpacity,
                      child: Transform.scale(
                        scale: scale,
                        child: Center(child: illustration),
                      ),
                    ),
                  ),

                // Top Fixed Toolbar
                Positioned(
                  top: topPadding,
                  left: 0,
                  right: 0,
                  height: collapsedHeight,
                  child: Padding(
                    padding: s.padding ??
                        const EdgeInsets.symmetric(horizontal: 16.0),
                    child: NavigationToolbar(
                      leading: leading,
                      middle: progress > 0.6
                          ? Opacity(
                              opacity: ((progress - 0.6) / 0.4).clamp(0.0, 1.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: s.centerTitle == true
                                    ? CrossAxisAlignment.center
                                    : CrossAxisAlignment.start,
                                children: [
                                  if (title != null)
                                    DefaultTextStyle(
                                      style: s.titleStyle ??
                                          theme.textTheme.titleMedium!.copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      child: title!,
                                    ),
                                  if (subtitle != null)
                                    DefaultTextStyle(
                                      style: s.subtitleStyle ??
                                          theme.textTheme.bodySmall!.copyWith(
                                            color: theme
                                                .colorScheme.onSurfaceVariant,
                                          ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      child: subtitle!,
                                    ),
                                ],
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
              ],
            ),
          );
        },
      ),
    );
  }
}

/// Preset 40: Edge-to-Edge Header
///
/// Seamless margin-free header designed for modern edge-to-edge screens,
/// extending directly behind status bars and display cutouts with full bleed.
class EdgeToEdgeHeaderWidget extends StatelessWidget {
  /// Creates an [EdgeToEdgeHeaderWidget].
  const EdgeToEdgeHeaderWidget({
    super.key,
    this.title,
    this.subtitle,
    this.leading,
    this.actions,
    this.style,
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

  /// Whether to pad for top safe insets.
  final bool safeArea;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final topPadding = safeArea ? MediaQuery.paddingOf(context).top : 0.0;
    final s = (style ?? const ScrollHeaderStyle()).copyWith(
      margin: EdgeInsets.zero,
      borderRadius: BorderRadius.zero,
      backgroundColor: style?.backgroundColor ?? theme.colorScheme.surface,
      scrolledBackgroundColor:
          style?.scrolledBackgroundColor ?? theme.colorScheme.surfaceContainer,
      elevation: style?.elevation ?? 0.0,
      scrolledElevation: style?.scrolledElevation ?? 2.0,
      showDivider: style?.showDivider ?? true,
    );

    return Container(
      color: s.backgroundColor,
      child: Padding(
        padding: EdgeInsets.only(top: topPadding),
        child: SizedBox(
          height: s.height,
          child: Padding(
            padding:
                s.padding ?? const EdgeInsets.symmetric(horizontal: 16.0),
            child: NavigationToolbar(
              leading: leading,
              middle: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: s.centerTitle == true
                    ? CrossAxisAlignment.center
                    : CrossAxisAlignment.start,
                children: [
                  if (title != null)
                    DefaultTextStyle(
                      style: s.titleStyle ??
                          theme.textTheme.titleMedium!.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      child: title!,
                    ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 1.0),
                    DefaultTextStyle(
                      style: s.subtitleStyle ??
                          theme.textTheme.bodySmall!.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      child: subtitle!,
                    ),
                  ],
                ],
              ),
              trailing: actions != null && actions!.isNotEmpty
                  ? Row(mainAxisSize: MainAxisSize.min, children: actions!)
                  : null,
              centerMiddle: s.centerTitle ?? false,
            ),
          ),
        ),
      ),
    );
  }
}

