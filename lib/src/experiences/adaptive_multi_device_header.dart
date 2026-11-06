import 'package:flutter/material.dart';
import 'experience_configs.dart';

/// Style 30: Adaptive Multi-Device Responsive Header.
///
/// Reflows its visual architecture dynamically based on screen form factor:
/// compact single-row on mobile, two-tier split on tablet/foldables, and a
/// 3-column navigation hub with global search and profile chip on desktop.
class AdaptiveMultiDeviceHeaderWidget extends StatelessWidget {
  /// Creates an [AdaptiveMultiDeviceHeaderWidget].
  const AdaptiveMultiDeviceHeaderWidget({
    super.key,
    required this.title,
    this.searchBar,
    this.tabs,
    this.actions,
    this.avatar,
    this.backgroundColor,
    this.safeArea = true,
    this.config = const AdaptiveMultiDeviceConfig(),
  });

  /// Primary branding / title widget.
  final Widget title;

  /// Global search input widget (used on tablet and desktop).
  final Widget? searchBar;

  /// Category navigation tabs (used on tablet and desktop).
  final List<Widget>? tabs;

  /// Action buttons.
  final List<Widget>? actions;

  /// User avatar widget.
  final Widget? avatar;

  /// Background color.
  final Color? backgroundColor;

  /// Whether to respect top SafeArea padding.
  final bool safeArea;

  /// Adaptive multi-device configuration.
  final AdaptiveMultiDeviceConfig config;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final topPadding = safeArea ? MediaQuery.paddingOf(context).top : 0.0;

    double headerHeight;
    Widget content;

    if (screenWidth < config.mobileBreakpoint) {
      // Mobile Single-Row Mode
      headerHeight = config.mobileHeight;
      content = _buildMobileLayout(context);
    } else if (screenWidth < config.desktopBreakpoint) {
      // Tablet Two-Tier Split Mode
      headerHeight = config.tabletHeight;
      content = _buildTabletLayout(context);
    } else {
      // Desktop 3-Column Hub Mode
      headerHeight = config.desktopHeight;
      content = _buildDesktopLayout(context);
    }

    final totalHeight = headerHeight + topPadding;

    return Material(
      elevation: config.elevation,
      color: backgroundColor ?? Theme.of(context).colorScheme.surface,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: config.curve,
        height: totalHeight,
        padding: EdgeInsets.only(top: topPadding),
        child: content,
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: [
          IconButton(icon: const Icon(Icons.menu), onPressed: () {}),
          const SizedBox(width: 8.0),
          Expanded(
            child: DefaultTextStyle(
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              child: title,
            ),
          ),
          if (actions != null && actions!.isNotEmpty) actions!.first,
          if (avatar != null) ...[
            const SizedBox(width: 6.0),
            SizedBox(width: 32.0, height: 32.0, child: avatar!),
          ],
        ],
      ),
    );
  }

  Widget _buildTabletLayout(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Top Tier: Title, Search, and Actions
          Row(
            children: [
              DefaultTextStyle(
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                child: title,
              ),
              const SizedBox(width: 16.0),
              if (searchBar != null) Expanded(child: searchBar!),
              const SizedBox(width: 12.0),
              ...?actions,
              if (avatar != null) ...[
                const SizedBox(width: 8.0),
                SizedBox(width: 34.0, height: 34.0, child: avatar!),
              ],
            ],
          ),
          // Bottom Tier: Horizontal Navigation Tabs
          if (tabs != null && tabs!.isNotEmpty)
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(children: tabs!),
            ),
        ],
      ),
    );
  }

  Widget _buildDesktopLayout(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Row(
        children: [
          // Column 1: Brand & Title
          DefaultTextStyle(
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  fontWeight: FontWeight.bold,
                ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            child: title,
          ),
          const SizedBox(width: 24.0),

          // Column 2: Center Global Search & Navigation Links
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (searchBar != null)
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 420.0),
                    child: searchBar!,
                  ),
                if (tabs != null) ...[
                  const SizedBox(width: 16.0),
                  ...tabs!,
                ],
              ],
            ),
          ),

          // Column 3: Action Toolbar & Profile
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ...?actions,
              if (avatar != null) ...[
                const SizedBox(width: 12.0),
                avatar!,
              ],
            ],
          ),
        ],
      ),
    );
  }
}
