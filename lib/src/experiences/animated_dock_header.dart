import 'package:flutter/material.dart';
import 'experience_configs.dart';

/// Style 15: Animated Dock Header
///
/// Top header that smoothly dissolves and transforms into a floating bottom
/// navigation dock as the user scrolls deep into page content.
class AnimatedDockHeaderWidget extends StatelessWidget {
  /// Creates an [AnimatedDockHeaderWidget].
  const AnimatedDockHeaderWidget({
    super.key,
    required this.topHeaderContent,
    this.backgroundColor,
    this.config = const AnimatedDockConfig(),
    this.safeArea = true,
  });

  /// The presentation content displayed in the initial top header state.
  final Widget topHeaderContent;

  /// Background color of the top header.
  final Color? backgroundColor;

  /// Dock transition configuration.
  final AnimatedDockConfig config;

  /// Whether to incorporate safe area top insets.
  final bool safeArea;

  @override
  Widget build(BuildContext context) {
    final topPadding = safeArea ? MediaQuery.paddingOf(context).top : 0.0;
    final totalExpanded = config.topHeaderHeight + topPadding;

    return SliverPersistentHeader(
      pinned: false,
      delegate: _AnimatedDockDelegate(
        topHeaderContent: topHeaderContent,
        backgroundColor: backgroundColor,
        topPadding: topPadding,
        totalExpanded: totalExpanded,
        config: config,
      ),
    );
  }
}

class _AnimatedDockDelegate extends SliverPersistentHeaderDelegate {
  _AnimatedDockDelegate({
    required this.topHeaderContent,
    required this.backgroundColor,
    required this.topPadding,
    required this.totalExpanded,
    required this.config,
  });

  final Widget topHeaderContent;
  final Color? backgroundColor;
  final double topPadding;
  final double totalExpanded;
  final AnimatedDockConfig config;

  @override
  double get minExtent => 0.0;

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

    // Compute top header fade out
    final fadeOutRatio =
        (shrinkOffset / config.dockTriggerOffset).clamp(0.0, 1.0);
    final curve = config.resolveCurve(context);
    final t = curve.transform(fadeOutRatio);

    final resolvedBgColor = backgroundColor ?? theme.colorScheme.surface;
    final headerOffset = isReducedMotion ? 0.0 : -shrinkOffset * 0.5;

    return SizedBox.expand(
      child: Material(
        color: resolvedBgColor,
        child: ClipRect(
          child: Padding(
            padding: EdgeInsets.only(top: topPadding),
            child: Opacity(
              opacity: (1.0 - t).clamp(0.0, 1.0),
              child: Transform.translate(
                offset: Offset(0.0, headerOffset),
                child: topHeaderContent,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(covariant _AnimatedDockDelegate oldDelegate) {
    return oldDelegate.topHeaderContent != topHeaderContent ||
        oldDelegate.backgroundColor != backgroundColor ||
        oldDelegate.topPadding != topPadding ||
        oldDelegate.totalExpanded != totalExpanded ||
        oldDelegate.config != config;
  }
}

/// Floating bottom dock capsule widget paired with [AnimatedDockHeaderWidget].
class FloatingBottomDockCapsule extends StatelessWidget {
  /// Creates a [FloatingBottomDockCapsule].
  const FloatingBottomDockCapsule({
    super.key,
    required this.scrollOffset,
    required this.child,
    this.backgroundColor,
    this.config = const AnimatedDockConfig(),
  });

  /// Live scroll offset driving dock emergence.
  final double scrollOffset;

  /// Dock items / actions.
  final Widget child;

  /// Dock capsule background color.
  final Color? backgroundColor;

  /// Dock configuration.
  final AnimatedDockConfig config;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isReducedMotion = MediaQuery.disableAnimationsOf(context);

    // Dock emerges when scroll offset exceeds trigger offset
    final emergeProgress = ((scrollOffset - (config.dockTriggerOffset * 0.7)) /
            (config.dockTriggerOffset * 0.5))
        .clamp(0.0, 1.0);

    if (emergeProgress <= 0.001) {
      return const SizedBox.shrink();
    }

    final curve = config.resolveCurve(context);
    final t = curve.transform(emergeProgress);
    final verticalDisplacement = isReducedMotion ? 0.0 : (1.0 - t) * 60.0;
    final resolvedBgColor = backgroundColor ?? theme.colorScheme.primaryContainer;

    return Positioned(
      left: config.dockHorizontalMargin,
      right: config.dockHorizontalMargin,
      bottom: config.dockBottomMargin,
      child: Transform.translate(
        offset: Offset(0.0, verticalDisplacement),
        child: Opacity(
          opacity: t.clamp(0.0, 1.0),
          child: Material(
            elevation: config.dockElevation,
            borderRadius: BorderRadius.circular(config.dockBorderRadius),
            color: resolvedBgColor,
            child: SizedBox(
              height: config.bottomDockHeight,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: child,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

