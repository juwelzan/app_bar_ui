import 'package:flutter/material.dart';
import 'experience_configs.dart';

/// Style 17: Split-Screen Lateral Reveal Header
///
/// Header that parts like a stage curtain or elevator doors upon scrolling,
/// sliding left and right panels laterally to reveal a dramatic center showcase.
class SplitScreenLateralRevealHeaderWidget extends StatelessWidget {
  /// Creates a [SplitScreenLateralRevealHeaderWidget].
  const SplitScreenLateralRevealHeaderWidget({
    super.key,
    required this.centerShowcase,
    required this.leftCurtain,
    required this.rightCurtain,
    this.compactToolbar,
    this.backgroundColor,
    this.config = const SplitScreenLateralRevealConfig(),
    this.safeArea = true,
  });

  /// The center showcase revealed when panels part.
  final Widget centerShowcase;

  /// The left panel that slides laterally leftward.
  final Widget leftCurtain;

  /// The right panel that slides laterally rightward.
  final Widget rightCurtain;

  /// Optional compact toolbar displayed when fully collapsed.
  final Widget? compactToolbar;

  /// Background color of the header.
  final Color? backgroundColor;

  /// Motion and reveal configuration.
  final SplitScreenLateralRevealConfig config;

  /// Whether to incorporate safe area top insets.
  final bool safeArea;

  @override
  Widget build(BuildContext context) {
    final topPadding = safeArea ? MediaQuery.paddingOf(context).top : 0.0;
    final totalExpanded = config.expandedHeight + topPadding;
    final totalCollapsed = config.collapsedHeight + topPadding;

    return SliverPersistentHeader(
      pinned: true,
      delegate: _SplitScreenLateralRevealDelegate(
        centerShowcase: centerShowcase,
        leftCurtain: leftCurtain,
        rightCurtain: rightCurtain,
        compactToolbar: compactToolbar,
        backgroundColor: backgroundColor,
        topPadding: topPadding,
        totalExpanded: totalExpanded,
        totalCollapsed: totalCollapsed,
        config: config,
      ),
    );
  }
}

class _SplitScreenLateralRevealDelegate
    extends SliverPersistentHeaderDelegate {
  _SplitScreenLateralRevealDelegate({
    required this.centerShowcase,
    required this.leftCurtain,
    required this.rightCurtain,
    required this.compactToolbar,
    required this.backgroundColor,
    required this.topPadding,
    required this.totalExpanded,
    required this.totalCollapsed,
    required this.config,
  });

  final Widget centerShowcase;
  final Widget leftCurtain;
  final Widget rightCurtain;
  final Widget? compactToolbar;
  final Color? backgroundColor;
  final double topPadding;
  final double totalExpanded;
  final double totalCollapsed;
  final SplitScreenLateralRevealConfig config;

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

    // Parting reveal progress (0.0 -> 1.0)
    final revealProgress =
        (shrinkOffset / config.revealThreshold).clamp(0.0, 1.0);
    final curve = config.resolveCurve(context);
    final t = curve.transform(revealProgress);

    final leftOffset = isReducedMotion ? 0.0 : -config.partingDistance * t;
    final rightOffset = isReducedMotion ? 0.0 : config.partingDistance * t;

    final delta = maxExtent - minExtent;
    final totalProgress =
        delta > 0 ? (shrinkOffset / delta).clamp(0.0, 1.0) : 0.0;

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
                // Center Showcase Layer (revealed underneath parting curtains)
                Positioned.fill(
                  child: Opacity(
                    opacity: (1.0 - (totalProgress * 1.3)).clamp(0.0, 1.0),
                    child: Center(child: centerShowcase),
                  ),
                ),

                // Left Curtain Panel
                if (totalProgress < 0.85)
                  Positioned(
                    top: 0.0,
                    bottom: 0.0,
                    left: 0.0,
                    width: MediaQuery.sizeOf(context).width * 0.5,
                    child: Transform.translate(
                      offset: Offset(leftOffset, 0.0),
                      child: Opacity(
                        opacity: (1.0 - t * 0.7).clamp(0.0, 1.0),
                        child: leftCurtain,
                      ),
                    ),
                  ),

                // Right Curtain Panel
                if (totalProgress < 0.85)
                  Positioned(
                    top: 0.0,
                    bottom: 0.0,
                    right: 0.0,
                    width: MediaQuery.sizeOf(context).width * 0.5,
                    child: Transform.translate(
                      offset: Offset(rightOffset, 0.0),
                      child: Opacity(
                        opacity: (1.0 - t * 0.7).clamp(0.0, 1.0),
                        child: rightCurtain,
                      ),
                    ),
                  ),

                // Compact Docked Toolbar (emerges on full collapse)
                if (compactToolbar != null && totalProgress > 0.4)
                  Positioned(
                    top: 0.0,
                    left: 0.0,
                    right: 0.0,
                    height: config.collapsedHeight,
                    child: Opacity(
                      opacity: ((totalProgress - 0.4) / 0.6).clamp(0.0, 1.0),
                      child: compactToolbar!,
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
    covariant _SplitScreenLateralRevealDelegate oldDelegate,
  ) {
    return oldDelegate.centerShowcase != centerShowcase ||
        oldDelegate.leftCurtain != leftCurtain ||
        oldDelegate.rightCurtain != rightCurtain ||
        oldDelegate.compactToolbar != compactToolbar ||
        oldDelegate.backgroundColor != backgroundColor ||
        oldDelegate.topPadding != topPadding ||
        oldDelegate.totalExpanded != totalExpanded ||
        oldDelegate.totalCollapsed != totalCollapsed ||
        oldDelegate.config != config;
  }
}

