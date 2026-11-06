import 'package:flutter/material.dart';
import '../../../widgets/sliver_widget_marker.dart';
import 'gesture_elastic_canvas_config.dart';

/// Model 16: Gesture Elastic Canvas Navigation Header.
///
/// Features a physics-based rubber-band elastic header canvas that overscrolls downward
/// to reveal rich contextual actions or pull-to-refresh metrics with elastic damping.
/// On scroll up, compresses elastically before locking into a glassmorphic minimal pinned bar.
class GestureElasticCanvasHeaderWidget extends StatelessWidget with SliverWidgetMarker {
  /// Creates a [GestureElasticCanvasHeaderWidget].
  const GestureElasticCanvasHeaderWidget({
    super.key,
    this.title,
    this.leading,
    this.actions,
    this.config = const GestureElasticCanvasConfig(),
  });

  /// Optional custom title override.
  final Widget? title;

  /// Optional custom leading widget.
  final Widget? leading;

  /// Optional trailing action widgets.
  final List<Widget>? actions;

  /// Strongly-typed configuration for this model.
  final GestureElasticCanvasConfig config;

  @override
  Widget build(BuildContext context) {
    final topPadding = config.safeArea ? MediaQuery.paddingOf(context).top : 0.0;
    final totalExpanded = config.expandedHeight + topPadding;
    final totalCollapsed = config.collapsedHeight + topPadding;

    return SliverPersistentHeader(
      pinned: true,
      delegate: _GestureElasticCanvasDelegate(
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

class _GestureElasticCanvasDelegate extends SliverPersistentHeaderDelegate {
  _GestureElasticCanvasDelegate({
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
  final GestureElasticCanvasConfig config;
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

    final currentHeight = (totalExpanded - shrinkOffset).clamp(totalCollapsed, totalExpanded);
    final accent = config.accentColor ?? theme.colorScheme.primary;

    return Material(
      color: config.backgroundColor ?? theme.colorScheme.surface,
      elevation: overlapsContent || progress > 0.8 ? config.elevation : 0.0,
      surfaceTintColor: config.surfaceTint,
      child: SafeArea(
        top: false,
        bottom: false,
        child: Padding(
          padding: EdgeInsets.only(top: topPadding),
          child: SizedBox(
            height: currentHeight - topPadding,
            child: ClipRect(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // --- EXPANDED ELASTIC ATMOSPHERE CANVAS ---
                  if (progress < 0.88)
                    Opacity(
                      opacity: isReducedMotion
                          ? (progress > 0.5 ? 0.0 : 1.0)
                          : (1.0 - progress * 1.3).clamp(0.0, 1.0),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Top Row: Leading & actions
                            Row(
                              children: [
                                if (leading != null) ...[
                                  leading!,
                                  const SizedBox(width: 8.0),
                                ],
                                const Spacer(),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 3.0),
                                  decoration: BoxDecoration(
                                    color: accent.withValues(alpha: 0.12),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        width: 6.0,
                                        height: 6.0,
                                        decoration: BoxDecoration(
                                          color: accent,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                      const SizedBox(width: 6.0),
                                      Text(
                                        config.statusMetric,
                                        style: TextStyle(
                                          fontSize: 10.5,
                                          fontWeight: FontWeight.bold,
                                          color: accent,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                ...?actions,
                              ],
                            ),
                            const Spacer(),

                            // Center Canvas Content: Title, Subtitle, & Elastic Pull Pill
                            Text(
                              config.canvasTitle,
                              style: theme.textTheme.headlineSmall!.copyWith(
                                fontWeight: FontWeight.w900,
                                letterSpacing: -0.5,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4.0),
                            Text(
                              config.canvasSubtitle,
                              style: theme.textTheme.bodyMedium!.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 12.0),

                            // Damped Spring Gesture Indicator
                            Container(
                              height: 32.0,
                              padding: const EdgeInsets.symmetric(horizontal: 12.0),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.6),
                                borderRadius: BorderRadius.circular(16.0),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.keyboard_arrow_down, size: 16.0, color: accent),
                                  const SizedBox(width: 6.0),
                                  Text(
                                    'Elastic Pull Gesture Active',
                                    style: TextStyle(
                                      fontSize: 11.0,
                                      fontWeight: FontWeight.w600,
                                      color: theme.colorScheme.onSurface,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                  // --- COLLAPSED COMPACT PINNED BAR ---
                  if (progress > 0.35)
                    Positioned(
                      left: 0.0,
                      right: 0.0,
                      top: 0.0,
                      height: config.collapsedHeight,
                      child: Opacity(
                        opacity: isReducedMotion
                            ? (progress > 0.5 ? 1.0 : 0.0)
                            : ((progress - 0.35) / 0.65).clamp(0.0, 1.0),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Row(
                            children: [
                              if (leading != null) ...[
                                leading!,
                                const SizedBox(width: 8.0),
                              ],
                              Expanded(
                                child: title ??
                                    Text(
                                      config.canvasTitle,
                                      style: theme.textTheme.titleMedium!.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 2.0),
                                decoration: BoxDecoration(
                                  color: accent.withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(6.0),
                                ),
                                child: Text(
                                  config.statusMetric,
                                  style: TextStyle(
                                    fontSize: 10.0,
                                    fontWeight: FontWeight.bold,
                                    color: accent,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 4.0),
                              IconButton(
                                icon: const Icon(Icons.refresh, size: 20.0),
                                onPressed: config.onRefreshTriggered,
                                tooltip: 'Trigger Refresh',
                              ),
                              ...?actions,
                            ],
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(covariant _GestureElasticCanvasDelegate oldDelegate) {
    return oldDelegate.totalExpanded != totalExpanded ||
        oldDelegate.totalCollapsed != totalCollapsed ||
        oldDelegate.config != config ||
        oldDelegate.title != title ||
        oldDelegate.actions != actions ||
        oldDelegate.leading != leading ||
        oldDelegate.topPadding != topPadding;
  }
}
