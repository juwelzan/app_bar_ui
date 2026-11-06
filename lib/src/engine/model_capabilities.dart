/// Declares what features, motion primitives, and interaction models
/// an [AppBarModel] supports.
///
/// Used by the capability validator to prevent silent failures and provide
/// actionable development-time diagnostics.
class ModelCapabilities {
  /// Creates a model capability specification.
  const ModelCapabilities({
    this.supportsParallax = false,
    this.supportsShapeMorph = false,
    this.supportsDragToExpand = false,
    this.supportsSticky = false,
    this.supports3DTransform = false,
    this.supportsMultiStage = false,
    this.supportsRadialActions = false,
    this.supportsFloatingDock = false,
    this.supportsVelocityAutoHide = false,
    this.supportsCurtainSplit = false,
    this.supportsMagneticSnap = false,
    this.supportsAccordionSlices = false,
    this.supportsCircularClipper = false,
    this.supportsStackedPanels = false,
    this.supportsCustomMotion = true,
    this.supportsCustomLayoutBuilder = true,
    this.supportsElementOverrides = true,
  });

  /// Whether the model supports optical multi-plane parallax depth.
  final bool supportsParallax;

  /// Whether the model supports geometric shape morphing (e.g., polygon, circle, pill).
  final bool supportsShapeMorph;

  /// Whether the model supports direct touch drag gestures to expand/reveal content.
  final bool supportsDragToExpand;

  /// Whether the model supports pinning/sticking secondary content tiers.
  final bool supportsSticky;

  /// Whether the model supports Matrix4 3D perspective pitch/roll transformations.
  final bool supports3DTransform;

  /// Whether the model supports discrete multi-stage milestone layouts.
  final bool supportsMultiStage;

  /// Whether the model arranges and animates actions in polar/radial orbits.
  final bool supportsRadialActions;

  /// Whether the model can transform into a floating bottom capsule dock.
  final bool supportsFloatingDock;

  /// Whether the model supports scroll direction and velocity-based auto-hiding.
  final bool supportsVelocityAutoHide;

  /// Whether the model supports lateral split curtain parting animations.
  final bool supportsCurtainSplit;

  /// Whether the model supports magnetic spring-based scroll detent snapping.
  final bool supportsMagneticSnap;

  /// Whether the model supports independent multi-slice accordion collapse.
  final bool supportsAccordionSlices;

  /// Whether the model supports circular/radial aperture clipping masks.
  final bool supportsCircularClipper;

  /// Whether the model supports stacked overlapping card deck transforms.
  final bool supportsStackedPanels;

  /// Whether the model accepts custom animation curves, duration, and physics.
  final bool supportsCustomMotion;

  /// Whether the model accepts custom layout builders.
  final bool supportsCustomLayoutBuilder;

  /// Whether the model accepts individual element-level overrides.
  final bool supportsElementOverrides;

  /// Universal baseline capabilities for standard models.
  static const ModelCapabilities standard = ModelCapabilities(
    supportsSticky: true,
  );

  /// Capabilities for 3D perspective models.
  static const ModelCapabilities dimensional3D = ModelCapabilities(
    supports3DTransform: true,
  );

  /// Capabilities for drag & gesture models.
  static const ModelCapabilities gestureDriven = ModelCapabilities(
    supportsDragToExpand: true,
  );

  /// Capabilities for radial action models.
  static const ModelCapabilities radial = ModelCapabilities(
    supportsRadialActions: true,
  );

  /// Capabilities for velocity auto-hide models.
  static const ModelCapabilities autoHide = ModelCapabilities(
    supportsVelocityAutoHide: true,
  );

  /// Capabilities for parallax & depth models.
  static const ModelCapabilities parallax = ModelCapabilities(
    supportsParallax: true,
  );

  /// Capabilities for shape morphing models.
  static const ModelCapabilities shapeMorph = ModelCapabilities(
    supportsShapeMorph: true,
  );

  /// Capabilities for docking models.
  static const ModelCapabilities dock = ModelCapabilities(
    supportsFloatingDock: true,
  );

  /// Capabilities for curtain split models.
  static const ModelCapabilities curtain = ModelCapabilities(
    supportsCurtainSplit: true,
  );

  /// Capabilities for magnetic snap models.
  static const ModelCapabilities magneticSnapCapabilities = ModelCapabilities(
    supportsMagneticSnap: true,
  );

  /// Capabilities for multi-slice accordion models.
  static const ModelCapabilities accordion = ModelCapabilities(
    supportsAccordionSlices: true,
  );

  /// Capabilities for circular clipper models.
  static const ModelCapabilities circularClipper = ModelCapabilities(
    supportsCircularClipper: true,
  );

  /// Capabilities for stacked deck models.
  static const ModelCapabilities stackedPanels = ModelCapabilities(
    supportsStackedPanels: true,
  );
}

