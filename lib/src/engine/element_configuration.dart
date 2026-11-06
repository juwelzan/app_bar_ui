import 'package:flutter/material.dart';

/// Defines how an individual element behaves regarding visibility as scroll progress changes.
enum ElementVisibility {
  /// Adapts automatically based on the model's design paradigm.
  adaptive,

  /// Always visible regardless of scroll progress.
  always,

  /// Visible only when the header is expanded; fades/slides away during collapse.
  expandedOnly,

  /// Visible only when the header is collapsed/docked; hidden in expanded state.
  collapsedOnly,

  /// Fades smoothly as scroll progress advances from 0.0 to 1.0.
  scrollFade,

  /// Hidden completely.
  hidden,
}

/// Positioning parameters for an individual element.
class ElementPositionSpec {
  /// Creates an element positioning specification.
  const ElementPositionSpec({
    this.alignment = Alignment.center,
    this.offset = Offset.zero,
    this.anchor,
    this.zIndex = 0,
  });

  /// Base alignment within its container or slot.
  final AlignmentGeometry alignment;

  /// Absolute or relative offset.
  final Offset offset;

  /// Optional fractional anchor position [0.0..1.0].
  final Alignment? anchor;

  /// Visual stacking layer order.
  final int zIndex;
}

/// Animation behavior and parameter overrides for an individual element.
class ElementAnimationSpec {
  /// Creates an element animation specification.
  const ElementAnimationSpec({
    this.fadeOnScroll = true,
    this.scaleRange,
    this.slideOffset,
    this.rotationRange,
    this.duration,
    this.curve = Curves.easeInOut,
    this.reverseCurve,
    this.delay = Duration.zero,
  });

  /// Whether the element fades in/out based on scroll progress.
  final bool fadeOnScroll;

  /// Scale interpolation range (e.g. Tween(begin: 1.0, end: 0.8)).
  final Tween<double>? scaleRange;

  /// Directional slide translation offset.
  final Offset? slideOffset;

  /// Rotation angle range in radians.
  final Tween<double>? rotationRange;

  /// Optional custom duration overriding the global motion duration.
  final Duration? duration;

  /// Animation curve.
  final Curve curve;

  /// Reverse animation curve.
  final Curve? reverseCurve;

  /// Delay before animating.
  final Duration delay;
}

/// Interactive gestures and haptics for an individual element.
class ElementInteractionSpec {
  /// Creates an element interaction specification.
  const ElementInteractionSpec({
    this.onTap,
    this.onDoubleTap,
    this.onLongPress,
    this.enableHaptics = true,
    this.hitTestBehavior = HitTestBehavior.opaque,
  });

  /// Tap callback.
  final VoidCallback? onTap;

  /// Double tap callback.
  final VoidCallback? onDoubleTap;

  /// Long press callback.
  final VoidCallback? onLongPress;

  /// Whether to trigger subtle platform haptic feedback on interaction.
  final bool enableHaptics;

  /// Hit testing behavior.
  final HitTestBehavior hitTestBehavior;
}

/// Accessibility semantics for an individual element.
class ElementSemanticsSpec {
  /// Creates semantics specification.
  const ElementSemanticsSpec({
    this.label,
    this.hint,
    this.isButton = false,
    this.isHeader = false,
  });

  /// Accessibility label read by screen readers.
  final String? label;

  /// Action hint.
  final String? hint;

  /// Marks element as a clickable button in accessibility tree.
  final bool isButton;

  /// Marks element as an accessible section header.
  final bool isHeader;
}

/// Real-time state provided to element builder callbacks.
class ElementState {
  /// Creates an element state snapshot.
  const ElementState({
    required this.progress,
    required this.isCollapsed,
    required this.isExpanded,
    this.effectiveColor,
    this.availableSize,
  });

  /// Current scroll collapse progress in [0.0..1.0].
  final double progress;

  /// Whether the header is fully collapsed/pinned.
  final bool isCollapsed;

  /// Whether the header is fully expanded.
  final bool isExpanded;

  /// Effective color based on current appearance and scroll interpolation.
  final Color? effectiveColor;

  /// Current available layout size for this element.
  final Size? availableSize;
}

/// Builder callback to replace or customize an element's rendering completely.
typedef ElementWidgetBuilder = Widget Function(BuildContext context, ElementState state);

/// Fine-grained configuration for an individual AppBar UI element.
class ElementConfiguration {
  /// Creates a configuration for an individual element.
  const ElementConfiguration({
    this.visibility = ElementVisibility.adaptive,
    this.position,
    this.size,
    this.alignment,
    this.padding,
    this.margin,
    this.color,
    this.opacity,
    this.scale,
    this.rotation,
    this.translation,
    this.border,
    this.shape,
    this.animation,
    this.interaction,
    this.semantics,
    this.builder,
  });

  /// Element visibility rule.
  final ElementVisibility visibility;

  /// Geometric position and layer order.
  final ElementPositionSpec? position;

  /// Explicit element size.
  final Size? size;

  /// Element alignment.
  final AlignmentGeometry? alignment;

