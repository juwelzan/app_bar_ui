import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../engine/scroll_responsive_engine.dart';
import '../engine/status_bar_manager.dart';
import '../models/scroll_responsive_config.dart';
import 'pinned_action_button.dart';
import 'scroll_auto_hide_bottom_bar.dart';
import 'scroll_aware_fab.dart';
import 'scroll_responsive_header.dart';
import 'scroll_sticky_tab_bar.dart';
import '../engine/scroll_responsive_controller.dart';

/// The primary widget providing an advanced, configurable Scroll-Responsive UI system.
///
/// Combines:
/// - Natural Sliver-style scrolling for header and body content.
/// - Independently pinned left and right side action icons.
/// - Scroll-driven dual icon transitions (e.g. Profile Avatar -> Drawer Button and
///   Notification -> Profile Avatar).
/// - Responsive native System Status Bar visibility with hysteresis.
/// - Zero unnecessary widget rebuilds using targeted listenable notifications.
class ScrollResponsiveScaffold extends StatefulWidget {
  /// Creates a [ScrollResponsiveScaffold].
  const ScrollResponsiveScaffold({
    super.key,
    this.initialLeading,
    this.scrolledLeading,
    this.initialTrailing,
    this.scrolledTrailing,
    this.header,
    this.headerTitle,
    this.headerSubtitle,
    this.body,
    this.slivers,
    this.onLeadingInitialTap,
    this.onLeadingScrolledTap,
    this.onTrailingInitialTap,
    this.onTrailingScrolledTap,
    this.controller,
    this.config = const ScrollResponsiveConfig(),
    this.drawer,
    this.endDrawer,
    this.bottomNavigationBar,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.stickyTabBar,
    this.progressIndicator,
    this.scrollAwareFab = false,
    this.autoHideBottomBar = false,
    this.backgroundColor,
    this.physics,
    this.semanticLabelLeadingInitial,
    this.semanticLabelLeadingScrolled,
    this.semanticLabelTrailingInitial,
    this.semanticLabelTrailingScrolled,
    this.onScrollUpdate,
    this.onScrollDirectionChanged,
    this.onScrollStart,
    this.onScrollEnd,
    this.routeObserver,
  }) : assert(
         body != null || slivers != null,
         'Either body or slivers must be provided.',
       );

  /// The widget displayed initially in the pinned left position (e.g. Profile Avatar).
  final Widget? initialLeading;

  /// The widget displayed in the pinned left position after scrolling (e.g. Drawer Button).
  final Widget? scrolledLeading;

  /// The widget displayed initially in the pinned right position (e.g. Notification Button).
  final Widget? initialTrailing;

  /// The widget displayed in the pinned right position after scrolling (e.g. Profile Avatar).
  final Widget? scrolledTrailing;

  /// Full custom header widget that scrolls naturally away with the page.
  final Widget? header;

  /// Convenience title widget when [header] is not explicitly specified.
  final Widget? headerTitle;

  /// Convenience subtitle widget when [header] is not explicitly specified.
  final Widget? headerSubtitle;

  /// The main scrollable body content.
  final Widget? body;

  /// Optional custom slivers list. When supplied, takes precedence over [body].
  final List<Widget>? slivers;

  /// Tap callback for the leading action in its initial state.
  final VoidCallback? onLeadingInitialTap;

  /// Tap callback for the leading action in its scrolled state.
  /// Defaults to opening [drawer] if [drawer] is provided and this callback is null.
  final VoidCallback? onLeadingScrolledTap;

  /// Tap callback for the trailing action in its initial state.
  final VoidCallback? onTrailingInitialTap;

  /// Tap callback for the trailing action in its scrolled state.
  final VoidCallback? onTrailingScrolledTap;

  /// Optional external [ScrollController]. An internal controller is managed automatically if omitted.
  final ScrollController? controller;

  /// Full configuration governing thresholds, animations, status bar, and pinned actions.
  final ScrollResponsiveConfig config;

  /// Navigation drawer widget opened automatically by the scrolled leading icon if configured.
  final Widget? drawer;

  /// End drawer widget.
  final Widget? endDrawer;

  /// Bottom navigation bar widget.
  final Widget? bottomNavigationBar;

  /// Floating action button widget.
  final Widget? floatingActionButton;

  /// Location of the floating action button.
  final FloatingActionButtonLocation? floatingActionButtonLocation;

  /// Optional sticky tab bar widget pinned beneath the header when scrolling past.
  final Widget? stickyTabBar;

  /// Optional scroll/reading progress indicator pinned at the very top of the scaffold.
  final Widget? progressIndicator;

  /// Whether to automatically wrap [floatingActionButton] in a [ScrollAwareFab].
  final bool scrollAwareFab;

  /// Whether to automatically wrap [bottomNavigationBar] in a [ScrollAutoHideBottomBar].
  final bool autoHideBottomBar;

  /// Background color of the underlying scaffold.
  final Color? backgroundColor;

  /// Scroll physics for the scrollable view.
  final ScrollPhysics? physics;

