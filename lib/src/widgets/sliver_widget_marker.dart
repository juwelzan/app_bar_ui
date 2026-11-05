import 'package:flutter/material.dart';

/// Marker interface for widgets that render as Slivers rather than Box widgets.
///
/// Used by [ScrollResponsiveScaffold] to determine whether a header should be
/// placed directly into the sliver sequence or wrapped in a [SliverToBoxAdapter].
abstract mixin class SliverWidgetMarker {
  /// Whether this widget should be treated as a Sliver in a [CustomScrollView].
  bool get isSliver => true;
}

/// Helper function to check if a [Widget] is a Sliver.
bool isSliverWidget(Widget widget) {
  if (widget is SliverWidgetMarker) {
    return (widget as SliverWidgetMarker).isSliver;
  }
  if (widget is SliverPersistentHeader ||
      widget is SliverAppBar ||
      widget is SliverToBoxAdapter ||
      widget is SliverList ||
      widget is SliverGrid ||
      widget is SliverPadding ||
      widget is SliverFillRemaining ||
      widget is SliverFillViewport) {
    return true;
  }
  return false;
}
