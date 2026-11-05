import 'package:flutter/material.dart';

import '../models/scroll_responsive_config.dart';

/// A pinned action button supporting seamless dual-state transitions (e.g.
/// Profile Avatar -> Drawer Button or Notification -> Profile Avatar).
///
/// Features:
/// - Fixed touch target dimensions ([touchTargetSize]) to completely prevent layout shifts.
/// - Completely transparent background with zero elevation, shadow, borders, or blur.
/// - Synchronized fade, scale, and slide transitions based on scroll progress.
/// - Accurate hit-testing switching at the 50% transition midpoint.
class PinnedActionButton extends StatelessWidget {
  /// Creates a pinned action button.
  const PinnedActionButton({
    super.key,
    this.initialWidget,
    this.scrolledWidget,
    required this.progress,
    this.onInitialTap,
    this.onScrolledTap,
    this.animationConfig = const ScrollAnimationConfig(),
    this.touchTargetSize = const Size(48.0, 48.0),
    this.alignment = Alignment.center,
    this.semanticLabelInitial,
    this.semanticLabelScrolled,
  });

  /// The widget displayed initially before scrolling (e.g. Profile Avatar or Notification).
  final Widget? initialWidget;

  /// The widget displayed after scrolling past the threshold (e.g. Drawer Button or Profile Avatar).
  final Widget? scrolledWidget;

  /// Normalized scroll progress from 0.0 (initial state) to 1.0 (scrolled state).
  final double progress;

  /// Callback executed when tapping the action in the initial state (progress < 0.5).
  final VoidCallback? onInitialTap;

  /// Callback executed when tapping the action in the scrolled state (progress >= 0.5).
  final VoidCallback? onScrolledTap;

  /// Configuration for animations (duration, curve, scales, slide offsets).
  final ScrollAnimationConfig animationConfig;

  /// Touch target dimensions (minimum 48x48 recommended for accessibility).
  final Size touchTargetSize;

  /// Alignment within the touch target bounding box.
  final Alignment alignment;

  /// Semantic label for accessibility in the initial state.
  final String? semanticLabelInitial;

  /// Semantic label for accessibility in the scrolled state.
  final String? semanticLabelScrolled;

  @override
  Widget build(BuildContext context) {
    if (initialWidget == null && scrolledWidget == null) {
      return SizedBox(
        width: touchTargetSize.width,
        height: touchTargetSize.height,
      );
    }

    // Clamp progress safely to [0.0, 1.0]
    final double clampedProgress = progress.clamp(0.0, 1.0);
    final double curvedProgress = animationConfig.curve.transform(
      clampedProgress,
    );

    final bool isScrolledActive = clampedProgress >= 0.5;
    final VoidCallback? activeCallback = isScrolledActive
        ? onScrolledTap
        : onInitialTap;
    final String? activeSemanticLabel = isScrolledActive
        ? semanticLabelScrolled
        : semanticLabelInitial;

    return Semantics(
      button: true,
      label: activeSemanticLabel,
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          onTap: activeCallback,
          customBorder: const CircleBorder(),
          splashColor: Colors.black12,
          highlightColor: Colors.transparent,
          child: Container(
            width: touchTargetSize.width,
            height: touchTargetSize.height,
            alignment: alignment,
            decoration: const BoxDecoration(
              color: Colors.transparent,
              boxShadow: [], // Explicitly no shadow
            ),
            child: Stack(
              alignment: alignment,
              fit: StackFit.expand,
              children: [
                if (initialWidget != null)
                  _buildTransitionLayer(
                    child: initialWidget!,
                    visibilityFactor: 1.0 - curvedProgress,
                    slideDirection: -1.0, // Slides slightly upward on exit
                    isHitTestable: !isScrolledActive,
                  ),
                if (scrolledWidget != null)
                  _buildTransitionLayer(
                    child: scrolledWidget!,
                    visibilityFactor: curvedProgress,
                    slideDirection: 1.0, // Slides from slightly bottom on entry
                    isHitTestable: isScrolledActive,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTransitionLayer({
    required Widget child,
    required double visibilityFactor,
    required double slideDirection,
    required bool isHitTestable,
  }) {
    final double opacity = animationConfig.enableFade
        ? visibilityFactor.clamp(0.0, 1.0)
        : 1.0;

    final double scale = animationConfig.enableScale
        ? animationConfig.minScale +
              (animationConfig.maxScale - animationConfig.minScale) *
                  visibilityFactor
        : 1.0;

    final Offset translation = animationConfig.enableSlide
        ? Offset(
            animationConfig.slideOffset.dx *
                (1.0 - visibilityFactor) *
                slideDirection,
            animationConfig.slideOffset.dy *
                (1.0 - visibilityFactor) *
                slideDirection,
          )
        : Offset.zero;

    Widget result = child;

    if (animationConfig.enableSlide && translation != Offset.zero) {
      result = FractionalTranslation(translation: translation, child: result);
    }

    if (animationConfig.enableScale && scale != 1.0) {
      result = Transform.scale(
        scale: scale,
        alignment: alignment,
        child: result,
      );
    }

    if (animationConfig.enableFade) {
      result = Opacity(opacity: opacity, child: result);
    }

    return IgnorePointer(
      ignoring: !isHitTestable,
      child: Center(child: result),
    );
  }
}
