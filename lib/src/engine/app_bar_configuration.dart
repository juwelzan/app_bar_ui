import 'dart:ui' show ImageFilter;
import 'package:flutter/material.dart';

import '../design_system/app_bar_model_configuration.dart';
import 'element_configuration.dart';

/// Screen width breakpoints for adaptive responsive layouts.
class ResponsiveBreakpoints {
  /// Creates responsive breakpoints.
  const ResponsiveBreakpoints({
    this.mobile = 0.0,
    this.tablet = 600.0,
    this.desktop = 1024.0,
    this.ultraWide = 1440.0,
  });

  /// Mobile breakpoint threshold.
  final double mobile;

  /// Tablet breakpoint threshold.
  final double tablet;

  /// Desktop breakpoint threshold.
  final double desktop;

  /// Ultra-wide monitor threshold.
  final double ultraWide;

  /// Determines whether current width is in tablet range.
  bool isTablet(double width) => width >= tablet && width < desktop;

  /// Determines whether current width is desktop or wider.
  bool isDesktop(double width) => width >= desktop;
}

/// Custom layout builder signature for overriding the AppBar layout container.
typedef CustomLayoutBuilder = Widget Function(
  BuildContext context,
  BoxConstraints constraints,
  ResolvedAppBarConfiguration configuration,
);

/// Layout geometry, heights, padding, and responsive constraints.
class LayoutConfiguration {
  /// Creates a layout configuration.
  const LayoutConfiguration({
    this.expandedHeight = 240.0,
    this.collapsedHeight = 64.0,
    this.minHeight,
    this.maxHeight,
    this.width,
    this.alignment = Alignment.center,
    this.padding = EdgeInsets.zero,
    this.margin = EdgeInsets.zero,
    this.spacing = 8.0,
    this.safeArea = true,
    this.layoutDirection,
    this.breakpoints = const ResponsiveBreakpoints(),
    this.customLayoutBuilder,
  }) : assert(expandedHeight >= collapsedHeight, 'expandedHeight must be >= collapsedHeight');

  /// Height when fully expanded.
  final double expandedHeight;

  /// Height when collapsed / pinned at top.
  final double collapsedHeight;

  /// Optional minimum height clamp.
  final double? minHeight;

  /// Optional maximum height clamp.
  final double? maxHeight;

  /// Optional fixed width.
  final double? width;

  /// Alignment of content inside the header.
  final AlignmentGeometry alignment;

  /// Internal padding.
  final EdgeInsetsGeometry padding;

  /// External margin around the header.
  final EdgeInsetsGeometry margin;

  /// Spacing between adjacent elements.
  final double spacing;

  /// Whether to automatically inset for device notch and status bar.
  final bool safeArea;

  /// Text and layout direction.
  final TextDirection? layoutDirection;

  /// Responsive screen size breakpoints.
  final ResponsiveBreakpoints breakpoints;

  /// Custom layout builder overriding default slot layout.
  final CustomLayoutBuilder? customLayoutBuilder;

  /// Creates a copy with selectively replaced properties.
  LayoutConfiguration copyWith({
    double? expandedHeight,
    double? collapsedHeight,
    double? minHeight,
    double? maxHeight,
    double? width,
    AlignmentGeometry? alignment,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    double? spacing,
    bool? safeArea,
    TextDirection? layoutDirection,
    ResponsiveBreakpoints? breakpoints,
    CustomLayoutBuilder? customLayoutBuilder,
  }) {
    return LayoutConfiguration(
      expandedHeight: expandedHeight ?? this.expandedHeight,
      collapsedHeight: collapsedHeight ?? this.collapsedHeight,
      minHeight: minHeight ?? this.minHeight,
      maxHeight: maxHeight ?? this.maxHeight,
      width: width ?? this.width,
      alignment: alignment ?? this.alignment,
      padding: padding ?? this.padding,
      margin: margin ?? this.margin,
      spacing: spacing ?? this.spacing,
      safeArea: safeArea ?? this.safeArea,
      layoutDirection: layoutDirection ?? this.layoutDirection,
      breakpoints: breakpoints ?? this.breakpoints,
      customLayoutBuilder: customLayoutBuilder ?? this.customLayoutBuilder,
    );
  }
}

