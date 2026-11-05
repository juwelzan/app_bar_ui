import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Provides hardware-accelerated 3D perspective projection and rotational transforms.
class PerspectiveTransform3D {
  /// Builds a [Matrix4] with perspective entry applied along the Z-axis.
  ///
  /// [perspective] specifies the focal distance factor (typical values: 0.001 - 0.003).
  /// [angleRadians] is the rotation angle in radians.
  /// [axis] specifies horizontal (X-axis flip) or vertical (Y-axis roll).
  static Matrix4 createRotationMatrix({
    required double angleRadians,
    Axis axis = Axis.horizontal,
    double perspective = 0.0018,
  }) {
    final matrix = Matrix4.identity();
    if (perspective > 0.0) {
      matrix.setEntry(3, 2, perspective);
    }

    if (axis == Axis.horizontal) {
      matrix.rotateX(angleRadians);
    } else {
      matrix.rotateY(angleRadians);
    }
    return matrix;
  }

  /// Whether the card's front face is currently visible given [angleRadians].
  ///
  /// Returns `true` when the rotation is in $[-\pi/2, \pi/2]$ modulo $2\pi$.
  static bool isFrontFaceVisible(double angleRadians) {
    final normalized = angleRadians % (2 * math.pi);
    return normalized <= math.pi / 2 || normalized >= 3 * math.pi / 2;
  }
}
