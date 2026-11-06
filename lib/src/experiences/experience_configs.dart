import 'package:flutter/material.dart';
import '../motion/motion_config.dart';

/// Configuration for Style 1: Morphing Split Header.
class MorphingSplitConfig extends AppBarMotionConfig {
  /// Creates a [MorphingSplitConfig].
  const MorphingSplitConfig({
    super.curve = Curves.easeInOutCubic,
    super.reducedMotionCurve = Curves.linear,
    this.expandedHeight = 140.0,
    this.collapsedHeight = kToolbarHeight,
    this.splitDistance = 60.0,
    this.mergeThreshold = 0.65,
    this.elevation = 0.0,
    this.collapsedElevation = 3.0,
  });

  /// Height when completely expanded.
  final double expandedHeight;

  /// Height when completely collapsed into compact bar.
  final double collapsedHeight;

  /// Maximum horizontal divergent travel distance for left/right modules.
  final double splitDistance;

  /// Normalized scroll progress ratio ($0.0 \to 1.0$) where modules merge into center pill.
  final double mergeThreshold;

  /// Expanded resting elevation.
  final double elevation;

  /// Elevation in compact collapsed state.
  final double collapsedElevation;
}

/// Configuration for Style 2: Elastic Floating Header.
class ElasticFloatingConfig extends AppBarMotionConfig {
  /// Creates an [ElasticFloatingConfig].
  const ElasticFloatingConfig({
    super.curve = Curves.easeOutBack,
    super.reducedMotionCurve = Curves.easeOut,
    this.height = 72.0,
    this.compactHeight = 56.0,
    this.horizontalMargin = 16.0,
    this.verticalMargin = 8.0,
    this.borderRadius = 20.0,
    this.compactBorderRadius = 28.0,
    this.maxOverscrollStretch = 50.0,
    this.stiffness = 220.0,
    this.damping = 18.0,
    this.restingElevation = 2.0,
    this.compactElevation = 6.0,
  });

  /// Normal resting height of the floating header.
  final double height;

  /// Height when settled in compact state.
  final double compactHeight;

  /// Left and right margin from screen bounds.
  final double horizontalMargin;

  /// Top and bottom resting margin.
  final double verticalMargin;

  /// Border radius when expanded.
  final double borderRadius;

  /// Border radius when compacted into capsule.
  final double compactBorderRadius;

  /// Maximum downward stretch distance during pull overscroll.
  final double maxOverscrollStretch;

  /// Spring stiffness constant.
  final double stiffness;

  /// Spring damping coefficient.
  final double damping;

  /// Resting elevation shadow.
  final double restingElevation;

  /// Elevated shadow in compact floating state.
  final double compactElevation;
}

/// Configuration for Style 3: Disappearing Header with Floating Actions.
class DisappearingFloatingActionsConfig extends AppBarMotionConfig {
  /// Creates a [DisappearingFloatingActionsConfig].
  const DisappearingFloatingActionsConfig({
    super.curve = Curves.easeInOut,
    super.reducedMotionCurve = Curves.linear,
    this.expandedHeight = 160.0,
    this.detachOffset = 45.0,
    this.fadeOffset = 80.0,
    this.actionSpacing = 10.0,
    this.floatingActionElevation = 6.0,
    this.floatingActionMargin = const EdgeInsets.only(top: 12.0, right: 16.0),
  });

  /// Height of the non-permanent hero header.
  final double expandedHeight;

  /// Scroll offset at which action controls detach and float independently.
  final double detachOffset;

  /// Scroll offset at which header title and metadata fade to 0 opacity.
  final double fadeOffset;

  /// Spacing between pinned floating action icons.
  final double actionSpacing;

  /// Elevation shadow for detached floating actions.
  final double floatingActionElevation;

  /// Anchor position margin for detached floating action cluster.
  final EdgeInsets floatingActionMargin;
}

