import 'package:flutter/material.dart';
import '../motion/path_deformation_driver.dart';
import 'experience_configs.dart';

/// Style 10: Liquid Wave Morph Header
///
/// Header with an organic, mathematical liquid wave bottom boundary that
/// ripples dynamically with scroll movement and flattens into a straight docked edge.
class LiquidWaveMorphHeaderWidget extends StatelessWidget {
  /// Creates a [LiquidWaveMorphHeaderWidget].
  const LiquidWaveMorphHeaderWidget({
    super.key,
    required this.child,
    this.compactTitle,
    this.backgroundColor,
    this.config = const LiquidWaveMorphConfig(),
    this.safeArea = true,
  });

  /// Main content displayed within the liquid canvas.
  final Widget child;

  /// Optional compact title displayed when wave flattens into compact toolbar.
  final Widget? compactTitle;

  /// Background color of the liquid wave container.
  final Color? backgroundColor;

  /// Wave geometry and fluid motion configuration.
  final LiquidWaveMorphConfig config;

  /// Whether to incorporate safe area top insets.
  final bool safeArea;

  @override
  Widget build(BuildContext context) {
    final topPadding = safeArea ? MediaQuery.paddingOf(context).top : 0.0;
    final totalExpanded = config.expandedHeight + topPadding;
    final totalCollapsed = config.collapsedHeight + topPadding;

    return SliverPersistentHeader(
      pinned: true,
      delegate: _LiquidWaveMorphDelegate(
        child: child,
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

class _LiquidWaveMorphDelegate extends SliverPersistentHeaderDelegate {
  _LiquidWaveMorphDelegate({
    required this.child,
    required this.compactTitle,
    required this.backgroundColor,
    required this.topPadding,
    required this.totalExpanded,
    required this.totalCollapsed,
    required this.config,
  });

  final Widget child;
  final Widget? compactTitle;
  final Color? backgroundColor;
  final double topPadding;
  final double totalExpanded;
  final double totalCollapsed;
  final LiquidWaveMorphConfig config;

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

    // Compute flattening progress (0.0 = full wave, 1.0 = completely flat)
    final flattenProgress =
        (shrinkOffset / config.flattenOffset).clamp(0.0, 1.0);
    final curve = config.resolveCurve(context);
    final tFlatten = curve.transform(flattenProgress);

    // Dynamic phase shift creates fluid ripple movement on scroll
    final phase = isReducedMotion ? 0.0 : shrinkOffset * config.waveSpeed;
    final currentAmplitude = isReducedMotion ? 0.0 : config.waveAmplitude;

    final bgColor = backgroundColor ?? theme.colorScheme.primary;
    final delta = maxExtent - minExtent;
    final totalProgress =
        delta > 0 ? (shrinkOffset / delta).clamp(0.0, 1.0) : 0.0;

    return SizedBox.expand(
      child: ClipPath(
        clipper: LiquidWaveClipper(
          amplitude: currentAmplitude,
          frequency: config.waveFrequency,
          phase: phase,
          flattenProgress: tFlatten,
        ),
        child: Material(
          elevation: config.elevation,
          color: bgColor,
          child: Padding(
            padding: EdgeInsets.only(top: topPadding),
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Expanded primary child
                Opacity(
                  opacity: (1.0 - (totalProgress * 1.4)).clamp(0.0, 1.0),
                  child: child,
                ),

                // Compact title visible when flattened into toolbar
                if (compactTitle != null && totalProgress > 0.4)
                  Positioned(
                    top: 0.0,
                    left: 0.0,
                    right: 0.0,
                    height: config.collapsedHeight,
                    child: Center(
                      child: Opacity(
                        opacity: ((totalProgress - 0.4) / 0.6).clamp(0.0, 1.0),
                        child: compactTitle!,
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
  bool shouldRebuild(covariant _LiquidWaveMorphDelegate oldDelegate) {
    return oldDelegate.child != child ||
        oldDelegate.compactTitle != compactTitle ||
        oldDelegate.backgroundColor != backgroundColor ||
        oldDelegate.topPadding != topPadding ||
        oldDelegate.totalExpanded != totalExpanded ||
        oldDelegate.totalCollapsed != totalCollapsed ||
        oldDelegate.config != config;
  }
}

