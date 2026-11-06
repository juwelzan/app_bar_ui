import 'package:flutter/material.dart';

import '../design_system/app_bar_model_configuration.dart';
import '../design_system/model_transition_spec.dart';
import '../widgets/sliver_widget_marker.dart';
import 'app_bar_configuration.dart';
import 'app_bar_controller.dart';
import 'app_bar_model.dart';
import 'app_bar_model_registry.dart';
import 'app_bar_model_renderer.dart';
import 'capability_validator.dart';

/// Single unified public entry point for all AppBar experiences in the package.
///
/// Provides complete control over models, layout, content, appearance, motion,
/// behaviors, individual elements, and runtime switching through one coherent API:
///
/// ```dart
/// AppBarEngine(
///   model: AppBarModel.immersiveHero,
///   configuration: AppBarConfiguration(
///     layout: const LayoutConfiguration(expandedHeight: 280.0),
///     content: ContentConfiguration.text(title: 'Dashboard'),
///   ),
///   body: const DashboardContent(),
/// )
/// ```
///
/// Or as an individual sliver inside a [CustomScrollView]:
///
/// ```dart
/// CustomScrollView(
///   slivers: [
///     AppBarEngine.sliver(
///       model: AppBarModel.morphingSplit,
///       configuration: AppBarConfiguration(...),
///     ),
///     // ... other slivers
///   ],
/// )
/// ```
class AppBarEngine extends StatefulWidget with SliverWidgetMarker {
  /// Creates a unified full-page AppBar experience wrapping [body] (Level 1 Preset Mode).
  const AppBarEngine({
    super.key,
    required this.model,
    this.configuration,
    this.typedConfiguration,
    this.controller,
    required Widget this.body,
    this.scrollController,
    this.physics,
    this.restorationId,
    this.scaffoldBackgroundColor,
    this.bottomNavigationBar,
    this.floatingActionButton,
  })  : isSliverMode = false;

  /// Creates a unified sliver AppBar experience for use inside a [CustomScrollView].
  const AppBarEngine.sliver({
    super.key,
    required this.model,
    this.configuration,
    this.typedConfiguration,
    this.controller,
  })  : isSliverMode = true,
        body = null,
        scrollController = null,
        physics = null,
        restorationId = null,
        scaffoldBackgroundColor = null,
        bottomNavigationBar = null,
        floatingActionButton = null;

  /// Level 2 Customization: Configurable Mode with strongly-typed model configuration.
  const AppBarEngine.custom({
    super.key,
    required this.model,
    required AppBarModelConfiguration configuration,
    this.controller,
    required Widget this.body,
    this.scrollController,
    this.physics,
    this.restorationId,
    this.scaffoldBackgroundColor,
    this.bottomNavigationBar,
    this.floatingActionButton,
  })  : isSliverMode = false,
        configuration = null,
        typedConfiguration = configuration;

  /// Level 2 Customization in Sliver Mode.
  const AppBarEngine.customSliver({
    super.key,
    required this.model,
    required AppBarModelConfiguration configuration,
    this.controller,
  })  : isSliverMode = true,
        configuration = null,
        typedConfiguration = configuration,
        body = null,
        scrollController = null,
        physics = null,
        restorationId = null,
        scaffoldBackgroundColor = null,
        bottomNavigationBar = null,
        floatingActionButton = null;

  /// The active AppBar model defining the visual structure and behavior paradigm.
  final AppBarModel model;

  /// Unified configuration controlling layout, content, styling, motion, and behaviors.
  final AppBarConfiguration? configuration;

  /// Dedicated strongly-typed model configuration (Level 2 Customization).
  final AppBarModelConfiguration? typedConfiguration;

  /// Optional runtime controller for programmatically expanding, collapsing,
  /// auto-hiding, or switching models on the fly.
  final AppBarController? controller;

  /// Main scrollable body widget (when used in standard scaffold mode).
  final Widget? body;

  /// Optional external scroll controller.
  final ScrollController? scrollController;

  /// Scroll physics for the integrated scroll view.
  final ScrollPhysics? physics;

  /// Restoration ID for state preservation across process recycling.
  final String? restorationId;

  /// Background color for the underlying scaffold in scaffold mode.
  final Color? scaffoldBackgroundColor;

  /// Bottom navigation bar for full scaffold mode.
  final Widget? bottomNavigationBar;

  /// Floating action button for full scaffold mode.
  final Widget? floatingActionButton;

  /// Whether this instance was instantiated as a sliver.
  final bool isSliverMode;

  @override
  State<AppBarEngine> createState() => _AppBarEngineState();
}

