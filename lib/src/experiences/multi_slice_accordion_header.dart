import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'experience_configs.dart';

/// Data model representing a custom accordion slice in [MultiSliceAccordionHeaderWidget].
class AccordionSliceItem {
  /// Creates an [AccordionSliceItem].
  const AccordionSliceItem({
    required this.spec,
    required this.builder,
    this.backgroundColor,
  });

  /// Collapse specification and height constraints.
  final AccordionSliceSpec spec;

  /// Builder for the contents of this slice.
  /// Receives [collapseFactor] (0.0 = fully open, 1.0 = completely closed).
  final Widget Function(BuildContext context, double collapseFactor) builder;

  /// Optional background tint.
  final Color? backgroundColor;
}

/// Style 32: Accordion Multi-Tier Header.
///
/// Features multiple independent horizontal slices beneath a pinned navigation bar.
/// Each slice expands and collapses according to its own distinct scroll band,
/// folding away with an accordion shutter motion without disturbing neighboring tiers.
class MultiSliceAccordionHeaderWidget extends StatelessWidget {
  /// Creates a [MultiSliceAccordionHeaderWidget].
  const MultiSliceAccordionHeaderWidget({
    super.key,
    required this.pinnedBar,
    required this.slices,
    this.backgroundColor,
    this.safeArea = true,
    this.config = const MultiSliceAccordionConfig(),
  });

  /// Top navigation bar permanently pinned into view.
  final Widget pinnedBar;

  /// Ordered accordion slice items positioned below the pinned bar.
  final List<AccordionSliceItem> slices;

  /// Background color for the entire header container.
  final Color? backgroundColor;

  /// Whether to respect top SafeArea.
  final bool safeArea;

  /// Configuration for slice specifications and motion curves.
  final MultiSliceAccordionConfig config;

  @override
  Widget build(BuildContext context) {
    final topPadding = safeArea ? MediaQuery.paddingOf(context).top : 0.0;
    final totalExpanded = topPadding + config.pinnedToolbarHeight +
        slices.fold(0.0, (acc, item) => acc + item.spec.height);
    final totalCollapsed = topPadding + config.pinnedToolbarHeight;

    return SliverPersistentHeader(
      pinned: true,
      delegate: _MultiSliceAccordionDelegate(
        pinnedBar: pinnedBar,
        slices: slices,
        backgroundColor: backgroundColor ?? Theme.of(context).colorScheme.surface,
        topPadding: topPadding,
        totalExpanded: math.max(totalExpanded, totalCollapsed + 1.0),
        totalCollapsed: totalCollapsed,
        config: config,
      ),
    );
  }
}

class _MultiSliceAccordionDelegate extends SliverPersistentHeaderDelegate {
  _MultiSliceAccordionDelegate({
    required this.pinnedBar,
    required this.slices,
    required this.backgroundColor,
    required this.topPadding,
    required this.totalExpanded,
    required this.totalCollapsed,
    required this.config,
  });

  final Widget pinnedBar;
  final List<AccordionSliceItem> slices;
  final Color backgroundColor;
  final double topPadding;
  final double totalExpanded;
  final double totalCollapsed;
  final MultiSliceAccordionConfig config;

  @override
  double get minExtent => totalCollapsed;

  @override
  double get maxExtent => totalExpanded;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    final reducedMotion = MediaQuery.disableAnimationsOf(context);
    final width = MediaQuery.sizeOf(context).width;
    final safeWidth = width > 0 ? width : 360.0;
    final theme = Theme.of(context);

    // Compute active height for each slice based on its distinct scroll band
    final sliceHeights = <double>[];
    final sliceFactors = <double>[];

    for (final item in slices) {
      final spec = item.spec;
      final start = spec.collapseStartOffset;
      final end = spec.collapseEndOffset;
      final delta = end - start;

      double collapseFactor = 0.0;
      if (shrinkOffset <= start) {
        collapseFactor = 0.0;
      } else if (shrinkOffset >= end || delta <= 0) {
        collapseFactor = 1.0;
      } else {
        collapseFactor = (shrinkOffset - start) / delta;
      }

      final curvedFactor = reducedMotion
          ? (collapseFactor > 0.5 ? 1.0 : 0.0)
          : config.curve.transform(collapseFactor.clamp(0.0, 1.0));

      final activeHeight = spec.height * (1.0 - curvedFactor);
      sliceHeights.add(activeHeight);
      sliceFactors.add(curvedFactor);
    }

    final isCollapsed = shrinkOffset >= (maxExtent - minExtent - 1.0);

    return Material(
      elevation: isCollapsed ? 3.0 : 1.0,
      color: backgroundColor,
      child: ClipRect(
        child: OverflowBox(
          minWidth: 0.0,
          maxWidth: safeWidth,
          minHeight: 0.0,
          maxHeight: totalExpanded,
          alignment: Alignment.topLeft,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Top SafeArea padding
              if (topPadding > 0) SizedBox(height: topPadding),

              // Pinned navigation bar
              SizedBox(
                height: config.pinnedToolbarHeight,
                child: pinnedBar,
              ),

              // Accordion Slices
              for (int i = 0; i < slices.length; i++) ...[
                _buildSliceWidget(
                  context: context,
                  item: slices[i],
                  height: sliceHeights[i],
                  collapseFactor: sliceFactors[i],
                  theme: theme,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSliceWidget({
    required BuildContext context,
    required AccordionSliceItem item,
    required double height,
    required double collapseFactor,
    required ThemeData theme,
  }) {
    if (height <= 0.5) {
      return const SizedBox.shrink();
    }

    final naturalHeight = item.spec.height;

    return SizedBox(
      height: height,
      child: ClipRect(
        child: OverflowBox(
          minWidth: 0.0,
          maxWidth: double.infinity,
          minHeight: 0.0,
          maxHeight: naturalHeight,
          alignment: Alignment.topCenter,
          child: Container(
            height: naturalHeight,
            color: item.backgroundColor,
            child: Opacity(
              opacity: (1.0 - collapseFactor).clamp(0.0, 1.0),
              child: item.builder(context, collapseFactor),
            ),
          ),
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(covariant _MultiSliceAccordionDelegate oldDelegate) {
    return pinnedBar != oldDelegate.pinnedBar ||
        slices != oldDelegate.slices ||
        backgroundColor != oldDelegate.backgroundColor ||
        topPadding != oldDelegate.topPadding ||
        totalExpanded != oldDelegate.totalExpanded ||
        totalCollapsed != oldDelegate.totalCollapsed ||
        config != oldDelegate.config;
  }
}

