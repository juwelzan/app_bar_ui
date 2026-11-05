import 'package:flutter/material.dart';

import '../scroll_header_style.dart';
import 'base_header.dart';

/// Preset 1: Minimal Header
/// Clean, simple, low visual weight with an optional scroll-triggered hairline divider.
class MinimalHeaderWidget extends StatelessWidget {
  /// Creates a [MinimalHeaderWidget].
  const MinimalHeaderWidget({
    super.key,
    this.title,
    this.subtitle,
    this.leading,
    this.actions,
    this.style,
    this.safeArea = true,
  });

  /// Main title widget.
  final Widget? title;

  /// Optional subtitle widget.
  final Widget? subtitle;

  /// Leading widget (e.g. back button, menu icon).
  final Widget? leading;

  /// Trailing action buttons.
  final List<Widget>? actions;

  /// Style configurations.
  final ScrollHeaderStyle? style;

  /// Whether to pad for top safe insets.
  final bool safeArea;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final s = (style ?? const ScrollHeaderStyle()).copyWith(
      elevation: style?.elevation ?? 0.0,
      scrolledElevation: style?.scrolledElevation ?? 0.5,
      showDivider: style?.showDivider ?? true,
    );

    return HeaderContainer(
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
                      fontWeight: FontWeight.w600,
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

/// Preset 2: Transparent Header
/// Fully transparent background over scrollable content with optional blur and contrast.
class TransparentHeaderWidget extends StatelessWidget {
  /// Creates a [TransparentHeaderWidget].
  const TransparentHeaderWidget({
    super.key,
    this.title,
    this.subtitle,
    this.leading,
    this.actions,
    this.style,
    this.safeArea = true,
  });

  /// Main title widget.
  final Widget? title;

  /// Subtitle widget.
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
      backgroundColor: style?.backgroundColor ?? Colors.transparent,
      scrolledBackgroundColor:
          style?.scrolledBackgroundColor ??
          theme.colorScheme.surface.withValues(alpha: 0.85),
      elevation: style?.elevation ?? 0.0,
      scrolledElevation: style?.scrolledElevation ?? 0.0,
      blurBackground: style?.blurBackground ?? true,
    );

    return HeaderContainer(
      style: s,
      safeArea: safeArea,
      child: NavigationToolbar(
        leading: leading,
        middle: title != null
            ? DefaultTextStyle(
                style:
                    s.titleStyle ??
                    theme.textTheme.titleMedium!.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                child: title!,
              )
            : null,
        trailing: actions != null && actions!.isNotEmpty
            ? Row(mainAxisSize: MainAxisSize.min, children: actions!)
            : null,
        centerMiddle: s.centerTitle ?? true,
      ),
    );
  }
}

/// Preset 3: Floating Header
/// Rounded "island" header card floating above content with configurable margins and shadows.
class FloatingHeaderWidget extends StatelessWidget {
  /// Creates a [FloatingHeaderWidget].
  const FloatingHeaderWidget({
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

  /// Leading icon.
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
      margin:
          style?.margin ??
          const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      borderRadius: style?.borderRadius ?? BorderRadius.circular(16.0),
      elevation: style?.elevation ?? 2.0,
      scrolledElevation: style?.scrolledElevation ?? 6.0,
      backgroundColor:
          style?.backgroundColor ?? theme.colorScheme.surfaceContainerHighest,
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
                    theme.textTheme.titleSmall!.copyWith(
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
        centerMiddle: false,
      ),
    );
  }
}

/// Preset 6: Center Title Header
/// Symmetrically balanced header with strictly centered title and balanced action slots.
class CenterTitleHeaderWidget extends StatelessWidget {
  /// Creates a [CenterTitleHeaderWidget].
  const CenterTitleHeaderWidget({
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
      centerTitle: true,
      elevation: style?.elevation ?? 0.0,
      scrolledElevation: style?.scrolledElevation ?? 2.0,
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
                    theme.textTheme.titleMedium!.copyWith(
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
        centerMiddle: true,
      ),
    );
  }
}
