import 'dart:math' as math;
import 'dart:ui' show lerpDouble;
import 'package:flutter/material.dart';
import 'experience_configs.dart';

/// Style 22: Avatar-to-Profile Header.
///
/// A massive centered profile avatar glides smoothly along a quadratic Bezier
/// trajectory arc into the leading toolbar slot while scaling down, seamlessly
/// transforming an expansive social profile canvas into a compact navigation bar.
class AvatarToProfileHeaderWidget extends StatelessWidget {
  /// Creates an [AvatarToProfileHeaderWidget].
  const AvatarToProfileHeaderWidget({
    super.key,
    required this.avatar,
    required this.name,
    this.handle,
    this.bio,
    this.leading,
    this.actions,
    this.backgroundColor,
    this.safeArea = true,
    this.config = const AvatarToProfileConfig(),
  });

  /// Avatar widget (e.g. [CircleAvatar]).
  final Widget avatar;

  /// User display name.
  final Widget name;

  /// Optional username/handle (e.g. `@johndoe`).
  final Widget? handle;

  /// Optional bio or stats widget displayed only in expanded state.
  final Widget? bio;

  /// Optional leading widget (e.g. back button).
  final Widget? leading;

  /// Optional trailing action buttons.
  final List<Widget>? actions;

  /// Header background color.
  final Color? backgroundColor;

  /// Whether to respect top SafeArea padding.
  final bool safeArea;

  /// Avatar to profile configuration.
  final AvatarToProfileConfig config;

  @override
  Widget build(BuildContext context) {
    final topPadding = safeArea ? MediaQuery.paddingOf(context).top : 0.0;
    final totalExpanded = config.expandedHeight + topPadding;
    final totalCollapsed = config.collapsedHeight + topPadding;

    return SliverPersistentHeader(
      pinned: true,
      delegate: _AvatarToProfileDelegate(
        avatar: avatar,
        name: name,
        handle: handle,
        bio: bio,
        leading: leading,
        actions: actions,
        backgroundColor: backgroundColor,
        topPadding: topPadding,
        totalExpanded: totalExpanded,
        totalCollapsed: totalCollapsed,
        config: config,
      ),
    );
  }
}

class _AvatarToProfileDelegate extends SliverPersistentHeaderDelegate {
  _AvatarToProfileDelegate({
    required this.avatar,
    required this.name,
    required this.handle,
    required this.bio,
    required this.leading,
    required this.actions,
    required this.backgroundColor,
    required this.topPadding,
    required this.totalExpanded,
    required this.totalCollapsed,
    required this.config,
  });

  final Widget avatar;
  final Widget name;
  final Widget? handle;
  final Widget? bio;
  final Widget? leading;
  final List<Widget>? actions;
  final Color? backgroundColor;
  final double topPadding;
  final double totalExpanded;
  final double totalCollapsed;
  final AvatarToProfileConfig config;

  @override
  double get minExtent => totalCollapsed;

  @override
  double get maxExtent => totalExpanded;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    final theme = Theme.of(context);
    final isReducedMotion = MediaQuery.disableAnimationsOf(context);

    final rawProgress =
        (shrinkOffset / config.collapseThreshold).clamp(0.0, 1.0);
    final curve = config.resolveCurve(context);
    final progress = curve.transform(rawProgress);

    final resolvedBg = backgroundColor ?? theme.colorScheme.surface;
    final screenWidth = MediaQuery.sizeOf(context).width;

    // Avatar diameter interpolation
    final currentDiameter = isReducedMotion
        ? (progress > 0.5 ? config.compactAvatarDiameter : config.initialAvatarDiameter)
        : (lerpDouble(
                config.initialAvatarDiameter,
                config.compactAvatarDiameter,
                progress,
              ) ??
            config.initialAvatarDiameter);

    // Quadratic Bezier Arc Trajectory Calculation
    // Start: Centered horizontally, vertically near expanded mid-lower
    // End: Docked in top-left leading slot (e.g. left: 56.0, top: (collapsedHeight - compactAvatarDiameter) / 2)
    final startX = (math.max(config.initialAvatarDiameter, screenWidth) - config.initialAvatarDiameter) / 2;
    final startY = config.expandedHeight - config.initialAvatarDiameter - 60.0;

    final targetLeftOffset = leading != null ? 56.0 : 16.0;
    final endX = targetLeftOffset;
    final endY = (config.collapsedHeight - config.compactAvatarDiameter) / 2;

