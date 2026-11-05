import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Data class representing a secondary action button inside a [ScrollExpandableFab].
class ScrollExpandableFabAction {
  /// Creates an action button configuration.
  const ScrollExpandableFabAction({
    required this.icon,
    this.label,
    required this.onPressed,
    this.backgroundColor,
    this.foregroundColor,
    this.tooltip,
    this.heroTag,
  });

  /// Icon or widget inside the action button.
  final Widget icon;

  /// Optional text label displayed alongside the button.
  final String? label;

  /// Callback executed when the action is tapped.
  final VoidCallback? onPressed;

  /// Background color of the action button.
  final Color? backgroundColor;

  /// Foreground/icon color of the action button.
  final Color? foregroundColor;

  /// Tooltip text.
  final String? tooltip;

  /// Optional unique hero tag.
  final Object? heroTag;
}

/// An expandable speed-dial floating action control that fans out child action buttons
/// with smooth staggered animations.
///
/// Features:
/// - Automatically collapses open child menus when the user scrolls ([autoCollapseOnScroll]).
/// - Auto-hides when scrolling down and restores when scrolling up ([autoHideOnScrollDown]).
/// - Connects directly to [ScrollController] or [visibilityListenable].
/// - Tap-outside scrim dismissal.
class ScrollExpandableFab extends StatefulWidget {
  /// Creates a [ScrollExpandableFab] widget.
  const ScrollExpandableFab({
    super.key,
    required this.children,
    this.icon = const Icon(Icons.add),
    this.activeIcon = const Icon(Icons.close),
    this.scrollController,
    this.visibilityListenable,
    this.autoCollapseOnScroll = true,
    this.autoHideOnScrollDown = false,
    this.distance = 58.0,
    this.animationDuration = const Duration(milliseconds: 250),
    this.curve = Curves.easeOutBack,
    this.backgroundColor,
    this.foregroundColor,
    this.overlayColor,
    this.heroTag,
  });

  /// The child action buttons to fan out.
  final List<ScrollExpandableFabAction> children;

  /// Main icon displayed when collapsed. Defaults to [Icons.add].
  final Widget icon;

  /// Active icon displayed when expanded. Defaults to [Icons.close].
  final Widget activeIcon;

  /// Optional [ScrollController] to monitor for scrolling.
  final ScrollController? scrollController;

  /// Optional [ValueListenable] providing visibility progress directly (0.0 = hidden, 1.0 = visible).
  final ValueListenable<double>? visibilityListenable;

  /// Whether to automatically collapse the expanded speed-dial when the user begins scrolling.
  /// Defaults to true.
  final bool autoCollapseOnScroll;

  /// Whether to auto-hide the entire FAB when scrolling down. Defaults to false.
  final bool autoHideOnScrollDown;

  /// Vertical distance between child buttons. Defaults to 58.0.
  final double distance;

  /// Animation duration for expanding/collapsing. Defaults to 250ms.
  final Duration animationDuration;

  /// Animation curve. Defaults to [Curves.easeOutBack].
  final Curve curve;

  /// Main FAB background color.
  final Color? backgroundColor;

  /// Main FAB foreground/icon color.
  final Color? foregroundColor;

  /// Background overlay scrim color when open. Defaults to transparent.
  final Color? overlayColor;

  /// Optional unique hero tag for the main FAB.
  final Object? heroTag;

  @override
  State<ScrollExpandableFab> createState() => _ScrollExpandableFabState();
}

