import 'package:flutter/foundation.dart';

import 'app_bar_model.dart';
import 'app_bar_model_renderer.dart';
import 'model_capabilities.dart';
import 'renderers/built_in_renderers.dart';

/// Factory signature for lazy-instantiating an [AppBarModelRenderer].
typedef AppBarModelRendererFactory = AppBarModelRenderer Function();

/// Central registry mapping each [AppBarModel] to its independent renderer implementation.
class AppBarModelRegistry {
  AppBarModelRegistry._();

  /// Global singleton instance.
  static final AppBarModelRegistry instance = AppBarModelRegistry._();

  final Map<AppBarModel, AppBarModelRendererFactory> _factories = {};
  final Map<AppBarModel, ModelCapabilities> _capabilities = {};
  bool _bootstrapped = false;

  /// Registers an independent model renderer factory with its capability declaration.
  void register(
    AppBarModel model,
    AppBarModelRendererFactory factory, {
    ModelCapabilities? capabilities,
  }) {
    _factories[model] = factory;
    if (capabilities != null) {
      _capabilities[model] = capabilities;
    }
  }

  /// Checks whether a renderer has been registered for [model].
  bool isRegistered(AppBarModel model) {
    _ensureBootstrapped();
    return _factories.containsKey(model);
  }

  /// Instantiates and returns the independent renderer for [model].
  AppBarModelRenderer getRenderer(AppBarModel model) {
    _ensureBootstrapped();
    final factory = _factories[model];
    if (factory == null) {
      throw FlutterError(
        'No renderer registered for AppBarModel.$model. '
        'Ensure the model renderer is registered via AppBarModelRegistry.instance.register().',
      );
    }
    return factory();
  }

  /// Returns the capabilities descriptor for [model].
  ModelCapabilities getCapabilities(AppBarModel model) {
    _ensureBootstrapped();
    if (_capabilities.containsKey(model)) {
      return _capabilities[model]!;
    }
    // Fall back to querying instance capabilities
    final factory = _factories[model];
    if (factory != null) {
      final renderer = factory();
      _capabilities[model] = renderer.capabilities;
      return renderer.capabilities;
    }
    return const ModelCapabilities();
  }

  /// Bootstraps built-in model renderers.
  void _ensureBootstrapped() {
    if (_bootstrapped) return;
    _bootstrapped = true;
    bootstrapBuiltInRenderers(this);
  }

  /// Resets registry for unit tests.
  @visibleForTesting
  void reset() {
    _factories.clear();
    _capabilities.clear();
    _bootstrapped = false;
  }
}
