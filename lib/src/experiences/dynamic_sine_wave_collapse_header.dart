import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'experience_configs.dart';

/// Style 35: Dynamic Sine Wave Collapse Header.
///
/// Features an oscillatory mathematical sine wave bottom boundary. As the user
/// scrolls, the wave's amplitude dynamically dampens and ripples in phase,
/// converging continuously into a perfectly flat docked navigation toolbar at
/// minimum extent.
class DynamicSineWaveCollapseHeaderWidget extends StatelessWidget {
  /// Creates a [DynamicSineWaveCollapseHeaderWidget].
  const DynamicSineWaveCollapseHeaderWidget({
    super.key,
    required this.title,
    this.subtitle,
    this.expandedHero,
    this.leading,
    this.actions,
    this.gradientColors,
    this.safeArea = true,
    this.config = const DynamicSineWaveCollapseConfig(),
  });

  /// Main title widget.
  final Widget title;

  /// Optional subtitle widget.
  final Widget? subtitle;

  /// Optional expanded hero graphic or content displayed in the upper body.
  final Widget? expandedHero;

  /// Optional leading navigation widget.
  final Widget? leading;

  /// Optional trailing action widgets.
  final List<Widget>? actions;

  /// Gradient colors for the wave canvas.
  final List<Color>? gradientColors;

  /// Whether to respect top SafeArea.
  final bool safeArea;

  /// Wave collapse configuration.
  final DynamicSineWaveCollapseConfig config;

  @override
  Widget build(BuildContext context) {
    final topPadding = safeArea ? MediaQuery.paddingOf(context).top : 0.0;
    final totalExpanded = config.expandedHeight + topPadding;
    final totalCollapsed = config.collapsedHeight + topPadding;

    return SliverPersistentHeader(
      pinned: true,
      delegate: _DynamicSineWaveCollapseDelegate(
        title: title,
        subtitle: subtitle,
        expandedHero: expandedHero,
        leading: leading,
        actions: actions,
        gradientColors: gradientColors,
        topPadding: topPadding,
        totalExpanded: math.max(totalExpanded, totalCollapsed + 1.0),
        totalCollapsed: totalCollapsed,
        config: config,
      ),
    );
  }
}

class _DynamicSineWaveCollapseDelegate extends SliverPersistentHeaderDelegate {
  _DynamicSineWaveCollapseDelegate({
    required this.title,
    required this.subtitle,
    required this.expandedHero,
    required this.leading,
    required this.actions,
    required this.gradientColors,
    required this.topPadding,
    required this.totalExpanded,
    required this.totalCollapsed,
    required this.config,
  });

  final Widget title;
  final Widget? subtitle;
  final Widget? expandedHero;
  final Widget? leading;
  final List<Widget>? actions;
  final List<Color>? gradientColors;
  final double topPadding;
  final double totalExpanded;
  final double totalCollapsed;
  final DynamicSineWaveCollapseConfig config;

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

    // Dynamic wave metrics
    final currentAmplitude = reducedMotion
        ? 0.0
        : (config.waveAmplitude * (1.0 - curvedProgress)).clamp(0.0, config.waveAmplitude);
    final phase = (!reducedMotion && config.enableDynamicPhase)
        ? curvedProgress * math.pi * 2
        : 0.0;

    final defaultColors = [
      theme.colorScheme.primary,
      theme.colorScheme.tertiary,
    ];
    final activeGradient = gradientColors ?? defaultColors;

    // Title positioning
    final isCollapsed = curvedProgress > 0.65;
    final titleLeft = leading != null ? 64.0 : 20.0;
    final titleTop = isCollapsed
        ? topPadding + (totalCollapsed - topPadding - 24.0) / 2.0
        : topPadding + 16.0;

