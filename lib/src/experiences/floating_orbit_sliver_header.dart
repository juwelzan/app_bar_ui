import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'experience_configs.dart';

/// Representation of an orbiting satellite action in [FloatingOrbitSliverHeaderWidget].
class OrbitSatelliteItem {
  /// Creates an [OrbitSatelliteItem].
  const OrbitSatelliteItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.backgroundColor,
    this.foregroundColor,
  });

  /// Satellite icon.
  final IconData icon;

  /// Semantic accessibility label.
  final String label;

  /// Callback when satellite is tapped.
  final VoidCallback onTap;

  /// Optional background color.
  final Color? backgroundColor;

  /// Optional icon/foreground color.
  final Color? foregroundColor;
}

/// Style 31: Floating Orbit Header.
///
/// Action satellite items orbit along a continuous celestial trajectory around a
/// central planetary title/avatar when expanded. As the user scrolls, the orbital
/// radius contracts with gravitational acceleration, aligning all satellites into
/// a compact horizontal row inside the pinned navigation toolbar.
class FloatingOrbitSliverHeaderWidget extends StatelessWidget {
  /// Creates a [FloatingOrbitSliverHeaderWidget].
  const FloatingOrbitSliverHeaderWidget({
    super.key,
    required this.centralTitle,
    required this.satellites,
    this.centralSubtitle,
    this.centralAvatar,
    this.leading,
    this.backgroundColor,
    this.safeArea = true,
    this.config = const FloatingOrbitSliverConfig(),
  });

  /// Central planetary title widget.
  final Widget centralTitle;

  /// Optional planetary subtitle.
  final Widget? centralSubtitle;

  /// Optional planetary central avatar or icon.
  final Widget? centralAvatar;

  /// Ordered satellite items orbiting the planetary center.
  final List<OrbitSatelliteItem> satellites;

  /// Optional leading navigation widget.
  final Widget? leading;

  /// Background color.
  final Color? backgroundColor;

  /// Whether to respect top SafeArea.
  final bool safeArea;

  /// Orbit motion configuration.
  final FloatingOrbitSliverConfig config;

  @override
  Widget build(BuildContext context) {
    final topPadding = safeArea ? MediaQuery.paddingOf(context).top : 0.0;
    final totalExpanded = math.max(config.expandedHeight + topPadding, config.collapsedHeight + topPadding + 1.0);
    final totalCollapsed = config.collapsedHeight + topPadding;

    return SliverPersistentHeader(
      pinned: true,
      delegate: _FloatingOrbitDelegate(
        centralTitle: centralTitle,
        centralSubtitle: centralSubtitle,
        centralAvatar: centralAvatar,
        satellites: satellites,
        leading: leading,
        backgroundColor: backgroundColor ?? Theme.of(context).colorScheme.surface,
        topPadding: topPadding,
        totalExpanded: totalExpanded,
        totalCollapsed: totalCollapsed,
        config: config,
      ),
    );
  }
}

class _FloatingOrbitDelegate extends SliverPersistentHeaderDelegate {
  _FloatingOrbitDelegate({
    required this.centralTitle,
    required this.centralSubtitle,
    required this.centralAvatar,
    required this.satellites,
    required this.leading,
    required this.backgroundColor,
    required this.topPadding,
    required this.totalExpanded,
    required this.totalCollapsed,
    required this.config,
  });

  final Widget centralTitle;
  final Widget? centralSubtitle;
  final Widget? centralAvatar;
  final List<OrbitSatelliteItem> satellites;
  final Widget? leading;
  final Color backgroundColor;
  final double topPadding;
  final double totalExpanded;
  final double totalCollapsed;
  final FloatingOrbitSliverConfig config;

  @override
  double get minExtent => totalCollapsed;

  @override
  double get maxExtent => totalExpanded;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    final reducedMotion = MediaQuery.disableAnimationsOf(context);
    final delta = maxExtent - minExtent;
    final progress = delta > 0 ? (shrinkOffset / delta).clamp(0.0, 1.0) : 0.0;
    final curvedProgress = reducedMotion ? progress : config.curve.transform(progress);

    final width = MediaQuery.sizeOf(context).width;
    final safeWidth = width > 0 ? width : 360.0;
    final theme = Theme.of(context);

    // Center coordinates for the planetary body
    // When expanded: middle of the expanded header (below topPadding)
    // When collapsed: offset to the left beside leading widget
    final expandedCenterX = safeWidth / 2.0;
    final expandedCenterY = topPadding + (totalExpanded - topPadding) * 0.45;

    final collapsedCenterX = leading != null ? 80.0 : 48.0;
    final collapsedCenterY = topPadding + (totalCollapsed - topPadding) / 2.0;

    final planetX = reducedMotion
        ? (progress > 0.5 ? collapsedCenterX : expandedCenterX)
        : (expandedCenterX + (collapsedCenterX - expandedCenterX) * curvedProgress);
    final planetY = reducedMotion
        ? (progress > 0.5 ? collapsedCenterY : expandedCenterY)
        : (expandedCenterY + (collapsedCenterY - expandedCenterY) * curvedProgress);

