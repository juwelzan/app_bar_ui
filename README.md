# app_bar_ui

A production-ready, reusable Flutter UI package that provides a fully configurable **Scroll-Responsive Header System**.

Combines:
1. **SliverAppBar-Style Scrolling Behavior** — The complete header (title, subtitle, profile info, welcome greeting, custom widgets) scrolls naturally away with the page.
2. **Independently Pinned Side Action Icons** — Only the left and right action icons remain pinned to the top of the viewport with completely transparent backgrounds, zero elevation, no cards, no borders, no blur, and strictly aligned with the device's SafeArea.
3. **Smooth Scroll-Based Icon Transitions** — Dual-state icon transitions with synchronized fade, subtle scale, and vertical slide (e.g. Left: Profile Avatar &rarr; Drawer Button; Right: Notification &rarr; Profile Avatar).
4. **Scroll-Responsive Native System Status Bar** — Integrates mobile System Status Bar visibility with threshold-based hysteresis, preventing content jumps and avoiding frame-by-frame platform channel calls.
5. **Zero-Lag Performance Engine** — Driven by high-performance listenable notifiers that rebuild *only* the 48x48 action buttons, ensuring 60/120 FPS performance even on low-end mobile devices without full-tree rebuilds.

---

## Architecture Overview

```
+-------------------------------------------------------------+
| System Status Bar (Hides on scroll-down, restores on scroll-up) |
+-------------------------------------------------------------+
| [Pinned Leading]                     [Pinned Trailing]      | <-- Layer 2: Transparent Pinned Actions
|  (Avatar -> Drawer)                  (Bell -> Avatar)       |     (Zero layout shift, 48x48 touch targets)
|                                                             |
|  +-------------------------------------------------------+  |
|  | Header Section (Scrolls naturally away with content)  |  | <-- Layer 1: CustomScrollView
|  | - Title & Subtitle                                    |  |
|  | - Welcome Greetings & Quick Stats                     |  |
|  +-------------------------------------------------------+  |
|                                                             |
|  +-------------------------------------------------------+  |
|  | Scrollable Body (Slivers, ListView, or Custom Content)|  |
|  |                                                       |  |
|  +-------------------------------------------------------+  |
+-------------------------------------------------------------+
```

---

## Installation

Add `app_bar_ui` to your `pubspec.yaml`:

```yaml
dependencies:
  flutter:
    sdk: flutter
  app_bar_ui: ^1.0.0
```

Then run:

```bash
flutter pub get
```

---

## Quick Start (Basic Usage)

```dart
import 'package:flutter/material.dart';
import 'package:app_bar_ui/app_bar_ui.dart';

class MyHomeScreen extends StatelessWidget {
  const MyHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ScrollResponsiveScaffold(
      // Left side action: Profile Avatar initially -> Drawer icon when scrolled
      initialLeading: const CircleAvatar(
        radius: 18,
        child: Text('JD'),
      ),
      scrolledLeading: const Icon(Icons.menu),

      // Right side action: Notification icon initially -> Profile Avatar when scrolled
      initialTrailing: const Icon(Icons.notifications_none),
      scrolledTrailing: const CircleAvatar(
        radius: 18,
        child: Text('JD'),
      ),

      // Header scrolls away naturally
      headerTitle: const Text('My Workspace'),
      headerSubtitle: const Text('Learn • Grow • Excel'),

      // Navigation drawer opened automatically when tapping scrolled leading icon
      drawer: const Drawer(
        child: SafeArea(
          child: ListTile(
            leading: Icon(Icons.home),
            title: Text('Home'),
          ),
        ),
      ),

      // Scrollable content
      body: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 30,
        itemBuilder: (context, index) => ListTile(
          title: Text('Task item #$index'),
        ),
      ),
    );
  }
}
```

---

## Advanced Usage

### 1. Custom Header and Slivers

You can pass a rich `header` widget or leverage direct `slivers`:

```dart
ScrollResponsiveScaffold(
  header: ScrollResponsiveHeader(
    welcome: const Text('Good morning, Alex 👋'),
    title: const Text('Executive Dashboard'),
    subtitle: const Text('Real-time production metrics'),
    content: Row(
      children: [
        Chip(label: Text('Sprint 42')),
        SizedBox(width: 8),
        Chip(label: Text('99.98% Uptime')),
      ],
    ),
  ),
  slivers: [
    SliverGrid(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
      ),
      delegate: SliverChildBuilderDelegate(
        (context, index) => Card(child: Center(child: Text('Metric #$index'))),
        childCount: 6,
      ),
    ),
    SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) => ListTile(title: Text('Activity #$index')),
        childCount: 20,
      ),
    ),
  ],
)
```

