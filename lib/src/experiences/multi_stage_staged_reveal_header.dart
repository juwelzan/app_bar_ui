import 'package:flutter/material.dart';
import 'experience_configs.dart';

/// Style 14: Multi-Stage Staged Reveal Header
///
/// Header that transitions across 3 distinct architectural states
/// (Stage 1: Hero, Stage 2: Contextual Meta, Stage 3: Compact Toolbar)
/// triggered at discrete scroll offset thresholds.
class MultiStageStagedRevealHeaderWidget extends StatelessWidget {
  /// Creates a [MultiStageStagedRevealHeaderWidget].
  const MultiStageStagedRevealHeaderWidget({
    super.key,
    required this.stage1Hero,
    required this.stage2Meta,
    required this.stage3Toolbar,
    this.backgroundColor,
    this.config = const MultiStageStagedRevealConfig(),
    this.safeArea = true,
  });

  /// Widget displayed in Stage 1 ($0 \to \text{stage1EndOffset}$).
  final Widget stage1Hero;

  /// Widget displayed in Stage 2 ($\text{stage1EndOffset} \to \text{stage2EndOffset}$).
  final Widget stage2Meta;

  /// Widget displayed in Stage 3 ($> \text{stage2EndOffset}$).
  final Widget stage3Toolbar;

  /// Background color of the header.
  final Color? backgroundColor;

  /// Multi-stage threshold configuration.
  final MultiStageStagedRevealConfig config;

  /// Whether to incorporate safe area top insets.
  final bool safeArea;

  @override
  Widget build(BuildContext context) {
    final topPadding = safeArea ? MediaQuery.paddingOf(context).top : 0.0;
    final totalExpanded = config.expandedHeight + topPadding;
    final totalCollapsed = config.collapsedHeight + topPadding;

    return SliverPersistentHeader(
      pinned: true,
      delegate: _MultiStageStagedRevealDelegate(
        stage1Hero: stage1Hero,
        stage2Meta: stage2Meta,
        stage3Toolbar: stage3Toolbar,
        backgroundColor: backgroundColor,
        topPadding: topPadding,
        totalExpanded: totalExpanded,
        totalCollapsed: totalCollapsed,
        config: config,
      ),
    );
  }
}

class _MultiStageStagedRevealDelegate
    extends SliverPersistentHeaderDelegate {
  _MultiStageStagedRevealDelegate({
    required this.stage1Hero,
    required this.stage2Meta,
    required this.stage3Toolbar,
    required this.backgroundColor,
    required this.topPadding,
    required this.totalExpanded,
    required this.totalCollapsed,
    required this.config,
  });

  final Widget stage1Hero;
  final Widget stage2Meta;
  final Widget stage3Toolbar;
  final Color? backgroundColor;
  final double topPadding;
  final double totalExpanded;
  final double totalCollapsed;
  final MultiStageStagedRevealConfig config;

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

    // Compute active stage factors:
    // Stage 1 opacity: active from 0.0 -> stage1EndOffset
    final s1Opacity = (1.0 - (shrinkOffset / config.stage1EndOffset)).clamp(0.0, 1.0);

    // Stage 2 opacity: ramps in from stage1EndOffset * 0.7 to stage1EndOffset, then ramps out towards stage2EndOffset
    final s2In = ((shrinkOffset - config.stage1EndOffset * 0.5) /
            (config.stage1EndOffset * 0.5))
        .clamp(0.0, 1.0);
    final s2Out = (1.0 -
            ((shrinkOffset - config.stage1EndOffset) /
                (config.stage2EndOffset - config.stage1EndOffset)))
        .clamp(0.0, 1.0);
    final s2Opacity = (s2In * s2Out).clamp(0.0, 1.0);

    // Stage 3 opacity: ramps in as shrinkOffset approaches and exceeds stage2EndOffset
    final s3Opacity = ((shrinkOffset - config.stage1EndOffset) /
            (config.stage2EndOffset - config.stage1EndOffset))
        .clamp(0.0, 1.0);

    final resolvedBgColor = backgroundColor ?? theme.colorScheme.surface;

    return SizedBox.expand(
      child: Material(
        elevation: shrinkOffset > config.stage1EndOffset ? config.elevation : 0.0,
        color: resolvedBgColor,
        child: ClipRect(
          child: Padding(
            padding: EdgeInsets.only(top: topPadding),
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Stage 1: Hero representation
                if (s1Opacity > 0.01)
                  Positioned.fill(
                    child: Opacity(
                      opacity: s1Opacity,
                      child: OverflowBox(
                        minHeight: 0.0,
                        maxHeight: config.expandedHeight,
                        alignment: Alignment.center,
                        child: stage1Hero,
                      ),
                    ),
                  ),

                // Stage 2: Contextual Meta / Category Chips
                if (s2Opacity > 0.01)
                  Positioned.fill(
                    child: Opacity(
                      opacity: s2Opacity,
                      child: OverflowBox(
                        minHeight: 0.0,
                        maxHeight: config.expandedHeight,
                        alignment: Alignment.center,
                        child: stage2Meta,
                      ),
                    ),
                  ),

                // Stage 3: Compact Pinned Toolbar
                if (s3Opacity > 0.01)
                  Positioned(
                    top: 0.0,
                    left: 0.0,
                    right: 0.0,
                    height: config.collapsedHeight,
                    child: Opacity(
                      opacity: s3Opacity,
                      child: stage3Toolbar,
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
  bool shouldRebuild(
    covariant _MultiStageStagedRevealDelegate oldDelegate,
  ) {
    return oldDelegate.stage1Hero != stage1Hero ||
        oldDelegate.stage2Meta != stage2Meta ||
        oldDelegate.stage3Toolbar != stage3Toolbar ||
        oldDelegate.backgroundColor != backgroundColor ||
        oldDelegate.topPadding != topPadding ||
        oldDelegate.totalExpanded != totalExpanded ||
        oldDelegate.totalCollapsed != totalCollapsed ||
        oldDelegate.config != config;
  }
}

