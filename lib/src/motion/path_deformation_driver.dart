import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Helper utility for computing dynamic wave and liquid path deformations
/// based on scroll metrics and animation progression.
class PathDeformationDriver {
  const PathDeformationDriver._();

  /// Computes a liquid wave path along the bottom edge of a rectangular area.
  ///
  /// [size]: Box dimensions (width & height).
  /// [amplitude]: Maximum vertical wave displacement in pixels.
  /// [frequency]: Number of full sine wave cycles across the width.
  /// [phase]: Phase shift in radians (can be driven by scroll offset or velocity).
  /// [flattenProgress]: Normalized collapse factor (0.0 = full wave, 1.0 = completely flat).
  static Path computeWavePath({
    required Size size,
    required double amplitude,
    double frequency = 1.0,
    double phase = 0.0,
    double flattenProgress = 0.0,
  }) {
    final path = Path();
    path.lineTo(0.0, size.height);

    // If completely flat, return simple rectangle
    final currentAmplitude = amplitude * (1.0 - flattenProgress.clamp(0.0, 1.0));
    if (currentAmplitude <= 0.001) {
      path.lineTo(size.width, size.height);
      path.lineTo(size.width, 0.0);
      path.close();
      return path;
    }

    final waveWidth = size.width;
    const step = 4.0; // Point evaluation step in pixels

    for (double x = 0.0; x <= waveWidth; x += step) {
      final normalizedX = x / waveWidth;
      final angle = (normalizedX * frequency * 2 * math.pi) + phase;
      final waveOffset = math.sin(angle) * currentAmplitude;
      final y = size.height - waveOffset;
      path.lineTo(x, y);
    }

    // Connect to right edge and close back along the top
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0.0);
    path.close();

    return path;
  }
}

/// Custom clipper that clips a widget using [PathDeformationDriver.computeWavePath].
class LiquidWaveClipper extends CustomClipper<Path> {
  const LiquidWaveClipper({
    required this.amplitude,
    this.frequency = 1.0,
    this.phase = 0.0,
    this.flattenProgress = 0.0,
  });

  final double amplitude;
  final double frequency;
  final double phase;
  final double flattenProgress;

  @override
  Path getClip(Size size) {
    return PathDeformationDriver.computeWavePath(
      size: size,
      amplitude: amplitude,
      frequency: frequency,
      phase: phase,
      flattenProgress: flattenProgress,
    );
  }

  @override
  bool shouldReclip(covariant LiquidWaveClipper oldClipper) {
    return oldClipper.amplitude != amplitude ||
        oldClipper.frequency != frequency ||
        oldClipper.phase != phase ||
        oldClipper.flattenProgress != flattenProgress;
  }
}