/// Content widgets and slot declarations for the AppBar.
class ContentConfiguration {
  /// Creates a content configuration.
  const ContentConfiguration({
    this.title,
    this.subtitle,
    this.leading,
    this.actions = const [],
    this.avatar,
    this.searchField,
    this.navigationControls,
    this.tabs,
    this.background,
    this.foreground,
    this.decorative = const [],
    this.expandedContent,
    this.collapsedContent,
    this.customWidgets = const {},
  });

  /// Convenience factory for simple text-based headers.
  factory ContentConfiguration.text({
    required String title,
    String? subtitle,
    Widget? leading,
    List<Widget> actions = const [],
    Widget? avatar,
    Widget? searchField,
    Widget? background,
  }) {
    return ContentConfiguration(
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle,
              style: const TextStyle(fontSize: 13.0, color: Colors.grey),
            )
          : null,
      leading: leading,
      actions: actions,
      avatar: avatar,
      searchField: searchField,
      background: background,
    );
  }

  /// Primary title widget.
  final Widget? title;

  /// Secondary subtitle widget.
  final Widget? subtitle;

  /// Leading navigation widget (e.g. back button, menu icon).
  final Widget? leading;

  /// Trailing action button list.
  final List<Widget> actions;

  /// User avatar or identity graphic.
  final Widget? avatar;

  /// Search bar or search trigger field.
  final Widget? searchField;

  /// Intermediate navigation widgets (e.g. breadcrumbs, segmented controls).
  final Widget? navigationControls;

  /// Pinned or collapsing tab bar.
  final Widget? tabs;

  /// Background layer (e.g. hero image, mesh gradient, video cover).
  final Widget? background;

  /// Foreground scrim or overlay layer.
  final Widget? foreground;

  /// Floating or decorative graphic accents.
  final List<Widget> decorative;

  /// Custom content shown exclusively in expanded mode.
  final Widget? expandedContent;

  /// Custom content shown exclusively in compact/collapsed mode.
  final Widget? collapsedContent;

  /// Extensible dictionary of named custom widgets.
  final Map<String, Widget> customWidgets;

  /// Creates a copy with selectively replaced properties.
  ContentConfiguration copyWith({
    Widget? title,
    Widget? subtitle,
    Widget? leading,
    List<Widget>? actions,
    Widget? avatar,
    Widget? searchField,
    Widget? navigationControls,
    Widget? tabs,
    Widget? background,
    Widget? foreground,
    List<Widget>? decorative,
    Widget? expandedContent,
    Widget? collapsedContent,
    Map<String, Widget>? customWidgets,
  }) {
    return ContentConfiguration(
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      leading: leading ?? this.leading,
      actions: actions ?? this.actions,
      avatar: avatar ?? this.avatar,
      searchField: searchField ?? this.searchField,
      navigationControls: navigationControls ?? this.navigationControls,
      tabs: tabs ?? this.tabs,
      background: background ?? this.background,
      foreground: foreground ?? this.foreground,
      decorative: decorative ?? this.decorative,
      expandedContent: expandedContent ?? this.expandedContent,
      collapsedContent: collapsedContent ?? this.collapsedContent,
      customWidgets: customWidgets ?? this.customWidgets,
    );
  }
}

/// Visual styling, colors, borders, elevations, and blur filters.
class AppearanceConfiguration {
  /// Creates an appearance configuration.
  const AppearanceConfiguration({
    this.backgroundColor,
    this.collapsedBackgroundColor,
    this.foregroundColor,
    this.elevation = 0.0,
    this.scrolledElevation = 4.0,
    this.shadowColor,
    this.borderRadius = BorderRadius.zero,
    this.collapsedBorderRadius = BorderRadius.zero,
    this.shape,
    this.border,
    this.gradient,
    this.scrolledGradient,
    this.blurFilter,
    this.blurSigma = 0.0,
    this.opacity = 1.0,
    this.overlayColor,
  });

