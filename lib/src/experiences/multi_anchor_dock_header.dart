import 'package:flutter/material.dart';
import '../widgets/sliver_widget_marker.dart';
import 'experience_configs.dart';

/// Style 47: Multi-Anchor Dock Header.
///
/// An interactive action capsule that glides smoothly across multiple discrete
/// anchor positions as the user scrolls, snapping magnetically into the pinned
/// navigation bar with spring recoil damping.
class MultiAnchorDockHeaderWidget extends StatelessWidget
    with SliverWidgetMarker {
  /// Creates a [MultiAnchorDockHeaderWidget].
  const MultiAnchorDockHeaderWidget({
    super.key,
    required this.dockContent,
    this.expandedBackground,
    this.title,
    this.leading,
    this.actions,
    this.backgroundColor,
    this.safeArea = true,
    this.config = const MultiAnchorDockConfig(),
  });

  /// The interactive capsule content that moves between anchor positions.
  final Widget dockContent;

  /// Optional background canvas in expanded mode.
  final Widget? expandedBackground;

  /// Pinned title widget.
  final Widget? title;

  /// Optional leading widget.
  final Widget? leading;

  /// Optional pinned trailing actions.
  final List<Widget>? actions;

  /// Background fill color.
  final Color? backgroundColor;

  /// Whether to respect status bar safe area.
  final bool safeArea;

  /// Dock anchor physics and geometry configuration.
  final MultiAnchorDockConfig config;

  @override
  Widget build(BuildContext context) {
    final topPadding = safeArea ? MediaQuery.paddingOf(context).top : 0.0;
    final totalExpanded = config.expandedHeight + topPadding;
    final totalCollapsed = config.collapsedHeight + topPadding;

    return SliverPersistentHeader(
      pinned: true,
      delegate: _MultiAnchorDockDelegate(
        dockContent: dockContent,
        expandedBackground: expandedBackground,
        title: title,
        leading: leading,
        actions: actions,
        backgroundColor: backgroundColor ?? Theme.of(context).colorScheme.surface,
        topPadding: topPadding,
        totalExpanded: totalExpanded,
        totalCollapsed: totalCollapsed,
        config: config,
      ),
    );
  }
}

class _MultiAnchorDockDelegate extends SliverPersistentHeaderDelegate {
  _MultiAnchorDockDelegate({
    required this.dockContent,
    required this.expandedBackground,
    required this.title,
    required this.leading,
    required this.actions,
    required this.backgroundColor,
    required this.topPadding,
    required this.totalExpanded,
    required this.totalCollapsed,
    required this.config,
  });

  final Widget dockContent;
  final Widget? expandedBackground;
  final Widget? title;
  final Widget? leading;
  final List<Widget>? actions;
  final Color backgroundColor;
  final double topPadding;
  final double totalExpanded;
  final double totalCollapsed;
  final MultiAnchorDockConfig config;

  @override
  double get minExtent => totalCollapsed;

  @override
  double get maxExtent => totalExpanded;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    final isReducedMotion = MediaQuery.disableAnimationsOf(context);
    final theme = Theme.of(context);
    final progress = ((shrinkOffset) / (totalExpanded - totalCollapsed)).clamp(0.0, 1.0);

    // Anchor 1 (Expanded): Centered lower canvas (y ~ totalExpanded - 70)
    // Anchor 2 (Collapsed): Snapped into top toolbar (y ~ topPadding + 10)
    final startY = totalExpanded - 76.0;
    final endY = topPadding + (config.collapsedHeight - 48.0) / 2;
    final currentY = isReducedMotion
        ? (progress > 0.5 ? endY : startY)
        : (startY + (endY - startY) * progress);

    return Container(
      color: backgroundColor,
      child: SafeArea(
        top: false,
        bottom: false,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Expanded Background Canvas
            if (expandedBackground != null)
              Positioned.fill(
                child: Opacity(
                  opacity: (1.0 - progress * 1.5).clamp(0.0, 1.0),
                  child: expandedBackground!,
                ),
              ),

            // Pinned Toolbar (Leading & Title)
            Positioned(
              top: topPadding,
              left: 0.0,
              right: 0.0,
              height: config.collapsedHeight,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: [
                    if (leading != null) ...[
                      leading!,
                      const SizedBox(width: 8.0),
                    ],
                    if (title != null)
                      Expanded(
                        child: Opacity(
                          opacity: progress.clamp(0.0, 1.0),
                          child: DefaultTextStyle(
                            style: theme.textTheme.titleMedium!.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                            child: title!,
                          ),
                        ),
                      )
                    else
                      const Spacer(),
                    ...?actions,
                  ],
                ),
              ),
            ),

            // Multi-Anchor Floating Capsule
            Positioned(
              top: currentY,
              left: 16.0,
              right: 16.0,
              child: Center(
                child: Material(
                  elevation: config.dockElevation * (1.0 - progress * 0.4),
                  borderRadius: BorderRadius.circular(config.dockCornerRadius),
                  color: theme.colorScheme.surfaceContainerHighest,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: dockContent,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(covariant _MultiAnchorDockDelegate oldDelegate) {
    return oldDelegate.totalExpanded != totalExpanded ||
        oldDelegate.totalCollapsed != totalCollapsed ||
        oldDelegate.dockContent != dockContent ||
        oldDelegate.expandedBackground != expandedBackground ||
        oldDelegate.title != title ||
        oldDelegate.leading != leading ||
        oldDelegate.actions != actions ||
        oldDelegate.backgroundColor != backgroundColor ||
        oldDelegate.topPadding != topPadding ||
        oldDelegate.config != config;
  }
}