    // Planet scale: 1.0 down to 0.75
    final planetScale = 1.0 - (0.25 * curvedProgress);

    // Satellite orbital mechanics
    final currentOrbitRadius = config.orbitRadius * (1.0 - curvedProgress);
    final angleOffset = curvedProgress * math.pi * config.orbitSpeedFactor;

    return Material(
      elevation: config.elevation * curvedProgress,
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
              // Orbital trajectory ring indicator (visible when expanded)
              if (!reducedMotion && curvedProgress < 0.8)
                Positioned(
                  left: planetX - currentOrbitRadius,
                  top: planetY - currentOrbitRadius,
                  child: Opacity(
                    opacity: (1.0 - (curvedProgress / 0.8)).clamp(0.0, 1.0) * 0.25,
                    child: Container(
                      width: currentOrbitRadius * 2,
                      height: currentOrbitRadius * 2,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: theme.colorScheme.primary,
                          width: 1.5,
                        ),
                      ),
                    ),
                  ),
                ),

              // Leading button
              if (leading != null)
                Positioned(
                  top: topPadding + 4.0,
                  left: 8.0,
                  child: SizedBox(
                    width: 48.0,
                    height: 48.0,
                    child: Center(child: leading!),
                  ),
                ),

              // Planetary central body (Avatar, Title, Subtitle)
              Positioned(
                left: planetX - 90.0,
                top: planetY - 45.0,
                width: 180.0,
                height: 90.0,
                child: Transform.scale(
                  scale: planetScale,
                  child: OverflowBox(
                    minHeight: 0.0,
                    maxHeight: 120.0,
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        if (centralAvatar != null && curvedProgress < 0.7) ...[
                          Opacity(
                            opacity: (1.0 - (curvedProgress / 0.7)).clamp(0.0, 1.0),
                            child: centralAvatar!,
                          ),
                          const SizedBox(height: 4.0),
                        ],
                        DefaultTextStyle(
                          style: theme.textTheme.titleMedium!.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          child: centralTitle,
                        ),
                        if (centralSubtitle != null && curvedProgress < 0.5) ...[
                          const SizedBox(height: 2.0),
                          Opacity(
                            opacity: (1.0 - (curvedProgress / 0.5)).clamp(0.0, 1.0),
                            child: DefaultTextStyle(
                              style: theme.textTheme.bodySmall!,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              child: centralSubtitle!,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),

              // Orbiting Satellites
              ...List.generate(satellites.length, (index) {
                final sat = satellites[index];
                final count = satellites.length;

                // When expanded: spaced evenly around 2*pi
                final baseAngle = (2 * math.pi / count) * index;
                final currentAngle = baseAngle + angleOffset;

                // Expanded coordinates (orbiting planet)
                final orbX = planetX + currentOrbitRadius * math.cos(currentAngle) - 20.0;
                final orbY = planetY + currentOrbitRadius * math.sin(currentAngle) - 20.0;

                // Collapsed coordinates (docked row on top right)
                final dockedSpacing = 44.0;
                final dockedStartX = safeWidth - 16.0 - (count * dockedSpacing);
                final dockedX = dockedStartX + (index * dockedSpacing);
                final dockedY = topPadding + (totalCollapsed - topPadding - 40.0) / 2.0;

                final currentSatX = reducedMotion
                    ? (progress > 0.5 ? dockedX : orbX)
                    : (orbX + (dockedX - orbX) * curvedProgress);
                final currentSatY = reducedMotion
                    ? (progress > 0.5 ? dockedY : orbY)
                    : (orbY + (dockedY - orbY) * curvedProgress);

                return Positioned(
                  left: currentSatX,
                  top: currentSatY,
                  width: 40.0,
                  height: 40.0,
                  child: Semantics(
                    button: true,
                    label: sat.label,
                    child: Material(
                      shape: const CircleBorder(),
                      color: sat.backgroundColor ?? theme.colorScheme.primaryContainer,
                      elevation: 2.0,
                      child: InkWell(
                        customBorder: const CircleBorder(),
                        onTap: sat.onTap,
                        child: Center(
                          child: Icon(
                            sat.icon,
                            size: 20.0,
                            color: sat.foregroundColor ?? theme.colorScheme.onPrimaryContainer,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(covariant _FloatingOrbitDelegate oldDelegate) {
    return centralTitle != oldDelegate.centralTitle ||
        centralSubtitle != oldDelegate.centralSubtitle ||
        centralAvatar != oldDelegate.centralAvatar ||
        satellites != oldDelegate.satellites ||
        leading != oldDelegate.leading ||
        backgroundColor != oldDelegate.backgroundColor ||
        topPadding != oldDelegate.topPadding ||
        totalExpanded != oldDelegate.totalExpanded ||
        totalCollapsed != oldDelegate.totalCollapsed ||
        config != oldDelegate.config;
  }
}