### 2. Independent Left and Right Thresholds

Configure independent scroll thresholds for left vs. right action transitions:

```dart
ScrollResponsiveScaffold(
  config: const ScrollResponsiveConfig(
    thresholds: ScrollThresholdConfig(
      // Left avatar -> drawer starts at 10px and completes at 60px
      leadingStartOffset: 10.0,
      leadingEndOffset: 60.0,

      // Right notification -> avatar starts at 40px and completes at 100px
      trailingStartOffset: 40.0,
      trailingEndOffset: 100.0,

      // Status bar hides at 110px, restores when scrolled back to 50px (hysteresis)
      statusBarHideOffset: 110.0,
      statusBarShowOffset: 50.0,
    ),
    animation: ScrollAnimationConfig(
      transitionType: ScrollTransitionType.scrollProgress,
      curve: Curves.easeInOutCubic,
      minScale: 0.70,
      slideOffset: Offset(0.0, 0.2), // subtle vertical slide
    ),
  ),
  // ...
)
```

### 3. Threshold-Triggered Animation Mode

If you prefer discrete animated transitions triggered when crossing thresholds (rather than continuous scroll mapping):

```dart
ScrollResponsiveConfig(
  animation: ScrollAnimationConfig(
    transitionType: ScrollTransitionType.thresholdTriggered,
    duration: Duration(milliseconds: 300),
    curve: Curves.easeOutBack,
  ),
)
```

### 4. Interactive Callbacks

```dart
ScrollResponsiveScaffold(
  // Initial state tap actions (progress < 0.5)
  onLeadingInitialTap: () => Navigator.pushNamed(context, '/profile'),
  onTrailingInitialTap: () => Navigator.pushNamed(context, '/notifications'),

  // Scrolled state tap actions (progress >= 0.5)
  onLeadingScrolledTap: () => Scaffold.of(context).openDrawer(),
  onTrailingScrolledTap: () => Navigator.pushNamed(context, '/profile'),

  // Real-time telemetry updates
  onScrollUpdate: (ScrollProgressDetails details) {
    print('Offset: ${details.offset}');
    print('Leading progress: ${details.leadingProgress}');
    print('Trailing progress: ${details.trailingProgress}');
    print('Status bar hidden: ${details.isStatusBarHidden}');
    print('Scroll direction: ${details.scrollDirection}');
  },
  onScrollDirectionChanged: (ScrollDirection direction) {
    print('Direction changed to: $direction');
  },
  // ...
)
```

---

## Configuration Reference

### `ScrollResponsiveConfig`

| Property | Type | Default | Description |
|---|---|---|---|
| `pinSideActions` | `bool` | `true` | Convenience flag to pin side action icons. |
| `transparentActions` | `bool` | `true` | Convenience flag for transparent action container background. |
| `hideStatusBarOnScroll` | `bool` | `true` | Convenience flag for status bar hide/restore. |
| `enableReverseAnimation` | `bool` | `true` | Convenience flag to reverse transitions on scroll-up. |
| `thresholds` | `ScrollThresholdConfig` | `ScrollThresholdConfig()` | Scroll transition threshold configuration. |
| `animation` | `ScrollAnimationConfig` | `ScrollAnimationConfig()` | Animation timing, curves, scale, and slide settings. |
| `statusBar` | `StatusBarConfig` | `StatusBarConfig()` | Native mobile status bar behavior. |
| `pinnedActions` | `PinnedActionsConfig` | `PinnedActionsConfig()` | Pinned action sizing, padding, and SafeArea settings. |

### `ScrollThresholdConfig`

| Property | Type | Default | Description |
|---|---|---|---|
| `leadingStartOffset` | `double` | `20.0` | Scroll offset (px) where left action starts transitioning. |
| `leadingEndOffset` | `double` | `80.0` | Scroll offset (px) where left action finishes transitioning. |
| `trailingStartOffset` | `double` | `20.0` | Scroll offset (px) where right action starts transitioning. |
| `trailingEndOffset` | `double` | `80.0` | Scroll offset (px) where right action finishes transitioning. |
| `statusBarHideOffset` | `double` | `100.0` | Scroll offset (px) to hide the mobile status bar. |
| `statusBarShowOffset` | `double` | `50.0` | Scroll offset (px) to restore the mobile status bar (hysteresis). |

### `ScrollAnimationConfig`

