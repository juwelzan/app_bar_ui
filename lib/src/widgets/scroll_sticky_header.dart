import 'package:flutter/material.dart';

import 'sliver_widget_marker.dart';

/// A persistent sticky header sliver that anchors any arbitrary widget
/// (e.g., search bars, category filters, section headers) to the top of the viewport.
///
/// Supports dynamic builder functions with `isPinned` awareness, elevation shifts,
/// and smooth background color transitions.
class ScrollStickyHeader extends StatelessWidget with SliverWidgetMarker {
  /// Creates a [ScrollStickyHeader] wrapping a child widget.
  const ScrollStickyHeader({
    super.key,
    required this.child,
    this.height,
    this.pinned = true,
    this.floating = false,
    this.backgroundColor,
    this.elevation = 0.0,
    this.pinnedElevation = 2.0,
    this.border,
    this.pinnedBorder,
  }) : builder = null;

  /// Creates a [ScrollStickyHeader] with a dynamic builder receiving the pinned state.
  const ScrollStickyHeader.builder({
    super.key,
    required this.builder,
    required double this.height,
    this.pinned = true,
    this.floating = false,
    this.backgroundColor,
    this.elevation = 0.0,
    this.pinnedElevation = 2.0,
    this.border,
    this.pinnedBorder,
  }) : child = null;

  /// The child widget to pin (e.g., SearchBar, Section Title, FilterChip row).
  final Widget? child;

  /// Custom builder receiving the `isPinned` boolean.
  final Widget Function(BuildContext context, bool isPinned)? builder;

  /// Height of the sticky header. If omitted and [child] is a [PreferredSizeWidget],
  /// [PreferredSizeWidget.preferredSize.height] is used automatically. Defaults to 56.0.
  final double? height;

  /// Whether the header stays pinned when scrolling past. Defaults to `true`.
  final bool pinned;

  /// Whether the header floats back into view immediately upon reverse scrolling. Defaults to `false`.
  final bool floating;

  /// Background color of the header container. Defaults to theme's surface color.
  final Color? backgroundColor;

  /// Elevation when unpinned. Defaults to 0.0.
  final double elevation;

  /// Elevation when pinned or overlapping content. Defaults to 2.0.
  final double pinnedElevation;

  /// Optional bottom border when unpinned.
  final BoxBorder? border;

  /// Optional bottom border when pinned.
  final BoxBorder? pinnedBorder;

  @override
  Widget build(BuildContext context) {
    double resolvedHeight = height ?? 56.0;
    if (height == null && child is PreferredSizeWidget) {
      resolvedHeight = (child as PreferredSizeWidget).preferredSize.height;
    }

    final Color effectiveBg =
        backgroundColor ??
        Theme.of(context).appBarTheme.backgroundColor ??
        Theme.of(context).colorScheme.surface;

    return SliverPersistentHeader(
      pinned: pinned,
      floating: floating,
      delegate: _ScrollStickyHeaderDelegate(
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

class _ScrollStickyHeaderDelegate extends SliverPersistentHeaderDelegate {
  _ScrollStickyHeaderDelegate({
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
    final BoxBorder? effectiveBorder = isPinned
        ? (pinnedBorder ?? border)
        : border;

    Widget content = child ?? builder!(context, isPinned);

    return Material(
      color: backgroundColor,
      elevation: effectiveElevation,
      child: Container(
        height: height,
        decoration: effectiveBorder != null
            ? BoxDecoration(border: effectiveBorder)
            : null,
        child: content,
      ),
    );
  }

  @override
  bool shouldRebuild(covariant _ScrollStickyHeaderDelegate oldDelegate) {
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
