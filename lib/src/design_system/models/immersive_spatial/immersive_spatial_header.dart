import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import '../../../widgets/sliver_widget_marker.dart';
import 'immersive_spatial_config.dart';

/// Model 4: Edge-to-Edge Immersive Spatial Navigation Header.
///
/// A multi-plane 3D spatial depth header where background, midground, and
/// foreground layers move at differential parallax rates, converging smoothly
/// with focal depth blur into a flat pinned toolbar.
class ImmersiveSpatialHeaderWidget extends StatelessWidget
    with SliverWidgetMarker {
  /// Creates an [ImmersiveSpatialHeaderWidget].
  const ImmersiveSpatialHeaderWidget({
    super.key,
    this.title,
    this.leading,
    this.actions,
    this.config = const ImmersiveSpatialConfig(),
  });

  /// Optional title override.
  final Widget? title;

  /// Optional leading widget override.
  final Widget? leading;

  /// Optional trailing action widgets.
  final List<Widget>? actions;

  /// Strongly-typed configuration for this model.
  final ImmersiveSpatialConfig config;

  @override
  Widget build(BuildContext context) {
    final topPadding = config.safeArea ? MediaQuery.paddingOf(context).top : 0.0;
    final totalExpanded = config.expandedHeight + topPadding;
    final totalCollapsed = config.collapsedHeight + topPadding;

    return SliverPersistentHeader(
      pinned: true,
      delegate: _ImmersiveSpatialDelegate(
        title: title,
        leading: leading,
        actions: actions,
        config: config,
        topPadding: topPadding,
        totalExpanded: totalExpanded,
        totalCollapsed: totalCollapsed,
      ),
    );
  }
}

class _ImmersiveSpatialDelegate extends SliverPersistentHeaderDelegate {
  _ImmersiveSpatialDelegate({
    required this.title,
    required this.leading,
    required this.actions,
    required this.config,
    required this.topPadding,
    required this.totalExpanded,
    required this.totalCollapsed,
  });

  final Widget? title;
  final Widget? leading;
  final List<Widget>? actions;
  final ImmersiveSpatialConfig config;
  final double topPadding;
  final double totalExpanded;
  final double totalCollapsed;

  @override
  double get minExtent => totalCollapsed;

  @override
  double get maxExtent => totalExpanded;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    final theme = Theme.of(context);
    final isReducedMotion = MediaQuery.disableAnimationsOf(context);
    final collapseRange = totalExpanded - totalCollapsed;
    final progress = collapseRange > 0.0 ? (shrinkOffset / collapseRange).clamp(0.0, 1.0) : 0.0;

    // Differential plane translations
    final bgOffset = isReducedMotion ? 0.0 : -shrinkOffset * (1.0 - config.backgroundParallaxFactor);
    final mgOffset = isReducedMotion ? 0.0 : -shrinkOffset * (1.0 - config.midgroundParallaxFactor);
    final blurSigma = isReducedMotion ? 0.0 : progress * config.focalDepthBlur;

    return Material(
      color: config.backgroundColor ?? theme.colorScheme.surface,
      elevation: progress > 0.8 ? config.elevation : 0.0,
      surfaceTintColor: config.surfaceTint,
      child: ClipRect(
        child: Stack(
          fit: StackFit.expand,
          children: [
            // --- LAYER 1: DEEP BACKGROUND PLANE (-100 z-depth) ---
            Positioned(
              top: bgOffset,
              left: 0.0,
              right: 0.0,
              height: totalExpanded,
              child: ImageFiltered(
                imageFilter: ui.ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
                child: config.backgroundLayer ??
                    Container(
                      decoration: BoxDecoration(
                        gradient: RadialGradient(
                          center: const Alignment(0.4, -0.6),
                          radius: 1.2,
                          colors: [
                            theme.colorScheme.primary.withValues(alpha: 0.25),
                            theme.colorScheme.surfaceContainerHighest,
                          ],
                        ),
                      ),
                    ),
              ),
            ),

            // --- LAYER 2: MIDGROUND FOCAL PLANE (0 z-depth) ---
            Positioned(
              top: mgOffset + topPadding,
              left: 20.0,
              right: 20.0,
              height: config.expandedHeight,
              child: Opacity(
                opacity: isReducedMotion ? (progress > 0.5 ? 0.0 : 1.0) : (1.0 - progress * 1.3).clamp(0.0, 1.0),
                child: config.midgroundLayer ??
                    Center(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.view_in_ar_outlined,
                              size: 56.0,
                              color: theme.colorScheme.primary.withValues(alpha: 0.7),
                            ),
                            const SizedBox(height: 10.0),
                            Text(
                              config.titleText,
                              style: theme.textTheme.headlineSmall!.copyWith(
                                fontWeight: FontWeight.w800,
                                letterSpacing: -0.3,
                              ),
                            ),
                            if (config.subtitleText != null) ...[
                              const SizedBox(height: 4.0),
                              Text(
                                config.subtitleText!,
                                style: theme.textTheme.bodyMedium!.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
              ),
            ),

            // --- LAYER 3: FOREGROUND CONTROLS PLANE (+50 z-depth) ---
            Positioned(
              top: 0.0,
              left: 0.0,
              right: 0.0,
              height: totalCollapsed,
              child: Container(
                padding: EdgeInsets.only(top: topPadding),
                color: theme.colorScheme.surface.withValues(alpha: progress * 0.85),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    children: [
                      if (leading != null) ...[
                        leading!,
                        const SizedBox(width: 8.0),
                      ] else
                        const Icon(Icons.layers_outlined, size: 22.0),
                      const SizedBox(width: 10.0),
                      Expanded(
                        child: Opacity(
                          opacity: isReducedMotion ? (progress > 0.5 ? 1.0 : 0.0) : progress.clamp(0.0, 1.0),
                          child: title ??
                              Text(
                                config.titleText,
                                style: theme.textTheme.titleMedium!.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                        ),
                      ),
                      ...?actions,
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(covariant _ImmersiveSpatialDelegate oldDelegate) {
    return oldDelegate.totalExpanded != totalExpanded ||
        oldDelegate.totalCollapsed != totalCollapsed ||
        oldDelegate.config != config ||
        oldDelegate.title != title ||
        oldDelegate.leading != leading ||
        oldDelegate.actions != actions ||
        oldDelegate.topPadding != topPadding;
  }
}
