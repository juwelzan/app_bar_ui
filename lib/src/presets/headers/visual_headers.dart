import 'dart:ui' as ui;

import 'package:flutter/material.dart';

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
