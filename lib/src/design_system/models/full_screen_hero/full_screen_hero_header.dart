import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import '../../../widgets/sliver_widget_marker.dart';
import 'full_screen_hero_config.dart';

/// Model 2: Full-Screen Hero Cinematic Navigation Header.
///
/// An expansive, immersive hero presentation spanning the full viewport on launch,
/// featuring media overscroll stretch, vignette gradient scrim, and optical
/// contraction into a pinned glassmorphic toolbar on upward scroll.
class FullScreenHeroHeaderWidget extends StatelessWidget
    with SliverWidgetMarker {
  /// Creates a [FullScreenHeroHeaderWidget].
  const FullScreenHeroHeaderWidget({
    super.key,
    this.title,
    this.leading,
    this.actions,
    this.config = const FullScreenHeroConfig(),
  });

  /// Optional custom title override.
  final Widget? title;

  /// Optional leading navigation widget.
  final Widget? leading;

  /// Optional trailing action widgets.
  final List<Widget>? actions;

  /// Strongly-typed configuration for this model.
  final FullScreenHeroConfig config;

  @override
  Widget build(BuildContext context) {
    final topPadding = config.safeArea ? MediaQuery.paddingOf(context).top : 0.0;
    final viewportHeight = MediaQuery.sizeOf(context).height;
    final totalExpanded = config.customViewportHeight ?? (viewportHeight * 0.72).clamp(340.0, 760.0);
    final totalCollapsed = config.collapsedHeight + topPadding;

    return SliverPersistentHeader(
      pinned: true,
      delegate: _FullScreenHeroDelegate(
        title: title,
        leading: leading,
        actions: actions,
        config: config,
        topPadding: topPadding,
        totalExpanded: totalExpanded,
        totalCollapsed: totalCollapsed,
      ),
    );
  }
}

class _FullScreenHeroDelegate extends SliverPersistentHeaderDelegate {
  _FullScreenHeroDelegate({
    required this.title,
    required this.leading,
    required this.actions,
    required this.config,
    required this.topPadding,
    required this.totalExpanded,
    required this.totalCollapsed,
  });

  final Widget? title;
  final Widget? leading;
  final List<Widget>? actions;
  final FullScreenHeroConfig config;
  final double topPadding;
  final double totalExpanded;
  final double totalCollapsed;

  @override
  double get minExtent => totalCollapsed;

  @override
  double get maxExtent => totalExpanded;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    final theme = Theme.of(context);
    final isReducedMotion = MediaQuery.disableAnimationsOf(context);
    final collapseRange = totalExpanded - totalCollapsed;
    final progress = collapseRange > 0.0 ? (shrinkOffset / collapseRange).clamp(0.0, 1.0) : 0.0;

    // Optical blur and scrim computations
    final blurValue = isReducedMotion ? 0.0 : progress * config.blurSigma;
    final scrimOpacity = (0.35 + progress * 0.55).clamp(0.0, 0.95);

    return Container(
      color: config.backgroundColor ?? Colors.black,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // --- FULL VIEWPORT MEDIA CANVAS ---
          Positioned.fill(
            child: ClipRect(
              child: ImageFiltered(
                imageFilter: ui.ImageFilter.blur(sigmaX: blurValue, sigmaY: blurValue),
                child: config.heroMedia ??
                    Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFF0F2027), Color(0xFF203A43), Color(0xFF2C5364)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: const Center(
                        child: Icon(Icons.movie_filter_outlined, size: 72.0, color: Colors.white24),
                      ),
                    ),
              ),
            ),
          ),

          // --- VIGNETTE GRADIENT SCRIM ---
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: config.scrimGradient ??
                    LinearGradient(
                      colors: [
                        Colors.black.withValues(alpha: 0.2),
                        Colors.black.withValues(alpha: scrimOpacity),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
              ),
            ),
          ),

          // --- EXPANDED CINEMATIC HERO DISPLAY ---
          if (progress < 0.9)
            Positioned(
              left: 24.0,
              right: 24.0,
              bottom: 32.0,
              child: Opacity(
                opacity: isReducedMotion ? (progress > 0.5 ? 0.0 : 1.0) : (1.0 - progress * 1.5).clamp(0.0, 1.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (config.playbackAction != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: config.playbackAction!,
                      ),
                    Text(
                      config.headline,
                      style: theme.textTheme.headlineMedium!.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -0.5,
                      ),
                    ),
                    if (config.tagline != null) ...[
                      const SizedBox(height: 6.0),
                      Text(
                        config.tagline!,
                        style: theme.textTheme.bodyMedium!.copyWith(
                          color: Colors.white70,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),

          // --- PINNED GLASSMORPHIC NAVIGATION TOOLBAR ---
          Positioned(
            top: 0.0,
            left: 0.0,
            right: 0.0,
            height: totalCollapsed,
            child: ClipRect(
              child: BackdropFilter(
                filter: ui.ImageFilter.blur(
                  sigmaX: config.glassmorphicToolbar ? progress * 16.0 : 0.0,
                  sigmaY: config.glassmorphicToolbar ? progress * 16.0 : 0.0,
                ),
                child: Container(
                  color: Colors.black.withValues(alpha: progress * 0.45),
                  padding: EdgeInsets.only(top: topPadding),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      children: [
                        if (leading != null)
                          leading!
                        else
                          const BackButton(color: Colors.white),
                        const SizedBox(width: 8.0),
                        Expanded(
                          child: Opacity(
                            opacity: isReducedMotion ? (progress > 0.5 ? 1.0 : 0.0) : progress.clamp(0.0, 1.0),
                            child: title ??
                                Text(
                                  config.headline,
                                  style: theme.textTheme.titleMedium!.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                          ),
                        ),
                        if (actions != null)
                          ...actions!
                        else
                          IconButton(
                            icon: const Icon(Icons.share_outlined, color: Colors.white),
                            onPressed: () {},
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  bool shouldRebuild(covariant _FullScreenHeroDelegate oldDelegate) {
    return oldDelegate.totalExpanded != totalExpanded ||
        oldDelegate.totalCollapsed != totalCollapsed ||
        oldDelegate.config != config ||
        oldDelegate.title != title ||
        oldDelegate.leading != leading ||
        oldDelegate.actions != actions ||
        oldDelegate.topPadding != topPadding;
  }
}
