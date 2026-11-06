import 'dart:math' as math;
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'experience_configs.dart';

/// Style 34: Divergent Vector Parallax Zoom Header.
///
/// Combines optical background magnification with divergent multi-vector foreground
/// kinetics. As the user scrolls, the background zooms outward along the z-axis,
/// while primary typography and metadata diverge diagonally along opposing vectors,
/// converging cleanly into a crisp pinned toolbar at minimum extent.
class DivergentVectorParallaxZoomHeaderWidget extends StatelessWidget {
  /// Creates a [DivergentVectorParallaxZoomHeaderWidget].
  const DivergentVectorParallaxZoomHeaderWidget({
    super.key,
    required this.backgroundImage,
    required this.title,
    this.subtitle,
    this.categoryTag,
    this.leading,
    this.actions,
    this.safeArea = true,
    this.config = const DivergentVectorParallaxZoomConfig(),
  });

  /// Background hero media or graphic that zooms outward.
  final Widget backgroundImage;

  /// Main title widget that travels diagonally up-right before docking.
  final Widget title;

  /// Optional subtitle widget that travels diagonally down-left.
  final Widget? subtitle;

  /// Optional category or pill badge.
  final Widget? categoryTag;

  /// Optional leading navigation button.
  final Widget? leading;

  /// Optional trailing action buttons.
  final List<Widget>? actions;

  /// Whether to respect top SafeArea.
  final bool safeArea;

  /// Parallax zoom and divergence configuration.
  final DivergentVectorParallaxZoomConfig config;

  @override
  Widget build(BuildContext context) {
    final topPadding = safeArea ? MediaQuery.paddingOf(context).top : 0.0;
    final totalExpanded = config.expandedHeight + topPadding;
    final totalCollapsed = config.collapsedHeight + topPadding;

    return SliverPersistentHeader(
      pinned: true,
      delegate: _DivergentVectorParallaxZoomDelegate(
        backgroundImage: backgroundImage,
        title: title,
        subtitle: subtitle,
        categoryTag: categoryTag,
        leading: leading,
        actions: actions,
        topPadding: topPadding,
        totalExpanded: math.max(totalExpanded, totalCollapsed + 1.0),
        totalCollapsed: totalCollapsed,
        config: config,
      ),
    );
  }
}

class _DivergentVectorParallaxZoomDelegate extends SliverPersistentHeaderDelegate {
  _DivergentVectorParallaxZoomDelegate({
    required this.backgroundImage,
    required this.title,
    required this.subtitle,
    required this.categoryTag,
    required this.leading,
    required this.actions,
    required this.topPadding,
    required this.totalExpanded,
    required this.totalCollapsed,
    required this.config,
  });

  final Widget backgroundImage;
  final Widget title;
  final Widget? subtitle;
  final Widget? categoryTag;
  final Widget? leading;
  final List<Widget>? actions;
  final double topPadding;
  final double totalExpanded;
  final double totalCollapsed;
  final DivergentVectorParallaxZoomConfig config;

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

    // 1. Background Zoom & Optical Scrim
    // When scroll begins, background zooms from 1.0 to zoomScaleFactor
    final backgroundScale = reducedMotion
        ? 1.0
        : (1.0 + (config.zoomScaleFactor - 1.0) * curvedProgress);

    // Focal blur calculation
    final blurSigma = (!reducedMotion && config.enableFocalBlur)
        ? config.maxBlurSigma * curvedProgress
        : 0.0;

    // 2. Divergent Vector Calculations
    // Expanded Title Position: centered or lower-left
    final expandedTitleLeft = 24.0;
    final expandedTitleTop = topPadding + (totalExpanded - topPadding) * 0.55;

    // Collapsed Title Position: pinned beside leading
    final collapsedTitleLeft = leading != null ? 68.0 : 20.0;
    final collapsedTitleTop = topPadding + (totalCollapsed - topPadding - 24.0) / 2.0;

