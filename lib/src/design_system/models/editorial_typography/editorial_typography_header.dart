import 'package:flutter/material.dart';
import '../../../widgets/sliver_widget_marker.dart';
import 'editorial_typography_config.dart';

/// Model 9: Dynamic Editorial Typography Navigation Header.
///
/// A publication-grade masthead featuring dynamic typographic scaling,
/// editorial metadata pills, and an integrated reading progress line.
class EditorialTypographyHeaderWidget extends StatelessWidget with SliverWidgetMarker {
  /// Creates an [EditorialTypographyHeaderWidget].
  const EditorialTypographyHeaderWidget({
    super.key,
    this.title,
    this.leading,
    this.actions,
    this.config = const EditorialTypographyConfig(),
  });

  /// Optional custom title override.
  final Widget? title;

  /// Optional custom leading widget.
  final Widget? leading;

  /// Optional trailing action widgets.
  final List<Widget>? actions;

  /// Strongly-typed configuration for this model.
  final EditorialTypographyConfig config;

  @override
  Widget build(BuildContext context) {
    final topPadding = config.safeArea ? MediaQuery.paddingOf(context).top : 0.0;
    final totalExpanded = config.expandedHeight + topPadding;
    final totalCollapsed = config.collapsedHeight + topPadding;

    return SliverPersistentHeader(
      pinned: true,
      delegate: _EditorialTypographyDelegate(
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

class _EditorialTypographyDelegate extends SliverPersistentHeaderDelegate {
  _EditorialTypographyDelegate({
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
  final EditorialTypographyConfig config;
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

    final currentHeight = (totalExpanded - shrinkOffset).clamp(totalCollapsed, totalExpanded);
    final accent = config.accentColor ?? theme.colorScheme.primary;

    return Material(
      color: config.backgroundColor ?? theme.colorScheme.surface,
      elevation: overlapsContent || progress > 0.8 ? config.elevation : 0.0,
      surfaceTintColor: config.surfaceTint,
      child: SafeArea(
        top: false,
        bottom: false,
        child: Padding(
          padding: EdgeInsets.only(top: topPadding),
          child: SizedBox(
            height: currentHeight - topPadding,
            child: Stack(
              fit: StackFit.expand,
              children: [
                // --- EXPANDED EDITORIAL CANVAS ---
                if (progress < 0.85)
                  Positioned(
                    left: 20.0,
                    right: 20.0,
                    top: 10.0,
                    child: Opacity(
                      opacity: isReducedMotion
                          ? (progress > 0.5 ? 0.0 : 1.0)
                          : (1.0 - progress * 1.3).clamp(0.0, 1.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Metadata Row: Category pill, Issue, Date
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                if (leading != null) ...[
                                  leading!,
                                  const SizedBox(width: 8.0),
                                ],
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 3.0),
                                  decoration: BoxDecoration(
                                    color: accent.withValues(alpha: 0.12),
                                    borderRadius: BorderRadius.circular(4.0),
                                  ),
                                  child: Text(
                                    config.category.toUpperCase(),
                                    style: TextStyle(
                                      fontSize: 10.0,
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: 1.0,
                                      color: accent,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10.0),
                                Text(
                                  '${config.editionNumber} • ${config.publicationDate}',
                                  style: theme.textTheme.bodySmall!.copyWith(
                                    color: theme.colorScheme.onSurfaceVariant,
                                    fontStyle: FontStyle.italic,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                if (actions != null && actions!.isNotEmpty) ...[
                                  const SizedBox(width: 8.0),
                                  ...actions!,
                                ],
                              ],
                            ),
                          ),
                          const SizedBox(height: 12.0),

                          // Display Headline with dynamic letter spacing and weight
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            alignment: Alignment.centerLeft,
                            child: Text(
                              config.headline,
                              style: TextStyle(
                                fontFamily: config.serifFont ? 'Georgia' : null,
                                fontSize: config.expandedFontSize,
                                fontWeight: FontWeight.w900,
                                letterSpacing: -0.8,
                                height: 1.15,
                                color: theme.colorScheme.onSurface,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                // --- COLLAPSED COMPACT PINNED MASTHEAD ---
                if (progress > 0.4)
                  Positioned(
                    left: 0.0,
                    right: 0.0,
                    top: 0.0,
                    height: config.collapsedHeight,
                    child: Opacity(
                      opacity: isReducedMotion
                          ? (progress > 0.5 ? 1.0 : 0.0)
                          : ((progress - 0.4) / 0.6).clamp(0.0, 1.0),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Row(
                          children: [
                            if (leading != null) ...[
                              leading!,
                              const SizedBox(width: 8.0),
                            ],
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 2.0),
                              decoration: BoxDecoration(
                                color: accent.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(4.0),
                              ),
                              child: Text(
                                config.category.toUpperCase(),
                                style: TextStyle(
                                  fontSize: 9.0,
                                  fontWeight: FontWeight.w800,
                                  color: accent,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8.0),
                            Expanded(
                              child: title ??
                                  Text(
                                    config.headline,
                                    style: TextStyle(
                                      fontFamily: config.serifFont ? 'Georgia' : null,
                                      fontSize: config.collapsedFontSize,
                                      fontWeight: FontWeight.bold,
                                      color: theme.colorScheme.onSurface,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                            ),
                            if (actions != null && actions!.isNotEmpty)
                              ...actions!
                            else ...[
                              IconButton(
                                icon: const Icon(Icons.bookmark_border, size: 20.0),
                                onPressed: () {},
                                tooltip: 'Bookmark',
                              ),
                              IconButton(
                                icon: const Icon(Icons.share_outlined, size: 20.0),
                                onPressed: () {},
                                tooltip: 'Share',
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),

                // --- READING PROGRESS ACCENT LINE ---
                if (config.showReadingProgressBar)
                  Positioned(
                    left: 0.0,
                    right: 0.0,
                    bottom: 0.0,
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 2.5,
                      backgroundColor: Colors.transparent,
                      valueColor: AlwaysStoppedAnimation<Color>(accent),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(covariant _EditorialTypographyDelegate oldDelegate) {
    return oldDelegate.totalExpanded != totalExpanded ||
        oldDelegate.totalCollapsed != totalCollapsed ||
        oldDelegate.config != config ||
        oldDelegate.title != title ||
        oldDelegate.actions != actions ||
        oldDelegate.leading != leading ||
        oldDelegate.topPadding != topPadding;
  }
}
