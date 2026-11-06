import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'experience_configs.dart';

/// Style 39: Radial Circular Reveal Header.
///
/// Expands and conceals a rich content canvas using an animated circular clipping mask
/// that radiates outward from an origin point. As the user scrolls, the circular aperture
/// contracts smoothly with mathematical precision, focusing attention onto a focal icon
/// or origin coordinate in the compact navigation bar.
class RadialCircularClipperRevealHeaderWidget extends StatelessWidget {
  /// Creates a [RadialCircularClipperRevealHeaderWidget].
  const RadialCircularClipperRevealHeaderWidget({
    super.key,
    required this.compactBar,
    required this.expandedCanvas,
    this.revealOrigin = Alignment.centerRight,
    this.backgroundColor,
    this.safeArea = true,
    this.config = const RadialCircularClipperRevealConfig(),
  });

  /// The compact navigation bar always present at minimum extent.
  final Widget compactBar;

  /// The rich expanded canvas revealed through the circular mask.
  final Widget expandedCanvas;

  /// Origin alignment from which the circular reveal expands.
  final Alignment revealOrigin;

  /// Header background color.
  final Color? backgroundColor;

  /// Whether to respect top SafeArea.
  final bool safeArea;

  /// Configuration for reveal radius and thresholds.
  final RadialCircularClipperRevealConfig config;

  @override
  Widget build(BuildContext context) {
    final topPadding = safeArea ? MediaQuery.paddingOf(context).top : 0.0;
    final totalExpanded = config.expandedHeight + topPadding;
    final totalCollapsed = config.collapsedHeight + topPadding;

    return SliverPersistentHeader(
      pinned: true,
      delegate: _RadialCircularClipperRevealDelegate(
        compactBar: compactBar,
        expandedCanvas: expandedCanvas,
        revealOrigin: revealOrigin,
        backgroundColor: backgroundColor ?? Theme.of(context).colorScheme.surface,
        topPadding: topPadding,
        totalExpanded: math.max(totalExpanded, totalCollapsed + 1.0),
        totalCollapsed: totalCollapsed,
        config: config,
      ),
    );
  }
}

class _RadialCircularClipperRevealDelegate extends SliverPersistentHeaderDelegate {
  _RadialCircularClipperRevealDelegate({
    required this.compactBar,
    required this.expandedCanvas,
    required this.revealOrigin,
    required this.backgroundColor,
    required this.topPadding,
    required this.totalExpanded,
    required this.totalCollapsed,
    required this.config,
  });

  final Widget compactBar;
  final Widget expandedCanvas;
  final Alignment revealOrigin;
  final Color backgroundColor;
  final double topPadding;
  final double totalExpanded;
  final double totalCollapsed;
  final RadialCircularClipperRevealConfig config;

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

    // Origin coordinate for the circle
    final originX = (safeWidth * (revealOrigin.x + 1.0) / 2.0).clamp(0.0, safeWidth);
    final originY = topPadding + (totalCollapsed - topPadding) / 2.0;

    // Maximum radius needed to cover the entire header canvas
    final maxRadius = math.sqrt(math.pow(safeWidth, 2) + math.pow(totalExpanded, 2));
    final currentRadius = reducedMotion
        ? (progress > 0.5 ? 0.0 : maxRadius)
        : (config.minRadius + (maxRadius - config.minRadius) * (1.0 - curvedProgress));

    return Material(
      elevation: 2.0 * curvedProgress,
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
              // 1. Base Compact Bar (visible underneath)
              Positioned(
                left: 0.0,
                right: 0.0,
                top: 0.0,
                height: totalCollapsed,
                child: Padding(
                  padding: EdgeInsets.only(top: topPadding),
                  child: compactBar,
                ),
              ),

              // 2. Circular Clipped Expanded Canvas
              if (currentRadius > 0.5)
                ClipPath(
                  clipper: _CircularRevealClipper(
                    center: Offset(originX, originY),
                    radius: currentRadius,
                  ),
                  child: Container(
                    width: safeWidth,
                    height: totalExpanded,
                    color: backgroundColor,
                    child: Padding(
                      padding: EdgeInsets.only(top: topPadding),
                      child: expandedCanvas,
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
  bool shouldRebuild(covariant _RadialCircularClipperRevealDelegate oldDelegate) {
    return compactBar != oldDelegate.compactBar ||
        expandedCanvas != oldDelegate.expandedCanvas ||
        revealOrigin != oldDelegate.revealOrigin ||
        backgroundColor != oldDelegate.backgroundColor ||
        topPadding != oldDelegate.topPadding ||
        totalExpanded != oldDelegate.totalExpanded ||
        totalCollapsed != oldDelegate.totalCollapsed ||
        config != oldDelegate.config;
  }
}

/// Custom clipper that punches a circular aperture of given [radius] centered at [center].
class _CircularRevealClipper extends CustomClipper<Path> {
  const _CircularRevealClipper({
    required this.center,
    required this.radius,
  });

  final Offset center;
  final double radius;

  @override
  Path getClip(Size size) {
    final path = Path();
    path.addOval(Rect.fromCircle(center: center, radius: radius));
    return path;
  }

  @override
  bool shouldReclip(covariant _CircularRevealClipper oldClipper) {
    return center != oldClipper.center || radius != oldClipper.radius;
  }
}

