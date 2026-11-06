import 'package:flutter/material.dart';

/// Abstract base class for all strongly-typed AppBar Model configurations.
///
/// Unlike monolithic configuration classes, each independent AppBar Model
/// defines its own typed configuration subclass containing exclusively the
/// geometry, animation, and behavior properties meaningful to its UI paradigm.
abstract class AppBarModelConfiguration {
  /// Creates a base [AppBarModelConfiguration].
  const AppBarModelConfiguration({
    this.safeArea = true,
    this.backgroundColor,
    this.surfaceTint,
    this.physics,
    this.elevation = 0.0,
  });

  /// Whether the header accommodates the top device status bar.
  final bool safeArea;

  /// Primary canvas background color.
  final Color? backgroundColor;

  /// Optional Material 3 surface tint elevation color.
  final Color? surfaceTint;

  /// Custom scroll physics to apply to the enclosing scroll view.
  final ScrollPhysics? physics;

  /// Resting elevation in logical pixels.
  final double elevation;
}

