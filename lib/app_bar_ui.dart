export 'src/models/scroll_responsive_config.dart';
export 'src/engine/scroll_responsive_engine.dart';
export 'src/engine/status_bar_manager.dart';
export 'src/widgets/pinned_action_button.dart';
export 'src/widgets/scroll_responsive_header.dart';
export 'src/widgets/scroll_responsive_scaffold.dart';

import 'app_bar_ui_platform_interface.dart';

/// Legacy platform interface wrapper.
class AppBarUi {
  /// Fetches platform version for platform integration checks.
  Future<String?> getPlatformVersion() {
    return AppBarUiPlatform.instance.getPlatformVersion();
  }
}
