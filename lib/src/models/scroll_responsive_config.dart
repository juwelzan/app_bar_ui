import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

/// Defines how the icon transitions are driven.
enum ScrollTransitionType {
  /// Transition progress interpolates smoothly based on the current scroll offset
  /// between the configured start and end thresholds.
  ///
  /// This provides continuous, real-time gesture feedback matching the finger movement.
  scrollProgress,

  /// Transition is triggered with an [AnimationController] when the scroll offset
  /// crosses the configured threshold, animating forward or reverse.
  thresholdTriggered,
}

/// Thresholds for scroll-based triggers and transitions.
class ScrollThresholdConfig {
  /// Creates a configuration for scroll thresholds.
  const ScrollThresholdConfig({
    this.leadingStartOffset = 20.0,
    this.leadingEndOffset = 80.0,
    this.trailingStartOffset = 20.0,
    this.trailingEndOffset = 80.0,
    this.statusBarHideOffset = 100.0,
    this.statusBarShowOffset = 50.0,
  }) : assert(
         leadingEndOffset >= leadingStartOffset,
         'leadingEndOffset ($leadingEndOffset) must be >= leadingStartOffset ($leadingStartOffset)',
       ),
       assert(
         trailingEndOffset >= trailingStartOffset,
         'trailingEndOffset ($trailingEndOffset) must be >= trailingStartOffset ($trailingStartOffset)',
       ),
       assert(
         statusBarHideOffset >= statusBarShowOffset,
         'statusBarHideOffset ($statusBarHideOffset) must be >= statusBarShowOffset ($statusBarShowOffset)',
       );

  /// Scroll offset at which the left icon begins transitioning.
  final double leadingStartOffset;

  /// Scroll offset at which the left icon finishes transitioning.
  final double leadingEndOffset;

  /// Scroll offset at which the right icon begins transitioning.
  final double trailingStartOffset;

  /// Scroll offset at which the right icon finishes transitioning.
  final double trailingEndOffset;

  /// Scroll offset at which the native status bar is hidden when scrolling down.
  final double statusBarHideOffset;

  /// Scroll offset at which the native status bar is restored when scrolling back up.
  ///
  /// Using a value lower than [statusBarHideOffset] creates hysteresis,
  /// preventing status bar flickering around the threshold boundary.
  final double statusBarShowOffset;

  /// Creates a copy of this configuration with the given fields replaced.
  ScrollThresholdConfig copyWith({
    double? leadingStartOffset,
    double? leadingEndOffset,
    double? trailingStartOffset,
    double? trailingEndOffset,
    double? statusBarHideOffset,
    double? statusBarShowOffset,
  }) {
    return ScrollThresholdConfig(
      leadingStartOffset: leadingStartOffset ?? this.leadingStartOffset,
      leadingEndOffset: leadingEndOffset ?? this.leadingEndOffset,
      trailingStartOffset: trailingStartOffset ?? this.trailingStartOffset,
      trailingEndOffset: trailingEndOffset ?? this.trailingEndOffset,
      statusBarHideOffset: statusBarHideOffset ?? this.statusBarHideOffset,
      statusBarShowOffset: statusBarShowOffset ?? this.statusBarShowOffset,
    );
  }
}

/// Animation parameters for icon transitions.
class ScrollAnimationConfig {
  /// Creates an animation configuration.
  const ScrollAnimationConfig({
    this.transitionType = ScrollTransitionType.scrollProgress,
    this.duration = const Duration(milliseconds: 250),
    this.curve = Curves.easeInOut,
    this.reverseCurve,
    this.minScale = 0.75,
    this.maxScale = 1.0,
    this.slideOffset = const Offset(0.0, 0.15),
    this.enableFade = true,
    this.enableScale = true,
    this.enableSlide = true,
    this.enableReverseAnimation = true,
  });

  /// Mode of transition (scroll progress continuous mapping or threshold triggered).
  final ScrollTransitionType transitionType;

  /// Duration for triggered animations.
  final Duration duration;

  /// Easing curve for forward transitions.
  final Curve curve;

  /// Easing curve for reverse transitions. Defaults to [curve] if null.
  final Curve? reverseCurve;

  /// Minimum scale applied to the transitioning icon (at 0 progress).
  final double minScale;

  /// Maximum scale applied to the transitioning icon (at 1.0 progress).
  final double maxScale;

