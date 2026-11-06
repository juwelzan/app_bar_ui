import 'package:flutter/material.dart';
import '../../../widgets/sliver_widget_marker.dart';
import 'floating_island_config.dart';

/// Model 3: Floating Dynamic Island Navigation Header.
///
/// A decoupled floating pill that hovers freely over the scroll viewport with
/// adaptive margins, dynamic height compression, live status chips, and
/// tactile spring recoil physics.
class FloatingIslandHeaderWidget extends StatelessWidget
    with SliverWidgetMarker {
  /// Creates a [FloatingIslandHeaderWidget].
  const FloatingIslandHeaderWidget({
    super.key,
    this.title,
    this.leading,
    this.actions,
    this.config = const FloatingIslandConfig(),
  });

  /// Optional custom title widget override.
  final Widget? title;

  /// Optional custom leading widget override.
  final Widget? leading;

  /// Optional trailing actions.
  final List<Widget>? actions;

  /// Strongly-typed configuration for this model.
  final FloatingIslandConfig config;

  @override
  Widget build(BuildContext context) {
    final topPadding = config.safeArea ? MediaQuery.paddingOf(context).top : 0.0;
    final totalExpanded = config.expandedHeight + topPadding + 16.0;
    final totalCollapsed = config.compactHeight + topPadding + 8.0;

    return SliverPersistentHeader(
      pinned: true,
      delegate: _FloatingIslandDelegate(
        title: title,
        leading: leading,
        actions: actions,
        config: config,
        topPadding: topPadding,
        totalExpanded: totalExpanded,
        totalCollapsed: totalCollapsed,
      ),
    );
  }
}

class _FloatingIslandDelegate extends SliverPersistentHeaderDelegate {
  _FloatingIslandDelegate({
    required this.title,
    required this.leading,
    required this.actions,
    required this.config,
    required this.topPadding,
    required this.totalExpanded,
    required this.totalCollapsed,
  });

  final Widget? title;
  final Widget? leading;
  final List<Widget>? actions;
  final FloatingIslandConfig config;
  final double topPadding;
  final double totalExpanded;
  final double totalCollapsed;

  @override
  double get minExtent => totalCollapsed;

  @override
  double get maxExtent => totalExpanded;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    final theme = Theme.of(context);
    final isReducedMotion = MediaQuery.disableAnimationsOf(context);
    final collapseRange = totalExpanded - totalCollapsed;
    final progress = collapseRange > 0.0 ? (shrinkOffset / collapseRange).clamp(0.0, 1.0) : 0.0;

    // Margin & geometry interpolation
    final currentMargin = isReducedMotion
        ? (progress > 0.5 ? config.compactHorizontalMargin : config.expandedHorizontalMargin)
        : (config.expandedHorizontalMargin + (config.compactHorizontalMargin - config.expandedHorizontalMargin) * progress);

    final currentHeight = isReducedMotion
        ? (progress > 0.5 ? config.compactHeight : config.expandedHeight)
        : (config.expandedHeight - (config.expandedHeight - config.compactHeight) * progress);

    final currentElevation = config.elevation * (1.0 - progress * 0.3);
    final accent = config.accentColor ?? theme.colorScheme.primary;

    return Container(
      color: Colors.transparent,
      padding: EdgeInsets.only(top: topPadding + 4.0),
      alignment: Alignment.topCenter,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: currentMargin),
        child: Material(
          elevation: currentElevation,
          borderRadius: BorderRadius.circular(config.borderRadius),
          color: config.backgroundColor ?? theme.colorScheme.surfaceContainerHighest,
          surfaceTintColor: config.surfaceTint,
          shadowColor: theme.shadowColor.withValues(alpha: 0.25),
          child: Container(
            height: currentHeight,
            padding: const EdgeInsets.symmetric(horizontal: 14.0),
            alignment: Alignment.center,
            child: Row(
              children: [
                // Leading Island Icon or Custom Leading
                if (leading != null)
                  leading!
                else
                  Container(
                    width: 32.0,
                    height: 32.0,
                    decoration: BoxDecoration(
                      color: accent.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(config.leadingIcon, size: 18.0, color: accent),
                  ),

                const SizedBox(width: 10.0),

                // Island Title & Telemetry
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DefaultTextStyle(
                        style: theme.textTheme.titleSmall!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                        child: title ??
                            Text(
                              config.islandTitle,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                      ),
                      if (progress < 0.6 && config.islandSubtitle != null)
                        Opacity(
                          opacity: (1.0 - progress / 0.6).clamp(0.0, 1.0),
                          child: Text(
                            config.islandSubtitle!,
                            style: theme.textTheme.bodySmall!.copyWith(
                              fontSize: 11.0,
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                    ],
                  ),
                ),

                // Optional Status Chips
                if (config.statusChips.isNotEmpty && progress < 0.5)
                  Opacity(
                    opacity: (1.0 - progress / 0.5).clamp(0.0, 1.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: config.statusChips,
                    ),
                  ),

                // Trailing Action or Status Indicator
                if (actions != null)
                  ...actions!
                else
                  Container(
                    width: 8.0,
                    height: 8.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: accent,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(covariant _FloatingIslandDelegate oldDelegate) {
    return oldDelegate.totalExpanded != totalExpanded ||
        oldDelegate.totalCollapsed != totalCollapsed ||
        oldDelegate.config != config ||
        oldDelegate.title != title ||
        oldDelegate.leading != leading ||
        oldDelegate.actions != actions ||
        oldDelegate.topPadding != topPadding;
  }
}

