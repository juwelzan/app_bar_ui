import 'package:flutter/material.dart';
import '../../app_bar_model_configuration.dart';
import 'adaptive_breakpoint_profile.dart';

/// Strongly-typed configuration for Model 17: Adaptive Breakpoint Navigation.
///
/// Automatically reforms between mobile (compact stacked), tablet (split dual-column),
/// and desktop (expansive multi-pane command bar) layouts based on ambient width breakpoints.
class AdaptiveBreakpointNavConfig extends AppBarModelConfiguration {
  /// Creates an [AdaptiveBreakpointNavConfig].
  const AdaptiveBreakpointNavConfig({
    this.title = 'Adaptive Command Center',
    this.compactSubtitle = 'Mobile Profile Active',
    this.mediumSubtitle = 'Tablet Workspace Active',
    this.expandedSubtitle = 'Enterprise Desktop Grid Active',
    this.compactHeight = 150.0,
    this.mediumHeight = 175.0,
    this.expandedHeight = 200.0,
    this.collapsedHeight = 58.0,
    this.navigationLinks = const ['Overview', 'Analytics', 'Settings', 'Audit'],
    this.onProfileChanged,
    super.safeArea = true,
    super.backgroundColor,
    super.surfaceTint,
    super.physics,
    super.elevation = 2.0,
  });

  /// Primary application title.
  final String title;

  /// Subtitle shown on compact (<600px) mobile screens.
  final String compactSubtitle;

  /// Subtitle shown on medium (600–1024px) tablet screens.
  final String mediumSubtitle;

  /// Subtitle shown on expanded (>1024px) desktop screens.
  final String expandedSubtitle;

  /// Expanded height on compact screens.
  final double compactHeight;

  /// Expanded height on medium screens.
  final double mediumHeight;

  /// Expanded height on desktop screens.
  final double expandedHeight;

  /// Collapsed pinned toolbar height.
  final double collapsedHeight;

  /// Top navigation links displayed on medium and desktop breakpoints.
  final List<String> navigationLinks;

  /// Callback when active layout profile switches.
  final ValueChanged<AdaptiveBreakpointProfile>? onProfileChanged;

  /// Resolves the effective expanded height for a given layout profile.
  double heightForProfile(AdaptiveBreakpointProfile profile) {
    switch (profile) {
      case AdaptiveBreakpointProfile.compact:
        return compactHeight;
      case AdaptiveBreakpointProfile.medium:
        return mediumHeight;
      case AdaptiveBreakpointProfile.expanded:
        return expandedHeight;
    }
  }
}