/// Configuration for Style 4: Circular Morph Header.
class CircularMorphConfig extends AppBarMotionConfig {
  /// Creates a [CircularMorphConfig].
  const CircularMorphConfig({
    super.curve = Curves.fastOutSlowIn,
    super.reducedMotionCurve = Curves.linear,
    this.expandedHeight = 130.0,
    this.targetDiameter = 54.0,
    this.anchorAlignment = Alignment.topRight,
    this.margin = const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
    this.compactMargin = const EdgeInsets.only(top: 8.0, right: 16.0),
    this.restingElevation = 1.0,
    this.compactElevation = 5.0,
  });

  /// Expanded height of the full-width rect header.
  final double expandedHeight;

  /// Diameter of the final circular morph state.
  final double targetDiameter;

  /// Alignment where the circle anchors in the compact state.
  final Alignment anchorAlignment;

  /// Initial padding/margin when rectangular.
  final EdgeInsets margin;

  /// Margin when morphed into compact floating circular avatar.
  final EdgeInsets compactMargin;

  /// Elevation in expanded state.
  final double restingElevation;

  /// Elevation in compact circular state.
  final double compactElevation;
}

/// Configuration for Style 5: 3D Flip Header.
class Flip3DConfig extends AppBarMotionConfig {
  /// Creates a [Flip3DConfig].
  const Flip3DConfig({
    super.curve = Curves.easeInOutCubic,
    super.reducedMotionCurve = Curves.linear,
    this.expandedHeight = 160.0,
    this.collapsedHeight = kToolbarHeight,
    this.perspective = 0.0016,
    this.flipAxis = Axis.horizontal,
    this.flipThreshold = 120.0,
    this.frontElevation = 2.0,
    this.backElevation = 4.0,
  });

  /// Expanded card height (front face).
  final double expandedHeight;

  /// Collapsed toolbar height (back face).
  final double collapsedHeight;

  /// 3D perspective projection distortion factor.
  final double perspective;

  /// Axis of rotation: [Axis.horizontal] for vertical card flip, [Axis.vertical] for lateral spin.
  final Axis flipAxis;

  /// Scroll distance required to execute a complete $180^\circ$ flip.
  final double flipThreshold;

  /// Front face card elevation.
  final double frontElevation;

  /// Back face compact bar elevation.
  final double backElevation;
}

/// Configuration for Style 6: Horizontal Sliding Multi-Panel Header.
class HorizontalSlidingPanelsConfig extends AppBarMotionConfig {
  /// Creates a [HorizontalSlidingPanelsConfig].
  const HorizontalSlidingPanelsConfig({
    super.curve = Curves.easeInOutCubic,
    super.reducedMotionCurve = Curves.linear,
    this.expandedHeight = 150.0,
    this.collapsedHeight = kToolbarHeight,
    this.panel1SlideDistance = 120.0,
    this.panel2SlideDistance = 80.0,
    this.fadeThreshold = 0.7,
    this.elevation = 2.0,
  });

  /// Height when completely expanded.
  final double expandedHeight;

  /// Height when collapsed into compact docked bar.
  final double collapsedHeight;

  /// Maximum horizontal travel for the top secondary panel (slides left).
  final double panel1SlideDistance;

  /// Maximum horizontal travel for the bottom secondary panel (slides right).
  final double panel2SlideDistance;

  /// Normalized scroll progress ratio ($0.0 \to 1.0$) where sliding panels fade away.
  final double fadeThreshold;

  /// Compact header elevation shadow.
  final double elevation;
}

/// Configuration for Style 7: Vertical Folding Accordion Header.
class VerticalFoldingAccordionConfig extends AppBarMotionConfig {
  /// Creates a [VerticalFoldingAccordionConfig].
  const VerticalFoldingAccordionConfig({
    super.curve = Curves.easeInOut,
    super.reducedMotionCurve = Curves.linear,
    this.expandedHeight = 180.0,
    this.collapsedHeight = kToolbarHeight,
    this.perspective = 0.002,
    this.foldThreshold = 100.0,
    this.seamShadowIntensity = 0.45,
    this.elevation = 2.0,
  });

