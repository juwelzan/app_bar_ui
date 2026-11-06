import 'package:flutter/material.dart';

import 'app_bar_configuration.dart';
import 'app_bar_model.dart';

/// Private communication interface between [AppBarController] and the engine state.
abstract class AppBarEngineHost {
  /// Triggers a model change inside the host engine state.
  void requestModelChange(
    AppBarModel newModel, {
    Duration duration = const Duration(milliseconds: 300),
    Curve curve = Curves.easeInOut,
    bool preserveScrollOffset = true,
  });

  /// Triggers a configuration update inside the host engine state.
  void requestConfigurationUpdate(
    AppBarConfiguration Function(AppBarConfiguration current) update,
  );

  /// Triggers programmatic scroll to a specific progress value [0.0..1.0].
  void requestAnimateToProgress(
    double progress, {
    Duration duration = const Duration(milliseconds: 300),
    Curve curve = Curves.easeInOutCubic,
  });

  /// Triggers visibility toggle (auto-hide programmatically).
  void requestSetVisibility(
    bool visible, {
    Duration duration = const Duration(milliseconds: 250),
    Curve curve = Curves.easeInOut,
  });
}

/// Reactive, lifecycle-safe controller for programmatically commanding the [AppBarEngine].
class AppBarController extends ChangeNotifier {
  /// Creates an AppBar controller.
  AppBarController({AppBarModel? initialModel}) : _currentModel = initialModel;

  AppBarModel? _currentModel;
  AppBarEngineHost? _host;
  ScrollController? _attachedScrollController;

  double _scrollProgress = 0.0;
  bool _isExpanded = true;
  bool _isCollapsed = false;
  bool _isVisible = true;
  bool _isDisposed = false;

  /// Currently active AppBar model.
  AppBarModel? get currentModel => _currentModel;

  /// Current scroll progress in [0.0..1.0] (0.0 = fully expanded, 1.0 = fully collapsed).
  double get scrollProgress => _scrollProgress;

  /// Whether the app bar is in its fully expanded state.
  bool get isExpanded => _isExpanded;

  /// Whether the app bar is in its fully collapsed/docked state.
  bool get isCollapsed => _isCollapsed;

  /// Whether the app bar is currently visible (not hidden by auto-hide).
  bool get isVisible => _isVisible;

  /// Attached scroll controller if integrated with the body.
  ScrollController? get attachedScrollController => _attachedScrollController;

  /// Binds the host engine to this controller.
  void attachHost(AppBarEngineHost host) {
    _host = host;
  }

  /// Detaches the host engine.
  void detachHost(AppBarEngineHost host) {
    if (_host == host) {
      _host = null;
    }
  }

  /// Binds an external scroll controller for coordination.
  void attachScrollController(ScrollController scrollController) {
    _attachedScrollController = scrollController;
  }

  /// Detaches the scroll controller.
  void detachScrollController() {
    _attachedScrollController = null;
  }

  /// Updates internal telemetry without triggering full rebuilds when unchanged.
  void updateTelemetry({
    required double progress,
    required bool isExpanded,
    bool isCollapsed = false,
    required bool isVisible,
    AppBarModel? activeModel,
  }) {
    if (_isDisposed) return;
    bool changed = false;

    if (activeModel != null && _currentModel != activeModel) {
      _currentModel = activeModel;
      changed = true;
    }

    if ((_scrollProgress - progress).abs() > 0.001) {
      _scrollProgress = progress;
      changed = true;
    }

    if (_isExpanded != isExpanded) {
      _isExpanded = isExpanded;
      changed = true;
    }

    if (_isCollapsed != isCollapsed) {
      _isCollapsed = isCollapsed;
      changed = true;
    }

    if (_isVisible != isVisible) {
      _isVisible = isVisible;
      changed = true;
    }

    if (changed) {
      notifyListeners();
    }
  }

  /// Dynamically switches the active [AppBarModel] at runtime.
  ///
  /// Can smoothly crossfade between old and new model renderers without
  /// dropping scroll position.
  void changeModel(
    AppBarModel newModel, {
    Duration duration = const Duration(milliseconds: 300),
    Curve curve = Curves.easeInOut,
    bool preserveScrollOffset = true,
  }) {
    if (_isDisposed) return;
    _currentModel = newModel;
    _host?.requestModelChange(
      newModel,
      duration: duration,
      curve: curve,
      preserveScrollOffset: preserveScrollOffset,
    );
    notifyListeners();
  }

  /// Dynamically updates the AppBar configuration at runtime.
  void updateConfiguration(
    AppBarConfiguration Function(AppBarConfiguration current) update,
  ) {
    if (_isDisposed) return;
    _host?.requestConfigurationUpdate(update);
    notifyListeners();
  }

  /// Programmatically animates the app bar to an exact scroll progress [0.0..1.0].
  void animateToProgress(
    double progress, {
    Duration duration = const Duration(milliseconds: 300),
    Curve curve = Curves.easeInOutCubic,
  }) {
    if (_isDisposed) return;
    final clamped = progress.clamp(0.0, 1.0);
    _host?.requestAnimateToProgress(clamped, duration: duration, curve: curve);
  }

  /// Programmatically expands the app bar to its maximum height.
  void expand({
    Duration duration = const Duration(milliseconds: 300),
    Curve curve = Curves.easeOutCubic,
  }) {
    animateToProgress(0.0, duration: duration, curve: curve);
  }

  /// Programmatically collapses the app bar to its compact pinned toolbar state.
  void collapse({
    Duration duration = const Duration(milliseconds: 300),
    Curve curve = Curves.easeInOutCubic,
  }) {
    animateToProgress(1.0, duration: duration, curve: curve);
  }

  /// Programmatically hides the app bar completely (auto-hide).
  void hide({
    Duration duration = const Duration(milliseconds: 250),
    Curve curve = Curves.easeInOut,
  }) {
    if (_isDisposed) return;
    _isVisible = false;
    _host?.requestSetVisibility(false, duration: duration, curve: curve);
    notifyListeners();
  }

  /// Programmatically reveals the app bar if it was hidden.
  void show({
    Duration duration = const Duration(milliseconds: 250),
    Curve curve = Curves.easeInOut,
  }) {
    if (_isDisposed) return;
    _isVisible = true;
    _host?.requestSetVisibility(true, duration: duration, curve: curve);
    notifyListeners();
  }

  @override
  void dispose() {
    _isDisposed = true;
    _host = null;
    _attachedScrollController = null;
    super.dispose();
  }
}