  /// Base background color when expanded.
  final Color? backgroundColor;

  /// Background color when collapsed/pinned.
  final Color? collapsedBackgroundColor;

  /// Foreground icon and text tint color.
  final Color? foregroundColor;

  /// Elevation when expanded.
  final double elevation;

  /// Elevation when collapsed and scrolled.
  final double scrolledElevation;

  /// Shadow color for elevation.
  final Color? shadowColor;

  /// Border radius in expanded state.
  final BorderRadiusGeometry borderRadius;

  /// Border radius in collapsed state.
  final BorderRadiusGeometry collapsedBorderRadius;

  /// Custom shape border.
  final ShapeBorder? shape;

  /// Border outline.
  final BoxBorder? border;

  /// Gradient in expanded state.
  final Gradient? gradient;

  /// Gradient in collapsed state.
  final Gradient? scrolledGradient;

  /// Backdrop blur filter.
  final ImageFilter? blurFilter;

  /// Gaussian blur sigma for frosted glass effect.
  final double blurSigma;

  /// Overall opacity multiplier.
  final double opacity;

  /// Semi-transparent scrim color.
  final Color? overlayColor;

  /// Creates a copy with selectively replaced properties.
  AppearanceConfiguration copyWith({
    Color? backgroundColor,
    Color? collapsedBackgroundColor,
    Color? foregroundColor,
    double? elevation,
    double? scrolledElevation,
    Color? shadowColor,
    BorderRadiusGeometry? borderRadius,
    BorderRadiusGeometry? collapsedBorderRadius,
    ShapeBorder? shape,
    BoxBorder? border,
    Gradient? gradient,
    Gradient? scrolledGradient,
    ImageFilter? blurFilter,
    double? blurSigma,
    double? opacity,
    Color? overlayColor,
  }) {
    return AppearanceConfiguration(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      collapsedBackgroundColor: collapsedBackgroundColor ?? this.collapsedBackgroundColor,
      foregroundColor: foregroundColor ?? this.foregroundColor,
      elevation: elevation ?? this.elevation,
      scrolledElevation: scrolledElevation ?? this.scrolledElevation,
      shadowColor: shadowColor ?? this.shadowColor,
      borderRadius: borderRadius ?? this.borderRadius,
      collapsedBorderRadius: collapsedBorderRadius ?? this.collapsedBorderRadius,
      shape: shape ?? this.shape,
      border: border ?? this.border,
      gradient: gradient ?? this.gradient,
      scrolledGradient: scrolledGradient ?? this.scrolledGradient,
      blurFilter: blurFilter ?? this.blurFilter,
      blurSigma: blurSigma ?? this.blurSigma,
      opacity: opacity ?? this.opacity,
      overlayColor: overlayColor ?? this.overlayColor,
    );
  }
}

/// Mathematical spring physics parameters for interactive recoil and settle.
class SpringPhysicsSpec {
  /// Creates spring physics parameters.
  const SpringPhysicsSpec({
    this.stiffness = 250.0,
    this.damping = 20.0,
    this.mass = 1.0,
  });

  /// Spring stiffness constant k.
  final double stiffness;

  /// Damping coefficient c.
  final double damping;

  /// Inertial mass m.
  final double mass;
}

/// Maps input scroll offset domain to output animation progress.
class ScrollProgressMapping {
  /// Creates progress mapping.
  const ScrollProgressMapping({
    this.startOffset = 0.0,
    this.endOffset = 180.0,
    this.curve = Curves.linear,
  });

  /// Offset where transition begins.
  final double startOffset;

  /// Offset where transition completes.
  final double endOffset;

  /// Curve applied to the [0.0..1.0] progression.
  final Curve curve;

