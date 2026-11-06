import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../widgets/sliver_widget_marker.dart';
import 'spatial_3d_flip_config.dart';

/// Model 6: 3D Spatial Perspective Flip Navigation Header.
///
/// Implements a 3D perspective rotation flipping between an expanded hero metrics
/// front face and a compact quick-actions reverse face on scroll.
class Spatial3DFlipHeaderWidget extends StatelessWidget with SliverWidgetMarker {
  /// Creates a [Spatial3DFlipHeaderWidget].
  const Spatial3DFlipHeaderWidget({
    super.key,
    this.title,
    this.leading,
    this.actions,
    this.config = const Spatial3DFlipConfig(),
  });

  /// Optional custom title override.
  final Widget? title;

  /// Optional custom leading widget.
  final Widget? leading;

  /// Optional trailing action widgets.
  final List<Widget>? actions;

  /// Strongly-typed configuration for this model.
  final Spatial3DFlipConfig config;

  @override
  Widget build(BuildContext context) {
    final topPadding = config.safeArea ? MediaQuery.paddingOf(context).top : 0.0;
    final totalExpanded = config.expandedHeight + topPadding;
    final totalCollapsed = config.collapsedHeight + topPadding;

    return SliverPersistentHeader(
      pinned: true,
      delegate: _Spatial3DFlipDelegate(
        title: title,
        leading: leading,
        actions: actions,
        config: config,
        topPadding: topPadding,
        totalExpanded: totalExpanded,
        totalCollapsed: totalCollapsed,
      ),
    );
  }
}

class _Spatial3DFlipDelegate extends SliverPersistentHeaderDelegate {
  _Spatial3DFlipDelegate({
    required this.title,
    required this.leading,
    required this.actions,
    required this.config,
    required this.topPadding,
    required this.totalExpanded,
    required this.totalCollapsed,
  });

  final Widget? title;
  final Widget? leading;
  final List<Widget>? actions;
  final Spatial3DFlipConfig config;
  final double topPadding;
  final double totalExpanded;
  final double totalCollapsed;

  @override
  double get minExtent => totalCollapsed;

  @override
  double get maxExtent => totalExpanded;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    final theme = Theme.of(context);
    final isReducedMotion = MediaQuery.disableAnimationsOf(context);
    final collapseRange = totalExpanded - totalCollapsed;
    final progress = collapseRange > 0.0 ? (shrinkOffset / collapseRange).clamp(0.0, 1.0) : 0.0;

    // Angle in radians: 0.0 -> math.pi
    final angle = isReducedMotion
        ? (progress > 0.5 ? math.pi : 0.0)
        : (progress * math.pi);

    final isFrontVisible = angle < (math.pi / 2);
    final currentHeight = (totalExpanded - shrinkOffset).clamp(totalCollapsed, totalExpanded);

    // 3D Perspective Matrix
    final matrix = Matrix4.identity()..setEntry(3, 2, config.perspective);
    if (config.flipAxis == Axis.horizontal) {
      matrix.rotateY(angle);
    } else {
      matrix.rotateX(angle);
    }

    return Material(
      color: config.backgroundColor ?? theme.colorScheme.surface,
      elevation: overlapsContent || progress > 0.8 ? config.elevation : 0.0,
      surfaceTintColor: config.surfaceTint,
      child: SafeArea(
        top: false,
        bottom: false,
        child: Padding(
          padding: EdgeInsets.only(top: topPadding),
          child: Container(
            height: currentHeight - topPadding,
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
            alignment: Alignment.center,
            child: Transform(
              alignment: Alignment.center,
              transform: matrix,
              child: isFrontVisible
                  ? _buildFrontFace(context, theme)
                  : Transform(
                      alignment: Alignment.center,
                      // Counter-rotate reverse face so content renders upright
                      transform: config.flipAxis == Axis.horizontal
                          ? (Matrix4.identity()..rotateY(math.pi))
                          : (Matrix4.identity()..rotateX(math.pi)),
                      child: _buildBackFace(context, theme),
                    ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFrontFace(BuildContext context, ThemeData theme) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14.0),
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(config.borderRadius),
        border: Border.all(
          color: theme.colorScheme.primary.withValues(alpha: 0.3),
          width: 1.2,
        ),
      ),
      child: config.frontFace ??
          LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                physics: const NeverScrollableScrollPhysics(),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          if (leading != null) ...[
                            leading!,
                            const SizedBox(width: 8.0),
                          ],
                          const Icon(Icons.account_balance_wallet_outlined, size: 20.0),
                          const SizedBox(width: 8.0),
                          Expanded(
                            child: Text(
                              config.frontTitle,
                              style: theme.textTheme.titleSmall!.copyWith(
                                fontWeight: FontWeight.bold,
                                color: theme.colorScheme.onPrimaryContainer,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          ...?actions,
                        ],
                      ),
                      if (config.frontMetricValue != null)
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.centerLeft,
                          child: Text(
                            config.frontMetricValue!,
                            style: theme.textTheme.headlineMedium!.copyWith(
                              fontWeight: FontWeight.w900,
                              color: theme.colorScheme.onPrimaryContainer,
                              letterSpacing: -0.5,
                            ),
                          ),
                        ),
                      if (config.frontMetricLabel != null)
                        Row(
                          children: [
                            Icon(Icons.trending_up, size: 16.0, color: Colors.green.shade700),
                            const SizedBox(width: 4.0),
                            Expanded(
                              child: Text(
                                config.frontMetricLabel!,
                                style: TextStyle(
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.green.shade800,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
    );
  }

  Widget _buildBackFace(BuildContext context, ThemeData theme) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(config.borderRadius),
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.6),
          width: 1.2,
        ),
      ),
      child: config.backFace ??
          Row(
            children: [
              if (leading != null) ...[
                leading!,
                const SizedBox(width: 8.0),
              ] else
                const Icon(Icons.flash_on, size: 20.0, color: Colors.amber),
              const SizedBox(width: 8.0),
              Expanded(
                child: title ??
                    Text(
                      config.backTitle,
                      style: theme.textTheme.titleMedium!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
              ),
              IconButton(
                icon: const Icon(Icons.qr_code_scanner, size: 20.0),
                onPressed: () {},
                tooltip: 'Scan',
              ),
              IconButton(
                icon: const Icon(Icons.send_outlined, size: 20.0),
                onPressed: () {},
                tooltip: 'Send',
              ),
              ...?actions,
            ],
          ),
    );
  }

  @override
  bool shouldRebuild(covariant _Spatial3DFlipDelegate oldDelegate) {
    return oldDelegate.totalExpanded != totalExpanded ||
        oldDelegate.totalCollapsed != totalCollapsed ||
        oldDelegate.config != config ||
        oldDelegate.title != title ||
        oldDelegate.actions != actions ||
        oldDelegate.leading != leading ||
        oldDelegate.topPadding != topPadding;
  }
}
