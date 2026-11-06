import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'experience_configs.dart';

/// Style 38: Dual-Mode 3D Crossfade Header.
///
/// Features two completely distinct widget interfaces (e.g. an expansive rich media
/// player canvas vs. a compact pinned navigation toolbar). As the user scrolls,
/// the header performs a true 3D perspective flip, rotating the expanded mode
/// away and revolving the compact navigation mode into active view.
class DualMode3DCrossfadeHeaderWidget extends StatelessWidget {
  /// Creates a [DualMode3DCrossfadeHeaderWidget].
  const DualMode3DCrossfadeHeaderWidget({
    super.key,
    required this.primaryMode,
    required this.secondaryMode,
    this.backgroundColor,
    this.safeArea = true,
    this.config = const DualMode3DCrossfadeConfig(),
  });

  /// The primary rich expanded mode widget tree.
  final Widget primaryMode;

  /// The secondary compact docked mode widget tree.
  final Widget secondaryMode;

  /// Header background color.
  final Color? backgroundColor;

  /// Whether to respect top SafeArea.
  final bool safeArea;

  /// 3D flip rotation configuration.
  final DualMode3DCrossfadeConfig config;

  @override
  Widget build(BuildContext context) {
    final topPadding = safeArea ? MediaQuery.paddingOf(context).top : 0.0;
    final totalExpanded = config.expandedHeight + topPadding;
    final totalCollapsed = config.collapsedHeight + topPadding;

    return SliverPersistentHeader(
      pinned: true,
      delegate: _DualMode3DCrossfadeDelegate(
        primaryMode: primaryMode,
        secondaryMode: secondaryMode,
        backgroundColor: backgroundColor ?? Theme.of(context).colorScheme.surface,
        topPadding: topPadding,
        totalExpanded: math.max(totalExpanded, totalCollapsed + 1.0),
        totalCollapsed: totalCollapsed,
        config: config,
      ),
    );
  }
}

class _DualMode3DCrossfadeDelegate extends SliverPersistentHeaderDelegate {
  _DualMode3DCrossfadeDelegate({
    required this.primaryMode,
    required this.secondaryMode,
    required this.backgroundColor,
    required this.topPadding,
    required this.totalExpanded,
    required this.totalCollapsed,
    required this.config,
  });

  final Widget primaryMode;
  final Widget secondaryMode;
  final Color backgroundColor;
  final double topPadding;
  final double totalExpanded;
  final double totalCollapsed;
  final DualMode3DCrossfadeConfig config;

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

    // 3D Angle: 0 to pi (180 degrees)
    final rotationAngle = curvedProgress * math.pi;
    final isSecondaryFacing = rotationAngle > (math.pi / 2.0);

    // 3D Transform Matrix with true optical perspective
    final transform = Matrix4.identity()
      ..setEntry(3, 2, config.perspective)
      ..rotateX(rotationAngle);

    return Material(
      elevation: isSecondaryFacing ? 3.0 : 1.0,
      color: backgroundColor,
      child: ClipRect(
        child: OverflowBox(
          minWidth: 0.0,
          maxWidth: safeWidth,
          minHeight: 0.0,
          maxHeight: totalExpanded,
          alignment: Alignment.topLeft,
          child: SizedBox(
            width: safeWidth,
            height: totalExpanded,
            child: reducedMotion
                ? (isSecondaryFacing
                    ? SizedBox(
                        height: totalCollapsed,
                        child: Padding(
                          padding: EdgeInsets.only(top: topPadding),
                          child: secondaryMode,
                        ),
                      )
                    : Padding(
                        padding: EdgeInsets.only(top: topPadding),
                        child: primaryMode,
                      ))
                : Transform(
                    alignment: Alignment.center,
                    transform: transform,
                    child: isSecondaryFacing
                        ? Transform(
                            alignment: Alignment.center,
                            transform: Matrix4.identity()..rotateX(math.pi),
                            child: SizedBox(
                              height: totalCollapsed,
                              child: Padding(
                                padding: EdgeInsets.only(top: topPadding),
                                child: secondaryMode,
                              ),
                            ),
                          )
                        : Padding(
                            padding: EdgeInsets.only(top: topPadding),
                            child: primaryMode,
                          ),
                  ),
          ),
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(covariant _DualMode3DCrossfadeDelegate oldDelegate) {
    return primaryMode != oldDelegate.primaryMode ||
        secondaryMode != oldDelegate.secondaryMode ||
        backgroundColor != oldDelegate.backgroundColor ||
        topPadding != oldDelegate.topPadding ||
        totalExpanded != oldDelegate.totalExpanded ||
        totalCollapsed != oldDelegate.totalCollapsed ||
        config != oldDelegate.config;
  }
}
