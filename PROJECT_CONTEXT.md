# PROJECT CONTEXT — Scroll-Responsive UI System

## 1. Project Overview & Objective

The objective of this project is to create a production-ready, reusable Flutter package (`app_bar_ui`) that provides a configurable **Scroll-Responsive Header System**.

The package solves a common UX challenge: combining the natural, fluid scrolling of a `SliverAppBar` with **independently pinned left and right side action icons** that remain fixed at the top of the viewport, undergo smooth visual transitions on scroll (e.g., Profile Avatar $\leftrightarrow$ Navigation Drawer, and Notification Bell $\leftrightarrow$ Profile Avatar), and coordinate seamlessly with mobile **System Status Bar visibility**.

The package is strictly application-agnostic (independent of any specific product or application) and encapsulates all scroll listeners, animation controllers, overlay layout, and status bar management internally so developers can import and configure it with zero boilerplate.

---

## 2. Environment & Tooling Analysis

| Item | Detected Specification | Notes |
|---|---|---|
| **Flutter SDK** | `3.50.0-1.0.pre-83` (Channel `stable`) | Modern Flutter runtime supporting Impeller, Material 3, and enhanced slivers |
| **Dart SDK** | `3.13.4` | Supports Dart 3 patterns, records, sealed classes, and modern null safety |
| **DevTools** | `2.60.0` | Profiling, widget inspector, and memory leak tracking |
| **Target Platforms** | Android, iOS, iPadOS, Web, macOS, Windows, Linux | Mobile provides native System UI control; Web/Desktop provide graceful fallbacks |
| **Package Name** | `app_bar_ui` | Standard Flutter plugin/package structure |

---

## 3. Dependency & Package Convention Inspection

- **Zero Unnecessary 3rd-Party Dependencies**: All scrolling, animations, overlays, and system UI operations are powered directly by the official Flutter framework (`package:flutter/widgets.dart`, `package:flutter/material.dart`, `package:flutter/services.dart`, and `package:flutter/rendering.dart`).
- **Core Dependencies**:
  - `flutter`: `sdk: flutter`
  - `plugin_platform_interface`: `^2.0.2` (preserves backward compatibility with plugin interfaces)
- **Developer Dependencies**:
  - `flutter_test`: `sdk: flutter`
  - `flutter_lints`: `^6.0.0`
- **Package Architecture**:
  - `lib/app_bar_ui.dart`: Public API barrel export.
  - `lib/src/models/`: Strongly typed immutable configuration models.
  - `lib/src/engine/`: Low-level state and system UI managers (`StatusBarManager`).
  - `lib/src/widgets/`: Modular, reusable UI components (`ScrollResponsiveScaffold`, `ScrollResponsiveHeader`, `PinnedActionButton`).
  - `test/`: Isolated unit and widget test suites.
  - `example/`: Standalone interactive showcase application with live telemetry.

---

## 4. Platform Limitations & Compatibility Matrix

| Platform | Scroll Header | Pinned Actions | Dual-State Transitions | Native Status Bar Control | Notes & Native Constraints |
|---|---|---|---|---|---|
| **Android** | ✅ Full | ✅ Full | ✅ Full | ✅ Full | Uses `SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [SystemUiOverlay.bottom])`. Preserves gesture navigation / bottom nav bar. Avoids per-frame calls using hysteresis. |
| **iOS / iPadOS** | ✅ Full | ✅ Full | ✅ Full | ✅ Full | Uses `SystemChrome` to toggle `UIStatusBar`. Preserves home indicator. Content jump prevention ensures notch/safe insets don't collapse abruptly. |
| **Web** | ✅ Full | ✅ Full | ✅ Full | ⚠️ N/A | Browser chrome (URL bar, tabs) cannot be toggled via `SystemChrome`. Graceful no-op fallback without errors. |
| **macOS** | ✅ Full | ✅ Full | ✅ Full | ⚠️ N/A | Desktop window title bars are managed by the window manager. Graceful fallback. |
| **Windows** | ✅ Full | ✅ Full | ✅ Full | ⚠️ N/A | Desktop window frame is managed by Win32/DWM. Graceful fallback. |
| **Linux** | ✅ Full | ✅ Full | ✅ Full | ⚠️ N/A | X11/Wayland window decorations. Graceful fallback. |

---

## 5. Key Constraints & Guarantees

1. **Zero Layout Shifts**: The pinned side action buttons maintain fixed bounding boxes (e.g. $48 \times 48\text{ px}$) during transitions, ensuring touch targets never jump.
2. **Transparent Background**: Pinned icons have no cards, elevation, shadows, borders, or blur.
3. **Touch Pass-Through**: The center header and body remain completely touch-interactive. Only the action button hitboxes intercept touches.
4. **Content Jump Prevention**: Caches top safe insets so hiding the status bar on mobile does not cause the layout to snap upward by 24–44px.
5. **Rebuild Efficiency**: Only the small pinned buttons re-render during scroll animations; the scrollable body and header do not suffer unnecessary rebuilds.

