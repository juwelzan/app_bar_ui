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