class _AppBarEngineState extends State<AppBarEngine>
    with SingleTickerProviderStateMixin
    implements AppBarEngineHost {
  late AppBarModel _activeModel;
  late AppBarModelRenderer _activeRenderer;
  AppBarController? _internalController;
  ScrollController? _internalScrollController;
  AppBarConfiguration Function(AppBarConfiguration current)? _runtimeConfigOverride;

  bool _isVisible = true;
  double _scrollProgress = 0.0;
  double _lastScrollOffset = 0.0;

  /// Current scroll progress in [0.0..1.0].
  double get scrollProgress => _scrollProgress;

  AppBarController get _effectiveController =>
      widget.controller ?? (_internalController ??= AppBarController(initialModel: widget.model));

  ScrollController get _effectiveScrollController =>
      widget.scrollController ?? (_internalScrollController ??= ScrollController());

  @override
  void initState() {
    super.initState();
    _activeModel = widget.model;
    _activeRenderer = AppBarModelRegistry.instance.getRenderer(_activeModel);
    _effectiveController.attachHost(this);
    if (!widget.isSliverMode) {
      _effectiveController.attachScrollController(_effectiveScrollController);
      _effectiveScrollController.addListener(_handleScrollListener);
    }
  }

  @override
  void didUpdateWidget(covariant AppBarEngine oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller?.detachHost(this);
      widget.controller?.attachHost(this);
    }

    if (oldWidget.model != widget.model && widget.model != _activeModel) {
      _transitionToModel(widget.model, duration: Duration.zero);
    }
  }

  void _handleScrollListener() {
    if (!mounted || !_effectiveScrollController.hasClients) return;
    final offset = _effectiveScrollController.offset;
    _updateScrollMetrics(offset);
  }

  void _updateScrollMetrics(double offset) {
    final config = _resolveEffectiveConfiguration();
    final scrollSpan = (config.layout.expandedHeight - config.layout.collapsedHeight);
    final progress = scrollSpan > 0.0 ? (offset / scrollSpan).clamp(0.0, 1.0) : 1.0;

    final isExpanded = progress <= 0.01;
    final isCollapsed = progress >= 0.99;

    // Directional velocity auto-hide detection
    if (config.behavior.directionAwareAutoHide) {
      final delta = offset - _lastScrollOffset;
      if (delta > config.behavior.autoHideHysteresis && _isVisible && offset > config.layout.collapsedHeight) {
        requestSetVisibility(false);
      } else if (delta < -config.behavior.autoHideHysteresis && !_isVisible) {
        requestSetVisibility(true);
      }
    }
    _lastScrollOffset = offset;
    _scrollProgress = progress;

    _effectiveController.updateTelemetry(
      progress: progress,
      isExpanded: isExpanded,
      isCollapsed: isCollapsed,
      isVisible: _isVisible,
      activeModel: _activeModel,
    );
  }

  ResolvedAppBarConfiguration _resolveEffectiveConfiguration() {
    // 1. Model baseline defaults
    final baseConfig = _activeRenderer.defaultConfiguration;

    // 2. User configuration
    final userConfig = widget.configuration ?? const AppBarConfiguration();

    // 3. Merged base + user
    var merged = AppBarConfiguration(
      layout: baseConfig.layout.copyWith(
        expandedHeight: widget.configuration?.layout.expandedHeight ?? baseConfig.layout.expandedHeight,
        collapsedHeight: widget.configuration?.layout.collapsedHeight ?? baseConfig.layout.collapsedHeight,
        minHeight: widget.configuration?.layout.minHeight ?? baseConfig.layout.minHeight,
        maxHeight: widget.configuration?.layout.maxHeight ?? baseConfig.layout.maxHeight,
        width: widget.configuration?.layout.width ?? baseConfig.layout.width,
        alignment: widget.configuration?.layout.alignment ?? baseConfig.layout.alignment,
        padding: widget.configuration?.layout.padding ?? baseConfig.layout.padding,
        margin: widget.configuration?.layout.margin ?? baseConfig.layout.margin,
        spacing: widget.configuration?.layout.spacing ?? baseConfig.layout.spacing,
        safeArea: widget.configuration?.layout.safeArea ?? baseConfig.layout.safeArea,
        layoutDirection: widget.configuration?.layout.layoutDirection ?? baseConfig.layout.layoutDirection,
        breakpoints: widget.configuration?.layout.breakpoints ?? baseConfig.layout.breakpoints,
        customLayoutBuilder: widget.configuration?.layout.customLayoutBuilder ?? baseConfig.layout.customLayoutBuilder,
      ),
      content: userConfig.content,
      appearance: baseConfig.appearance.copyWith(
        backgroundColor: widget.configuration?.appearance.backgroundColor ?? baseConfig.appearance.backgroundColor,
        collapsedBackgroundColor: widget.configuration?.appearance.collapsedBackgroundColor ?? baseConfig.appearance.collapsedBackgroundColor,
        foregroundColor: widget.configuration?.appearance.foregroundColor ?? baseConfig.appearance.foregroundColor,
        elevation: widget.configuration?.appearance.elevation ?? baseConfig.appearance.elevation,
        scrolledElevation: widget.configuration?.appearance.scrolledElevation ?? baseConfig.appearance.scrolledElevation,
        shadowColor: widget.configuration?.appearance.shadowColor ?? baseConfig.appearance.shadowColor,
        borderRadius: widget.configuration?.appearance.borderRadius ?? baseConfig.appearance.borderRadius,
        collapsedBorderRadius: widget.configuration?.appearance.collapsedBorderRadius ?? baseConfig.appearance.collapsedBorderRadius,
        shape: widget.configuration?.appearance.shape ?? baseConfig.appearance.shape,
        border: widget.configuration?.appearance.border ?? baseConfig.appearance.border,
        gradient: widget.configuration?.appearance.gradient ?? baseConfig.appearance.gradient,
        scrolledGradient: widget.configuration?.appearance.scrolledGradient ?? baseConfig.appearance.scrolledGradient,
        blurFilter: widget.configuration?.appearance.blurFilter ?? baseConfig.appearance.blurFilter,
        blurSigma: widget.configuration?.appearance.blurSigma ?? baseConfig.appearance.blurSigma,
        opacity: widget.configuration?.appearance.opacity ?? baseConfig.appearance.opacity,
        overlayColor: widget.configuration?.appearance.overlayColor ?? baseConfig.appearance.overlayColor,
      ),
      motion: userConfig.motion,
      behavior: baseConfig.behavior.copyWith(
        collapsible: widget.configuration?.behavior.collapsible ?? baseConfig.behavior.collapsible,
        floating: widget.configuration?.behavior.floating ?? baseConfig.behavior.floating,
        pinned: widget.configuration?.behavior.pinned ?? baseConfig.behavior.pinned,
        snap: widget.configuration?.behavior.snap ?? baseConfig.behavior.snap,
        sticky: widget.configuration?.behavior.sticky ?? baseConfig.behavior.sticky,
        directionAwareAutoHide: widget.configuration?.behavior.directionAwareAutoHide ?? baseConfig.behavior.directionAwareAutoHide,
        autoHideVelocityThreshold: widget.configuration?.behavior.autoHideVelocityThreshold ?? baseConfig.behavior.autoHideVelocityThreshold,
        autoHideHysteresis: widget.configuration?.behavior.autoHideHysteresis ?? baseConfig.behavior.autoHideHysteresis,
        dragToExpand: widget.configuration?.behavior.dragToExpand ?? baseConfig.behavior.dragToExpand,
        dragSensitivity: widget.configuration?.behavior.dragSensitivity ?? baseConfig.behavior.dragSensitivity,
        pullToExpand: widget.configuration?.behavior.pullToExpand ?? baseConfig.behavior.pullToExpand,
        overScrollStretch: widget.configuration?.behavior.overScrollStretch ?? baseConfig.behavior.overScrollStretch,
        onRefresh: widget.configuration?.behavior.onRefresh ?? baseConfig.behavior.onRefresh,
        multiStageMilestones: widget.configuration?.behavior.multiStageMilestones ?? baseConfig.behavior.multiStageMilestones,
        programmaticTransitionsEnabled: widget.configuration?.behavior.programmaticTransitionsEnabled ?? baseConfig.behavior.programmaticTransitionsEnabled,
      ),
      elements: userConfig.elements,
    );

    // 4. Apply runtime override if active
    if (_runtimeConfigOverride != null) {
      merged = _runtimeConfigOverride!(merged);
    }

    // 5. Validate capabilities
    CapabilityValidator.validate(
      model: _activeModel,
      capabilities: _activeRenderer.capabilities,
      configuration: merged,
    );

    return ResolvedAppBarConfiguration(
      layout: merged.layout,
      content: merged.content,
      appearance: merged.appearance,
      motion: merged.motion,
      behavior: merged.behavior,
      elements: merged.elements,
      typedConfig: widget.typedConfiguration ?? merged.typedConfig,
    );
  }

  void _transitionToModel(
    AppBarModel newModel, {
    Duration duration = const Duration(milliseconds: 300),
    Curve curve = Curves.easeInOut,
    bool preserveScrollOffset = true,
  }) {
    if (!mounted || newModel == _activeModel) return;

    final oldRenderer = _activeRenderer;
    final newRenderer = AppBarModelRegistry.instance.getRenderer(newModel);

    setState(() {
      _activeModel = newModel;
      _activeRenderer = newRenderer;
    });

    oldRenderer.dispose();
  }

  @override
  void requestModelChange(
    AppBarModel newModel, {
    Duration duration = const Duration(milliseconds: 300),
    Curve curve = Curves.easeInOut,
    bool preserveScrollOffset = true,
    ModelTransitionSpec? transition,
  }) {
    _transitionToModel(
      newModel,
      duration: transition?.duration ?? duration,
      curve: transition?.curve ?? curve,
      preserveScrollOffset: preserveScrollOffset,
    );
  }

  @override
  void requestConfigurationUpdate(
    AppBarConfiguration Function(AppBarConfiguration current) update,
  ) {
    if (!mounted) return;
    setState(() {
      _runtimeConfigOverride = update;
    });
  }

  @override
  void requestAnimateToProgress(
    double progress, {
    Duration duration = const Duration(milliseconds: 300),
    Curve curve = Curves.easeInOutCubic,
  }) {
    if (!mounted || !_effectiveScrollController.hasClients) return;
    final config = _resolveEffectiveConfiguration();
    final targetOffset = progress * (config.layout.expandedHeight - config.layout.collapsedHeight);
    _effectiveScrollController.animateTo(
      targetOffset,
      duration: duration,
      curve: curve,
    );
  }

  @override
  void requestSetVisibility(
    bool visible, {
    Duration duration = const Duration(milliseconds: 250),
    Curve curve = Curves.easeInOut,
  }) {
    if (!mounted || _isVisible == visible) return;
    setState(() {
      _isVisible = visible;
    });
  }

  @override
  void dispose() {
    _effectiveController.detachHost(this);
    if (!widget.isSliverMode) {
      _effectiveScrollController.removeListener(_handleScrollListener);
    }
    _internalScrollController?.dispose();
    _internalController?.dispose();
    _activeRenderer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final resolvedConfig = _resolveEffectiveConfiguration();

    // Build the sliver for the active model (or custom layout builder override)
    final sliver = resolvedConfig.layout.customLayoutBuilder != null
        ? SliverPersistentHeader(
            pinned: resolvedConfig.behavior.pinned,
            floating: resolvedConfig.behavior.floating,
            delegate: _CustomLayoutHeaderDelegate(
              resolvedConfig: resolvedConfig,
              builder: resolvedConfig.layout.customLayoutBuilder!,
            ),
          )
        : _activeRenderer.buildSliver(
            context: context,
            configuration: resolvedConfig,
            controller: _effectiveController,
          );

    if (widget.isSliverMode) {
      // In sliver mode, return the sliver directly
      return sliver;
    }

    // In scaffold mode, compose with integrated scroll body
    return Scaffold(
      backgroundColor: widget.scaffoldBackgroundColor,
      bottomNavigationBar: widget.bottomNavigationBar,
      floatingActionButton: widget.floatingActionButton,
      body: NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          if (notification is ScrollUpdateNotification) {
            _updateScrollMetrics(notification.metrics.pixels);
          }
          return false;
        },
        child: CustomScrollView(
          controller: _effectiveScrollController,
          physics: widget.physics,
          restorationId: widget.restorationId,
          slivers: [
            sliver,
            if (widget.body != null)
              SliverToBoxAdapter(child: widget.body!),
          ],
        ),
      ),
    );
  }
}

class _CustomLayoutHeaderDelegate extends SliverPersistentHeaderDelegate {
  _CustomLayoutHeaderDelegate({
    required this.resolvedConfig,
    required this.builder,
  });

  final ResolvedAppBarConfiguration resolvedConfig;
  final CustomLayoutBuilder builder;

  @override
  double get minExtent => resolvedConfig.layout.collapsedHeight;

  @override
  double get maxExtent => resolvedConfig.layout.expandedHeight;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    final currentHeight = (maxExtent - shrinkOffset).clamp(minExtent, maxExtent);
    return builder(
      context,
      BoxConstraints.tightFor(height: currentHeight),
      resolvedConfig,
    );
  }

  @override
  bool shouldRebuild(covariant _CustomLayoutHeaderDelegate oldDelegate) {
    return oldDelegate.resolvedConfig != resolvedConfig || oldDelegate.builder != builder;
  }
}
