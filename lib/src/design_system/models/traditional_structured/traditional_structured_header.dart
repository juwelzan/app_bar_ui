import 'package:flutter/material.dart';
import '../../../widgets/sliver_widget_marker.dart';
import 'traditional_structured_config.dart';

/// Model 1: Traditional Structured Navigation Header.
///
/// An enterprise-grade, multi-tiered header featuring organization identity,
/// environment badge, interactive breadcrumb hierarchy, and sticky tab strip.
class TraditionalStructuredHeaderWidget extends StatefulWidget
    with SliverWidgetMarker {
  /// Creates a [TraditionalStructuredHeaderWidget].
  const TraditionalStructuredHeaderWidget({
    super.key,
    this.title,
    this.actions,
    this.leading,
    this.config = const TraditionalStructuredConfig(),
  });

  /// Optional custom title widget override.
  final Widget? title;

  /// Optional trailing action widgets.
  final List<Widget>? actions;

  /// Optional leading widget override.
  final Widget? leading;

  /// Strongly-typed configuration for this model.
  final TraditionalStructuredConfig config;

  @override
  State<TraditionalStructuredHeaderWidget> createState() =>
      _TraditionalStructuredHeaderWidgetState();
}

class _TraditionalStructuredHeaderWidgetState
    extends State<TraditionalStructuredHeaderWidget>
    with TickerProviderStateMixin {
  TabController? _internalTabController;

  @override
  void initState() {
    super.initState();
    _initControllerIfNeeded();
  }

  @override
  void didUpdateWidget(covariant TraditionalStructuredHeaderWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.config.tabController != oldWidget.config.tabController ||
        widget.config.tabs.length != oldWidget.config.tabs.length) {
      _initControllerIfNeeded();
    }
  }

  void _initControllerIfNeeded() {
    if (widget.config.tabController == null && widget.config.tabs.isNotEmpty) {
      _internalTabController?.dispose();
      _internalTabController = TabController(
        length: widget.config.tabs.length,
        vsync: this,
      );
    } else if (widget.config.tabController != null) {
      _internalTabController?.dispose();
      _internalTabController = null;
    }
  }

  @override
  void dispose() {
    _internalTabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final config = widget.config;
    final topPadding = config.safeArea ? MediaQuery.paddingOf(context).top : 0.0;
    final tabHeight = (config.stickyTabStrip && config.tabs.isNotEmpty) ? 46.0 : 0.0;
    final totalExpanded = config.expandedHeight + topPadding + tabHeight;
    final totalCollapsed = config.collapsedHeight + topPadding + tabHeight;

    final effectiveTabController = config.tabController ??
        _internalTabController ??
        DefaultTabController.maybeOf(context);

    return SliverPersistentHeader(
      pinned: true,
      delegate: _TraditionalStructuredDelegate(
        title: widget.title,
        actions: widget.actions,
        leading: widget.leading,
        config: config,
        tabController: effectiveTabController,
        topPadding: topPadding,
        tabHeight: tabHeight,
        totalExpanded: totalExpanded,
        totalCollapsed: totalCollapsed,
      ),
    );
  }
}

class _TraditionalStructuredDelegate extends SliverPersistentHeaderDelegate {
  _TraditionalStructuredDelegate({
    required this.title,
    required this.actions,
    required this.leading,
    required this.config,
    required this.tabController,
    required this.topPadding,
    required this.tabHeight,
    required this.totalExpanded,
    required this.totalCollapsed,
  });

  final Widget? title;
  final List<Widget>? actions;
  final Widget? leading;
  final TraditionalStructuredConfig config;
  final TabController? tabController;
  final double topPadding;
  final double tabHeight;
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

    final activeCrumb = config.breadcrumbs.isNotEmpty
        ? config.breadcrumbs.last.label
        : config.organizationName;