    // Title vector shifts diagonally (+dx, -dy) during mid-scroll before snapping into docked slot
    final midProgress = (math.sin(curvedProgress * math.pi)).clamp(0.0, 1.0);
    final titleDivergeX = reducedMotion ? 0.0 : (config.divergenceDistance * midProgress);
    final titleDivergeY = reducedMotion ? 0.0 : (-config.divergenceDistance * 0.5 * midProgress);

    final titleLeft = expandedTitleLeft + (collapsedTitleLeft - expandedTitleLeft) * curvedProgress + titleDivergeX;
    final titleTop = expandedTitleTop + (collapsedTitleTop - expandedTitleTop) * curvedProgress + titleDivergeY;

    // Subtitle vector shifts diagonally opposite (-dx, +dy) and fades out
    final subDivergeX = reducedMotion ? 0.0 : (-config.divergenceDistance * 1.2 * curvedProgress);
    final subDivergeY = reducedMotion ? 0.0 : (config.divergenceDistance * 0.6 * curvedProgress);
    final subOpacity = (1.0 - (curvedProgress / 0.6)).clamp(0.0, 1.0);

    return Material(
      color: theme.colorScheme.surface,
      elevation: 3.0 * curvedProgress,
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
              // 1. Zooming Background
              Transform.scale(
                scale: backgroundScale,
                child: SizedBox(
                  width: safeWidth,
                  height: totalExpanded,
                  child: backgroundImage,
                ),
              ),

              // Optical Focal Blur Filter
              if (blurSigma > 0.1)
                BackdropFilter(
                  filter: ui.ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
                  child: Container(color: Colors.transparent),
                ),

              // Scrim overlay darkening as it collapses into toolbar
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.3 + 0.5 * curvedProgress),
                      Colors.black.withValues(alpha: 0.1 + 0.6 * curvedProgress),
                    ],
                  ),
                ),
              ),

              // 2. Subtitle / Badge with Opposing Vector Motion
              if (subtitle != null || categoryTag != null)
                Positioned(
                  left: 24.0 + subDivergeX,
                  top: expandedTitleTop + 36.0 + subDivergeY,
                  child: Opacity(
                    opacity: subOpacity,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (categoryTag != null) ...[
                          categoryTag!,
                          const SizedBox(width: 8.0),
                        ],
                        if (subtitle != null)
                          DefaultTextStyle(
                            style: theme.textTheme.bodyMedium!.copyWith(
                              color: Colors.white70,
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            child: subtitle!,
                          ),
                      ],
                    ),
                  ),
                ),

              // 3. Primary Title with Divergent Trajectory
              Positioned(
                left: titleLeft,
                top: titleTop,
                right: actions != null ? (actions!.length * 48.0 + 16.0) : 16.0,
                child: DefaultTextStyle(
                  style: (curvedProgress > 0.6
                          ? theme.textTheme.titleMedium!
                          : theme.textTheme.headlineSmall!)
                      .copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    shadows: const [
                      Shadow(
                        color: Colors.black54,
                        blurRadius: 4.0,
                        offset: Offset(0.0, 1.0),
                      ),
                    ],
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  child: title,
                ),
              ),

              // 4. Leading navigation control
              if (leading != null)
                Positioned(
                  left: 8.0,
                  top: topPadding + 4.0,
                  child: SizedBox(
                    width: 48.0,
                    height: 48.0,
                    child: Center(child: leading!),
                  ),
                ),

              // 5. Actions row
              if (actions != null && actions!.isNotEmpty)
                Positioned(
                  right: 8.0,
                  top: topPadding + 4.0,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: actions!,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(covariant _DivergentVectorParallaxZoomDelegate oldDelegate) {
    return backgroundImage != oldDelegate.backgroundImage ||
        title != oldDelegate.title ||
        subtitle != oldDelegate.subtitle ||
        categoryTag != oldDelegate.categoryTag ||
        leading != oldDelegate.leading ||
        actions != oldDelegate.actions ||
        topPadding != oldDelegate.topPadding ||
        totalExpanded != oldDelegate.totalExpanded ||
        totalCollapsed != oldDelegate.totalCollapsed ||
        config != oldDelegate.config;
  }
}

