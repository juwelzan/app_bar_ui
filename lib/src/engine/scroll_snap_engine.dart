import 'package:flutter/material.dart';

/// Configuration for scroll snapping behavior.
class ScrollSnapConfig {
  /// Creates a [ScrollSnapConfig].
  const ScrollSnapConfig({
    this.snapOffsets = const [0.0],
    this.snapTolerance = 40.0,
    this.animationDuration = const Duration(milliseconds: 250),
    this.curve = Curves.easeOutCubic,
    this.snapToHeader = true,
    this.headerExpandedOffset = 0.0,
    this.headerCollapsedOffset = 150.0,
  });

  /// Explicit pixel offsets where scrolling should snap.
  final List<double> snapOffsets;

  /// Maximum pixel distance from a snap target to activate snapping.
  final double snapTolerance;

  /// Duration of the snapping animation. Defaults to 250ms.
  final Duration animationDuration;

  /// Easing curve for snapping animations.
  final Curve curve;

  /// Whether to automatically include header collapse boundaries as snap targets.
  final bool snapToHeader;

  /// Header expanded offset (typically 0.0).
  final double headerExpandedOffset;

  /// Header fully collapsed offset.
  final double headerCollapsedOffset;

  /// Returns all effective snap points sorted ascending.
  List<double> get effectiveSnapPoints {
    final points = <double>{...snapOffsets};
    if (snapToHeader) {
      points.add(headerExpandedOffset);
      points.add(headerCollapsedOffset);
    }
    final sorted = points.toList()..sort();
    return sorted;
  }

  /// Finds the closest snap target to [currentOffset], or null if outside [snapTolerance].
  double? findNearestSnapTarget(double currentOffset) {
    double? closest;
    double minDistance = double.infinity;

    for (final point in effectiveSnapPoints) {
      final distance = (point - currentOffset).abs();
      if (distance <= snapTolerance && distance < minDistance) {
        minDistance = distance;
        closest = point;
      }
    }

    return closest;
  }
}

/// A scroll physics class that snaps to configured offset targets upon ballistic simulation.
class ScrollSnapPhysics extends ScrollPhysics {
  /// Creates a [ScrollSnapPhysics] instance.
  const ScrollSnapPhysics({
    super.parent,
    this.config = const ScrollSnapConfig(),
  });

  /// The snap configuration.
  final ScrollSnapConfig config;

  @override
  ScrollSnapPhysics applyTo(ScrollPhysics? ancestor) {
    return ScrollSnapPhysics(
      parent: buildParent(ancestor),
      config: config,
    );
  }

  @override
  Simulation? createBallisticSimulation(
    ScrollMetrics position,
    double velocity,
  ) {
    // If user flicked with high velocity, let normal physics handle it
    if (velocity.abs() > 400.0) {
      return super.createBallisticSimulation(position, velocity);
    }

    final double currentOffset = position.pixels;
    final double? nearest = config.findNearestSnapTarget(currentOffset);

    if (nearest != null && (nearest - currentOffset).abs() > 1.0) {
      return ScrollSpringSimulation(
        spring,
        currentOffset,
        nearest,
        velocity,
        tolerance: toleranceFor(position),
      );
    }

    return super.createBallisticSimulation(position, velocity);
  }
}

/// Programmatic scroll snapping controller that manages snapping when drag ends.
class ScrollSnapEngine {
  /// Creates a [ScrollSnapEngine].
  ScrollSnapEngine({
    required this.controller,
    this.config = const ScrollSnapConfig(),
  });

  /// The target [ScrollController].
  final ScrollController controller;

  /// Active snap configuration.
  ScrollSnapConfig config;

  bool _isSnapping = false;

  /// Handles scroll end notifications and snaps if within tolerance.
  void handleScrollEnd() {
    if (_isSnapping || !controller.hasClients) return;

    final offset = controller.offset;
    final target = config.findNearestSnapTarget(offset);

    if (target != null && (target - offset).abs() > 1.0) {
      snapTo(target);
    }
  }

  /// Programmatically animates to a specific [targetOffset].
  Future<void> snapTo(double targetOffset) async {
    if (!controller.hasClients || _isSnapping) return;
    _isSnapping = true;
    try {
      await controller.animateTo(
        targetOffset.clamp(
          controller.position.minScrollExtent,
          controller.position.maxScrollExtent,
        ),
        duration: config.animationDuration,
        curve: config.curve,
      );
    } finally {
      _isSnapping = false;
    }
  }
}
