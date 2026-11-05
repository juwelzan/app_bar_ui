import 'package:flutter/material.dart';

import '../../widgets/sliver_widget_marker.dart';
import '../scroll_header_style.dart';
import 'base_header.dart';

/// Preset 41: Media Player Header
///
/// Dedicated music and podcast header featuring album art thumbnail,
/// track title, artist name, and embedded playback controls (play/pause, skip).
class MediaPlayerHeaderWidget extends StatelessWidget {
  /// Creates a [MediaPlayerHeaderWidget].
  const MediaPlayerHeaderWidget({
    super.key,
    this.nowPlayingTitle,
    this.artist,
    this.albumArt,
    this.isPlaying = false,
    this.onPlayPause,
    this.onNext,
    this.onPrevious,
    this.leading,
    this.actions,
    this.style,
    this.safeArea = true,
  });

  /// Now playing track title.
  final Widget? nowPlayingTitle;

  /// Artist or podcast host subtitle.
  final Widget? artist;

  /// Album art cover or thumbnail widget.
  final Widget? albumArt;

  /// Whether track is currently playing.
  final bool isPlaying;

  /// Callback when play/pause toggle button is tapped.
  final VoidCallback? onPlayPause;

  /// Callback when skip to next track is tapped.
  final VoidCallback? onNext;

  /// Callback when skip to previous track is tapped.
  final VoidCallback? onPrevious;

  /// Optional custom leading widget.
  final Widget? leading;

  /// Optional trailing action widgets.
  final List<Widget>? actions;

  /// Style configurations.
  final ScrollHeaderStyle? style;

  /// Whether to pad for top safe insets.
  final bool safeArea;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final s = (style ?? const ScrollHeaderStyle()).copyWith(
      height: style?.height ?? 72.0,
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
          if (leading != null) ...[
            leading!,
            const SizedBox(width: 8.0),
          ],
          if (albumArt != null) ...[
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: SizedBox(
                width: 48.0,
                height: 48.0,
                child: albumArt!,
              ),
            ),
            const SizedBox(width: 12.0),
          ],
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (nowPlayingTitle != null)
                  DefaultTextStyle(
                    style: s.titleStyle ??
                        theme.textTheme.titleMedium!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    child: nowPlayingTitle!,
                  ),
                if (artist != null) ...[
                  const SizedBox(height: 1.0),
                  DefaultTextStyle(
                    style: s.subtitleStyle ??
                        theme.textTheme.bodySmall!.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    child: artist!,
                  ),
                ],
              ],
            ),
          ),
          if (onPrevious != null)
            IconButton(
              icon: const Icon(Icons.skip_previous),
              tooltip: 'Previous track',
              onPressed: onPrevious,
            ),
          if (onPlayPause != null)
            IconButton(
              icon: Icon(
                isPlaying
                    ? Icons.pause_circle_filled
                    : Icons.play_circle_filled,
                size: 32.0,
                color: theme.colorScheme.primary,
              ),
              tooltip: isPlaying ? 'Pause' : 'Play',
              onPressed: onPlayPause,
            ),
          if (onNext != null)
            IconButton(
              icon: const Icon(Icons.skip_next),
              tooltip: 'Next track',
              onPressed: onNext,
            ),
          if (actions != null && actions!.isNotEmpty) ...actions!,
        ],
      ),
    );
  }
}

/// Preset 42: Shopping Header
///
/// E-commerce storefront header featuring quick search shortcut,
/// live shopping cart badge with item counter, and category actions.
class ShoppingHeaderWidget extends StatelessWidget {
  /// Creates a [ShoppingHeaderWidget].
  const ShoppingHeaderWidget({
    super.key,
    this.title,
    this.cartItemCount = 0,
    this.onCartTap,
    this.leading,
    this.actions,
    this.style,
    this.safeArea = true,
  });

  /// Main store title or search field widget.
  final Widget? title;

  /// Current number of items in shopping cart.
  final int cartItemCount;

  /// Callback when shopping cart icon is tapped.
  final VoidCallback? onCartTap;

  /// Leading navigation widget.
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
      scrolledElevation: style?.scrolledElevation ?? 2.0,
      showDivider: style?.showDivider ?? true,
    );

    return HeaderContainer(
      style: s,
      safeArea: safeArea,
      child: NavigationToolbar(
        leading: leading,
        middle: title != null
            ? DefaultTextStyle(
                style: s.titleStyle ??
                    theme.textTheme.titleMedium!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                child: title!,
              )
            : null,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (actions != null && actions!.isNotEmpty) ...actions!,
            Badge(
              isLabelVisible: cartItemCount > 0,
              label: Text('$cartItemCount'),
              child: IconButton(
                icon: const Icon(Icons.shopping_cart_outlined),
                tooltip: 'Shopping Cart',
                onPressed: onCartTap,
              ),
            ),
          ],
        ),
        centerMiddle: s.centerTitle ?? false,
      ),
    );
  }
}

