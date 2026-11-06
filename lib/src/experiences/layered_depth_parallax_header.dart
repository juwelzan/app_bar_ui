import 'dart:ui';
import 'package:flutter/material.dart';
import 'experience_configs.dart';

/// Style 8: Layered Depth Parallax Header
///
/// Multi-plane parallax canvas featuring 3 distinct z-index layers
/// (background ambient, midground graphic, foreground interactive) that move
/// at differential velocities with optical focal blur simulation on collapse.
class LayeredDepthParallaxHeaderWidget extends StatelessWidget {
  /// Creates a [LayeredDepthParallaxHeaderWidget].
  const LayeredDepthParallaxHeaderWidget({
    super.key,
    required this.backgroundLayer,
    required this.midgroundLayer,
    required this.foregroundLayer,
    this.backgroundColor,
    this.config = const LayeredDepthParallaxConfig(),
    this.safeArea = true,
  });

  /// Deepest layer (moves slowly, receives optical depth blur on collapse).
  final Widget backgroundLayer;

  /// Middle layer (moves at intermediate velocity).
  final Widget midgroundLayer;

  /// Topmost layer (pinned navigation, titles, and interactive action buttons).
  final Widget foregroundLayer;

  /// Base canvas background color.
  final Color? backgroundColor;

  /// Motion and optical configuration.
  final LayeredDepthParallaxConfig config;

  /// Whether to incorporate safe area top insets.
  final bool safeArea;

  @override
  Widget build(BuildContext context) {
    final topPadding = safeArea ? MediaQuery.paddingOf(context).top : 0.0;
    final totalExpanded = config.expandedHeight + topPadding;
    final totalCollapsed = config.collapsedHeight + topPadding;

    return SliverPersistentHeader(
      pinned: true,
      delegate: _LayeredDepthParallaxDelegate(
        backgroundLayer: backgroundLayer,
        midgroundLayer: midgroundLayer,
        foregroundLayer: foregroundLayer,
        backgroundColor: backgroundColor,
        topPadding: topPadding,
        totalExpanded: totalExpanded,
        totalCollapsed: totalCollapsed,
        config: config,
      ),
    );
  }
}

class _LayeredDepthParallaxDelegate
    extends SliverPersistentHeaderDelegate {
  _LayeredDepthParallaxDelegate({
    required this.backgroundLayer,
    required this.midgroundLayer,
    required this.foregroundLayer,
    required this.backgroundColor,
    required this.topPadding,
    required this.totalExpanded,
    required this.totalCollapsed,
    required this.config,
  });

  final Widget backgroundLayer;
  final Widget midgroundLayer;
  final Widget foregroundLayer;
  final Color? backgroundColor;
  final double topPadding;
  final double totalExpanded;
  final double totalCollapsed;
  final LayeredDepthParallaxConfig config;

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
    final progress = delta > 0 ? (shrinkOffset / delta).clamp(0.0, 1.0) : 0.0;

    // Layer-specific translation offsets
    final bgOffset = isReducedMotion
        ? 0.0
        : -shrinkOffset * config.backgroundParallaxFactor;
    final midOffset = isReducedMotion
        ? 0.0
        : -shrinkOffset * config.midgroundParallaxFactor;

    // Optical depth blur on background as user focuses on foreground content
    final blurSigma = isReducedMotion ? 0.0 : progress * config.maxBlur;
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
                // Layer 1: Background ambient layer (slowest parallax, blur)
                Positioned.fill(
                  child: Transform.translate(
                    offset: Offset(0.0, bgOffset),
                    child: blurSigma > 0.1
                        ? ImageFiltered(
                            imageFilter: ImageFilter.blur(
                              sigmaX: blurSigma,
                              sigmaY: blurSigma,
                            ),
                            child: backgroundLayer,
                          )
                        : backgroundLayer,
                  ),
                ),

                // Layer 2: Midground graphic layer (intermediate parallax)
                Positioned.fill(
                  child: Transform.translate(
                    offset: Offset(0.0, midOffset),
                    child: Opacity(
                      opacity: (1.0 - progress * 0.8).clamp(0.0, 1.0),
                      child: midgroundLayer,
                    ),
                  ),
                ),

                // Layer 3: Foreground interactive toolbar (pinned)
                Positioned(
                  top: 0.0,
                  left: 0.0,
                  right: 0.0,
                  height: config.collapsedHeight,
                  child: foregroundLayer,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(covariant _LayeredDepthParallaxDelegate oldDelegate) {
    return oldDelegate.backgroundLayer != backgroundLayer ||
        oldDelegate.midgroundLayer != midgroundLayer ||
        oldDelegate.foregroundLayer != foregroundLayer ||
        oldDelegate.backgroundColor != backgroundColor ||
        oldDelegate.topPadding != topPadding ||
        oldDelegate.totalExpanded != totalExpanded ||
        oldDelegate.totalCollapsed != totalCollapsed ||
        oldDelegate.config != config;
  }
}

