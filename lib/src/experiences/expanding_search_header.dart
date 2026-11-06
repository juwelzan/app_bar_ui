import 'dart:math' as math;
import 'dart:ui' show lerpDouble;
import 'package:flutter/material.dart';
import 'experience_configs.dart';

/// Style 25: Expanding Search Transformation Header.
///
/// Action search icon smoothly morphs and expands horizontally into an active
/// full-bleed search bar that takes over the header, shifting actions out of the way.
class ExpandingSearchHeaderWidget extends StatefulWidget {
  /// Creates an [ExpandingSearchHeaderWidget].
  const ExpandingSearchHeaderWidget({
    super.key,
    required this.title,
    this.subtitle,
    this.leading,
    this.actions,
    this.hintText = 'Search...',
    this.onSearchChanged,
    this.onSearchSubmitted,
    this.searchController,
    this.backgroundColor,
    this.safeArea = true,
    this.config = const ExpandingSearchConfig(),
  });

  /// Primary branding / title widget.
  final Widget title;

  /// Optional subtitle.
  final Widget? subtitle;

  /// Optional leading icon (e.g. menu or back button).
  final Widget? leading;

  /// Optional trailing action buttons.
  final List<Widget>? actions;

  /// Placeholder hint text for the search input.
  final String hintText;

  /// Search query change callback.
  final ValueChanged<String>? onSearchChanged;

  /// Search submit callback.
  final ValueChanged<String>? onSearchSubmitted;

  /// Optional external [TextEditingController].
  final TextEditingController? searchController;

  /// Header background color.
  final Color? backgroundColor;

  /// Whether to respect top SafeArea padding.
  final bool safeArea;

  /// Expanding search configuration.
  final ExpandingSearchConfig config;

  @override
  State<ExpandingSearchHeaderWidget> createState() =>
      ExpandingSearchHeaderWidgetState();
}

