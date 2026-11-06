import 'package:flutter/material.dart';
import 'experience_configs.dart';

/// Style 45: Full Bleed Edge-To-Edge Hero Scale Header.
///
/// Immersive full-bleed media cover banner that expands edge-to-edge with
/// continuous scale magnification on overscroll, and contracts with optical scrim
/// and aspect ratio shift into a compact pinned toolbar.
class FullBleedHeroScaleHeaderWidget extends StatelessWidget {
  /// Creates a [FullBleedHeroScaleHeaderWidget].
  const FullBleedHeroScaleHeaderWidget({
    super.key,
    required this.heroCover,
    required this.title,
    this.subtitle,
    this.leading,
    this.actions,
    this.config = const FullBleedHeroScaleConfig(),
  });

  /// The full-bleed background cover image or video preview widget.
  final Widget heroCover;

  /// Primary title widget.
  final Widget title;

  /// Optional subtitle.
  final Widget? subtitle;

  /// Optional leading navigation button.
  final Widget? leading;

  /// Optional trailing actions.
  final List<Widget>? actions;

  /// Scale, scrim, and collapse configuration.
  final FullBleedHeroScaleConfig config;

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.paddingOf(context).top;
    final totalExpanded = config.expandedHeight + topPadding;
    final totalCollapsed = config.collapsedHeight + topPadding;

    return SliverPersistentHeader(
      pinned: true,
      delegate: _FullBleedHeroDelegate(
        heroCover: heroCover,
        title: title,
        subtitle: subtitle,
        leading: leading,
        actions: actions,
        topPadding: topPadding,
        totalExpanded: totalExpanded,
        totalCollapsed: totalCollapsed,
        config: config,
      ),
    );
  }
}

class _FullBleedHeroDelegate extends SliverPersistentHeaderDelegate {
  _FullBleedHeroDelegate({
    required this.heroCover,
    required this.title,
    required this.subtitle,
    required this.leading,
    required this.actions,
    required this.topPadding,
    required this.totalExpanded,
    required this.totalCollapsed,
    required this.config,
  });

  final Widget heroCover;
  final Widget title;
  final Widget? subtitle;
  final Widget? leading;
  final List<Widget>? actions;
  final double topPadding;
  final double totalExpanded;
  final double totalCollapsed;
  final FullBleedHeroScaleConfig config;

  @override
  double get minExtent => totalCollapsed;

  @override
  double get maxExtent => totalExpanded;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    final isReducedMotion = MediaQuery.disableAnimationsOf(context);
    final progress = (shrinkOffset / (totalExpanded - totalCollapsed)).clamp(0.0, 1.0);
    final isCollapsed = progress >= 0.85;

    // Scale calculation: shrinkOffset < 0 is overscroll pull
    final overscroll = shrinkOffset < 0 ? -shrinkOffset : 0.0;
    final scale = isReducedMotion
        ? 1.0
        : 1.0 + (overscroll / totalExpanded) * (config.maxOverscrollScale - 1.0);

    final scrimOpacity = isReducedMotion
        ? (progress > 0.5 ? config.scrimMaxOpacity : 0.0)
        : (progress * config.scrimMaxOpacity).clamp(0.0, config.scrimMaxOpacity);

    return ClipRect(
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Scaling Hero Cover Background
          Transform.scale(
            scale: scale,
            alignment: Alignment.center,
            child: heroCover,
          ),

          // Optical Gradient Scrim
          Container(
            color: Colors.black.withValues(alpha: scrimOpacity),
          ),

          // Bottom gradient for text readability in expanded mode
          Positioned(
            bottom: 0.0,
            left: 0.0,
            right: 0.0,
            height: 120.0,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.85),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          // Expanded Title / Subtitle
          Positioned(
            left: 20.0,
            right: 20.0,
            bottom: 20.0,
            child: Opacity(
              opacity: (1.0 - progress / 0.6).clamp(0.0, 1.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  title,
                  if (subtitle != null) ...[
                    const SizedBox(height: 4.0),
                    subtitle!,
                  ],
                ],
              ),
            ),
          ),

          // Pinned Top Toolbar
          Positioned(
            top: topPadding,
            left: 0.0,
            right: 0.0,
            height: config.collapsedHeight,
            child: Row(
              children: [
                ?leading,
                if (isCollapsed)
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: title,
                    ),
                  )
                else
                  const Spacer(),
                ...?actions,
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  bool shouldRebuild(covariant _FullBleedHeroDelegate oldDelegate) {
    return oldDelegate.totalExpanded != totalExpanded ||
        oldDelegate.totalCollapsed != totalCollapsed ||
        oldDelegate.heroCover != heroCover;
  }
}
