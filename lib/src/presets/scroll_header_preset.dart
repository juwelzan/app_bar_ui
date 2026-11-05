/// Enumeration of the 20 pre-configured AppBar and Header design presets
/// available in the Scroll-Driven UI Framework.
enum ScrollHeaderPreset {
  /// Clean, flat, low visual weight header with a subtle divider on scroll.
  minimal,

  /// Fully transparent background over scrollable content with scroll-triggered frosted blur or tint.
  transparent,

  /// Rounded "island" header card floating above content with margins and shadow.
  floating,

  /// Material Design 3 style with tonal surface colors and scroll-under elevation tint.
  material,

  /// iOS Cupertino navigation style with SF typography, hairline divider, and compact layout.
  ios,

  /// Symmetrically balanced header with strictly centered title and balanced action slots.
  centerTitle,

  /// Expanded large typography title that collapses into an inline title on scroll.
  largeTitle,

  /// Expandable flexible header content accommodating arbitrary custom widgets.
  flexibleSpace,

  /// Smoothly collapses from hero height down to toolbar height with sticky pinning.
  collapsing,

  /// Background hero layer moving at fractional speed (e.g. 0.5x) with zero rebuilds.
  parallax,

  /// Multi-stop linear or radial gradient background with contrasting content and scroll color shift.
  gradient,

  /// High-resolution image background with configurable dark/light scrim overlay gradient.
  image,

  /// Profile cover with avatar, user name, role/handle badge, stats row, and actions.
  profile,

  /// High-density dashboard with greeting, date chip, metrics summary, and quick actions.
  dashboard,

  /// Integrated search field with search icon, clear button, filter button, and search callbacks.
  search,

  /// Header with an embedded segmented button or pill category selector.
  segmented,

  /// Pinned tab bar navigation pinned directly under the header with tab indicator and border transition.
  stickyTab,

  /// Ultra-compact space-saving header collapsing into a micro-bar at the slightest scroll.
  compactScroll,

  /// Dual-state synchronized icon swapping based on scroll state with independent thresholds.
  sideActionTransition,

  /// 100% developer-controlled custom layout using a builder callback receiving real-time progress.
  customBuilder,

  /// Title and subtitle anchored at the bottom edge with top or inline controls.
  bottomAlignedTitle,

  /// Asymmetric, dynamic weighting with prominent leading accent and compact action cluster.
  asymmetric,

  /// Split navigation with two separate compartments for title and actions.
  split,

  /// Two stacked rows of navigation: upper toolbar and lower secondary control bar.
  twoRow,

  /// Multi-action header displaying primary actions and an automatic overflow menu.
  multiAction,

  /// Ultra-minimal, icon-centric navigation bar with compact height.
  compactIcon,

  /// Hierarchical breadcrumb navigation header for nested page traversal.
  breadcrumb,

  /// Focused back navigation header with prominent title and quick actions.
  backTitle,

  /// Contextual Action Bar (CAB) mode displaying selection count and batch actions.
  contextualSelection,

  /// Breakpoint-aware responsive header adapting between mobile and wide screen layouts.
  adaptiveNavigation;

  /// User-friendly display label for this preset.
  String get label {
    switch (this) {
      case ScrollHeaderPreset.minimal:
        return 'Minimal Header';
      case ScrollHeaderPreset.transparent:
        return 'Transparent Header';
      case ScrollHeaderPreset.floating:
        return 'Floating Header';
      case ScrollHeaderPreset.material:
        return 'Material Inspired Header';
      case ScrollHeaderPreset.ios:
        return 'iOS Inspired Header';
      case ScrollHeaderPreset.centerTitle:
        return 'Center Title Header';
      case ScrollHeaderPreset.largeTitle:
        return 'Large Title Header';
      case ScrollHeaderPreset.flexibleSpace:
        return 'Flexible Space Header';
      case ScrollHeaderPreset.collapsing:
        return 'Collapsing Header';
      case ScrollHeaderPreset.parallax:
        return 'Parallax Header';
      case ScrollHeaderPreset.gradient:
        return 'Gradient Header';
      case ScrollHeaderPreset.image:
        return 'Image Background Header';
      case ScrollHeaderPreset.profile:
        return 'Profile Header';
      case ScrollHeaderPreset.dashboard:
        return 'Dashboard Header';
      case ScrollHeaderPreset.search:
        return 'Search Header';
      case ScrollHeaderPreset.segmented:
        return 'Segmented Header';
      case ScrollHeaderPreset.stickyTab:
        return 'Sticky Tab Header';
      case ScrollHeaderPreset.compactScroll:
        return 'Compact Scroll Header';
      case ScrollHeaderPreset.sideActionTransition:
        return 'Side Action Transition Header';
      case ScrollHeaderPreset.customBuilder:
        return 'Custom Builder Header';
      case ScrollHeaderPreset.bottomAlignedTitle:
        return 'Bottom-Aligned Title Header';
      case ScrollHeaderPreset.asymmetric:
        return 'Asymmetric Header';
      case ScrollHeaderPreset.split:
        return 'Split Header';
      case ScrollHeaderPreset.twoRow:
        return 'Two-Row Header';
      case ScrollHeaderPreset.multiAction:
        return 'Multi-Action Header';
      case ScrollHeaderPreset.compactIcon:
        return 'Compact Icon Header';
      case ScrollHeaderPreset.breadcrumb:
        return 'Breadcrumb Header';
      case ScrollHeaderPreset.backTitle:
        return 'Back-Title Header';
      case ScrollHeaderPreset.contextualSelection:
        return 'Contextual Selection Header';
      case ScrollHeaderPreset.adaptiveNavigation:
        return 'Adaptive Navigation Header';
    }
  }

