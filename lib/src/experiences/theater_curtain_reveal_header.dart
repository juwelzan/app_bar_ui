import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'experience_configs.dart';

/// Style 33: Lateral Theater Curtain Reveal Header.
///
/// Features authentic dual-panel draped theater curtains with realistic fabric
/// pleats and shading. As the user scrolls, the curtains gather and part sideways,
/// bunching up at the outer edges to reveal an illuminated stage canvas underneath.
/// A classic top pelmet / valence remains pinned as the navigation toolbar.
class TheaterCurtainRevealHeaderWidget extends StatelessWidget {
  /// Creates a [TheaterCurtainRevealHeaderWidget].
  const TheaterCurtainRevealHeaderWidget({
    super.key,
    required this.stageContent,
    required this.valenceTitle,
    this.valenceActions,
    this.leading,
    this.safeArea = true,
    this.config = const TheaterCurtainRevealConfig(),
  });

  /// The illuminated stage canvas revealed behind the parting curtains.
  final Widget stageContent;

  /// Title displayed on the top pinned valence / pelmet.
  final Widget valenceTitle;

  /// Optional action buttons in the top valence.
  final List<Widget>? valenceActions;

  /// Optional leading navigation button.
  final Widget? leading;

  /// Whether to respect top SafeArea.
  final bool safeArea;

  /// Curtain reveal configuration.
  final TheaterCurtainRevealConfig config;

  @override
  Widget build(BuildContext context) {
    final topPadding = safeArea ? MediaQuery.paddingOf(context).top : 0.0;
    final totalExpanded = config.expandedHeight + topPadding;
    final totalCollapsed = config.collapsedHeight + topPadding;

    return SliverPersistentHeader(
      pinned: true,
      delegate: _TheaterCurtainDelegate(
        stageContent: stageContent,
        valenceTitle: valenceTitle,
        valenceActions: valenceActions,
        leading: leading,
        safeArea: safeArea,
        topPadding: topPadding,
        totalExpanded: math.max(totalExpanded, totalCollapsed + 1.0),
        totalCollapsed: totalCollapsed,
        config: config,
      ),
    );
  }
}

class _TheaterCurtainDelegate extends SliverPersistentHeaderDelegate {
  _TheaterCurtainDelegate({
    required this.stageContent,
    required this.valenceTitle,
    required this.valenceActions,
    required this.leading,
    required this.safeArea,
    required this.topPadding,
    required this.totalExpanded,
    required this.totalCollapsed,
    required this.config,
  });

  final Widget stageContent;
  final Widget valenceTitle;
  final List<Widget>? valenceActions;
  final Widget? leading;
  final bool safeArea;
  final double topPadding;
  final double totalExpanded;
  final double totalCollapsed;
  final TheaterCurtainRevealConfig config;

  @override
  double get minExtent => totalCollapsed;

  @override
  double get maxExtent => totalExpanded;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    final reducedMotion = MediaQuery.disableAnimationsOf(context);
    final width = MediaQuery.sizeOf(context).width;
    final safeWidth = width > 0 ? width : 360.0;
    final halfWidth = safeWidth / 2.0;

    final scrollProgress = (shrinkOffset / config.partingThreshold).clamp(0.0, 1.0);
    final curvedProgress = reducedMotion
        ? (scrollProgress > 0.5 ? 1.0 : 0.0)
        : config.curve.transform(scrollProgress);

    final curtainBaseColor = config.curtainColor ?? const Color(0xFF8B1538); // Classic crimson velvet
    final theme = Theme.of(context);

    // Curtain width bunches up as it parts
    // At progress = 0: width = halfWidth (covers entire half)
    // At progress = 1: width bunches to 24px at the edge
    final bunchedWidth = 24.0;
    final currentCurtainWidth = halfWidth - ((halfWidth - bunchedWidth) * curvedProgress);