  /// Calculates clamped and curved progress for given [scrollOffset].
  double evaluate(double scrollOffset) {
    if (endOffset <= startOffset) return 1.0;
    final raw = ((scrollOffset - startOffset) / (endOffset - startOffset)).clamp(0.0, 1.0);
    return curve.transform(raw);
  }
}

/// Motion path interpolation trajectory.
enum MotionPathSpec {
  /// Linear straight-line interpolation.
  linear,

  /// Quadratic Bezier arc with focal control point.
  quadraticBezier,

  /// Cubic spline with smooth entry and exit tangents.
  cubicSpline,

  /// Polar orbital path around a focal center point.
  polarOrbit,
}

/// Policy for handling device reduced-motion accessibility preference.
enum ReducedMotionPolicy {
  /// Automatically disable non-essential motion and use accessible crossfades.
  accessibleFallback,

  /// Instantly jump between states without animated interpolation.
  instantJump,

  /// Preserve motion regardless of system setting.
  ignoreAccessibility,
}

/// Custom animation builder callback.
typedef CustomAnimationBuilder = Widget Function(
  BuildContext context,
  Animation<double> progress,
  Widget child,
);

/// Animation curves, durations, spring physics, and accessibility policies.
class MotionConfiguration {
  /// Creates motion configuration.
  const MotionConfiguration({
    this.duration = const Duration(milliseconds: 350),
    this.reverseDuration,
    this.delay = Duration.zero,
    this.curve = Curves.easeInOutCubic,
    this.reverseCurve,
    this.springPhysics = const SpringPhysicsSpec(),
    this.staggerInterval = Duration.zero,
    this.scrollMapping = const ScrollProgressMapping(),
    this.motionPath = MotionPathSpec.linear,
    this.reducedMotion = ReducedMotionPolicy.accessibleFallback,
    this.customAnimationBuilder,
  });

  /// Primary forward animation duration.
  final Duration duration;

  /// Reverse animation duration.
  final Duration? reverseDuration;

  /// Start delay.
  final Duration delay;

  /// Forward animation curve.
  final Curve curve;

  /// Reverse animation curve.
  final Curve? reverseCurve;

  /// Physical spring coefficients.
  final SpringPhysicsSpec springPhysics;

  /// Stagger interval between successive animated children.
  final Duration staggerInterval;

  /// Scroll offset to progress mapping curve.
  final ScrollProgressMapping scrollMapping;

  /// Geometric motion path trajectory.
  final MotionPathSpec motionPath;

  /// Accessibility reduced-motion handling policy.
  final ReducedMotionPolicy reducedMotion;

  /// Custom animation builder.
  final CustomAnimationBuilder? customAnimationBuilder;

  /// Creates a copy with selectively replaced properties.
  MotionConfiguration copyWith({
    Duration? duration,
    Duration? reverseDuration,
    Duration? delay,
    Curve? curve,
    Curve? reverseCurve,
    SpringPhysicsSpec? springPhysics,
    Duration? staggerInterval,
    ScrollProgressMapping? scrollMapping,
    MotionPathSpec? motionPath,
    ReducedMotionPolicy? reducedMotion,
    CustomAnimationBuilder? customAnimationBuilder,
  }) {
    return MotionConfiguration(
      duration: duration ?? this.duration,
      reverseDuration: reverseDuration ?? this.reverseDuration,
      delay: delay ?? this.delay,
      curve: curve ?? this.curve,
      reverseCurve: reverseCurve ?? this.reverseCurve,
      springPhysics: springPhysics ?? this.springPhysics,
      staggerInterval: staggerInterval ?? this.staggerInterval,
      scrollMapping: scrollMapping ?? this.scrollMapping,
      motionPath: motionPath ?? this.motionPath,
      reducedMotion: reducedMotion ?? this.reducedMotion,
      customAnimationBuilder: customAnimationBuilder ?? this.customAnimationBuilder,
    );
  }
}

