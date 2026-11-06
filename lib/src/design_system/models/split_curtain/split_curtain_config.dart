import 'package:flutter/material.dart';
import '../../app_bar_model_configuration.dart';

/// Strongly-typed configuration for Model 5: Multi-Panel Split Curtain Navigation.
///
/// Features two lateral panels (brand/identity on the left, controls/actions on the right)
/// that start separated by a central gap and translate horizontally to fuse into
/// a unified compact toolbar upon upward scrolling.
class MultiPanelSplitCurtainConfig extends AppBarModelConfiguration {
  /// Creates a [MultiPanelSplitCurtainConfig].
  const MultiPanelSplitCurtainConfig({
    this.leftPanelTitle = 'Enterprise Cloud',
    this.leftPanelSubtitle = 'Multi-Tenant Cluster',
    this.leftIcon = Icons.splitscreen_outlined,
    this.leftCustomPanel,
    this.rightCustomPanel,
    this.actionButtons = const [],
    this.splitGap = 36.0,
    this.horizontalMargin = 16.0,
    this.expandedHeight = 180.0,
    this.collapsedHeight = 58.0,
    this.curtainCurve = Curves.easeOutCubic,
    super.safeArea = true,
    super.backgroundColor,
    super.surfaceTint,
    super.physics,
    super.elevation = 3.0,
  });

  /// Primary headline text on the left curtain panel.
  final String leftPanelTitle;

  /// Secondary subtitle text on the left curtain panel.
  final String? leftPanelSubtitle;

  /// Icon rendered on the left curtain panel.
  final IconData? leftIcon;

  /// Optional custom widget tree replacing the built-in left panel.
  final Widget? leftCustomPanel;

  /// Optional custom widget tree replacing the built-in right panel.
  final Widget? rightCustomPanel;

  /// Action widgets rendered inside the right curtain panel.
  final List<Widget> actionButtons;

  /// Gap distance in logical pixels separating the two panels in resting expanded state.
  final double splitGap;

  /// Horizontal padding from the viewport edges.
  final double horizontalMargin;

  /// Expanded height of both curtain panels combined.
  final double expandedHeight;

  /// Collapsed height when fused into the compact pinned toolbar.
  final double collapsedHeight;

  /// Mathematical easing curve governing horizontal convergence.
  final Curve curtainCurve;
}