  /// Height of the fully unfolded multi-tier header.
  final double expandedHeight;

  /// Height of the pinned primary toolbar when tiers are folded.
  final double collapsedHeight;

  /// 3D perspective distortion factor during accordion folding.
  final double perspective;

  /// Scroll distance in pixels to complete the $90^\circ$ origami fold.
  final double foldThreshold;

  /// Intensity multiplier for the shadow gradient at the origami folding seam.
  final double seamShadowIntensity;

  /// Resting elevation.
  final double elevation;
}

/// Configuration for Style 8: Layered Depth Parallax Header.
class LayeredDepthParallaxConfig extends AppBarMotionConfig {
  /// Creates a [LayeredDepthParallaxConfig].
  const LayeredDepthParallaxConfig({
    super.curve = Curves.linear,
    super.reducedMotionCurve = Curves.linear,
    this.expandedHeight = 200.0,
    this.collapsedHeight = kToolbarHeight + 8.0,
    this.backgroundParallaxFactor = 0.25,
    this.midgroundParallaxFactor = 0.6,
    this.foregroundParallaxFactor = 1.0,
    this.maxBlur = 8.0,
    this.elevation = 3.0,
  });

  /// Height of the multi-plane parallax canvas when expanded.
  final double expandedHeight;

  /// Collapsed toolbar height.
  final double collapsedHeight;

  /// Relative velocity multiplier for the background depth layer ($0.0 \to 1.0$).
  final double backgroundParallaxFactor;

  /// Relative velocity multiplier for the midground graphic layer.
  final double midgroundParallaxFactor;

  /// Relative velocity multiplier for the foreground interactive controls.
  final double foregroundParallaxFactor;

  /// Maximum focal depth blur applied to the background as foreground collapses.
  final double maxBlur;

  /// Docked header elevation.
  final double elevation;
}

/// Configuration for Style 9: Expanding Hero Card Header.
class ExpandingHeroCardConfig extends AppBarMotionConfig {
  /// Creates an [ExpandingHeroCardConfig].
  const ExpandingHeroCardConfig({
    super.curve = Curves.fastOutSlowIn,
    super.reducedMotionCurve = Curves.linear,
    this.expandedHeight = 180.0,
    this.collapsedHeight = kToolbarHeight,
    this.cardHorizontalMargin = 16.0,
    this.cardVerticalMargin = 12.0,
    this.cardBorderRadius = 20.0,
    this.cardElevation = 4.0,
    this.expandThreshold = 70.0,
    this.dockElevation = 2.0,
  });

  /// Height of the inset card header when fully expanded.
  final double expandedHeight;

  /// Height of the docked pinned toolbar when fully collapsed.
  final double collapsedHeight;

  /// Horizontal margin around the floating card in resting state.
  final double cardHorizontalMargin;

  /// Vertical margin around the floating card in resting state.
  final double cardVerticalMargin;

  /// Corner radius of the resting card (interpolates to 0.0 at edge-to-edge).
  final double cardBorderRadius;

  /// Floating card shadow elevation.
  final double cardElevation;

  /// Scroll distance over which the card expands from inset island to edge-to-edge full bleed.
  final double expandThreshold;

  /// Docked toolbar elevation after completing expansion and collapse.
  final double dockElevation;
}

/// Configuration for Style 10: Liquid Wave Morph Header.
class LiquidWaveMorphConfig extends AppBarMotionConfig {
  /// Creates a [LiquidWaveMorphConfig].
  const LiquidWaveMorphConfig({
    super.curve = Curves.easeOutCubic,
    super.reducedMotionCurve = Curves.linear,
    this.expandedHeight = 160.0,
    this.collapsedHeight = kToolbarHeight,
    this.waveAmplitude = 22.0,
    this.waveFrequency = 1.4,
    this.waveSpeed = 0.04,
    this.flattenOffset = 85.0,
    this.elevation = 2.0,
  });

