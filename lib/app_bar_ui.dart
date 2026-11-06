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
export 'src/motion/motion_timeline.dart';
export 'src/motion/spring_coordinator.dart';
export 'src/motion/perspective_transform.dart';
export 'src/motion/motion_config.dart';
export 'src/motion/path_deformation_driver.dart';
export 'src/experiences/experience_configs.dart';
export 'src/experiences/morphing_split_header.dart';
export 'src/experiences/elastic_floating_header.dart';
export 'src/experiences/disappearing_floating_actions_header.dart';
export 'src/experiences/circular_morph_header.dart';
export 'src/experiences/flip_3d_header.dart';
export 'src/experiences/horizontal_sliding_panels_header.dart';
export 'src/experiences/vertical_folding_accordion_header.dart';
export 'src/experiences/layered_depth_parallax_header.dart';
export 'src/experiences/expanding_hero_card_header.dart';
export 'src/experiences/liquid_wave_morph_header.dart';
export 'src/experiences/auto_hiding_velocity_header.dart';
export 'src/experiences/scroll_synchronized_progress_header.dart';
export 'src/experiences/sticky_collapse_dual_tier_header.dart';
export 'src/experiences/multi_stage_staged_reveal_header.dart';
export 'src/experiences/animated_dock_header.dart';
export 'src/experiences/radial_orbital_action_header.dart';
export 'src/experiences/split_screen_lateral_reveal_header.dart';
export 'src/experiences/magnetic_scroll_snap_header.dart';
export 'src/experiences/parallax_zoom_hero_header.dart';
export 'src/experiences/pull_down_disclosure_canvas_header.dart';

import 'app_bar_ui_platform_interface.dart';

/// Legacy platform interface wrapper.
class AppBarUi {
  /// Fetches platform version for platform integration checks.
  Future<String?> getPlatformVersion() {
    return AppBarUiPlatform.instance.getPlatformVersion();
  }
}
