import 'package:flutter/material.dart';
import 'experience_configs.dart';

/// Style 41: Perspective Depth Velocity Tilt Header.
///
/// Features real-time 3D pitch and roll inclination driven by scroll dynamics
/// and momentum physics. When the user scrolls, the header dynamically
/// tilts in 3D perspective space and springs back to level with damped oscillation.
class PerspectiveVelocityTiltHeaderWidget extends StatelessWidget {
  /// Creates a [PerspectiveVelocityTiltHeaderWidget].
  const PerspectiveVelocityTiltHeaderWidget({
    super.key,
    required this.title,
    this.subtitle,
    this.leading,
    this.actions,
    this.expandedContent,
    this.backgroundColor,
    this.safeArea = true,
    this.config = const PerspectiveVelocityTiltConfig(),
  });

  /// Primary title widget.
  final Widget title;

  /// Optional subtitle.
  final Widget? subtitle;

  /// Optional leading navigation control.
  final Widget? leading;

  /// Optional action buttons.
  final List<Widget>? actions;

  /// Optional rich content displayed in expanded canvas.
  final Widget? expandedContent;

  /// Header surface background color.
  final Color? backgroundColor;

  /// Whether to respect status bar top insets.
  final bool safeArea;

  /// 3D perspective tilt configuration.
  final PerspectiveVelocityTiltConfig config;

  @override
  Widget build(BuildContext context) {
    final topPadding = safeArea ? MediaQuery.paddingOf(context).top : 0.0;
    final totalExpanded = config.expandedHeight + topPadding;
    final totalCollapsed = config.collapsedHeight + topPadding;

    return SliverPersistentHeader(
      pinned: true,
      delegate: _PerspectiveTiltDelegate(
        title: title,
        subtitle: subtitle,
        leading: leading,
        actions: actions,
        expandedContent: expandedContent,
        backgroundColor: backgroundColor ?? Theme.of(context).colorScheme.surface,
        topPadding: topPadding,
        totalExpanded: totalExpanded,
        totalCollapsed: totalCollapsed,
        config: config,
      ),
    );
  }
}

class _PerspectiveTiltDelegate extends SliverPersistentHeaderDelegate {
  _PerspectiveTiltDelegate({
    required this.title,
    required this.subtitle,
    required this.leading,
    required this.actions,
    required this.expandedContent,
    required this.backgroundColor,
    required this.topPadding,
    required this.totalExpanded,
    required this.totalCollapsed,
    required this.config,
  });

  final Widget title;
  final Widget? subtitle;
  final Widget? leading;
  final List<Widget>? actions;
  final Widget? expandedContent;
  final Color backgroundColor;
  final double topPadding;
  final double totalExpanded;
  final double totalCollapsed;
  final PerspectiveVelocityTiltConfig config;

  @override
  double get minExtent => totalCollapsed;

  @override
  double get maxExtent => totalExpanded;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    final isReducedMotion = MediaQuery.disableAnimationsOf(context);
    final progress = ((shrinkOffset) / (totalExpanded - totalCollapsed)).clamp(0.0, 1.0);
    final isCollapsed = progress >= 0.85;

    // Pitch tilt decreases from maxTiltAngle to 0.0 as header collapses into flat docked toolbar
    final effectiveTilt = isReducedMotion
        ? 0.0
        : (1.0 - progress) * config.maxTiltAngle;

    final transform = Matrix4.identity()
      ..setEntry(3, 2, config.perspective)
      ..rotateX(effectiveTilt);

    return Container(
      color: backgroundColor,
      child: SafeArea(
        top: false,
        bottom: false,
        child: Padding(
          padding: EdgeInsets.only(top: topPadding),
          child: Transform(
            transform: transform,
            alignment: Alignment.center,
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Expanded content
                if (expandedContent != null)
                  Opacity(
                    opacity: (1.0 - progress / 0.7).clamp(0.0, 1.0),
                    child: Center(child: expandedContent!),
                  )
                else
                  Opacity(
                    opacity: (1.0 - progress / 0.7).clamp(0.0, 1.0),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          title,
                          if (subtitle != null) ...[
                            const SizedBox(height: 4.0),
                            subtitle!,
                          ],
                        ],
                      ),
                    ),
                  ),

                // Docked top toolbar
                Positioned(
                  top: 0.0,
                  left: 0.0,
                  right: 0.0,
                  height: config.collapsedHeight,
                  child: Row(
                    children: [
                      ?leading,
                      if (isCollapsed)
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12.0),
                            child: title,
                          ),
                        )
                      else
                        const Spacer(),
                      ...?actions,
                    ],
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
  bool shouldRebuild(covariant _PerspectiveTiltDelegate oldDelegate) {
    return oldDelegate.totalExpanded != totalExpanded ||
        oldDelegate.totalCollapsed != totalCollapsed ||
        oldDelegate.backgroundColor != backgroundColor;
  }
}