  /// Maximum expanded height including wave crest.
  final double expandedHeight;

  /// Compact collapsed height with flattened edge.
  final double collapsedHeight;

  /// Amplitude of the liquid wave crest in pixels.
  final double waveAmplitude;

  /// Number of sine wave cycles across the screen width.
  final double waveFrequency;

  /// Phase shift multiplier per scroll pixel (controls dynamic fluid ripples on scroll).
  final double waveSpeed;

  /// Scroll offset in pixels at which the wave edge flattens into a straight border.
  final double flattenOffset;

  /// Header elevation.
  final double elevation;
}

/// Configuration for Style 11: Auto-Hiding Velocity-Sensitive Header.
class AutoHidingVelocityConfig extends AppBarMotionConfig {
  /// Creates an [AutoHidingVelocityConfig].
  const AutoHidingVelocityConfig({
    super.curve = Curves.fastOutSlowIn,
    super.reducedMotionCurve = Curves.linear,
    this.height = kToolbarHeight,
    this.hideVelocityThreshold = 150.0,
    this.revealVelocityThreshold = -120.0,
    this.animationDuration = const Duration(milliseconds: 250),
    this.elevation = 3.0,
    this.floating = false,
    this.horizontalMargin = 0.0,
    this.topMargin = 0.0,
    this.borderRadius = 0.0,
  });

  /// Height of the auto-hiding toolbar.
  final double height;

  /// Downward velocity in pixels/second that triggers an immediate slide-away hide.
  final double hideVelocityThreshold;

  /// Upward velocity in pixels/second that triggers an immediate reveal.
  final double revealVelocityThreshold;

  /// Duration of the slide animation.
  final Duration animationDuration;

  /// Resting elevation.
  final double elevation;

  /// Whether the header floats above content with margins and rounded corners.
  final bool floating;

  /// Left/right margin when [floating] is true.
  final double horizontalMargin;

  /// Top margin when [floating] is true.
  final double topMargin;

  /// Corner radius when [floating] is true.
  final double borderRadius;
}

/// Configuration for Style 12: Scroll-Synchronized Progress Header.
class ScrollSynchronizedProgressConfig extends AppBarMotionConfig {
  /// Creates a [ScrollSynchronizedProgressConfig].
  const ScrollSynchronizedProgressConfig({
    super.curve = Curves.easeInOut,
    super.reducedMotionCurve = Curves.linear,
    this.expandedHeight = 140.0,
    this.collapsedHeight = kToolbarHeight,
    this.progressStrokeWidth = 3.5,
    this.showPercentageBadge = true,
    this.elevation = 2.0,
  });

  /// Height when fully expanded.
  final double expandedHeight;

  /// Height when collapsed into compact bar.
  final double collapsedHeight;

  /// Thickness of the reading progress bar or ring.
  final double progressStrokeWidth;

  /// Whether to render a live numerical percentage badge in the toolbar.
  final bool showPercentageBadge;

  /// Collapsed toolbar elevation.
  final double elevation;
}

/// Configuration for Style 13: Sticky-Collapse Dual-Tier Header.
class StickyCollapseDualTierConfig extends AppBarMotionConfig {
  /// Creates a [StickyCollapseDualTierConfig].
  const StickyCollapseDualTierConfig({
    super.curve = Curves.easeInOutCubic,
    super.reducedMotionCurve = Curves.linear,
    this.tier1Height = 85.0,
    this.tier2Height = 56.0,
    this.collapseThreshold = 85.0,
    this.elevation = 3.0,
  });

  /// Height of Tier 1 (branding/identity) that collapses completely out of view.
  final double tier1Height;

  /// Height of Tier 2 (navigation, search, tabs) that docks permanently sticky.
  final double tier2Height;

  /// Scroll distance required to complete Tier 1 collapse.
  final double collapseThreshold;