/// Scrolling mechanics, pinning, snapping, pull gestures, and auto-hide.
class BehaviorConfiguration {
  /// Creates behavior configuration.
  const BehaviorConfiguration({
    this.collapsible = true,
    this.floating = false,
    this.pinned = true,
    this.snap = false,
    this.sticky = false,
    this.directionAwareAutoHide = false,
    this.autoHideVelocityThreshold = 180.0,
    this.autoHideHysteresis = 40.0,
    this.dragToExpand = false,
    this.dragSensitivity = 1.0,
    this.pullToExpand = false,
    this.overScrollStretch = 30.0,
    this.onRefresh,
    this.multiStageMilestones = const [],
    this.programmaticTransitionsEnabled = true,
  });

  /// Whether the header collapses on downward scroll.
  final bool collapsible;

  /// Whether the header floats into view when scrolling upward.
  final bool floating;

  /// Whether the collapsed toolbar remains pinned at the top.
  final bool pinned;

  /// Whether the header magnetically snaps between expanded/collapsed states.
  final bool snap;

  /// Whether secondary content tiers stick to the viewport top.
  final bool sticky;

  /// Whether the header hides on downward scroll and reveals on upward velocity.
  final bool directionAwareAutoHide;

  /// Velocity threshold in logical px/sec to trigger auto-hide.
  final double autoHideVelocityThreshold;

  /// Buffer distance preventing flicker when reversing scroll direction.
  final double autoHideHysteresis;

  /// Whether direct downward touch drag gestures can pull open the header.
  final bool dragToExpand;

  /// Drag sensitivity multiplier.
  final double dragSensitivity;

  /// Whether pulling past the top stretches the header with overscroll elastic bounce.
  final bool pullToExpand;

  /// Maximum overscroll stretch distance.
  final double overScrollStretch;

  /// Pull-to-refresh async callback.
  final Future<void> Function()? onRefresh;

  /// Fractional milestones for multi-stage transitions (e.g. `[0.3, 0.7, 1.0]`).
  final List<double> multiStageMilestones;

  /// Whether programmatic controller transitions are enabled.
  final bool programmaticTransitionsEnabled;

  /// Creates a copy with selectively replaced properties.
  BehaviorConfiguration copyWith({
    bool? collapsible,
    bool? floating,
    bool? pinned,
    bool? snap,
    bool? sticky,
    bool? directionAwareAutoHide,
    double? autoHideVelocityThreshold,
    double? autoHideHysteresis,
    bool? dragToExpand,
    double? dragSensitivity,
    bool? pullToExpand,
    double? overScrollStretch,
    Future<void> Function()? onRefresh,
    List<double>? multiStageMilestones,
    bool? programmaticTransitionsEnabled,
  }) {
    return BehaviorConfiguration(
      collapsible: collapsible ?? this.collapsible,
      floating: floating ?? this.floating,
      pinned: pinned ?? this.pinned,
      snap: snap ?? this.snap,
      sticky: sticky ?? this.sticky,
      directionAwareAutoHide: directionAwareAutoHide ?? this.directionAwareAutoHide,
      autoHideVelocityThreshold: autoHideVelocityThreshold ?? this.autoHideVelocityThreshold,
      autoHideHysteresis: autoHideHysteresis ?? this.autoHideHysteresis,
      dragToExpand: dragToExpand ?? this.dragToExpand,
      dragSensitivity: dragSensitivity ?? this.dragSensitivity,
      pullToExpand: pullToExpand ?? this.pullToExpand,
      overScrollStretch: overScrollStretch ?? this.overScrollStretch,
      onRefresh: onRefresh ?? this.onRefresh,
      multiStageMilestones: multiStageMilestones ?? this.multiStageMilestones,
      programmaticTransitionsEnabled: programmaticTransitionsEnabled ?? this.programmaticTransitionsEnabled,
    );
  }
}

