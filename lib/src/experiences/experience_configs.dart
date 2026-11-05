import 'package:flutter/material.dart';
import '../motion/motion_config.dart';

/// Configuration for Style 1: Morphing Split Header.
class MorphingSplitConfig extends AppBarMotionConfig {
  /// Creates a [MorphingSplitConfig].
  const MorphingSplitConfig({
    super.curve = Curves.easeInOutCubic,
    super.reducedMotionCurve = Curves.linear,
    this.expandedHeight = 140.0,
    this.collapsedHeight = kToolbarHeight,
    this.splitDistance = 60.0,
    this.mergeThreshold = 0.65,
    this.elevation = 0.0,
    this.collapsedElevation = 3.0,
  });

  /// Height when completely expanded.
  final double expandedHeight;

  /// Height when completely collapsed into compact bar.
  final double collapsedHeight;

  /// Maximum horizontal divergent travel distance for left/right modules.
  final double splitDistance;

  /// Normalized scroll progress ratio ($0.0 \to 1.0$) where modules merge into center pill.
  final double mergeThreshold;

  /// Expanded resting elevation.
  final double elevation;

  /// Elevation in compact collapsed state.
  final double collapsedElevation;
}

/// Configuration for Style 2: Elastic Floating Header.
class ElasticFloatingConfig extends AppBarMotionConfig {
  /// Creates an [ElasticFloatingConfig].
  const ElasticFloatingConfig({
    super.curve = Curves.easeOutBack,
    super.reducedMotionCurve = Curves.easeOut,
    this.height = 72.0,
    this.compactHeight = 56.0,
    this.horizontalMargin = 16.0,
    this.verticalMargin = 8.0,
    this.borderRadius = 20.0,
    this.compactBorderRadius = 28.0,
    this.maxOverscrollStretch = 50.0,
    this.stiffness = 220.0,
    this.damping = 18.0,
    this.restingElevation = 2.0,
    this.compactElevation = 6.0,
  });

  /// Normal resting height of the floating header.
  final double height;

  /// Height when settled in compact state.
  final double compactHeight;

  /// Left and right margin from screen bounds.
  final double horizontalMargin;

  /// Top and bottom resting margin.
  final double verticalMargin;

  /// Border radius when expanded.
  final double borderRadius;

  /// Border radius when compacted into capsule.
  final double compactBorderRadius;

  /// Maximum downward stretch distance during pull overscroll.
  final double maxOverscrollStretch;

  /// Spring stiffness constant.
  final double stiffness;

  /// Spring damping coefficient.
  final double damping;

  /// Resting elevation shadow.
  final double restingElevation;

  /// Elevated shadow in compact floating state.
  final double compactElevation;
}

/// Configuration for Style 3: Disappearing Header with Floating Actions.
class DisappearingFloatingActionsConfig extends AppBarMotionConfig {
  /// Creates a [DisappearingFloatingActionsConfig].
  const DisappearingFloatingActionsConfig({
    super.curve = Curves.easeInOut,
    super.reducedMotionCurve = Curves.linear,
    this.expandedHeight = 160.0,
    this.detachOffset = 45.0,
    this.fadeOffset = 80.0,
    this.actionSpacing = 10.0,
    this.floatingActionElevation = 6.0,
    this.floatingActionMargin = const EdgeInsets.only(top: 12.0, right: 16.0),
  });

  /// Height of the non-permanent hero header.
  final double expandedHeight;

  /// Scroll offset at which action controls detach and float independently.
  final double detachOffset;

  /// Scroll offset at which header title and metadata fade to 0 opacity.
  final double fadeOffset;

  /// Spacing between pinned floating action icons.
  final double actionSpacing;

  /// Elevation shadow for detached floating actions.
  final double floatingActionElevation;

  /// Anchor position margin for detached floating action cluster.
  final EdgeInsets floatingActionMargin;
}

/// Configuration for Style 4: Circular Morph Header.
class CircularMorphConfig extends AppBarMotionConfig {
  /// Creates a [CircularMorphConfig].
  const CircularMorphConfig({
    super.curve = Curves.fastOutSlowIn,
    super.reducedMotionCurve = Curves.linear,
    this.expandedHeight = 130.0,
    this.targetDiameter = 54.0,
    this.anchorAlignment = Alignment.topRight,
    this.margin = const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
    this.compactMargin = const EdgeInsets.only(top: 8.0, right: 16.0),
    this.restingElevation = 1.0,
    this.compactElevation = 5.0,
  });

  /// Expanded height of the full-width rect header.
  final double expandedHeight;

  /// Diameter of the final circular morph state.
  final double targetDiameter;

  /// Alignment where the circle anchors in the compact state.
  final Alignment anchorAlignment;

  /// Initial padding/margin when rectangular.
  final EdgeInsets margin;

  /// Margin when morphed into compact floating circular avatar.
  final EdgeInsets compactMargin;

  /// Elevation in expanded state.
  final double restingElevation;

  /// Elevation in compact circular state.
  final double compactElevation;
}

/// Configuration for Style 5: 3D Flip Header.
class Flip3DConfig extends AppBarMotionConfig {
  /// Creates a [Flip3DConfig].
  const Flip3DConfig({
    super.curve = Curves.easeInOutCubic,
    super.reducedMotionCurve = Curves.linear,
    this.expandedHeight = 160.0,
    this.collapsedHeight = kToolbarHeight,
    this.perspective = 0.0016,
    this.flipAxis = Axis.horizontal,
    this.flipThreshold = 120.0,
    this.frontElevation = 2.0,
    this.backElevation = 4.0,
  });

  /// Expanded card height (front face).
  final double expandedHeight;

  /// Collapsed toolbar height (back face).
  final double collapsedHeight;

  /// 3D perspective projection distortion factor.
  final double perspective;

  /// Axis of rotation: [Axis.horizontal] for vertical card flip, [Axis.vertical] for lateral spin.
  final Axis flipAxis;

  /// Scroll distance required to execute a complete $180^\circ$ flip.
  final double flipThreshold;

  /// Front face card elevation.
  final double frontElevation;

  /// Back face compact bar elevation.
  final double backElevation;
}
