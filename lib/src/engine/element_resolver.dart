import 'package:flutter/material.dart';

import 'element_configuration.dart';

/// Helper utility for resolving, transforming, and animating individual elements
/// based on developer-provided [ElementConfiguration] overrides.
class ElementResolver {
  const ElementResolver._();

  /// Resolves an element widget by applying visibility rules, custom builders,
  /// geometric styling, gestures, and animations.
  static Widget resolve({
    required BuildContext context,
    required Widget? defaultWidget,
    required ElementConfiguration? elementConfig,
    required double progress,
    Color? fallbackColor,
    Size? availableSize,
  }) {
    // If no widget and no custom builder, render nothing
    if (defaultWidget == null && elementConfig?.builder == null) {
      return const SizedBox.shrink();
    }

    final isCollapsed = progress >= 0.99;
    final isExpanded = progress <= 0.01;

    // Check visibility rule
    if (elementConfig != null) {
      switch (elementConfig.visibility) {
        case ElementVisibility.hidden:
          return const SizedBox.shrink();
        case ElementVisibility.expandedOnly:
          if (progress > 0.6) return const SizedBox.shrink();
          break;
        case ElementVisibility.collapsedOnly:
          if (progress < 0.4) return const SizedBox.shrink();
          break;
        case ElementVisibility.scrollFade:
          // Will be faded below via opacity
          break;
        case ElementVisibility.always:
        case ElementVisibility.adaptive:
          break;
      }
    }

    final elementState = ElementState(
      progress: progress,
      isCollapsed: isCollapsed,
      isExpanded: isExpanded,
      effectiveColor: elementConfig?.color ?? fallbackColor,
      availableSize: availableSize,
    );

    // 1. Build base widget (builder override or default)
    Widget child = elementConfig?.builder != null
        ? elementConfig!.builder!(context, elementState)
        : defaultWidget!;

    if (elementConfig == null) {
      return child;
    }

    // 2. Element-level interaction & gestures
    if (elementConfig.interaction != null) {
      final interaction = elementConfig.interaction!;
      child = GestureDetector(
        behavior: interaction.hitTestBehavior,
        onTap: () {
          if (interaction.enableHaptics) {
            Feedback.forTap(context);
          }
          interaction.onTap?.call();
        },
        onDoubleTap: interaction.onDoubleTap,
        onLongPress: () {
          if (interaction.enableHaptics) {
            Feedback.forLongPress(context);
          }
          interaction.onLongPress?.call();
        },
        child: child,
      );
    }

    // 3. Size constraints
    if (elementConfig.size != null) {
      child = SizedBox(
        width: elementConfig.size!.width,
        height: elementConfig.size!.height,
        child: child,
      );
    }

    // 4. Alignment
    if (elementConfig.alignment != null) {
      child = Align(
        alignment: elementConfig.alignment!,
        child: child,
      );
    }

    // 5. Padding
    if (elementConfig.padding != null) {
      child = Padding(
        padding: elementConfig.padding!,
        child: child,
      );
    }

    // 6. Margin
    if (elementConfig.margin != null) {
      child = Padding(
        padding: elementConfig.margin!,
        child: child,
      );
    }

    // 7. Opacity and Fade on scroll
    double effectiveOpacity = elementConfig.opacity ?? 1.0;
    if (elementConfig.visibility == ElementVisibility.scrollFade) {
      effectiveOpacity *= (1.0 - progress).clamp(0.0, 1.0);
    } else if (elementConfig.animation?.fadeOnScroll == true) {
      // Smooth fade transition
      if (elementConfig.visibility == ElementVisibility.expandedOnly) {
        effectiveOpacity *= (1.0 - progress / 0.6).clamp(0.0, 1.0);
      } else if (elementConfig.visibility == ElementVisibility.collapsedOnly) {
        effectiveOpacity *= ((progress - 0.4) / 0.6).clamp(0.0, 1.0);
      }
    }

    if (effectiveOpacity < 0.999) {
      child = Opacity(
        opacity: effectiveOpacity.clamp(0.0, 1.0),
        child: child,
      );
    }

    // 8. Scale
    double effectiveScale = elementConfig.scale ?? 1.0;
    if (elementConfig.animation?.scaleRange != null) {
      effectiveScale = elementConfig.animation!.scaleRange!.transform(progress);
    }
    if ((effectiveScale - 1.0).abs() > 0.001) {
      child = Transform.scale(
        scale: effectiveScale,
        alignment: Alignment.center,
        child: child,
      );
    }

    // 9. Rotation
    double effectiveRotation = elementConfig.rotation ?? 0.0;
    if (elementConfig.animation?.rotationRange != null) {
      effectiveRotation = elementConfig.animation!.rotationRange!.transform(progress);
    }
    if (effectiveRotation.abs() > 0.001) {
      child = Transform.rotate(
        angle: effectiveRotation,
        alignment: Alignment.center,
        child: child,
      );
    }

    // 10. Translation
    Offset effectiveTranslation = elementConfig.translation ?? Offset.zero;
    if (elementConfig.animation?.slideOffset != null) {
      effectiveTranslation += elementConfig.animation!.slideOffset! * progress;
    }
    if (effectiveTranslation != Offset.zero) {
      child = Transform.translate(
        offset: effectiveTranslation,
        child: child,
      );
    }

    // 11. Semantics
    if (elementConfig.semantics != null) {
      final semantics = elementConfig.semantics!;
      child = Semantics(
        label: semantics.label,
        hint: semantics.hint,
        button: semantics.isButton,
        header: semantics.isHeader,
        child: child,
      );
    }

    return child;
  }
}

