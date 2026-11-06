import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../widgets/sliver_widget_marker.dart';
import 'liquid_wave_morph_nav_config.dart';

/// Model 19: Liquid Wave Morph Navigation Header.
///
/// Features a fluid organic sine wave boundary that deforms dynamically on scroll.
/// At rest, gentle wave crests contour the bottom perimeter. On upward scroll,
/// wave amplitude and frequency flatten elastically to snap into a crisp straight pinned toolbar.
class LiquidWaveMorphNavHeaderWidget extends StatelessWidget with SliverWidgetMarker {
  /// Creates a [LiquidWaveMorphNavHeaderWidget].
  const LiquidWaveMorphNavHeaderWidget({
    super.key,
    this.title,
    this.leading,
    this.actions,
    this.config = const LiquidWaveMorphNavConfig(),
  });

  /// Optional custom title override.
  final Widget? title;

  /// Optional custom leading widget.
  final Widget? leading;

  /// Optional trailing action widgets.
  final List<Widget>? actions;

  /// Strongly-typed configuration for this model.
  final LiquidWaveMorphNavConfig config;

  @override
  Widget build(BuildContext context) {
    final topPadding = config.safeArea ? MediaQuery.paddingOf(context).top : 0.0;
    final totalExpanded = config.expandedHeight + topPadding;
    final totalCollapsed = config.collapsedHeight + topPadding;

    return SliverPersistentHeader(
      pinned: true,
      delegate: _LiquidWaveMorphNavDelegate(
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

class _LiquidWaveMorphNavDelegate extends SliverPersistentHeaderDelegate {
  _LiquidWaveMorphNavDelegate({
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
  final LiquidWaveMorphNavConfig config;
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

    final currentHeight = (totalExpanded - shrinkOffset).clamp(totalCollapsed, totalExpanded);
    final effectiveAmplitude = isReducedMotion ? 0.0 : config.waveAmplitude * (1.0 - progress);

    final waveColor = config.waveColor ?? theme.colorScheme.primary;

    return SizedBox(
      height: currentHeight,
      child: ClipPath(
        clipper: _WaveClipper(
          amplitude: effectiveAmplitude,
          frequency: config.waveFrequency,
          progress: progress,
        ),
        child: Material(
          color: waveColor,
          elevation: overlapsContent || progress > 0.8 ? config.elevation : 0.0,
          surfaceTintColor: config.surfaceTint,
          child: SafeArea(
            top: false,
            bottom: false,
            child: Padding(
              padding: EdgeInsets.only(top: topPadding),
              child: SizedBox(
                height: currentHeight - topPadding,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    // --- EXPANDED WAVE HERO CANVAS ---
                    if (progress < 0.85)
                      Opacity(
                        opacity: isReducedMotion
                            ? (progress > 0.5 ? 0.0 : 1.0)
                            : (1.0 - progress * 1.3).clamp(0.0, 1.0),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  if (leading != null) ...[
                                    leading!,
                                    const SizedBox(width: 8.0),
                                  ],
                                  const Spacer(),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 3.0),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withValues(alpha: 0.2),
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(Icons.waves, size: 12.0, color: Colors.white),
                                        const SizedBox(width: 4.0),
                                        Text(
                                          '${(config.waveFrequency).toStringAsFixed(1)}λ Wave',
                                          style: const TextStyle(
                                            fontSize: 10.5,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  ...?actions,
                                ],
                              ),
                              const Spacer(),
                              FittedBox(
                                fit: BoxFit.scaleDown,
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  config.title,
                                  style: theme.textTheme.headlineSmall!.copyWith(
                                    fontWeight: FontWeight.w900,
                                    color: Colors.white,
                                    letterSpacing: -0.5,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 4.0),
                              FittedBox(
                                fit: BoxFit.scaleDown,
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  config.subtitle,
                                  style: theme.textTheme.bodyMedium!.copyWith(
                                    color: Colors.white70,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 24.0),
                            ],
                          ),
                        ),
                      ),

                    // --- COLLAPSED COMPACT PINNED TOOLBAR ---
                    if (progress > 0.35)
                      Positioned(
                        left: 0.0,
                        right: 0.0,
                        top: 0.0,
                        height: config.collapsedHeight,
                        child: Opacity(
                          opacity: isReducedMotion
                              ? (progress > 0.5 ? 1.0 : 0.0)
                              : ((progress - 0.35) / 0.65).clamp(0.0, 1.0),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Row(
                              children: [
                                if (leading != null) ...[
                                  leading!,
                                  const SizedBox(width: 8.0),
                                ],
                                Expanded(
                                  child: title ??
                                      Text(
                                        config.title,
                                        style: theme.textTheme.titleMedium!.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                ),
                                const SizedBox(width: 6.0),
                                IconButton(
                                  icon: const Icon(Icons.waves, size: 20.0, color: Colors.white),
                                  onPressed: () {},
                                  tooltip: 'Wave Crest Active',
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
            ),
          ),
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(covariant _LiquidWaveMorphNavDelegate oldDelegate) {
    return oldDelegate.totalExpanded != totalExpanded ||
        oldDelegate.totalCollapsed != totalCollapsed ||
        oldDelegate.config != config ||
        oldDelegate.title != title ||
        oldDelegate.actions != actions ||
        oldDelegate.leading != leading ||
        oldDelegate.topPadding != topPadding;
  }
}

class _WaveClipper extends CustomClipper<Path> {
  const _WaveClipper({
    required this.amplitude,
    required this.frequency,
    required this.progress,
  });

  final double amplitude;
  final double frequency;
  final double progress;

  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0.0, size.height - amplitude);

    if (amplitude <= 0.5) {
      path.lineTo(size.width, size.height);
      path.lineTo(size.width, 0.0);
      path.close();
      return path;
    }

    final waveLength = size.width / frequency;
    for (double x = 0; x <= size.width; x += 4.0) {
      final y = size.height - amplitude + math.sin((x / waveLength) * 2 * math.pi) * amplitude;
      path.lineTo(x, y);
    }

    path.lineTo(size.width, size.height - amplitude);
    path.lineTo(size.width, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant _WaveClipper oldClipper) {
    return oldClipper.amplitude != amplitude ||
        oldClipper.frequency != frequency ||
        oldClipper.progress != progress;
  }
}