    // Control point creates natural parabolic curvature
    final controlX = startX - (startX - endX) * (1.0 - config.arcControlPointBias);
    final controlY = endY + (startY - endY) * 0.15;

    final t = progress;
    final arcX = isReducedMotion
        ? (progress > 0.5 ? endX : startX)
        : ((1 - t) * (1 - t) * startX + 2 * (1 - t) * t * controlX + t * t * endX);
    final arcY = isReducedMotion
        ? (progress > 0.5 ? endY : startY)
        : ((1 - t) * (1 - t) * startY + 2 * (1 - t) * t * controlY + t * t * endY);

    // Bio / Handle opacity
    final detailsOpacity = (1.0 - progress * 1.8).clamp(0.0, 1.0);

    // Title positioning: fades and glides from centered text into compact title row
    final titleLeftOffset = endX + config.compactAvatarDiameter + 12.0;

    return SizedBox.expand(
      child: Material(
        elevation: shrinkOffset > 5.0 ? config.elevation : 0.0,
        color: resolvedBg,
        child: ClipRect(
          child: Padding(
            padding: EdgeInsets.only(top: topPadding),
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Collapsed Pinned Toolbar Background Layer
                Positioned(
                  top: 0.0,
                  left: 0.0,
                  right: 0.0,
                  height: config.collapsedHeight,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: Row(
                      children: [
                        ?leading,
                        const Spacer(),
                        ...?actions,
                      ],
                    ),
                  ),
                ),

                // Expanded Bio & Handle Block
                if (detailsOpacity > 0.01)
                  Positioned(
                    top: startY + config.initialAvatarDiameter + 8.0,
                    left: 20.0,
                    right: 20.0,
                    child: Opacity(
                      opacity: detailsOpacity,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (handle != null) ...[
                            DefaultTextStyle(
                              style: theme.textTheme.bodyMedium!.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              child: handle!,
                            ),
                            const SizedBox(height: 4.0),
                          ],
                          if (bio != null) ...[
                            DefaultTextStyle(
                              style: theme.textTheme.bodySmall!,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              child: bio!,
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),

                // Transforming Display Name
                Positioned(
                  top: isReducedMotion
                      ? (progress > 0.5 ? (config.collapsedHeight - 24.0) / 2 : startY - 28.0)
                      : (lerpDouble(
                              startY - 28.0,
                              (config.collapsedHeight - 24.0) / 2,
                              progress,
                            ) ??
                          startY - 28.0),
                  left: isReducedMotion
                      ? (progress > 0.5 ? titleLeftOffset : 24.0)
                      : (lerpDouble(24.0, titleLeftOffset, progress) ?? 24.0),
                  right: isReducedMotion
                      ? (progress > 0.5 ? 90.0 : 24.0)
                      : (lerpDouble(24.0, 90.0, progress) ?? 24.0),
                  child: Align(
                    alignment: isReducedMotion
                        ? (progress > 0.5 ? Alignment.centerLeft : Alignment.center)
                        : Alignment.lerp(
                            Alignment.center,
                            Alignment.centerLeft,
                            progress,
                          )!,
                    child: DefaultTextStyle(
                      style: theme.textTheme.titleMedium!.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: isReducedMotion
                            ? (progress > 0.5 ? 16.0 : 20.0)
                            : (lerpDouble(20.0, 16.0, progress) ?? 20.0),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      child: name,
                    ),
                  ),
                ),

                // Arc Trajectory Avatar
                Positioned(
                  left: arcX,
                  top: arcY,
                  width: currentDiameter,
                  height: currentDiameter,
                  child: SizedBox(
                    width: currentDiameter,
                    height: currentDiameter,
                    child: FittedBox(
                      fit: BoxFit.contain,
                      child: avatar,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(covariant _AvatarToProfileDelegate oldDelegate) {
    return oldDelegate.avatar != avatar ||
        oldDelegate.name != name ||
        oldDelegate.handle != handle ||
        oldDelegate.bio != bio ||
        oldDelegate.leading != leading ||
        oldDelegate.actions != actions ||
        oldDelegate.backgroundColor != backgroundColor ||
        oldDelegate.topPadding != topPadding ||
        oldDelegate.totalExpanded != totalExpanded ||
        oldDelegate.totalCollapsed != totalCollapsed ||
        oldDelegate.config != config;
  }
}
