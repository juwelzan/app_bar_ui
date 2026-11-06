import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'experience_configs.dart';

/// Style 7: Vertical Folding Accordion Header
///
/// Header featuring an origami-style vertical folding accordion tier that
/// rotates along a 3D horizontal hinge with seam depth shading as the user scrolls.
class VerticalFoldingAccordionHeaderWidget extends StatelessWidget {
  /// Creates a [VerticalFoldingAccordionHeaderWidget].
  const VerticalFoldingAccordionHeaderWidget({
    super.key,
    required this.pinnedToolbar,
    required this.foldingTier,
    this.backgroundColor,
    this.config = const VerticalFoldingAccordionConfig(),
    this.safeArea = true,
  });

  /// The top pinned toolbar that remains docked when folded.
  final Widget pinnedToolbar;

  /// The lower tier that folds vertically in 3D origami fashion.
  final Widget foldingTier;

  /// Background color of the header canvas.
  final Color? backgroundColor;

  /// Accordion motion configuration.
  final VerticalFoldingAccordionConfig config;

  /// Whether to incorporate safe area top insets.
  final bool safeArea;

  @override
  Widget build(BuildContext context) {
    final topPadding = safeArea ? MediaQuery.paddingOf(context).top : 0.0;
    final totalExpanded = config.expandedHeight + topPadding;
    final totalCollapsed = config.collapsedHeight + topPadding;

    return SliverPersistentHeader(
      pinned: true,
      delegate: _VerticalFoldingAccordionDelegate(
        pinnedToolbar: pinnedToolbar,
        foldingTier: foldingTier,
        backgroundColor: backgroundColor,
        topPadding: topPadding,
        totalExpanded: totalExpanded,
        totalCollapsed: totalCollapsed,
        config: config,
      ),
    );
  }
}

class _VerticalFoldingAccordionDelegate
    extends SliverPersistentHeaderDelegate {
  _VerticalFoldingAccordionDelegate({
    required this.pinnedToolbar,
    required this.foldingTier,
    required this.backgroundColor,
    required this.topPadding,
    required this.totalExpanded,
    required this.totalCollapsed,
    required this.config,
  });

  final Widget pinnedToolbar;
  final Widget foldingTier;
  final Color? backgroundColor;
  final double topPadding;
  final double totalExpanded;
  final double totalCollapsed;
  final VerticalFoldingAccordionConfig config;

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
    final foldProgress = (shrinkOffset / config.foldThreshold).clamp(0.0, 1.0);
    final curve = config.resolveCurve(context);
    final progress = curve.transform(foldProgress);

    // Fold angle from 0.0 to 90 degrees (pi / 2 radians)
    final foldAngle = progress * (math.pi / 2);
    final isFolded = foldAngle >= (math.pi / 2 - 0.01);

    final matrix = Matrix4.identity()
      ..setEntry(3, 2, config.perspective)
      ..rotateX(-foldAngle);

    final shadowAlpha = (progress * config.seamShadowIntensity).clamp(0.0, 1.0);
    final bgColor = backgroundColor ?? theme.colorScheme.surface;

    return SizedBox.expand(
      child: Material(
        elevation: shrinkOffset > 5.0 ? config.elevation : 0.0,
        color: bgColor,
        child: ClipRect(
          child: Padding(
            padding: EdgeInsets.only(top: topPadding),
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Top pinned toolbar
                Positioned(
                  top: 0.0,
                  left: 0.0,
                  right: 0.0,
                  height: config.collapsedHeight,
                  child: pinnedToolbar,
                ),

                // 3D Origami Folding Accordion Tier
                if (!isFolded)
                  Positioned(
                    top: config.collapsedHeight,
                    left: 0.0,
                    right: 0.0,
                    height: config.expandedHeight - config.collapsedHeight,
                    child: isReducedMotion
                        ? Opacity(
                            opacity: (1.0 - progress).clamp(0.0, 1.0),
                            child: foldingTier,
                          )
                        : Transform(
                            transform: matrix,
                            alignment: Alignment.topCenter,
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                foldingTier,

                                // Seam depth shadow overlay along the hinge
                                if (shadowAlpha > 0.01)
                                  IgnorePointer(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          colors: [
                                            Colors.black.withValues(
                                              alpha: shadowAlpha,
                                            ),
                                            Colors.transparent,
                                          ],
                                          stops: const [0.0, 0.4],
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
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
  bool shouldRebuild(
    covariant _VerticalFoldingAccordionDelegate oldDelegate,
  ) {
    return oldDelegate.pinnedToolbar != pinnedToolbar ||
        oldDelegate.foldingTier != foldingTier ||
        oldDelegate.backgroundColor != backgroundColor ||
        oldDelegate.topPadding != topPadding ||
        oldDelegate.totalExpanded != totalExpanded ||
        oldDelegate.totalCollapsed != totalCollapsed ||
        oldDelegate.config != config;
  }
}

