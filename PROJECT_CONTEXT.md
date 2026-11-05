# PROJECT CONTEXT — Production-Ready Scroll-Driven UI Framework

## 1. Project Overview & Mission

`app_bar_ui` is a high-performance, modular, and production-ready **Scroll-Driven UI Framework** for Flutter applications.

### Primary Problem Statement
Modern mobile and desktop applications require sophisticated scroll-driven user experiences:
1. Natural scrolling headers where branding and greetings scroll away with page content.
2. Independently pinned action controls (e.g., Profile Avatar, Navigation Drawer, Notification Bell) that remain anchored at the top without permanent, opaque AppBar backgrounds.
3. Fluid, reversible icon and avatar transformations driven by scroll progress.
4. Intelligent native System Status Bar hiding and restoration with directional hysteresis to prevent visual flickering.
5. Coordinated auxiliary components: sticky tab navigation, auto-hiding floating action buttons (FAB), auto-hiding bottom navigation bars, parallax viewports, scroll-snapping boundaries, reading progress indicators, and viewport-triggered section reveals.

### Core Engineering Principles
- **Zero Unnecessary Lag & Jank**: Target solid 60 FPS and 120 FPS high-refresh rates across all supported devices.
- **Selective Localized Rebuilds**: No whole-tree rebuilds during scroll updates. All transitions are powered by targeted `ValueListenableBuilder`s, `FlowDelegate`s, and `CurvedAnimation`s.
- **Memory Safety & Lifecycle Integrity**: Strict single-owner controller lifecycle. Zero listener leaks, stream leaks, or un-disposed tickers.
- **Developer-Friendly Ergonomics**: Sensible pre-configured presets (`material`, `minimal`, `iosInspired`, `collapsingHeader`, `transparentFloating`, `dashboard`, `custom`) alongside deeply customizable granular configuration objects.
- **Zero Third-Party Dependency Bloat**: 100% built upon the native Flutter SDK (`flutter/widgets`, `flutter/material`, `flutter/rendering`, `flutter/services`).

---

## 2. Environment & Tooling Audit

| Environment Dimension | Specification | Verification Details |
|---|---|---|
| **Flutter SDK** | `3.50.0-1.0.pre-83` (Channel `stable`) | Supports Impeller rendering engine, Material 3, and advanced slivers |
| **Dart SDK** | `3.13.4` | Modern null-safety, Dart 3 patterns, records, sealed classes, switch expressions |
| **Operating System** | macOS (Darwin 24.3.0) / Cross-platform | Validated on Unix/macOS environment |
| **DevTools** | `2.60.0` | Frame render timing, jank analysis, rebuild counters, memory snapshots |
| **Package Structure** | Modular Flutter Package / Plugin | `lib/` root with `src/models/`, `src/engine/`, `src/animations/`, `src/widgets/` |
| **Linter Configuration** | `package:flutter_lints/flutter.yaml` | Strict analysis rules enforced; 0 warnings, 0 info lints |

---

## 3. Dependency & Module Architecture

### Production Dependencies
```yaml
dependencies:
  flutter:
    sdk: flutter
  plugin_platform_interface: ^2.0.2
```
*No external third-party packages (no `provider`, no `get`, no `bloc`, no `rxdart`) are required or used. The entire engine leverages Flutter's built-in primitives.*

### Development Dependencies
```yaml
dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^6.0.0
```

