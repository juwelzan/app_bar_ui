# TESTING GUIDELINES — Quality Assurance & Verification Protocols

## 1. Testing Philosophy & Ground Rules

1. **Empirical Evidence Only**: Never present assumptions, estimates, or unverified claims as test results.
2. **Comprehensive Coverage**: Every component, threshold calculation, animation curve, lifecycle transition, and fallback mechanism must have automated test coverage.
3. **No Flaky Tests**: Tests must avoid arbitrary wall-clock `sleep()` or timer polling. Use `tester.pump()`, `tester.pumpAndSettle()`, or deterministic mock bindings.
4. **Zero Regressions**: Any modification to existing modules must pass the complete test suite before proceeding.

---

## 2. Test Architecture & Directory Structure

```
test/
├── scroll_responsive_config_test.dart         # Unit tests: Thresholds, animations, status bar, pinned actions
├── scroll_responsive_engine_test.dart         # Unit tests: Position tracking, velocity, direction, axis isolation
├── status_bar_manager_test.dart               # Unit & Channel tests: Hysteresis, platform checks, serialization queue
├── pinned_action_button_test.dart             # Widget tests: Fixed touch targets, midpoint hit-testing, transparency
├── scroll_responsive_header_test.dart         # Widget tests: Content rendering, alignment, custom actions
├── scroll_responsive_scaffold_test.dart       # Widget & Lifecycle tests: Scroll transitions, route observer, disposal
├── smart_visibility_and_animation_test.dart   # Animation & Visibility tests: ScrollRange, ScrollTransform, morphing
├── scroll_components_test.dart                # Component tests: Collapsing header, sticky tab bar, FAB, bottom bar
├── scroll_parallax_snap_reveal_test.dart      # Viewport tests: Flow parallax, snapping engine, progress, reveals
├── presets_and_controls_test.dart             # Control tests: Presets, programmatic controls, scaffold slots
└── full_package_integration_test.dart         # End-to-end integration tests: Route push/pop, lifecycle resume, callbacks
```

---

## 3. Test Suites & Verification Criteria

### 3.1 Unit Testing Protocols
- **Configuration Boundary Assertions**:
  - `startOffset <= endOffset` must throw `AssertionError` if violated.
  - `statusBarShowOffset <= statusBarHideOffset` must throw `AssertionError`.
  - `expandedHeight >= collapsedHeight` must throw `AssertionError`.
  - `initialVisibility` must be between $0.0$ and $1.0$.
- **Arithmetic & Progress Calculations**:
  - When $offset \le startOffset$, progress must be $0.0$.
  - When $offset \ge endOffset$, progress must be $1.0$.
  - Midpoint offset must evaluate to $0.5 \pm 0.01$.
- **Snap Mathematics**:
  - `findNearestSnapTarget(offset)` must correctly return closest target within tolerance or `null` if outside tolerance.

### 3.2 Widget & Interaction Testing Protocols
- **Visual Transparency**:
  - Pinned actions must contain no `Card`, no `Material` with elevation $> 0$, no shadows, and no box borders.
- **Midpoint Hit-Test Switching**:
  - At $t < 0.5$, tap on leading button must trigger `onInitialTap`.
  - At $t \ge 0.5$, tap on leading button must trigger `onScrolledTap` (or automatically open drawer).
- **Center Area Passthrough**:
  - Tapping between left and right pinned actions must hit-test the underlying scrollable content directly.
- **Header Scroll-Away**:
  - Pumping scroll offset past header height must ensure header content is no longer in viewport.

### 3.3 Scroll Direction & Reverse Scroll Testing
- **User Scroll Notifications**:
  - Simulating scroll down must dispatch `ScrollDirection.reverse` and trigger `onScrollDirectionChanged`.
  - Simulating scroll up must dispatch `ScrollDirection.forward`.
- **Full Reverse Restoration**:
  - Scrolling from 0px $\to$ 200px $\to$ 0px must restore initial leading avatar, trailing notification icon, and status bar visibility without artifact residual states.
- **Horizontal Scroll Isolation**:
  - Horizontal gestures inside nested carousels must not trigger vertical header transitions or status bar hiding.

### 3.4 Lifecycle & Route Integration Testing
- **Route Push & Pop Restoration**:
  - When a new route is pushed via `Navigator.push`, status bar must temporarily restore.
  - When the pushed route is popped via `Navigator.pop`, the previous scroll-driven status bar state must re-apply seamlessly via `RouteObserver`.
- **App Lifecycle Handling**:
  - Simulating `AppLifecycleState.paused` $\to$ `AppLifecycleState.resumed` must synchronize status bar state.
- **Disposal Cleanup**:
  - Disposing `ScrollResponsiveScaffold` must restore native system UI and remove all observers and controllers.

### 3.5 Reduced-Motion & Accessibility Testing
- When `MediaQueryData(disableAnimations: true)` is supplied:
  - `ScrollTransform`: `Transform.scale` and `Transform.translate` must not be mounted.
  - `ScrollAwareFab`: Animated transitions must bypass scaling/sliding.
  - `ScrollSectionReveal`: Elements must render immediately with opacity 1.0.

---

## 4. Execution Commands

```bash
# 1. Run complete static analysis (must report 0 issues)
flutter analyze

# 2. Run all unit and widget tests
flutter test

# 3. Run individual test suites
flutter test test/presets_and_controls_test.dart
flutter test test/scroll_components_test.dart
flutter test test/scroll_parallax_snap_reveal_test.dart

# 4. Validate dry run for publication
dart pub publish --dry-run
```