    return Material(
      elevation: 4.0 * curvedProgress,
      color: theme.colorScheme.surface,
      child: ClipRect(
        child: OverflowBox(
          minWidth: 0.0,
          maxWidth: safeWidth,
          minHeight: 0.0,
          maxHeight: totalExpanded,
          alignment: Alignment.topLeft,
          child: Stack(
            fit: StackFit.expand,
            children: [
              // 1. Stage Canvas Background (revealed behind curtains)
              Positioned(
                left: 0.0,
                right: 0.0,
                top: totalCollapsed,
                bottom: 0.0,
                child: Opacity(
                  opacity: (0.3 + 0.7 * curvedProgress).clamp(0.0, 1.0),
                  child: stageContent,
                ),
              ),

              // 2. Left Fabric Curtain Panel
              Positioned(
                left: 0.0,
                top: totalCollapsed,
                bottom: 0.0,
                width: math.max(0.0, currentCurtainWidth),
                child: CustomPaint(
                  painter: _CurtainPleatsPainter(
                    pleatsCount: config.pleatsCount,
                    baseColor: curtainBaseColor,
                    isLeft: true,
                  ),
                ),
              ),

              // 3. Right Fabric Curtain Panel
              Positioned(
                right: 0.0,
                top: totalCollapsed,
                bottom: 0.0,
                width: math.max(0.0, currentCurtainWidth),
                child: CustomPaint(
                  painter: _CurtainPleatsPainter(
                    pleatsCount: config.pleatsCount,
                    baseColor: curtainBaseColor,
                    isLeft: false,
                  ),
                ),
              ),

              // 4. Top Pinned Valence / Pelmet (Grand Theater Header)
              Positioned(
                left: 0.0,
                right: 0.0,
                top: 0.0,
                height: totalCollapsed,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        curtainBaseColor,
                        curtainBaseColor.withValues(alpha: 0.85),
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.3),
                        blurRadius: 4.0,
                        offset: const Offset(0.0, 2.0),
                      ),
                    ],
                  ),
                  child: SafeArea(
                    top: safeArea,
                    bottom: false,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Row(
                        children: [
                          if (leading != null) ...[
                            leading!,
                            const SizedBox(width: 8.0),
                          ],
                          Expanded(
                            child: DefaultTextStyle(
                              style: theme.textTheme.titleMedium!.copyWith(
                                color: Colors.amber.shade100,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              child: valenceTitle,
                            ),
                          ),
                          ...?valenceActions,
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(covariant _TheaterCurtainDelegate oldDelegate) {
    return stageContent != oldDelegate.stageContent ||
        valenceTitle != oldDelegate.valenceTitle ||
        valenceActions != oldDelegate.valenceActions ||
        leading != oldDelegate.leading ||
        topPadding != oldDelegate.topPadding ||
        totalExpanded != oldDelegate.totalExpanded ||
        totalCollapsed != oldDelegate.totalCollapsed ||
        config != oldDelegate.config;
  }
}

/// Custom painter rendering pleated fabric folds and directional shading for theater curtains.
class _CurtainPleatsPainter extends CustomPainter {
  _CurtainPleatsPainter({
    required this.pleatsCount,
    required this.baseColor,
    required this.isLeft,
  });

  final int pleatsCount;
  final Color baseColor;
  final bool isLeft;

  @override
  void paint(Canvas canvas, Size size) {
    if (size.width <= 0 || size.height <= 0) return;

    final pleatWidth = size.width / math.max(1, pleatsCount);
    final shadowColor = Color.lerp(baseColor, Colors.black, 0.45)!;
    final highlightColor = Color.lerp(baseColor, Colors.white, 0.25)!;

    for (int i = 0; i < pleatsCount; i++) {
      final left = i * pleatWidth;
      final rect = Rect.fromLTWH(left, 0, pleatWidth, size.height);

      final gradient = LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: isLeft
            ? [shadowColor, baseColor, highlightColor]
            : [highlightColor, baseColor, shadowColor],
        stops: const [0.0, 0.5, 1.0],
      );

      final paint = Paint()..shader = gradient.createShader(rect);
      canvas.drawRect(rect, paint);
    }

    // Outer edge gather line
    final edgePaint = Paint()
      ..color = shadowColor
      ..strokeWidth = 2.0;
    final edgeX = isLeft ? size.width : 0.0;
    canvas.drawLine(Offset(edgeX, 0), Offset(edgeX, size.height), edgePaint);
  }

  @override
  bool shouldRepaint(covariant _CurtainPleatsPainter oldDelegate) {
    return pleatsCount != oldDelegate.pleatsCount ||
        baseColor != oldDelegate.baseColor ||
        isLeft != oldDelegate.isLeft;
  }
}