  /// Relative vertical/horizontal slide offset applied during transition.
  final Offset slideOffset;

  /// Whether fade transition is enabled.
  final bool enableFade;

  /// Whether scale transition is enabled.
  final bool enableScale;

  /// Whether slide transition is enabled.
  final bool enableSlide;

  /// Whether reverse transitions are enabled when scrolling back up.
  final bool enableReverseAnimation;

  /// Returns the effective reverse curve.
  Curve get effectiveReverseCurve => reverseCurve ?? curve;

  /// Creates a copy of this configuration with the given fields replaced.
  ScrollAnimationConfig copyWith({
    ScrollTransitionType? transitionType,
    Duration? duration,
    Curve? curve,
    Curve? reverseCurve,
    double? minScale,
    double? maxScale,
    Offset? slideOffset,
    bool? enableFade,
    bool? enableScale,
    bool? enableSlide,
    bool? enableReverseAnimation,
  }) {
    return ScrollAnimationConfig(
      transitionType: transitionType ?? this.transitionType,
      duration: duration ?? this.duration,
      curve: curve ?? this.curve,
      reverseCurve: reverseCurve ?? this.reverseCurve,
      minScale: minScale ?? this.minScale,
      maxScale: maxScale ?? this.maxScale,
      slideOffset: slideOffset ?? this.slideOffset,
      enableFade: enableFade ?? this.enableFade,
      enableScale: enableScale ?? this.enableScale,
      enableSlide: enableSlide ?? this.enableSlide,
      enableReverseAnimation:
          enableReverseAnimation ?? this.enableReverseAnimation,
    );
  }
}

/// Configuration for the mobile System Status Bar.
class StatusBarConfig {
  /// Creates a configuration for status bar responsiveness.
  const StatusBarConfig({
    this.enabled = true,
    this.hideOnScroll = true,
    this.preventContentJump = true,
    this.hiddenUiMode = SystemUiMode.manual,
    this.hiddenOverlays = const [SystemUiOverlay.bottom],
    this.visibleUiMode = SystemUiMode.edgeToEdge,
    this.visibleOverlays = SystemUiOverlay.values,
    this.visibleOverlayStyle,
    this.hiddenOverlayStyle,
    this.restoreOnDispose = true,
    this.restoreOnRouteTransition = true,
    this.androidHiddenOverlayStyle,
    this.androidVisibleOverlayStyle,
    this.iosHiddenOverlayStyle,
    this.iosVisibleOverlayStyle,
  });

  /// Whether status bar management is enabled.
  final bool enabled;

  /// Whether to hide the status bar when scrolling down.
  final bool hideOnScroll;

  /// Whether to prevent sudden UI jumps when the status bar hides.
  ///
  /// When true, maintains safe top insets so content does not snap up or down.
  final bool preventContentJump;

  /// System UI mode applied when status bar is hidden.
  final SystemUiMode hiddenUiMode;

  /// System UI overlays preserved when status bar is hidden.
  /// Defaults to keeping [SystemUiOverlay.bottom] to preserve navigation controls.
  final List<SystemUiOverlay> hiddenOverlays;

  /// System UI mode applied when status bar is visible.
  final SystemUiMode visibleUiMode;

  /// System UI overlays restored when status bar is visible.
  final List<SystemUiOverlay>? visibleOverlays;

  /// Generic style applied when status bar is visible (fallback for platforms without specific styles).
  final SystemUiOverlayStyle? visibleOverlayStyle;

  /// Generic style applied when status bar is hidden (fallback for platforms without specific styles).
  final SystemUiOverlayStyle? hiddenOverlayStyle;

  /// Whether to restore initial status bar configuration when widget is disposed.
  final bool restoreOnDispose;

  /// Whether to restore the status bar when navigating to a new route and reapply on return.
  final bool restoreOnRouteTransition;

  /// Android-specific overlay style when status bar is hidden.
  final SystemUiOverlayStyle? androidHiddenOverlayStyle;

  /// Android-specific overlay style when status bar is visible.
  final SystemUiOverlayStyle? androidVisibleOverlayStyle;

  /// iOS-specific overlay style when status bar is hidden.
  final SystemUiOverlayStyle? iosHiddenOverlayStyle;

  /// iOS-specific overlay style when status bar is visible.
  final SystemUiOverlayStyle? iosVisibleOverlayStyle;

