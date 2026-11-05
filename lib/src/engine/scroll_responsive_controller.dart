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

  /// Current raw scroll offset in pixels (0.0 if detached).
  double get currentOffset => hasClients ? offset : 0.0;

  /// Maximum scroll extent of the attached view (0.0 if detached or boundless).
  double get maxScrollExtent =>
      (hasClients && position.haveDimensions) ? position.maxScrollExtent : 0.0;

  /// Whether the scroll position is currently at the top of the viewport (offset <= 0.0).
  bool get isAtTop => hasClients && offset <= 0.0;

  /// Whether the scroll position is currently at the bottom of the viewport.
  bool get isAtBottom =>
      hasClients &&
      position.haveDimensions &&
      offset >= position.maxScrollExtent;

  /// Whether the header is currently fully collapsed past [headerCollapsedOffset].
  bool get isHeaderCollapsed => hasClients && offset >= headerCollapsedOffset;

  /// Whether the header is currently fully expanded at the top.
  bool get isHeaderExpanded => hasClients && offset <= 0.0;

  /// Smoothly animates the scroll position by a relative [delta] in pixels.
  Future<void> scrollBy(
    double delta, {
    Duration duration = const Duration(milliseconds: 200),
    Curve curve = Curves.easeOut,
  }) async {
    if (!hasClients) return;
    final target = (offset + delta).clamp(
      position.minScrollExtent,
      position.maxScrollExtent,
    );
    await animateTo(target, duration: duration, curve: curve);
  }

  /// Smoothly animates to an item at [index] for lists with fixed [itemExtent].
  Future<void> scrollToItem(
    int index, {
    required double itemExtent,
    Duration duration = const Duration(milliseconds: 250),
    Curve curve = Curves.easeInOutCubic,
  }) async {
    if (!hasClients) return;
    final target = (index * itemExtent).clamp(
      position.minScrollExtent,
      position.maxScrollExtent,
    );
    await animateTo(target, duration: duration, curve: curve);
  }

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

  /// Convenience method to show a specific component.
  void show(VisibilityTarget target) => visibilityController.show(target);

  /// Convenience method to hide a specific component.
  void hide(VisibilityTarget target) => visibilityController.hide(target);

  /// Toggles visibility of a specific component between 0.0 and 1.0.
  void toggle(VisibilityTarget target) => visibilityController.toggle(target);

  /// Locks a target's visibility so subsequent scrolling does not affect it.
  void lock(VisibilityTarget target, [double? visibility]) =>
      visibilityController.lock(target, visibility);

  /// Unlocks a target, restoring scroll responsiveness.
  void unlock(VisibilityTarget target) => visibilityController.unlock(target);

  /// Reveals all targets simultaneously.
  void showAll() => visibilityController.showAll();

  /// Hides all hideable targets simultaneously.
  void hideAll() => visibilityController.hideAll();

  @override
  void dispose() {
    visibilityController.dispose();
    super.dispose();
  }
}
