import '../../app_bar_model_configuration.dart';

/// Strongly-typed configuration for Model 11: Minimalist Content-First Micro-Bar.
///
/// An ultra-clean, content-first presentation with razor-thin geometry (38–48px),
/// monospace micro-breadcrumbs, reading ETA, and subtle scroll progress dot.
class MinimalistMicroBarConfig extends AppBarModelConfiguration {
  /// Creates a [MinimalistMicroBarConfig].
  const MinimalistMicroBarConfig({
    this.pathBreadcrumb = 'packages / app_bar_ui / lib / engine.dart',
    this.readingEta = '4 min read',
    this.documentStatus = 'v2.4.0 • clean',
    this.expandedHeight = 48.0,
    this.collapsedHeight = 38.0,
    this.showProgressDot = true,
    this.monospace = true,
    this.hairlineBorder = true,
    super.safeArea = true,
    super.backgroundColor,
    super.surfaceTint,
    super.physics,
    super.elevation = 0.5,
  });

  /// Monospace path breadcrumb displayed in the micro-bar.
  final String pathBreadcrumb;

  /// Estimated reading time or document length.
  final String? readingEta;

  /// Version or sync status label.
  final String? documentStatus;

  /// Expanded height of the micro-bar.
  final double expandedHeight;

  /// Collapsed height when pinned.
  final double collapsedHeight;

  /// Whether to render a subtle scroll progress indicator dot on the right edge.
  final bool showProgressDot;

  /// Whether to render breadcrumb labels in a clean monospace font.
  final bool monospace;

  /// Whether to render a delicate 0.5px hairline border on the bottom edge.
  final bool hairlineBorder;
}
