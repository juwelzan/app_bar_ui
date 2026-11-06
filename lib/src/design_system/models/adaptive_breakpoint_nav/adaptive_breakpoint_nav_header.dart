import 'package:flutter/material.dart';
import '../../../widgets/sliver_widget_marker.dart';
import 'adaptive_breakpoint_profile.dart';
import 'adaptive_breakpoint_nav_config.dart';

/// Model 17: Adaptive Breakpoint Navigation Header.
///
/// Automatically reforms between mobile (compact stacked), tablet (split dual-column),
/// and desktop (expansive multi-pane command bar) layouts based on ambient width breakpoints.
class AdaptiveBreakpointNavHeaderWidget extends StatelessWidget with SliverWidgetMarker {
  /// Creates an [AdaptiveBreakpointNavHeaderWidget].
  const AdaptiveBreakpointNavHeaderWidget({
    super.key,
    this.title,
    this.leading,
    this.actions,
    this.config = const AdaptiveBreakpointNavConfig(),
  });

  /// Optional custom title override.
  final Widget? title;

  /// Optional custom leading widget.
  final Widget? leading;

  /// Optional trailing action widgets.
  final List<Widget>? actions;

  /// Strongly-typed configuration for this model.
  final AdaptiveBreakpointNavConfig config;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final width = mediaQuery.size.width > 0.0 ? mediaQuery.size.width : 400.0;
    final profile = AdaptiveBreakpointProfile.fromWidth(width);
    final topPadding = config.safeArea ? mediaQuery.padding.top : 0.0;
    final totalExpanded = config.heightForProfile(profile) + topPadding;
    final totalCollapsed = config.collapsedHeight + topPadding;

    return SliverPersistentHeader(
      pinned: true,
      delegate: _AdaptiveBreakpointNavDelegate(
        title: title,
        leading: leading,
        actions: actions,
        config: config,
        profile: profile,
        topPadding: topPadding,
        totalExpanded: totalExpanded,
        totalCollapsed: totalCollapsed,
      ),
    );
  }
}

class _AdaptiveBreakpointNavDelegate extends SliverPersistentHeaderDelegate {
  _AdaptiveBreakpointNavDelegate({
    required this.title,
    required this.leading,
    required this.actions,
    required this.config,
    required this.profile,
    required this.topPadding,
    required this.totalExpanded,
    required this.totalCollapsed,
  });

  final Widget? title;
  final Widget? leading;
  final List<Widget>? actions;
  final AdaptiveBreakpointNavConfig config;
  final AdaptiveBreakpointProfile profile;
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
                  // --- EXPANDED RESPONSIVE LAYOUT CANVAS ---
                  if (progress < 0.88)
                    Opacity(
                      opacity: isReducedMotion
                          ? (progress > 0.5 ? 0.0 : 1.0)
                          : (1.0 - progress * 1.3).clamp(0.0, 1.0),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                        child: _buildExpandedCanvas(theme),
                      ),
                    ),

                  // --- COLLAPSED COMPACT PINNED TOOLBAR ---
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
                                      config.title,
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
                                  color: theme.colorScheme.primaryContainer,
                                  borderRadius: BorderRadius.circular(6.0),
                                ),
                                child: Text(
                                  profile.name.toUpperCase(),
                                  style: TextStyle(
                                    fontSize: 10.0,
                                    fontWeight: FontWeight.bold,
                                    color: theme.colorScheme.onPrimaryContainer,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 6.0),
                              IconButton(
                                icon: const Icon(Icons.devices, size: 20.0),
                                onPressed: () {},
                                tooltip: 'Device Profile',
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

  Widget _buildExpandedCanvas(ThemeData theme) {
    switch (profile) {
      case AdaptiveBreakpointProfile.compact:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                if (leading != null) ...[
                  leading!,
                  const SizedBox(width: 8.0),
                ],
                Expanded(
                  child: Text(
                    config.title,
                    style: theme.textTheme.titleMedium!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                _buildProfileBadge(theme),
                ...?actions,
              ],
            ),
            const Spacer(),
            Text(
              config.compactSubtitle,
              style: theme.textTheme.bodyMedium!.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 8.0),
          ],
        );

      case AdaptiveBreakpointProfile.medium:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                if (leading != null) ...[
                  leading!,
                  const SizedBox(width: 8.0),
                ],
                Flexible(
                  child: Text(
                    config.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleLarge!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 8.0),
                _buildProfileBadge(theme),
                const Spacer(),
                ...?actions,
              ],
            ),
            const Spacer(),
            Row(
              children: [
                Expanded(
                  child: Text(
                    config.mediumSubtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodyMedium!.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
                const SizedBox(width: 8.0),
                Flexible(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: config.navigationLinks.map((link) {
                        return Padding(
                          padding: const EdgeInsets.only(left: 6.0),
                          child: TextButton(
                            onPressed: () {},
                            style: TextButton.styleFrom(
                              visualDensity: VisualDensity.compact,
                              padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            ),
                            child: Text(link),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],
            ),
          ],
        );

      case AdaptiveBreakpointProfile.expanded:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                if (leading != null) ...[
                  leading!,
                  const SizedBox(width: 8.0),
                ],
                Flexible(
                  child: Text(
                    config.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.headlineSmall!.copyWith(
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                const SizedBox(width: 12.0),
                _buildProfileBadge(theme),
                const SizedBox(width: 16.0),
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: config.navigationLinks.map((link) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 12.0),
                          child: Chip(
                            label: Text(link),
                            visualDensity: VisualDensity.compact,
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                ...?actions,
              ],
            ),
            const Spacer(),
            Text(
              config.expandedSubtitle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.titleSmall!.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        );
    }
  }

  Widget _buildProfileBadge(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 3.0),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(6.0),
        border: Border.all(color: theme.colorScheme.primary.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.dashboard_customize, size: 12.0, color: theme.colorScheme.primary),
          const SizedBox(width: 4.0),
          Text(
            profile.name.toUpperCase(),
            style: TextStyle(
              fontSize: 10.0,
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }

  @override
  bool shouldRebuild(covariant _AdaptiveBreakpointNavDelegate oldDelegate) {
    return oldDelegate.totalExpanded != totalExpanded ||
        oldDelegate.totalCollapsed != totalCollapsed ||
        oldDelegate.config != config ||
        oldDelegate.profile != profile ||
        oldDelegate.title != title ||
        oldDelegate.actions != actions ||
        oldDelegate.leading != leading ||
        oldDelegate.topPadding != topPadding;
  }
}