  /// Resolves the effective overlay style when status bar is hidden for the target [platform].
  SystemUiOverlayStyle? resolveHiddenOverlayStyle(TargetPlatform platform) {
    if (platform == TargetPlatform.android &&
        androidHiddenOverlayStyle != null) {
      return androidHiddenOverlayStyle;
    }
    if (platform == TargetPlatform.iOS && iosHiddenOverlayStyle != null) {
      return iosHiddenOverlayStyle;
    }
    return hiddenOverlayStyle;
  }

  /// Resolves the effective overlay style when status bar is visible for the target [platform].
  SystemUiOverlayStyle? resolveVisibleOverlayStyle(TargetPlatform platform) {
    if (platform == TargetPlatform.android &&
        androidVisibleOverlayStyle != null) {
      return androidVisibleOverlayStyle;
    }
    if (platform == TargetPlatform.iOS && iosVisibleOverlayStyle != null) {
      return iosVisibleOverlayStyle;
    }
    return visibleOverlayStyle;
  }

  /// Creates a copy of this configuration with the given fields replaced.
  StatusBarConfig copyWith({
    bool? enabled,
    bool? hideOnScroll,
    bool? preventContentJump,
    SystemUiMode? hiddenUiMode,
    List<SystemUiOverlay>? hiddenOverlays,
    SystemUiMode? visibleUiMode,
    List<SystemUiOverlay>? visibleOverlays,
    SystemUiOverlayStyle? visibleOverlayStyle,
    SystemUiOverlayStyle? hiddenOverlayStyle,
    bool? restoreOnDispose,
    bool? restoreOnRouteTransition,
    SystemUiOverlayStyle? androidHiddenOverlayStyle,
    SystemUiOverlayStyle? androidVisibleOverlayStyle,
    SystemUiOverlayStyle? iosHiddenOverlayStyle,
    SystemUiOverlayStyle? iosVisibleOverlayStyle,
  }) {
    return StatusBarConfig(
      enabled: enabled ?? this.enabled,
      hideOnScroll: hideOnScroll ?? this.hideOnScroll,
      preventContentJump: preventContentJump ?? this.preventContentJump,
      hiddenUiMode: hiddenUiMode ?? this.hiddenUiMode,
      hiddenOverlays: hiddenOverlays ?? this.hiddenOverlays,
      visibleUiMode: visibleUiMode ?? this.visibleUiMode,
      visibleOverlays: visibleOverlays ?? this.visibleOverlays,
      visibleOverlayStyle: visibleOverlayStyle ?? this.visibleOverlayStyle,
      hiddenOverlayStyle: hiddenOverlayStyle ?? this.hiddenOverlayStyle,
      restoreOnDispose: restoreOnDispose ?? this.restoreOnDispose,
      restoreOnRouteTransition:
          restoreOnRouteTransition ?? this.restoreOnRouteTransition,
      androidHiddenOverlayStyle:
          androidHiddenOverlayStyle ?? this.androidHiddenOverlayStyle,
      androidVisibleOverlayStyle:
          androidVisibleOverlayStyle ?? this.androidVisibleOverlayStyle,
      iosHiddenOverlayStyle:
          iosHiddenOverlayStyle ?? this.iosHiddenOverlayStyle,
      iosVisibleOverlayStyle:
          iosVisibleOverlayStyle ?? this.iosVisibleOverlayStyle,
    );
  }
}

/// Configuration for the pinned side actions.
class PinnedActionsConfig {
  /// Creates a configuration for pinned action icons.
  const PinnedActionsConfig({
    this.pinned = true,
    this.transparentBackground = true,
    this.height = 56.0,
    this.padding = const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
    this.touchTargetSize = const Size(48.0, 48.0),
    this.safeArea = true,
  });

  /// Whether the side actions should remain pinned on screen.
  final bool pinned;

  /// Whether the action container has a transparent background with no card,
  /// border, shadow, blur, or elevation.
  final bool transparentBackground;

  /// Overall height of the pinned action bar row.
  final double height;

  /// Outer padding for the pinned action bar row.
  final EdgeInsetsGeometry padding;

  /// Size of the accessible touch target for each action icon.
  final Size touchTargetSize;

  /// Whether to position pinned actions within the device's top SafeArea.
  final bool safeArea;

