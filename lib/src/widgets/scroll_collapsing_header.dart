import 'package:flutter/material.dart';

/// A customizable collapsing sliver header that smoothly transitions from
/// [expandedHeight] down to [collapsedHeight] as the user scrolls.
///
/// Supports:
/// - Pinned sticky collapse or floating auto-reveal
/// - Parallax background movement via [parallaxFactor]
/// - Smooth content cross-fading from flexible space to collapsed toolbar
/// - Custom builder functions for complete layout control
/// - Transparent floating headers with zero elevation
class ScrollCollapsingHeader extends StatelessWidget {
  /// Creates a standard [ScrollCollapsingHeader] widget.
  const ScrollCollapsingHeader({
    super.key,
    this.expandedHeight = 200.0,
    this.collapsedHeight = kToolbarHeight,
    this.pinned = true,
    this.floating = false,
    this.parallaxFactor = 0.0,
    this.builder,
    this.flexibleSpace,
    this.collapsedTitle,
    this.collapsedLeading,
    this.collapsedActions,
    this.backgroundColor,
    this.collapsedBackgroundColor,
    this.elevation = 0.0,
    this.scrolledElevation = 4.0,
    this.curve = Curves.easeInOut,
  }) : assert(
         expandedHeight >= collapsedHeight,
         'expandedHeight ($expandedHeight) must be >= collapsedHeight ($collapsedHeight).',
       );

  /// Creates a transparent floating header that floats back into view upon reverse scroll
  /// without pinning permanently.
  const ScrollCollapsingHeader.transparentFloating({
    super.key,
    this.expandedHeight = 180.0,
    this.collapsedHeight = kToolbarHeight,
    this.parallaxFactor = 0.0,
    this.builder,
    this.flexibleSpace,
    this.collapsedTitle,
    this.collapsedLeading,
    this.collapsedActions,
    this.curve = Curves.easeOut,
  }) : pinned = false,
       floating = true,
       backgroundColor = Colors.transparent,
       collapsedBackgroundColor = Colors.transparent,
       elevation = 0.0,
       scrolledElevation = 0.0,
       assert(
         expandedHeight >= collapsedHeight,
         'expandedHeight ($expandedHeight) must be >= collapsedHeight ($collapsedHeight).',
       );

  /// Creates a collapsing header with built-in parallax background movement.
  const ScrollCollapsingHeader.parallax({
    super.key,
    this.expandedHeight = 240.0,
    this.collapsedHeight = kToolbarHeight,
    this.pinned = true,
    this.floating = false,
    this.parallaxFactor = 0.5,
    required Widget background,
    this.collapsedTitle,
    this.collapsedLeading,
    this.collapsedActions,
    this.backgroundColor,
    this.collapsedBackgroundColor,
    this.elevation = 0.0,
    this.scrolledElevation = 4.0,
    this.curve = Curves.easeInOut,
  }) : builder = null,
       flexibleSpace = background,
       assert(
         expandedHeight >= collapsedHeight,
         'expandedHeight ($expandedHeight) must be >= collapsedHeight ($collapsedHeight).',
       );

  /// Height when fully expanded. Defaults to 200.0.
  final double expandedHeight;

  /// Height when fully collapsed. Defaults to [kToolbarHeight] (56.0).
  final double collapsedHeight;

  /// Whether the collapsed header remains pinned at the top. Defaults to `true`.
  final bool pinned;

  /// Whether the header floats back into view immediately upon reverse scrolling. Defaults to `false`.
  final bool floating;

  /// Parallax speed factor for [flexibleSpace] ($0.0$ = moves naturally, $0.5$ = moves at half speed).
  final double parallaxFactor;

  /// Optional custom builder receiving the [collapseProgress] (0.0 = fully expanded, 1.0 = fully collapsed).
  final Widget Function(BuildContext context, double collapseProgress)? builder;

  /// Widget rendered in the background of the expanded space (e.g., banner image, gradient).
  final Widget? flexibleSpace;

  /// Title widget displayed in the collapsed toolbar as it reaches full collapse.
  final Widget? collapsedTitle;

  /// Leading widget displayed in the collapsed toolbar (e.g., back button).
  final Widget? collapsedLeading;

  /// Action widgets displayed on the trailing end of the collapsed toolbar.
  final List<Widget>? collapsedActions;

  /// Background color when fully expanded. Defaults to theme's scaffold background.
  final Color? backgroundColor;

  /// Background color when fully collapsed.
  final Color? collapsedBackgroundColor;

  /// Elevation when fully expanded. Defaults to 0.0.
  final double elevation;

  /// Elevation when collapsed or overlapping content. Defaults to 4.0.
  final double scrolledElevation;

  /// Animation easing curve applied to [collapseProgress].
  final Curve curve;

