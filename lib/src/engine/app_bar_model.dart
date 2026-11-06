/// Comprehensive enumeration of all distinct AppBar models supported by the
/// Universal AppBar Engine.
///
/// Each model provides an independent layout structure, scroll mechanics,
/// animation timeline, and interaction physics.
enum AppBarModel {
  // --- Batch 1 (1–5): Core Morphing & Motion ---
  /// Style 1: Split header that divides into two lateral sections on scroll.
  morphingSplit,

  /// Style 2: Floating header with elastic rubber-band pull and settle physics.
  elasticFloating,

  /// Style 3: Complete header scrolls away while selected actions stay pinned.
  disappearingActions,

  /// Style 4: Rectangular header morphs into a circular or rounded floating pill.
  circularMorph,

  /// Style 5: Header panels rotate around a 3D perspective axis.
  flip3D,

  // --- Batch 2 (6–10): Directional & Fluid Dynamics ---
  /// Style 6: Panels slide horizontally across the viewport during scroll.
  horizontalSliding,

  /// Style 7: Vertical multi-tier accordion that folds and collapses sequentially.
  verticalFolding,

  /// Style 8: Multi-layer depth parallax with independent movement factors.
  layeredDepth,

  /// Style 9: Large hero banner transforms smoothly into a compact docked toolbar.
  expandingHero,

  /// Style 10: Smooth fluid/liquid wave deformation along the bottom boundary.
  liquidWave,

  // --- Batch 3 (11–15): Reactive & Progressive ---
  /// Style 11: Auto-hides on downward scroll velocity and reveals on upward flick.
  autoHidingVelocity,

  /// Style 12: Animations mapped directly to scroll progress with progress indicator.
  scrollSynchronizedProgress,

  /// Style 13: Top tier collapses while bottom navigation tier stays sticky.
  stickyDualTier,

  /// Style 14: Discrete 4-stage transitions with reversible layout states.
  multiStageReveal,

  /// Style 15: Header dissolves and reconstitutes as a floating bottom dock.
  animatedDock,

  // --- Batch 4 (16–20): Spatial & Interactive ---
  /// Style 16: Action buttons orbit in polar coordinates around a central core.
  radialOrbit,

  /// Style 17: Header splits laterally into two distinct curtain zones.
  splitCurtain,

  /// Style 18: Header magnetically snaps between defined scroll detents.
  magneticSnap,

  /// Style 19: Deep parallax zoom magnification with optical scrim.
  parallaxZoom,

  /// Style 20: Overscroll pull-down opens an interactive disclosure canvas.
  pullDownDisclosure,

  // --- Batch 5 (21–25): Structural & Semantic ---
  /// Style 21: Rich promotional cards compress into a slim pinned tab strip.
  tabTransform,

  /// Style 22: Prominent hero avatar glides along quadratic Bezier curve to toolbar.
  avatarToProfile,

  /// Style 23: Multi-tier content collapses in cascading milestone sequence.
  progressiveDisclosure,

  /// Style 24: Header width shrinks laterally into a centered pill or card.
  sidewaysCollapse,

  /// Style 25: Search bar morphs from compact action button to full-width input.
  expandingSearch,

  // --- Batch 6 (26–30): Contextual & Adaptive ---
  /// Style 26: Multi-segment breadcrumb path collapses intermediate nodes into dropdown.
  breadcrumbTransform,

  /// Style 27: Elevated floating card morphs margins, border radius, and elevation.
  cardToHeaderMorph,

  /// Style 28: Off-screen edge-anchored toolbar reveals on gesture/velocity triggers.
  revealFromEdge,

  /// Style 29: Direct touch drag gesture pulls open secondary control drawer.
  gestureDrivenDrag,

  /// Style 30: Dynamically reorganizes layout across Mobile, Tablet, and Desktop.
  adaptiveMultiDevice,

  // --- Batch 7 (31–35): Cinematic & Physics ---
  /// Style 31: Celestial planet core surrounded by orbiting satellite actions.
  floatingOrbit,

  /// Style 32: N independent horizontal slices collapse at custom scroll intervals.
  multiSliceAccordion,

  /// Style 33: Dual velvet stage curtain panels bunch and part to reveal backdrop.
  theaterCurtain,

  /// Style 34: Optical zoom with divergent multi-vector typography motion.
  divergentVectorZoom,

  /// Style 35: Mathematical sine wave bottom boundary with dynamic phase ripple.
  dynamicSineWave,

  // --- Batch 8 (36–40): Dimensional & Layered ---
  /// Style 36: Action badge and title magnetically snap and latch into docked anchors.
  magneticAnchorSnap,

  /// Style 37: Title, search, and actions pin progressively in cascading order.
  cascadingProgressivePin,

  /// Style 38: 3D perspective flip between primary media and compact control modes.
  dualMode3DCrossfade,

