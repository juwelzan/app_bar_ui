import 'package:flutter/material.dart';
import '../../../widgets/sliver_widget_marker.dart';
import 'split_curtain_config.dart';

/// Model 5: Multi-Panel Split Curtain Navigation Header.
///
/// Left identity panel and right actions panel start divided on either side of the viewport.
/// On scroll, both panels slide inward along the X-axis to join seamlessly into a unified
/// compact pill toolbar pinned at the top.
class MultiPanelSplitCurtainHeaderWidget extends StatelessWidget with SliverWidgetMarker {
  /// Creates a [MultiPanelSplitCurtainHeaderWidget].
  const MultiPanelSplitCurtainHeaderWidget({
    super.key,
    this.title,
    this.leading,
    this.actions,
    this.config = const MultiPanelSplitCurtainConfig(),
  });

  /// Optional custom title override.
  final Widget? title;

  /// Optional custom leading widget.
  final Widget? leading;

  /// Optional trailing action widgets.
  final List<Widget>? actions;

  /// Strongly-typed configuration for this model.
  final MultiPanelSplitCurtainConfig config;

  @override
  Widget build(BuildContext context) {
    final topPadding = config.safeArea ? MediaQuery.paddingOf(context).top : 0.0;
    final totalExpanded = config.expandedHeight + topPadding;
    final totalCollapsed = config.collapsedHeight + topPadding;

    return SliverPersistentHeader(
      pinned: true,
      delegate: _SplitCurtainDelegate(
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

class _SplitCurtainDelegate extends SliverPersistentHeaderDelegate {
  _SplitCurtainDelegate({
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
  final MultiPanelSplitCurtainConfig config;
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
    final rawProgress = collapseRange > 0.0 ? (shrinkOffset / collapseRange).clamp(0.0, 1.0) : 0.0;
    final progress = isReducedMotion ? (rawProgress > 0.5 ? 1.0 : 0.0) : config.curtainCurve.transform(rawProgress);

    final currentHeight = (totalExpanded - shrinkOffset).clamp(totalCollapsed, totalExpanded);

    // Dynamic horizontal convergence shift
    final convergenceShift = (config.splitGap / 2) * progress;
    final currentGap = (config.splitGap * (1.0 - progress)).clamp(0.0, config.splitGap);

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
            child: progress > 0.85
                // --- FUSED COMPACT TOOLBAR STATE ---
                ? _buildFusedToolbar(context, theme, progress)
                // --- SPLIT LATERAL CURTAIN PANELS STATE ---
                : _buildSplitCurtainPanels(context, theme, progress, convergenceShift, currentGap),
          ),
        ),
      ),
    );
  }

  Widget _buildSplitCurtainPanels(
    BuildContext context,
    ThemeData theme,
    double progress,
    double convergenceShift,
    double currentGap,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: config.horizontalMargin, vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Left Panel: Identity & Brand
          Expanded(
            flex: 6,
            child: Transform.translate(
              offset: Offset(convergenceShift, 0.0),
              child: config.leftCustomPanel ??
                  Container(
                    padding: const EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primaryContainer.withValues(alpha: 0.7 - progress * 0.3),
                      borderRadius: BorderRadius.horizontal(
                        left: const Radius.circular(16.0),
                        right: Radius.circular((16.0 * (1.0 - progress)).clamp(4.0, 16.0)),
                      ),
                      border: Border.all(
                        color: theme.colorScheme.primary.withValues(alpha: 0.25),
                        width: 1.0,
                      ),
                    ),
                    child: Row(
                      children: [
                        if (leading != null) ...[
                          leading!,
                          const SizedBox(width: 8.0),
                        ] else if (config.leftIcon != null) ...[
                          Icon(config.leftIcon, size: 24.0, color: theme.colorScheme.primary),
                          const SizedBox(width: 8.0),
                        ],
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                config.leftPanelTitle,
                                style: theme.textTheme.titleMedium!.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: theme.colorScheme.onPrimaryContainer,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              if (config.leftPanelSubtitle != null) ...[
                                const SizedBox(height: 2.0),
                                Text(
                                  config.leftPanelSubtitle!,
                                  style: theme.textTheme.bodySmall!.copyWith(
                                    color: theme.colorScheme.onPrimaryContainer.withValues(alpha: 0.8),
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
            ),
          ),

          SizedBox(width: currentGap),

          // Right Panel: Actions & Controls
          Expanded(
            flex: 5,
            child: Transform.translate(
              offset: Offset(-convergenceShift, 0.0),
              child: config.rightCustomPanel ??
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.7 - progress * 0.3),
                      borderRadius: BorderRadius.horizontal(
                        left: Radius.circular((16.0 * (1.0 - progress)).clamp(4.0, 16.0)),
                        right: const Radius.circular(16.0),
                      ),
                      border: Border.all(
                        color: theme.colorScheme.outlineVariant.withValues(alpha: 0.4),
                        width: 1.0,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        if (config.actionButtons.isNotEmpty)
                          ...config.actionButtons
                        else ...[
                          IconButton(
                            icon: const Icon(Icons.search, size: 20.0),
                            onPressed: () {},
                            tooltip: 'Search',
                          ),
                          IconButton(
                            icon: const Icon(Icons.tune, size: 20.0),
                            onPressed: () {},
                            tooltip: 'Settings',
                          ),
                          ...?actions,
                        ],
                      ],
                    ),
                  ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFusedToolbar(BuildContext context, ThemeData theme, double progress) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: config.horizontalMargin, vertical: 4.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14.0),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(24.0),
          border: Border.all(
            color: theme.colorScheme.primary.withValues(alpha: 0.35),
            width: 1.2,
          ),
        ),
        child: Row(
          children: [
            if (leading != null) ...[
              leading!,
              const SizedBox(width: 8.0),
            ] else if (config.leftIcon != null) ...[
              Icon(config.leftIcon, size: 20.0, color: theme.colorScheme.primary),
              const SizedBox(width: 8.0),
            ],
            Expanded(
              child: title ??
                  Text(
                    config.leftPanelTitle,
                    style: theme.textTheme.titleMedium!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
            ),
            if (config.actionButtons.isNotEmpty)
              ...config.actionButtons
            else ...[
              IconButton(
                icon: const Icon(Icons.search, size: 18.0),
                onPressed: () {},
                tooltip: 'Search',
              ),
              IconButton(
                icon: const Icon(Icons.more_vert, size: 18.0),
                onPressed: () {},
                tooltip: 'More',
              ),
              ...?actions,
            ],
          ],
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(covariant _SplitCurtainDelegate oldDelegate) {
    return oldDelegate.totalExpanded != totalExpanded ||
        oldDelegate.totalCollapsed != totalCollapsed ||
        oldDelegate.config != config ||
        oldDelegate.title != title ||
        oldDelegate.actions != actions ||
        oldDelegate.leading != leading ||
        oldDelegate.topPadding != topPadding;
  }
}
