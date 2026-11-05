import 'package:flutter/material.dart';

import '../scroll_header_style.dart';
import 'base_header.dart';

/// Preset 21: Bottom-Aligned Title Header
///
/// An editorial and media-friendly header where the title and subtitle are anchored
/// at the bottom of the header space, while leading and actions sit at the top.
class BottomAlignedTitleHeaderWidget extends StatelessWidget {
  /// Creates a [BottomAlignedTitleHeaderWidget].
  const BottomAlignedTitleHeaderWidget({
    super.key,
    this.title,
    this.subtitle,
    this.leading,
    this.actions,
    this.style,
    this.safeArea = true,
  });

  /// Main title widget anchored at the bottom edge.
  final Widget? title;

  /// Subtitle widget below the title.
  final Widget? subtitle;

  /// Leading navigation widget at the top-left.
  final Widget? leading;

  /// Trailing actions at the top-right.
  final List<Widget>? actions;

  /// Style configurations.
  final ScrollHeaderStyle? style;

  /// Whether to pad for top safe insets.
  final bool safeArea;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final s = (style ?? const ScrollHeaderStyle()).copyWith(
      height: style?.height ?? 96.0,
      backgroundColor: style?.backgroundColor ?? theme.colorScheme.surface,
      scrolledBackgroundColor:
          style?.scrolledBackgroundColor ?? theme.colorScheme.surfaceContainer,
      elevation: style?.elevation ?? 0.0,
      scrolledElevation: style?.scrolledElevation ?? 2.0,
      showDivider: style?.showDivider ?? true,
    );

    return HeaderContainer(
      style: s,
      safeArea: safeArea,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (leading != null) leading! else const SizedBox.shrink(),
              if (actions != null && actions!.isNotEmpty)
                Row(mainAxisSize: MainAxisSize.min, children: actions!),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 6.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: s.centerTitle == true
                  ? CrossAxisAlignment.center
                  : CrossAxisAlignment.start,
              children: [
                if (title != null)
                  DefaultTextStyle(
                    style:
                        s.titleStyle ??
                        theme.textTheme.titleLarge!.copyWith(
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
          ),
        ],
      ),
    );
  }
}

/// Preset 22: Asymmetric Header
///
/// An unbalanced, modern layout with dynamic visual weight. Features an accented
/// leading focal section, offset title and subtitle typography, and a compact action cluster.
class AsymmetricHeaderWidget extends StatelessWidget {
  /// Creates an [AsymmetricHeaderWidget].
  const AsymmetricHeaderWidget({
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

  /// Leading widget with asymmetric accent styling.
  final Widget? leading;

  /// Trailing actions cluster.
  final List<Widget>? actions;

  /// Style configurations.
  final ScrollHeaderStyle? style;

  /// Whether to pad for top safe insets.
  final bool safeArea;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final s = (style ?? const ScrollHeaderStyle()).copyWith(
      height: style?.height ?? 64.0,
      backgroundColor: style?.backgroundColor ?? theme.colorScheme.surface,
      scrolledBackgroundColor:
          style?.scrolledBackgroundColor ?? theme.colorScheme.surfaceContainer,
      elevation: style?.elevation ?? 0.0,
      scrolledElevation: style?.scrolledElevation ?? 2.0,
      showDivider: style?.showDivider ?? true,
    );

    return HeaderContainer(
      style: s,
      safeArea: safeArea,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (leading != null)
            Container(
              margin: const EdgeInsets.only(right: 12.0),
              padding: const EdgeInsets.all(4.0),
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer.withValues(
                  alpha: 0.7,
                ),
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: leading,
            ),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (title != null)
                  DefaultTextStyle(
                    style:
                        s.titleStyle ??
                        theme.textTheme.titleMedium!.copyWith(
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.3,
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
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w500,
                        ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    child: subtitle!,
                  ),
                ],
              ],
            ),
          ),
          if (actions != null && actions!.isNotEmpty)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest.withValues(
                  alpha: 0.5,
                ),
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Row(mainAxisSize: MainAxisSize.min, children: actions!),
            ),
        ],
      ),
    );
  }
}

