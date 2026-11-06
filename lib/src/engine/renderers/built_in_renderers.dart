import '../app_bar_model.dart';
import '../app_bar_model_registry.dart';
import '../model_capabilities.dart';
import 'standard_renderers.dart';

import '../../design_system/models/traditional_structured/traditional_structured_renderer.dart';
import '../../design_system/models/full_screen_hero/full_screen_hero_renderer.dart';
import '../../design_system/models/floating_island/floating_island_renderer.dart';
import '../../design_system/models/immersive_spatial/immersive_spatial_renderer.dart';
import '../../design_system/models/split_curtain/split_curtain_renderer.dart';
import '../../design_system/models/spatial_3d_flip/spatial_3d_flip_renderer.dart';
import '../../design_system/models/vertical_rail_transform/vertical_rail_transform_renderer.dart';
import '../../design_system/models/radial_dial/radial_dial_renderer.dart';
import '../../design_system/models/editorial_typography/editorial_typography_renderer.dart';
import '../../design_system/models/card_deck_stacked/card_deck_stacked_renderer.dart';
import '../../design_system/models/minimalist_micro_bar/minimalist_micro_bar_renderer.dart';
import '../../design_system/models/profile_identity/profile_identity_renderer.dart';
import '../../design_system/models/expandable_control_center/expandable_control_center_renderer.dart';
import '../../design_system/models/timeline_scrubber_nav/timeline_scrubber_nav_renderer.dart';
import '../../design_system/models/search_spotlight/search_spotlight_renderer.dart';
import '../../design_system/models/gesture_elastic_canvas/gesture_elastic_canvas_renderer.dart';
import '../../design_system/models/adaptive_breakpoint_nav/adaptive_breakpoint_nav_renderer.dart';
import '../../design_system/models/context_focal_swap_nav/context_focal_swap_nav_renderer.dart';
import '../../design_system/models/liquid_wave_morph_nav/liquid_wave_morph_nav_renderer.dart';
import '../../design_system/models/developer_custom_canvas/developer_custom_canvas_renderer.dart';

/// Bootstraps all built-in model renderers into the registry.
void bootstrapBuiltInRenderers(AppBarModelRegistry registry) {
  // --- Baseline: Model 0 ---
  registry.register(
    AppBarModel.classic,
    () => const ClassicAppBarRenderer(),
  );

  // --- Complete Design System: Batch A (Models 1–4) ---
  registry.register(
    AppBarModel.traditionalStructured,
    () => const TraditionalStructuredRenderer(),
    capabilities: const ModelCapabilities(supportsSticky: true, supportsMultiStage: true),
  );
  registry.register(
    AppBarModel.fullScreenHero,
    () => const FullScreenHeroRenderer(),
    capabilities: const ModelCapabilities(supportsParallax: true),
  );
  registry.register(
    AppBarModel.floatingIsland,
    () => const FloatingIslandRenderer(),
    capabilities: const ModelCapabilities(supportsDragToExpand: true),
  );
  registry.register(
    AppBarModel.immersiveSpatial,
    () => const ImmersiveSpatialRenderer(),
    capabilities: const ModelCapabilities(supportsParallax: true, supports3DTransform: true),
  );

  // --- Complete Design System: Batch B (Models 5–8) ---
  registry.register(
    AppBarModel.multiPanelSplitCurtain,
    () => const MultiPanelSplitCurtainRenderer(),
    capabilities: const ModelCapabilities(supportsCurtainSplit: true, supportsSticky: true),
  );
  registry.register(
    AppBarModel.spatial3DFlip,
    () => const Spatial3DFlipRenderer(),
    capabilities: const ModelCapabilities(supports3DTransform: true, supportsSticky: true),
  );
  registry.register(
    AppBarModel.verticalRailTransform,
    () => const VerticalRailTransformRenderer(),
    capabilities: const ModelCapabilities(supportsSticky: true, supportsMultiStage: true),
  );
  registry.register(
    AppBarModel.radialDial,
    () => const RadialDialRenderer(),
    capabilities: const ModelCapabilities(supportsShapeMorph: true, supportsSticky: true),
  );

  // --- Complete Design System: Batch C (Models 9–12) ---
  registry.register(
    AppBarModel.editorialTypography,
    () => const EditorialTypographyRenderer(),
    capabilities: const ModelCapabilities(supportsSticky: true, supportsMultiStage: true),
  );
  registry.register(
    AppBarModel.cardDeckStacked,
    () => const CardDeckStackedRenderer(),
    capabilities: const ModelCapabilities(supportsSticky: true, supportsMultiStage: true),
  );
  registry.register(
    AppBarModel.minimalistMicroBar,
    () => const MinimalistMicroBarRenderer(),
    capabilities: const ModelCapabilities(supportsSticky: true),
  );
  registry.register(
    AppBarModel.profileIdentity,
    () => const ProfileIdentityRenderer(),
    capabilities: const ModelCapabilities(supportsShapeMorph: true, supportsSticky: true),
  );

  // --- Complete Design System: Batch D (Models 13–16) ---
  registry.register(
    AppBarModel.expandableControlCenter,
    () => const ExpandableControlCenterRenderer(),
    capabilities: const ModelCapabilities(supportsSticky: true, supportsMultiStage: true),
  );
  registry.register(
    AppBarModel.timelineScrubberNav,
    () => const TimelineScrubberNavRenderer(),
    capabilities: const ModelCapabilities(supportsSticky: true, supportsMultiStage: true),
  );
  registry.register(
    AppBarModel.searchSpotlight,
    () => const SearchSpotlightRenderer(),
    capabilities: const ModelCapabilities(supportsSticky: true, supportsMultiStage: true),
  );
  registry.register(
    AppBarModel.gestureElasticCanvas,
    () => const GestureElasticCanvasRenderer(),
    capabilities: const ModelCapabilities(supportsDragToExpand: true, supportsSticky: true, supportsMultiStage: true),
  );

  // --- Complete Design System: Batch E (Models 17–20) ---
  registry.register(
    AppBarModel.adaptiveBreakpointNav,
    () => const AdaptiveBreakpointNavRenderer(),
    capabilities: const ModelCapabilities(supportsSticky: true, supportsMultiStage: true),
  );
  registry.register(
    AppBarModel.contextFocalSwapNav,
    () => const ContextFocalSwapNavRenderer(),
    capabilities: const ModelCapabilities(supportsSticky: true, supportsMultiStage: true),
  );
  registry.register(
    AppBarModel.liquidWaveMorphNav,
    () => const LiquidWaveMorphNavRenderer(),
    capabilities: const ModelCapabilities(supportsShapeMorph: true, supportsSticky: true),
  );
  registry.register(
    AppBarModel.developerCustomCanvas,
    () => const DeveloperCustomCanvasRenderer(),
    capabilities: const ModelCapabilities(supportsSticky: true, supportsMultiStage: true),
  );
}