  @override
  Widget build(BuildContext context) {
    return SliverPersistentHeader(
      pinned: pinned,
      floating: floating,
      delegate: _ScrollCollapsingHeaderDelegate(
        expandedHeight: expandedHeight,
        collapsedHeight: collapsedHeight,
        parallaxFactor: parallaxFactor,
        builder: builder,
        flexibleSpace: flexibleSpace,
        collapsedTitle: collapsedTitle,
        collapsedLeading: collapsedLeading,
        collapsedActions: collapsedActions,
        backgroundColor:
            backgroundColor ?? Theme.of(context).scaffoldBackgroundColor,
        collapsedBackgroundColor:
            collapsedBackgroundColor ??
            Theme.of(context).appBarTheme.backgroundColor ??
            Theme.of(context).colorScheme.surface,
        elevation: elevation,
        scrolledElevation: scrolledElevation,
        curve: curve,
      ),
    );
  }
}

class _ScrollCollapsingHeaderDelegate extends SliverPersistentHeaderDelegate {
  _ScrollCollapsingHeaderDelegate({
    required this.expandedHeight,
    required this.collapsedHeight,
    required this.parallaxFactor,
    this.builder,
    this.flexibleSpace,
    this.collapsedTitle,
    this.collapsedLeading,
    this.collapsedActions,
    required this.backgroundColor,
    required this.collapsedBackgroundColor,
    required this.elevation,
    required this.scrolledElevation,
    required this.curve,
  });

  final double expandedHeight;
  final double collapsedHeight;
  final double parallaxFactor;
  final Widget Function(BuildContext context, double collapseProgress)? builder;
  final Widget? flexibleSpace;
  final Widget? collapsedTitle;
  final Widget? collapsedLeading;
  final List<Widget>? collapsedActions;
  final Color backgroundColor;
  final Color collapsedBackgroundColor;
  final double elevation;
  final double scrolledElevation;
  final Curve curve;

  @override
  double get minExtent => collapsedHeight;

  @override
  double get maxExtent => expandedHeight;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    final double rawProgress = (maxExtent > minExtent)
        ? (shrinkOffset / (maxExtent - minExtent)).clamp(0.0, 1.0)
        : 1.0;
    final double collapseProgress = curve.transform(rawProgress);

    if (builder != null) {
      return Material(
        elevation: overlapsContent || collapseProgress > 0.9
            ? scrolledElevation
            : elevation,
        color: Color.lerp(
          backgroundColor,
          collapsedBackgroundColor,
          collapseProgress,
        ),
        child: SizedBox.expand(child: builder!(context, collapseProgress)),
      );
    }

    final double effectiveElevation =
        (overlapsContent || collapseProgress > 0.9)
        ? scrolledElevation
        : elevation;
    final Color effectiveBg =
        Color.lerp(
          backgroundColor,
          collapsedBackgroundColor,
          collapseProgress,
        ) ??
        backgroundColor;

    return Material(
      elevation: effectiveElevation,
      color: effectiveBg,
      child: ClipRect(
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Flexible background with optional parallax translation
            if (flexibleSpace != null)
              Positioned.fill(
                child: Opacity(
                  opacity: (1.0 - collapseProgress).clamp(0.0, 1.0),
                  child: parallaxFactor > 0.0
                      ? Transform.translate(
                          offset: Offset(
                            0.0,
                            shrinkOffset * (1.0 - parallaxFactor),
                          ),
                          child: flexibleSpace,
                        )
                      : flexibleSpace,
                ),
              ),

            // Collapsed Toolbar (fades in as it approaches full collapse)
            if (collapsedTitle != null ||
                collapsedLeading != null ||
                collapsedActions != null)
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: collapsedHeight,
                child: Opacity(
                  opacity: collapseProgress.clamp(0.0, 1.0),
                  child: NavigationToolbar(
                    leading: collapsedLeading,
                    middle: collapsedTitle,
                    trailing: collapsedActions != null
                        ? Row(
                            mainAxisSize: MainAxisSize.min,
                            children: collapsedActions!,
                          )
                        : null,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(covariant _ScrollCollapsingHeaderDelegate oldDelegate) {
    return oldDelegate.expandedHeight != expandedHeight ||
        oldDelegate.collapsedHeight != collapsedHeight ||
        oldDelegate.parallaxFactor != parallaxFactor ||
        oldDelegate.builder != builder ||
        oldDelegate.flexibleSpace != flexibleSpace ||
        oldDelegate.collapsedTitle != collapsedTitle ||
        oldDelegate.collapsedLeading != collapsedLeading ||
        oldDelegate.backgroundColor != backgroundColor ||
        oldDelegate.collapsedBackgroundColor != collapsedBackgroundColor ||
        oldDelegate.elevation != elevation ||
        oldDelegate.scrolledElevation != scrolledElevation ||
        oldDelegate.curve != curve;
  }
}
