import 'package:flutter/material.dart';
import '../../app_bar_model_configuration.dart';

/// Strongly-typed configuration for Model 19: Liquid Wave Morph Navigation.
///
/// Features a fluid organic sine wave boundary that deforms dynamically on scroll.
/// At rest, gentle wave crests contour the bottom perimeter. On upward scroll,
/// wave amplitude and frequency flatten elastically to snap into a crisp straight pinned toolbar.
class LiquidWaveMorphNavConfig extends AppBarModelConfiguration {
  /// Creates a [LiquidWaveMorphNavConfig].
  const LiquidWaveMorphNavConfig({
    this.title = 'Liquid Wave Navigation',
    this.subtitle = 'Continuous Organic Boundary Morphing',
    this.waveAmplitude = 22.0,
    this.waveFrequency = 1.5,
    this.expandedHeight = 220.0,
    this.collapsedHeight = 60.0,
    this.waveColor,
    this.crestGradientColors,
    super.safeArea = true,
    super.backgroundColor,
    super.surfaceTint,
    super.physics,
    super.elevation = 2.0,
  });

  /// Primary navigation title.
  final String title;

  /// Secondary subtitle or descriptive label.
  final String subtitle;

  /// Peak amplitude (height in pixels) of the sinusoidal wave crests.
  final double waveAmplitude;

  /// Frequency multiplier of wave cycles across the header width.
  final double waveFrequency;

  /// Total expanded height.
  final double expandedHeight;

  /// Collapsed pinned toolbar height.
  final double collapsedHeight;

  /// Custom wave fill color.
  final Color? waveColor;

  /// Gradient colors for the fluid crest.
  final List<Color>? crestGradientColors;
}

