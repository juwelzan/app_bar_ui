import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'experience_configs.dart';

/// Style 16: Radial / Orbital Action Header
///
/// Header where action buttons orbit in a radial arc around a central anchor
/// in the expanded state, and collapse along curved orbital paths into a docked linear row.
class RadialOrbitalActionHeaderWidget extends StatelessWidget {
  /// Creates a [RadialOrbitalActionHeaderWidget].
  const RadialOrbitalActionHeaderWidget({
    super.key,
    required this.centerAnchor,
    required this.title,
    required this.actions,
    this.backgroundColor,
    this.config = const RadialOrbitalActionConfig(),
    this.safeArea = true,
  });

  /// Central anchor widget (e.g. Avatar, brand badge, key icon).
  final Widget centerAnchor;

  /// Title widget displayed in header.
  final Widget title;

  /// Action buttons that orbit around the anchor.
  final List<Widget> actions;

  /// Background color of the header canvas.
  final Color? backgroundColor;

  /// Orbital motion configuration.
  final RadialOrbitalActionConfig config;

  /// Whether to incorporate safe area top insets.
  final bool safeArea;

  @override
  Widget build(BuildContext context) {
    final topPadding = safeArea ? MediaQuery.paddingOf(context).top : 0.0;
    final totalExpanded = config.expandedHeight + topPadding;
    final totalCollapsed = config.collapsedHeight + topPadding;

    return SliverPersistentHeader(
      pinned: true,
      delegate: _RadialOrbitalActionDelegate(
        centerAnchor: centerAnchor,
        title: title,
        actions: actions,
        backgroundColor: backgroundColor,
        topPadding: topPadding,
        totalExpanded: totalExpanded,
        totalCollapsed: totalCollapsed,
        config: config,
      ),
    );
  }
}

class _RadialOrbitalActionDelegate extends SliverPersistentHeaderDelegate {
  _RadialOrbitalActionDelegate({
    required this.centerAnchor,
    required this.title,
    required this.actions,
    required this.backgroundColor,
    required this.topPadding,
    required this.totalExpanded,
    required this.totalCollapsed,
    required this.config,
  });

  final Widget centerAnchor;
  final Widget title;
  final List<Widget> actions;
  final Color? backgroundColor;
  final double topPadding;
  final double totalExpanded;
  final double totalCollapsed;
  final RadialOrbitalActionConfig config;

  @override
  double get minExtent => totalCollapsed;

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

    final rawProgress = (shrinkOffset / config.collapseThreshold).clamp(0.0, 1.0);
    final curve = config.resolveCurve(context);
    final progress = curve.transform(rawProgress);

    final currentRadius = isReducedMotion ? 0.0 : config.orbitRadius * (1.0 - progress);
    final resolvedBgColor = backgroundColor ?? theme.colorScheme.surface;

    return SizedBox.expand(
      child: Material(
        elevation: shrinkOffset > 5.0 ? config.elevation : 0.0,
        color: resolvedBgColor,
        child: ClipRect(
          child: Padding(
            padding: EdgeInsets.only(top: topPadding),
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Expanded State: Central Anchor with Orbiting Actions & Title
                if (progress < 0.85)
                  Positioned.fill(
                    child: Opacity(
                      opacity: (1.0 - progress * 1.2).clamp(0.0, 1.0),
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Stack(
                              alignment: Alignment.center,
                              clipBehavior: Clip.none,
                              children: [
                                // Center Anchor
                                centerAnchor,

                                // Orbiting Action Buttons
                                for (int i = 0; i < actions.length; i++)
                                  _buildOrbitingAction(i, currentRadius),
                              ],
                            ),
                            const SizedBox(height: 10.0),
                            DefaultTextStyle(
                              style: theme.textTheme.titleMedium!.copyWith(
                                fontWeight: FontWeight.bold,
                                overflow: TextOverflow.ellipsis,
                              ),
                              child: title,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                // Collapsed State: Linear Docked Toolbar
                if (progress > 0.25)
                  Positioned(
                    top: 0.0,
                    left: 0.0,
                    right: 0.0,
                    height: config.collapsedHeight,
                    child: Opacity(
                      opacity: ((progress - 0.25) / 0.75).clamp(0.0, 1.0),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 36.0,
                              height: 36.0,
                              child: Center(child: centerAnchor),
                            ),
                            const SizedBox(width: 12.0),
                            Expanded(
                              child: DefaultTextStyle(
                                style: theme.textTheme.titleMedium!.copyWith(
                                  fontWeight: FontWeight.bold,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                child: title,
                              ),
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: actions,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOrbitingAction(int index, double radius) {
    if (actions.isEmpty) return const SizedBox.shrink();

    final count = actions.length;
    final angleStep = count > 1
        ? (config.endAngle - config.startAngle) / (count - 1)
        : 0.0;
    final angle = config.startAngle + index * angleStep;

    // Polar to Cartesian conversion
    final dx = radius * math.cos(angle);
    final dy = radius * math.sin(angle);

    return Transform.translate(
      offset: Offset(dx, dy),
      child: actions[index],
    );
  }

  @override
  bool shouldRebuild(covariant _RadialOrbitalActionDelegate oldDelegate) {
    return oldDelegate.centerAnchor != centerAnchor ||
        oldDelegate.title != title ||
        oldDelegate.actions != actions ||
        oldDelegate.backgroundColor != backgroundColor ||
        oldDelegate.topPadding != topPadding ||
        oldDelegate.totalExpanded != totalExpanded ||
        oldDelegate.totalCollapsed != totalCollapsed ||
        oldDelegate.config != config;
  }
}
