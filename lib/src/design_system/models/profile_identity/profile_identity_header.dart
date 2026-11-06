import 'package:flutter/material.dart';
import '../../../widgets/sliver_widget_marker.dart';
import 'profile_identity_config.dart';

/// Model 12: Interactive Profile & Identity Centered Navigation Header.
///
/// Centered identity presentation that scale-morphs and translates into an
/// inline toolbar avatar alongside the name upon upward scrolling.
class ProfileIdentityHeaderWidget extends StatelessWidget with SliverWidgetMarker {
  /// Creates a [ProfileIdentityHeaderWidget].
  const ProfileIdentityHeaderWidget({
    super.key,
    this.title,
    this.leading,
    this.actions,
    this.config = const ProfileIdentityConfig(),
  });

  /// Optional custom title override.
  final Widget? title;

  /// Optional custom leading widget.
  final Widget? leading;

  /// Optional trailing action widgets.
  final List<Widget>? actions;

  /// Strongly-typed configuration for this model.
  final ProfileIdentityConfig config;

  @override
  Widget build(BuildContext context) {
    final topPadding = config.safeArea ? MediaQuery.paddingOf(context).top : 0.0;
    final totalExpanded = config.expandedHeight + topPadding;
    final totalCollapsed = config.collapsedHeight + topPadding;

    return SliverPersistentHeader(
      pinned: true,
      delegate: _ProfileIdentityDelegate(
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

class _ProfileIdentityDelegate extends SliverPersistentHeaderDelegate {
  _ProfileIdentityDelegate({
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
  final ProfileIdentityConfig config;
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
                  // --- EXPANDED CENTERED IDENTITY STACK ---
                  if (progress < 0.85)
                    Opacity(
                      opacity: isReducedMotion
                          ? (progress > 0.5 ? 0.0 : 1.0)
                          : (1.0 - progress * 1.3).clamp(0.0, 1.0),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                            // Centered Avatar with Verified Badge
                            Stack(
                              children: [
                                config.avatarWidget ??
                                    CircleAvatar(
                                      radius: config.expandedAvatarSize / 2,
                                      backgroundColor: theme.colorScheme.primaryContainer,
                                      child: Icon(
                                        Icons.person,
                                        size: config.expandedAvatarSize * 0.55,
                                        color: theme.colorScheme.primary,
                                      ),
                                    ),
                                if (config.verified)
                                  Positioned(
                                    right: 0.0,
                                    bottom: 0.0,
                                    child: Container(
                                      padding: const EdgeInsets.all(2.0),
                                      decoration: BoxDecoration(
                                        color: theme.colorScheme.surface,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        Icons.verified,
                                        size: 18.0,
                                        color: theme.colorScheme.primary,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 8.0),

                            // Name & Handle
                            FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    config.userName,
                                    style: theme.textTheme.titleMedium!.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(width: 6.0),
                                  Text(
                                    config.userHandle,
                                    style: theme.textTheme.bodySmall!.copyWith(
                                      color: theme.colorScheme.outline,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (config.bio != null) ...[
                              const SizedBox(height: 4.0),
                              FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  config.bio!,
                                  style: theme.textTheme.bodySmall!.copyWith(
                                    color: theme.colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              ),
                            ],

                            // Stat Chips
                            if (config.statChips.isNotEmpty) ...[
                              const SizedBox(height: 8.0),
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: config.statChips.map((chip) {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 3.0),
                                        decoration: BoxDecoration(
                                          color: theme.colorScheme.surfaceContainerHighest,
                                          borderRadius: BorderRadius.circular(12.0),
                                        ),
                                        child: Text(
                                          chip,
                                          style: TextStyle(
                                            fontSize: 10.5,
                                            fontWeight: FontWeight.w600,
                                            color: theme.colorScheme.onSurfaceVariant,
                                          ),
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),

                  // --- COLLAPSED COMPACT PINNED TOOLBAR ---
                  if (progress > 0.4)
                    Positioned(
                      left: 0.0,
                      right: 0.0,
                      top: 0.0,
                      height: config.collapsedHeight,
                      child: Opacity(
                        opacity: isReducedMotion
                            ? (progress > 0.5 ? 1.0 : 0.0)
                            : ((progress - 0.4) / 0.6).clamp(0.0, 1.0),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Row(
                            children: [
                              if (leading != null) ...[
                                leading!,
                                const SizedBox(width: 8.0),
                              ],
                              // Compact Avatar in Left Slot
                              CircleAvatar(
                                radius: config.collapsedAvatarSize / 2,
                                backgroundColor: theme.colorScheme.primaryContainer,
                                child: Icon(
                                  Icons.person,
                                  size: config.collapsedAvatarSize * 0.6,
                                  color: theme.colorScheme.primary,
                                ),
                              ),
                              const SizedBox(width: 10.0),
                              Expanded(
                                child: title ??
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Flexible(
                                          child: Text(
                                            config.userName,
                                            style: theme.textTheme.titleMedium!.copyWith(
                                              fontWeight: FontWeight.bold,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        if (config.verified) ...[
                                          const SizedBox(width: 4.0),
                                          Icon(
                                            Icons.verified,
                                            size: 16.0,
                                            color: theme.colorScheme.primary,
                                          ),
                                        ],
                                      ],
                                    ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.person_add_outlined, size: 20.0),
                                onPressed: () {},
                                tooltip: 'Connect',
                              ),
                              IconButton(
                                icon: const Icon(Icons.more_vert, size: 20.0),
                                onPressed: () {},
                                tooltip: 'More Options',
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
  bool shouldRebuild(covariant _ProfileIdentityDelegate oldDelegate) {
    return oldDelegate.totalExpanded != totalExpanded ||
        oldDelegate.totalCollapsed != totalCollapsed ||
        oldDelegate.config != config ||
        oldDelegate.title != title ||
        oldDelegate.actions != actions ||
        oldDelegate.leading != leading ||
        oldDelegate.topPadding != topPadding;
  }
}
