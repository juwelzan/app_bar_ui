# Changelog

All notable changes to `app_bar_ui` will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2026-11-05

### Added
- **Core Scroll Engine & Scaffold (`ScrollResponsiveScaffold`)**:
  - Full-featured scroll-responsive scaffold combining naturally scrolling headers with pinned transparent side actions.
  - Granular `ValueNotifier` event publishing ensuring zero whole-tree body rebuilds during continuous scrolling.
  - Native state preservation via `restorationId` for `ScrollResponsiveScaffold` and `CustomScrollView`.
- **Dual-State Synchronized Icon Transitions**:
  - Independent left and right action icon transition thresholds (`leadingStartOffset`, `leadingEndOffset`, `trailingStartOffset`, `trailingEndOffset`).
  - Synchronized opacity fade, subtle scale (`minScale` to `maxScale`), and directional fractional translation (`slideOffset`).
  - Automatic hit-test swapping: initial actions accept taps below 0.5 progress; scrolled actions accept taps at or above 0.5 progress.
  - Transparent overlay architecture: zero forced backgrounds, borders, or elevations on pinned actions.
- **7 Configurable Scaffold Presets**:
  - Named constructors on `ScrollResponsiveScaffold`: `.material()`, `.minimal()`, `.iosInspired()`, `.collapsingHeader()`, `.transparentFloating()`, `.dashboard()`, and `.custom()`.
  - Strict developer widget preservation: custom widgets and action icons are never overridden with unwanted styling.
- **12 Modular Scroll Components**:
  - `ScrollCollapsingHeader`: Smooth collapsing persistent header with custom builder and elevation transition.
  - `ScrollPullToExpandHeader`: Rubber-band zoom and stretch overscroll header.
  - `ScrollStickyHeader`: Header pinning with border and elevation changes when stuck.
  - `ScrollStickyTabBar`: Pinned tab bar adapting borders and elevation when stuck.
  - `ScrollAwareFab`: Scroll-direction aware auto-hiding FAB.
  - `ScrollAutoHideBottomBar`: Auto-hiding bottom navigation bar with fractional slide transitions.
  - `ScrollParallax`: High-performance 60/120 FPS parallax container using `Flow` and `FlowDelegate` with zero element rebuilds.
  - `ScrollProgressIndicator`: Linear and circular reading/scroll depth progress indicators.
  - `ScrollSectionReveal`: Viewport-entry animated reveal with customizable slide offsets and staggered cascade delays.
  - `ScrollToTopButton`: Threshold-aware button animating back to scroll position 0.
  - `ScrollPositionIndicator`: Minimalist scroll thumb / depth tracker.
  - `ScrollAwareSideActions`: Floating contextual edge action buttons.
  - `ScrollExpandableFab`: Speed-dial multi-action FAB with modal barrier and staggered child buttons.
  - `ScrollPageIndicator`: Scrollable dot indicators synchronized with page views.
- **Unified Animation Engine**:
  - Universal `ScrollRange<T>` supporting `double`, `Offset`, `Size`, `BorderRadius`, `EdgeInsets`, and `Color`.
  - `ScrollAvatarTransform`: Smoothly morphs avatars from large circular headers to compact rounded toolbar rectangles.
  - `ScrollStaggeredBuilder`: Cascading list item animations with programmatic delay offsets.
  - `ScrollAnimatedBuilder`: Multi-property declarative animation snapshot builder.
  - `ScrollTransform`: Declarative transform widget honoring reduced-motion accessibility preferences.
- **Smart Visibility Controller (`SmartVisibilityController`)**:
  - Multi-target visibility management with priority ordering.
  - Target locking mechanism (`lock()`, `unlock()`, `isLocked()`) preventing scroll-driven changes during modal states.
  - Manual overrides (`show()`, `hide()`, `toggle()`, `showAll()`, `hideAll()`).
  - Declarative transition widget (`SmartVisibilityTransition`).
- **Developer-Friendly API & Ambient Scope**:
  - `ScrollResponsiveScope` inherited widget wrapping scaffold.
  - `BuildContext.scrollResponsive` extension providing ambient telemetry (`currentOffset`, `isAtTop`, `isAtBottom`, `isHeaderCollapsed`, `isHeaderExpanded`) and programmatic controls (`scrollToTop()`, `scrollToBottom()`, `collapseHeader()`, `expandHeader()`, `scrollBy()`, `scrollToItem()`).
- **Native System UI Management (`StatusBarManager`)**:
  - Threshold-based hysteresis (`statusBarHideOffset` vs `statusBarShowOffset`) eliminating boundary jitter.
  - Asynchronous serialization task queue preventing platform race conditions during rapid velocity flings.
  - Android navigation bar preservation: keeps 3-button navigation and gesture pill visible via `SystemUiMode.manual` and `SystemUiOverlay.bottom`.
  - iOS Home indicator preservation and `preventContentJump` top safe area inset locking.
  - Route transition (`RouteObserver` / `RouteAware`) and app lifecycle (`WidgetsBindingObserver`) restoration.
  - Graceful no-op fallback on Web, macOS, Windows, and Linux.
- **Accessibility & Reduced Motion**:
  - Built-in `Semantics` on pinned actions and buttons.
  - Integration with `MediaQuery.disableAnimationsOf(context)`: automatically suppresses scale, slide, and rotation transitions while preserving full interactivity.
- **Comprehensive Testing & Validation**:
  - 173 automated tests passed across 10 test suites with 100% pass rate.
  - Performance audit verifying zero whole-tree body rebuilds and FlowDelegate paint transforms.
  - Cross-platform test suite validating Android, iOS, iPadOS, macOS, Windows, Linux, and Web compatibility.
- **Interactive Multi-Tab Showcase App**:
  - 5-tab example application demonstrating core headers, collapsing headers, pull-to-expand covers, parallax containers, and preset switching.
