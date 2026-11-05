import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'sliver_widget_marker.dart';

/// A sliver header that stretches and expands dynamically when pulled down at the top of a scroll view.
///
/// Provides the classic iOS-style rubber-band cover image expansion, profile header zoom,
/// and pull-to-expand visual feedback.
class ScrollPullToExpandHeader extends StatelessWidget with SliverWidgetMarker {
  /// Creates a [ScrollPullToExpandHeader] widget.
  const ScrollPullToExpandHeader({
    super.key,
    this.expandedHeight = 240.0,
    this.collapsedHeight = 0.0,
    this.maxExpansion = 150.0,
    this.stretchFactor = 1.0,
    this.enableZoom = true,
    this.onStretchTrigger,
    this.stretchTriggerOffset = 100.0,
    this.child,
    this.content,
    this.builder,
    this.curve = Curves.easeOut,
  }) : assert(expandedHeight > 0, 'expandedHeight must be positive.');

  /// Base height of the header when not pulled or collapsed.
  final double expandedHeight;

  /// Minimum collapsed height if scroll continues upwards. Defaults to 0.0.
  final double collapsedHeight;

  /// Maximum extra height when overscrolling (pulling down). Defaults to 150.0.
  final double maxExpansion;

  /// Sensitivity factor for the stretch effect. Defaults to 1.0.
  final double stretchFactor;

  /// Whether the background child scales up (zooms) during pull-to-expand. Defaults to `true`.
  final bool enableZoom;

  /// Optional callback invoked when pulled down past [stretchTriggerOffset].
  final AsyncCallback? onStretchTrigger;

  /// Pull distance in pixels required to trigger [onStretchTrigger]. Defaults to 100.0.
  final double stretchTriggerOffset;

  /// The background widget to stretch (e.g., Image, Decoration, Gradient).
  final Widget? child;

  /// Foreground content rendered over the expanding background.
  final Widget? content;

  /// Custom builder receiving [expandProgress] (0.0 at rest, 1.0 at [maxExpansion]).
  final Widget Function(
    BuildContext context,
    double expandProgress,
    double currentHeight,
  )?
  builder;

  /// Easing curve applied to the stretch expansion.
  final Curve curve;

  @override
  Widget build(BuildContext context) {
    return SliverPersistentHeader(
      delegate: _ScrollPullToExpandHeaderDelegate(
        expandedHeight: expandedHeight,
        collapsedHeight: collapsedHeight,
        maxExpansion: maxExpansion,
        stretchFactor: stretchFactor,
        enableZoom: enableZoom,
        onStretchTrigger: onStretchTrigger,
        stretchTriggerOffset: stretchTriggerOffset,
        child: child,
        content: content,
        builder: builder,
        curve: curve,
      ),
    );
  }
}

class _ScrollPullToExpandHeaderDelegate extends SliverPersistentHeaderDelegate {
  _ScrollPullToExpandHeaderDelegate({
    required this.expandedHeight,
    required this.collapsedHeight,
    required this.maxExpansion,
    required this.stretchFactor,
    required this.enableZoom,
    this.onStretchTrigger,
    required this.stretchTriggerOffset,
    this.child,
    this.content,
    this.builder,
    required this.curve,
  });

  final double expandedHeight;
  final double collapsedHeight;
  final double maxExpansion;
  final double stretchFactor;
  final bool enableZoom;
  final AsyncCallback? onStretchTrigger;
  final double stretchTriggerOffset;
  final Widget? child;
  final Widget? content;
  final Widget Function(
    BuildContext context,
    double expandProgress,
    double currentHeight,
  )?
  builder;
  final Curve curve;

  @override
  double get minExtent => collapsedHeight;

  @override
  double get maxExtent => expandedHeight;

  @override
  OverScrollHeaderStretchConfiguration? get stretchConfiguration =>
      OverScrollHeaderStretchConfiguration(
        stretchTriggerOffset: stretchTriggerOffset,
        onStretchTrigger: onStretchTrigger,
      );

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    final double currentHeight = math.max(minExtent, maxExtent - shrinkOffset);
    final double expandProgress = 0.0; // Base value without overscroll

    // If a custom builder is provided, invoke it with the calculated values
    if (builder != null) {
      return builder!(context, expandProgress, currentHeight);
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        // In overscroll environments (e.g. BouncingScrollPhysics), constraints.maxHeight
        // can exceed maxExtent by the pull amount.
        final double actualHeight = constraints.maxHeight;
        final double overscrollDelta = math.max(0.0, actualHeight - maxExtent);
        final double normalizedProgress = (maxExpansion > 0)
            ? (overscrollDelta / maxExpansion).clamp(0.0, 1.0)
            : 0.0;
        final double curvedProgress = curve.transform(normalizedProgress);
        final double scale = enableZoom
            ? 1.0 + (curvedProgress * 0.3 * stretchFactor)
            : 1.0;

        return ClipRect(
          child: Stack(
            fit: StackFit.expand,
            children: [
              if (child != null)
                Transform.scale(
                  scale: scale,
                  alignment: Alignment.center,
                  child: child!,
                ),
              ?content,
            ],
          ),
        );
      },
    );
  }

  @override
  bool shouldRebuild(covariant _ScrollPullToExpandHeaderDelegate oldDelegate) {
    return oldDelegate.expandedHeight != expandedHeight ||
        oldDelegate.collapsedHeight != collapsedHeight ||
        oldDelegate.maxExpansion != maxExpansion ||
        oldDelegate.stretchFactor != stretchFactor ||
        oldDelegate.enableZoom != enableZoom ||
        oldDelegate.onStretchTrigger != onStretchTrigger ||
        oldDelegate.stretchTriggerOffset != stretchTriggerOffset ||
        oldDelegate.child != child ||
        oldDelegate.content != content ||
        oldDelegate.builder != builder ||
        oldDelegate.curve != curve;
  }
}
