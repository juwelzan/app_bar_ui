import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Morphs fluidly between [initialChild] and [scrolledChild] as scroll progress advances.
///
/// Ideal for avatar transformations, title-to-icon collapses, and transforming indicators.
class ScrollMorphBuilder extends StatelessWidget {
  /// Creates a [ScrollMorphBuilder] widget.
  const ScrollMorphBuilder({
    super.key,
    required this.progressListenable,
    required this.initialChild,
    required this.scrolledChild,
    this.switchPoint = 0.5,
    this.curve = Curves.easeInOut,
    this.enableScale = true,
    this.enableFade = true,
    this.enableSlide = true,
    this.slideOffset = const Offset(0.0, 0.15),
    this.alignment = Alignment.center,
  }) : assert(
         switchPoint > 0.0 && switchPoint < 1.0,
         'switchPoint must be between 0.0 and 1.0.',
       );

  /// The [ValueListenable] emitting normalized progress (0.0 = initial, 1.0 = scrolled).
  final ValueListenable<double> progressListenable;

  /// The child shown in the initial state (progress < [switchPoint]).
  final Widget initialChild;

  /// The child shown in the scrolled state (progress >= [switchPoint]).
  final Widget scrolledChild;

  /// Progress boundary where active hit-testing and primary visibility switch.
  final double switchPoint;

  /// Animation easing curve.
  final Curve curve;

  /// Whether scale zoom is enabled during transition.
  final bool enableScale;

  /// Whether cross-fade is enabled during transition.
  final bool enableFade;

  /// Whether subtle vertical slide is enabled during transition.
  final bool enableSlide;

  /// Translation offset applied during entry/exit.
  final Offset slideOffset;

  /// Alignment within the container.
  final Alignment alignment;

  @override
  Widget build(BuildContext context) {
    final bool disableMotion =
        MediaQuery.maybeDisableAnimationsOf(context) == true;

    return ValueListenableBuilder<double>(
      valueListenable: progressListenable,
      builder: (context, progress, _) {
        final clamped = progress.clamp(0.0, 1.0);
        final curved = curve.transform(clamped);
        final isScrolledActive = clamped >= switchPoint;

        return Stack(
          alignment: alignment,
          children: [
            // Initial layer
            IgnorePointer(
              ignoring: isScrolledActive,
              child: _buildLayer(
                child: initialChild,
                visibility: 1.0 - curved,
                slideDirection: -1.0,
                disableMotion: disableMotion,
              ),
            ),
            // Scrolled layer
            IgnorePointer(
              ignoring: !isScrolledActive,
              child: _buildLayer(
                child: scrolledChild,
                visibility: curved,
                slideDirection: 1.0,
                disableMotion: disableMotion,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildLayer({
    required Widget child,
    required double visibility,
    required double slideDirection,
    required bool disableMotion,
  }) {
    Widget result = child;

    if (enableSlide && !disableMotion && slideOffset != Offset.zero) {
      final translation = Offset(
        slideOffset.dx * (1.0 - visibility) * slideDirection,
        slideOffset.dy * (1.0 - visibility) * slideDirection,
      );
      result = FractionalTranslation(
        translation: translation,
        child: result,
      );
    }

    if (enableScale && !disableMotion) {
      final scale = 0.75 + (0.25 * visibility);
      result = Transform.scale(
        scale: scale,
        alignment: alignment,
        child: result,
      );
    }

    if (enableFade) {
      result = Opacity(
        opacity: visibility.clamp(0.0, 1.0),
        child: result,
      );
    }

    return result;
  }
}
