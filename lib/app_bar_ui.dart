export 'src/models/scroll_responsive_config.dart';
export 'src/models/scroll_responsive_presets.dart';
export 'src/models/visibility_config.dart';
export 'src/engine/scroll_responsive_engine.dart';
export 'src/engine/scroll_responsive_controller.dart';
export 'src/engine/status_bar_manager.dart';
export 'src/engine/smart_visibility_controller.dart';
export 'src/engine/scroll_snap_engine.dart';
export 'src/engine/scroll_responsive_scope.dart';
export 'src/animations/scroll_driven_animation.dart';
export 'src/animations/scroll_color_tween.dart';
export 'src/animations/scroll_morph_builder.dart';
export 'src/animations/scroll_avatar_transform.dart';
export 'src/animations/scroll_staggered_builder.dart';
export 'src/animations/scroll_animated_builder.dart';
export 'src/widgets/pinned_action_button.dart';
export 'src/widgets/scroll_responsive_header.dart';
export 'src/widgets/scroll_responsive_scaffold.dart';
export 'src/widgets/scroll_collapsing_header.dart';
export 'src/widgets/scroll_pull_to_expand_header.dart';
export 'src/widgets/scroll_sticky_header.dart';
export 'src/widgets/scroll_sticky_tab_bar.dart';
export 'src/widgets/scroll_aware_fab.dart';
export 'src/widgets/scroll_auto_hide_bottom_bar.dart';
export 'src/widgets/scroll_parallax.dart';
export 'src/widgets/scroll_progress_indicator.dart';
export 'src/widgets/scroll_section_reveal.dart';
export 'src/widgets/scroll_to_top_button.dart';
export 'src/widgets/scroll_position_indicator.dart';
export 'src/widgets/scroll_aware_side_actions.dart';
export 'src/widgets/scroll_expandable_fab.dart';
export 'src/widgets/scroll_page_indicator.dart';
export 'src/widgets/smart_visibility_transition.dart';
export 'src/widgets/sliver_widget_marker.dart';
export 'src/presets/scroll_header.dart';
export 'src/presets/scroll_header_preset.dart';
export 'src/presets/scroll_header_style.dart';
export 'src/presets/headers/base_header.dart';
export 'src/presets/headers/navigation_headers.dart';
export 'src/presets/headers/visual_headers.dart';
export 'src/presets/headers/specialized_appbar_headers.dart';

import 'app_bar_ui_platform_interface.dart';

/// Legacy platform interface wrapper.
class AppBarUi {
  /// Fetches platform version for platform integration checks.
  Future<String?> getPlatformVersion() {
    return AppBarUiPlatform.instance.getPlatformVersion();
  }
}