    return Material(
      color: config.backgroundColor ?? theme.colorScheme.surface,
      elevation: overlapsContent || progress > 0.8 ? config.elevation : 0.0,
      surfaceTintColor: config.surfaceTint,
      child: SafeArea(
        top: false,
        bottom: false,
        child: Padding(
          padding: EdgeInsets.only(top: topPadding),
          child: Column(
            children: [
              // Primary Content Canvas (Tiers 1 & 2)
              Expanded(
                child: ClipRect(
                  child: Stack(
                    children: [
                      // --- EXPANDED TIERS 1 & 2 ---
                      if (progress < 0.95)
                        Positioned(
                          left: 16.0,
                          right: 16.0,
                          top: 8.0,
                          child: Opacity(
                            opacity: isReducedMotion
                                ? (progress > 0.5 ? 0.0 : 1.0)
                                : (1.0 - progress * 1.4).clamp(0.0, 1.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // Tier 1: Organization + Environment Badge + Actions
                                Row(
                                  children: [
                                    if (leading != null) ...[
                                      leading!,
                                      const SizedBox(width: 8.0),
                                    ],
                                    const Icon(Icons.business_outlined, size: 20.0),
                                    const SizedBox(width: 8.0),
                                    Flexible(
                                      child: Text(
                                        config.organizationName,
                                        style: theme.textTheme.titleSmall!.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    const SizedBox(width: 10.0),
                                    // Environment Pill
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0, vertical: 2.0),
                                      decoration: BoxDecoration(
                                        color: config.environment.color.withValues(alpha: 0.15),
                                        borderRadius: BorderRadius.circular(12.0),
                                        border: Border.all(
                                          color: config.environment.color.withValues(alpha: 0.4),
                                          width: 1.0,
                                        ),
                                      ),
                                      child: Text(
                                        config.environment.label,
                                        style: TextStyle(
                                          fontSize: 10.0,
                                          fontWeight: FontWeight.w800,
                                          color: config.environment.color.shade800,
                                        ),
                                      ),
                                    ),
                                    const Spacer(),
                                    ...?actions,
                                  ],
                                ),
                                const SizedBox(height: 12.0),

                                // Tier 2: Hierarchical Breadcrumb Path
                                SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children: _buildBreadcrumbs(context, theme),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                      // --- COLLAPSED COMPACT TITLE TOOLBAR ---
                      if (progress > 0.3)
                        Positioned(
                          left: 0.0,
                          right: 0.0,
                          top: 0.0,
                          height: config.collapsedHeight,
                          child: Opacity(
                            opacity: isReducedMotion
                                ? (progress > 0.5 ? 1.0 : 0.0)
                                : ((progress - 0.3) / 0.7).clamp(0.0, 1.0),
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
                                          activeCrumb,
                                          style: theme.textTheme.titleMedium!.copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 6.0, vertical: 2.0),
                                    decoration: BoxDecoration(
                                      color: config.environment.color.withValues(alpha: 0.15),
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    child: Text(
                                      config.environment.label,
                                      style: TextStyle(
                                        fontSize: 9.0,
                                        fontWeight: FontWeight.w800,
                                        color: config.environment.color.shade800,
                                      ),
                                    ),
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

              // --- TIER 3: STICKY TAB STRIP ---
              if (tabHeight > 0.0)
                Container(
                  height: tabHeight,
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
                        width: 0.8,
                      ),
                    ),
                  ),
                  child: TabBar(
                    controller: tabController,
                    isScrollable: true,
                    tabs: config.tabs,
                    tabAlignment: TabAlignment.start,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildBreadcrumbs(BuildContext context, ThemeData theme) {
    final widgets = <Widget>[];
    for (int i = 0; i < config.breadcrumbs.length; i++) {
      final node = config.breadcrumbs[i];
      final isLast = i == config.breadcrumbs.length - 1;

      widgets.add(
        InkWell(
          onTap: node.onTap,
          borderRadius: BorderRadius.circular(6.0),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 2.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (node.icon != null) ...[
                  Icon(node.icon, size: 14.0, color: isLast ? theme.colorScheme.primary : theme.colorScheme.onSurfaceVariant),
                  const SizedBox(width: 4.0),
                ],
                Text(
                  node.label,
                  style: theme.textTheme.bodyMedium!.copyWith(
                    fontWeight: isLast ? FontWeight.bold : FontWeight.normal,
                    color: isLast ? theme.colorScheme.primary : theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ),
      );

      if (!isLast) {
        widgets.add(
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2.0),
            child: Icon(Icons.chevron_right, size: 16.0, color: theme.colorScheme.outline),
          ),
        );
      }
    }
    return widgets;
  }

  @override
  bool shouldRebuild(covariant _TraditionalStructuredDelegate oldDelegate) {
    return oldDelegate.totalExpanded != totalExpanded ||
        oldDelegate.totalCollapsed != totalCollapsed ||
        oldDelegate.config != config ||
        oldDelegate.tabController != tabController ||
        oldDelegate.title != title ||
        oldDelegate.actions != actions ||
        oldDelegate.leading != leading ||
        oldDelegate.topPadding != topPadding ||
        oldDelegate.tabHeight != tabHeight;
  }
}
