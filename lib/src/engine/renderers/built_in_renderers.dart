import '../app_bar_model.dart';
import '../app_bar_model_registry.dart';
import '../model_capabilities.dart';
import 'batch1_renderers.dart';
import 'batch2_renderers.dart';
import 'batch3_renderers.dart';
import 'batch4_renderers.dart';
import 'batch5_renderers.dart';
import 'batch6_renderers.dart';
import 'batch7_renderers.dart';
import 'batch8_renderers.dart';
import 'batch9_renderers.dart';
import 'batch10_renderers.dart';
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

/// Bootstraps all built-in model renderers into the registry.
void bootstrapBuiltInRenderers(AppBarModelRegistry registry) {
  // --- Batch 1 (1–5) ---
  registry.register(
    AppBarModel.morphingSplit,
    () => const MorphingSplitRenderer(),
    capabilities: const ModelCapabilities(supportsCurtainSplit: true),
  );
  registry.register(
    AppBarModel.elasticFloating,
    () => const ElasticFloatingRenderer(),
    capabilities: const ModelCapabilities(supportsDragToExpand: true),
  );
  registry.register(
    AppBarModel.disappearingActions,
    () => const DisappearingActionsRenderer(),
    capabilities: const ModelCapabilities(supportsVelocityAutoHide: true),
  );
  registry.register(
    AppBarModel.circularMorph,
    () => const CircularMorphRenderer(),
    capabilities: const ModelCapabilities(supportsShapeMorph: true),
  );
  registry.register(
    AppBarModel.flip3D,
    () => const Flip3DRenderer(),
    capabilities: const ModelCapabilities(supports3DTransform: true),
  );

  // --- Batch 2 (6–10) ---
  registry.register(
    AppBarModel.horizontalSliding,
    () => const HorizontalSlidingRenderer(),
  );
  registry.register(
    AppBarModel.verticalFolding,
    () => const VerticalFoldingRenderer(),
    capabilities: const ModelCapabilities(supportsAccordionSlices: true),
  );
  registry.register(
    AppBarModel.layeredDepth,
    () => const LayeredDepthRenderer(),
    capabilities: const ModelCapabilities(supportsParallax: true),
  );
  registry.register(
    AppBarModel.expandingHero,
    () => const ExpandingHeroRenderer(),
    capabilities: const ModelCapabilities(supportsParallax: true),
  );
  registry.register(
    AppBarModel.liquidWave,
    () => const LiquidWaveRenderer(),
    capabilities: const ModelCapabilities(supportsShapeMorph: true),
  );

  // --- Batch 3 (11–15) ---
  registry.register(
    AppBarModel.autoHidingVelocity,
    () => const AutoHidingVelocityRenderer(),
    capabilities: const ModelCapabilities(supportsVelocityAutoHide: true),
  );
  registry.register(
    AppBarModel.scrollSynchronizedProgress,
    () => const ScrollSynchronizedProgressRenderer(),
  );
  registry.register(
    AppBarModel.stickyDualTier,
    () => const StickyDualTierRenderer(),
    capabilities: const ModelCapabilities(supportsSticky: true),
  );
  registry.register(
    AppBarModel.multiStageReveal,
    () => const MultiStageRevealRenderer(),
    capabilities: const ModelCapabilities(supportsMultiStage: true),
  );
  registry.register(
    AppBarModel.animatedDock,
    () => const AnimatedDockRenderer(),
    capabilities: const ModelCapabilities(supportsFloatingDock: true),
  );

  // --- Batch 4 (16–20) ---
  registry.register(
    AppBarModel.radialOrbit,
    () => const RadialOrbitRenderer(),
    capabilities: const ModelCapabilities(supportsRadialActions: true),
  );
  registry.register(
    AppBarModel.splitCurtain,
    () => const SplitCurtainRenderer(),
    capabilities: const ModelCapabilities(supportsCurtainSplit: true),
  );
  registry.register(
    AppBarModel.magneticSnap,
    () => const MagneticSnapRenderer(),
    capabilities: const ModelCapabilities(supportsMagneticSnap: true),
  );
  registry.register(
    AppBarModel.parallaxZoom,
    () => const ParallaxZoomRenderer(),
    capabilities: const ModelCapabilities(supportsParallax: true),
  );
  registry.register(
    AppBarModel.pullDownDisclosure,
    () => const PullDownDisclosureRenderer(),
    capabilities: const ModelCapabilities(supportsDragToExpand: true),
  );

  // --- Batch 5 (21–25) ---
  registry.register(
    AppBarModel.tabTransform,
    () => const TabTransformRenderer(),
    capabilities: const ModelCapabilities(supportsSticky: true),
  );
  registry.register(
    AppBarModel.avatarToProfile,
    () => const AvatarToProfileRenderer(),
    capabilities: const ModelCapabilities(supportsParallax: true),
  );
  registry.register(
    AppBarModel.progressiveDisclosure,
    () => const ProgressiveDisclosureRenderer(),
    capabilities: const ModelCapabilities(supportsMultiStage: true),
  );
  registry.register(
    AppBarModel.sidewaysCollapse,
    () => const SidewaysCollapseRenderer(),
    capabilities: const ModelCapabilities(supportsShapeMorph: true),
  );
  registry.register(
    AppBarModel.expandingSearch,
    () => const ExpandingSearchRenderer(),
  );

  // --- Batch 6 (26–30) ---
  registry.register(
    AppBarModel.breadcrumbTransform,
    () => const BreadcrumbTransformRenderer(),
  );
  registry.register(
    AppBarModel.cardToHeaderMorph,
    () => const CardToHeaderMorphRenderer(),
    capabilities: const ModelCapabilities(supportsShapeMorph: true),
  );
  registry.register(
    AppBarModel.revealFromEdge,
    () => const RevealFromEdgeRenderer(),
    capabilities: const ModelCapabilities(supportsVelocityAutoHide: true),
  );
  registry.register(
    AppBarModel.gestureDrivenDrag,
    () => const GestureDrivenDragRenderer(),
    capabilities: const ModelCapabilities(supportsDragToExpand: true),
  );
  registry.register(
    AppBarModel.adaptiveMultiDevice,
    () => const AdaptiveMultiDeviceRenderer(),
    capabilities: const ModelCapabilities(supportsCustomLayoutBuilder: true),
  );

  // --- Batch 7 (31–35) ---
  registry.register(
    AppBarModel.floatingOrbit,
    () => const FloatingOrbitRenderer(),
    capabilities: const ModelCapabilities(supportsRadialActions: true),
  );
  registry.register(
    AppBarModel.multiSliceAccordion,
    () => const MultiSliceAccordionRenderer(),
    capabilities: const ModelCapabilities(supportsAccordionSlices: true),
  );
  registry.register(
    AppBarModel.theaterCurtain,
    () => const TheaterCurtainRenderer(),
    capabilities: const ModelCapabilities(supportsCurtainSplit: true),
  );
  registry.register(
    AppBarModel.divergentVectorZoom,
    () => const DivergentVectorZoomRenderer(),
    capabilities: const ModelCapabilities(supportsParallax: true),
  );
  registry.register(
    AppBarModel.dynamicSineWave,
    () => const DynamicSineWaveRenderer(),
    capabilities: const ModelCapabilities(supportsShapeMorph: true),
  );

  // --- Batch 8 (36–40) ---
  registry.register(
    AppBarModel.magneticAnchorSnap,
    () => const MagneticAnchorSnapRenderer(),
    capabilities: const ModelCapabilities(supportsMagneticSnap: true),
  );
  registry.register(
    AppBarModel.cascadingProgressivePin,
    () => const CascadingProgressivePinRenderer(),
    capabilities: const ModelCapabilities(supportsMultiStage: true, supportsSticky: true),
  );
  registry.register(
    AppBarModel.dualMode3DCrossfade,
    () => const DualMode3DCrossfadeRenderer(),
    capabilities: const ModelCapabilities(supports3DTransform: true),
  );
  registry.register(
    AppBarModel.radialCircularClipperReveal,
    () => const RadialCircularClipperRevealRenderer(),
    capabilities: const ModelCapabilities(supportsCircularClipper: true, supportsShapeMorph: true),
  );
  registry.register(
    AppBarModel.depthOverlapStackedPanel,
    () => const DepthOverlapStackedPanelRenderer(),
    capabilities: const ModelCapabilities(supportsStackedPanels: true, supportsParallax: true),
  );

  // --- Batch 9 (41–45) ---
  registry.register(
    AppBarModel.perspectiveVelocityTilt,
    () => const PerspectiveVelocityTiltRenderer(),
    capabilities: const ModelCapabilities(supports3DTransform: true),
  );
  registry.register(
    AppBarModel.dispersingLetterScatter,
    () => const DispersingLetterScatterRenderer(),
  );
  registry.register(
    AppBarModel.polygonToRectangleMorph,
    () => const PolygonToRectangleMorphRenderer(),
    capabilities: const ModelCapabilities(supportsShapeMorph: true),
  );
  registry.register(
    AppBarModel.detachedDampedIsland,
    () => const DetachedDampedIslandRenderer(),
    capabilities: const ModelCapabilities(supportsDragToExpand: true),
  );
  registry.register(
    AppBarModel.fullBleedHeroScale,
    () => const FullBleedHeroScaleRenderer(),
    capabilities: const ModelCapabilities(supportsParallax: true),
  );

  // --- Batch 10 (46–50) ---
  registry.register(
    AppBarModel.scrubberTimelineProgress,
    () => const InteractiveTimelineScrubberRenderer(),
  );
  registry.register(
    AppBarModel.multiAnchorDock,
    () => const MultiAnchorDockRenderer(),
    capabilities: const ModelCapabilities(supportsDragToExpand: true),
  );
  registry.register(
    AppBarModel.sliverToRailTransform,
    () => const SliverToRailTransformRenderer(),
  );
  registry.register(
    AppBarModel.contextAwareFocalSwap,
    () => const ContextAwareFocalSwapRenderer(),
    capabilities: const ModelCapabilities(supportsMultiStage: true),
  );
  registry.register(
    AppBarModel.splineCurvedMotionPath,
    () => const SplineCurvedMotionPathRenderer(),
    capabilities: const ModelCapabilities(supports3DTransform: true),
  );

  // --- Universal Standard ---
  registry.register(
    AppBarModel.classic,
    () => const ClassicAppBarRenderer(),
    capabilities: ModelCapabilities.standard,
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
    capabilities: const ModelCapabilities(supportsParallax: true, supportsDragToExpand: true),
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
}

