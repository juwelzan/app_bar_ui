import 'package:flutter/material.dart';

/// Styling and geometry configurations for header presets in the Scroll-Driven UI Framework.
class ScrollHeaderStyle {
  /// Creates a [ScrollHeaderStyle] configuration.
  const ScrollHeaderStyle({
    this.backgroundColor,
    this.scrolledBackgroundColor,
    this.foregroundColor,
    this.scrolledForegroundColor,
    this.gradient,
    this.scrolledGradient,
    this.elevation = 0.0,
    this.scrolledElevation = 2.0,
    this.height = 56.0,
    this.expandedHeight = 200.0,
    this.collapsedHeight = 56.0,
    this.padding,
    this.margin,
    this.borderRadius,
    this.showDivider = false,
    this.dividerColor,
    this.centerTitle,
    this.titleSpacing,
    this.titleStyle,
    this.subtitleStyle,
    this.largeTitleStyle,
    this.collapsedTitleStyle,
    this.blurBackground = false,
    this.blurSigma = 10.0,
    this.pinned = true,
    this.floating = false,
    this.curve = Curves.easeInOut,
    this.duration = const Duration(milliseconds: 250),
  });

  /// Base background color.
  final Color? backgroundColor;

  /// Background color applied when scrolled past the transition threshold.
  final Color? scrolledBackgroundColor;

  /// Foreground/icon color in initial state.
  final Color? foregroundColor;

  /// Foreground/icon color in scrolled state.
  final Color? scrolledForegroundColor;

  /// Gradient applied in initial state.
  final Gradient? gradient;

  /// Gradient applied in scrolled state.
  final Gradient? scrolledGradient;

  /// Initial elevation/shadow.
  final double elevation;

  /// Elevation applied when scrolled past the threshold.
  final double scrolledElevation;

  /// Default height for fixed-height headers. Defaults to 56.0.
  final double height;

  /// Expanded height for collapsing or flexible headers. Defaults to 200.0.
  final double expandedHeight;

  /// Collapsed height for collapsing or flexible headers. Defaults to 56.0.
  final double collapsedHeight;

  /// Internal padding for the header contents.
  final EdgeInsetsGeometry? padding;

  /// External margin around the header (used e.g. in [ScrollHeader.floating]).
  final EdgeInsetsGeometry? margin;

  /// Border radius applied to the header container.
  final BorderRadius? borderRadius;

  /// Whether a hairline divider appears beneath the header upon scrolling.
  final bool showDivider;

  /// Color of the divider line.
  final Color? dividerColor;

  /// Whether the title is centered within the header.
  final bool? centerTitle;

  /// Horizontal spacing around the title.
  final double? titleSpacing;

  /// Text style for the main title.
  final TextStyle? titleStyle;

  /// Text style for the subtitle.
  final TextStyle? subtitleStyle;

  /// Text style for expanded large titles.
  final TextStyle? largeTitleStyle;

  /// Text style for collapsed inline titles.
  final TextStyle? collapsedTitleStyle;

  /// Whether to apply a frosted glass backdrop filter blur effect.
  final bool blurBackground;

  /// Blur sigma radius when [blurBackground] is enabled. Defaults to 10.0.
  final double blurSigma;

  /// Whether the header remains pinned at the top when scrolling.
  final bool pinned;

  /// Whether the header floats into view upon reverse scroll.
  final bool floating;

  /// Easing curve for header transitions.
  final Curve curve;

  /// Duration for triggered animations.
  final Duration duration;

  /// Creates a copy of this style with the given fields replaced.
  ScrollHeaderStyle copyWith({
    Color? backgroundColor,
    Color? scrolledBackgroundColor,
    Color? foregroundColor,
    Color? scrolledForegroundColor,
    Gradient? gradient,
    Gradient? scrolledGradient,
    double? elevation,
    double? scrolledElevation,
    double? height,
    double? expandedHeight,
    double? collapsedHeight,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    BorderRadius? borderRadius,
    bool? showDivider,
    Color? dividerColor,
    bool? centerTitle,
    double? titleSpacing,
    TextStyle? titleStyle,
    TextStyle? subtitleStyle,
    TextStyle? largeTitleStyle,
    TextStyle? collapsedTitleStyle,
    bool? blurBackground,
    double? blurSigma,
    bool? pinned,
    bool? floating,
    Curve? curve,
    Duration? duration,
  }) {
    return ScrollHeaderStyle(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      scrolledBackgroundColor:
          scrolledBackgroundColor ?? this.scrolledBackgroundColor,
      foregroundColor: foregroundColor ?? this.foregroundColor,
      scrolledForegroundColor:
          scrolledForegroundColor ?? this.scrolledForegroundColor,
      gradient: gradient ?? this.gradient,
      scrolledGradient: scrolledGradient ?? this.scrolledGradient,
      elevation: elevation ?? this.elevation,
      scrolledElevation: scrolledElevation ?? this.scrolledElevation,
      height: height ?? this.height,
      expandedHeight: expandedHeight ?? this.expandedHeight,
      collapsedHeight: collapsedHeight ?? this.collapsedHeight,
      padding: padding ?? this.padding,
      margin: margin ?? this.margin,
      borderRadius: borderRadius ?? this.borderRadius,
      showDivider: showDivider ?? this.showDivider,
      dividerColor: dividerColor ?? this.dividerColor,
      centerTitle: centerTitle ?? this.centerTitle,
      titleSpacing: titleSpacing ?? this.titleSpacing,
      titleStyle: titleStyle ?? this.titleStyle,
      subtitleStyle: subtitleStyle ?? this.subtitleStyle,
      largeTitleStyle: largeTitleStyle ?? this.largeTitleStyle,
      collapsedTitleStyle: collapsedTitleStyle ?? this.collapsedTitleStyle,
      blurBackground: blurBackground ?? this.blurBackground,
      blurSigma: blurSigma ?? this.blurSigma,
      pinned: pinned ?? this.pinned,
      floating: floating ?? this.floating,
      curve: curve ?? this.curve,
      duration: duration ?? this.duration,
    );
  }
}