| Property | Type | Default | Description |
|---|---|---|---|
| `transitionType` | `ScrollTransitionType` | `scrollProgress` | Continuous scroll progress mapping or threshold-triggered animation. |
| `duration` | `Duration` | `250ms` | Duration for threshold-triggered animations. |
| `curve` | `Curve` | `Curves.easeInOut` | Forward transition easing curve. |
| `reverseCurve` | `Curve?` | `null` | Reverse transition easing curve (defaults to forward curve). |
| `minScale` | `double` | `0.75` | Scale applied to inactive icons (subtle zoom). |
| `maxScale` | `double` | `1.0` | Scale applied to active icons. |
| `slideOffset` | `Offset` | `Offset(0.0, 0.15)` | Fractional translation offset applied during transitions. |
| `enableFade` | `bool` | `true` | Enables opacity fading during transitions. |
| `enableScale` | `bool` | `true` | Enables scale zooming during transitions. |
| `enableSlide` | `bool` | `true` | Enables subtle directional sliding. |

### `StatusBarConfig`

| Property | Type | Default | Description |
|---|---|---|---|
| `enabled` | `bool` | `true` | Master switch for status bar management. |
| `hideOnScroll` | `bool` | `true` | Automatically hide status bar when scrolling down past threshold. |
| `preventContentJump` | `bool` | `true` | Retains safe top insets so content never snaps when status bar hides. |
| `hiddenUiMode` | `SystemUiMode` | `SystemUiMode.manual` | Mode applied when status bar is hidden. |
| `hiddenOverlays` | `List<SystemUiOverlay>` | `[SystemUiOverlay.bottom]` | Preserves bottom navigation bar/home indicator. |
| `visibleUiMode` | `SystemUiMode` | `SystemUiMode.edgeToEdge` | Mode applied when status bar is visible. |
| `visibleOverlays` | `List<SystemUiOverlay>?` | `SystemUiOverlay.values` | Overlays restored on scroll up. |
| `restoreOnDispose` | `bool` | `true` | Restores status bar to visible when navigating away or disposing. |

---

## Platform Support & Native Limitations

| Platform | Scroll Header | Pinned Actions | Dual-State Transitions | System Status Bar Sync |
|---|---|---|---|---|
| **Android** | ✅ Full | ✅ Full | ✅ Full | ✅ Native `SystemChrome` (preserves bottom nav) |
| **iOS / iPadOS**| ✅ Full | ✅ Full | ✅ Full | ✅ Native `SystemChrome` (preserves home indicator) |
| **Web** | ✅ Full | ✅ Full | ✅ Full | ⚠️ N/A (Web browser chrome cannot be toggled) |
| **macOS** | ✅ Full | ✅ Full | ✅ Full | ⚠️ N/A (Desktop window decorations) |
| **Windows** | ✅ Full | ✅ Full | ✅ Full | ⚠️ N/A (Desktop window decorations) |
| **Linux** | ✅ Full | ✅ Full | ✅ Full | ⚠️ N/A (Desktop window decorations) |

> **Note on Native Status Bar Behavior**:
> The native mobile status bar is controlled by the operating system (Android WindowInsets / iOS UIStatusBar). Flutter communicates with the host operating system via asynchronous platform channels.
> - The package incorporates **threshold-based hysteresis** so platform channels are never spammed on every scroll frame.
> - On non-mobile platforms (Web, macOS, Windows, Linux), status bar calls gracefully fall back without throwing errors or warnings.
> - Operating systems do not support arbitrary in-between Flutter opacity fades for native hardware status bar icons; the status bar shows and hides using the platform's native animation behavior.

---

## Troubleshooting Guide

### 1. Pinned action button taps are not firing
- Ensure your `initialLeading`, `scrolledLeading`, etc. do not contain nested gesture detectors that absorb pointer events without bubbling.
- Note that `onInitialTap` triggers when scroll progress is `< 0.5`, and `onScrolledTap` triggers when progress is `>= 0.5`.

### 2. Header overlaps with the pinned action buttons
- Use `ScrollResponsiveHeader`, which includes built-in top padding (`68.0`) to comfortably clear the pinned action row.
- If using a custom header widget, ensure your custom header has top padding of at least `MediaQuery.paddingOf(context).top + 56.0`.

### 3. Content jumps when the status bar hides on Android/iOS
- Ensure `StatusBarConfig.preventContentJump: true` (which is enabled by default).
- The package tracks the maximum top safe insets and locks the pinned actions in place, preventing visual jumps.

### 4. Custom ScrollController conflict
- If you supply your own `ScrollController` via `controller: myScrollController`, do not dispose it inside your widget's `dispose()` until `ScrollResponsiveScaffold` has been unmounted.

---

## Running the Example Application

```bash
cd example
flutter run
```

The example app includes a live telemetry dashboard displaying scroll offset, transition percentages, status bar status, and interactive controls to test different configuration profiles in real time.
