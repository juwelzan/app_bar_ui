import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../models/visibility_config.dart';
import 'scroll_snap_engine.dart';
import 'smart_visibility_controller.dart';

/// An advanced [ScrollController] that unifies programmatic scrolling,
/// smart component visibility, header collapse/expand controls, and scroll snap navigation.
///
/// Can be passed directly to [ScrollResponsiveScaffold.controller] with full backward compatibility.
class ScrollResponsiveController extends ScrollController {
  /// Creates a [ScrollResponsiveController].
  ScrollResponsiveController({
    super.initialScrollOffset,
    super.keepScrollOffset,
    super.debugLabel,
    super.onAttach,
    super.onDetach,
    SmartVisibilityConfig? visibilityConfig,
    this.snapConfig = const ScrollSnapConfig(),
    this.headerCollapsedOffset = 120.0,
  }) : visibilityController = SmartVisibilityController(
         config: visibilityConfig ?? SmartVisibilityConfig(),
       );

  /// Centralized visibility controller managing header, actions, FAB, and status bar.
  final SmartVisibilityController visibilityController;

  /// Configuration governing scroll snapping.
  final ScrollSnapConfig snapConfig;

  /// Scroll offset in pixels where the header is considered fully collapsed.
  final double headerCollapsedOffset;

  /// Current normalized scroll progress (0.0 at top, 1.0 at maximum scroll extent).
  double get progress {
    if (!hasClients || position.maxScrollExtent <= 0) return 0.0;
    return (offset / position.maxScrollExtent).clamp(0.0, 1.0);
  }

  /// Current user scroll direction.
  ScrollDirection get direction =>
      hasClients ? position.userScrollDirection : ScrollDirection.idle;

  /// Smoothly animates the scroll position to the top (0.0).
  Future<void> scrollToTop({
    Duration duration = const Duration(milliseconds: 300),
    Curve curve = Curves.easeOutCubic,
  }) async {
    if (!hasClients) return;
    await animateTo(0.0, duration: duration, curve: curve);
  }

  /// Smoothly animates the scroll position to the bottom ([ScrollPosition.maxScrollExtent]).
  Future<void> scrollToBottom({
    Duration duration = const Duration(milliseconds: 300),
    Curve curve = Curves.easeOutCubic,
  }) async {
    if (!hasClients) return;
    await animateTo(position.maxScrollExtent, duration: duration, curve: curve);
  }

  /// Smoothly animates scrolling past the header to [headerCollapsedOffset].
  Future<void> collapseHeader({
    Duration duration = const Duration(milliseconds: 250),
    Curve curve = Curves.easeInOutCubic,
  }) async {
    if (!hasClients) return;
    await animateTo(
      headerCollapsedOffset.clamp(
        position.minScrollExtent,
        position.maxScrollExtent,
      ),
      duration: duration,
      curve: curve,
    );
  }

  /// Smoothly expands the header back into view at the top.
  Future<void> expandHeader({
    Duration duration = const Duration(milliseconds: 250),
    Curve curve = Curves.easeInOutCubic,
  }) async {
    await scrollToTop(duration: duration, curve: curve);
  }

  /// Smoothly animates to a specific [targetOffset].
  Future<void> snapTo(
    double targetOffset, {
    Duration duration = const Duration(milliseconds: 250),
    Curve curve = Curves.easeOutCubic,
  }) async {
    if (!hasClients) return;
    await animateTo(
      targetOffset.clamp(position.minScrollExtent, position.maxScrollExtent),
      duration: duration,
      curve: curve,
    );
  }

  /// Programmatically overrides the visibility of a specific [target].
  void setVisibility(VisibilityTarget target, double visibility) {
    visibilityController.setVisibility(target, visibility);
  }

  @override
  void dispose() {
    visibilityController.dispose();
    super.dispose();
  }
}
