import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'experience_configs.dart';

/// Style 36: Magnetic Anchor Snap Header.
///
/// Header controls and hero identity elements possess magnetic attraction toward
/// pre-calculated layout anchors. As the user scrolls past proximity thresholds,
/// the elements accelerate and snap into docked anchor slots with spring damping,
/// creating a tactile physical attraction experience.
class MagneticAnchorSnapHeaderWidget extends StatelessWidget {
  /// Creates a [MagneticAnchorSnapHeaderWidget].
  const MagneticAnchorSnapHeaderWidget({
    super.key,
    required this.heroTitle,
    required this.heroBadge,
    this.heroSubtitle,
    this.dockedLeading,
    this.dockedActions,
    this.backgroundColor,
    this.safeArea = true,
    this.config = const MagneticAnchorSnapConfig(),
  });

  /// Main title widget that travels between expanded and docked magnetic anchors.
  final Widget heroTitle;

  /// Prominent badge/avatar that snaps from central canvas to pinned toolbar.
  final Widget heroBadge;

  /// Optional subtitle widget.
  final Widget? heroSubtitle;

  /// Optional leading navigation widget.
  final Widget? dockedLeading;

  /// Optional trailing action widgets.
  final List<Widget>? dockedActions;

  /// Background color of the header canvas.
  final Color? backgroundColor;

  /// Whether to respect top SafeArea.
  final bool safeArea;

  /// Configuration for magnetic distances, spring curves, and thresholds.
  final MagneticAnchorSnapConfig config;

  @override
  Widget build(BuildContext context) {
    final topPadding = safeArea ? MediaQuery.paddingOf(context).top : 0.0;
    final totalExpanded = config.expandedHeight + topPadding;
    final totalCollapsed = config.collapsedHeight + topPadding;

    return SliverPersistentHeader(
      pinned: true,
      delegate: _MagneticAnchorSnapDelegate(
        heroTitle: heroTitle,
        heroBadge: heroBadge,
        heroSubtitle: heroSubtitle,
        dockedLeading: dockedLeading,
        dockedActions: dockedActions,
        backgroundColor: backgroundColor ?? Theme.of(context).colorScheme.surface,
        topPadding: topPadding,
        totalExpanded: math.max(totalExpanded, totalCollapsed + 1.0),
        totalCollapsed: totalCollapsed,
        config: config,
      ),
    );
  }
}

class _MagneticAnchorSnapDelegate extends SliverPersistentHeaderDelegate {
  _MagneticAnchorSnapDelegate({
    required this.heroTitle,
    required this.heroBadge,
    required this.heroSubtitle,
    required this.dockedLeading,
    required this.dockedActions,
    required this.backgroundColor,
    required this.topPadding,
    required this.totalExpanded,
    required this.totalCollapsed,
    required this.config,
  });

  final Widget heroTitle;
  final Widget heroBadge;
  final Widget? heroSubtitle;
  final Widget? dockedLeading;
  final List<Widget>? dockedActions;
  final Color backgroundColor;
  final double topPadding;
  final double totalExpanded;
  final double totalCollapsed;
  final MagneticAnchorSnapConfig config;

  @override
  double get minExtent => totalCollapsed;

  @override
  double get maxExtent => totalExpanded;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    final reducedMotion = MediaQuery.disableAnimationsOf(context);
    final delta = maxExtent - minExtent;
    final progress = delta > 0 ? (shrinkOffset / delta).clamp(0.0, 1.0) : 0.0;
    final curvedProgress = reducedMotion ? progress : config.curve.transform(progress);

    final width = MediaQuery.sizeOf(context).width;
    final safeWidth = width > 0 ? width : 360.0;
    final theme = Theme.of(context);

    // Anchor Coordinates:
    // Badge Anchor A (Expanded): Center top
    final badgeExpandedX = (safeWidth - 52.0) / 2.0;
    final badgeExpandedY = topPadding + 16.0;

    // Badge Anchor B (Docked): Left beside leading or left margin
    final badgeDockedX = dockedLeading != null ? 56.0 : 16.0;
    final badgeDockedY = topPadding + (totalCollapsed - topPadding - 36.0) / 2.0;

    // Title Anchor A (Expanded): Centered beneath badge
    final titleExpandedX = 24.0;
    final titleExpandedY = badgeExpandedY + 60.0;

    // Title Anchor B (Docked): Next to docked badge
    final titleDockedX = badgeDockedX + 44.0;
    final titleDockedY = topPadding + (totalCollapsed - topPadding - 24.0) / 2.0;