  /// Inner padding.
  final EdgeInsetsGeometry? padding;

  /// Outer margin.
  final EdgeInsetsGeometry? margin;

  /// Element tint or foreground color.
  final Color? color;

  /// Static or baseline opacity.
  final double? opacity;

  /// Static or baseline scale factor.
  final double? scale;

  /// Static or baseline rotation angle in radians.
  final double? rotation;

  /// Static or baseline translation offset.
  final Offset? translation;

  /// Box border around element.
  final BoxBorder? border;

  /// Shape border around element.
  final ShapeBorder? shape;

  /// Element-specific animation settings.
  final ElementAnimationSpec? animation;

  /// Element gesture interaction handlers.
  final ElementInteractionSpec? interaction;

  /// Element accessibility semantics.
  final ElementSemanticsSpec? semantics;

  /// Custom widget builder callback overriding the element completely.
  final ElementWidgetBuilder? builder;

  /// Creates a copy with selectively replaced properties.
  ElementConfiguration copyWith({
    ElementVisibility? visibility,
    ElementPositionSpec? position,
    Size? size,
    AlignmentGeometry? alignment,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    Color? color,
    double? opacity,
    double? scale,
    double? rotation,
    Offset? translation,
    BoxBorder? border,
    ShapeBorder? shape,
    ElementAnimationSpec? animation,
    ElementInteractionSpec? interaction,
    ElementSemanticsSpec? semantics,
    ElementWidgetBuilder? builder,
  }) {
    return ElementConfiguration(
      visibility: visibility ?? this.visibility,
      position: position ?? this.position,
      size: size ?? this.size,
      alignment: alignment ?? this.alignment,
      padding: padding ?? this.padding,
      margin: margin ?? this.margin,
      color: color ?? this.color,
      opacity: opacity ?? this.opacity,
      scale: scale ?? this.scale,
      rotation: rotation ?? this.rotation,
      translation: translation ?? this.translation,
      border: border ?? this.border,
      shape: shape ?? this.shape,
      animation: animation ?? this.animation,
      interaction: interaction ?? this.interaction,
      semantics: semantics ?? this.semantics,
      builder: builder ?? this.builder,
    );
  }
}

/// Collection of element-level overrides for an AppBar.
class ElementOverrideConfiguration {
  /// Creates a collection of element overrides.
  const ElementOverrideConfiguration({
    this.leading,
    this.title,
    this.subtitle,
    this.avatar,
    this.searchField,
    this.actions,
    this.navigationControls,
    this.tabs,
    this.background,
    this.foreground,
    this.decorative,
    this.expandedContent,
    this.collapsedContent,
    this.customElementOverrides = const {},
  });

  /// Override for leading icon / navigation button.
  final ElementConfiguration? leading;

  /// Override for main title text / widget.
  final ElementConfiguration? title;

  /// Override for subtitle.
  final ElementConfiguration? subtitle;

  /// Override for user avatar or profile icon.
  final ElementConfiguration? avatar;

  /// Override for search input field.
  final ElementConfiguration? searchField;

  /// Override for action buttons.
  final ElementConfiguration? actions;

  /// Override for navigation controls (e.g. segmented buttons, crumbs).
  final ElementConfiguration? navigationControls;

  /// Override for tab bar.
  final ElementConfiguration? tabs;

  /// Override for background layer.
  final ElementConfiguration? background;

  /// Override for foreground layer.
  final ElementConfiguration? foreground;

  /// Override for decorative visual accents.
  final ElementConfiguration? decorative;

  /// Override for expanded hero area content.
  final ElementConfiguration? expandedContent;

  /// Override for collapsed pinned toolbar content.
  final ElementConfiguration? collapsedContent;

  /// Named custom element overrides.
  final Map<String, ElementConfiguration> customElementOverrides;

  /// Creates a copy with selectively replaced element overrides.
  ElementOverrideConfiguration copyWith({
    ElementConfiguration? leading,
    ElementConfiguration? title,
    ElementConfiguration? subtitle,
    ElementConfiguration? avatar,
    ElementConfiguration? searchField,
    ElementConfiguration? actions,
    ElementConfiguration? navigationControls,
    ElementConfiguration? tabs,
    ElementConfiguration? background,
    ElementConfiguration? foreground,
    ElementConfiguration? decorative,
    ElementConfiguration? expandedContent,
    ElementConfiguration? collapsedContent,
    Map<String, ElementConfiguration>? customElementOverrides,
  }) {
    return ElementOverrideConfiguration(
      leading: leading ?? this.leading,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      avatar: avatar ?? this.avatar,
      searchField: searchField ?? this.searchField,
      actions: actions ?? this.actions,
      navigationControls: navigationControls ?? this.navigationControls,
      tabs: tabs ?? this.tabs,
      background: background ?? this.background,
      foreground: foreground ?? this.foreground,
      decorative: decorative ?? this.decorative,
      expandedContent: expandedContent ?? this.expandedContent,
      collapsedContent: collapsedContent ?? this.collapsedContent,
      customElementOverrides: customElementOverrides ?? this.customElementOverrides,
    );
  }
}

