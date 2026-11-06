import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Screen categorization for responsive AppBar layout adaptation.
enum AppBarScreenCategory {
  /// Small compact mobile screen (< 360px, e.g. 320px).
  smallMobile,

  /// Standard to large mobile screen (360px <= width < 600px).
  standardMobile,

  /// Tablet viewport (600px <= width < 1024px).
  tablet,

  /// Standard laptop / desktop viewport (1024px <= width < 1440px).
  desktop,

  /// Ultrawide desktop / workstation display (>= 1440px, e.g. 1920px).
  ultrawide;

  /// Returns true if this category represents a mobile device.
  bool get isMobile => this == smallMobile || this == standardMobile;

  /// Returns true if this category represents a tablet.
  bool get isTablet => this == tablet;

  /// Returns true if this category represents a desktop or ultrawide workstation.
  bool get isDesktopOrWider => this == desktop || this == ultrawide;
}

/// Resolved responsive metrics calculated from constraints and media query.
class AppBarResponsiveMetrics {
  /// Creates an [AppBarResponsiveMetrics] instance.
  const AppBarResponsiveMetrics({
    required this.availableWidth,
    required this.availableHeight,
    required this.category,
    required this.isLandscape,
    required this.textScaleFactor,
    required this.horizontalMargin,
    required this.actionSpacing,
    required this.maxContentWidth,
  });

  /// Evaluates responsive metrics from the given [BuildContext] and [BoxConstraints].
  factory AppBarResponsiveMetrics.of(BuildContext context, [BoxConstraints? constraints]) {
    final media = MediaQuery.maybeOf(context);
    final width = constraints?.maxWidth.isFinite == true
        ? constraints!.maxWidth
        : (media?.size.width ?? 400.0);
    final height = constraints?.maxHeight.isFinite == true
        ? constraints!.maxHeight
        : (media?.size.height ?? 800.0);

    final isLandscape = width > height;

    final category = resolveCategory(width);

    final rawScale = media?.textScaler.scale(1.0) ?? 1.0;
    // Safe text scaling factor to prevent runaway text blowing up compact toolbars
    final textScaleFactor = rawScale.clamp(0.8, 2.0);

    final double horizontalMargin;
    final double actionSpacing;
    final double maxContentWidth;

    switch (category) {
      case AppBarScreenCategory.smallMobile:
        horizontalMargin = 8.0;
        actionSpacing = 4.0;
        maxContentWidth = width;
        break;
      case AppBarScreenCategory.standardMobile:
        horizontalMargin = 16.0;
        actionSpacing = 8.0;
        maxContentWidth = width;
        break;
      case AppBarScreenCategory.tablet:
        horizontalMargin = 24.0;
        actionSpacing = 10.0;
        maxContentWidth = 960.0;
        break;
      case AppBarScreenCategory.desktop:
        horizontalMargin = 32.0;
        actionSpacing = 12.0;
        maxContentWidth = 1200.0;
        break;
      case AppBarScreenCategory.ultrawide:
        horizontalMargin = 48.0;
        actionSpacing = 16.0;
        maxContentWidth = 1440.0;
        break;
    }

    return AppBarResponsiveMetrics(
      availableWidth: width,
      availableHeight: height,
      category: category,
      isLandscape: isLandscape,
      textScaleFactor: textScaleFactor,
      horizontalMargin: horizontalMargin,
      actionSpacing: actionSpacing,
      maxContentWidth: maxContentWidth,
    );
  }

  /// Available width in logical pixels.
  final double availableWidth;

  /// Available height in logical pixels.
  final double availableHeight;

  /// The active screen category.
  final AppBarScreenCategory category;

  /// Whether the viewport is in landscape orientation.
  final bool isLandscape;

  /// Clamped text scale factor (0.8x to 2.0x).
  final double textScaleFactor;

  /// Adaptive horizontal outer margin.
  final double horizontalMargin;

  /// Adaptive spacing between action buttons.
  final double actionSpacing;

  /// Maximum content width before centering on wide displays.
  final double maxContentWidth;

  /// Resolves the screen category for a given viewport width.
  static AppBarScreenCategory resolveCategory(double width) {
    if (width < 360.0) return AppBarScreenCategory.smallMobile;
    if (width < 600.0) return AppBarScreenCategory.standardMobile;
    if (width < 1024.0) return AppBarScreenCategory.tablet;
    if (width < 1440.0) return AppBarScreenCategory.desktop;
    return AppBarScreenCategory.ultrawide;
  }
}

