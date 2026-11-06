import 'dart:math' as math;
import 'dart:ui' show lerpDouble;
import 'package:flutter/material.dart';
import 'experience_configs.dart';

/// Style 24: Sideways-Collapse Header.
///
/// Header collapses horizontally inward toward the leading anchor edge as the user
/// scrolls, morphing from a full-width expansive header into a compact pinned
/// navigation rail / badge pill.
class SidewaysCollapseHeaderWidget extends StatelessWidget {
  /// Creates a [SidewaysCollapseHeaderWidget].
  const SidewaysCollapseHeaderWidget({
    super.key,
    required this.expandedContent,
    required this.compactRailContent,
    this.backgroundColor,
    this.safeArea = true,
    this.config = const SidewaysCollapseConfig(),
  });

  /// Full-width expanded header content.
  final Widget expandedContent;

  /// Compact content displayed inside the collapsed navigation rail / pill.
  final Widget compactRailContent;

  /// Header background color.
  final Color? backgroundColor;

  /// Whether to respect top SafeArea padding.
  final bool safeArea;

  /// Sideways collapse configuration.
  final SidewaysCollapseConfig config;

  @override
  Widget build(BuildContext context) {
    final topPadding = safeArea ? MediaQuery.paddingOf(context).top : 0.0;
    final totalExpanded = config.expandedHeight + topPadding;
    final totalCollapsed = config.collapsedHeight + topPadding;

    return SliverPersistentHeader(
      pinned: true,
      delegate: _SidewaysCollapseDelegate(
        expandedContent: expandedContent,
        compactRailContent: compactRailContent,
        backgroundColor: backgroundColor,
        topPadding: topPadding,
        totalExpanded: totalExpanded,
        totalCollapsed: totalCollapsed,
        config: config,
      ),
    );
  }
}

class _SidewaysCollapseDelegate extends SliverPersistentHeaderDelegate {
  _SidewaysCollapseDelegate({
    required this.expandedContent,
    required this.compactRailContent,
    required this.backgroundColor,
    required this.topPadding,
    required this.totalExpanded,
    required this.totalCollapsed,
    required this.config,
  });

  final Widget expandedContent;
  final Widget compactRailContent;
  final Color? backgroundColor;
  final double topPadding;
  final double totalExpanded;
  final double totalCollapsed;
  final SidewaysCollapseConfig config;

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
        (shrinkOffset / config.collapseThreshold).clamp(0.0, 1.0);
    final curve = config.resolveCurve(context);
    final progress = curve.transform(rawProgress);

    final screenWidth = MediaQuery.sizeOf(context).width;
    final fullWidth =
        math.max(config.compactRailWidth, screenWidth > 32.0 ? screenWidth - 32.0 : config.compactRailWidth);
    final targetWidth = config.compactRailWidth;

    // Horizontal width interpolation
    final currentWidth = isReducedMotion
        ? (progress > 0.5 ? targetWidth : fullWidth)
        : (lerpDouble(fullWidth, targetWidth, progress) ?? fullWidth);

    // Height interpolation
    final currentHeight = isReducedMotion
        ? (progress > 0.5 ? config.collapsedHeight : config.expandedHeight)
        : (lerpDouble(config.expandedHeight, config.collapsedHeight, progress) ??
            config.expandedHeight);

    final currentRadius = isReducedMotion
        ? (progress > 0.5 ? 24.0 : 16.0)
        : (lerpDouble(16.0, 24.0, progress) ?? 16.0);

    final resolvedBg =
        backgroundColor ?? theme.colorScheme.primaryContainer;

    return SizedBox.expand(
      child: Padding(
        padding: EdgeInsets.only(top: topPadding, left: 16.0, right: 16.0, bottom: 6.0),
        child: Align(
          alignment: config.anchorAlignment,
          child: Material(
            elevation: shrinkOffset > 5.0 ? config.elevation : 1.0,
            borderRadius: BorderRadius.circular(currentRadius),
            color: resolvedBg,
            clipBehavior: Clip.antiAlias,
            child: SizedBox(
              width: currentWidth,
              height: currentHeight,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 180),
                child: progress > 0.65
                    ? Center(
                        key: const ValueKey('compact_rail'),
                        child: compactRailContent,
                      )
                    : OverflowBox(
                        key: const ValueKey('expanded_content'),
                        minWidth: 0.0,
                        maxWidth: fullWidth,
                        minHeight: 0.0,
                        maxHeight: config.expandedHeight,
                        alignment: Alignment.centerLeft,
                        child: expandedContent,
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(covariant _SidewaysCollapseDelegate oldDelegate) {
    return oldDelegate.expandedContent != expandedContent ||
        oldDelegate.compactRailContent != compactRailContent ||
        oldDelegate.backgroundColor != backgroundColor ||
        oldDelegate.topPadding != topPadding ||
        oldDelegate.totalExpanded != totalExpanded ||
        oldDelegate.totalCollapsed != totalCollapsed ||
        oldDelegate.config != config;
  }
}
