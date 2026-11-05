import 'package:flutter/material.dart';

import '../../widgets/scroll_sticky_tab_bar.dart';
import '../../widgets/sliver_widget_marker.dart';
import '../scroll_header_style.dart';

/// Preset 13: Profile Header
/// Dedicated profile header with avatar, name, role/handle badge, stats, and action buttons.
class ProfileHeaderWidget extends StatelessWidget {
  /// Creates a [ProfileHeaderWidget].
  const ProfileHeaderWidget({
    super.key,
    required this.name,
    this.handleOrRole,
    this.avatar,
    this.stats,
    this.actions,
    this.leading,
    this.onAvatarTap,
    this.style,
    this.safeArea = true,
  });

  /// User display name.
  final Widget name;

  /// Role or handle subtitle.
  final Widget? handleOrRole;

  /// Profile avatar widget.
  final Widget? avatar;

  /// Optional stats row (e.g. Followers, Following, Posts).
  final Widget? stats;

  /// Trailing actions.
  final List<Widget>? actions;

  /// Leading widget.
  final Widget? leading;

  /// Callback when avatar is tapped.
  final VoidCallback? onAvatarTap;

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
      padding: EdgeInsets.fromLTRB(16.0, topPadding + 8.0, 16.0, 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Navigation bar row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              leading ?? const SizedBox.shrink(),
              if (actions != null && actions!.isNotEmpty)
                Row(mainAxisSize: MainAxisSize.min, children: actions!),
            ],
          ),
          const SizedBox(height: 12.0),

          // Avatar and Profile Info
          Row(
            children: [
              GestureDetector(
                onTap: onAvatarTap,
                child:
                    avatar ??
                    CircleAvatar(
                      radius: 30.0,
                      backgroundColor: theme.colorScheme.primaryContainer,
                      child: Icon(
                        Icons.person,
                        size: 36.0,
                        color: theme.colorScheme.primary,
                      ),
                    ),
              ),
              const SizedBox(width: 16.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DefaultTextStyle(
                      style:
                          s.titleStyle ??
                          theme.textTheme.titleLarge!.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                      child: name,
                    ),
                    if (handleOrRole != null) ...[
                      const SizedBox(height: 2.0),
                      DefaultTextStyle(
                        style:
                            s.subtitleStyle ??
                            theme.textTheme.bodyMedium!.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                        child: handleOrRole!,
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),

          if (stats != null) ...[const SizedBox(height: 16.0), stats!],
        ],
      ),
    );
  }
}

/// Preset 14: Dashboard Header
/// High-density overview header with greeting, date/status chip, metric cards, and actions.
class DashboardHeaderWidget extends StatelessWidget {
  /// Creates a [DashboardHeaderWidget].
  const DashboardHeaderWidget({
    super.key,
    required this.greeting,
    this.userName,
    this.dateOrSubtitle,
    this.avatar,
    this.metricsRow,
    this.actions,
    this.style,
    this.safeArea = true,
  });

  /// Greeting headline (e.g. "Good morning 👋").
  final Widget greeting;

  /// User name or headline.
  final Widget? userName;

  /// Date chip or status subtitle.
  final Widget? dateOrSubtitle;

  /// Avatar widget.
  final Widget? avatar;

  /// Optional metrics cards row.
  final Widget? metricsRow;

  /// Quick action buttons.
  final List<Widget>? actions;

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
      padding: EdgeInsets.fromLTRB(20.0, topPadding + 12.0, 20.0, 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DefaultTextStyle(
                      style:
                          s.subtitleStyle ??
                          theme.textTheme.titleSmall!.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                      child: greeting,
                    ),
                    if (userName != null) ...[
                      const SizedBox(height: 2.0),
                      DefaultTextStyle(
                        style:
                            s.titleStyle ??
                            theme.textTheme.headlineSmall!.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                        child: userName!,
                      ),
                    ],
                    if (dateOrSubtitle != null) ...[
                      const SizedBox(height: 4.0),
                      DefaultTextStyle(
                        style: theme.textTheme.bodySmall!.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                        child: dateOrSubtitle!,
                      ),
                    ],
                  ],
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (actions != null && actions!.isNotEmpty) ...actions!,
                  if (avatar != null) ...[const SizedBox(width: 8.0), avatar!],
                ],
              ),
            ],
          ),
          if (metricsRow != null) ...[
            const SizedBox(height: 16.0),
            metricsRow!,
          ],
        ],
      ),
    );
  }
}

/// Preset 15: Search Header
/// Integrated search field with search icon, clear button, filter button, and search callbacks.
class SearchHeaderWidget extends StatelessWidget {
  /// Creates a [SearchHeaderWidget].
  const SearchHeaderWidget({
    super.key,
    this.title,
    this.searchController,
    this.searchHint = 'Search...',
    this.onSearchChanged,
    this.onSearchSubmitted,
    this.leading,
    this.actions,
    this.style,
    this.safeArea = true,
  });

  /// Main title above search.
  final Widget? title;

  /// Controller for search input.
  final TextEditingController? searchController;

