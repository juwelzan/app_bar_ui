import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'experience_configs.dart';

/// Style 43: Scroll-Driven Shape Polygon-To-Rectangle Morph Header.
///
/// Features a geometric multi-sided polygon (e.g. Hexagon, Octagon) that
/// morphs its path vertices dynamically based on scroll progression,
/// resolving seamlessly into a sharp rectangular docked toolbar.
class PolygonToRectangleMorphHeaderWidget extends StatelessWidget {
  /// Creates a [PolygonToRectangleMorphHeaderWidget].
  const PolygonToRectangleMorphHeaderWidget({
    super.key,
    required this.polygonContent,
    required this.dockedContent,
    this.backgroundColor,
    this.safeArea = true,
    this.config = const PolygonToRectangleMorphConfig(),
  });

  /// Widget content displayed inside the geometric polygon state.
  final Widget polygonContent;

  /// Widget content displayed when morphed into the rectangular toolbar.
  final Widget dockedContent;

  /// Background color of the morphing shape canvas.
  final Color? backgroundColor;

  /// Whether to respect status bar safe area.
  final bool safeArea;

  /// Shape morphing and polygon configuration.
  final PolygonToRectangleMorphConfig config;

  @override
  Widget build(BuildContext context) {
    final topPadding = safeArea ? MediaQuery.paddingOf(context).top : 0.0;
    final totalExpanded = config.expandedHeight + topPadding;
    final totalCollapsed = config.collapsedHeight + topPadding;

    return SliverPersistentHeader(
      pinned: true,
      delegate: _PolygonMorphDelegate(
        polygonContent: polygonContent,
        dockedContent: dockedContent,
        backgroundColor: backgroundColor ?? Theme.of(context).colorScheme.primaryContainer,
        topPadding: topPadding,
        totalExpanded: totalExpanded,
        totalCollapsed: totalCollapsed,
        config: config,
      ),
    );
  }
}

class _PolygonMorphDelegate extends SliverPersistentHeaderDelegate {
  _PolygonMorphDelegate({
    required this.polygonContent,
    required this.dockedContent,
    required this.backgroundColor,
    required this.topPadding,
    required this.totalExpanded,
    required this.totalCollapsed,
    required this.config,
  });

  final Widget polygonContent;
  final Widget dockedContent;
  final Color backgroundColor;
  final double topPadding;
  final double totalExpanded;
  final double totalCollapsed;
  final PolygonToRectangleMorphConfig config;

  @override
  double get minExtent => totalCollapsed;

  @override
  double get maxExtent => totalExpanded;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    final isReducedMotion = MediaQuery.disableAnimationsOf(context);
    // progress: 0.0 = polygon, 1.0 = rectangle
    final progress = ((shrinkOffset) / (totalExpanded - totalCollapsed)).clamp(0.0, 1.0);

    return SafeArea(
      top: false,
      bottom: false,
      child: Padding(
        padding: EdgeInsets.only(top: topPadding),
        child: ClipPath(
          clipper: isReducedMotion
              ? null
              : _PolygonToRectClipper(
                  progress: progress,
                  sides: config.polygonSides,
                ),
          child: Container(
            color: backgroundColor,
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Polygon mode content
                Opacity(
                  opacity: (1.0 - progress / 0.6).clamp(0.0, 1.0),
                  child: Center(child: polygonContent),
                ),

                // Docked rectangular content
                Opacity(
                  opacity: ((progress - 0.5) / 0.5).clamp(0.0, 1.0),
                  child: dockedContent,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(covariant _PolygonMorphDelegate oldDelegate) {
    return oldDelegate.totalExpanded != totalExpanded ||
        oldDelegate.totalCollapsed != totalCollapsed ||
        oldDelegate.backgroundColor != backgroundColor;
  }
}

class _PolygonToRectClipper extends CustomClipper<Path> {
  _PolygonToRectClipper({
    required this.progress,
    required this.sides,
  });

  final double progress;
  final int sides;

  @override
  Path getClip(Size size) {
    if (progress >= 0.99) {
      return Path()..addRect(Rect.fromLTWH(0.0, 0.0, size.width, size.height));
    }

    final path = Path();
    final cx = size.width / 2.0;
    final cy = size.height / 2.0;
    final radius = math.min(size.width, size.height) * 0.48;

    final polygonVertices = <Offset>[];
    for (int i = 0; i < sides; i++) {
      final angle = (i * 2 * math.pi / sides) - (math.pi / 2);
      polygonVertices.add(Offset(cx + radius * math.cos(angle), cy + radius * math.sin(angle)));
    }

    if (progress <= 0.01) {
      path.moveTo(polygonVertices[0].dx, polygonVertices[0].dy);
      for (int i = 1; i < polygonVertices.length; i++) {
        path.lineTo(polygonVertices[i].dx, polygonVertices[i].dy);
      }
      path.close();
      return path;
    }

    // Smoothly interpolate between polygon bounds and full rectangle
    final insetX = (1.0 - progress) * (size.width * 0.15);
    final insetY = (1.0 - progress) * (size.height * 0.10);
    final cornerRadius = (1.0 - progress) * configRadius(size);

    final rect = RRect.fromRectAndRadius(
      Rect.fromLTRB(insetX, insetY, size.width - insetX, size.height - insetY),
      Radius.circular(cornerRadius),
    );
    path.addRRect(rect);
    return path;
  }

  double configRadius(Size size) => size.height * 0.35;

  @override
  bool shouldReclip(covariant _PolygonToRectClipper oldClipper) {
    return oldClipper.progress != progress || oldClipper.sides != sides;
  }
}
