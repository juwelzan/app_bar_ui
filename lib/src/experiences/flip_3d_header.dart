import 'dart:math' as math;
import 'package:flutter/material.dart';

import '../motion/perspective_transform.dart';
import '../widgets/sliver_widget_marker.dart';
import 'experience_configs.dart';

/// Style 5: 3D Flip Header
///
/// Rotates around a 3D perspective axis during scroll, transforming from an expanded
/// front-face card into a compact back-face navigation toolbar.
class Flip3DHeaderWidget extends StatelessWidget with SliverWidgetMarker {
  /// Creates a [Flip3DHeaderWidget].
  const Flip3DHeaderWidget({
    super.key,
    required this.frontCard,
    required this.backToolbar,
    this.config = const Flip3DConfig(),
    this.safeArea = true,
  });

  /// Widget displayed on the front face (expanded card).
  final Widget frontCard;

  /// Widget displayed on the back face (compact toolbar).
  final Widget backToolbar;

  /// 3D motion and perspective configuration.
  final Flip3DConfig config;

  /// Whether to pad for status bar insets.
  final bool safeArea;

  @override
  Widget build(BuildContext context) {
    final topPadding = safeArea ? MediaQuery.paddingOf(context).top : 0.0;
    final totalExpanded = config.expandedHeight + topPadding;
    final totalCollapsed = config.collapsedHeight + topPadding;

    return SliverPersistentHeader(
      pinned: true,
      delegate: _Flip3DHeaderDelegate(
        frontCard: frontCard,
        backToolbar: backToolbar,
        topPadding: topPadding,
        totalExpanded: totalExpanded,
        totalCollapsed: totalCollapsed,
        config: config,
      ),
    );
  }
}

class _Flip3DHeaderDelegate extends SliverPersistentHeaderDelegate {
  _Flip3DHeaderDelegate({
    required this.frontCard,
    required this.backToolbar,
    required this.topPadding,
    required this.totalExpanded,
    required this.totalCollapsed,
    required this.config,
  });

  final Widget frontCard;
  final Widget backToolbar;
  final double topPadding;
  final double totalExpanded;
  final double totalCollapsed;
  final Flip3DConfig config;

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

    // Rotation angle from 0.0 to math.pi (180 degrees)
    final angle = rawProgress * math.pi;
    final isFront = PerspectiveTransform3D.isFrontFaceVisible(angle);

    if (isReducedMotion) {
      // In reduced motion mode, cross-fade cleanly without 3D rotation
      return Material(
        elevation: rawProgress > 0.5 ? config.backElevation : config.frontElevation,
        color: theme.colorScheme.surface,
        child: Padding(
          padding: EdgeInsets.only(top: topPadding),
          child: SizedBox.expand(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: rawProgress > 0.5
                  ? KeyedSubtree(key: const ValueKey('back'), child: Center(child: backToolbar))
                  : KeyedSubtree(key: const ValueKey('front'), child: Center(child: frontCard)),
            ),
          ),
        ),
      );
    }

    final matrix = PerspectiveTransform3D.createRotationMatrix(
      angleRadians: angle,
      axis: config.flipAxis,
      perspective: config.perspective,
    );

    return Material(
      elevation: isFront ? config.frontElevation : config.backElevation,
      color: theme.colorScheme.surface,
      child: Padding(
        padding: EdgeInsets.only(top: topPadding),
        child: SizedBox.expand(
          child: Center(
            child: Transform(
              transform: matrix,
              alignment: Alignment.center,
              child: isFront
                  ? frontCard
                  : Transform(
                      // Counter-rotate the back face by 180 deg so content is oriented upright
                      transform: config.flipAxis == Axis.horizontal
                          ? (Matrix4.identity()..rotateX(math.pi))
                          : (Matrix4.identity()..rotateY(math.pi)),
                      alignment: Alignment.center,
                      child: backToolbar,
                    ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(covariant _Flip3DHeaderDelegate oldDelegate) {
    return oldDelegate.totalExpanded != totalExpanded ||
        oldDelegate.totalCollapsed != totalCollapsed ||
        oldDelegate.frontCard != frontCard ||
        oldDelegate.backToolbar != backToolbar ||
        oldDelegate.config != config;
  }
}