  /// Semantic label for leading initial icon.
  final String? semanticLabelLeadingInitial;

  /// Semantic label for leading scrolled icon.
  final String? semanticLabelLeadingScrolled;

  /// Semantic label for trailing initial icon.
  final String? semanticLabelTrailingInitial;

  /// Semantic label for trailing scrolled icon.
  final String? semanticLabelTrailingScrolled;

  /// Real-time callback triggered with progress details on each scroll update.
  final ValueChanged<ScrollProgressDetails>? onScrollUpdate;

  /// Callback triggered when the user scroll direction changes.
  final ValueChanged<ScrollDirection>? onScrollDirectionChanged;

  /// Optional callback invoked when scrolling initiates.
  final ValueChanged<ScrollStartNotification>? onScrollStart;

  /// Optional callback invoked when scrolling concludes.
  final ValueChanged<ScrollEndNotification>? onScrollEnd;

  /// Optional [RouteObserver] to automatically manage status bar visibility across route transitions.
  final RouteObserver<ModalRoute<void>>? routeObserver;

  @override
  State<ScrollResponsiveScaffold> createState() =>
      _ScrollResponsiveScaffoldState();
}

class _ScrollResponsiveScaffoldState extends State<ScrollResponsiveScaffold>
    with RouteAware, WidgetsBindingObserver {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  late ScrollResponsiveEngine _engine;
  late StatusBarManager _statusBarManager;
  double _maxObservedTopPadding = 0.0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initEngine();
    _initStatusBarManager();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (widget.routeObserver != null) {
      final route = ModalRoute.of(context);
      if (route != null) {
        widget.routeObserver!.subscribe(this, route);
      }
    }
  }

  void _initEngine() {
    _engine = ScrollResponsiveEngine(
      config: widget.config,
      customController: widget.controller,
      onProgressChanged: (details) {
        widget.onScrollUpdate?.call(details);
        _statusBarManager.updateScrollOffset(details.offset);
        if (widget.controller is ScrollResponsiveController) {
          (widget.controller! as ScrollResponsiveController)
              .visibilityController
              .updateScroll(details.offset, direction: details.scrollDirection);
        }
      },
      onDirectionChanged: (direction) {
        widget.onScrollDirectionChanged?.call(direction);
        if (widget.controller is ScrollResponsiveController) {
          (widget.controller! as ScrollResponsiveController)
              .visibilityController
              .updateScroll(_engine.currentOffset, direction: direction);
        }
      },
      onScrollStart: widget.onScrollStart,
      onScrollEnd: widget.onScrollEnd,
    );
  }

  void _initStatusBarManager() {
    _statusBarManager = StatusBarManager(
      config: widget.config.effectiveStatusBar,
      thresholds: widget.config.thresholds,
    );
  }

  @override
  void didUpdateWidget(ScrollResponsiveScaffold oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.routeObserver != oldWidget.routeObserver) {
      oldWidget.routeObserver?.unsubscribe(this);
      if (widget.routeObserver != null) {
        final route = ModalRoute.of(context);
        if (route != null) {
          widget.routeObserver!.subscribe(this, route);
        }
      }
    }

    _engine.updateConfig(widget.config);
    if (widget.controller != oldWidget.controller) {
      _engine.updateController(widget.controller);
    }

    _statusBarManager.config = widget.config.effectiveStatusBar;
    _statusBarManager.thresholds = widget.config.thresholds;
  }

  @override
  void didPushNext() {
    // Temporarily restores status bar when another route is pushed on top
    _statusBarManager.handleRoutePushed();
  }

  @override
  void didPopNext() {
    // Reapplies status bar state based on current scroll position when popped back
    _statusBarManager.handleRoutePopped(_engine.currentOffset);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _statusBarManager.handleAppLifecycleStateChanged(
      state,
      _engine.currentOffset,
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    widget.routeObserver?.unsubscribe(this);
    _engine.dispose();
    _statusBarManager.restore();
    super.dispose();
  }

  void _handleLeadingScrolledTap() {
    if (widget.onLeadingScrolledTap != null) {
      widget.onLeadingScrolledTap!();
    } else if (widget.drawer != null) {
      _scaffoldKey.currentState?.openDrawer();
    }
  }

  void _handleTrailingScrolledTap() {
    if (widget.onTrailingScrolledTap != null) {
      widget.onTrailingScrolledTap!();
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final topPadding = mediaQuery.padding.top;

    // Track maximum observed top padding to prevent content jump when status bar hides
    if (topPadding > _maxObservedTopPadding) {
      _maxObservedTopPadding = topPadding;
    }

    final double effectiveTopPadding =
        widget.config.effectiveStatusBar.preventContentJump
        ? math.max(_maxObservedTopPadding, topPadding)
        : topPadding;

    final pinnedConfig = widget.config.effectivePinnedActions;

    Widget? effectiveFab = widget.floatingActionButton;
    if (effectiveFab != null && widget.scrollAwareFab) {
      effectiveFab = ScrollAwareFab(
        scrollController: _engine.controller,
        child: effectiveFab,
      );
    }

    Widget? effectiveBottomNav = widget.bottomNavigationBar;
    if (effectiveBottomNav != null && widget.autoHideBottomBar) {
      effectiveBottomNav = ScrollAutoHideBottomBar(
        scrollController: _engine.controller,
        child: effectiveBottomNav,
      );
    }

    return Scaffold(
      key: _scaffoldKey,
      drawer: widget.drawer,
      endDrawer: widget.endDrawer,
      bottomNavigationBar: effectiveBottomNav,
      floatingActionButton: effectiveFab,
      floatingActionButtonLocation: widget.floatingActionButtonLocation,
      backgroundColor: widget.backgroundColor,
      body: NotificationListener<ScrollNotification>(
        onNotification: _engine.handleScrollNotification,
        child: NotificationListener<UserScrollNotification>(
          onNotification: _engine.handleUserScrollNotification,
          child: Stack(
            children: [
              // Layer 1: Naturally scrollable CustomScrollView containing header and body
              _buildScrollableContent(effectiveTopPadding),

              // Layer 2: Independently pinned left and right side action icons
              if (pinnedConfig.pinned)
                ..._buildPinnedActionOverlays(
                  effectiveTopPadding,
                  pinnedConfig,
                ),

              // Layer 3: Reading / Scroll Progress Indicator
              if (widget.progressIndicator != null)
                Positioned(
                  top: effectiveTopPadding,
                  left: 0,
                  right: 0,
                  child: widget.progressIndicator!,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildScrollableContent(double effectiveTopPadding) {
    final List<Widget> sliverList = [];

    // Header sliver
    if (widget.header != null) {
      sliverList.add(SliverToBoxAdapter(child: widget.header!));
    } else if (widget.headerTitle != null || widget.headerSubtitle != null) {
      sliverList.add(
        SliverToBoxAdapter(
          child: ScrollResponsiveHeader(
            title: widget.headerTitle,
            subtitle: widget.headerSubtitle,
          ),
        ),
      );
    }

    // Optional Sticky Tab Bar sliver (placed directly below header, before body)
    if (widget.stickyTabBar != null) {
      if (widget.stickyTabBar is ScrollStickyTabBar) {
        sliverList.add(widget.stickyTabBar!);
      } else {
        sliverList.add(ScrollStickyTabBar(child: widget.stickyTabBar!));
      }
    }

    // Body slivers
    if (widget.slivers != null) {
      sliverList.addAll(widget.slivers!);
    } else if (widget.body != null) {
      sliverList.add(SliverToBoxAdapter(child: widget.body!));
    }

    return CustomScrollView(
      controller: _engine.controller,
      physics: widget.physics ?? const AlwaysScrollableScrollPhysics(),
      slivers: sliverList,
    );
  }

  List<Widget> _buildPinnedActionOverlays(
    double effectiveTopPadding,
    PinnedActionsConfig pinnedConfig,
  ) {
    final double safeTop = pinnedConfig.safeArea ? effectiveTopPadding : 0.0;
    final EdgeInsets padding = pinnedConfig.padding.resolve(
      Directionality.of(context),
    );
    final double topPosition = safeTop + padding.top;

    return [
      // Left Action - independently pinned, transparent, no occlusion of center
      Positioned(
        top: topPosition,
        left: padding.left,
        child: ValueListenableBuilder<double>(
          valueListenable: _engine.leadingProgressNotifier,
          builder: (context, progress, child) {
            return PinnedActionButton(
              key: const ValueKey('pinned_leading_action'),
              initialWidget: widget.initialLeading,
              scrolledWidget: widget.scrolledLeading,
              progress: progress,
              onInitialTap: widget.onLeadingInitialTap,
              onScrolledTap: _handleLeadingScrolledTap,
              animationConfig: widget.config.effectiveAnimation,
              touchTargetSize: pinnedConfig.touchTargetSize,
              alignment: Alignment.centerLeft,
              semanticLabelInitial: widget.semanticLabelLeadingInitial,
              semanticLabelScrolled: widget.semanticLabelLeadingScrolled,
            );
          },
        ),
      ),

      // Right Action - independently pinned, transparent, no occlusion of center
      Positioned(
        top: topPosition,
        right: padding.right,
        child: ValueListenableBuilder<double>(
          valueListenable: _engine.trailingProgressNotifier,
          builder: (context, progress, child) {
            return PinnedActionButton(
              key: const ValueKey('pinned_trailing_action'),
              initialWidget: widget.initialTrailing,
              scrolledWidget: widget.scrolledTrailing,
              progress: progress,
              onInitialTap: widget.onTrailingInitialTap,
              onScrolledTap: _handleTrailingScrolledTap,
              animationConfig: widget.config.effectiveAnimation,
              touchTargetSize: pinnedConfig.touchTargetSize,
              alignment: Alignment.centerRight,
              semanticLabelInitial: widget.semanticLabelTrailingInitial,
              semanticLabelScrolled: widget.semanticLabelTrailingScrolled,
            );
          },
        ),
      ),
    ];
  }
}
