import 'package:flutter/material.dart';
import '../../../widgets/sliver_widget_marker.dart';
import 'minimalist_micro_bar_config.dart';

/// Model 11: Minimalist Content-First Micro-Bar Navigation Header.
///
/// An ultra-clean, content-focused ribbon featuring monospace micro-breadcrumbs,
/// reading ETA, and a minimal scroll progress dot.
class MinimalistMicroBarHeaderWidget extends StatelessWidget with SliverWidgetMarker {
  /// Creates a [MinimalistMicroBarHeaderWidget].
  const MinimalistMicroBarHeaderWidget({
    super.key,
    this.title,
    this.leading,
    this.actions,
    this.config = const MinimalistMicroBarConfig(),
  });

  /// Optional custom title override.
  final Widget? title;

  /// Optional custom leading widget.
  final Widget? leading;

  /// Optional trailing action widgets.
  final List<Widget>? actions;

  /// Strongly-typed configuration for this model.
  final MinimalistMicroBarConfig config;

  @override
  Widget build(BuildContext context) {
    final topPadding = config.safeArea ? MediaQuery.paddingOf(context).top : 0.0;
    final totalExpanded = config.expandedHeight + topPadding;
    final totalCollapsed = config.collapsedHeight + topPadding;

    return SliverPersistentHeader(
      pinned: true,
      delegate: _MinimalistMicroBarDelegate(
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

class _MinimalistMicroBarDelegate extends SliverPersistentHeaderDelegate {
  _MinimalistMicroBarDelegate({
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
  final MinimalistMicroBarConfig config;
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
    final collapseRange = totalExpanded - totalCollapsed;
    final progress = collapseRange > 0.0 ? (shrinkOffset / collapseRange).clamp(0.0, 1.0) : 0.0;

    final currentHeight = (totalExpanded - shrinkOffset).clamp(totalCollapsed, totalExpanded);

    return Material(
      color: config.backgroundColor ?? theme.colorScheme.surface,
      elevation: overlapsContent || progress > 0.8 ? config.elevation : 0.0,
      surfaceTintColor: config.surfaceTint,
      child: SafeArea(
        top: false,
        bottom: false,
        child: Padding(
          padding: EdgeInsets.only(top: topPadding),
          child: Container(
            height: currentHeight - topPadding,
            decoration: BoxDecoration(
              border: config.hairlineBorder
                  ? Border(
                      bottom: BorderSide(
                        color: theme.colorScheme.outlineVariant.withValues(
                          alpha: 0.3 + progress * 0.4,
                        ),
                        width: 0.6,
                      ),
                    )
                  : null,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 14.0),
            child: Row(
              children: [
                if (leading != null) ...[
                  leading!,
                  const SizedBox(width: 6.0),
                ] else ...[
                  const Icon(Icons.terminal, size: 16.0),
                  const SizedBox(width: 6.0),
                ],
                // Monospace Micro-Breadcrumbs
                Expanded(
                  child: title ??
                      Text(
                        config.pathBreadcrumb,
                        style: TextStyle(
                          fontFamily: config.monospace ? 'monospace' : null,
                          fontSize: 11.5,
                          fontWeight: FontWeight.w600,
                          color: theme.colorScheme.onSurface,
                          letterSpacing: -0.2,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                ),
                if (config.documentStatus != null && progress < 0.7) ...[
                  const SizedBox(width: 8.0),
                  Opacity(
                    opacity: (1.0 - progress * 1.4).clamp(0.0, 1.0),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 1.5),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                      child: Text(
                        config.documentStatus!,
                        style: TextStyle(
                          fontSize: 9.5,
                          fontFamily: config.monospace ? 'monospace' : null,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ),
                ],
                if (config.readingEta != null) ...[
                  const SizedBox(width: 8.0),
                  Text(
                    config.readingEta!,
                    style: TextStyle(
                      fontSize: 10.5,
                      color: theme.colorScheme.outline,
                    ),
                  ),
                ],
                if (config.showProgressDot) ...[
                  const SizedBox(width: 8.0),
                  Container(
                    width: 7.0,
                    height: 7.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color.lerp(
                        theme.colorScheme.outlineVariant,
                        theme.colorScheme.primary,
                        progress,
                      ),
                    ),
                  ),
                ],
                ...?actions,
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(covariant _MinimalistMicroBarDelegate oldDelegate) {
    return oldDelegate.totalExpanded != totalExpanded ||
        oldDelegate.totalCollapsed != totalCollapsed ||
        oldDelegate.config != config ||
        oldDelegate.title != title ||
        oldDelegate.actions != actions ||
        oldDelegate.leading != leading ||
        oldDelegate.topPadding != topPadding;
  }
}