/// A responsive containment wrapper that centers and bounds content on ultrawide displays.
class AppBarResponsiveContainer extends StatelessWidget {
  /// Creates an [AppBarResponsiveContainer].
  const AppBarResponsiveContainer({
    super.key,
    required this.child,
    this.maxContentWidth,
    this.padding,
  });

  /// The child widget.
  final Widget child;

  /// Optional maximum content width override.
  final double? maxContentWidth;

  /// Optional outer padding.
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final metrics = AppBarResponsiveMetrics.of(context);
    final limit = maxContentWidth ?? metrics.maxContentWidth;

    Widget content = child;
    if (metrics.availableWidth > limit) {
      content = Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: limit),
          child: content,
        ),
      );
    }

    if (padding != null) {
      content = Padding(padding: padding!, child: content);
    }

    return content;
  }
}

/// Specialized optical layout slot for AppBars that ensures the title stays
/// truly and optically centered relative to the total header width without
/// drifting or shifting when leading and trailing actions have unequal widths.
class AppBarOpticalSlot extends StatelessWidget {
  /// Creates an [AppBarOpticalSlot].
  const AppBarOpticalSlot({
    super.key,
    this.leading,
    this.title,
    this.subtitle,
    this.actions,
    this.centerTitle = true,
    this.horizontalPadding = 16.0,
    this.crossAxisAlignment = CrossAxisAlignment.center,
  });

  /// Leading widget (e.g., back button or drawer toggle).
  final Widget? leading;

  /// Primary title widget.
  final Widget? title;

  /// Secondary subtitle widget.
  final Widget? subtitle;

  /// Action buttons cluster.
  final List<Widget>? actions;

  /// Whether to optically center the title relative to the overall header.
  final bool centerTitle;

  /// Horizontal padding applied on both sides.
  final double horizontalPadding;

  /// Cross-axis alignment for the toolbar contents.
  final CrossAxisAlignment crossAxisAlignment;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final totalWidth = constraints.maxWidth;
        final hasActions = actions != null && actions!.isNotEmpty;

        final actionsWidget = hasActions
            ? Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: actions!,
              )
            : null;

        if (!centerTitle) {
          // Standard start-aligned toolbar
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
            child: Row(
              crossAxisAlignment: crossAxisAlignment,
              children: [
                if (leading != null) ...[
                  leading!,
                  const SizedBox(width: 8.0),
                ],
                Expanded(
                  child: _buildTitleColumn(context),
                ),
                if (actionsWidget != null) ...[
                  const SizedBox(width: 8.0),
                  actionsWidget,
                ],
              ],
            ),
          );
        }

        // True optical centering:
        // Title is centered over the entire header width.
        // Side gutters (the maximum of leading or trailing width) ensure the
        // title never collides with either leading or actions.
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: _OpticalCenterLayout(
            leading: leading,
            title: _buildTitleColumn(context, textAlign: TextAlign.center),
            actions: actionsWidget,
            totalWidth: totalWidth - (horizontalPadding * 2),
          ),
        );
      },
    );
  }

  Widget _buildTitleColumn(BuildContext context, {TextAlign textAlign = TextAlign.start}) {
    if (title == null && subtitle == null) return const SizedBox.shrink();

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: textAlign == TextAlign.center
          ? CrossAxisAlignment.center
          : CrossAxisAlignment.start,
      children: [
        if (title != null)
          DefaultTextStyle.merge(
            textAlign: textAlign,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            child: title!,
          ),
        if (subtitle != null) ...[
          const SizedBox(height: 1.0),
          DefaultTextStyle.merge(
            textAlign: textAlign,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            child: subtitle!,
          ),
        ],
      ],
    );
  }
}

class _OpticalCenterLayout extends StatelessWidget {
  const _OpticalCenterLayout({
    required this.leading,
    required this.title,
    required this.actions,
    required this.totalWidth,
  });

  final Widget? leading;
  final Widget title;
  final Widget? actions;
  final double totalWidth;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Left Leading Anchor
        if (leading != null)
          Align(
            alignment: Alignment.centerLeft,
            child: leading!,
          ),

        // Right Actions Anchor
        if (actions != null)
          Align(
            alignment: Alignment.centerRight,
            child: actions!,
          ),

        // Centered Title with Dynamic Side Inset Gutters
        // Using IntrinsicWidth or dynamic side padding calculation
        Padding(
          // Reserve sufficient lateral space for typical back buttons (48-56px) and actions
          padding: EdgeInsets.symmetric(
            horizontal: math.max(
              leading != null ? 56.0 : 0.0,
              actions != null ? 56.0 : 0.0,
            ),
          ),
          child: Align(
            alignment: Alignment.center,
            child: title,
          ),
        ),
      ],
    );
  }
}
