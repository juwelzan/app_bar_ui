import 'package:flutter/material.dart';
import '../../../widgets/sliver_widget_marker.dart';
import 'developer_custom_canvas_config.dart';

/// Model 20: Developer Custom Canvas Navigation Header.
///
/// Blank-slate developer canvas giving complete unconstrained access to custom header rendering.
/// Renders an architectural blueprint inspection grid displaying real-time coordinate readouts
/// when no custom builder is passed.
class DeveloperCustomCanvasHeaderWidget extends StatelessWidget with SliverWidgetMarker {
  /// Creates a [DeveloperCustomCanvasHeaderWidget].
  const DeveloperCustomCanvasHeaderWidget({
    super.key,
    this.title,
    this.leading,
    this.actions,
    this.config = const DeveloperCustomCanvasConfig(),
  });

  /// Optional custom title override.
  final Widget? title;

  /// Optional custom leading widget.
  final Widget? leading;

  /// Optional trailing action widgets.
  final List<Widget>? actions;

  /// Strongly-typed configuration for this model.
  final DeveloperCustomCanvasConfig config;

  @override
  Widget build(BuildContext context) {
    final topPadding = config.safeArea ? MediaQuery.paddingOf(context).top : 0.0;
    final totalExpanded = config.expandedHeight + topPadding;
    final totalCollapsed = config.collapsedHeight + topPadding;

    return SliverPersistentHeader(
      pinned: true,
      delegate: _DeveloperCustomCanvasDelegate(
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

class _DeveloperCustomCanvasDelegate extends SliverPersistentHeaderDelegate {
  _DeveloperCustomCanvasDelegate({
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
  final DeveloperCustomCanvasConfig config;
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

    // If custom builder supplied, delegate completely to it
    if (config.builder != null) {
      return SizedBox(
        height: currentHeight,
        child: config.builder!(context, shrinkOffset, progress),
      );
    }

    // Default: Blueprint Developer Inspection Grid Canvas
    final gridColor = config.gridColor ?? theme.colorScheme.primary.withValues(alpha: 0.15);

    return Material(
      color: config.backgroundColor ?? const Color(0xFF0F172A),
      elevation: overlapsContent || progress > 0.8 ? config.elevation : 0.0,
      surfaceTintColor: config.surfaceTint,
      child: SafeArea(
        top: false,
        bottom: false,
        child: Padding(
          padding: EdgeInsets.only(top: topPadding),
          child: SizedBox(
            height: currentHeight - topPadding,
            child: ClipRect(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // Blueprint Grid Pattern
                  if (config.showBlueprintGrid)
                    CustomPaint(
                      painter: _BlueprintGridPainter(gridColor: gridColor),
                    ),

                  // --- EXPANDED BLUEPRINT CANVAS ---
                  if (progress < 0.88)
                    Opacity(
                      opacity: isReducedMotion
                          ? (progress > 0.5 ? 0.0 : 1.0)
                          : (1.0 - progress * 1.3).clamp(0.0, 1.0),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                if (leading != null) ...[
                                  leading!,
                                  const SizedBox(width: 8.0),
                                ],
                                const Icon(Icons.architecture, size: 20.0, color: Colors.cyanAccent),
                                const SizedBox(width: 8.0),
                                Expanded(
                                  child: Text(
                                    config.canvasName,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15.0,
                                      fontFamily: 'monospace',
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 3.0),
                                  decoration: BoxDecoration(
                                    color: Colors.cyan.withValues(alpha: 0.2),
                                    borderRadius: BorderRadius.circular(4.0),
                                    border: Border.all(color: Colors.cyanAccent.withValues(alpha: 0.4)),
                                  ),
                                  child: const Text(
                                    'MODEL 20',
                                    style: TextStyle(
                                      fontSize: 10.0,
                                      fontWeight: FontWeight.w900,
                                      color: Colors.cyanAccent,
                                      fontFamily: 'monospace',
                                    ),
                                  ),
                                ),
                                ...?actions,
                              ],
                            ),
                            const Spacer(),

                            // Real-time Coordinate Telemetry Readout
                            Container(
                              padding: const EdgeInsets.all(10.0),
                              decoration: BoxDecoration(
                                color: Colors.black45,
                                borderRadius: BorderRadius.circular(8.0),
                                border: Border.all(color: Colors.white12),
                              ),
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  'shrink: ${shrinkOffset.toStringAsFixed(1)}px | prog: ${(progress * 100).toStringAsFixed(1)}% | h: ${currentHeight.toStringAsFixed(1)}px',
                                  style: const TextStyle(
                                    fontFamily: 'monospace',
                                    fontSize: 11.0,
                                    color: Colors.greenAccent,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 8.0),
                          ],
                        ),
                      ),
                    ),

                  // --- COLLAPSED COMPACT PINNED TOOLBAR ---
                  if (progress > 0.35)
                    Positioned(
                      left: 0.0,
                      right: 0.0,
                      top: 0.0,
                      height: config.collapsedHeight,
                      child: Opacity(
                        opacity: isReducedMotion
                            ? (progress > 0.5 ? 1.0 : 0.0)
                            : ((progress - 0.35) / 0.65).clamp(0.0, 1.0),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Row(
                            children: [
                              if (leading != null) ...[
                                leading!,
                                const SizedBox(width: 8.0),
                              ],
                              const Icon(Icons.architecture, size: 18.0, color: Colors.cyanAccent),
                              const SizedBox(width: 8.0),
                              Expanded(
                                child: title ??
                                    Text(
                                      config.canvasName,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'monospace',
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                              ),
                              Text(
                                '${(progress * 100).round()}%',
                                style: const TextStyle(
                                  color: Colors.cyanAccent,
                                  fontFamily: 'monospace',
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              ...?actions,
                            ],
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(covariant _DeveloperCustomCanvasDelegate oldDelegate) {
    return oldDelegate.totalExpanded != totalExpanded ||
        oldDelegate.totalCollapsed != totalCollapsed ||
        oldDelegate.config != config ||
        oldDelegate.title != title ||
        oldDelegate.actions != actions ||
        oldDelegate.leading != leading ||
        oldDelegate.topPadding != topPadding;
  }
}

class _BlueprintGridPainter extends CustomPainter {
  const _BlueprintGridPainter({required this.gridColor});

  final Color gridColor;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = gridColor
      ..strokeWidth = 0.5;

    const step = 20.0;
    for (double x = 0; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant _BlueprintGridPainter oldPainter) {
    return oldPainter.gridColor != gridColor;
  }
}