  /// Sticky docked elevation.
  final double elevation;
}

/// Configuration for Style 14: Multi-Stage Staged Reveal Header.
class MultiStageStagedRevealConfig extends AppBarMotionConfig {
  /// Creates a [MultiStageStagedRevealConfig].
  const MultiStageStagedRevealConfig({
    super.curve = Curves.easeInOutCubic,
    super.reducedMotionCurve = Curves.linear,
    this.expandedHeight = 210.0,
    this.collapsedHeight = 60.0,
    this.stage1EndOffset = 70.0,
    this.stage2EndOffset = 140.0,
    this.elevation = 2.0,
  });

  /// Maximum expanded height (Stage 1: Hero presentation).
  final double expandedHeight;

  /// Pinned collapsed height (Stage 3: Minimalist toolbar).
  final double collapsedHeight;

  /// Scroll offset boundary where Stage 1 transitions to Stage 2.
  final double stage1EndOffset;

  /// Scroll offset boundary where Stage 2 transitions to Stage 3.
  final double stage2EndOffset;

  /// Elevation in compact collapsed state.
  final double elevation;
}

/// Configuration for Style 15: Animated Dock Header.
class AnimatedDockConfig extends AppBarMotionConfig {
  /// Creates an [AnimatedDockConfig].
  const AnimatedDockConfig({
    super.curve = Curves.fastOutSlowIn,
    super.reducedMotionCurve = Curves.linear,
    this.topHeaderHeight = 110.0,
    this.bottomDockHeight = 64.0,
    this.dockTriggerOffset = 90.0,
    this.dockHorizontalMargin = 20.0,
    this.dockBottomMargin = 16.0,
    this.dockBorderRadius = 32.0,
    this.dockElevation = 8.0,
  });

  /// Height of the initial top header canvas.
  final double topHeaderHeight;

  /// Height of the floating bottom dock navigation capsule.
  final double bottomDockHeight;

  /// Scroll offset threshold that triggers top header collapse and bottom dock reveal.
  final double dockTriggerOffset;

  /// Horizontal margin around the floating bottom dock capsule.
  final double dockHorizontalMargin;

  /// Distance between bottom dock and bottom edge / safe area.
  final double dockBottomMargin;

  /// Border radius of the floating bottom dock capsule.
  final double dockBorderRadius;

  /// Elevation shadow of the floating bottom dock.
  final double dockElevation;
}

/// Configuration for Style 16: Radial / Orbital Action Header.
class RadialOrbitalActionConfig extends AppBarMotionConfig {
  /// Creates a [RadialOrbitalActionConfig].
  const RadialOrbitalActionConfig({
    super.curve = Curves.easeInOutCubic,
    super.reducedMotionCurve = Curves.linear,
    this.expandedHeight = 180.0,
    this.collapsedHeight = kToolbarHeight,
    this.orbitRadius = 65.0,
    this.startAngle = -0.85,
    this.endAngle = 0.85,
    this.collapseThreshold = 95.0,
    this.elevation = 2.0,
  });

  /// Height when fully expanded with orbiting actions.
  final double expandedHeight;

  /// Height when collapsed into compact docked bar.
  final double collapsedHeight;

  /// Distance in pixels from the central anchor to the orbiting action buttons.
  final double orbitRadius;

  /// Starting angle in radians for the orbital arc distribution.
  final double startAngle;

  /// Ending angle in radians for the orbital arc distribution.
  final double endAngle;

  /// Scroll distance required to complete orbital collapse into a linear row.
  final double collapseThreshold;

  /// Elevation in compact state.
  final double elevation;
}

/// Configuration for Style 17: Split-Screen Lateral Reveal Header.
class SplitScreenLateralRevealConfig extends AppBarMotionConfig {
  /// Creates a [SplitScreenLateralRevealConfig].
  const SplitScreenLateralRevealConfig({
    super.curve = Curves.easeInOutCubic,
    super.reducedMotionCurve = Curves.linear,
    this.expandedHeight = 190.0,
    this.collapsedHeight = kToolbarHeight,
    this.partingDistance = 110.0,
    this.revealThreshold = 85.0,
    this.elevation = 3.0,
  });

