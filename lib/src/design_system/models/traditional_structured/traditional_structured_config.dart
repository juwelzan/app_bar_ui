import 'package:flutter/material.dart';
import '../../app_bar_model_configuration.dart';
import 'breadcrumb_node.dart';

/// Strongly-typed configuration for Model 1: Traditional Structured Navigation.
class TraditionalStructuredConfig extends AppBarModelConfiguration {
  /// Creates a [TraditionalStructuredConfig].
  const TraditionalStructuredConfig({
    this.breadcrumbs = const [
      StructuredBreadcrumbNode(label: 'Home', icon: Icons.home),
      StructuredBreadcrumbNode(label: 'Workspace'),
      StructuredBreadcrumbNode(label: 'Project Settings'),
    ],
    this.organizationName = 'Enterprise Cloud',
    this.environment = EnvironmentBadge.production,
    this.stickyTabStrip = true,
    this.tabs = const [
      Tab(text: 'General'),
      Tab(text: 'Members'),
      Tab(text: 'Security'),
      Tab(text: 'Audit Log'),
    ],
    this.tabController,
    this.expandedHeight = 170.0,
    this.collapsedHeight = 56.0,
    super.safeArea = true,
    super.backgroundColor,
    super.surfaceTint,
    super.physics,
    super.elevation = 2.0,
  });

  /// Hierarchical breadcrumbs tree displayed in Tier 2.
  final List<StructuredBreadcrumbNode> breadcrumbs;

  /// Top organization or workspace name.
  final String organizationName;

  /// Deployment environment badge.
  final EnvironmentBadge environment;

  /// Whether Tier 3 (the tab navigation strip) remains permanently pinned.
  final bool stickyTabStrip;

  /// List of tab widgets rendered in the sticky tab tier.
  final List<Widget> tabs;

  /// Optional external tab controller.
  final TabController? tabController;

  /// Expanded height of all three tiers combined.
  final double expandedHeight;

  /// Collapsed height of the primary pinned toolbar.
  final double collapsedHeight;
}