  /// Style 39: Radial circular aperture mask expands/contracts around focal center.
  radialCircularClipperReveal,

  /// Style 40: 3-tier overlapping card deck with depth scale and progressive slide.
  depthOverlapStackedPanel,

  // --- Batch 9 (41–45): Experimental & Generative ---
  /// Style 41: Header tilts along 3D pitch/roll axes based on velocity.
  perspectiveVelocityTilt,

  /// Style 42: Character glyphs scatter along 2D vectors and reconverge into title.
  dispersingLetterScatter,

  /// Style 43: Geometric polygon path morphs smoothly into rectangular toolbar.
  polygonToRectangleMorph,

  /// Style 44: Detached floating island header with damped inertia and spring bounce.
  detachedDampedIsland,

  /// Style 45: Full bleed edge-to-edge media banner scaling to compact toolbar.
  fullBleedHeroScale,

  // --- Batch 10 (46–50): Novel & Interactive Frontiers ---
  /// Style 46: Interactive scrubbing timeline header with milestone indicators.
  scrubberTimelineProgress,

  /// Style 47: Multi-anchor floating dock with reconfigurable action slots.
  multiAnchorDock,

  /// Style 48: Horizontal header morphs into vertical navigation rail on wide screens.
  sliverToRailTransform,

  /// Style 49: Context-aware focal swap switching displayed metrics dynamically.
  contextAwareFocalSwap,

  /// Style 50: Motion along custom mathematical Spline/Bezier paths.
  splineCurvedMotionPath,

  // --- Universal Standard ---
  /// Classic standard Material/Cupertino style navigation bar.
  classic,

  // --- Complete Design System: 20 Autonomous Models (Batch A) ---
  /// Model 1: Corporate multi-tier breadcrumb hierarchy and sticky tabs.
  traditionalStructured,

  /// Model 2: 100vh viewport cinematic media canvas with glassmorphic toolbar.
  fullScreenHero,

  /// Model 3: Detached floating pill hovering freely over scroll content.
  floatingIsland,

  /// Model 4: Multi-plane 3D spatial virtual z-depth with focal blur convergence.
  immersiveSpatial,

  // --- Complete Design System: 20 Autonomous Models (Batch B) ---
  /// Model 5: Lateral split curtain panels sliding inward to fuse into pinned toolbar.
  multiPanelSplitCurtain,

  /// Model 6: 3D perspective projection flip between hero card and action toolbar.
  spatial3DFlip,

  /// Model 7: Adaptive horizontal hero transforming into a compact navigation rail.
  verticalRailTransform,

  /// Model 8: Polar arc dial distributing interactive nodes along a trigonometric circle.
  radialDial,

  // --- Complete Design System: 20 Autonomous Models (Batch C) ---
  /// Model 9: High-end publication masthead with dynamic tracking and reading progress.
  editorialTypography,

  /// Model 10: Stacked physical card deck fanning out and tucking into pinned toolbar.
  cardDeckStacked,

  /// Model 11: Ultra-compact content-first ribbon with monospace micro-breadcrumbs.
  minimalistMicroBar,

  /// Model 12: Prominent centered avatar and identity scale-morphing into toolbar.
  profileIdentity,
}

/// Convenience display extensions on [AppBarModel].
extension AppBarModelDisplayName on AppBarModel {
  /// Human-readable display label for gallery pickers, inspector tools, and diagnostics.
  String get displayName {
    switch (this) {
      case AppBarModel.traditionalStructured:
        return 'Traditional Structured';
      case AppBarModel.fullScreenHero:
        return 'Full-Screen Hero';
      case AppBarModel.floatingIsland:
        return 'Floating Dynamic Island';
      case AppBarModel.immersiveSpatial:
        return 'Immersive Spatial Parallax';
      case AppBarModel.multiPanelSplitCurtain:
        return 'Multi-Panel Split Curtain';
      case AppBarModel.spatial3DFlip:
        return '3D Perspective Flip';
      case AppBarModel.verticalRailTransform:
        return 'Vertical Rail Transform';
      case AppBarModel.radialDial:
        return 'Radial Polar Dial';
      case AppBarModel.editorialTypography:
        return 'Editorial Typography';
      case AppBarModel.cardDeckStacked:
        return 'Card Deck Stacked';
      case AppBarModel.minimalistMicroBar:
        return 'Minimalist Micro-Bar';
      case AppBarModel.profileIdentity:
        return 'Profile Identity Centered';
      case AppBarModel.classic:
        return 'Classic Material';
      default:
        final exp = RegExp(r'(?<=[a-z])[A-Z]');
        return name
            .replaceAllMapped(exp, (m) => ' ${m.group(0)}')
            .replaceFirstMapped(RegExp(r'^[a-z]'), (m) => m.group(0)!.toUpperCase());
    }
  }
}