### Module Structure
```
lib/
├── app_bar_ui.dart                   # Public API barrel exports
├── src/
│   ├── models/                       # Immutable configuration models
│   │   ├── scroll_responsive_config.dart   # Core thresholds, animations, status bar, pinned actions
│   │   ├── visibility_config.dart         # Smart visibility targets and rules
│   │   └── scroll_responsive_presets.dart # Pre-configured architecture presets
│   ├── engine/                       # Low-level scroll, visibility, and system UI controllers
│   │   ├── scroll_responsive_engine.dart     # Scroll tracking, metrics, hysteresis, direction
│   │   ├── scroll_responsive_controller.dart # Unified programmatic controller extending ScrollController
│   │   ├── smart_visibility_controller.dart  # Centralized multi-target visibility streams
│   │   ├── status_bar_manager.dart           # Native System UI & SystemChrome coordinator
│   │   └── scroll_snap_engine.dart           # Scroll snapping physics and programmatic engine
│   ├── animations/                   # Shared scroll-linked animation system
│   │   ├── scroll_driven_animation.dart      # ScrollRange<T>, ScrollTransform (opacity, scale, slide, rotation)
│   │   ├── scroll_color_tween.dart           # ScrollColorTransition (colors & gradients)
│   │   └── scroll_morph_builder.dart         # ScrollMorphBuilder (midpoint switching & cross-fade)
│   ├── presets/                      # 20 Ready-To-Use AppBar & Header Presets
│   │   ├── scroll_header.dart                # Master unified ScrollHeader entrypoint
│   │   ├── scroll_header_preset.dart         # Enum of all 20 presets with metadata
│   │   ├── scroll_header_style.dart          # Styling, padding, and geometry model
│   │   └── headers/                          # Modular preset implementations
│   │       ├── base_header.dart              # Base delegate & HeaderContainer
│   │       ├── minimal_headers.dart          # Minimal, Transparent, Floating, CenterTitle
│   │       ├── standard_headers.dart         # Material, iOS, Gradient, ImageBackground
│   │       ├── collapsing_headers.dart       # LargeTitle, FlexibleSpace, Collapsing, CompactScroll
│   │       ├── specialized_headers.dart      # Profile, Dashboard, Search, Segmented, StickyTab
│   │       └── dynamic_headers.dart          # Parallax, SideActionTransition, CustomBuilder
│   └── widgets/                      # Reusable public components
│       ├── sliver_widget_marker.dart         # Sliver marker mixin for auto Box/Sliver routing
│       ├── scroll_responsive_scaffold.dart   # Master orchestrator scaffold
│       ├── scroll_responsive_header.dart     # Scroll-away content header
│       ├── pinned_action_button.dart         # Pinned left/right dual-state buttons
│       ├── scroll_collapsing_header.dart     # Collapsing hero/toolbar sliver
│       ├── scroll_pull_to_expand_header.dart # Rubber-band pull-to-expand overscroll sliver
│       ├── scroll_sticky_tab_bar.dart        # Persistent sticky tab bar sliver
│       ├── scroll_aware_fab.dart             # Auto-hiding / morphing FAB
│       ├── scroll_auto_hide_bottom_bar.dart  # Auto-hiding bottom navigation bar
│       ├── scroll_parallax.dart              # Flow-based high-performance parallax container
│       ├── scroll_progress_indicator.dart    # Reading progress bar (linear & circular)
│       └── scroll_section_reveal.dart        # Viewport-entry animated section reveal
```

---

## 4. Platform Compatibility & System Capabilities Matrix

| Platform | Core Scroll & Pinned Actions | Advanced Slivers & Sticky Tabs | Parallax & Progress | Native Status Bar Control | Platform Constraints & Graceful Fallbacks |
|---|---|---|---|---|---|
| **Android** | ✅ Full | ✅ Full | ✅ Full | ✅ Full | Controls native status bar via `SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [SystemUiOverlay.bottom])`. Preserves native Android 3-button or gesture pill navigation. Hysteresis eliminates threshold jitter. |
| **iOS** | ✅ Full | ✅ Full | ✅ Full | ✅ Full | Seamlessly hides/restores `UIStatusBar` while preserving Home Indicator. `preventContentJump` locks safe area top insets to prevent awkward notch layout shifts. |
| **iPadOS** | ✅ Full | ✅ Full | ✅ Full | ✅ Full | Adapts to Split View and Stage Manager viewport size alterations cleanly. |
| **macOS** | ✅ Full | ✅ Full | ✅ Full | ⚠️ N/A (Graceful) | Desktop window title bars are owned by AppKit/macOS WindowServer. Status bar calls safely no-op without exceptions. |
| **Windows** | ✅ Full | ✅ Full | ✅ Full | ⚠️ N/A (Graceful) | DWM window borders and title bars are Win32 system-managed. Status bar calls safely no-op. |
| **Linux** | ✅ Full | ✅ Full | ✅ Full | ⚠️ N/A (Graceful) | Wayland/X11 window decorations are desktop-managed. Status bar calls safely no-op. |
| **Web** | ✅ Full | ✅ Full | ✅ Full | ⚠️ N/A (Graceful) | Browser chrome (URL bar, tabs) is controlled by the user agent. Status bar calls safely no-op. Mouse wheel and touch interactions supported natively. |

---

## 5. Non-Negotiable Architectural Guarantees

1. **Strictly Agnostic**: No app-specific domain logic, hardcoded strings, brand colors, or mock images.
2. **Transparent Overlay Architecture**: Pinned side actions have zero background, zero elevation, zero border, and zero blur unless explicitly customized by the developer. Touches in the center and body pass directly to scrollable content.
3. **Accessibility Integration**: Built-in support for `Semantics` and reduced-motion preferences (`MediaQuery.disableAnimationsOf(context)`). When reduced motion is requested, scale, slide, and rotation transitions are safely suppressed while maintaining full interactivity.
4. **Hysteresis Gating**: Separate hide thresholds (`statusBarHideOffset`) and show thresholds (`statusBarShowOffset`) prevent infinite toggle loops when scrolling near boundaries.
5. **Serialization Queue**: Asynchronous system calls (`SystemChrome`) are processed sequentially via a task lock queue, avoiding platform race conditions during rapid velocity flings.