    // Magnetic interpolation
    final badgeX = reducedMotion
        ? (progress > 0.5 ? badgeDockedX : badgeExpandedX)
        : badgeExpandedX + (badgeDockedX - badgeExpandedX) * curvedProgress;
    final badgeY = reducedMotion
        ? (progress > 0.5 ? badgeDockedY : badgeExpandedY)
        : badgeExpandedY + (badgeDockedY - badgeExpandedY) * curvedProgress;
    final badgeScale = 1.0 - (0.30 * curvedProgress);

    final titleX = reducedMotion
        ? (progress > 0.5 ? titleDockedX : titleExpandedX)
        : titleExpandedX + (titleDockedX - titleExpandedX) * curvedProgress;
    final titleY = reducedMotion
        ? (progress > 0.5 ? titleDockedY : titleExpandedY)
        : titleExpandedY + (titleDockedY - titleExpandedY) * curvedProgress;

    final isDocked = curvedProgress > 0.7;

    return Material(
      elevation: config.elevation * curvedProgress,
      color: backgroundColor,
      child: ClipRect(
        child: OverflowBox(
          minWidth: 0.0,
          maxWidth: safeWidth,
          minHeight: 0.0,
          maxHeight: totalExpanded,
          alignment: Alignment.topLeft,
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Magnetic Field Indicator Rings (visible during mid-transit)
              if (!reducedMotion && curvedProgress > 0.1 && curvedProgress < 0.9)
                Positioned(
                  left: badgeDockedX - 10.0,
                  top: badgeDockedY - 10.0,
                  width: 56.0,
                  height: 56.0,
                  child: Opacity(
                    opacity: (math.sin(curvedProgress * math.pi) * 0.35).clamp(0.0, 1.0),
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: theme.colorScheme.primary,
                          width: 2.0,
                        ),
                      ),
                    ),
                  ),
                ),

              // Docked Leading widget
              if (dockedLeading != null)
                Positioned(
                  left: 8.0,
                  top: topPadding + (totalCollapsed - topPadding - 48.0) / 2.0,
                  child: SizedBox(
                    width: 48.0,
                    height: 48.0,
                    child: Center(child: dockedLeading!),
                  ),
                ),

              // Docked Actions
              if (dockedActions != null && dockedActions!.isNotEmpty)
                Positioned(
                  right: 8.0,
                  top: topPadding + (totalCollapsed - topPadding - 48.0) / 2.0,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: dockedActions!,
                  ),
                ),

              // Subtitle (fades out as magnetic pull snaps title into toolbar)
              if (heroSubtitle != null && curvedProgress < 0.6)
                Positioned(
                  left: 24.0,
                  right: 24.0,
                  top: titleExpandedY + 36.0,
                  child: Opacity(
                    opacity: (1.0 - (curvedProgress / 0.6)).clamp(0.0, 1.0),
                    child: Center(
                      child: DefaultTextStyle(
                        style: theme.textTheme.bodyMedium!.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        child: heroSubtitle!,
                      ),
                    ),
                  ),
                ),

              // Title Widget (Magnetic Anchor Transit)
              Positioned(
                left: titleX,
                top: titleY,
                right: isDocked
                    ? (dockedActions != null ? (dockedActions!.length * 48.0 + 16.0) : 16.0)
                    : 24.0,
                child: Align(
                  alignment: isDocked ? Alignment.centerLeft : Alignment.center,
                  child: DefaultTextStyle(
                    style: (isDocked
                            ? theme.textTheme.titleMedium!
                            : theme.textTheme.headlineSmall!)
                        .copyWith(fontWeight: FontWeight.bold),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    child: heroTitle,
                  ),
                ),
              ),

              // Badge Widget (Magnetic Anchor Transit)
              Positioned(
                left: badgeX,
                top: badgeY,
                child: Transform.scale(
                  scale: badgeScale,
                  child: SizedBox(
                    width: 52.0,
                    height: 52.0,
                    child: Center(child: heroBadge),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(covariant _MagneticAnchorSnapDelegate oldDelegate) {
    return heroTitle != oldDelegate.heroTitle ||
        heroBadge != oldDelegate.heroBadge ||
        heroSubtitle != oldDelegate.heroSubtitle ||
        dockedLeading != oldDelegate.dockedLeading ||
        dockedActions != oldDelegate.dockedActions ||
        backgroundColor != oldDelegate.backgroundColor ||
        topPadding != oldDelegate.topPadding ||
        totalExpanded != oldDelegate.totalExpanded ||
        totalCollapsed != oldDelegate.totalCollapsed ||
        config != oldDelegate.config;
  }
}

