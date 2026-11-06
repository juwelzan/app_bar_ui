import 'dart:ui' show lerpDouble;
import 'package:flutter/material.dart';
import 'experience_configs.dart';

/// Style 27: Card-to-Header Morph Header.
///
/// A floating rounded hero card inset inside page content morphs its margins,
/// corner radius, and elevation on scroll, attaching flush to the viewport top
/// edge as an edge-to-edge docked navigation bar.
class CardToHeaderMorphHeaderWidget extends StatelessWidget {
  /// Creates a [CardToHeaderMorphHeaderWidget].
  const CardToHeaderMorphHeaderWidget({
    super.key,
    required this.heroCardContent,
    required this.dockedToolbar,
    this.backgroundColor,
    this.safeArea = true,
    this.config = const CardToHeaderMorphConfig(),
  });

  /// Rich content displayed within the floating hero card.
  final Widget heroCardContent;

  /// Compact content displayed when docked at the top.
  final Widget dockedToolbar;

  /// Background color of the morphing container.
  final Color? backgroundColor;

  /// Whether to respect top SafeArea padding.
  final bool safeArea;

  /// Card to header morph configuration.
  final CardToHeaderMorphConfig config;

  @override
  Widget build(BuildContext context) {
    final topPadding = safeArea ? MediaQuery.paddingOf(context).top : 0.0;
    final totalExpanded = config.cardExpandedHeight + topPadding;
    final totalCollapsed = config.dockedHeight + topPadding;

    return SliverPersistentHeader(
      pinned: true,
      delegate: _CardToHeaderMorphDelegate(
        heroCardContent: heroCardContent,
        dockedToolbar: dockedToolbar,
        backgroundColor: backgroundColor,
        topPadding: topPadding,
        totalExpanded: totalExpanded,
        totalCollapsed: totalCollapsed,
        config: config,
      ),
    );
  }
}

class _CardToHeaderMorphDelegate extends SliverPersistentHeaderDelegate {
  _CardToHeaderMorphDelegate({
    required this.heroCardContent,
    required this.dockedToolbar,
    required this.backgroundColor,
    required this.topPadding,
    required this.totalExpanded,
    required this.totalCollapsed,
    required this.config,
  });

  final Widget heroCardContent;
  final Widget dockedToolbar;
  final Color? backgroundColor;
  final double topPadding;
  final double totalExpanded;
  final double totalCollapsed;
  final CardToHeaderMorphConfig config;

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

    final rawProgress =
        (shrinkOffset / config.morphThreshold).clamp(0.0, 1.0);
    final curve = config.resolveCurve(context);
    final progress = curve.transform(rawProgress);

    // Dynamic morphing geometry
    final currentHMargin = isReducedMotion
        ? (progress > 0.5 ? 0.0 : config.initialHorizontalMargin)
        : (lerpDouble(config.initialHorizontalMargin, 0.0, progress) ?? 0.0);

    final currentVMargin = isReducedMotion
        ? (progress > 0.5 ? 0.0 : config.initialVerticalMargin)
        : (lerpDouble(config.initialVerticalMargin, 0.0, progress) ?? 0.0);

    final currentRadius = isReducedMotion
        ? (progress > 0.5 ? 0.0 : config.initialBorderRadius)
        : (lerpDouble(config.initialBorderRadius, 0.0, progress) ?? 0.0);

    final currentElevation = isReducedMotion
        ? (progress > 0.5 ? config.dockedElevation : config.initialElevation)
        : (lerpDouble(config.initialElevation, config.dockedElevation, progress) ??
            config.dockedElevation);

    final resolvedBg =
        backgroundColor ?? theme.colorScheme.primaryContainer;

    return SizedBox.expand(
      child: Padding(
        padding: EdgeInsets.only(
          top: topPadding + currentVMargin,
          left: currentHMargin,
          right: currentHMargin,
          bottom: currentVMargin,
        ),
        child: Material(
          elevation: currentElevation,
          borderRadius: BorderRadius.circular(currentRadius),
          color: resolvedBg,
          clipBehavior: Clip.antiAlias,
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Hero card content (fades out as card docks)
              if (progress < 0.9)
                Opacity(
                  opacity: (1.0 - progress * 1.3).clamp(0.0, 1.0),
                  child: OverflowBox(
                    minHeight: 0.0,
                    maxHeight: config.cardExpandedHeight,
                    alignment: Alignment.centerLeft,
                    child: heroCardContent,
                  ),
                ),

              // Docked compact toolbar (fades in as card docks)
              if (progress > 0.25)
                Opacity(
                  opacity: ((progress - 0.25) / 0.75).clamp(0.0, 1.0),
                  child: OverflowBox(
                    minHeight: 0.0,
                    maxHeight: config.dockedHeight,
                    alignment: Alignment.center,
                    child: dockedToolbar,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(covariant _CardToHeaderMorphDelegate oldDelegate) {
    return oldDelegate.heroCardContent != heroCardContent ||
        oldDelegate.dockedToolbar != dockedToolbar ||
        oldDelegate.backgroundColor != backgroundColor ||
        oldDelegate.topPadding != topPadding ||
        oldDelegate.totalExpanded != totalExpanded ||
        oldDelegate.totalCollapsed != totalCollapsed ||
        oldDelegate.config != config;
  }
}
