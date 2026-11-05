import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import '../scroll_header_style.dart';

/// Base delegate for persistent sliver headers in the presets system.
class PresetSliverHeaderDelegate extends SliverPersistentHeaderDelegate {
  /// Creates a [PresetSliverHeaderDelegate].
  PresetSliverHeaderDelegate({
    required this.builder,
    required this.expandedHeight,
    required this.collapsedHeight,
  }) : assert(
         expandedHeight >= collapsedHeight,
         'expandedHeight ($expandedHeight) must be >= collapsedHeight ($collapsedHeight).',
       );

  /// Builder receiving [context], normalized scroll [progress] (0.0 to 1.0),
  /// and [overlapsContent] boolean.
  final Widget Function(
    BuildContext context,
    double progress,
    bool overlapsContent,
  )
  builder;

  /// Maximum expanded height.
  final double expandedHeight;

  /// Minimum collapsed height.
  final double collapsedHeight;

  @override
  double get minExtent => collapsedHeight;

  @override
  double get maxExtent => math.max(expandedHeight, collapsedHeight);

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    final double extentDiff = maxExtent - minExtent;
    final double progress = extentDiff > 0
        ? (shrinkOffset / extentDiff).clamp(0.0, 1.0)
        : (shrinkOffset > 0 ? 1.0 : 0.0);

    return SizedBox.expand(child: builder(context, progress, overlapsContent));
  }

  @override
  bool shouldRebuild(covariant PresetSliverHeaderDelegate oldDelegate) {
    return oldDelegate.expandedHeight != expandedHeight ||
        oldDelegate.collapsedHeight != collapsedHeight ||
        oldDelegate.builder != builder;
  }
}

/// Helper container for headers supporting background blurring, gradients, borders, and margins.
class HeaderContainer extends StatelessWidget {
  /// Creates a [HeaderContainer].
  const HeaderContainer({
    super.key,
    required this.child,
    this.style,
    this.progress = 0.0,
    this.safeArea = true,
  });

  /// The child content of the header.
  final Widget child;

  /// Optional style configuration.
  final ScrollHeaderStyle? style;

  /// Normalized scroll progress (0.0 = initial, 1.0 = fully scrolled).
  final double progress;

  /// Whether to automatically pad for top safe insets.
  final bool safeArea;

  @override
  Widget build(BuildContext context) {
    final s = style ?? const ScrollHeaderStyle();
    final theme = Theme.of(context);
    final topPadding = safeArea ? MediaQuery.paddingOf(context).top : 0.0;

    // Background color interpolation
    final baseBg = s.backgroundColor ?? theme.colorScheme.surface;
    final scrolledBg = s.scrolledBackgroundColor ?? baseBg;
    final bgColor = Color.lerp(baseBg, scrolledBg, progress) ?? baseBg;

    // Gradient interpolation
    final gradient = progress >= 0.5 && s.scrolledGradient != null
        ? s.scrolledGradient
        : s.gradient;

    // Elevation interpolation
    final elevation =
        s.elevation + (s.scrolledElevation - s.elevation) * progress;

    Widget result = Container(
      margin: s.margin,
      decoration: BoxDecoration(
        color: gradient == null ? bgColor : null,
        gradient: gradient,
        borderRadius: s.borderRadius,
        boxShadow: elevation > 0
            ? [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04 * elevation),
                  blurRadius: elevation * 2,
                  offset: Offset(0, elevation),
                ),
              ]
            : null,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.only(top: topPadding),
            child: SizedBox(
              height: s.height,
              child: Padding(
                padding:
                    s.padding ?? const EdgeInsets.symmetric(horizontal: 16.0),
                child: child,
              ),
            ),
          ),
          if (s.showDivider && progress > 0.1)
            Opacity(
              opacity: progress.clamp(0.0, 1.0),
              child: Divider(
                height: 1.0,
                thickness: 0.5,
                color: s.dividerColor ?? theme.dividerColor,
              ),
            ),
        ],
      ),
    );

    if (s.blurBackground) {
      result = ClipRRect(
        borderRadius: s.borderRadius ?? BorderRadius.zero,
        child: BackdropFilter(
          filter: ui.ImageFilter.blur(sigmaX: s.blurSigma, sigmaY: s.blurSigma),
          child: result,
        ),
      );
    }

    return result;
  }
}