/// Preset 23: Split Header
///
/// Breaks the navigation bar into two distinct visual compartments:
/// a left navigation & title compartment, and a right contextual actions compartment.
class SplitHeaderWidget extends StatelessWidget {
  /// Creates a [SplitHeaderWidget].
  const SplitHeaderWidget({
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

  /// Leading widget in left compartment.
  final Widget? leading;

  /// Trailing actions in right compartment.
  final List<Widget>? actions;

  /// Style configurations.
  final ScrollHeaderStyle? style;

  /// Whether to pad for top safe insets.
  final bool safeArea;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final s = (style ?? const ScrollHeaderStyle()).copyWith(
      height: style?.height ?? 60.0,
      backgroundColor: style?.backgroundColor ?? theme.colorScheme.surface,
      scrolledBackgroundColor:
          style?.scrolledBackgroundColor ?? theme.colorScheme.surfaceContainer,
      elevation: style?.elevation ?? 0.0,
      scrolledElevation: style?.scrolledElevation ?? 1.5,
      showDivider: style?.showDivider ?? false,
    );

    return HeaderContainer(
      style: s,
      safeArea: safeArea,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 10.0,
                vertical: 6.0,
              ),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerLow,
                borderRadius: BorderRadius.circular(16.0),
                border: Border.all(
                  color: theme.colorScheme.outlineVariant.withValues(
                    alpha: 0.5,
                  ),
                  width: 0.8,
                ),
              ),
              child: Row(
                children: [
                  if (leading != null) ...[
                    leading!,
                    const SizedBox(width: 8.0),
                  ],
                  Expanded(
                    child: Column(
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
                        if (subtitle != null)
                          DefaultTextStyle(
                            style:
                                s.subtitleStyle ??
                                theme.textTheme.labelSmall!.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            child: subtitle!,
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (actions != null && actions!.isNotEmpty) ...[
            const SizedBox(width: 8.0),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 4.0,
                vertical: 4.0,
              ),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerLow,
                borderRadius: BorderRadius.circular(16.0),
                border: Border.all(
                  color: theme.colorScheme.outlineVariant.withValues(
                    alpha: 0.5,
                  ),
                  width: 0.8,
                ),
              ),
              child: Row(mainAxisSize: MainAxisSize.min, children: actions!),
            ),
          ],
        ],
      ),
    );
  }
}

/// Preset 24: Two-Row Header
///
/// Two stacked rows of navigation and tools: upper row for leading, title, and actions;
/// lower row for secondary controls, filter chips, search shortcuts, or custom widgets.
class TwoRowHeaderWidget extends StatelessWidget {
  /// Creates a [TwoRowHeaderWidget].
  const TwoRowHeaderWidget({
    super.key,
    this.title,
    this.subtitle,
    this.leading,
    this.actions,
    this.bottomRow,
    this.style,
    this.safeArea = true,
  });

  /// Main title.
  final Widget? title;

  /// Subtitle.
  final Widget? subtitle;

  /// Leading widget.
  final Widget? leading;

  /// Trailing actions in upper row.
  final List<Widget>? actions;

  /// Secondary row widget beneath the main bar.
  final Widget? bottomRow;

  /// Style configurations.
  final ScrollHeaderStyle? style;

  /// Whether to pad for top safe insets.
  final bool safeArea;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final s = (style ?? const ScrollHeaderStyle()).copyWith(
      height: style?.height ?? 110.0,
      backgroundColor: style?.backgroundColor ?? theme.colorScheme.surface,
      scrolledBackgroundColor:
          style?.scrolledBackgroundColor ?? theme.colorScheme.surfaceContainer,
      elevation: style?.elevation ?? 0.0,
      scrolledElevation: style?.scrolledElevation ?? 2.0,
      showDivider: style?.showDivider ?? true,
    );

