import 'package:flutter/foundation.dart';

import 'app_bar_configuration.dart';
import 'app_bar_model.dart';
import 'model_capabilities.dart';

/// Validates that requested configurations align with the capabilities of the selected [AppBarModel].
class CapabilityValidator {
  const CapabilityValidator._();

  /// Validates [configuration] against [capabilities] for [model].
  ///
  /// Returns a list of diagnostic warning messages (empty if fully compatible).
  static List<String> validate({
    required AppBarModel model,
    required ModelCapabilities capabilities,
    required AppBarConfiguration configuration,
  }) {
    final warnings = <String>[];

    // Check drag to expand
    if (configuration.behavior.dragToExpand && !capabilities.supportsDragToExpand) {
      warnings.add(
        'dragToExpand is enabled in BehaviorConfiguration, but $model does not '
        'support direct downward touch drag expansion. '
        'Consider using AppBarModel.gestureElasticCanvas or AppBarModel.floatingIsland.',
      );
    }

    // Check velocity auto-hide
    if (configuration.behavior.directionAwareAutoHide && !capabilities.supportsVelocityAutoHide) {
      warnings.add(
        'directionAwareAutoHide is enabled in BehaviorConfiguration, but $model '
        'does not natively support velocity directional hiding. '
        'Consider using AppBarModel.minimalistMicroBar or AppBarModel.floatingIsland.',
      );
    }

    // Check magnetic snap
    if (configuration.behavior.snap && !capabilities.supportsMagneticSnap) {
      warnings.add(
        'snap is enabled in BehaviorConfiguration, but $model does not have '
        'built-in magnetic detent snapping. '
        'Consider using AppBarModel.cardDeckStacked or AppBarModel.timelineScrubberNav.',
      );
    }

    // Check sticky secondary tier
    if (configuration.behavior.sticky && !capabilities.supportsSticky) {
      warnings.add(
        'sticky is enabled in BehaviorConfiguration, but $model does not support '
        'pinning secondary tabs/tiers independently. '
        'Consider using AppBarModel.traditionalStructured or AppBarModel.expandableControlCenter.',
      );
    }

    // Report warnings in debug mode without crashing test framework
    if (warnings.isNotEmpty && kDebugMode) {
      for (final warning in warnings) {
        debugPrint('[AppBarEngine] Capability Warning: $warning');
      }
    }

    return warnings;
  }
}
