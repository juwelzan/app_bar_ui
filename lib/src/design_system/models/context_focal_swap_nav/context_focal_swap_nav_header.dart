import 'package:flutter/material.dart';
import '../../../widgets/sliver_widget_marker.dart';
import 'context_focal_swap_nav_config.dart';

/// Model 18: Context Focal Swap Navigation Header.
///
/// Features dynamic swapping between multiple distinct operational domains
/// (e.g. Finance, DevOps, Security). Selecting a domain cross-fades the primary metric,
/// action controls, and thematic styling. On scroll, collapses into a consolidated pinned
/// toolbar showing the active domain badge and telemetry.
class ContextFocalSwapNavHeaderWidget extends StatelessWidget with SliverWidgetMarker {
  /// Creates a [ContextFocalSwapNavHeaderWidget].
  const ContextFocalSwapNavHeaderWidget({
    super.key,
    this.title,
    this.leading,
    this.actions,
    this.config = const ContextFocalSwapNavConfig(),
  });

  /// Optional custom title override.
  final Widget? title;

  /// Optional custom leading widget.
  final Widget? leading;

  /// Optional trailing action widgets.
  final List<Widget>? actions;

  /// Strongly-typed configuration for this model.
  final ContextFocalSwapNavConfig config;

  @override
  Widget build(BuildContext context) {
    final topPadding = config.safeArea ? MediaQuery.paddingOf(context).top : 0.0;
    final totalExpanded = config.expandedHeight + topPadding;
    final totalCollapsed = config.collapsedHeight + topPadding;

    return SliverPersistentHeader(
      pinned: true,
      delegate: _ContextFocalSwapNavDelegate(
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

class _ContextFocalSwapNavDelegate extends SliverPersistentHeaderDelegate {
  _ContextFocalSwapNavDelegate({
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
  final ContextFocalSwapNavConfig config;
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

    final activeDomain = config.domains.isNotEmpty
        ? config.domains[config.activeDomainIndex.clamp(0, config.domains.length - 1)]
        : null;

    final accent = activeDomain?.accentColor ?? theme.colorScheme.primary;

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
                  // --- EXPANDED FOCAL CONTEXT CANVAS ---
                  if (progress < 0.88 && activeDomain != null)
                    Opacity(
                      opacity: isReducedMotion
                          ? (progress > 0.5 ? 0.0 : 1.0)
                          : (1.0 - progress * 1.3).clamp(0.0, 1.0),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Top Row: Domain Selector Pills
                            Row(
                              children: [
                                if (leading != null) ...[
                                  leading!,
                                  const SizedBox(width: 8.0),
                                ],
                                Expanded(
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      children: List.generate(config.domains.length, (idx) {
                                        final domain = config.domains[idx];
                                        final isSelected = idx == config.activeDomainIndex;
                                        return Padding(
                                          padding: const EdgeInsets.only(right: 6.0),
                                          child: InkWell(
                                            onTap: () => config.onDomainSwapped?.call(idx),
                                            borderRadius: BorderRadius.circular(8.0),
                                            child: AnimatedContainer(
                                              duration: const Duration(milliseconds: 200),
                                              padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
                                              decoration: BoxDecoration(
                                                color: isSelected
                                                    ? (domain.accentColor ?? theme.colorScheme.primary)
                                                    : theme.colorScheme.surfaceContainerHigh,
                                                borderRadius: BorderRadius.circular(8.0),
                                              ),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Icon(
                                                    domain.icon,
                                                    size: 13.0,
                                                    color: isSelected
                                                        ? Colors.white
                                                        : theme.colorScheme.onSurfaceVariant,
                                                  ),
                                                  const SizedBox(width: 4.0),
                                                  Text(
                                                    domain.name,
                                                    style: TextStyle(
                                                      fontSize: 11.0,
                                                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                                      color: isSelected
                                                        ? Colors.white
                                                        : theme.colorScheme.onSurfaceVariant,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      }),
                                    ),
                                  ),
                                ),
                                ...?actions,
                              ],
                            ),
                            const Spacer(),

                            // Active Focal Domain Prominent Metric Display
                            FittedBox(
                              fit: BoxFit.scaleDown,
                              alignment: Alignment.centerLeft,
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(10.0),
                                    decoration: BoxDecoration(
                                      color: accent.withValues(alpha: 0.15),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(activeDomain.icon, size: 28.0, color: accent),
                                  ),
                                  const SizedBox(width: 14.0),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        activeDomain.primaryMetric,
                                        style: TextStyle(
                                          fontSize: 28.0,
                                          fontWeight: FontWeight.w900,
                                          letterSpacing: -0.5,
                                          color: theme.colorScheme.onSurface,
                                        ),
                                      ),
                                      Text(
                                        activeDomain.metricLabel,
                                        style: TextStyle(
                                          fontSize: 12.0,
                                          fontWeight: FontWeight.w600,
                                          color: accent,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 8.0),
                          ],
                        ),
                      ),
                    ),

                  // --- COLLAPSED COMPACT PINNED TOOLBAR ---
                  if (progress > 0.35 && activeDomain != null)
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
                                      activeDomain.name,
                                      style: theme.textTheme.titleMedium!.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 3.0),
                                decoration: BoxDecoration(
                                  color: accent.withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(6.0),
                                ),
                                child: Text(
                                  activeDomain.primaryMetric,
                                  style: TextStyle(
                                    fontSize: 11.0,
                                    fontWeight: FontWeight.bold,
                                    color: accent,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 6.0),
                              IconButton(
                                icon: const Icon(Icons.swap_horiz, size: 20.0),
                                onPressed: () {
                                  final nextIdx = (config.activeDomainIndex + 1) % config.domains.length;
                                  config.onDomainSwapped?.call(nextIdx);
                                },
                                tooltip: 'Swap Domain',
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
  bool shouldRebuild(covariant _ContextFocalSwapNavDelegate oldDelegate) {
    return oldDelegate.totalExpanded != totalExpanded ||
        oldDelegate.totalCollapsed != totalCollapsed ||
        oldDelegate.config != config ||
        oldDelegate.title != title ||
        oldDelegate.actions != actions ||
        oldDelegate.leading != leading ||
        oldDelegate.topPadding != topPadding;
  }
}