/// State for [ExpandingSearchHeaderWidget] exposing programmatic toggle methods.
class ExpandingSearchHeaderWidgetState
    extends State<ExpandingSearchHeaderWidget> {
  late final TextEditingController _controller;
  bool _isInternalController = false;
  bool _isSearchActive = false;
  final FocusNode _focusNode = FocusNode();

  /// Whether the full search input is currently active.
  bool get isSearchActive => _isSearchActive;

  @override
  void initState() {
    super.initState();
    if (widget.searchController != null) {
      _controller = widget.searchController!;
    } else {
      _controller = TextEditingController();
      _isInternalController = true;
    }
  }

  @override
  void dispose() {
    if (_isInternalController) {
      _controller.dispose();
    }
    _focusNode.dispose();
    super.dispose();
  }

  /// Programmatically opens or closes the expanded search bar.
  void setSearchActive(bool active) {
    if (_isSearchActive != active) {
      setState(() {
        _isSearchActive = active;
      });
      if (active) {
        _focusNode.requestFocus();
      } else {
        _focusNode.unfocus();
        _controller.clear();
        widget.onSearchChanged?.call('');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final topPadding = widget.safeArea ? MediaQuery.paddingOf(context).top : 0.0;
    final totalExpanded = widget.config.expandedHeight + topPadding;
    final totalCollapsed = widget.config.collapsedHeight + topPadding;

    return SliverPersistentHeader(
      pinned: true,
      delegate: _ExpandingSearchDelegate(
        title: widget.title,
        subtitle: widget.subtitle,
        leading: widget.leading,
        actions: widget.actions,
        hintText: widget.hintText,
        onSearchChanged: widget.onSearchChanged,
        onSearchSubmitted: widget.onSearchSubmitted,
        controller: _controller,
        focusNode: _focusNode,
        isSearchActive: _isSearchActive,
        onToggleSearch: setSearchActive,
        backgroundColor: widget.backgroundColor,
        topPadding: topPadding,
        totalExpanded: totalExpanded,
        totalCollapsed: totalCollapsed,
        config: widget.config,
      ),
    );
  }
}

class _ExpandingSearchDelegate extends SliverPersistentHeaderDelegate {
  _ExpandingSearchDelegate({
    required this.title,
    required this.subtitle,
    required this.leading,
    required this.actions,
    required this.hintText,
    required this.onSearchChanged,
    required this.onSearchSubmitted,
    required this.controller,
    required this.focusNode,
    required this.isSearchActive,
    required this.onToggleSearch,
    required this.backgroundColor,
    required this.topPadding,
    required this.totalExpanded,
    required this.totalCollapsed,
    required this.config,
  });

  final Widget title;
  final Widget? subtitle;
  final Widget? leading;
  final List<Widget>? actions;
  final String hintText;
  final ValueChanged<String>? onSearchChanged;
  final ValueChanged<String>? onSearchSubmitted;
  final TextEditingController controller;
  final FocusNode focusNode;
  final bool isSearchActive;
  final ValueChanged<bool> onToggleSearch;
  final Color? backgroundColor;
  final double topPadding;
  final double totalExpanded;
  final double totalCollapsed;
  final ExpandingSearchConfig config;

  @override
  double get minExtent => totalCollapsed;

  @override
  double get maxExtent => totalExpanded;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    final theme = Theme.of(context);
    final isReducedMotion = MediaQuery.disableAnimationsOf(context);

    final rawProgress =
        (shrinkOffset / config.expandThreshold).clamp(0.0, 1.0);
    final curve = config.resolveCurve(context);
    final progress = curve.transform(rawProgress);

    final screenWidth = MediaQuery.sizeOf(context).width;
    final resolvedBg = backgroundColor ?? theme.colorScheme.surface;

    // Search expand factor is 1.0 if manually active or during scroll down
    final expandFactor = isSearchActive
        ? 1.0
        : (isReducedMotion ? (progress > 0.5 ? 1.0 : 0.0) : progress);

    final restingWidth = 44.0;
    final activeWidth =
        math.max(restingWidth, screenWidth > 32.0 ? screenWidth - 32.0 : restingWidth);
    final currentSearchWidth =
        lerpDouble(restingWidth, activeWidth, expandFactor) ?? restingWidth;

    final headerOpacity = (1.0 - expandFactor * 1.5).clamp(0.0, 1.0);

    return SizedBox.expand(
      child: Material(
        elevation: shrinkOffset > 5.0 ? config.elevation : 0.0,
        color: resolvedBg,
        child: ClipRect(
          child: Padding(
            padding: EdgeInsets.only(top: topPadding),
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Resting Title, Subtitle, and Leading Bar
                if (headerOpacity > 0.01)
                  Positioned(
                    top: 10.0,
                    left: leading != null ? 56.0 : 16.0,
                    right: 70.0,
                    child: Opacity(
                      opacity: headerOpacity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          DefaultTextStyle(
                            style: theme.textTheme.titleMedium!.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            child: title,
                          ),
                          if (subtitle != null) ...[
                            const SizedBox(height: 2.0),
                            DefaultTextStyle(
                              style: theme.textTheme.bodySmall!,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              child: subtitle!,
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),

                // Leading Widget
                if (leading != null && headerOpacity > 0.01)
                  Positioned(
                    top: 6.0,
                    left: 4.0,
                    child: Opacity(
                      opacity: headerOpacity,
                      child: leading!,
                    ),
                  ),

                // Trailing Actions (fade out when search expands)
                if (actions != null && headerOpacity > 0.01)
                  Positioned(
                    top: 6.0,
                    right: 56.0,
                    child: Opacity(
                      opacity: headerOpacity,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: actions!,
                      ),
                    ),
                  ),

                // Morphing & Expanding Search Bar Container
                Positioned(
                  top: isReducedMotion
                      ? (expandFactor > 0.5 ? 8.0 : 10.0)
                      : (lerpDouble(10.0, 8.0, expandFactor) ?? 10.0),
                  right: 16.0,
                  width: currentSearchWidth,
                  height: config.searchBarHeight,
                  child: Material(
                    elevation: expandFactor > 0.5 ? 2.0 : 0.0,
                    borderRadius: BorderRadius.circular(24.0),
                    color: theme.colorScheme.surfaceContainerHighest,
                    child: expandFactor < 0.35 && !isSearchActive
                        ? IconButton(
                            icon: const Icon(Icons.search),
                            tooltip: 'Search',
                            onPressed: () => onToggleSearch(true),
                          )
                        : Row(
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(left: 12.0, right: 8.0),
                                child: Icon(Icons.search, size: 20.0),
                              ),
                              Expanded(
                                child: TextField(
                                  controller: controller,
                                  focusNode: focusNode,
                                  decoration: InputDecoration(
                                    hintText: hintText,
                                    border: InputBorder.none,
                                    isDense: true,
                                    contentPadding: const EdgeInsets.symmetric(
                                      vertical: 8.0,
                                    ),
                                  ),
                                  onChanged: onSearchChanged,
                                  onSubmitted: onSearchSubmitted,
                                ),
                              ),
                              if (controller.text.isNotEmpty)
                                IconButton(
                                  icon: const Icon(Icons.clear, size: 18.0),
                                  onPressed: () {
                                    controller.clear();
                                    onSearchChanged?.call('');
                                  },
                                ),
                              IconButton(
                                icon: const Icon(Icons.arrow_forward, size: 18.0),
                                tooltip: 'Close Search',
                                onPressed: () => onToggleSearch(false),
                              ),
                            ],
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(covariant _ExpandingSearchDelegate oldDelegate) {
    return oldDelegate.title != title ||
        oldDelegate.subtitle != subtitle ||
        oldDelegate.leading != leading ||
        oldDelegate.actions != actions ||
        oldDelegate.hintText != hintText ||
        oldDelegate.controller != controller ||
        oldDelegate.focusNode != focusNode ||
        oldDelegate.isSearchActive != isSearchActive ||
        oldDelegate.backgroundColor != backgroundColor ||
        oldDelegate.topPadding != topPadding ||
        oldDelegate.totalExpanded != totalExpanded ||
        oldDelegate.totalCollapsed != totalCollapsed ||
        oldDelegate.config != config;
  }
}