    return HeaderContainer(
      style: s,
      safeArea: safeArea,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: 48.0,
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
                            fontSize: 11.0,
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
          if (bottomRow != null)
            Expanded(
              child: Align(
                alignment: Alignment.centerLeft,
                child: bottomRow!,
              ),
            ),
        ],
      ),
    );
  }
}

/// Preset 25: Multi-Action Header
///
/// Optimized for toolbars with many actions. Automatically partitions actions
/// into [maxVisibleActions] primary icons and groups the rest into an overflow menu.
class MultiActionHeaderWidget extends StatelessWidget {
  /// Creates a [MultiActionHeaderWidget].
  const MultiActionHeaderWidget({
    super.key,
    this.title,
    this.subtitle,
    this.leading,
    this.actions,
    this.maxVisibleActions = 2,
    this.overflowIcon,
    this.style,
    this.safeArea = true,
  });

  /// Main title.
  final Widget? title;

  /// Subtitle.
  final Widget? subtitle;

  /// Leading widget.
  final Widget? leading;

  /// Complete list of actions.
  final List<Widget>? actions;

  /// Maximum number of primary actions visible before collapsing to overflow.
  final int maxVisibleActions;

  /// Custom icon for the overflow button.
  final Widget? overflowIcon;

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
      scrolledElevation: style?.scrolledElevation ?? 2.0,
      showDivider: style?.showDivider ?? true,
    );

    final allActions = actions ?? const <Widget>[];
    final bool hasOverflow = allActions.length > maxVisibleActions;
    final visibleActions = hasOverflow
        ? allActions.take(maxVisibleActions).toList()
        : allActions;
    final overflowActions = hasOverflow
        ? allActions.skip(maxVisibleActions).toList()
        : const <Widget>[];

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
        trailing: allActions.isNotEmpty
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ...visibleActions,
                  if (hasOverflow)
                    PopupMenuButton<int>(
                      icon: overflowIcon ?? const Icon(Icons.more_vert),
                      tooltip: 'More actions',
                      itemBuilder: (context) {
                        return [
                          for (int i = 0; i < overflowActions.length; i++)
                            PopupMenuItem<int>(
                              value: i,
                              child: overflowActions[i],
                            ),
                        ];
                      },
                      onSelected: (index) {
                        final item = overflowActions[index];
                        if (item is IconButton && item.onPressed != null) {
                          item.onPressed!();
                        }
                      },
                    ),
                ],
              )
            : null,
        centerMiddle: s.centerTitle ?? false,
      ),
    );
  }
}

/// Preset 26: Compact Icon Header
///
/// Ultra-minimal, icon-centric navigation bar with reduced height (48px)
/// and prominent touch targets for primary tool actions.
class CompactIconHeaderWidget extends StatelessWidget {
  /// Creates a [CompactIconHeaderWidget].
  const CompactIconHeaderWidget({
    super.key,
    this.title,
    this.leading,
    this.actions,
    this.style,
    this.safeArea = true,
  });

  /// Optional compact title or badge widget.
  final Widget? title;

  /// Leading navigation icon.
  final Widget? leading;

  /// Icon actions displayed in the compact bar.
  final List<Widget>? actions;

  /// Style configurations.
  final ScrollHeaderStyle? style;