/// Preset 43: Chat Header
///
/// Messaging conversation header with contact avatar, online presence dot,
/// real-time status subtitle, and quick call buttons (voice, video).
class ChatHeaderWidget extends StatelessWidget {
  /// Creates a [ChatHeaderWidget].
  const ChatHeaderWidget({
    super.key,
    this.chatUser,
    this.onlineStatus,
    this.avatar,
    this.onCallTap,
    this.onVideoTap,
    this.leading,
    this.actions,
    this.style,
    this.safeArea = true,
  });

  /// Name or user title widget.
  final Widget? chatUser;

  /// Presence subtitle (e.g. "Online", "Typing...", "Last seen recently").
  final Widget? onlineStatus;

  /// Contact avatar widget.
  final Widget? avatar;

  /// Callback when audio call button is pressed.
  final VoidCallback? onCallTap;

  /// Callback when video call button is pressed.
  final VoidCallback? onVideoTap;

  /// Leading navigation button (e.g. back arrow).
  final Widget? leading;

  /// Additional trailing actions.
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
          ?leading,
          if (avatar != null) ...[
            Stack(
              children: [
                avatar!,
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    width: 10.0,
                    height: 10.0,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: theme.colorScheme.surface,
                        width: 1.5,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 10.0),
          ],
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (chatUser != null)
                  DefaultTextStyle(
                    style: s.titleStyle ??
                        theme.textTheme.titleMedium!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    child: chatUser!,
                  ),
                if (onlineStatus != null) ...[
                  const SizedBox(height: 1.0),
                  DefaultTextStyle(
                    style: s.subtitleStyle ??
                        theme.textTheme.bodySmall!.copyWith(
                          color: theme.colorScheme.primary,
                          fontSize: 11.5,
                        ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    child: onlineStatus!,
                  ),
                ],
              ],
            ),
          ),
          if (onCallTap != null)
            IconButton(
              icon: const Icon(Icons.call_outlined),
              tooltip: 'Voice call',
              onPressed: onCallTap,
            ),
          if (onVideoTap != null)
            IconButton(
              icon: const Icon(Icons.videocam_outlined),
              tooltip: 'Video call',
              onPressed: onVideoTap,
            ),
          if (actions != null && actions!.isNotEmpty) ...actions!,
        ],
      ),
    );
  }
}

