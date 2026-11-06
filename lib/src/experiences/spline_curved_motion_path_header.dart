import 'package:flutter/material.dart';
import '../widgets/sliver_widget_marker.dart';
import 'experience_configs.dart';

/// Style 50: Spline Curved Motion Path Header.
///
/// Avatar badges and headline titles traverse curved cubic or quadratic Bézier
/// spline trajectories across 2D space rather than rigid linear paths as the
/// header collapses into the pinned toolbar.
class SplineCurvedMotionPathHeaderWidget extends StatelessWidget
    with SliverWidgetMarker {
  /// Creates a [SplineCurvedMotionPathHeaderWidget].
  const SplineCurvedMotionPathHeaderWidget({
    super.key,
    required this.avatar,
    required this.title,
    this.subtitle,
    this.leading,
    this.actions,
    this.backgroundColor,
    this.safeArea = true,
    this.config = const SplineCurvedMotionPathConfig(),
  });

  /// The focal avatar or badge traversing the curved spline path.
  final Widget avatar;

  /// Header title widget.
  final Widget title;

  /// Optional subtitle.
  final Widget? subtitle;

  /// Optional leading widget.
  final Widget? leading;

  /// Optional trailing action widgets.
  final List<Widget>? actions;

  /// Header canvas background color.
  final Color? backgroundColor;

  /// Whether to respect status bar safe area.
  final bool safeArea;

  /// Spline curve trajectory and avatar geometry configuration.
  final SplineCurvedMotionPathConfig config;

  @override
  Widget build(BuildContext context) {
    final topPadding = safeArea ? MediaQuery.paddingOf(context).top : 0.0;
    final totalExpanded = config.expandedHeight + topPadding;
    final totalCollapsed = config.collapsedHeight + topPadding;

    return SliverPersistentHeader(
      pinned: true,
      delegate: _SplineMotionDelegate(
        avatar: avatar,
        title: title,
        subtitle: subtitle,
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

class _SplineMotionDelegate extends SliverPersistentHeaderDelegate {
  _SplineMotionDelegate({
    required this.avatar,
    required this.title,
    required this.subtitle,
    required this.leading,
    required this.actions,
    required this.backgroundColor,
    required this.topPadding,
    required this.totalExpanded,
    required this.totalCollapsed,
    required this.config,
  });

  final Widget avatar;
  final Widget title;
  final Widget? subtitle;
  final Widget? leading;
  final List<Widget>? actions;
  final Color backgroundColor;
  final double topPadding;
  final double totalExpanded;
  final double totalCollapsed;
  final SplineCurvedMotionPathConfig config;

  @override
  double get minExtent => totalCollapsed;

  @override
  double get maxExtent => totalExpanded;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    final isReducedMotion = MediaQuery.disableAnimationsOf(context);
    final theme = Theme.of(context);
    final progress = ((shrinkOffset) / (totalExpanded - totalCollapsed)).clamp(0.0, 1.0);

    return Container(
      color: backgroundColor,
      child: SafeArea(
        top: false,
        bottom: false,
        child: Padding(
          padding: EdgeInsets.only(top: topPadding),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final canvasWidth = constraints.maxWidth;

              // Quadratic Bézier Spline Coordinates
              // P0 (Expanded): Centered lower canvas
              final p0 = Offset(canvasWidth / 2 - config.avatarStartSize / 2, totalExpanded - topPadding - config.avatarStartSize - 24.0);
              // P2 (Collapsed): Left side in pinned bar
              final p2 = Offset(leading != null ? 56.0 : 16.0, (config.collapsedHeight - config.avatarEndSize) / 2);
              // P1 (Control Point): Curved arch to the right
              final p1 = Offset(
                (p0.dx + p2.dx) / 2 + (isReducedMotion ? 0.0 : config.controlPointXOffset),
                (p0.dy + p2.dy) / 2 + (isReducedMotion ? 0.0 : config.controlPointYOffset),
              );

              // B(t) = (1-t)^2 * P0 + 2*(1-t)*t * P1 + t^2 * P2
              final t = progress;
              final oneMinusT = 1.0 - t;
              final currentX = oneMinusT * oneMinusT * p0.dx + 2 * oneMinusT * t * p1.dx + t * t * p2.dx;
              final currentY = oneMinusT * oneMinusT * p0.dy + 2 * oneMinusT * t * p1.dy + t * t * p2.dy;

              final currentAvatarSize = config.avatarStartSize + (config.avatarEndSize - config.avatarStartSize) * progress;

              return Stack(
                fit: StackFit.expand,
                children: [
                  // Top Pinned Toolbar with actions
                  Positioned(
                    top: 0.0,
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
                          const Spacer(),
                          ...?actions,
                        ],
                      ),
                    ),
                  ),

                  // Subtitle & Title in Expanded State
                  Positioned(
                    top: totalExpanded - topPadding - 18.0,
                    left: 20.0,
                    right: 20.0,
                    child: Opacity(
                      opacity: (1.0 - progress * 2.5).clamp(0.0, 1.0),
                      child: Center(
                        child: subtitle ?? const SizedBox.shrink(),
                      ),
                    ),
                  ),

                  // Title sliding smoothly into pinned toolbar
                  Positioned(
                    left: p2.dx + config.avatarEndSize + 12.0,
                    top: (config.collapsedHeight - 24.0) / 2,
                    right: 70.0,
                    child: Opacity(
                      opacity: progress.clamp(0.0, 1.0),
                      child: DefaultTextStyle(
                        style: theme.textTheme.titleMedium!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                        child: title,
                      ),
                    ),
                  ),

                  // Avatar traversing the Quadratic Bézier Spline Path
                  Positioned(
                    left: currentX,
                    top: currentY,
                    child: SizedBox(
                      width: currentAvatarSize,
                      height: currentAvatarSize,
                      child: avatar,
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(covariant _SplineMotionDelegate oldDelegate) {
    return oldDelegate.totalExpanded != totalExpanded ||
        oldDelegate.totalCollapsed != totalCollapsed ||
        oldDelegate.avatar != avatar ||
        oldDelegate.title != title ||
        oldDelegate.subtitle != subtitle ||
        oldDelegate.leading != leading ||
        oldDelegate.actions != actions ||
        oldDelegate.backgroundColor != backgroundColor ||
        oldDelegate.topPadding != topPadding ||
        oldDelegate.config != config;
  }
}
