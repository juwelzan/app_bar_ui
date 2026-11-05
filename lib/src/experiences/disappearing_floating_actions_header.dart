import 'package:flutter/material.dart';

import '../widgets/sliver_widget_marker.dart';
import 'experience_configs.dart';

/// Style 3: Disappearing Header with Floating Actions
///
/// The header content and title scroll away completely without a permanent background,
/// while action controls detach into independently pinned floating action pills.
class DisappearingFloatingActionsHeaderWidget extends StatelessWidget
    with SliverWidgetMarker {
  /// Creates a [DisappearingFloatingActionsHeaderWidget].
  const DisappearingFloatingActionsHeaderWidget({
    super.key,
    required this.title,
    this.subtitle,
    required this.actions,
    this.leading,
    this.config = const DisappearingFloatingActionsConfig(),
    this.safeArea = true,
  });

  /// Main title widget that scrolls away.
  final Widget title;

  /// Optional subtitle widget.
  final Widget? subtitle;

  /// Action buttons that detach into floating controls.
  final List<Widget> actions;

  /// Leading navigation widget.
  final Widget? leading;

  /// Configuration for detach offsets and elevations.
  final DisappearingFloatingActionsConfig config;

  /// Whether to pad for status bar insets.
  final bool safeArea;

  @override
  Widget build(BuildContext context) {
    final topPadding = safeArea ? MediaQuery.paddingOf(context).top : 0.0;
    final totalExpanded = config.expandedHeight + topPadding;
    const totalCollapsed = kToolbarHeight;

    return SliverPersistentHeader(
      pinned: true,
      delegate: _DisappearingFloatingActionsDelegate(
        title: title,
        subtitle: subtitle,
        actions: actions,
        leading: leading,
        topPadding: topPadding,
        totalExpanded: totalExpanded,
        totalCollapsed: totalCollapsed,
        config: config,
      ),
    );
  }
}

class _DisappearingFloatingActionsDelegate
    extends SliverPersistentHeaderDelegate {
  _DisappearingFloatingActionsDelegate({
    required this.title,
    required this.subtitle,
    required this.actions,
    required this.leading,
    required this.topPadding,
    required this.totalExpanded,
    required this.totalCollapsed,
    required this.config,
  });

  final Widget title;
  final Widget? subtitle;
  final List<Widget> actions;
  final Widget? leading;
  final double topPadding;
  final double totalExpanded;
  final double totalCollapsed;
  final DisappearingFloatingActionsConfig config;

  @override
  double get minExtent => totalCollapsed + topPadding;

  @override
  double get maxExtent => totalExpanded;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    final theme = Theme.of(context);
    final isReducedMotion = MediaQuery.disableAnimationsOf(context);

    // Title fades out completely between 0 and config.fadeOffset
    final titleProgress = (shrinkOffset / config.fadeOffset).clamp(0.0, 1.0);
    final titleOpacity = (1.0 - titleProgress).clamp(0.0, 1.0);

    // Actions detach and elevate past config.detachOffset
    final isDetached = shrinkOffset >= config.detachOffset;
    final detachRatio = ((shrinkOffset - config.detachOffset) / 40.0).clamp(0.0, 1.0);

    return SizedBox.expand(
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Scrolling Away Header Content
          if (titleOpacity > 0.0)
            Positioned(
              left: 20.0,
              right: 20.0,
              bottom: 16.0,
              child: Opacity(
                opacity: titleOpacity,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DefaultTextStyle(
                      style: theme.textTheme.headlineMedium!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      child: title,
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 4.0),
                      DefaultTextStyle(
                        style: theme.textTheme.bodyMedium!.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                        child: subtitle!,
                      ),
                    ],
                  ],
                ),
              ),
            ),

          // Pinned Top Layer: Leading & Floating Actions
          Positioned(
            top: topPadding,
            left: 16.0,
            right: 16.0,
            height: totalCollapsed,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Optional leading button (e.g. back button in floating pill)
                if (leading != null)
                  Material(
                    elevation: isDetached ? config.floatingActionElevation : 0.0,
                    shape: const CircleBorder(),
                    color: isDetached
                        ? theme.colorScheme.surface
                        : Colors.transparent,
                    child: leading!,
                  )
                else
                  const SizedBox.shrink(),

                // Detached Floating Action Cluster
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: actions.map((action) {
                    final targetElevation = isDetached
                        ? config.floatingActionElevation * (isReducedMotion ? 1.0 : detachRatio)
                        : 0.0;

                    return Container(
                      margin: EdgeInsets.only(left: config.actionSpacing),
                      child: Material(
                        elevation: targetElevation,
                        shape: const CircleBorder(),
                        color: isDetached
                            ? theme.colorScheme.surface
                            : Colors.transparent,
                        child: action,
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  bool shouldRebuild(covariant _DisappearingFloatingActionsDelegate oldDelegate) {
    return oldDelegate.totalExpanded != totalExpanded ||
        oldDelegate.totalCollapsed != totalCollapsed ||
        oldDelegate.title != title ||
        oldDelegate.subtitle != subtitle ||
        oldDelegate.actions != actions ||
        oldDelegate.leading != leading ||
        oldDelegate.config != config;
  }
}
