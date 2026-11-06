import 'package:flutter/widgets.dart';

import 'app_bar_configuration.dart';
import 'app_bar_controller.dart';
import 'model_capabilities.dart';

/// Abstract contract for an independent, self-contained AppBar model renderer.
///
/// Each of the 50 models implements this interface independently.
/// No giant switch statements or shared kitchen-sink widgets are permitted.
abstract class AppBarModelRenderer {
  /// Creates a model renderer.
  const AppBarModelRenderer();

  /// Declares what features, motion primitives, and interaction models
  /// this renderer natively supports.
  ModelCapabilities get capabilities;

  /// Default baseline configuration for this model when developer leaves fields null.
  AppBarConfiguration get defaultConfiguration;

  /// Constructs the sliver widget representing this model within a scroll view.
  Widget buildSliver({
    required BuildContext context,
    required ResolvedAppBarConfiguration configuration,
    required AppBarController? controller,
  });

  /// Cleanly releases any retained controllers, tickers, or native resources.
  void dispose() {}
}
