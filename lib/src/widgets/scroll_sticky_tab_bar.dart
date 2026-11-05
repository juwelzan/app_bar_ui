import 'package:flutter/material.dart';

/// A persistent sticky navigation bar sliver that scrolls with the content and
/// remains pinned at the top once reached.
///
/// Supports standard Flutter [TabBar] instances, [PreferredSizeWidget]s, segmented controls,
/// and custom builder functions that adapt when pinned.
class ScrollStickyTabBar extends StatelessWidget {
  /// Creates a [ScrollStickyTabBar] wrapping a child widget.
  const ScrollStickyTabBar({
    super.key,
    required this.child,
    this.height,
    this.pinned = true,
    this.backgroundColor,
    this.elevation = 0.0,
    this.pinnedElevation = 2.0,
    this.border,
    this.pinnedBorder,
  }) : builder = null;

  /// Creates a [ScrollStickyTabBar] with a dynamic builder receiving the pinned state.
  const ScrollStickyTabBar.builder({
    super.key,
    required this.builder,
    required double this.height,
    this.pinned = true,
    this.backgroundColor,
    this.elevation = 0.0,
    this.pinnedElevation = 2.0,
    this.border,
    this.pinnedBorder,
  }) : child = null;

  /// The child widget (typically a [TabBar] or segmented control).
  final Widget? child;

  /// Custom builder receiving `isPinned` state.
  final Widget Function(BuildContext context, bool isPinned)? builder;

  /// Height of the sticky bar. If omitted and [child] is a [PreferredSizeWidget],
  /// its [PreferredSizeWidget.preferredSize.height] is used automatically. Defaults to 48.0.
  final double? height;

  /// Whether the bar remains pinned when scrolling past. Defaults to `true`.
  final bool pinned;

  /// Background color of the sticky bar. Defaults to theme's canvas/surface color.
  final Color? backgroundColor;

  /// Elevation when not pinned. Defaults to 0.0.
  final double elevation;

  /// Elevation when pinned or overlapping content. Defaults to 2.0.
  final double pinnedElevation;

  /// Optional bottom border when unpinned.
  final BoxBorder? border;

  /// Optional bottom border when pinned.
  final BoxBorder? pinnedBorder;

  @override
  Widget build(BuildContext context) {
    double resolvedHeight = height ?? 48.0;
    if (height == null && child is PreferredSizeWidget) {
      resolvedHeight = (child as PreferredSizeWidget).preferredSize.height;
    }

    final Color effectiveBg =
        backgroundColor ??
        Theme.of(context).appBarTheme.backgroundColor ??
        Theme.of(context).colorScheme.surface;

    return SliverPersistentHeader(
      pinned: pinned,
      delegate: _ScrollStickyTabBarDelegate(
        height: resolvedHeight,
        child: child,
        builder: builder,
        backgroundColor: effectiveBg,
        elevation: elevation,
        pinnedElevation: pinnedElevation,
        border: border,
        pinnedBorder: pinnedBorder,
      ),
    );
  }
}

class _ScrollStickyTabBarDelegate extends SliverPersistentHeaderDelegate {
  _ScrollStickyTabBarDelegate({
    required this.height,
    this.child,
    this.builder,
    required this.backgroundColor,
    required this.elevation,
    required this.pinnedElevation,
    this.border,
    this.pinnedBorder,
  });

  final double height;
  final Widget? child;
  final Widget Function(BuildContext context, bool isPinned)? builder;
  final Color backgroundColor;
  final double elevation;
  final double pinnedElevation;
  final BoxBorder? border;
  final BoxBorder? pinnedBorder;

  @override
  double get minExtent => height;

  @override
  double get maxExtent => height;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    final bool isPinned = overlapsContent;
    final double effectiveElevation = isPinned ? pinnedElevation : elevation;
    final BoxBorder? effectiveBorder = isPinned ? (pinnedBorder ?? border) : border;

    Widget content = child ?? builder!(context, isPinned);

    return Material(
      color: backgroundColor,
      elevation: effectiveElevation,
      child: Container(
        height: height,
        decoration: effectiveBorder != null ? BoxDecoration(border: effectiveBorder) : null,
        child: content,
      ),
    );
  }

  @override
  bool shouldRebuild(covariant _ScrollStickyTabBarDelegate oldDelegate) {
    return oldDelegate.height != height ||
        oldDelegate.child != child ||
        oldDelegate.builder != builder ||
        oldDelegate.backgroundColor != backgroundColor ||
        oldDelegate.elevation != elevation ||
        oldDelegate.pinnedElevation != pinnedElevation ||
        oldDelegate.border != border ||
        oldDelegate.pinnedBorder != pinnedBorder;
  }
}
