import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'experience_configs.dart';

/// Style 37: Cascading Progressive Pin Header.
///
/// Features independent sub-elements (Title, Search Bar, and Action Controls)
/// that scroll naturally before locking into pinned positions at separate,
/// cascading scroll milestones. Rather than collapsing as a single rigid unit,
/// the header components latch into place sequentially, creating a staged
/// docking experience.
class CascadingProgressivePinHeaderWidget extends StatelessWidget {
  /// Creates a [CascadingProgressivePinHeaderWidget].
  const CascadingProgressivePinHeaderWidget({
    super.key,
    required this.title,
    required this.searchBar,
    required this.statusPills,
    this.leading,
    this.backgroundColor,
    this.safeArea = true,
    this.config = const CascadingProgressivePinConfig(),
  });

  /// Main title widget.
  final Widget title;

  /// Search bar or query input widget.
  final Widget searchBar;

  /// Ordered row or wrap of status indicators and filter chips.
  final Widget statusPills;

  /// Optional leading navigation widget.
  final Widget? leading;

  /// Background color.
  final Color? backgroundColor;

  /// Whether to respect top SafeArea.
  final bool safeArea;

  /// Configuration for cascading pin milestone offsets.
  final CascadingProgressivePinConfig config;

  @override
  Widget build(BuildContext context) {
    final topPadding = safeArea ? MediaQuery.paddingOf(context).top : 0.0;
    final totalExpanded = config.expandedHeight + topPadding;
    final totalCollapsed = config.collapsedHeight + topPadding;

    return SliverPersistentHeader(
      pinned: true,
      delegate: _CascadingProgressivePinDelegate(
        title: title,
        searchBar: searchBar,
        statusPills: statusPills,
        leading: leading,
        backgroundColor: backgroundColor ?? Theme.of(context).colorScheme.surface,
        topPadding: topPadding,
        totalExpanded: math.max(totalExpanded, totalCollapsed + 1.0),
        totalCollapsed: totalCollapsed,
        config: config,
      ),
    );
  }
}

class _CascadingProgressivePinDelegate extends SliverPersistentHeaderDelegate {
  _CascadingProgressivePinDelegate({
    required this.title,
    required this.searchBar,
    required this.statusPills,
    required this.leading,
    required this.backgroundColor,
    required this.topPadding,
    required this.totalExpanded,
    required this.totalCollapsed,
    required this.config,
  });

  final Widget title;
  final Widget searchBar;
  final Widget statusPills;
  final Widget? leading;
  final Color backgroundColor;
  final double topPadding;
  final double totalExpanded;
  final double totalCollapsed;
  final CascadingProgressivePinConfig config;

  @override
  double get minExtent => totalCollapsed;

  @override
  double get maxExtent => totalExpanded;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    final reducedMotion = MediaQuery.disableAnimationsOf(context);
    final width = MediaQuery.sizeOf(context).width;
    final safeWidth = width > 0 ? width : 360.0;
    final theme = Theme.of(context);

    // Cascading milestone calculations:
    // 1. Title: moves up with scroll until titlePinOffset, then pins firmly
    final rawTitleY = (totalExpanded - shrinkOffset) * 0.25;
    final pinnedTitleY = topPadding + (totalCollapsed - topPadding - 24.0) / 2.0;
    final titlePinned = shrinkOffset >= config.titlePinOffset;
    final titleY = reducedMotion
        ? (titlePinned ? pinnedTitleY : rawTitleY)
        : (shrinkOffset < config.titlePinOffset
            ? (topPadding + 16.0 - shrinkOffset)
            : pinnedTitleY);

    // 2. Search bar: scrolls upward until searchPinOffset, then locks into inline or compact slot
    final searchPinned = shrinkOffset >= config.searchPinOffset;
    final searchInitialY = topPadding + 64.0;
    final searchY = searchPinned
        ? (topPadding + (totalCollapsed - topPadding - 38.0) / 2.0)
        : (searchInitialY - (shrinkOffset * 0.6));

    // 3. Status pills: scroll upward until actionsPinOffset, then tucks or pins
    final pillsPinned = shrinkOffset >= config.actionsPinOffset;
    final pillsInitialY = topPadding + 120.0;
    final pillsY = pillsPinned
        ? (topPadding + (totalCollapsed - topPadding - 32.0) / 2.0)
        : (pillsInitialY - (shrinkOffset * 0.8));

    final isAllPinned = shrinkOffset >= config.actionsPinOffset;

    return Material(
      elevation: isAllPinned ? 3.0 : 1.0,
      color: backgroundColor,
      child: ClipRect(
        child: OverflowBox(
          minWidth: 0.0,
          maxWidth: safeWidth,
          minHeight: 0.0,
          maxHeight: totalExpanded,
          alignment: Alignment.topLeft,
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Pinned Leading
              if (leading != null)
                Positioned(
                  left: 8.0,
                  top: topPadding + (totalCollapsed - topPadding - 48.0) / 2.0,
                  child: SizedBox(
                    width: 48.0,
                    height: 48.0,
                    child: Center(child: leading!),
                  ),
                ),

              // 1. Progressively Pinning Title
              Positioned(
                left: leading != null ? 60.0 : 16.0,
                top: titleY,
                right: searchPinned ? 160.0 : 16.0,
                child: DefaultTextStyle(
                  style: (titlePinned
                          ? theme.textTheme.titleMedium!
                          : theme.textTheme.headlineSmall!)
                      .copyWith(fontWeight: FontWeight.bold),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  child: title,
                ),
              ),

              // 2. Progressively Pinning Search Bar
              Positioned(
                left: searchPinned ? (safeWidth - 150.0) : 16.0,
                top: searchY,
                width: searchPinned ? 134.0 : (safeWidth - 32.0),
                height: 38.0,
                child: searchBar,
              ),

              // 3. Progressively Pinning Status Pills
              if (!pillsPinned || !searchPinned)
                Positioned(
                  left: 16.0,
                  right: 16.0,
                  top: pillsY,
                  height: 36.0,
                  child: Opacity(
                    opacity: (1.0 - (shrinkOffset / config.actionsPinOffset)).clamp(0.0, 1.0),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: statusPills,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(covariant _CascadingProgressivePinDelegate oldDelegate) {
    return title != oldDelegate.title ||
        searchBar != oldDelegate.searchBar ||
        statusPills != oldDelegate.statusPills ||
        leading != oldDelegate.leading ||
        backgroundColor != oldDelegate.backgroundColor ||
        topPadding != oldDelegate.topPadding ||
        totalExpanded != oldDelegate.totalExpanded ||
        totalCollapsed != oldDelegate.totalCollapsed ||
        config != oldDelegate.config;
  }
}
