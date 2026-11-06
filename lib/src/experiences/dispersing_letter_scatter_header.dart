import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'experience_configs.dart';

/// Style 42: Animated Typography Dispersing Letter Scatter Header.
///
/// The headline characters disassemble and scatter outward in 2D space along
/// distinct radial vectors during scroll expansion, reconverging into a tight,
/// coherent title string as the user scrolls into the pinned navigation toolbar.
class DispersingLetterScatterHeaderWidget extends StatelessWidget {
  /// Creates a [DispersingLetterScatterHeaderWidget].
  const DispersingLetterScatterHeaderWidget({
    super.key,
    required this.titleText,
    this.textStyle,
    this.subtitle,
    this.leading,
    this.actions,
    this.backgroundColor,
    this.safeArea = true,
    this.config = const DispersingLetterScatterConfig(),
  });

  /// The raw text string whose letters disperse and reconverge.
  final String titleText;

  /// Custom typography style for the letters.
  final TextStyle? textStyle;

  /// Optional subtitle.
  final Widget? subtitle;

  /// Optional leading navigation widget.
  final Widget? leading;

  /// Optional trailing action widgets.
  final List<Widget>? actions;

  /// Canvas background color.
  final Color? backgroundColor;

  /// Whether to respect status bar safe area.
  final bool safeArea;

  /// Letter scatter and typography animation configuration.
  final DispersingLetterScatterConfig config;

  @override
  Widget build(BuildContext context) {
    final topPadding = safeArea ? MediaQuery.paddingOf(context).top : 0.0;
    final totalExpanded = config.expandedHeight + topPadding;
    final totalCollapsed = config.collapsedHeight + topPadding;

    return SliverPersistentHeader(
      pinned: true,
      delegate: _LetterScatterDelegate(
        titleText: titleText,
        textStyle: textStyle,
        subtitle: subtitle,
        leading: leading,
        actions: actions,
        backgroundColor: backgroundColor ?? Theme.of(context).colorScheme.surface,
        topPadding: topPadding,
        totalExpanded: totalExpanded,
        totalCollapsed: totalCollapsed,
        config: config,
      ),
    );
  }
}

class _LetterScatterDelegate extends SliverPersistentHeaderDelegate {
  _LetterScatterDelegate({
    required this.titleText,
    required this.textStyle,
    required this.subtitle,
    required this.leading,
    required this.actions,
    required this.backgroundColor,
    required this.topPadding,
    required this.totalExpanded,
    required this.totalCollapsed,
    required this.config,
  });

  final String titleText;
  final TextStyle? textStyle;
  final Widget? subtitle;
  final Widget? leading;
  final List<Widget>? actions;
  final Color backgroundColor;
  final double topPadding;
  final double totalExpanded;
  final double totalCollapsed;
  final DispersingLetterScatterConfig config;

  @override
  double get minExtent => totalCollapsed;

  @override
  double get maxExtent => totalExpanded;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    final isReducedMotion = MediaQuery.disableAnimationsOf(context);
    final theme = Theme.of(context);
    final effectiveStyle = textStyle ??
        theme.textTheme.headlineMedium!.copyWith(
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        );

    // progress: 0.0 = fully expanded (scattered), 1.0 = collapsed (docked and unified)
    final progress = ((shrinkOffset) / (totalExpanded - totalCollapsed)).clamp(0.0, 1.0);
    // scatterAmount: 1.0 when expanded, 0.0 when collapsed
    final scatterAmount = (1.0 - progress);

    return Container(
      color: backgroundColor,
      child: SafeArea(
        top: false,
        bottom: false,
        child: Padding(
          padding: EdgeInsets.only(top: topPadding),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Subtitle in expanded mode
              if (subtitle != null)
                Positioned(
                  bottom: 16.0,
                  left: 20.0,
                  right: 20.0,
                  child: Opacity(
                    opacity: (1.0 - progress / 0.5).clamp(0.0, 1.0),
                    child: subtitle!,
                  ),
                ),

              // Scattered or Reconverged Typography
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(titleText.length, (i) {
                        final char = titleText[i];
                        if (isReducedMotion) {
                          return Text(char, style: effectiveStyle);
                        }

                        // Deterministic pseudo-random seed per character index
                        final angle = (i * 1.35) % (2 * math.pi);
                        final radius = (config.scatterRadius * scatterAmount) *
                            (0.6 + 0.4 * ((i * 3) % 5) / 5.0);

                        final dx = math.cos(angle) * radius;
                        final dy = math.sin(angle) * radius * 0.7;
                        final rotation = (math.sin(i * 2.1) * config.maxGlyphRotation) * scatterAmount;
                        final scale = 1.0 + (0.35 * scatterAmount * ((i % 2 == 0) ? 1 : -0.5));

                        return Transform.translate(
                          offset: Offset(dx, dy),
                          child: Transform.rotate(
                            angle: rotation,
                            child: Transform.scale(
                              scale: scale,
                              child: Text(
                                char,
                                style: effectiveStyle.copyWith(
                                  color: Color.lerp(
                                    theme.colorScheme.primary,
                                    effectiveStyle.color ?? theme.colorScheme.onSurface,
                                    progress,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                ),
              ),

              // Docked toolbar controls
              Positioned(
                top: 0.0,
                left: 0.0,
                right: 0.0,
                height: config.collapsedHeight,
                child: Row(
                  children: [
                    ?leading,
                    const Spacer(),
                    ...?actions,
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(covariant _LetterScatterDelegate oldDelegate) {
    return oldDelegate.titleText != titleText ||
        oldDelegate.totalExpanded != totalExpanded ||
        oldDelegate.totalCollapsed != totalCollapsed ||
        oldDelegate.backgroundColor != backgroundColor;
  }
}