  /// Placeholder hint text.
  final String searchHint;

  /// Callback when text changes.
  final ValueChanged<String>? onSearchChanged;

  /// Callback when search is submitted.
  final ValueChanged<String>? onSearchSubmitted;

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
    final s = style ?? const ScrollHeaderStyle();

    return Container(
      color: s.backgroundColor ?? theme.colorScheme.surface,
      padding: EdgeInsets.fromLTRB(16.0, topPadding + 8.0, 16.0, 12.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null ||
              leading != null ||
              (actions != null && actions!.isNotEmpty))
            SizedBox(
              height: kToolbarHeight,
              child: NavigationToolbar(
                leading: leading,
                middle: title != null
                    ? DefaultTextStyle(
                        style:
                            s.titleStyle ??
                            theme.textTheme.titleMedium!.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                        child: title!,
                      )
                    : null,
                trailing: actions != null && actions!.isNotEmpty
                    ? Row(mainAxisSize: MainAxisSize.min, children: actions!)
                    : null,
              ),
            ),
          const SizedBox(height: 8.0),
          SearchBar(
            controller: searchController,
            hintText: searchHint,
            leading: const Icon(Icons.search, size: 20.0),
            onChanged: onSearchChanged,
            onSubmitted: onSearchSubmitted,
            elevation: WidgetStateProperty.all(0.0),
            backgroundColor: WidgetStateProperty.all(
              theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
    );
  }
}

/// Preset 16: Segmented Header
/// Header with embedded segmented control or category chip selector.
class SegmentedHeaderWidget extends StatelessWidget {
  /// Creates a [SegmentedHeaderWidget].
  const SegmentedHeaderWidget({
    super.key,
    this.title,
    required this.segments,
    this.selectedSegment,
    this.onSegmentSelected,
    this.leading,
    this.actions,
    this.style,
    this.safeArea = true,
  });

  /// Main title.
  final Widget? title;

  /// Segment list widgets or items.
  final Widget segments;

  /// Optional active segment value.
  final String? selectedSegment;

  /// Callback when segment selected.
  final ValueChanged<String>? onSegmentSelected;

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
    final s = style ?? const ScrollHeaderStyle();

    return Container(
      color: s.backgroundColor ?? theme.colorScheme.surface,
      padding: EdgeInsets.fromLTRB(16.0, topPadding + 8.0, 16.0, 12.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (title != null ||
              leading != null ||
              (actions != null && actions!.isNotEmpty))
            SizedBox(
              height: kToolbarHeight,
              child: NavigationToolbar(
                leading: leading,
                middle: title != null
                    ? DefaultTextStyle(
                        style:
                            s.titleStyle ??
                            theme.textTheme.titleMedium!.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                        child: title!,
                      )
                    : null,
                trailing: actions != null && actions!.isNotEmpty
                    ? Row(mainAxisSize: MainAxisSize.min, children: actions!)
                    : null,
              ),
            ),
          const SizedBox(height: 8.0),
          segments,
        ],
      ),
    );
  }
}

/// Preset 17: Sticky Tab Header
/// Pinned tab bar navigation pinned directly under the header with elevation transition.
class StickyTabHeaderWidget extends StatelessWidget with SliverWidgetMarker {
  /// Creates a [StickyTabHeaderWidget].
  const StickyTabHeaderWidget({
    super.key,
    required this.tabBar,
    this.title,
    this.leading,
    this.actions,
    this.style,
    this.pinned = true,
  });

  /// The tab bar widget (typically [TabBar]).
  final Widget tabBar;

  /// Optional title row above the tab bar.
  final Widget? title;

  /// Leading widget.
  final Widget? leading;

  /// Trailing actions.
  final List<Widget>? actions;

  /// Style configurations.
  final ScrollHeaderStyle? style;

  /// Whether the tab bar remains pinned when scrolling.
  final bool pinned;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final s = style ?? const ScrollHeaderStyle();

    final hasToolbar =
        title != null ||
        leading != null ||
        (actions != null && actions!.isNotEmpty);
    final tabHeight = tabBar is PreferredSizeWidget
        ? (tabBar as PreferredSizeWidget).preferredSize.height
        : 48.0;
    final totalHeight = hasToolbar
        ? (kToolbarHeight + 8.0 + tabHeight)
        : tabHeight;

    return ScrollStickyTabBar(
      height: totalHeight,
      pinned: pinned,
      elevation: s.elevation,
      pinnedElevation: s.scrolledElevation,
      backgroundColor: s.backgroundColor ?? theme.colorScheme.surface,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (title != null ||
              leading != null ||
              (actions != null && actions!.isNotEmpty))
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 4.0,
              ),
              child: SizedBox(
                height: kToolbarHeight,
                child: NavigationToolbar(
                  leading: leading,
                  middle: title,
                  trailing: actions != null && actions!.isNotEmpty
                      ? Row(mainAxisSize: MainAxisSize.min, children: actions!)
                      : null,
                ),
              ),
            ),
          tabBar,
        ],
      ),
    );
  }
}