  /// Whether to pad for top safe insets.
  final bool safeArea;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final s = (style ?? const ScrollHeaderStyle()).copyWith(
      height: style?.height ?? 48.0,
      backgroundColor: style?.backgroundColor ?? theme.colorScheme.surface,
      scrolledBackgroundColor:
          style?.scrolledBackgroundColor ?? theme.colorScheme.surfaceContainer,
      elevation: style?.elevation ?? 0.0,
      scrolledElevation: style?.scrolledElevation ?? 1.5,
      showDivider: style?.showDivider ?? true,
      padding:
          style?.padding ?? const EdgeInsets.symmetric(horizontal: 8.0),
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
                    theme.textTheme.labelLarge!.copyWith(
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

/// Preset 27: Breadcrumb Header
///
/// Hierarchical breadcrumb navigation header allowing seamless traversal
/// through nested page hierarchies with automatic horizontal scrolling on small screens.
class BreadcrumbHeaderWidget extends StatelessWidget {
  /// Creates a [BreadcrumbHeaderWidget].
  const BreadcrumbHeaderWidget({
    super.key,
    required this.breadcrumbs,
    this.separator,
    this.leading,
    this.actions,
    this.onBreadcrumbTap,
    this.style,
    this.safeArea = true,
  });

  /// List of breadcrumb item widgets.
  final List<Widget> breadcrumbs;

  /// Separator between breadcrumb items. Defaults to a chevron right.
  final Widget? separator;

  /// Optional leading widget before breadcrumbs.
  final Widget? leading;

  /// Trailing actions.
  final List<Widget>? actions;

  /// Optional tap callback receiving the index of the tapped breadcrumb.
  final ValueChanged<int>? onBreadcrumbTap;

  /// Style configurations.
  final ScrollHeaderStyle? style;

  /// Whether to pad for top safe insets.
  final bool safeArea;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final s = (style ?? const ScrollHeaderStyle()).copyWith(
      height: style?.height ?? 54.0,
      backgroundColor: style?.backgroundColor ?? theme.colorScheme.surface,
      scrolledBackgroundColor:
          style?.scrolledBackgroundColor ?? theme.colorScheme.surfaceContainer,
      elevation: style?.elevation ?? 0.0,
      scrolledElevation: style?.scrolledElevation ?? 1.5,
      showDivider: style?.showDivider ?? true,
    );

    final sep = separator ??
        Icon(
          Icons.chevron_right,
          size: 16.0,
          color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
        );

    final items = <Widget>[];
    for (int i = 0; i < breadcrumbs.length; i++) {
      final isLast = i == breadcrumbs.length - 1;
      Widget crumb = breadcrumbs[i];

      if (onBreadcrumbTap != null && !isLast) {
        crumb = InkWell(
          borderRadius: BorderRadius.circular(6.0),
          onTap: () => onBreadcrumbTap!(i),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 2.0),
            child: crumb,
          ),
        );
      }

      items.add(crumb);
      if (!isLast) {
        items.add(
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: sep,
          ),
        );
      }
    }

    return HeaderContainer(
      style: s,
      safeArea: safeArea,
      child: Row(
        children: [
          if (leading != null) ...[
            leading!,
            const SizedBox(width: 8.0),
          ],
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: items,
              ),
            ),
          ),
          if (actions != null && actions!.isNotEmpty) ...[
            const SizedBox(width: 8.0),
            Row(mainAxisSize: MainAxisSize.min, children: actions!),
          ],
        ],
      ),
    );
  }
}

/// Preset 28: Back-Title Header
///
/// Focused detail and edit page navigation bar with explicit back button,
/// prominent page title, and contextual quick actions.
class BackTitleHeaderWidget extends StatelessWidget {
  /// Creates a [BackTitleHeaderWidget].
  const BackTitleHeaderWidget({
    super.key,
    this.title,
    this.subtitle,
    this.backIcon,
    this.onBackTap,
    this.actions,
    this.style,
    this.safeArea = true,
  });

  /// Main page title.
  final Widget? title;

  /// Optional subtitle.
  final Widget? subtitle;

  /// Custom back icon. Defaults to [Icons.arrow_back].
  final Widget? backIcon;

  /// Callback when back button is pressed. Defaults to Navigator.maybePop.
  final VoidCallback? onBackTap;

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
      scrolledElevation: style?.scrolledElevation ?? 2.0,
      showDivider: style?.showDivider ?? true,
    );

    return HeaderContainer(
      style: s,
      safeArea: safeArea,
      child: NavigationToolbar(
        leading: IconButton(
          icon: backIcon ?? const Icon(Icons.arrow_back),
          tooltip: 'Back',
          onPressed: onBackTap ?? () => Navigator.maybePop(context),
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
    );
  }
}

