# Changelog

All notable changes to `app_bar_ui` will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.1.0] - 2026-11-06

### Added
- **20 Ready-to-Use AppBar & Header Design Presets**:
  - `ScrollHeader` master widget with 20 named constructors and `ScrollHeaderPreset` enumeration:
    1. `ScrollHeader.minimal`: Flat, clean, low visual weight header with subtle divider.
    2. `ScrollHeader.transparent`: Fully transparent header overlaying hero content.
    3. `ScrollHeader.floating`: Rounded "island" card floating above content with margin and shadow.
    4. `ScrollHeader.material`: Material Design 3 style with tonal surface colors and elevation tint.
    5. `ScrollHeader.ios`: Cupertino navigation style with backdrop blur, hairline divider, and SF-inspired layout.
    6. `ScrollHeader.centerTitle`: Symmetrically balanced header with centered title and action slots.
    7. `ScrollHeader.largeTitle`: Collapsing typography header transitioning from large display title to inline title.
    8. `ScrollHeader.flexibleSpace`: Expandable header accommodating arbitrary custom widgets in flexible space.
    9. `ScrollHeader.collapsing`: Smooth collapsing persistent header transitioning from hero banner down to toolbar.
    10. `ScrollHeader.parallax`: 60/120 FPS background parallax moving at configurable speed factor via `FlowDelegate` with zero rebuilds.
    11. `ScrollHeader.gradient`: Multi-stop linear or radial gradient background with scroll-under shift.
    12. `ScrollHeader.image`: High-resolution image background with configurable dark/light scrim overlay gradient.
    13. `ScrollHeader.profile`: Profile cover with avatar, user name, role/handle badge, stats row, and actions.
    14. `ScrollHeader.dashboard`: High-density dashboard with greeting, user info, metrics row, and quick actions.
    15. `ScrollHeader.search`: Integrated search field with search icon, clear button, and real-time query callbacks.
    16. `ScrollHeader.segmented`: Header with an embedded segmented button or pill category selector.
    17. `ScrollHeader.stickyTab`: Persistent tab bar pinned beneath header with tab indicator and border transition.
    18. `ScrollHeader.compactScroll`: Space-saving header collapsing into a micro-bar at the slightest scroll.
    19. `ScrollHeader.sideActionTransition`: Dual-state synchronized icon swapping based on scroll state with independent thresholds.
    20. `ScrollHeader.customBuilder`: 100% developer-controlled custom layout using a builder callback receiving real-time progress.
- **Sliver vs Box Invariant Detection (`SliverWidgetMarker`)**:
  - `SliverWidgetMarker` mixin allowing `ScrollResponsiveScaffold` to automatically differentiate Box headers (requiring `SliverToBoxAdapter`) from Sliver headers (e.g. `Collapsing`, `LargeTitle`, `Parallax`, `StickyTab`), eliminating runtime `RenderSliver was added to RenderBox` crashes.
- **Header Customization Model (`ScrollHeaderStyle`)**:
  - Comprehensive styling model controlling background colors, elevations, typography, border radii, blur sigma, padding, margin, divider colors, and animation transitions.
- **Interactive 20-Preset Gallery in Example Application**:
  - Tab 5 expanded with interactive cards for all 20 presets and full-screen `PresetDetailScreen` with live scroll telemetry.
- **Comprehensive Preset Test Suite (`test/header_presets_test.dart`)**:
  - 27 dedicated tests verifying layout correctness, scroll collapse/expansion, custom widget preservation, and accessibility across all 20 presets.

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
