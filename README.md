# app_bar_ui

[![pub package](https://img.shields.io/badge/pub-v1.0.0-blue.svg)](https://pub.dev/packages/app_bar_ui)
[![Flutter](https://img.shields.io/badge/Flutter-3.3+-02569B?logo=flutter)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.0+-0175C2?logo=dart)](https://dart.dev)
[![Tests Passing](https://img.shields.io/badge/tests-173%20passed-success.svg)](https://github.com/example/app_bar_ui)
[![License: MIT](https://img.shields.io/badge/license-MIT-purple.svg)](https://opensource.org/licenses/MIT)
[![Platforms](https://img.shields.io/badge/platforms-Android%20%7C%20iOS%20%7C%20iPadOS%20%7C%20macOS%20%7C%20Windows%20%7C%20Linux%20%7C%20Web-brightgreen.svg)](https://flutter.dev)

A production-ready, highly optimized Flutter package providing a **Scroll-Driven UI Framework**.

Combines naturally scrolling headers, independently pinned transparent side actions, dual-state icon transitions, synchronized native status bar management, flow-based parallax, and modular sliver components with **zero unnecessary rebuilds** and rock-solid 60/120 FPS high-refresh rate performance.

---

## Key Features

- **Transparent Overlay Architecture** — Pinned side actions have zero background, zero elevation, zero border, and zero blur. Touches in the center and body pass directly to scrollable content.
- **Dual-State Icon Transitions** — Smoothly transitions between initial and scrolled icon states (e.g. Profile $\rightarrow$ Drawer on left; Notification $\rightarrow$ Profile on right) with synchronized fade, scale, and subtle slide.
- **7 Out-of-the-Box Presets** — Named constructors for instant setup: `.material()`, `.minimal()`, `.iosInspired()`, `.collapsingHeader()`, `.transparentFloating()`, `.dashboard()`, and `.custom()`.
- **12 Modular Scroll Components** — Collapsing headers, rubber-band pull-to-expand, sticky tab bars, auto-hiding FABs, auto-hiding bottom bars, flow parallax, reading progress bars, section reveals, scroll-to-top buttons, side actions, expandable speed-dial FABs, and page indicators.
- **Ambient Scope & Developer API** — Descendant widgets access ambient telemetry and programmatic controls via `context.scrollResponsive` (`scrollToTop()`, `scrollToBottom()`, `collapseHeader()`, `expandHeader()`, `scrollBy()`, `scrollToItem()`).
- **Smart Visibility Controller** — Advanced multi-target visibility management with target locking (`lock()`, `unlock()`), priority sorting, and declarative transitions (`SmartVisibilityTransition`).
- **Unified Animation Engine** — Universal `ScrollRange<T>` interpolation (`Size`, `BorderRadius`, `EdgeInsets`, `double`, `Offset`, `Color`), `ScrollAvatarTransform` morphing, and `ScrollStaggeredBuilder` cascading delays.
- **Native Status Bar Synchronization** — Coordinates system status bar visibility with threshold-based hysteresis and serialized platform invocations, preserving Android 3-button/gesture navigation and iOS home indicators without safe area layout jumps.
- **Zero-Rebuild Performance** — Evaluated via granular `ValueNotifier` leaves. Scrolling the page triggers **0 widget element rebuilds** of body content.
- **Cross-Platform Compatibility** — Verified across all 7 target platforms (Android, iOS, iPadOS, macOS, Windows, Linux, and Web) with built-in reduced motion accessibility (`MediaQuery.disableAnimationsOf`).

---

## Architectural Layers

```
+-------------------------------------------------------------+
| System Status Bar (Hides on scroll-down, restores on scroll-up) |
+-------------------------------------------------------------+
| Layer 3: Reading Progress Indicator (Linear or Circular)    |
+-------------------------------------------------------------+
| Layer 2: Transparent Pinned Side Actions (SafeArea aligned) |
| [Pinned Leading]                     [Pinned Trailing]      |
| (Avatar -> Drawer)                   (Bell -> Profile)      |
|                                                             |
| +---------------------------------------------------------+ |
| | Layer 1: CustomScrollView                               | |
| | - Header Section (Scrolls naturally away with content)  | |
| | - Sticky Tab Bar (Pins beneath header on scroll)        | |
| | - Scrollable Body Content (Slivers, Lists, Grid, Cards) | |
| +---------------------------------------------------------+ |
+-------------------------------------------------------------+
| Layer 4: Auto-Hiding Bottom Bar & Scroll-Aware FAB          |
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

## Quick Start (Presets)

Construct an entire scroll-responsive screen with a single named constructor:

### 1. Material Preset
```dart
ScrollResponsiveScaffold.material(
  headerTitle: const Text('Material Scaffold'),
  headerSubtitle: const Text('Material 3 responsive design'),
  initialLeading: const Icon(Icons.menu),
  initialTrailing: const Icon(Icons.search),
  body: ListView.builder(
    itemCount: 40,
    itemBuilder: (context, index) => ListTile(title: Text('Item $index')),
  ),
);
```

### 2. Minimal Preset (Zero-Clutter)
```dart
ScrollResponsiveScaffold.minimal(
  headerTitle: const Text('Notes'),
  initialLeading: const Icon(Icons.arrow_back),
  body: const Center(child: Text('Minimal Clean Layout')),
);
```

### 3. iOS-Inspired Preset (Cupertino Physics & Smooth Collapse)
```dart
ScrollResponsiveScaffold.iosInspired(
  headerTitle: const Text('Settings'),
  initialLeading: const Icon(Icons.arrow_back_ios),
  body: const SettingsList(),
);
```

### 4. Collapsing Header Preset
```dart
ScrollResponsiveScaffold.collapsingHeader(
  headerTitle: const Text('Store Showcase'),
  body: const ProductGrid(),
);
```

### 5. Transparent Floating Preset
```dart
ScrollResponsiveScaffold.transparentFloating(
  headerTitle: const Text('Photo Gallery'),
  body: const PhotoFeed(),
);
```

### 6. Dashboard Preset (High-Density Metrics)
```dart
ScrollResponsiveScaffold.dashboard(
  headerTitle: const Text('Analytics'),
  initialLeading: const Icon(Icons.menu),
  initialTrailing: const Icon(Icons.notifications_none),
  body: const MetricsDashboard(),
);
```

---

## Core Scaffolding & Dual-State Transitions

```dart
ScrollResponsiveScaffold(
  // Pinned Left Action: Profile Avatar initially -> Drawer icon when scrolled
  initialLeading: const CircleAvatar(
    radius: 18,
    child: Text('AM'),
  ),
  scrolledLeading: const Icon(Icons.menu),

  // Pinned Right Action: Notification Bell initially -> Profile Avatar when scrolled
  initialTrailing: const Icon(Icons.notifications_none),
  scrolledTrailing: const CircleAvatar(
    radius: 18,
    child: Text('AM'),
  ),

  // Header scrolls away naturally
  headerTitle: const Text('My Workspace'),
  headerSubtitle: const Text('Learn • Build • Innovate'),

  // Navigation drawer opened automatically when tapping scrolled leading icon
  drawer: const AppNavigationDrawer(),

  // Independent thresholds & animations
  config: const ScrollResponsiveConfig(
    thresholds: ScrollThresholdConfig(
      leadingStartOffset: 20.0,
      leadingEndOffset: 80.0,
      trailingStartOffset: 40.0,
      trailingEndOffset: 100.0,
      statusBarHideOffset: 100.0,
      statusBarShowOffset: 50.0, // Hysteresis prevents edge jitter
    ),
    animation: ScrollAnimationConfig(
      curve: Curves.easeInOutCubic,
      enableFade: true,
      enableScale: true,
      enableSlide: true,
    ),
  ),

  // Real-time telemetry callback
  onScrollUpdate: (ScrollProgressDetails details) {
    // details.offset, details.leadingProgress, details.trailingProgress, details.isStatusBarHidden
  },

  body: const MyScrollableContent(),
);
```

---

## Modular Scroll Components Guide

### 1. `ScrollCollapsingHeader`
Smoothly transitions between `expandedHeight` and `collapsedHeight` with builder support, parallax, and optional sticky pinning.

```dart
ScrollCollapsingHeader(
  expandedHeight: 220.0,
  collapsedHeight: 64.0,
  pinned: true,
  builder: (context, progress) {
    return Container(
      decoration: BoxDecoration(color: Color.lerp(Colors.blue, Colors.indigo, progress)),
      child: Center(
        child: Text(
          'Collapsing Header',
          style: TextStyle(fontSize: 18.0 + (1.0 - progress) * 8.0, color: Colors.white),
        ),
      ),
    );
  },
);
```

### 2. `ScrollPullToExpandHeader`
Provides iOS-style rubber-band cover image expansion, profile header zoom, and pull-to-expand visual feedback.

```dart
ScrollPullToExpandHeader(
  expandedHeight: 250.0,
  stretchTriggerOffset: 120.0,
  onStretchTrigger: () async => fetchLatestProfileData(),
  child: Image.asset('assets/cover.jpg', fit: BoxFit.cover),
  content: const ProfileSummaryOverlay(),
);
```

### 3. `ScrollStickyTabBar`
Pins a tab bar directly beneath the header once scrolled past, adapting elevation and borders dynamically.

```dart
ScrollStickyTabBar(
  pinned: true,
  elevation: 3.0,
  child: TabBar(
    controller: _tabController,
    tabs: const [Tab(text: 'Overview'), Tab(text: 'Specs'), Tab(text: 'Reviews')],
  ),
);
```

### 4. `ScrollParallax`
High-performance parallax container that moves its child at a configurable speed multiplier relative to the viewport. Repaints via `Flow` and `FlowDelegate` at 60/120 FPS with **zero widget rebuilds**.

```dart
ScrollParallax(
  speedFactor: 0.5, // 0.5x speed background movement
  child: Image.asset('assets/landscape.jpg', fit: BoxFit.cover),
);
```

### 5. `ScrollProgressIndicator`
Reading progress bar tracking reading depth (0.0 to 1.0) with linear and circular display styles.

```dart
ScrollProgressIndicator(
  type: ProgressIndicatorType.linear,
  color: Colors.amber,
  height: 3.5,
);
```

### 6. `ScrollSectionReveal`
Triggers smooth entrance animations (fade, slide, scale) as content scrolls into the active viewport.

```dart
ScrollSectionReveal(
  slideOffset: const Offset(0.0, 30.0),
  staggerDelay: Duration(milliseconds: 50 * index),
  child: Card(child: ListTile(title: Text('Card #$index'))),
);
```

### 7. `ScrollToTopButton` & `ScrollAwareFab`
Auto-hides FAB when scrolling down; smoothly transitions into a scroll-to-top button.

```dart
ScrollToTopButton(
  scrollController: _scrollController,
  threshold: 300.0,
);
```

### 8. `ScrollAutoHideBottomBar`
Slides navigation bars offscreen during downward scrolls and restores them on upward scrolls.

```dart
ScrollAutoHideBottomBar(
  scrollController: _scrollController,
  child: BottomNavigationBar(...),
);
```

### 9. `ScrollExpandableFab`
Scroll-aware multi-action speed dial FAB with modal barrier and staggered animation.

```dart
ScrollExpandableFab(
  scrollController: _scrollController,
  icon: const Icon(Icons.add),
  children: [
    FabAction(icon: const Icon(Icons.edit), label: 'Draft', onTap: () => ...),
    FabAction(icon: const Icon(Icons.share), label: 'Share', onTap: () => ...),
  ],
);
```

---

## Ambient Scope & Context Extension

Any descendant widget in the subtree can access telemetry or trigger navigation without manual controller drilling:

```dart
// Check telemetry anywhere in child widgets
final telemetry = context.scrollResponsive;
print('Current offset: ${telemetry.currentOffset}');
print('Is at top: ${telemetry.isAtTop}');
print('Is header collapsed: ${telemetry.isHeaderCollapsed}');

// Trigger programmatic controls
context.scrollResponsive.scrollToTop();
context.scrollResponsive.scrollToBottom();
context.scrollResponsive.collapseHeader();
context.scrollResponsive.expandHeader();
context.scrollResponsive.scrollBy(150.0);
```

---

## Platform Support & Compatibility Matrix

| Platform | Scroll Header | Pinned Actions | Advanced Slivers | Native Status Bar | Notes |
|---|---|---|---|---|---|
| **Android** | ✅ Full | ✅ Full | ✅ Full | ✅ Native | Preserves 3-button or gesture pill navigation. Hysteresis prevents jitter. |
| **iOS** | ✅ Full | ✅ Full | ✅ Full | ✅ Native | Preserves Home Indicator. `preventContentJump` locks top safe padding. |
| **iPadOS** | ✅ Full | ✅ Full | ✅ Full | ✅ Native | Dynamically adapts to Stage Manager and Split View viewport resizing. |
| **macOS** | ✅ Full | ✅ Full | ✅ Full | ⚠️ Graceful | Window decorations owned by AppKit; status bar safely no-ops. Mouse wheel supported. |
| **Windows** | ✅ Full | ✅ Full | ✅ Full | ⚠️ Graceful | Window borders managed by DWM; status bar safely no-ops. Mouse wheel supported. |
| **Linux** | ✅ Full | ✅ Full | ✅ Full | ⚠️ Graceful | Window chrome managed by desktop environment; status bar safely no-ops. |
| **Web** | ✅ Full | ✅ Full | ✅ Full | ⚠️ Graceful | Browser chrome user-agent managed; status bar safely no-ops. Mouse wheel and touch supported. |

### Accessibility & Reduced Motion
Built-in support for `Semantics` and reduced-motion preferences (`MediaQuery.disableAnimationsOf(context)`). When reduced motion is requested, scale, slide, and rotation transitions are suppressed while maintaining full opacity cross-fade, semantic labels, and tap interactivity.

---

## Configuration Reference

### `ScrollResponsiveConfig`
| Property | Type | Default | Description |
|---|---|---|---|
| `pinSideActions` | `bool` | `true` | Pins side action icons. |
| `transparentActions` | `bool` | `true` | Enforces transparent action container backgrounds. |
| `hideStatusBarOnScroll` | `bool` | `true` | Enables scroll-responsive status bar hiding. |
| `enableReverseAnimation` | `bool` | `true` | Enables reverse animations on scroll up. |
| `thresholds` | `ScrollThresholdConfig` | `ScrollThresholdConfig()` | Independent scroll transition thresholds. |
| `animation` | `ScrollAnimationConfig` | `ScrollAnimationConfig()` | Animation timing, curves, scale, and slide settings. |
| `statusBar` | `StatusBarConfig` | `StatusBarConfig()` | Mobile status bar behavior and hysteresis settings. |
| `pinnedActions` | `PinnedActionsConfig` | `PinnedActionsConfig()` | Touch target sizes and layout padding. |

### `ScrollThresholdConfig`
| Property | Type | Default | Description |
|---|---|---|---|
| `leadingStartOffset` | `double` | `20.0` | Scroll offset (px) where left action starts transitioning. |
| `leadingEndOffset` | `double` | `80.0` | Scroll offset (px) where left action finishes transitioning. |
| `trailingStartOffset` | `double` | `20.0` | Scroll offset (px) where right action starts transitioning. |
| `trailingEndOffset` | `double` | `80.0` | Scroll offset (px) where right action finishes transitioning. |
| `statusBarHideOffset` | `double` | `100.0` | Scroll offset (px) to hide mobile status bar. |
| `statusBarShowOffset` | `double` | `50.0` | Scroll offset (px) to restore status bar (hysteresis deadband). |

---

## Running the Showcase Application

Run the multi-tab showcase application included in the repository:

```bash
cd example
flutter run
```

Features 5 interactive showcase tabs:
- **Tab 1: Core Header** — Dual icon swaps, live telemetry dashboard, and configuration controls.
- **Tab 2: Collapsing** — Smooth collapsing header with pinned sticky tab bar navigation.
- **Tab 3: Pull Expand** — Profile cover with iOS-style rubber-band zoom and spring-back physics.
- **Tab 4: Parallax** — Flow-based parallax banner, linear reading progress indicator, and section reveals.
- **Tab 5: Presets** — Live interactive preview of all 6 built-in scaffold presets.

---

## License

This project is licensed under the MIT License — see the [LICENSE](LICENSE) file for details.
