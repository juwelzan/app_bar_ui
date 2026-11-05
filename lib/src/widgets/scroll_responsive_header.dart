import 'package:flutter/material.dart';

/// A scroll-responsive header widget designed to scroll naturally away with the page.
///
/// Supports app titles, subtitles, welcome greetings, profile information, and
/// arbitrary custom content while maintaining clean layout boundaries.
class ScrollResponsiveHeader extends StatelessWidget {
  /// Creates a [ScrollResponsiveHeader].
  const ScrollResponsiveHeader({
    super.key,
    this.title,
    this.subtitle,
    this.welcome,
    this.avatar,
    this.content,
    this.actions,
    this.padding = const EdgeInsets.fromLTRB(16.0, 68.0, 16.0, 16.0),
    this.margin,
    this.backgroundColor = Colors.transparent,
    this.decoration,
    this.crossAxisAlignment = CrossAxisAlignment.start,
  });

  /// The main application or screen title.
  final Widget? title;

  /// Subtitle or slogan displayed below the title.
  final Widget? subtitle;

  /// Optional welcome banner or greeting text (e.g. "Good morning, Alex").
  final Widget? welcome;

  /// Optional profile avatar widget displayed within the header content flow.
  final Widget? avatar;

  /// Additional custom header widgets or content sections.
  final Widget? content;

  /// Optional action widgets placed inside the scrollable header area.
  final List<Widget>? actions;

  /// Padding surrounding the header content.
  ///
  /// Defaults to top padding of 68.0 to ensure clearance below the pinned actions row.
  final EdgeInsetsGeometry padding;

  /// Margin around the header container.
  final EdgeInsetsGeometry? margin;

  /// Background color of the header container. Defaults to [Colors.transparent].
  final Color backgroundColor;

  /// Optional custom decoration for the header container.
  final Decoration? decoration;

  /// Horizontal alignment of children in the column.
  final CrossAxisAlignment crossAxisAlignment;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: margin,
      padding: padding,
      decoration: decoration ?? BoxDecoration(color: backgroundColor),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: crossAxisAlignment,
        children: [
          if (welcome != null) ...[
            DefaultTextStyle(
              style:
                  theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ) ??
                  const TextStyle(fontSize: 14.0),
              child: welcome!,
            ),
            const SizedBox(height: 4.0),
          ],
          if (avatar != null || title != null || actions != null)
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (avatar != null) ...[avatar!, const SizedBox(width: 12.0)],
                if (title != null)
                  Expanded(
                    child: DefaultTextStyle(
                      style:
                          theme.textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.onSurface,
                          ) ??
                          const TextStyle(
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold,
                          ),
                      child: title!,
                    ),
                  ),
                ...?actions,
              ],
            ),
          if (subtitle != null) ...[
            const SizedBox(height: 6.0),
            DefaultTextStyle(
              style:
                  theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ) ??
                  const TextStyle(fontSize: 14.0),
              child: subtitle!,
            ),
          ],
          if (content != null) ...[const SizedBox(height: 12.0), content!],
        ],
      ),
    );
  }
}
