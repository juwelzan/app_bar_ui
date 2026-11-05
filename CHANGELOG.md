# Changelog

All notable changes to `app_bar_ui` will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.2.0] - 2026-11-06

### Added
- **Expanded Preset Catalog to 50 Ready-to-Use AppBar & Header Styles**:
  - Added 30 unique, battle-tested header design presets across three distinct new categories:
  - **Category B: Navigation & Layout Styles (Presets 21–30)**:
    - 21. `ScrollHeader.bottomAlignedTitle`: Bottom-aligned title layout with top-anchored navigation and actions.
    - 22. `ScrollHeader.asymmetric`: Asymmetric layout with unequal leading, expanded title, and compact trailing action cluster.
    - 23. `ScrollHeader.split`: Distinct visual separation dividing navigation/title from actions.
    - 24. `ScrollHeader.twoRow`: Dual-tier header with upper primary toolbar and lower secondary control/filter row.
    - 25. `ScrollHeader.multiAction`: Multi-action navigation header with automated overflow popup menu (`maxVisibleActions`).
    - 26. `ScrollHeader.compactIcon`: Ultra-minimal icon-centric toolbar for high spatial efficiency.
    - 27. `ScrollHeader.breadcrumb`: Deep hierarchical navigation breadcrumb trail with horizontal overflow scrolling.
    - 28. `ScrollHeader.backTitle`: Seamless inline back button joined directly with page title.
    - 29. `ScrollHeader.contextualSelection`: Multi-select contextual mode bar showing active selection count, close, and batch actions.
    - 30. `ScrollHeader.adaptiveNavigation`: Responsive layout switching automatically between compact mobile and expanded desktop bars.
  - **Category C: Visual & Creative Styles (Presets 31–40)**:
    - 31. `ScrollHeader.glass`: Translucent frosted glass effect with platform-safe fallback and blur.
    - 32. `ScrollHeader.blurredBackground`: Performance-isolated backdrop blur header with configurable `blurSigma`.
    - 33. `ScrollHeader.bordered`: Flat elevation-free aesthetic framed with clean hairline borders.
    - 34. `ScrollHeader.shadowElevated`: High-depth multi-stop drop shadow header with configurable elevation.
    - 35. `ScrollHeader.layered`: Tri-layer depth header featuring decorative back, middle, and front cards.
    - 36. `ScrollHeader.shapeMorphing`: Dynamic border radius and shape transformation driven by scroll offset (`isSliver = true`).
    - 37. `ScrollHeader.animatedGradient`: Ambient continuously shifting gradient background animation.
    - 38. `ScrollHeader.colorTransition`: Continuous background and foreground color interpolation on scroll (`isSliver = true`).
    - 39. `ScrollHeader.illustrated`: Collapsing banner with custom illustration, scale, and fade animations (`isSliver = true`).
    - 40. `ScrollHeader.edgeToEdge`: Margin-free full bleed layout extending cleanly behind status and navigation bars.
  - **Category D: Specialized AppBar Styles (Presets 41–50)**:
    - 41. `ScrollHeader.mediaPlayer`: Media playback header with album art, track details, and embedded play/skip controls.
    - 42. `ScrollHeader.shopping`: Storefront header with live shopping cart badge counter and quick search.
    - 43. `ScrollHeader.chat`: Messaging conversation header with contact avatar, online presence dot, and call actions.
    - 44. `ScrollHeader.detailPage`: Article/media detail header with Hero animation transition, contrast scrim, and floating pills (`isSliver = true`).
    - 45. `ScrollHeader.reading`: Editorial reader header with integrated horizontal reading progress indicator.
    - 46. `ScrollHeader.map`: Interactive location preview header with floating search card and location chips.
    - 47. `ScrollHeader.form`: State-aware form/editor header with cancel button and reactive Save action (`isDirty`).
    - 48. `ScrollHeader.wizard`: Multi-step setup header with segmented step progress indicators and step counter.
    - 49. `ScrollHeader.notificationCenter`: Notification inbox header with unread badge counter, "Mark all read", and filter pills.
    - 50. `ScrollHeader.customScrollLayout`: Completely customizable sliver persistent header layout delegate or builder (`isSliver = true`).
- **Dedicated Test Suites for All 6 Batches**:
  - `test/batch1_navigation_presets_test.dart`
  - `test/batch2_navigation_presets_test.dart`
  - `test/batch3_visual_presets_test.dart`
  - `test/batch4_visual_presets_test.dart`
  - `test/batch5_specialized_presets_test.dart`
  - `test/batch6_specialized_presets_test.dart`
  - Total package test count increased to 242 tests passing 100%.

### Fixed
- Fixed `ScrollResponsiveEngine` velocity preservation during drag end notifications.
- Resolved edge-case sub-pixel RenderFlex overflow in reading and custom builder headers on high-DPI displays.

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