/// Preset 44: Detail Page Header
///
/// Media/article detail header with Hero animation transition support,
/// high-contrast floating action pill buttons, and smooth contrast scrim.
class DetailPageHeaderWidget extends StatelessWidget
    with SliverWidgetMarker {
  /// Creates a [DetailPageHeaderWidget].
  const DetailPageHeaderWidget({
    super.key,
    this.background,
    this.heroTag,
    this.title,
    this.subtitle,
    this.leading,
    this.actions,
    this.style,
    this.expandedHeight = 260.0,
    this.collapsedHeight = kToolbarHeight,
    this.safeArea = true,
  });

  /// Hero background image or widget.
  final Widget? background;

  /// Tag for Flutter [Hero] widget transition.
  final String? heroTag;

  /// Main title shown when collapsed or overlaid on banner.
  final Widget? title;

  /// Subtitle widget.
  final Widget? subtitle;

  /// Leading navigation widget.
  final Widget? leading;

  /// Trailing actions.
  final List<Widget>? actions;

  /// Style configurations.
  final ScrollHeaderStyle? style;

  /// Expanded height of the detail banner.
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

    Widget bgWidget = background ?? Container(color: theme.colorScheme.primary);
    if (heroTag != null) {
      bgWidget = Hero(tag: heroTag!, child: bgWidget);
    }

    return SliverPersistentHeader(
      pinned: s.pinned,
      floating: s.floating,
      delegate: PresetSliverHeaderDelegate(
        expandedHeight: totalExpanded,
        collapsedHeight: totalCollapsed,
        builder: (context, progress, overlapsContent) {
          final isCollapsed = progress >= 0.8;
          final toolbarOpacity =
              isCollapsed ? ((progress - 0.8) / 0.2).clamp(0.0, 1.0) : 0.0;

          return Container(
            color: theme.colorScheme.surface,
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Background Hero
                Positioned.fill(child: bgWidget),

                // Scrim gradient for contrast
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withValues(alpha: 0.5),
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.65),
                        ],
                        stops: const [0.0, 0.45, 1.0],
                      ),
                    ),
                  ),
                ),

                // Scrolled solid toolbar background
                if (isCollapsed)
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    height: totalCollapsed,
                    child: Opacity(
                      opacity: toolbarOpacity,
                      child: Container(
                        color: s.scrolledBackgroundColor ??
                            theme.colorScheme.surface,
                      ),
                    ),
                  ),

                // Top Toolbar
                Positioned(
                  top: topPadding,
                  left: 0,
                  right: 0,
                  height: collapsedHeight,
                  child: Padding(
                    padding: s.padding ??
                        const EdgeInsets.symmetric(horizontal: 16.0),
                    child: NavigationToolbar(
                      leading: leading != null
                          ? Container(
                              decoration: BoxDecoration(
                                color: isCollapsed
                                    ? Colors.transparent
                                    : Colors.black38,
                                shape: BoxShape.circle,
                              ),
                              child: leading!,
                            )
                          : null,
                      middle: isCollapsed && title != null
                          ? Opacity(
                              opacity: toolbarOpacity,
                              child: DefaultTextStyle(
                                style: s.titleStyle ??
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
                              children: actions!.map((action) {
                                return Container(
                                  margin: const EdgeInsets.only(left: 4.0),
                                  decoration: BoxDecoration(
                                    color: isCollapsed
                                        ? Colors.transparent
                                        : Colors.black38,
                                    shape: BoxShape.circle,
                                  ),
                                  child: action,
                                );
                              }).toList(),
                            )
                          : null,
                      centerMiddle: s.centerTitle ?? false,
                    ),
                  ),
                ),

                // Bottom Title on Expanded Banner
                if (!isCollapsed && title != null)
                  Positioned(
                    left: 20.0,
                    right: 20.0,
                    bottom: 16.0,
                    child: Opacity(
                      opacity: (1.0 - progress * 1.5).clamp(0.0, 1.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          DefaultTextStyle(
                            style: s.largeTitleStyle ??
                                theme.textTheme.headlineSmall!.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            child: title!,
                          ),
                          if (subtitle != null) ...[
                            const SizedBox(height: 4.0),
                            DefaultTextStyle(
                              style: s.subtitleStyle ??
                                  theme.textTheme.bodyMedium!.copyWith(
                                    color: Colors.white70,
                                  ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
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

/// Preset 45: Reading Header
///
/// Editorial reader header with integrated horizontal reading progress bar,
/// estimated reading time counter, and text sizing controls.
class ReadingHeaderWidget extends StatelessWidget {
  /// Creates a [ReadingHeaderWidget].
  const ReadingHeaderWidget({
    super.key,
    this.title,
    this.estimatedReadTime,
    this.readingProgress = 0.0,
    this.leading,
    this.actions,
    this.style,
    this.safeArea = true,
  });

  /// Article or document title.
  final Widget? title;

  /// Estimated reading time label (e.g. "4 min read").
  final String? estimatedReadTime;

  /// Normalized reading progress (0.0 to 1.0).
  final double readingProgress;

  /// Leading navigation widget.
  final Widget? leading;

  /// Trailing actions (e.g. font size, bookmark).
  final List<Widget>? actions;

  /// Style configurations.
  final ScrollHeaderStyle? style;

  /// Whether to pad for top safe insets.
  final bool safeArea;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final s = (style ?? const ScrollHeaderStyle()).copyWith(
      height: style?.height ?? 58.0,
      backgroundColor: style?.backgroundColor ?? theme.colorScheme.surface,
      scrolledBackgroundColor:
          style?.scrolledBackgroundColor ?? theme.colorScheme.surfaceContainer,
      elevation: style?.elevation ?? 0.0,
      scrolledElevation: style?.scrolledElevation ?? 1.5,
      showDivider: false,
    );

    return HeaderContainer(
      style: s,
      safeArea: safeArea,
      child: Stack(
        children: [
          Positioned.fill(
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
                    if (estimatedReadTime != null) ...[
                      const SizedBox(height: 1.0),
                      Text(
                        estimatedReadTime!,
                        style: s.subtitleStyle ??
                            theme.textTheme.bodySmall!.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                              fontSize: 11.0,
                            ),
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
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: LinearProgressIndicator(
              value: readingProgress.clamp(0.0, 1.0),
              minHeight: 2.5,
              backgroundColor: Colors.transparent,
              valueColor: AlwaysStoppedAnimation<Color>(
                theme.colorScheme.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Preset 46: Map Header
///
/// Embedded interactive location or map preview header with a floating
/// search bar, leading button, and quick location actions.
class MapHeaderWidget extends StatelessWidget {
  /// Creates a [MapHeaderWidget].
  const MapHeaderWidget({
    super.key,
    this.mapWidget,
    this.title,
    this.searchHint = 'Search location...',
    this.searchController,
    this.onSearchChanged,
    this.leading,
    this.actions,
    this.style,
    this.height = 180.0,
    this.safeArea = true,
  });

  /// Base map canvas or image widget.
  final Widget? mapWidget;

  /// Optional header title overlay or location pill.
  final Widget? title;

  /// Placeholder text for the floating search card.
  final String searchHint;

  /// Optional search input controller.
  final TextEditingController? searchController;

  /// Callback when search query changes.
  final ValueChanged<String>? onSearchChanged;

  /// Leading navigation widget.
  final Widget? leading;

  /// Trailing action widgets.
  final List<Widget>? actions;

  /// Style configurations.
  final ScrollHeaderStyle? style;

  /// Overall header height.
  final double height;

  /// Whether to pad for top safe insets.
  final bool safeArea;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final topPadding = safeArea ? MediaQuery.paddingOf(context).top : 0.0;
    final totalHeight = height + topPadding;
    final s = style ?? const ScrollHeaderStyle();

    return Container(
      height: totalHeight,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: s.backgroundColor ?? theme.colorScheme.surfaceContainerHighest,
        borderRadius: s.borderRadius,
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Base map or preview
          Positioned.fill(
            child: mapWidget ??
                Container(
                  color: theme.colorScheme.surfaceContainerHighest,
                  child: Center(
                    child: Icon(
                      Icons.map_outlined,
                      size: 64.0,
                      color: theme.colorScheme.outline.withValues(alpha: 0.5),
                    ),
                  ),
                ),
          ),

          // Vignette gradient for top readability
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: topPadding + 80.0,
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.45),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          // Floating Top Search Bar
          Positioned(
            top: topPadding + 10.0,
            left: 16.0,
            right: 16.0,
            child: Material(
              elevation: style?.elevation ?? 3.0,
              borderRadius: BorderRadius.circular(28.0),
              color: theme.colorScheme.surface,
              child: SizedBox(
                height: 48.0,
                child: Row(
                  children: [
                    if (leading != null)
                      leading!
                    else
                      Padding(
                        padding: const EdgeInsets.only(left: 14.0, right: 8.0),
                        child: Icon(
                          Icons.search,
                          color: theme.colorScheme.onSurfaceVariant,
                          size: 20.0,
                        ),
                      ),
                    Expanded(
                      child: TextField(
                        controller: searchController,
                        onChanged: onSearchChanged,
                        decoration: InputDecoration(
                          hintText: searchHint,
                          hintStyle: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 12.0),
                        ),
                      ),
                    ),
                    if (actions != null && actions!.isNotEmpty) ...actions!,
                  ],
                ),
              ),
            ),
          ),

          // Bottom Location Pill / Title if provided
          if (title != null)
            Positioned(
              left: 16.0,
              bottom: 12.0,
              child: Material(
                elevation: 2.0,
                borderRadius: BorderRadius.circular(16.0),
                color: theme.colorScheme.surface.withValues(alpha: 0.92),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12.0,
                    vertical: 6.0,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.my_location,
                        size: 15.0,
                        color: theme.colorScheme.primary,
                      ),
                      const SizedBox(width: 6.0),
                      DefaultTextStyle(
                        style: theme.textTheme.bodySmall!.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.onSurface,
                        ),
                        child: title!,
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Preset 47: Form Header
///
/// State-aware form and editor header with cancel action, document title,
/// autosave status indicator, and a reactive primary Save action.
class FormHeaderWidget extends StatelessWidget {
  /// Creates a [FormHeaderWidget].
  const FormHeaderWidget({
    super.key,
    this.title,
    this.subtitle,
    this.isDirty = false,
    this.isSaving = false,
    this.saveLabel = 'Save',
    this.onSave,
    this.leading,
    this.actions,
    this.style,
    this.safeArea = true,
  });

  /// Form title widget.
  final Widget? title;

  /// Autosave status or subtitle widget.
  final Widget? subtitle;

  /// Whether the form has unsaved modifications.
  final bool isDirty;

  /// Whether saving is in progress.
  final bool isSaving;

  /// Label displayed on primary save button.
  final String saveLabel;

  /// Callback when Save button is pressed.
  final VoidCallback? onSave;

  /// Custom leading cancel/back widget.
  final Widget? leading;

  /// Additional trailing actions.
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
        leading: leading ??
            TextButton(
              onPressed: () => Navigator.of(context).maybePop(),
              child: const Text('Cancel'),
            ),
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
                      color: isDirty
                          ? theme.colorScheme.error
                          : theme.colorScheme.onSurfaceVariant,
                      fontSize: 11.0,
                    ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                child: subtitle!,
              ),
            ],
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (actions != null && actions!.isNotEmpty) ...actions!,
            FilledButton(
              onPressed: isDirty && !isSaving ? onSave : null,
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                visualDensity: VisualDensity.compact,
              ),
              child: isSaving
                  ? const SizedBox(
                      width: 14.0,
                      height: 14.0,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.0,
                        color: Colors.white,
                      ),
                    )
                  : Text(saveLabel),
            ),
          ],
        ),
        centerMiddle: s.centerTitle ?? false,
      ),
    );
  }
}

/// Preset 48: Wizard Header
///
/// Multi-step onboarding and checkout setup header with segmented step progress
/// indicators, step counter labels, and cancel/back navigation.
class WizardHeaderWidget extends StatelessWidget {
  /// Creates a [WizardHeaderWidget].
  const WizardHeaderWidget({
    super.key,
    this.currentStep = 1,
    this.totalSteps = 4,
    this.stepTitle,
    this.stepSubtitle,
    this.leading,
    this.actions,
    this.style,
    this.safeArea = true,
  });

  /// Current 1-based step index.
  final int currentStep;

  /// Total number of setup steps.
  final int totalSteps;

  /// Current step title widget.
  final Widget? stepTitle;

  /// Optional custom subtitle (e.g. "Step 2 of 4").
  final Widget? stepSubtitle;

  /// Leading navigation widget.
  final Widget? leading;

  /// Trailing actions (e.g. close/skip button).
  final List<Widget>? actions;

  /// Style configurations.
  final ScrollHeaderStyle? style;

  /// Whether to pad for top safe insets.
  final bool safeArea;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final s = (style ?? const ScrollHeaderStyle()).copyWith(
      height: style?.height ?? 74.0,
      backgroundColor: style?.backgroundColor ?? theme.colorScheme.surface,
      scrolledBackgroundColor:
          style?.scrolledBackgroundColor ?? theme.colorScheme.surfaceContainer,
      elevation: style?.elevation ?? 0.0,
      scrolledElevation: style?.scrolledElevation ?? 1.5,
      showDivider: style?.showDivider ?? true,
    );

    final safeTotalSteps = totalSteps > 0 ? totalSteps : 1;
    final safeCurrentStep = currentStep.clamp(1, safeTotalSteps);

    return HeaderContainer(
      style: s,
      safeArea: safeArea,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: NavigationToolbar(
              leading: leading,
              middle: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: s.centerTitle == true
                    ? CrossAxisAlignment.center
                    : CrossAxisAlignment.start,
                children: [
                  if (stepTitle != null)
                    DefaultTextStyle(
                      style: s.titleStyle ??
                          theme.textTheme.titleMedium!.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      child: stepTitle!,
                    ),
                  const SizedBox(height: 1.0),
                  DefaultTextStyle(
                    style: s.subtitleStyle ??
                        theme.textTheme.bodySmall!.copyWith(
                          color: theme.colorScheme.primary,
                          fontSize: 11.5,
                          fontWeight: FontWeight.w600,
                        ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    child: stepSubtitle ??
                        Text('Step $safeCurrentStep of $safeTotalSteps'),
                  ),
                ],
              ),
              trailing: actions != null && actions!.isNotEmpty
                  ? Row(mainAxisSize: MainAxisSize.min, children: actions!)
                  : null,
              centerMiddle: s.centerTitle ?? false,
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
            child: Row(
              children: List.generate(safeTotalSteps, (index) {
                final isPassed = index < safeCurrentStep;
                return Expanded(
                  child: Container(
                    height: 3.5,
                    margin: EdgeInsets.only(
                      right: index < safeTotalSteps - 1 ? 4.0 : 0.0,
                    ),
                    decoration: BoxDecoration(
                      color: isPassed
                          ? theme.colorScheme.primary
                          : theme.colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(2.0),
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}

/// Preset 49: Notification Center Header
///
/// Notification and activity inbox header featuring an unread counter badge,
/// "Mark all as read" shortcut action, and optional filter pills.
class NotificationCenterHeaderWidget extends StatelessWidget {
  /// Creates a [NotificationCenterHeaderWidget].
  const NotificationCenterHeaderWidget({
    super.key,
    this.title,
    this.unreadCount = 0,
    this.onMarkAllRead,
    this.segments,
    this.leading,
    this.actions,
    this.style,
    this.safeArea = true,
  });

  /// Main title widget (defaults to 'Notifications').
  final Widget? title;

  /// Unread notifications badge count.
  final int unreadCount;

  /// Callback when "Mark all as read" action is tapped.
  final VoidCallback? onMarkAllRead;

  /// Filter tabs or category pills widget.
  final Widget? segments;

  /// Leading navigation widget.
  final Widget? leading;

  /// Additional trailing actions.
  final List<Widget>? actions;

  /// Style configurations.
  final ScrollHeaderStyle? style;

  /// Whether to pad for top safe insets.
  final bool safeArea;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasSegments = segments != null;
    final s = (style ?? const ScrollHeaderStyle()).copyWith(
      height: style?.height ?? (hasSegments ? 116.0 : 60.0),
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
            height: 52.0,
            child: NavigationToolbar(
              leading: leading,
              middle: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    child: DefaultTextStyle(
                      style: s.titleStyle ??
                          theme.textTheme.titleMedium!.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      child: title ?? const Text('Notifications'),
                    ),
                  ),
                  if (unreadCount > 0) ...[
                    const SizedBox(width: 8.0),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 7.0,
                        vertical: 2.0,
                      ),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.error,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Text(
                        '$unreadCount',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (onMarkAllRead != null)
                    TextButton.icon(
                      icon: const Icon(Icons.done_all, size: 16.0),
                      label: const Text('Mark all read'),
                      style: TextButton.styleFrom(
                        visualDensity: VisualDensity.compact,
                        textStyle: const TextStyle(fontSize: 12.0),
                      ),
                      onPressed: onMarkAllRead,
                    ),
                  if (actions != null && actions!.isNotEmpty) ...actions!,
                ],
              ),
              centerMiddle: s.centerTitle ?? false,
            ),
          ),
          if (hasSegments)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 16.0,
                  right: 16.0,
                  bottom: 6.0,
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: segments!,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Preset 50: Custom Scroll Layout Header
///
/// Flexible sliver header delegating completely to a developer-provided custom
/// [SliverPersistentHeaderDelegate] or scroll progress builder callback.
class CustomScrollLayoutHeaderWidget extends StatelessWidget
    with SliverWidgetMarker {
  /// Creates a [CustomScrollLayoutHeaderWidget].
  const CustomScrollLayoutHeaderWidget({
    super.key,
    this.customLayoutDelegate,
    this.builder,
    this.expandedHeight = 200.0,
    this.collapsedHeight = kToolbarHeight,
    this.pinned = true,
    this.floating = false,
  });

  /// Custom persistent header delegate.
  final SliverPersistentHeaderDelegate? customLayoutDelegate;

  /// Custom builder callback with scroll progress (0.0 to 1.0).
  final Widget Function(
    BuildContext context,
    double progress,
    bool overlapsContent,
  )? builder;

  /// Expanded height when fully uncollapsed.
  final double expandedHeight;

  /// Collapsed toolbar height.
  final double collapsedHeight;

  /// Whether the header remains pinned at the top.
  final bool pinned;

  /// Whether the header floats when scrolling down.
  final bool floating;

  @override
  Widget build(BuildContext context) {
    if (customLayoutDelegate != null) {
      return SliverPersistentHeader(
        delegate: customLayoutDelegate!,
        pinned: pinned,
        floating: floating,
      );
    }

    return SliverPersistentHeader(
      pinned: pinned,
      floating: floating,
      delegate: PresetSliverHeaderDelegate(
        expandedHeight: expandedHeight,
        collapsedHeight: collapsedHeight,
        builder: builder ??
            (context, progress, overlapsContent) => Container(
                  color: Theme.of(context).colorScheme.surface,
                  alignment: Alignment.center,
                  child: Text(
                    'Custom Layout (${(progress * 100).toInt()}% Scrolled)',
                  ),
                ),
      ),
    );
  }
}
