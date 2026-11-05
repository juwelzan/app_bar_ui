import 'package:flutter/material.dart';

import '../scroll_header_style.dart';
import 'base_header.dart';

/// Preset 4: Material Inspired Header
/// Material Design 3 style with tonal surface colors, standard elevation, and scroll tint.
class MaterialHeaderWidget extends StatelessWidget {
  /// Creates a [MaterialHeaderWidget].
  const MaterialHeaderWidget({
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
    final s = (style ?? const ScrollHeaderStyle()).copyWith(
      backgroundColor: style?.backgroundColor ?? theme.colorScheme.surface,
      scrolledBackgroundColor:
          style?.scrolledBackgroundColor ?? theme.colorScheme.surfaceContainer,
      elevation: style?.elevation ?? 0.0,
      scrolledElevation: style?.scrolledElevation ?? 3.0,
      showDivider: style?.showDivider ?? false,
    );

    return HeaderContainer(
      style: s,
      safeArea: safeArea,
      child: NavigationToolbar(
        leading: leading,
        middle: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (title != null)
              DefaultTextStyle(
                style:
                    s.titleStyle ??
                    theme.textTheme.titleMedium!.copyWith(
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.15,
                    ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
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
    );
  }
}

/// Preset 5: iOS Inspired Header
/// Cupertino navigation style with SF typography, hairline divider, and compact layout.
class IOSHeaderWidget extends StatelessWidget {
  /// Creates an [IOSHeaderWidget].
  const IOSHeaderWidget({
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
    final isDark = theme.brightness == Brightness.dark;
    final s = (style ?? const ScrollHeaderStyle()).copyWith(
      height: style?.height ?? 44.0,
      backgroundColor:
          style?.backgroundColor ?? (isDark ? Colors.black54 : Colors.white70),
      scrolledBackgroundColor:
          style?.scrolledBackgroundColor ??
          (isDark ? Colors.black87 : Colors.white),
      blurBackground: style?.blurBackground ?? true,
      blurSigma: style?.blurSigma ?? 15.0,
      showDivider: style?.showDivider ?? true,
      dividerColor:
          style?.dividerColor ?? (isDark ? Colors.white12 : Colors.black12),
      centerTitle: style?.centerTitle ?? true,
    );

    return HeaderContainer(
      style: s,
      safeArea: safeArea,
      child: NavigationToolbar(
        leading: leading,
        middle: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (title != null)
              DefaultTextStyle(
                style:
                    s.titleStyle ??
                    theme.textTheme.titleSmall!.copyWith(
                      fontWeight: FontWeight.w600,
                      letterSpacing: -0.2,
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
                      fontSize: 11.0,
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
        centerMiddle: true,
      ),
    );
  }
}

/// Preset 11: Gradient Header
/// Multi-stop linear or radial gradient background with contrasting content.
class GradientHeaderWidget extends StatelessWidget {
  /// Creates a [GradientHeaderWidget].
  const GradientHeaderWidget({
    super.key,
    this.title,
    this.subtitle,
    this.leading,
    this.actions,
    this.gradient,
    this.scrolledGradient,
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

  /// Background gradient.
  final Gradient? gradient;

  /// Gradient applied when scrolled.
  final Gradient? scrolledGradient;

  /// Style configurations.
  final ScrollHeaderStyle? style;

  /// Whether to pad for top safe insets.
  final bool safeArea;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final defaultGradient = LinearGradient(
      colors: [theme.colorScheme.primary, theme.colorScheme.tertiary],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );

    final s = (style ?? const ScrollHeaderStyle()).copyWith(
      gradient: gradient ?? style?.gradient ?? defaultGradient,
      scrolledGradient: scrolledGradient ?? style?.scrolledGradient,
      elevation: style?.elevation ?? 0.0,
      scrolledElevation: style?.scrolledElevation ?? 4.0,
    );

    return HeaderContainer(
      style: s,
      safeArea: safeArea,
      child: NavigationToolbar(
        leading: leading != null
            ? IconTheme(
                data: const IconThemeData(color: Colors.white),
                child: leading!,
              )
            : null,
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
                    const TextStyle(
                      color: Colors.white,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                child: title!,
              ),
            if (subtitle != null) ...[
              const SizedBox(height: 2.0),
              DefaultTextStyle(
                style:
                    s.subtitleStyle ??
                    const TextStyle(color: Colors.white70, fontSize: 12.0),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                child: subtitle!,
              ),
            ],
          ],
        ),
        trailing: actions != null && actions!.isNotEmpty
            ? IconTheme(
                data: const IconThemeData(color: Colors.white),
                child: Row(mainAxisSize: MainAxisSize.min, children: actions!),
              )
            : null,
        centerMiddle: s.centerTitle ?? false,
      ),
    );
  }
}

/// Preset 12: Image Background Header
/// High-resolution image background with dark/light scrim overlay gradient.
class ImageBackgroundHeaderWidget extends StatelessWidget {
  /// Creates an [ImageBackgroundHeaderWidget].
  const ImageBackgroundHeaderWidget({
    super.key,
    this.title,
    this.subtitle,
    this.leading,
    this.actions,
    this.image,
    this.overlayGradient,
    this.overlayColor,
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

  /// Background image decoration or widget.
  final ImageProvider? image;

  /// Scrim overlay gradient for text contrast.
  final Gradient? overlayGradient;

  /// Solid scrim color if gradient is not specified.
  final Color? overlayColor;

  /// Style configurations.
  final ScrollHeaderStyle? style;

  /// Whether to pad for top safe insets.
  final bool safeArea;

  @override
  Widget build(BuildContext context) {
    final s = style ?? const ScrollHeaderStyle();
    final topPadding = safeArea ? MediaQuery.paddingOf(context).top : 0.0;
    final defaultOverlay = LinearGradient(
      colors: [
        Colors.black.withValues(alpha: 0.65),
        Colors.black.withValues(alpha: 0.25),
      ],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    );

    return Container(
      height: s.height + topPadding,
      decoration: BoxDecoration(
        image: image != null
            ? DecorationImage(image: image!, fit: BoxFit.cover)
            : null,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: overlayColor,
          gradient: overlayColor == null
              ? (overlayGradient ?? defaultOverlay)
              : null,
        ),
        padding: EdgeInsets.only(top: topPadding),
        child: Padding(
          padding: s.padding ?? const EdgeInsets.symmetric(horizontal: 16.0),
          child: NavigationToolbar(
            leading: leading != null
                ? IconTheme(
                    data: const IconThemeData(color: Colors.white),
                    child: leading!,
                  )
                : null,
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
                        const TextStyle(
                          color: Colors.white,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    child: title!,
                  ),
                if (subtitle != null) ...[
                  const SizedBox(height: 2.0),
                  DefaultTextStyle(
                    style:
                        s.subtitleStyle ??
                        const TextStyle(color: Colors.white70, fontSize: 12.0),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    child: subtitle!,
                  ),
                ],
              ],
            ),
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
    );
  }
}