/// Preset 29: Contextual Selection Header
///
/// Contextual Action Bar (CAB) header for item selection modes.
/// Displays item selection count, clear/close button, and contextual batch action items.
class ContextualSelectionHeaderWidget extends StatelessWidget {
  /// Creates a [ContextualSelectionHeaderWidget].
  const ContextualSelectionHeaderWidget({
    super.key,
    required this.selectedCount,
    this.onClearSelection,
    this.closeIcon,
    this.selectionActions,
    this.countBuilder,
    this.style,
    this.safeArea = true,
  });

  /// Number of currently selected items.
  final int selectedCount;

  /// Callback when close/cancel selection is tapped.
  final VoidCallback? onClearSelection;

  /// Custom icon for the close/dismiss button. Defaults to [Icons.close].
  final Widget? closeIcon;

  /// Batch action buttons (e.g. delete, archive, share).
  final List<Widget>? selectionActions;

  /// Custom builder for the selection count text.
  final Widget Function(int count)? countBuilder;

  /// Style configurations.
  final ScrollHeaderStyle? style;

  /// Whether to pad for top safe insets.
  final bool safeArea;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final s = (style ?? const ScrollHeaderStyle()).copyWith(
      backgroundColor:
          style?.backgroundColor ?? theme.colorScheme.primaryContainer,
      scrolledBackgroundColor:
          style?.scrolledBackgroundColor ??
          theme.colorScheme.primaryContainer,
      foregroundColor:
          style?.foregroundColor ?? theme.colorScheme.onPrimaryContainer,
      elevation: style?.elevation ?? 2.0,
      scrolledElevation: style?.scrolledElevation ?? 3.0,
      showDivider: style?.showDivider ?? false,
    );

    return HeaderContainer(
      style: s,
      safeArea: safeArea,
      child: NavigationToolbar(
        leading: IconButton(
          icon: closeIcon ?? const Icon(Icons.close),
          tooltip: 'Clear selection',
          color: s.foregroundColor,
          onPressed: onClearSelection,
        ),
        middle: countBuilder != null
            ? countBuilder!(selectedCount)
            : Text(
                '$selectedCount selected',
                style: s.titleStyle ??
                    theme.textTheme.titleMedium!.copyWith(
                      color: s.foregroundColor,
                      fontWeight: FontWeight.bold,
                    ),
              ),
        trailing: selectionActions != null && selectionActions!.isNotEmpty
            ? Row(mainAxisSize: MainAxisSize.min, children: selectionActions!)
            : null,
        centerMiddle: s.centerTitle ?? false,
      ),
    );
  }
}

/// Preset 30: Adaptive Navigation Header
///
/// Screen-size adaptive navigation header that automatically switches between
/// a compact mobile header layout and an expanded tablet/desktop layout at [breakpoint].
class AdaptiveNavigationHeaderWidget extends StatelessWidget {
  /// Creates an [AdaptiveNavigationHeaderWidget].
  const AdaptiveNavigationHeaderWidget({
    super.key,
    required this.compactHeader,
    required this.expandedHeader,
    this.breakpoint = 600.0,
    this.style,
    this.safeArea = true,
  });

  /// Header widget rendered on screens narrower than [breakpoint].
  final Widget compactHeader;

  /// Header widget rendered on screens with width >= [breakpoint].
  final Widget expandedHeader;

  /// Width threshold separating compact and expanded modes. Defaults to 600.0.
  final double breakpoint;

  /// Style configurations.
  final ScrollHeaderStyle? style;

  /// Whether to pad for top safe insets.
  final bool safeArea;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < breakpoint) {
          return compactHeader;
        }
        return expandedHeader;
      },
    );
  }
}
