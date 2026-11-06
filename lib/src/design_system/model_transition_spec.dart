import 'package:flutter/material.dart';

/// Supported visual transition styles when dynamically switching between
/// distinct AppBar Models at runtime.
enum ModelTransitionType {
  /// Instantly unmounts the outgoing model and mounts the incoming model.
  instant,

  /// Cross-fades opacity between outgoing and incoming models.
  fade,

  /// Scales down outgoing model while scaling up incoming model.
  scale,

  /// Slides the incoming model into place (e.g. from top or lateral).
  slide,

  /// Shared element morphing transition for persistent titles/avatars.
  sharedElement,
}

/// Configuration specifying how the AppBar Engine transitions between models.
class ModelTransitionSpec {
  /// Creates a [ModelTransitionSpec].
  const ModelTransitionSpec({
    this.type = ModelTransitionType.fade,
    this.duration = const Duration(milliseconds: 300),
    this.curve = Curves.easeInOutCubic,
    this.reverseDuration,
    this.slideOffset = const Offset(0.0, -0.1),
  });

  /// Instant replacement without animation.
  static const ModelTransitionSpec none = ModelTransitionSpec(
    type: ModelTransitionType.instant,
    duration: Duration.zero,
  );

  /// Smooth fade transition preset.
  static const ModelTransitionSpec smoothFade = ModelTransitionSpec(
    type: ModelTransitionType.fade,
    duration: Duration(milliseconds: 250),
    curve: Curves.easeOutCubic,
  );

  /// Scale transition preset.
  static const ModelTransitionSpec smoothScale = ModelTransitionSpec(
    type: ModelTransitionType.scale,
    duration: Duration(milliseconds: 300),
    curve: Curves.easeOutBack,
  );

  /// The visual transition style to employ.
  final ModelTransitionType type;

  /// Duration of the transition animation.
  final Duration duration;

  /// Easing curve applied to the transition.
  final Curve curve;

  /// Optional custom reverse duration.
  final Duration? reverseDuration;

  /// Fractional offset when [ModelTransitionType.slide] is chosen.
  final Offset slideOffset;
}