    return Material(
      color: Colors.transparent,
      elevation: 2.0 * curvedProgress,
      child: ClipPath(
        clipper: _SineWaveBottomClipper(
          amplitude: currentAmplitude,
          frequency: config.waveFrequency,
          phase: phase,
        ),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: activeGradient,
            ),
          ),
          child: OverflowBox(
            minWidth: 0.0,
            maxWidth: safeWidth,
            minHeight: 0.0,
            maxHeight: totalExpanded,
            alignment: Alignment.topLeft,
            child: Stack(
              fit: StackFit.expand,
              children: [
                // 1. Expanded Hero Graphic / Metrics in the middle
                if (expandedHero != null && curvedProgress < 0.6)
                  Positioned(
                    left: 20.0,
                    right: 20.0,
                    top: topPadding + 52.0,
                    bottom: config.waveAmplitude + 12.0,
                    child: Opacity(
                      opacity: (1.0 - (curvedProgress / 0.6)).clamp(0.0, 1.0),
                      child: Center(child: expandedHero!),
                    ),
                  ),

                // 2. Navigation bar: Leading
                if (leading != null)
                  Positioned(
                    left: 8.0,
                    top: topPadding + (totalCollapsed - topPadding - 48.0) / 2.0,
                    child: SizedBox(
                      width: 48.0,
                      height: 48.0,
                      child: Center(
                        child: IconTheme(
                          data: const IconThemeData(color: Colors.white),
                          child: leading!,
                        ),
                      ),
                    ),
                  ),

                // 3. Navigation bar: Title & Subtitle
                Positioned(
                  left: titleLeft,
                  top: titleTop,
                  right: actions != null ? (actions!.length * 48.0 + 16.0) : 16.0,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DefaultTextStyle(
                        style: (isCollapsed
                                ? theme.textTheme.titleMedium!
                                : theme.textTheme.headlineSmall!)
                            .copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        child: title,
                      ),
                      if (subtitle != null && !isCollapsed) ...[
                        const SizedBox(height: 2.0),
                        Opacity(
                          opacity: (1.0 - (curvedProgress / 0.5)).clamp(0.0, 1.0),
                          child: DefaultTextStyle(
                            style: theme.textTheme.bodySmall!.copyWith(
                              color: Colors.white70,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            child: subtitle!,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),

                // 4. Actions
                if (actions != null && actions!.isNotEmpty)
                  Positioned(
                    right: 8.0,
                    top: topPadding + (totalCollapsed - topPadding - 48.0) / 2.0,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: actions!.map((act) {
                        return IconTheme(
                          data: const IconThemeData(color: Colors.white),
                          child: act,
                        );
                      }).toList(),
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
  bool shouldRebuild(covariant _DynamicSineWaveCollapseDelegate oldDelegate) {
    return title != oldDelegate.title ||
        subtitle != oldDelegate.subtitle ||
        expandedHero != oldDelegate.expandedHero ||
        leading != oldDelegate.leading ||
        actions != oldDelegate.actions ||
        gradientColors != oldDelegate.gradientColors ||
        topPadding != oldDelegate.topPadding ||
        totalExpanded != oldDelegate.totalExpanded ||
        totalCollapsed != oldDelegate.totalCollapsed ||
        config != oldDelegate.config;
  }
}

/// Custom clipper that cuts a periodic sine wave along the bottom edge of the container.
class _SineWaveBottomClipper extends CustomClipper<Path> {
  const _SineWaveBottomClipper({
    required this.amplitude,
    required this.frequency,
    required this.phase,
  });

  final double amplitude;
  final double frequency;
  final double phase;

  @override
  Path getClip(Size size) {
    final path = Path();
    if (amplitude <= 0.05) {
      path.addRect(Rect.fromLTWH(0, 0, size.width, size.height));
      return path;
    }

    final waveBaseY = size.height - amplitude;
    path.lineTo(0.0, waveBaseY);

    final step = math.max(2.0, size.width / 120.0);
    for (double x = 0; x <= size.width; x += step) {
      final y = waveBaseY +
          amplitude * math.sin((x / size.width) * 2 * math.pi * frequency + phase);
      path.lineTo(x, y);
    }
    path.lineTo(size.width, waveBaseY);
    path.lineTo(size.width, 0.0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(covariant _SineWaveBottomClipper oldClipper) {
    return amplitude != oldClipper.amplitude ||
        frequency != oldClipper.frequency ||
        phase != oldClipper.phase;
  }
}

