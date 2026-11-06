import 'package:flutter/material.dart';
import 'experience_configs.dart';

/// Style 19: Parallax Zoom Hero Header
///
/// Header that combines vertical parallax translation with non-linear zoom
/// scaling (elastic magnification on pull overscroll and scaling on collapse).
class ParallaxZoomHeroHeaderWidget extends StatelessWidget {
  /// Creates a [ParallaxZoomHeroHeaderWidget].
  const ParallaxZoomHeroHeaderWidget({
    super.key,
    required this.heroVisual,
    required this.foregroundOverlay,
    this.compactTitle,
    this.backgroundColor,
    this.config = const ParallaxZoomHeroConfig(),
    this.safeArea = true,
  });

  /// The hero image or background visual subjected to parallax zoom.
  final Widget heroVisual;

  /// Foreground content (e.g. titles, tags, meta badges).
  final Widget foregroundOverlay;

  /// Optional compact title displayed when docked.
  final Widget? compactTitle;

  /// Background color of the canvas.
  final Color? backgroundColor;

  /// Motion and optical configuration.
  final ParallaxZoomHeroConfig config;

  /// Whether to incorporate safe area top insets.
  final bool safeArea;

  @override
  Widget build(BuildContext context) {
    final topPadding = safeArea ? MediaQuery.paddingOf(context).top : 0.0;
    final totalExpanded = config.expandedHeight + topPadding;
    final totalCollapsed = config.collapsedHeight + topPadding;

    return SliverPersistentHeader(
      pinned: true,
      delegate: _ParallaxZoomHeroDelegate(
        heroVisual: heroVisual,
        foregroundOverlay: foregroundOverlay,
        compactTitle: compactTitle,
        backgroundColor: backgroundColor,
        topPadding: topPadding,
        totalExpanded: totalExpanded,
        totalCollapsed: totalCollapsed,
        config: config,
      ),
    );
  }
}

class _ParallaxZoomHeroDelegate extends SliverPersistentHeaderDelegate {
  _ParallaxZoomHeroDelegate({
    required this.heroVisual,
    required this.foregroundOverlay,
    required this.compactTitle,
    required this.backgroundColor,
    required this.topPadding,
    required this.totalExpanded,
    required this.totalCollapsed,
    required this.config,
  });

  final Widget heroVisual;
  final Widget foregroundOverlay;
  final Widget? compactTitle;
  final Color? backgroundColor;
  final double topPadding;
  final double totalExpanded;
  final double totalCollapsed;
  final ParallaxZoomHeroConfig config;

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

    final delta = maxExtent - minExtent;
    final collapseRatio =
        delta > 0 ? (shrinkOffset / delta).clamp(0.0, 1.0) : 0.0;
    final curve = config.resolveCurve(context);
    final t = curve.transform(collapseRatio);

    // Compute optical scale factor:
    // When shrinkOffset > 0, scales down subtly from 1.0 -> minCollapseZoom
    final scale = isReducedMotion
        ? 1.0
        : (1.0 - (1.0 - config.minCollapseZoom) * t);

    // Parallax vertical translation offset
    final visualYOffset = isReducedMotion ? 0.0 : -shrinkOffset * 0.4;

    // Darkening scrim alpha increases as user scrolls into content
    final scrimAlpha =
        (t * config.darkeningOverlayAlpha).clamp(0.0, 1.0);

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
                // Layer 1: Parallax Zoom Hero Visual
                Positioned.fill(
                  child: Transform.translate(
                    offset: Offset(0.0, visualYOffset),
                    child: Transform.scale(
                      scale: scale,
                      alignment: config.focalPoint,
                      child: heroVisual,
                    ),
                  ),
                ),

                // Layer 2: Progressive Darkening Scrim
                if (scrimAlpha > 0.01)
                  Positioned.fill(
                    child: Container(
                      color: Colors.black.withValues(alpha: scrimAlpha),
                    ),
                  ),

                // Layer 3: Foreground Overlay Content
                if (collapseRatio < 0.9)
                  Positioned.fill(
                    child: Opacity(
                      opacity: (1.0 - t * 1.3).clamp(0.0, 1.0),
                      child: foregroundOverlay,
                    ),
                  ),

                // Layer 4: Docked Compact Title
                if (compactTitle != null && collapseRatio > 0.35)
                  Positioned(
                    top: 0.0,
                    left: 0.0,
                    right: 0.0,
                    height: config.collapsedHeight,
                    child: Opacity(
                      opacity: ((collapseRatio - 0.35) / 0.65).clamp(0.0, 1.0),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: compactTitle!,
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

  @override
  bool shouldRebuild(covariant _ParallaxZoomHeroDelegate oldDelegate) {
    return oldDelegate.heroVisual != heroVisual ||
        oldDelegate.foregroundOverlay != foregroundOverlay ||
        oldDelegate.compactTitle != compactTitle ||
        oldDelegate.backgroundColor != backgroundColor ||
        oldDelegate.topPadding != topPadding ||
        oldDelegate.totalExpanded != totalExpanded ||
        oldDelegate.totalCollapsed != totalCollapsed ||
        oldDelegate.config != config;
  }
}

