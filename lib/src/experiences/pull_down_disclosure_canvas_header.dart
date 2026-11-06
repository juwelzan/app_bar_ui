import 'package:flutter/material.dart';
import 'experience_configs.dart';

/// Style 20: Pull-Down Disclosure Canvas Header
///
/// Header that reveals a hidden utility disclosure drawer above or within
/// the header canvas upon an intentional pull-down overscroll gesture or tap.
class PullDownDisclosureCanvasHeaderWidget extends StatefulWidget {
  /// Creates a [PullDownDisclosureCanvasHeaderWidget].
  const PullDownDisclosureCanvasHeaderWidget({
    super.key,
    required this.restingHeaderContent,
    required this.disclosureCanvasContent,
    this.backgroundColor,
    this.disclosureBackgroundColor,
    this.config = const PullDownDisclosureCanvasConfig(),
    this.safeArea = true,
  });

  /// The normal header content visible in resting state.
  final Widget restingHeaderContent;

  /// The hidden utility canvas disclosed upon pull-down.
  final Widget disclosureCanvasContent;

  /// Header background color.
  final Color? backgroundColor;

  /// Disclosure canvas background color.
  final Color? disclosureBackgroundColor;

  /// Geometry and trigger threshold configuration.
  final PullDownDisclosureCanvasConfig config;

  /// Whether to incorporate safe area top insets.
  final bool safeArea;

  @override
  State<PullDownDisclosureCanvasHeaderWidget> createState() =>
      PullDownDisclosureCanvasHeaderWidgetState();
}

class PullDownDisclosureCanvasHeaderWidgetState
    extends State<PullDownDisclosureCanvasHeaderWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _disclosureController;
  late Animation<double> _disclosureAnimation;
  bool _isDisclosed = false;

  @override
  void initState() {
    super.initState();
    _disclosureController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _disclosureAnimation = CurvedAnimation(
      parent: _disclosureController,
      curve: widget.config.curve,
    );
  }

  @override
  void dispose() {
    _disclosureController.dispose();
    super.dispose();
  }

  /// Toggles disclosure state.
  void toggleDisclosure() {
    setDisclosed(!_isDisclosed);
  }

  /// Explicitly sets the disclosure open or closed.
  void setDisclosed(bool disclosed) {
    if (_isDisclosed == disclosed) return;
    setState(() => _isDisclosed = disclosed);
    if (disclosed) {
      _disclosureController.forward();
    } else {
      _disclosureController.reverse();
    }
  }

  /// Handles overscroll drag to unlock disclosure canvas.
  void handleOverscrollDelta(double delta) {
    if (!_isDisclosed && delta > widget.config.pullUnlockThreshold) {
      setDisclosed(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final topPadding = widget.safeArea ? MediaQuery.paddingOf(context).top : 0.0;
    final resolvedBgColor = widget.backgroundColor ?? theme.colorScheme.surface;
    final resolvedDisclosureColor =
        widget.disclosureBackgroundColor ?? theme.colorScheme.surfaceContainerHighest;

    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        if (notification is ScrollUpdateNotification) {
          if (notification.metrics.extentBefore == 0 &&
              notification.scrollDelta != null &&
              notification.scrollDelta! < -8.0) {
            handleOverscrollDelta(-notification.scrollDelta!);
          }
        }
        return false;
      },
      child: AnimatedBuilder(
        animation: _disclosureAnimation,
        builder: (context, _) {
          final t = _disclosureAnimation.value;
          final currentDisclosureHeight = widget.config.disclosureCanvasHeight * t;

          return Material(
            elevation: widget.config.elevation,
            color: resolvedBgColor,
            child: Padding(
              padding: EdgeInsets.only(top: topPadding),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Hidden Disclosure Drawer Canvas
                  ClipRect(
                    child: SizedBox(
                      height: currentDisclosureHeight,
                      child: Opacity(
                        opacity: t.clamp(0.0, 1.0),
                        child: Container(
                          color: resolvedDisclosureColor,
                          width: double.infinity,
                          child: widget.disclosureCanvasContent,
                        ),
                      ),
                    ),
                  ),

                  // Resting Header Bar with disclosure toggle indicator
                  SizedBox(
                    height: widget.config.restingHeight,
                    child: widget.restingHeaderContent,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
