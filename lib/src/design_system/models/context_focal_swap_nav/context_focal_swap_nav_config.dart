import 'package:flutter/material.dart';
import '../../app_bar_model_configuration.dart';
import 'focal_domain_context.dart';

/// Strongly-typed configuration for Model 18: Context Focal Swap Navigation.
///
/// Features dynamic swapping between multiple distinct operational domains
/// (e.g. Finance, DevOps, Security). Selecting a domain cross-fades the primary metric,
/// action controls, and thematic styling. On scroll, collapses into a consolidated pinned
/// toolbar showing the active domain badge and telemetry.
class ContextFocalSwapNavConfig extends AppBarModelConfiguration {
  /// Creates a [ContextFocalSwapNavConfig].
  const ContextFocalSwapNavConfig({
    this.domains = const [
      FocalDomainContext(
        name: 'Financial Core',
        primaryMetric: '\$1,248,500',
        metricLabel: '+18.4% Net Run-Rate',
        icon: Icons.account_balance_wallet,
        accentColor: Color(0xFF10B981),
        statusBadge: 'HEALTHY',
      ),
      FocalDomainContext(
        name: 'Infrastructure DevOps',
        primaryMetric: '99.992%',
        metricLabel: 'Global SLA 30-Day Mean',
        icon: Icons.cloud_done,
        accentColor: Color(0xFF0284C7),
        statusBadge: 'OPTIMAL',
      ),
      FocalDomainContext(
        name: 'Cyber Security',
        primaryMetric: '0 Incidents',
        metricLabel: 'Zero-Day Vulnerabilities',
        icon: Icons.shield,
        accentColor: Color(0xFF8B5CF6),
        statusBadge: 'SHIELDED',
      ),
    ],
    this.activeDomainIndex = 0,
    this.expandedHeight = 210.0,
    this.collapsedHeight = 60.0,
    this.onDomainSwapped,
    super.safeArea = true,
    super.backgroundColor,
    super.surfaceTint,
    super.physics,
    super.elevation = 2.0,
  });

  /// Available domain contexts to swap between.
  final List<FocalDomainContext> domains;

  /// Index of the currently active focal domain.
  final int activeDomainIndex;

  /// Total expanded height.
  final double expandedHeight;

  /// Collapsed pinned toolbar height.
  final double collapsedHeight;

  /// Callback when a domain is swapped.
  final ValueChanged<int>? onDomainSwapped;
}

