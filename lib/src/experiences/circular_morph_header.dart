import 'dart:ui' show lerpDouble;
import 'package:flutter/material.dart';

import '../motion/motion_timeline.dart';
import '../widgets/sliver_widget_marker.dart';
import 'experience_configs.dart';

/// Style 4: Circular Morph Header
///
/// Transitions from a full-width rectangular header into a compact floating
/// circular icon or avatar element anchored at a specific corner.
class CircularMorphHeaderWidget extends StatelessWidget
    with SliverWidgetMarker {
  /// Creates a [CircularMorphHeaderWidget].
  const CircularMorphHeaderWidget({
    super.key,
    required this.expandedChild,
    required this.circularChild,
    this.backgroundColor,
    this.config = const CircularMorphConfig(),
    this.safeArea = true,
  });

  /// Widget rendered when expanded (full-width rectangular layout).
  final Widget expandedChild;

  /// Widget rendered when morphed into compact circle.
  final Widget circularChild;

  /// Background fill color.
  final Color? backgroundColor;

  /// Motion and morphing geometry configuration.
  final CircularMorphConfig config;

  /// Whether to pad for status bar insets.
  final bool safeArea;

  @override
  Widget build(BuildContext context) {
    final topPadding = safeArea ? MediaQuery.paddingOf(context).top : 0.0;
    final totalExpanded = config.expandedHeight + topPadding;
    final totalCollapsed = config.targetDiameter + topPadding + 16.0;

    return SliverPersistentHeader(
      pinned: true,
      delegate: _CircularMorphDelegate(
        expandedChild: expandedChild,
        circularChild: circularChild,
        backgroundColor: backgroundColor,
        topPadding: topPadding,
        totalExpanded: totalExpanded,
        totalCollapsed: totalCollapsed,
        config: config,
      ),
    );
  }
}

class _CircularMorphDelegate extends SliverPersistentHeaderDelegate {
  _CircularMorphDelegate({
    required this.expandedChild,
    required this.circularChild,
    required this.backgroundColor,
    required this.topPadding,
    required this.totalExpanded,
    required this.totalCollapsed,
    required this.config,
  });

  final Widget expandedChild;
  final Widget circularChild;
  final Color? backgroundColor;
  final double topPadding;
  final double totalExpanded;
  final double totalCollapsed;
  final CircularMorphConfig config;

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

    final morphProgress = ScrollMotionTimeline.evaluateStage(
      progress: rawProgress,
      start: 0.0,
      end: 1.0,
      curve: config.resolveCurve(context),
      reducedMotion: isReducedMotion,
    );

    final screenWidth = MediaQuery.sizeOf(context).width;
    final expandedWidth = screenWidth - (config.margin.horizontal);
    final targetWidth = config.targetDiameter;

    // Geometric morph: width, height, radius
    final currentWidth = isReducedMotion
        ? (rawProgress > 0.5 ? targetWidth : expandedWidth)
        : (lerpDouble(expandedWidth, targetWidth, morphProgress) ?? expandedWidth);

    final currentHeight = isReducedMotion
        ? (rawProgress > 0.5 ? config.targetDiameter : config.expandedHeight)
        : (lerpDouble(config.expandedHeight, config.targetDiameter, morphProgress) ??
            config.expandedHeight);

    final currentRadius = isReducedMotion
        ? (rawProgress > 0.5 ? config.targetDiameter / 2 : 16.0)
        : (lerpDouble(16.0, config.targetDiameter / 2, morphProgress) ?? 16.0);

    final currentElevation = rawProgress > 0.5
        ? config.compactElevation
        : config.restingElevation;

    // Alignment morph from center (0,0) to target anchor (e.g. top-right 1.0, -1.0)
    final currentAlignment = isReducedMotion
        ? (rawProgress > 0.5 ? config.anchorAlignment : Alignment.center)
        : (Alignment.lerp(Alignment.center, config.anchorAlignment, morphProgress) ??
            Alignment.center);

    return Padding(
      padding: EdgeInsets.only(top: topPadding),
      child: Align(
        alignment: currentAlignment,
        child: Padding(
          padding: EdgeInsets.lerp(config.margin, config.compactMargin, morphProgress) ??
              config.margin,
          child: Material(
            elevation: currentElevation,
            borderRadius: BorderRadius.circular(currentRadius),
            color: backgroundColor ?? theme.colorScheme.primaryContainer,
            clipBehavior: Clip.antiAlias,
            child: SizedBox(
              width: currentWidth,
              height: currentHeight,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 180),
                child: morphProgress > 0.65
                    ? Center(
                        key: const ValueKey('circular'),
                        child: circularChild,
                      )
                    : Center(
                        key: const ValueKey('expanded'),
                        child: OverflowBox(
                          minWidth: 0.0,
                          maxWidth: expandedWidth,
                          minHeight: 0.0,
                          maxHeight: config.expandedHeight,
                          child: expandedChild,
                        ),
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(covariant _CircularMorphDelegate oldDelegate) {
    return oldDelegate.totalExpanded != totalExpanded ||
        oldDelegate.totalCollapsed != totalCollapsed ||
        oldDelegate.expandedChild != expandedChild ||
        oldDelegate.circularChild != circularChild ||
        oldDelegate.backgroundColor != backgroundColor ||
        oldDelegate.config != config;
  }
}

