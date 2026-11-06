import 'package:flutter/material.dart';
import '../widgets/sliver_widget_marker.dart';
import 'experience_configs.dart';

/// Style 49: Context-Aware Focal Swap Header.
///
/// A dynamic header that presents a primary hero element when expanded, and
/// automatically cross-fades into a specialized contextual toolset (search,
/// filters, action dock) when scrolled past the defined threshold.
class ContextAwareFocalSwapHeaderWidget extends StatelessWidget
    with SliverWidgetMarker {
  /// Creates a [ContextAwareFocalSwapHeaderWidget].
  const ContextAwareFocalSwapHeaderWidget({
    super.key,
    required this.primaryHero,
    required this.contextualToolbar,
    this.backgroundColor,
    this.safeArea = true,
    this.config = const ContextAwareFocalSwapConfig(),
  });

  /// The primary presentation widget shown when expanded.
  final Widget primaryHero;

  /// The operational/contextual toolset widget swapped in when collapsed.
  final Widget contextualToolbar;

  /// Header canvas background color.
  final Color? backgroundColor;

  /// Whether to respect status bar safe area.
  final bool safeArea;

  /// Focal swap threshold and cross-fade configuration.
  final ContextAwareFocalSwapConfig config;

  @override
  Widget build(BuildContext context) {
    final topPadding = safeArea ? MediaQuery.paddingOf(context).top : 0.0;
    final totalExpanded = config.expandedHeight + topPadding;
    final totalCollapsed = config.collapsedHeight + topPadding;

    return SliverPersistentHeader(
      pinned: true,
      delegate: _FocalSwapDelegate(
        primaryHero: primaryHero,
        contextualToolbar: contextualToolbar,
        backgroundColor: backgroundColor ?? Theme.of(context).colorScheme.surface,
        topPadding: topPadding,
        totalExpanded: totalExpanded,
        totalCollapsed: totalCollapsed,
        config: config,
      ),
    );
  }
}

class _FocalSwapDelegate extends SliverPersistentHeaderDelegate {
  _FocalSwapDelegate({
    required this.primaryHero,
    required this.contextualToolbar,
    required this.backgroundColor,
    required this.topPadding,
    required this.totalExpanded,
    required this.totalCollapsed,
    required this.config,
  });

  final Widget primaryHero;
  final Widget contextualToolbar;
  final Color backgroundColor;
  final double topPadding;
  final double totalExpanded;
  final double totalCollapsed;
  final ContextAwareFocalSwapConfig config;

  @override
  double get minExtent => totalCollapsed;

  @override
  double get maxExtent => totalExpanded;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    final isReducedMotion = MediaQuery.disableAnimationsOf(context);
    final progress = ((shrinkOffset) / (totalExpanded - totalCollapsed)).clamp(0.0, 1.0);

    // Swap crossfade calculations
    final isSwapped = shrinkOffset >= config.swapThreshold;
    final heroOpacity = isReducedMotion
        ? (isSwapped ? 0.0 : 1.0)
        : (1.0 - progress * 1.6).clamp(0.0, 1.0);
    final toolsetOpacity = isReducedMotion
        ? (isSwapped ? 1.0 : 0.0)
        : ((progress - 0.4) / 0.6).clamp(0.0, 1.0);

    return Material(
      color: backgroundColor,
      elevation: isSwapped ? config.elevationOnSwap : 0.0,
      child: SafeArea(
        top: false,
        bottom: false,
        child: Padding(
          padding: EdgeInsets.only(top: topPadding),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Primary Hero Layer (dissolves on scroll)
              if (heroOpacity > 0.01)
                Positioned.fill(
                  child: Opacity(
                    opacity: heroOpacity,
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: primaryHero,
                        ),
                      ),
                    ),
                  ),
                ),

              // Contextual Operational Toolbar Layer (emerges on scroll)
              if (toolsetOpacity > 0.01)
                Positioned(
                  top: 0.0,
                  left: 0.0,
                  right: 0.0,
                  height: config.collapsedHeight,
                  child: Opacity(
                    opacity: toolsetOpacity,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Center(child: contextualToolbar),
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
  bool shouldRebuild(covariant _FocalSwapDelegate oldDelegate) {
    return oldDelegate.totalExpanded != totalExpanded ||
        oldDelegate.totalCollapsed != totalCollapsed ||
        oldDelegate.primaryHero != primaryHero ||
        oldDelegate.contextualToolbar != contextualToolbar ||
        oldDelegate.backgroundColor != backgroundColor ||
        oldDelegate.topPadding != topPadding ||
        oldDelegate.config != config;
  }
}