  /// Brief description of the preset purpose and visual behavior.
  String get description {
    switch (this) {
      case ScrollHeaderPreset.minimal:
        return 'Clean, simple, low visual weight.';
      case ScrollHeaderPreset.transparent:
        return 'Fully transparent header over content.';
      case ScrollHeaderPreset.floating:
        return 'Rounded floating header with configurable spacing.';
      case ScrollHeaderPreset.material:
        return 'Material-style layout and tonal elevation.';
      case ScrollHeaderPreset.ios:
        return 'Native-inspired compact navigation style with blur.';
      case ScrollHeaderPreset.centerTitle:
        return 'Center-aligned title with balanced action slots.';
      case ScrollHeaderPreset.largeTitle:
        return 'Large typography title collapsing on scroll.';
      case ScrollHeaderPreset.flexibleSpace:
        return 'Expandable flexible header content.';
      case ScrollHeaderPreset.collapsing:
        return 'Smooth collapsing transition from hero to toolbar.';
      case ScrollHeaderPreset.parallax:
        return 'Background moves at fractional scroll speed.';
      case ScrollHeaderPreset.gradient:
        return 'Multi-stop linear or radial gradient background.';
      case ScrollHeaderPreset.image:
        return 'Image background with configurable overlay scrim.';
      case ScrollHeaderPreset.profile:
        return 'Avatar, name, subtitle, and stats metrics.';
      case ScrollHeaderPreset.dashboard:
        return 'Greeting, user info, metrics row, and quick actions.';
      case ScrollHeaderPreset.search:
        return 'Integrated search bar with real-time query callbacks.';
      case ScrollHeaderPreset.segmented:
        return 'Header with embedded category or segment selector.';
      case ScrollHeaderPreset.stickyTab:
        return 'Header with tabs that remain pinned on scroll.';
      case ScrollHeaderPreset.compactScroll:
        return 'Expanded title transitioning to compact bar.';
      case ScrollHeaderPreset.sideActionTransition:
        return 'Action icons transforming based on scroll progress.';
      case ScrollHeaderPreset.customBuilder:
        return 'Fully custom layout with real-time scroll progress.';
      case ScrollHeaderPreset.bottomAlignedTitle:
        return 'Title anchored at the bottom edge with top controls.';
      case ScrollHeaderPreset.asymmetric:
        return 'Dynamic layout with accented focal leading section.';
      case ScrollHeaderPreset.split:
        return 'Two separate visual compartments for title and actions.';
      case ScrollHeaderPreset.twoRow:
        return 'Upper navigation bar with lower secondary control row.';
      case ScrollHeaderPreset.multiAction:
        return 'Primary actions with automatic overflow popup menu.';
      case ScrollHeaderPreset.compactIcon:
        return 'Ultra-minimal icon-focused navigation.';
      case ScrollHeaderPreset.breadcrumb:
        return 'Hierarchical navigation breadcrumbs.';
      case ScrollHeaderPreset.backTitle:
        return 'Back navigation with prominent title and quick actions.';
      case ScrollHeaderPreset.contextualSelection:
        return 'Selection mode toolbar with count and batch actions.';
      case ScrollHeaderPreset.adaptiveNavigation:
        return 'Breakpoint-aware responsive layout for compact and wide screens.';
    }
  }
}
