import 'package:flutter/physics.dart';

/// Coordinates damped physical spring simulations and non-linear elastic resistance.
class ElasticSpringCoordinator {
  /// Default spring description tuned for responsive UI headers.
  static const SpringDescription defaultSpring = SpringDescription(
    mass: 1.0,
    stiffness: 220.0,
    damping: 18.0,
  );

  /// Computes non-linear elastic displacement with resistance decay.
  ///
  /// Given raw overscroll distance [rawDisplacement], computes a physically
  /// dampening curve that never exceeds [maxStretch].
  static double computeElasticResistance({
    required double rawDisplacement,
    double maxStretch = 60.0,
    double resistanceFactor = 0.55,
  }) {
    if (rawDisplacement <= 0.0) return 0.0;
    // Asymptotic decay curve: f(x) = maxStretch * (1 - e^(-x * factor / maxStretch))
    final normalized = (rawDisplacement * resistanceFactor) / maxStretch;
    final dampening = 1.0 - (1.0 / (1.0 + normalized));
    return (maxStretch * dampening).clamp(0.0, maxStretch);
  }

  /// Creates a [SpringSimulation] to settle an element back to zero resting position.
  static SpringSimulation createSettleSimulation({
    required double startDisplacement,
    required double initialVelocity,
    SpringDescription spring = defaultSpring,
  }) {
    return SpringSimulation(spring, startDisplacement, 0.0, initialVelocity);
  }
}