class _ScrollExpandableFabState extends State<ScrollExpandableFab>
    with SingleTickerProviderStateMixin {
  late final AnimationController _expandController;
  late final Animation<double> _expandAnimation;
  double _lastOffset = 0.0;
  bool _isOpen = false;
  bool _isVisible = true;

  @override
  void initState() {
    super.initState();
    _expandController = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
    );
    _expandAnimation = CurvedAnimation(
      parent: _expandController,
      curve: widget.curve,
      reverseCurve: Curves.easeInBack,
    );

    widget.visibilityListenable?.addListener(_onVisibilityListenableChanged);
    widget.scrollController?.addListener(_onScrollChanged);
  }

  @override
  void didUpdateWidget(covariant ScrollExpandableFab oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.visibilityListenable != oldWidget.visibilityListenable) {
      oldWidget.visibilityListenable?.removeListener(
        _onVisibilityListenableChanged,
      );
      widget.visibilityListenable?.addListener(_onVisibilityListenableChanged);
    }
    if (widget.scrollController != oldWidget.scrollController) {
      oldWidget.scrollController?.removeListener(_onScrollChanged);
      widget.scrollController?.addListener(_onScrollChanged);
    }
  }

  void _onVisibilityListenableChanged() {
    if (!mounted || widget.visibilityListenable == null) return;
    final targetVisible = widget.visibilityListenable!.value > 0.5;
    if (_isVisible != targetVisible) {
      setState(() {
        _isVisible = targetVisible;
      });
      if (!targetVisible && _isOpen) {
        _close();
      }
    }
  }

  void _onScrollChanged() {
    if (!mounted ||
        widget.scrollController == null ||
        !widget.scrollController!.hasClients) {
      return;
    }

    final currentOffset = widget.scrollController!.offset;
    final delta = currentOffset - _lastOffset;
    _lastOffset = currentOffset;

    // Auto-collapse open menu on scroll
    if (widget.autoCollapseOnScroll && _isOpen && delta.abs() > 2.0) {
      _close();
    }

    // Auto-hide handling
    if (widget.autoHideOnScrollDown) {
      if (currentOffset <= 0.0) {
        _setVisibility(true);
      } else if (delta > 3.0) {
        _setVisibility(false);
      } else if (delta < -3.0) {
        _setVisibility(true);
      }
    }
  }

  void _setVisibility(bool visible) {
    if (_isVisible == visible) return;
    setState(() {
      _isVisible = visible;
    });
    if (!visible && _isOpen) {
      _close();
    }
  }

  void _toggle() {
    if (_isOpen) {
      _close();
    } else {
      _open();
    }
  }

  void _open() {
    setState(() => _isOpen = true);
    _expandController.forward();
  }

  void _close() {
    setState(() => _isOpen = false);
    _expandController.reverse();
  }

  @override
  void dispose() {
    widget.visibilityListenable?.removeListener(_onVisibilityListenableChanged);
    widget.scrollController?.removeListener(_onScrollChanged);
    _expandController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double openHeight = (widget.distance * widget.children.length) + 64.0;
    const double openWidth = 240.0;

    return AnimatedScale(
      scale: _isVisible ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 200),
      child: SizedBox(
        width: _isOpen ? openWidth : 56.0,
        height: _isOpen ? openHeight : 56.0,
        child: Stack(
          alignment: Alignment.bottomRight,
          children: [
            // Dismiss tap target when expanded
            if (_isOpen)
              Positioned.fill(
                child: GestureDetector(
                  onTap: _close,
                  behavior: HitTestBehavior.opaque,
                  child: Container(
                    color: widget.overlayColor ?? Colors.transparent,
                  ),
                ),
              ),

            // Child action buttons fanning upwards
            ..._buildChildActions(),

            // Main Floating Action Button
            Positioned(
              bottom: 0,
              right: 0,
              child: FloatingActionButton(
                key: const ValueKey('scroll_expandable_fab_main'),
                heroTag: widget.heroTag,
                backgroundColor: widget.backgroundColor,
                foregroundColor: widget.foregroundColor,
                elevation: 4.0,
                onPressed: _toggle,
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  transitionBuilder: (child, anim) =>
                      ScaleTransition(scale: anim, child: child),
                  child: _isOpen
                      ? KeyedSubtree(
                          key: const ValueKey('active_icon'),
                          child: widget.activeIcon,
                        )
                      : KeyedSubtree(
                          key: const ValueKey('idle_icon'),
                          child: widget.icon,
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildChildActions() {
    final List<Widget> items = [];
    final count = widget.children.length;

    for (int i = 0; i < count; i++) {
      final action = widget.children[i];
      final double targetBottom = (i + 1) * widget.distance;

      final actionWidget = AnimatedBuilder(
        animation: _expandAnimation,
        builder: (context, child) {
          final progress = _expandAnimation.value;
          return Positioned(
            bottom: targetBottom * progress,
            right: 4.0,
            child: Opacity(
              opacity: progress.clamp(0.0, 1.0),
              child: Transform.scale(
                scale: 0.5 + (0.5 * progress),
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    _close();
                    action.onPressed?.call();
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (action.label != null && action.label!.isNotEmpty) ...[
                        Material(
                          elevation: 2.0,
                          borderRadius: BorderRadius.circular(6.0),
                          color: Theme.of(context).colorScheme.surface,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8.0,
                              vertical: 4.0,
                            ),
                            child: Text(
                              action.label!,
                              style: Theme.of(context).textTheme.labelMedium,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8.0),
                      ],
                      FloatingActionButton.small(
                        heroTag: action.heroTag,
                        tooltip: action.tooltip,
                        backgroundColor: action.backgroundColor,
                        foregroundColor: action.foregroundColor,
                        onPressed: () {
                          _close();
                          action.onPressed?.call();
                        },
                        child: action.icon,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      );

      items.add(actionWidget);
    }

    return items;
  }
}
