# PERFORMANCE GUIDELINES — Zero-Lag Scroll Architecture

## 1. Core Performance Objectives

1. **Rock-Solid 60 FPS & 120 FPS High Refresh Rates**: Rendering frame budget must strictly stay within **16.6ms** (60Hz) and **8.3ms** (120Hz) during active drag, fling, and overscroll.
2. **Zero Whole-Tree Rebuilds**: Scrolling updates must NEVER invoke `setState()` on root widgets, scaffolds, or parent viewports.
3. **Zero Allocation in Scroll Hot Paths**: No heap objects, closures, or temporary matrix allocations inside high-frequency scroll notification callbacks.
4. **Zero Memory & Listener Leaks**: Every controller, ticker, listener, and platform channel registration must have a strictly deterministic lifecycle and cleanup guarantee.

---

## 2. Rendering Optimization Protocol

### 2.1 Targeted Localized Updates
- **Problem**: Calling `setState()` in a scroll listener forces Flutter to re-evaluate the entire widget tree, triggering layout recalculations for every child widget on every scroll tick.
- **Framework Rule**: Never call `setState()` on `ScrollResponsiveScaffold` when scroll offset changes.
- **Implementation**: Use isolated `ValueNotifier<double>` instances for individual components (e.g. `leadingProgressNotifier`, `trailingProgressNotifier`, `statusBarNotifier`). Only the leaf widgets wrapped in `ValueListenableBuilder` rebuild their visual representation.

```dart
// ✅ CORRECT: Localized rebuild of only the action button
ValueListenableBuilder<double>(
  valueListenable: _engine.leadingProgressNotifier,
  builder: (context, progress, child) {
    return PinnedActionButton(progress: progress, ...);
  },
);

// ❌ FORBIDDEN: Rebuilding the entire Scaffold on scroll update
onScrollUpdate: (offset) {
  setState(() { _currentOffset = offset; }); // Causes global jank!
}
```

### 2.2 Repaint Boundary & Flow Architecture
- **Problem**: Moving backgrounds (such as parallax images) can cause adjacent widgets to repaint if they share the same render layer.
- **Framework Rule**: Use `Flow` with `FlowDelegate` for parallax effects (`ScrollParallax`).
- **Implementation**: `_ParallaxFlowDelegate` overrides `super(repaint: scrollable.position)`. When the user scrolls, Flutter directly invokes `paintChildren()` with a `Matrix4.translationValues` matrix **without performing element layout or widget rebuilds**.

### 2.3 Offscreen Clipping & SaveLayer Caution
- Avoid wrapping full-screen views in `Opacity` or `ShaderMask`, which triggers expensive offscreen GPU render passes (`saveLayer`).
- When opacity transitions reach 1.0, bypass `Opacity` completely (`if (opacity < 1.0)`).
- When a component is completely hidden ($opacity = 0.0$ or $visibility = 0.0$), use `IgnorePointer(ignoring: true)` and avoid unnecessary layout evaluation.

### 2.4 Lazy Rendering Integrity
- When rendering content bodies, ensure developers use sliver lists (`SliverList.builder`) or list views (`ListView.builder`) with appropriate cache extents (`cacheExtent: 250.0`) so offscreen items are lazily created and destroyed.

---

## 3. Animation Performance & 120Hz Displays

### 3.1 Single Controller Lifecycle
- Every `AnimationController` must be owned by a single `State` object utilizing `SingleTickerProviderStateMixin`.
- Always dispose controllers inside `State.dispose()`:
```dart
@override
void dispose() {
  _controller.dispose();
  super.dispose();
}
```

### 3.2 Smooth Interruption & Reversal Handling
- When a user reverses scroll direction midway through an ongoing transition, do not restart animations from scratch.
- The framework uses continuous scroll mapping (`curvedT = curve.transform(progress)`) where $t$ is directly bound to scroll position. Direction changes immediately and smoothly reverse without frame stutter or visual snapping.

### 3.3 Reduced-Motion Accessibility Compliance
- High-frequency animations (such as aggressive scale or slide) can induce vestibular discomfort.
- `ScrollTransform` and `ScrollMorphBuilder` inspect `MediaQuery.maybeDisableAnimationsOf(context)`. When enabled at the OS level, scale and translation transforms are suppressed, rendering clean, instant visual states while preserving full interactivity.

---

## 4. Memory Safety & Resource Management

### 4.1 Listener Lifecycle Checklist
| Component | Registered Listener | Disposal Location | Verification |
|---|---|---|---|
| `ScrollResponsiveScaffold` | `ScrollResponsiveEngine` | `_ScrollResponsiveScaffoldState.dispose()` | `_engine.dispose()` cleans all `ValueNotifier`s |
| `ScrollResponsiveScaffold` | `RouteObserver` | `_ScrollResponsiveScaffoldState.dispose()` | `widget.routeObserver?.unsubscribe(this)` |
| `ScrollResponsiveScaffold` | `WidgetsBinding.instance` | `_ScrollResponsiveScaffoldState.dispose()` | `removeObserver(this)` |
| `StatusBarManager` | `SystemChrome` async queue | `StatusBarManager.restore()` | Restores previous UI style and clears pending operations |
| `ScrollAwareFab` | `visibilityListenable` | `_ScrollAwareFabState.dispose()` | `removeListener(_onVisibilityListenableChanged)` |
| `ScrollAutoHideBottomBar` | `scrollController` | `_ScrollAutoHideBottomBarState.dispose()` | `removeListener(_onScrollControllerChanged)` |

### 4.2 Preventing Asynchronous Race Conditions
- Native system UI operations (`SystemChrome.setEnabledSystemUIMode`) are asynchronous platform channel calls over IPC.
- Rapid scrolling or fling gestures could dispatch dozens of conflicting calls per second.
- `StatusBarManager` utilizes an internal operation lock:
```dart
Future<void> _applySystemUiState(bool hide) async {
  _pendingOperation = _pendingOperation.then((_) async {
    // Executes safely in order, preventing dropped frames or out-of-order execution
  });
}
```

---

## 5. Performance Profiling Protocol

Before declaring any release ready, execute the following DevTools checklist:
1. **CPU / Frame Raster Timing**:
   - Verify UI thread duration $< 8\text{ ms}$ on 120Hz displays.
   - Verify Raster thread duration $< 8\text{ ms}$.
   - Ensure zero red jank bars during continuous high-velocity flings.
2. **Rebuild Counter Profiling**:
   - Enable "Track widget rebuilds" in DevTools.
   - Scroll from top to bottom.
   - Ensure the body and sliver items have **0 rebuilds** caused by the header or status bar.
3. **Memory Leak Inspection**:
   - Take a baseline memory heap snapshot in DevTools Memory Inspector.
   - Perform 50 rapid scroll-to-bottom and scroll-to-top gestures.
   - Navigate away from the route and pop back 10 times.
   - Execute GC and take a second snapshot.
   - Confirm zero retained instances of `ScrollResponsiveEngine`, `StatusBarManager`, or `_ScrollResponsiveScaffoldState`.
