/// Layout profile for responsive breakpoints in [AdaptiveBreakpointNavConfig].
enum AdaptiveBreakpointProfile {
  /// Mobile portrait / narrow screens (< 600px).
  compact,

  /// Tablet / foldable unfolded screens (600px – 1024px).
  medium,

  /// Desktop / widescreen displays (> 1024px).
  expanded;

  /// Resolves breakpoint from available width constraints.
  static AdaptiveBreakpointProfile fromWidth(double width) {
    if (width < 600.0) return AdaptiveBreakpointProfile.compact;
    if (width <= 1024.0) return AdaptiveBreakpointProfile.medium;
    return AdaptiveBreakpointProfile.expanded;
  }
}
