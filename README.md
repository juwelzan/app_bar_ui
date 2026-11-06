# app_bar_ui

[![pub package](https://img.shields.io/badge/pub-v2.0.0-blue.svg)](https://pub.dev/packages/app_bar_ui)
[![Flutter](https://img.shields.io/badge/Flutter-3.3+-02569B?logo=flutter)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.0+-0175C2?logo=dart)](https://dart.dev)
[![Tests Passing](https://img.shields.io/badge/tests-297%20passed-success.svg)](https://github.com/example/app_bar_ui)
[![License: MIT](https://img.shields.io/badge/license-MIT-purple.svg)](https://opensource.org/licenses/MIT)
[![Platforms](https://img.shields.io/badge/platforms-Android%20%7C%20iOS%20%7C%20iPadOS%20%7C%20macOS%20%7C%20Windows%20%7C%20Linux%20%7C%20Web-brightgreen.svg)](https://flutter.dev)

A next-generation, high-performance Flutter navigation engine providing **20+ genuinely autonomous AppBar Design System Models**, a unified zero-boilerplate **`AppBarEngine`** entry point, and rock-solid **120 FPS pure-math scroll physics** with zero unnecessary body element rebuilds.

---

## 🌟 What Makes app_bar_ui 2.0 Unique?

Traditional Flutter app bars are typically identical boxes with minor variations in background color or icon placement. **app_bar_ui changes this entirely**:

1. **20 Genuinely Autonomous Models** — Switching between models doesn't just restyle a title; it transforms the **entire layout structure, gesture handling, scroll mechanics, spatial depth, and animation timeline**.
2. **Single Public Entry Point (`AppBarEngine`)** — Developers interact with one unified API supporting both **Simple Mode** (direct parameters with zero boilerplate) and **Advanced Mode** (strongly-typed model configurations).
3. **Pure Math Header Physics** — Geometry, scaling, opacities, and clipping are computed strictly from scroll offsets (`shrinkOffset / maxExtent`). No continuous `setState`, no rebuild cascades, and 0 body widget rebuilds during scroll.
4. **Zero-Leak Runtime Model Switching** — Switch models dynamically at runtime (e.g., during responsive screen rotation or user state change). Previous animation tickers and states are cleanly disposed with zero memory leaks.
5. **Native Accessibility (A11Y)** — First-class support for `MediaQuery.disableAnimationsOf(context)` across all 20 models, immediately providing clean, comfortable static layouts for users who prefer reduced motion.

---

## 🚀 Quick Start

### 1. Simple Mode (Zero Boilerplate)

Build any autonomous AppBar model in seconds using direct parameters:

```dart
import 'package:flutter/material.dart';
import 'package:app_bar_ui/app_bar_ui.dart';

class MyScreen extends StatelessWidget {
  const MyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBarEngine(
      model: AppBarModel.floatingIsland,
      title: 'Flight Tracker',
      subtitle: 'Gate B12 • On Time',
      onLeadingTap: () => Navigator.pop(context),
      actions: [
        IconButton(
          icon: const Icon(Icons.share_outlined),
          onPressed: () {},
        ),
      ],
      body: ListView.builder(
        itemCount: 30,
        itemBuilder: (context, index) => ListTile(title: Text('Passenger $index')),
      ),
    );
  }
}
```

### 2. Sliver Mode (CustomScrollView Integration)

Embed any model directly inside a sliver-based scroll viewport:

```dart
CustomScrollView(
  slivers: [
    AppBarEngine.sliver(
      model: AppBarModel.traditionalStructured,
      title: 'Enterprise Nexus',
      subtitle: 'Production Cluster',
      actions: [
        IconButton(icon: const Icon(Icons.tune), onPressed: () {}),
      ],
    ),
    SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) => ListTile(title: Text('Data Item $index')),
        childCount: 40,
      ),
    ),
  ],
)
```

---

## 🎨 Advanced Mode (Typed Configurations)

Every autonomous model possesses its own strongly-typed configuration class exposing fine-grained visual, structural, and behavioral parameters. Pass the configuration directly to `configuration:` without boilerplate wrappers:

```dart
AppBarEngine(
  model: AppBarModel.fullScreenHero,
  configuration: FullScreenHeroConfig(
    viewportHeight: 400.0,
    collapsedHeight: 64.0,
    headline: 'Cinematic Odyssey',
    tagline: 'An IMAX Original Documentary',
    background: Image.network(
      'https://images.unsplash.com/photo-1518709268805-4e9042af9f23',
      fit: BoxFit.cover,
    ),
    headlineCurve: Curves.easeOutCubic,
    scrimColor: Colors.black.withOpacity(0.4),
  ),
  body: const MovieOverviewBody(),
)
```

---

## ⚡ Runtime Model Switching (Zero Resource Leaks)

Switch between models on the fly with animated cross-fades or slide transitions using `AppBarController`:

```dart
class DynamicShowcase extends StatefulWidget {
  const DynamicShowcase({super.key});

  @override
  State<DynamicShowcase> createState() => _DynamicShowcaseState();
}

class _DynamicShowcaseState extends State<DynamicShowcase> {
  final _controller = AppBarController(
    initialModel: AppBarModel.traditionalStructured,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _switchToCreativeDeck() {
    // Dynamically transforms the AppBar experience with zero state leakage
    _controller.changeModel(
      AppBarModel.cardDeckStacked,
      transition: const ModelTransitionSpec(
        type: ModelTransitionType.fade,
        duration: Duration(milliseconds: 350),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppBarEngine(
      controller: _controller,
      title: 'Interactive Studio',
      body: Center(
        child: ElevatedButton(
          onPressed: _switchToCreativeDeck,
          child: const Text('Switch to Card Deck Model'),
        ),
      ),
    );
  }
}
```

---

## 🏛️ The 21 Distinct AppBar Models

| # | Model Enum | Visual Structure | Scroll Mechanics | Best For |
|---|---|---|---|---|
| **0** | `classic` | Standard Material / Cupertino toolbar | Pinned or collapsible baseline header | Clean, conventional utility screens |
| **1** | `traditionalStructured` | 3-tier layout: Organization, Title/Status, Sticky Tabs | Collapses upper tiers into a compact pinned bar | Enterprise dashboards, multi-tab portals |
| **2** | `fullScreenHero` | Immersive full-viewport hero banner | Exponential parallax scale & optical scrim fade | Media landing, travel, articles |
| **3** | `floatingIsland` | Detached rounded capsule card with outer margins | Shrinks horizontally & elevates on scroll | Consumer apps, music playback, modern SaaS |
| **4** | `immersiveSpatial` | 3-layer differential depth stage | Foreground, midground, background parallax with focal blur | Gaming profiles, visual portfolios, 3D art |
| **5** | `multiPanelSplitCurtain` | Lateral split panels (Identity left, Actions right) | Panels slide inward horizontally to fuse into a pill toolbar | Dual-action hubs, control centers, admin consoles |
| **6** | `spatial3DFlip` | 3D perspective front card & back toolbar | Flips 180° around X-axis as scroll threshold triggers | Finance wallets, secure credential cards |
| **7** | `verticalRailTransform` | Horizontal app bar transforming into vertical side rail | Morphs into pinned left navigation rail on scroll or large screens | Wide tablets, desktop layouts, productivity |
| **8** | `radialDial` | Polar coordinate dial with orbital action nodes | Orbital nodes converge along trigonometric arc into compact cluster | Creative tools, camera controls, gesture hubs |
| **9** | `editorialTypography` | Elegant newspaper masthead, issue date, headline | Masthead fades while headline collapses with reading progress | Long-form journalism, blogs, documentation |
| **10** | `cardDeckStacked` | Multi-card stacked deck with depth perspective | Cards compress and stack into compact tab strip | Passbooks, loyalty cards, payment wallets |
| **11** | `minimalistMicroBar` | Monospace breadcrumb trail, live ETA, status dot | Auto-hides on velocity downward flick; reveals on tap | Code viewers, terminal monitors, focused reading |
| **12** | `profileIdentity` | Large hero circular avatar, bio, badge counters | Avatar shrinks along Bezier path to dock inline in pinned toolbar | Social profiles, author pages, user bios |
| **13** | `expandableControlCenter` | 2x3 interactive toggle tile grid (WiFi, Dark Mode, etc.) | Collapses into horizontal status icon strip in pinned bar | Device control, smart home, quick settings |
| **14** | `timelineScrubberNav` | Interactive milestone timeline with progress nodes | Scrubbing scrolls viewport; scrolling updates active timeline node | Project roadmaps, delivery trackers, event schedules |
| **15** | `searchSpotlight` | Centered expanded search field with instant chips | Search field contracts into slim bar while chips scroll away | E-commerce, directory discovery, catalog exploration |
| **16** | `gestureElasticCanvas` | Elastic oversized pull-to-refresh & metrics canvas | Overscroll expands elastic canvas with live spring settling | Financial tickers, live telemetry, fitness dashboards |
| **17** | `adaptiveBreakpointNav` | Responsive engine adapting between 3 form-factor layouts | Seamlessly morphs layout across 600px and 840px boundaries | Multi-device apps, responsive web, tablets |
| **18** | `contextFocalSwapNav` | Multi-domain focal context switch bar (Personal/Business) | Swapping domain updates toolbar styling and actions instantly | Multi-tenant apps, banking, workspace switchers |
| **19** | `liquidWaveMorphNav` | Dynamic Bezier fluid wave boundary | Sinusoidal crest dampens and flattens out smoothly on scroll | Wellness apps, water trackers, playful consumer UI |
| **20** | `developerCustomCanvas` | Unconstrained custom canvas with blueprint inspection | Developer provides completely bespoke sliver delegate or builder | Experimental layouts, custom brand identities |

---

## 🛠️ Level 3 Customization: Developer Custom Canvas

When you require layout mechanics that go beyond pre-built parameters, Model 20 (`developerCustomCanvas`) gives you absolute freedom while maintaining integration with the `AppBarEngine`:

```dart
AppBarEngine(
  model: AppBarModel.developerCustomCanvas,
  configuration: DeveloperCustomCanvasConfig(
    expandedHeight: 240.0,
    collapsedHeight: 60.0,
    showDebugGrid: false,
    customSliverBuilder: (context, shrinkOffset, progress) {
      return Container(
        alignment: Alignment.center,
        color: Color.lerp(Colors.indigo, Colors.teal, progress),
        child: Text(
          'Scroll Progress: ${(progress * 100).toStringAsFixed(0)}%',
          style: const TextStyle(color: Colors.white, fontSize: 20),
        ),
      );
    },
  ),
  body: const MyListContent(),
)
```

---

## ♿ Accessibility & Reduced Motion

All 20 models rigorously respect system accessibility preferences:

```dart
// Automatically handled internally across all 20 models:
final isReducedMotion = MediaQuery.disableAnimationsOf(context);
```

When reduced motion is enabled:
- Parallax depth calculations, 3D rotations, and orbital transforms are deactivated.
- Continuous Bezier morphs snap directly to comfortable, accessible static states.
- Color shifts and text hierarchies remain completely clear and legible.

---

## 📊 Performance & Invariants

- **Impeller & Skia Ready** — Hardware accelerated through `Transform` and `SliverPersistentHeaderDelegate`.
- **Zero Element Rebuilds** — Body content is completely decoupled from scroll updates.
- **Pure Math Animations** — All layout geometries derive synchronously from `shrinkOffset` with zero frame-delay ticker latency.
- **Cross-Platform Verified** — Validated on macOS, iOS, Android, Linux, Windows, and Web.

---

## 📄 License

This project is licensed under the MIT License — see the [LICENSE](LICENSE) file for details.