  /// Height when completely expanded.
  final double expandedHeight;

  /// Height when collapsed into compact docked bar.
  final double collapsedHeight;

  /// Maximum lateral distance each curtain half slides outward to reveal the center panel.
  final double partingDistance;

  /// Scroll offset distance over which the lateral curtain separation completes.
  final double revealThreshold;

  /// Docked header elevation shadow.
  final double elevation;
}

/// Configuration for Style 18: Magnetic Scroll-Snap Header.
class MagneticScrollSnapConfig extends AppBarMotionConfig {
  /// Creates a [MagneticScrollSnapConfig].
  const MagneticScrollSnapConfig({
    super.curve = Curves.easeOutBack,
    super.reducedMotionCurve = Curves.linear,
    this.expandedHeight = 180.0,
    this.collapsedHeight = kToolbarHeight,
    this.snapProximity = 32.0,
    this.snapStiffness = 240.0,
    this.snapDamping = 18.0,
    this.elevation = 2.0,
  });

  /// Height when expanded at top.
  final double expandedHeight;

  /// Height when collapsed.
  final double collapsedHeight;

  /// Distance threshold in pixels within which magnetic snapping activates.
  final double snapProximity;

  /// Spring stiffness constant for magnetic snap settling.
  final double snapStiffness;

  /// Spring damping coefficient for magnetic snap settling.
  final double snapDamping;

  /// Elevation in compact collapsed state.
  final double elevation;
}

/// Configuration for Style 19: Parallax Zoom Hero Header.
class ParallaxZoomHeroConfig extends AppBarMotionConfig {
  /// Creates a [ParallaxZoomHeroConfig].
  const ParallaxZoomHeroConfig({
    super.curve = Curves.easeOutQuad,
    super.reducedMotionCurve = Curves.linear,
    this.expandedHeight = 220.0,
    this.collapsedHeight = kToolbarHeight,
    this.maxOverscrollZoom = 1.45,
    this.minCollapseZoom = 0.85,
    this.focalPoint = Alignment.center,
    this.darkeningOverlayAlpha = 0.35,
    this.elevation = 3.0,
  });

  /// Maximum expanded canvas height.
  final double expandedHeight;

  /// Minimum collapsed docked toolbar height.
  final double collapsedHeight;

  /// Maximum zoom magnification factor during pull-down overscroll gestures.
  final double maxOverscrollZoom;

  /// Minimum scale factor applied to the hero visual during upward scroll collapse.
  final double minCollapseZoom;

  /// Anchor point around which zoom scaling occurs.
  final Alignment focalPoint;

  /// Maximum opacity of the progressive darkening scrim applied on collapse.
  final double darkeningOverlayAlpha;

  /// Docked header elevation.
  final double elevation;
}

/// Configuration for Style 20: Pull-Down Disclosure Canvas Header.
class PullDownDisclosureCanvasConfig extends AppBarMotionConfig {
  /// Creates a [PullDownDisclosureCanvasConfig].
  const PullDownDisclosureCanvasConfig({
    super.curve = Curves.easeOutCubic,
    super.reducedMotionCurve = Curves.linear,
    this.restingHeight = 120.0,
    this.disclosureCanvasHeight = 160.0,
    this.pullUnlockThreshold = 80.0,
    this.elevation = 4.0,
  });

  /// Normal resting height of the header.
  final double restingHeight;

  /// Height of the hidden utility disclosure canvas unlocked above the header.
  final double disclosureCanvasHeight;

  /// Downward pull overscroll distance in pixels required to latch the disclosure canvas open.
  final double pullUnlockThreshold;

  /// Header elevation shadow.
  final double elevation;
}




