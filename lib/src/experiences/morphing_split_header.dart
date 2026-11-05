import 'package:flutter/material.dart';

import '../motion/motion_timeline.dart';
import '../widgets/sliver_widget_marker.dart';
import 'experience_configs.dart';

/// Style 1: Morphing Split Header
///
/// Divides into two counter-directionally animated modules during scroll,
/// which diverge laterally and merge back into a compact center navigation pill.
class MorphingSplitHeaderWidget extends StatelessWidget
    with SliverWidgetMarker {
  /// Creates a [MorphingSplitHeaderWidget].
  const MorphingSplitHeaderWidget({
    super.key,
    required this.leftModule,
    required this.rightModule,
    this.compactPill,
    this.backgroundColor,
    this.collapsedBackgroundColor,
    this.config = const MorphingSplitConfig(),
    this.safeArea = true,
  });

  /// Left-side module (e.g. leading back button and expanded title).
  final Widget leftModule;

  /// Right-side module (e.g. status badge and action icons).
  final Widget rightModule;

  /// Compact center pill widget rendered when modules diverge and merge.
  final Widget? compactPill;

  /// Background color in expanded state.
  final Color? backgroundColor;

  /// Background color in collapsed compact state.
  final Color? collapsedBackgroundColor;

  /// Motion and geometry configuration.
  final MorphingSplitConfig config;

  /// Whether to pad for status bar safe area.
  final bool safeArea;

  @override
  Widget build(BuildContext context) {
    final topPadding = safeArea ? MediaQuery.paddingOf(context).top : 0.0;
    final totalExpanded = config.expandedHeight + topPadding;
    final totalCollapsed = config.collapsedHeight + topPadding;

    return SliverPersistentHeader(
      pinned: true,
      delegate: _MorphingSplitHeaderDelegate(
        leftModule: leftModule,
        rightModule: rightModule,
        compactPill: compactPill,
        topPadding: topPadding,
        totalExpanded: totalExpanded,
        totalCollapsed: totalCollapsed,
        config: config,
        bgColor: backgroundColor,
        collapsedBgColor: collapsedBackgroundColor,
      ),
    );
  }
}

class _MorphingSplitHeaderDelegate extends SliverPersistentHeaderDelegate {
  _MorphingSplitHeaderDelegate({
    required this.leftModule,
    required this.rightModule,
    required this.compactPill,
    required this.topPadding,
    required this.totalExpanded,
    required this.totalCollapsed,
    required this.config,
    required this.bgColor,
    required this.collapsedBgColor,
  });

  final Widget leftModule;
  final Widget rightModule;
  final Widget? compactPill;
  final double topPadding;
  final double totalExpanded;
  final double totalCollapsed;
  final MorphingSplitConfig config;
  final Color? bgColor;
  final Color? collapsedBgColor;

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
    final rawProgress = (shrinkOffset / (maxExtent - minExtent)).clamp(0.0, 1.0);

    // Stage 1: Left and right modules diverge outwards [0.0 -> mergeThreshold]
    final divergeProgress = ScrollMotionTimeline.evaluateStage(
      progress: rawProgress,
      start: 0.0,
      end: config.mergeThreshold,
      curve: config.resolveCurve(context),
      reducedMotion: isReducedMotion,
    );

    // Stage 2: Center pill merges and fades in [mergeThreshold -> 1.0]
    final mergeProgress = ScrollMotionTimeline.evaluateStage(
      progress: rawProgress,
      start: config.mergeThreshold,
      end: 1.0,
      curve: config.resolveCurve(context),
      reducedMotion: isReducedMotion,
    );

    final leftOffset = isReducedMotion
        ? Offset.zero
        : Offset(-config.splitDistance * divergeProgress, 0.0);
    final rightOffset = isReducedMotion
        ? Offset.zero
        : Offset(config.splitDistance * divergeProgress, 0.0);

    final moduleOpacity = (1.0 - divergeProgress).clamp(0.0, 1.0);
    final currentBg = Color.lerp(
      bgColor ?? theme.colorScheme.surface,
      collapsedBgColor ?? theme.colorScheme.surfaceContainer,
      rawProgress,
    );
    final currentElevation = rawProgress >= 0.8
        ? config.collapsedElevation
        : config.elevation;

    return Material(
      elevation: currentElevation,
      color: currentBg,
      child: Padding(
        padding: EdgeInsets.only(top: topPadding),
        child: SizedBox.expand(
          child: Stack(
            fit: StackFit.expand,
            alignment: Alignment.center,
            children: [
              // Diverging Left Module
              if (moduleOpacity > 0.0)
                Positioned(
                  left: 16.0,
                  bottom: 8.0,
                  child: Transform.translate(
                    offset: leftOffset,
                    child: Opacity(
                      opacity: moduleOpacity,
                      child: leftModule,
                    ),
                  ),
                ),

              // Diverging Right Module
              if (moduleOpacity > 0.0)
                Positioned(
                  right: 16.0,
                  bottom: 8.0,
                  child: Transform.translate(
                    offset: rightOffset,
                    child: Opacity(
                      opacity: moduleOpacity,
                      child: rightModule,
                    ),
                  ),
                ),

              // Merged Center Pill
              if (mergeProgress > 0.0)
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 8.0,
                  child: Opacity(
                    opacity: mergeProgress,
                    child: Transform.scale(
                      scale: isReducedMotion ? 1.0 : (0.8 + 0.2 * mergeProgress),
                      child: Center(
                        child: compactPill ??
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16.0,
                                vertical: 6.0,
                              ),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.primaryContainer,
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              child: Text(
                                'Navigation',
                                style: theme.textTheme.labelMedium?.copyWith(
                                  color: theme.colorScheme.onPrimaryContainer,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                      ),
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
  bool shouldRebuild(covariant _MorphingSplitHeaderDelegate oldDelegate) {
    return oldDelegate.totalExpanded != totalExpanded ||
        oldDelegate.totalCollapsed != totalCollapsed ||
        oldDelegate.leftModule != leftModule ||
        oldDelegate.rightModule != rightModule ||
        oldDelegate.compactPill != compactPill ||
        oldDelegate.config != config ||
        oldDelegate.bgColor != bgColor ||
        oldDelegate.collapsedBgColor != collapsedBgColor;
  }
}