  /// Creates a copy of this configuration with the given fields replaced.
  PinnedActionsConfig copyWith({
    bool? pinned,
    bool? transparentBackground,
    double? height,
    EdgeInsetsGeometry? padding,
    Size? touchTargetSize,
    bool? safeArea,
  }) {
    return PinnedActionsConfig(
      pinned: pinned ?? this.pinned,
      transparentBackground:
          transparentBackground ?? this.transparentBackground,
      height: height ?? this.height,
      padding: padding ?? this.padding,
      touchTargetSize: touchTargetSize ?? this.touchTargetSize,
      safeArea: safeArea ?? this.safeArea,
    );
  }
}

/// Real-time details about the current scroll responsive progress.
class ScrollProgressDetails {
  /// Creates a scroll progress details object.
  const ScrollProgressDetails({
    required this.offset,
    required this.leadingProgress,
    required this.trailingProgress,
    required this.isStatusBarHidden,
    required this.scrollDirection,
  });

  /// Current scroll offset in logical pixels.
  final double offset;

  /// Transition progress of the leading (left) action, from 0.0 to 1.0.
  final double leadingProgress;

  /// Transition progress of the trailing (right) action, from 0.0 to 1.0.
  final double trailingProgress;

  /// Whether the native system status bar is currently hidden.
  final bool isStatusBarHidden;

  /// Current scroll direction.
  final ScrollDirection scrollDirection;
}

/// Master configuration for [ScrollResponsiveScaffold].
class ScrollResponsiveConfig {
  /// Creates a comprehensive scroll-responsive configuration.
  const ScrollResponsiveConfig({
    this.pinSideActions = true,
    this.transparentActions = true,
    this.hideStatusBarOnScroll = true,
    this.enableReverseAnimation = true,
    this.thresholds = const ScrollThresholdConfig(),
    this.animation = const ScrollAnimationConfig(),
    this.statusBar = const StatusBarConfig(),
    this.pinnedActions = const PinnedActionsConfig(),
  });

  /// Convenience flag to pin side actions.
  final bool pinSideActions;

  /// Convenience flag to enforce transparent action backgrounds.
  final bool transparentActions;

  /// Convenience flag to enable scroll-responsive status bar hiding.
  final bool hideStatusBarOnScroll;

  /// Convenience flag to enable reverse animations on scroll up.
  final bool enableReverseAnimation;

  /// Threshold configurations.
  final ScrollThresholdConfig thresholds;

  /// Animation configurations.
  final ScrollAnimationConfig animation;

  /// System Status Bar configurations.
  final StatusBarConfig statusBar;

  /// Pinned actions configurations.
  final PinnedActionsConfig pinnedActions;

  /// Returns effective [PinnedActionsConfig] with convenience flags reconciled.
  PinnedActionsConfig get effectivePinnedActions => pinnedActions.copyWith(
    pinned: pinSideActions,
    transparentBackground: transparentActions,
  );

  /// Returns effective [StatusBarConfig] with convenience flags reconciled.
  StatusBarConfig get effectiveStatusBar =>
      statusBar.copyWith(hideOnScroll: hideStatusBarOnScroll);

  /// Returns effective [ScrollAnimationConfig] with convenience flags reconciled.
  ScrollAnimationConfig get effectiveAnimation =>
      animation.copyWith(enableReverseAnimation: enableReverseAnimation);

  /// Creates a copy of this configuration with the given fields replaced.
  ScrollResponsiveConfig copyWith({
    bool? pinSideActions,
    bool? transparentActions,
    bool? hideStatusBarOnScroll,
    bool? enableReverseAnimation,
    ScrollThresholdConfig? thresholds,
    ScrollAnimationConfig? animation,
    StatusBarConfig? statusBar,
    PinnedActionsConfig? pinnedActions,
  }) {
    return ScrollResponsiveConfig(
      pinSideActions: pinSideActions ?? this.pinSideActions,
      transparentActions: transparentActions ?? this.transparentActions,
      hideStatusBarOnScroll:
          hideStatusBarOnScroll ?? this.hideStatusBarOnScroll,
      enableReverseAnimation:
          enableReverseAnimation ?? this.enableReverseAnimation,
      thresholds: thresholds ?? this.thresholds,
      animation: animation ?? this.animation,
      statusBar: statusBar ?? this.statusBar,
      pinnedActions: pinnedActions ?? this.pinnedActions,
    );
  }
}
