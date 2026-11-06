import 'package:flutter/material.dart';
import '../../app_bar_model_configuration.dart';

/// Strongly-typed configuration for Model 2: Full-Screen Hero Cinematic Navigation.
class FullScreenHeroConfig extends AppBarModelConfiguration {
  /// Creates a [FullScreenHeroConfig].
  const FullScreenHeroConfig({
    this.heroMedia,
    this.headline = 'Celestial Odyssey',
    this.tagline = 'Deep Space Documentary • 4K HDR',
    this.scrimGradient,
    this.overscrollStretchFactor = 1.45,
    this.blurSigma = 12.0,
    this.collapsedHeight = 64.0,
    this.glassmorphicToolbar = true,
    this.playbackAction,
    this.customViewportHeight,
    super.safeArea = true,
    super.backgroundColor = Colors.black,
    super.surfaceTint,
    super.physics,
    super.elevation = 0.0,
  });

  /// The full-screen background media widget (image, shader, or video canvas).
  final Widget? heroMedia;

  /// Primary display headline.
  final String headline;

  /// Secondary cinematic tagline or metadata.
  final String? tagline;

  /// Gradient scrim applied over media to ensure pristine text legibility.
  final Gradient? scrimGradient;

  /// Maximum scale multiplier applied during downward overscroll stretch.
  final double overscrollStretchFactor;

  /// Gaussian blur sigma applied to the glassmorphic toolbar when collapsed.
  final double blurSigma;

  /// Height of the compact pinned toolbar.
  final double collapsedHeight;

  /// Whether the collapsed toolbar renders a glassmorphic frosted blur filter.
  final bool glassmorphicToolbar;

  /// Prominent hero CTA or media playback button.
  final Widget? playbackAction;

  /// Optional override for the expanded viewport height (defaults to 100vh).
  final double? customViewportHeight;
}

