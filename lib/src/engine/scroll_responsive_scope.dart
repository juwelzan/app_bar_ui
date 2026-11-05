import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../models/scroll_responsive_config.dart';
import 'scroll_responsive_controller.dart';
import 'scroll_responsive_engine.dart';

/// An [InheritedWidget] providing ambient access to the active [ScrollResponsiveScaffold] state,
/// its [ScrollResponsiveController], and real-time scroll telemetry.
class ScrollResponsiveScope extends InheritedWidget {
  /// Creates a [ScrollResponsiveScope] widget.
  const ScrollResponsiveScope({
    super.key,
    required this.engine,
    required this.config,
    this.controller,
    required super.child,
  });

  /// The active scroll engine coordinating progress and callbacks.
  final ScrollResponsiveEngine engine;

  /// The active configuration.
  final ScrollResponsiveConfig config;

  /// The programmatic controller, if one was attached.
  final ScrollResponsiveController? controller;

  /// Current raw scroll offset in pixels.
  double get offset => engine.currentOffset;

  /// Current normalized leading progress (0.0 to 1.0).
  double get leadingProgress => engine.leadingProgress;

  /// Current normalized trailing progress (0.0 to 1.0).
  double get trailingProgress => engine.trailingProgress;

  /// Current scroll direction.
  ScrollDirection get direction => engine.currentDirection;

  /// Whether the scrollable is currently at the top (offset <= 0.0).
  bool get isAtTop => offset <= 0.0;

  /// Programmatically animates to the top of the scrollable view.
  Future<void> scrollToTop({
    Duration duration = const Duration(milliseconds: 300),
    Curve curve = Curves.easeOutCubic,
  }) async {
    if (controller != null) {
      await controller!.scrollToTop(duration: duration, curve: curve);
    } else if (engine.controller.hasClients) {
      await engine.controller.animateTo(0.0, duration: duration, curve: curve);
    }
  }

  /// Programmatically animates to the bottom of the scrollable view.
  Future<void> scrollToBottom({
    Duration duration = const Duration(milliseconds: 300),
    Curve curve = Curves.easeOutCubic,
  }) async {
    if (controller != null) {
      await controller!.scrollToBottom(duration: duration, curve: curve);
    } else if (engine.controller.hasClients) {
      await engine.controller.animateTo(
        engine.controller.position.maxScrollExtent,
        duration: duration,
        curve: curve,
      );
    }
  }

  /// Programmatically collapses the header.
  Future<void> collapseHeader({
    Duration duration = const Duration(milliseconds: 250),
    Curve curve = Curves.easeInOutCubic,
  }) async {
    if (controller != null) {
      await controller!.collapseHeader(duration: duration, curve: curve);
    } else if (engine.controller.hasClients) {
      await engine.controller.animateTo(
        config.thresholds.leadingEndOffset,
        duration: duration,
        curve: curve,
      );
    }
  }

  /// Programmatically expands the header back to top.
  Future<void> expandHeader({
    Duration duration = const Duration(milliseconds: 250),
    Curve curve = Curves.easeInOutCubic,
  }) async {
    await scrollToTop(duration: duration, curve: curve);
  }

  /// Retrieves the nearest ambient [ScrollResponsiveScope] or throws an assertion error if not found.
  static ScrollResponsiveScope of(BuildContext context) {
    final scope = maybeOf(context);
    assert(
      scope != null,
      'No ScrollResponsiveScope found in context. Ensure your widget is a descendant of ScrollResponsiveScaffold.',
    );
    return scope!;
  }

  /// Safely retrieves the nearest ambient [ScrollResponsiveScope], or null if not found.
  static ScrollResponsiveScope? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<ScrollResponsiveScope>();
  }

  @override
  bool updateShouldNotify(covariant ScrollResponsiveScope oldWidget) {
    return engine != oldWidget.engine ||
        config != oldWidget.config ||
        controller != oldWidget.controller;
  }
}

/// Convenience extensions on [BuildContext] for ergonomic access to [ScrollResponsiveScope].
extension ScrollResponsiveContextExtension on BuildContext {
  /// Accesses the nearest ambient [ScrollResponsiveScope].
  ScrollResponsiveScope get scrollResponsive => ScrollResponsiveScope.of(this);

  /// Safely accesses the nearest ambient [ScrollResponsiveScope], or null if none exists.
  ScrollResponsiveScope? get maybeScrollResponsive =>
      ScrollResponsiveScope.maybeOf(this);
}
