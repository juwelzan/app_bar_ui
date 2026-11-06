import 'package:flutter/material.dart';

/// Single context domain in [ContextFocalSwapNavConfig].
class FocalDomainContext {
  /// Creates a [FocalDomainContext].
  const FocalDomainContext({
    required this.name,
    required this.primaryMetric,
    required this.metricLabel,
    required this.icon,
    this.accentColor,
    this.statusBadge,
  });

  /// Name of the domain (e.g. 'Financials', 'DevOps Core', 'Security Compliance').
  final String name;

  /// Primary prominent metric displayed (e.g. '\$482.5K', '99.99%', '0 Threats').
  final String primaryMetric;

  /// Secondary descriptive label for the metric (e.g. 'Monthly Inflow', 'Uptime', 'Clean Audit').
  final String metricLabel;

  /// Domain icon.
  final IconData icon;

  /// Custom accent color for this domain.
  final Color? accentColor;

  /// Optional status badge tag (e.g. 'PROD', 'AUDITED').
  final String? statusBadge;
}

