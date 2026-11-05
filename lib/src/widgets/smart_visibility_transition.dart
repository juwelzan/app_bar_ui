import 'package:flutter/material.dart';

import '../engine/smart_visibility_controller.dart';
import '../models/visibility_config.dart';

/// Supported transition types for [SmartVisibilityTransition].
enum VisibilityTransitionType {
  /// Cross-fades opacity between 0.0 and 1.0.
  fade,

  /// Scales size between 0.0 and 1.0.
  scale,

  /// Slides offset along configured [slideOffset].
  slide,

  /// Combined scale and fade transition.
  scaleAndFade,

  /// Combined slide and fade transition.
  slideAndFade,
}

/// A declarative transition widget that binds an arbitrary child widget to a
/// [SmartVisibilityController] and [VisibilityTarget].
///
/// Automatically retrieves animation duration and curve from the target's [VisibilityRule],
/// suppresses phantom hit tests when hidden via [IgnorePointer], and respects
/// accessibility reduced-motion preferences.
class SmartVisibilityTransition extends StatelessWidget {
  /// Creates a [SmartVisibilityTransition] widget.
  const SmartVisibilityTransition({
    super.key,
    required this.controller,
    required this.target,
    required this.child,
    this.transition = VisibilityTransitionType.fade,
    this.slideOffset,
    this.duration,
    this.curve,
    this.alignment = Alignment.center,
  });

  /// The visibility controller managing target state.
  final SmartVisibilityController controller;

  /// The visibility target this widget represents.
  final VisibilityTarget target;

  /// The child widget to show and hide.
  final Widget child;

  /// Visual transition type. Defaults to [VisibilityTransitionType.fade].
  final VisibilityTransitionType transition;

  /// Directional slide offset when hidden. If omitted, infers based on target type
  /// (e.g. slides up for header, down for bottom bar).
  final Offset? slideOffset;

  /// Optional duration override. Defaults to target's [VisibilityRule.duration].
  final Duration? duration;

  /// Optional curve override. Defaults to target's [VisibilityRule.curve].
  final Curve? curve;

  /// Alignment for scale transformations. Defaults to [Alignment.center].
  final Alignment alignment;

  Offset _resolveDefaultSlideOffset() {
    if (slideOffset != null) return slideOffset!;
    switch (target) {
      case VisibilityTarget.header:
      case VisibilityTarget.statusBar:
        return const Offset(0.0, -1.2);
      case VisibilityTarget.bottomNavigationBar:
        return const Offset(0.0, 1.2);
      case VisibilityTarget.leftAction:
        return const Offset(-1.5, 0.0);
      case VisibilityTarget.rightAction:
      case VisibilityTarget.floatingActionButton:
        return const Offset(1.5, 0.0);
      case VisibilityTarget.stickyTab:
        return const Offset(0.0, -1.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    final rule = controller.config.getRule(target);
    final effectiveDuration = duration ?? rule.duration;
    final effectiveCurve = curve ?? rule.curve;
    final effectiveSlide = _resolveDefaultSlideOffset();

    final bool disableMotion =
        MediaQuery.maybeDisableAnimationsOf(context) == true;

    return ValueListenableBuilder<double>(
      valueListenable: controller.visibilityNotifier(target),
      builder: (context, visibility, _) {
        final bool isVisible = visibility > 0.5;
        final double effectiveOpacity = visibility.clamp(0.0, 1.0);
        final double effectiveScale = isVisible ? 1.0 : 0.0;
        final Offset effectiveOffset = isVisible ? Offset.zero : effectiveSlide;

        Widget current = child;

        if (disableMotion) {
          // In reduced motion, instantaneously switch visibility
          return Visibility(
            visible: isVisible,
            maintainState: true,
            child: current,
          );
        }

        switch (transition) {
          case VisibilityTransitionType.fade:
            current = AnimatedOpacity(
              opacity: effectiveOpacity,
              duration: effectiveDuration,
              curve: effectiveCurve,
              child: current,
            );
            break;
          case VisibilityTransitionType.scale:
            current = AnimatedScale(
              scale: effectiveScale,
              duration: effectiveDuration,
              curve: effectiveCurve,
              alignment: alignment,
              child: current,
            );
            break;
          case VisibilityTransitionType.slide:
            current = AnimatedSlide(
              offset: effectiveOffset,
              duration: effectiveDuration,
              curve: effectiveCurve,
              child: current,
            );
            break;
          case VisibilityTransitionType.scaleAndFade:
            current = AnimatedScale(
              scale: effectiveScale,
              duration: effectiveDuration,
              curve: effectiveCurve,
              alignment: alignment,
              child: AnimatedOpacity(
                opacity: effectiveOpacity,
                duration: effectiveDuration,
                curve: effectiveCurve,
                child: current,
              ),
            );
            break;
          case VisibilityTransitionType.slideAndFade:
            current = AnimatedSlide(
              offset: effectiveOffset,
              duration: effectiveDuration,
              curve: effectiveCurve,
              child: AnimatedOpacity(
                opacity: effectiveOpacity,
                duration: effectiveDuration,
                curve: effectiveCurve,
                child: current,
              ),
            );
            break;
        }

        return IgnorePointer(ignoring: !isVisible, child: current);
      },
    );
  }
}