/// Master configuration defining all parameters of an AppBar experience.
class AppBarConfiguration {
  /// Creates an AppBar configuration.
  const AppBarConfiguration({
    this.layout = const LayoutConfiguration(),
    this.content = const ContentConfiguration(),
    this.appearance = const AppearanceConfiguration(),
    this.motion = const MotionConfiguration(),
    this.behavior = const BehaviorConfiguration(),
    this.elements = const ElementOverrideConfiguration(),
    this.typedConfig,
  });

  /// Strongly-typed independent model configuration (Level 2 customization).
  final AppBarModelConfiguration? typedConfig;

  /// Minimal clean header preset.
  factory AppBarConfiguration.minimal({
    required String title,
    Widget? leading,
    List<Widget> actions = const [],
    Color? backgroundColor,
  }) {
    return AppBarConfiguration(
      layout: const LayoutConfiguration(
        expandedHeight: 64.0,
        collapsedHeight: 64.0,
      ),
      content: ContentConfiguration.text(
        title: title,
        leading: leading,
        actions: actions,
      ),
      appearance: AppearanceConfiguration(
        backgroundColor: backgroundColor,
      ),
      behavior: const BehaviorConfiguration(
        collapsible: false,
        pinned: true,
      ),
    );
  }

  /// Immersive hero media preset.
  factory AppBarConfiguration.hero({
    required Widget background,
    required String title,
    String? subtitle,
    double expandedHeight = 300.0,
    List<Widget> actions = const [],
  }) {
    return AppBarConfiguration(
      layout: LayoutConfiguration(
        expandedHeight: expandedHeight,
        collapsedHeight: 64.0,
      ),
      content: ContentConfiguration.text(
        title: title,
        subtitle: subtitle,
        background: background,
        actions: actions,
      ),
      behavior: const BehaviorConfiguration(
        collapsible: true,
        pinned: true,
        pullToExpand: true,
      ),
    );
  }

  /// Layout geometry and sizing.
  final LayoutConfiguration layout;

  /// Content widgets and slots.
  final ContentConfiguration content;

  /// Visual styling, colors, and shadows.
  final AppearanceConfiguration appearance;

  /// Motion, curves, and spring physics.
  final MotionConfiguration motion;

  /// Scroll mechanics, gestures, and auto-hide behaviors.
  final BehaviorConfiguration behavior;

  /// Granular element-level overrides.
  final ElementOverrideConfiguration elements;

  /// Creates a copy with selectively replaced sub-configurations.
  AppBarConfiguration copyWith({
    LayoutConfiguration? layout,
    ContentConfiguration? content,
    AppearanceConfiguration? appearance,
    MotionConfiguration? motion,
    BehaviorConfiguration? behavior,
    ElementOverrideConfiguration? elements,
  }) {
    return AppBarConfiguration(
      layout: layout ?? this.layout,
      content: content ?? this.content,
      appearance: appearance ?? this.appearance,
      motion: motion ?? this.motion,
      behavior: behavior ?? this.behavior,
      elements: elements ?? this.elements,
    );
  }
}

/// Fully resolved, immutable configuration with all themes and overrides applied.
class ResolvedAppBarConfiguration {
  /// Creates a resolved configuration snapshot.
  const ResolvedAppBarConfiguration({
    required this.layout,
    required this.content,
    required this.appearance,
    required this.motion,
    required this.behavior,
    required this.elements,
    this.typedConfig,
  });

  /// Optional strongly-typed model configuration.
  final AppBarModelConfiguration? typedConfig;

  /// Resolved layout configuration.
  final LayoutConfiguration layout;

  /// Resolved content configuration.
  final ContentConfiguration content;

  /// Resolved appearance configuration.
  final AppearanceConfiguration appearance;

  /// Resolved motion configuration.
  final MotionConfiguration motion;

  /// Resolved behavior configuration.
  final BehaviorConfiguration behavior;

  /// Resolved element override configuration.
  final ElementOverrideConfiguration elements;
}

