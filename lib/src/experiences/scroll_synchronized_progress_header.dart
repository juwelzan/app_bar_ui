import 'package:flutter/material.dart';
import 'experience_configs.dart';

/// Style 12: Scroll-Synchronized Progress Header
///
/// Header with an integrated circular and linear progress indicator
/// synchronized directly with scroll metrics and content consumption.
class ScrollSynchronizedProgressHeaderWidget extends StatelessWidget {
  /// Creates a [ScrollSynchronizedProgressHeaderWidget].
  const ScrollSynchronizedProgressHeaderWidget({
    super.key,
    required this.title,
    this.subtitle,
    this.leading,
    this.actions,
    this.backgroundColor,
    this.progressColor,
    this.scrollProgress = 0.0,
    this.config = const ScrollSynchronizedProgressConfig(),
    this.safeArea = true,
  });

  /// Primary title.
  final Widget title;

  /// Optional subtitle.
  final Widget? subtitle;

  /// Optional leading widget.
  final Widget? leading;

  /// Optional trailing actions.
  final List<Widget>? actions;

  /// Background color of the header.
  final Color? backgroundColor;

  /// Color of the reading progress indicator.
  final Color? progressColor;

  /// Current normalized scroll progress ratio ($0.0 \to 1.0$).
  final double scrollProgress;

  /// Geometry and progress configuration.
  final ScrollSynchronizedProgressConfig config;

  /// Whether to incorporate safe area top insets.
  final bool safeArea;

  @override
  Widget build(BuildContext context) {
    final topPadding = safeArea ? MediaQuery.paddingOf(context).top : 0.0;
    final totalExpanded = config.expandedHeight + topPadding;
    final totalCollapsed = config.collapsedHeight + topPadding;

    return SliverPersistentHeader(
      pinned: true,
      delegate: _ScrollSynchronizedProgressDelegate(
        title: title,
        subtitle: subtitle,
        leading: leading,
        actions: actions,
        backgroundColor: backgroundColor,
        progressColor: progressColor,
        scrollProgress: scrollProgress,
        topPadding: topPadding,
        totalExpanded: totalExpanded,
        totalCollapsed: totalCollapsed,
        config: config,
      ),
    );
  }
}

class _ScrollSynchronizedProgressDelegate
    extends SliverPersistentHeaderDelegate {
  _ScrollSynchronizedProgressDelegate({
    required this.title,
    required this.subtitle,
    required this.leading,
    required this.actions,
    required this.backgroundColor,
    required this.progressColor,
    required this.scrollProgress,
    required this.topPadding,
    required this.totalExpanded,
    required this.totalCollapsed,
    required this.config,
  });

  final Widget title;
  final Widget? subtitle;
  final Widget? leading;
  final List<Widget>? actions;
  final Color? backgroundColor;
  final Color? progressColor;
  final double scrollProgress;
  final double topPadding;
  final double totalExpanded;
  final double totalCollapsed;
  final ScrollSynchronizedProgressConfig config;

  @override
  double get minExtent => totalCollapsed;

  @override
  double get maxExtent => totalExpanded;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    final theme = Theme.of(context);
    final delta = maxExtent - minExtent;
    final collapseRatio = delta > 0 ? (shrinkOffset / delta).clamp(0.0, 1.0) : 0.0;
    final curve = config.resolveCurve(context);
    final t = curve.transform(collapseRatio);

    // Compute active progress: either externally provided scrollProgress or collapseRatio
    final progressValue = scrollProgress > 0.0 ? scrollProgress : collapseRatio;
    final percent = (progressValue * 100).toInt().clamp(0, 100);

    final resolvedBgColor = backgroundColor ?? theme.colorScheme.surface;
    final resolvedProgressColor = progressColor ?? theme.colorScheme.primary;

    return SizedBox.expand(
      child: Material(
        elevation: shrinkOffset > 5.0 ? config.elevation : 0.0,
        color: resolvedBgColor,
        child: Padding(
          padding: EdgeInsets.only(top: topPadding),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Expanded state layout
              if (t < 0.95)
                Positioned(
                  left: 16.0,
                  right: 16.0,
                  bottom: 12.0,
                  child: Opacity(
                    opacity: (1.0 - t * 1.2).clamp(0.0, 1.0),
                    child: Row(
                      children: [
                        if (leading != null) ...[
                          leading!,
                          const SizedBox(width: 12.0),
                        ],
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              DefaultTextStyle(
                                style: theme.textTheme.headlineSmall!.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: theme.colorScheme.onSurface,
                                ),
                                child: title,
                              ),
                              if (subtitle != null) ...[
                                const SizedBox(height: 4.0),
                                DefaultTextStyle(
                                  style: theme.textTheme.bodyMedium!.copyWith(
                                    color: theme.colorScheme.onSurfaceVariant,
                                  ),
                                  child: subtitle!,
                                ),
                              ],
                            ],
                          ),
                        ),
                        // Circular progress ring wrapping reading percentage
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            SizedBox(
                              width: 44.0,
                              height: 44.0,
                              child: CircularProgressIndicator(
                                value: progressValue,
                                strokeWidth: config.progressStrokeWidth,
                                color: resolvedProgressColor,
                                backgroundColor: theme.colorScheme.surfaceContainerHighest,
                              ),
                            ),
                            Text(
                              '$percent%',
                              style: theme.textTheme.labelSmall!.copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: 10.0,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

              // Collapsed state navigation toolbar
              if (t > 0.2)
                Positioned(
                  top: 0.0,
                  left: 0.0,
                  right: 0.0,
                  height: config.collapsedHeight,
                  child: Opacity(
                    opacity: ((t - 0.2) / 0.8).clamp(0.0, 1.0),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        children: [
                          ?leading,
                          const SizedBox(width: 8.0),
                          Expanded(
                            child: DefaultTextStyle(
                              style: theme.textTheme.titleMedium!.copyWith(
                                fontWeight: FontWeight.bold,
                                overflow: TextOverflow.ellipsis,
                              ),
                              child: title,
                            ),
                          ),
                          if (config.showPercentageBadge)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8.0,
                                vertical: 2.0,
                              ),
                              decoration: BoxDecoration(
                                color: resolvedProgressColor.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              child: Text(
                                '$percent%',
                                style: TextStyle(
                                  color: resolvedProgressColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 11.0,
                                ),
                              ),
                            ),
                          ...?actions,
                        ],
                      ),
                    ),
                  ),
                ),

              // Bottom edge horizontal linear progress track
              Positioned(
                bottom: 0.0,
                left: 0.0,
                right: 0.0,
                height: config.progressStrokeWidth,
                child: LinearProgressIndicator(
                  value: progressValue,
                  color: resolvedProgressColor,
                  backgroundColor: Colors.transparent,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(
    covariant _ScrollSynchronizedProgressDelegate oldDelegate,
  ) {
    return oldDelegate.title != title ||
        oldDelegate.subtitle != subtitle ||
        oldDelegate.leading != leading ||
        oldDelegate.actions != actions ||
        oldDelegate.backgroundColor != backgroundColor ||
        oldDelegate.progressColor != progressColor ||
        oldDelegate.scrollProgress != scrollProgress ||
        oldDelegate.topPadding != topPadding ||
        oldDelegate.totalExpanded != totalExpanded ||
        oldDelegate.totalCollapsed != totalCollapsed ||
        oldDelegate.config != config;
  }
}
