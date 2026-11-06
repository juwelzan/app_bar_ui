/// Comprehensive enumeration of all distinct AppBar models supported by the
/// Universal AppBar Engine.
///
/// Each model provides an independent layout structure, scroll mechanics,
/// animation timeline, and interaction physics.
enum AppBarModel {
  /// Model 0: Classic standard Material/Cupertino style navigation bar.
  classic,

  // --- Complete Design System: 20 Autonomous Models ---
  /// Model 1: Corporate multi-tier breadcrumb hierarchy and sticky tabs.
  traditionalStructured,

  /// Model 2: 100vh viewport cinematic media canvas with glassmorphic toolbar.
  fullScreenHero,

  /// Model 3: Detached floating pill hovering freely over scroll content with spring recoil.
  floatingIsland,

  /// Model 4: Multi-plane 3D spatial virtual z-depth with focal blur convergence.
  immersiveSpatial,

  /// Model 5: Lateral split curtain panels sliding inward to fuse into pinned toolbar.
  multiPanelSplitCurtain,

  /// Model 6: 180° perspective projection flip between hero card and action toolbar.
  spatial3DFlip,

  /// Model 7: Adaptive horizontal hero transforming into a compact navigation rail.
  verticalRailTransform,

  /// Model 8: Polar arc dial distributing interactive nodes along a trigonometric circle.
  radialDial,

  /// Model 9: High-end publication masthead with dynamic tracking and reading progress.
  editorialTypography,

  /// Model 10: Stacked physical card deck fanning out and tucking into pinned toolbar.
  cardDeckStacked,

  /// Model 11: Ultra-compact content-first ribbon with monospace micro-breadcrumbs.
  minimalistMicroBar,

  /// Model 12: Prominent centered avatar and identity scale-morphing into toolbar.
  profileIdentity,

  /// Model 13: Quick-settings control hub with interactive tiles collapsing into icon status bar.
  expandableControlCenter,

  /// Model 14: Chronological scrubber header with milestone nodes along horizontal track.
  timelineScrubberNav,

  /// Model 15: Full-width prominent search experience with suggested query pills and filter chips.
  searchSpotlight,

  /// Model 16: Physics-based rubber-band elastic header canvas with damped spring overscroll.
  gestureElasticCanvas,

  /// Model 17: Adaptive breakpoint navigation automatically reforming between mobile, tablet, and desktop breakpoints.
  adaptiveBreakpointNav,

  /// Model 18: Context focal swap header dynamically swapping primary focus, actions, and telemetry based on active domain.
  contextFocalSwapNav,

  /// Model 19: Fluid organic sine wave morphing header with animated boundary deformation.
  liquidWaveMorphNav,

  /// Model 20: Blank developer-defined custom canvas with full builder lifecycle and zero engine constraints.
  developerCustomCanvas,
}

/// Convenience display extensions on [AppBarModel].
extension AppBarModelDisplayName on AppBarModel {
  /// Human-readable display label for gallery pickers, inspector tools, and diagnostics.
  String get displayName {
    switch (this) {
      case AppBarModel.classic:
        return 'Classic Material';
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
      case AppBarModel.expandableControlCenter:
        return 'Expandable Control Center';
      case AppBarModel.timelineScrubberNav:
        return 'Timeline Scrubber Navigation';
      case AppBarModel.searchSpotlight:
        return 'Search Spotlight First';
      case AppBarModel.gestureElasticCanvas:
        return 'Gesture Elastic Canvas';
      case AppBarModel.adaptiveBreakpointNav:
        return 'Adaptive Breakpoint Navigation';
      case AppBarModel.contextFocalSwapNav:
        return 'Context Focal Swap Navigation';
      case AppBarModel.liquidWaveMorphNav:
        return 'Liquid Wave Morph Navigation';
      case AppBarModel.developerCustomCanvas:
        return 'Developer Custom Canvas';
    }
  }
}
