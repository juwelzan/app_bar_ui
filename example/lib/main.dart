import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:app_bar_ui/app_bar_ui.dart';
import 'animated_lab.dart';

/// Global theme mode notifier for interactive light and dark theme switching.
final ValueNotifier<ThemeMode> themeModeNotifier = ValueNotifier<ThemeMode>(
  ThemeMode.system,
);

void main() {
  runApp(const ScrollResponsiveDemoApp());
}

/// The main demo application demonstrating the [ScrollResponsiveScaffold] system.
class ScrollResponsiveDemoApp extends StatelessWidget {
  const ScrollResponsiveDemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeModeNotifier,
      builder: (context, currentThemeMode, _) {
        return MaterialApp(
          title: 'Scroll Responsive UI Showcase',
          debugShowCheckedModeBanner: false,
          themeMode: currentThemeMode,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF3F51B5),
              brightness: Brightness.light,
            ),
            useMaterial3: true,
          ),
          darkTheme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF3F51B5),
              brightness: Brightness.dark,
            ),
            useMaterial3: true,
          ),
          home: const ShowcaseHomeScreen(),
        );
      },
    );
  }
}

/// Main container screen featuring a bottom navigation bar switching across 5 showcase tabs.
class ShowcaseHomeScreen extends StatefulWidget {
  const ShowcaseHomeScreen({super.key});

  @override
  State<ShowcaseHomeScreen> createState() => _ShowcaseHomeScreenState();
}

class _ShowcaseHomeScreenState extends State<ShowcaseHomeScreen> {
  int _currentTabIndex = 0;

  final List<Widget> _tabs = const [
    CoreHeaderTab(),
    CollapsingStickyTab(),
    PullToExpandTab(),
    ParallaxAndRevealsTab(),
    PresetSwitcherTab(),
    AnimatedExperiencesLabTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentTabIndex, children: _tabs),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentTabIndex,
        onDestinationSelected: (index) {
          setState(() => _currentTabIndex = index);
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard),
            label: 'Core Header',
          ),
          NavigationDestination(
            icon: Icon(Icons.view_day_outlined),
            selectedIcon: Icon(Icons.view_day),
            label: 'Collapsing',
          ),
          NavigationDestination(
            icon: Icon(Icons.unfold_more_outlined),
            selectedIcon: Icon(Icons.unfold_more),
            label: 'Pull Expand',
          ),
          NavigationDestination(
            icon: Icon(Icons.auto_awesome_mosaic_outlined),
            selectedIcon: Icon(Icons.auto_awesome_mosaic),
            label: 'Parallax',
          ),
          NavigationDestination(
            icon: Icon(Icons.style_outlined),
            selectedIcon: Icon(Icons.style),
            label: 'Presets',
          ),
          NavigationDestination(
            icon: Icon(Icons.science_outlined),
            selectedIcon: Icon(Icons.science),
            label: 'Lab (50)',
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// TAB 1: Core Scroll Header with Dual Icon Swaps & Live Telemetry
// ============================================================================

class CoreHeaderTab extends StatefulWidget {
  const CoreHeaderTab({super.key});

  @override
  State<CoreHeaderTab> createState() => _CoreHeaderTabState();
}

class _CoreHeaderTabState extends State<CoreHeaderTab> {
  final ScrollResponsiveController _controller = ScrollResponsiveController();

  final ValueNotifier<ScrollProgressDetails> _telemetryNotifier =
      ValueNotifier<ScrollProgressDetails>(
        const ScrollProgressDetails(
          offset: 0.0,
          leadingProgress: 0.0,
          trailingProgress: 0.0,
          isStatusBarHidden: false,
          scrollDirection: ScrollDirection.idle,
        ),
      );

  bool _hideStatusBar = true;
  String _thresholdPreset = 'Standard (20-80px)';

  @override
  void dispose() {
    _controller.dispose();
    _telemetryNotifier.dispose();
    super.dispose();
  }

  ScrollThresholdConfig _getThresholdConfig() {
    switch (_thresholdPreset) {
      case 'Fast (10-40px)':
        return const ScrollThresholdConfig(
          leadingStartOffset: 10.0,
          leadingEndOffset: 40.0,
          trailingStartOffset: 10.0,
          trailingEndOffset: 40.0,
          statusBarHideOffset: 50.0,
          statusBarShowOffset: 25.0,
        );
      case 'Delayed (40-120px)':
        return const ScrollThresholdConfig(
          leadingStartOffset: 40.0,
          leadingEndOffset: 120.0,
          trailingStartOffset: 40.0,
          trailingEndOffset: 120.0,
          statusBarHideOffset: 130.0,
          statusBarShowOffset: 70.0,
        );
      default:
        return const ScrollThresholdConfig(
          leadingStartOffset: 20.0,
          leadingEndOffset: 80.0,
          trailingStartOffset: 20.0,
          trailingEndOffset: 80.0,
          statusBarHideOffset: 90.0,
          statusBarShowOffset: 45.0,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ScrollResponsiveScaffold(
      controller: _controller,
      config: ScrollResponsiveConfig(
        thresholds: _getThresholdConfig(),
        statusBar: StatusBarConfig(
          enabled: _hideStatusBar,
          hideOnScroll: _hideStatusBar,
        ),
      ),
      initialLeading: const Icon(Icons.menu, size: 24),
      scrolledLeading: const Icon(Icons.arrow_back, size: 24),
      initialTrailing: const Icon(Icons.search, size: 24),
      scrolledTrailing: const Icon(Icons.tune, size: 24),
      onLeadingInitialTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Menu tapped!'),
            duration: Duration(milliseconds: 700),
          ),
        );
      },
      onLeadingScrolledTap: () => _controller.scrollToTop(),
      onTrailingInitialTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Search tapped!'),
            duration: Duration(milliseconds: 700),
          ),
        );
      },
      onTrailingScrolledTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Filter options tapped!'),
            duration: Duration(milliseconds: 700),
          ),
        );
      },
      onScrollUpdate: (details) => _telemetryNotifier.value = details,
      header: Container(
        padding: const EdgeInsets.fromLTRB(20.0, 56.0, 20.0, 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome Back,',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      Text(
                        'Alex Morgan',
                        style: theme.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton.filledTonal(
                  icon: Icon(
                    theme.brightness == Brightness.dark
                        ? Icons.light_mode
                        : Icons.dark_mode,
                  ),
                  onPressed: () {
                    themeModeNotifier.value =
                        theme.brightness == Brightness.dark
                        ? ThemeMode.light
                        : ThemeMode.dark;
                  },
                ),
              ],
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Live Telemetry Card
            Card(
              elevation: 0,
              color: theme.colorScheme.surfaceContainerHighest.withValues(
                alpha: 0.5,
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: ValueListenableBuilder<ScrollProgressDetails>(
                  valueListenable: _telemetryNotifier,
                  builder: (context, details, _) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.speed,
                              size: 20,
                              color: theme.colorScheme.primary,
                            ),
                            const SizedBox(width: 8.0),
                            Text(
                              'Live Scroll Telemetry',
                              style: theme.textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const Divider(height: 20.0),
                        _buildTelemetryRow(
                          'Scroll Offset',
                          '${details.offset.toStringAsFixed(1)} px',
                        ),
                        const SizedBox(height: 8.0),
                        _buildTelemetryRow(
                          'Leading Progress',
                          '${(details.leadingProgress * 100).toInt()}%',
                          progress: details.leadingProgress,
                        ),
                        const SizedBox(height: 8.0),
                        _buildTelemetryRow(
                          'Trailing Progress',
                          '${(details.trailingProgress * 100).toInt()}%',
                          progress: details.trailingProgress,
                        ),
                        const SizedBox(height: 8.0),
                        _buildTelemetryRow(
                          'Scroll Direction',
                          details.scrollDirection.name.toUpperCase(),
                        ),
                        const SizedBox(height: 8.0),
                        _buildTelemetryRow(
                          'Status Bar Hidden',
                          details.isStatusBarHidden ? 'YES' : 'NO',
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 16.0),

            // Settings Controls
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
                side: BorderSide(
                  color: theme.colorScheme.outlineVariant.withValues(
                    alpha: 0.4,
                  ),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Configuration',
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12.0),
                    DropdownButtonFormField<String>(
                      initialValue: _thresholdPreset,
                      decoration: const InputDecoration(
                        labelText: 'Threshold Range',
                        border: OutlineInputBorder(),
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: 'Fast (10-40px)',
                          child: Text('Fast (10-40px)'),
                        ),
                        DropdownMenuItem(
                          value: 'Standard (20-80px)',
                          child: Text('Standard (20-80px)'),
                        ),
                        DropdownMenuItem(
                          value: 'Delayed (40-120px)',
                          child: Text('Delayed (40-120px)'),
                        ),
                      ],
                      onChanged: (val) {
                        if (val != null) setState(() => _thresholdPreset = val);
                      },
                    ),
                    const SizedBox(height: 8.0),
                    SwitchListTile.adaptive(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Hide Status Bar on Scroll'),
                      value: _hideStatusBar,
                      onChanged: (val) => setState(() => _hideStatusBar = val),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16.0),

            // Continuous scroll demo items
            ...List.generate(
              15,
              (index) => Card(
                elevation: 0,
                margin: const EdgeInsets.only(bottom: 10.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  side: BorderSide(
                    color: theme.colorScheme.outlineVariant.withValues(
                      alpha: 0.3,
                    ),
                  ),
                ),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: theme.colorScheme.primaryContainer,
                    child: Text('${index + 1}'),
                  ),
                  title: Text('Activity Item #${index + 1}'),
                  subtitle: Text('Recorded event log at ${10 + index}:00 AM'),
                  trailing: const Icon(Icons.chevron_right, size: 20),
                ),
              ),
            ),
            const SizedBox(height: 40.0),
          ],
        ),
      ),
    );
  }

  Widget _buildTelemetryRow(String label, String value, {double? progress}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(fontSize: 12.0, color: Colors.grey),
            ),
            Text(
              value,
              style: const TextStyle(
                fontSize: 12.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        if (progress != null) ...[
          const SizedBox(height: 3.0),
          ClipRRect(
            borderRadius: BorderRadius.circular(2.0),
            child: LinearProgressIndicator(value: progress, minHeight: 4.0),
          ),
        ],
      ],
    );
  }
}

// ============================================================================
// TAB 2: Collapsing Header & Sticky Tab Bar
// ============================================================================

class CollapsingStickyTab extends StatefulWidget {
  const CollapsingStickyTab({super.key});

  @override
  State<CollapsingStickyTab> createState() => _CollapsingStickyTabState();
}

class _CollapsingStickyTabState extends State<CollapsingStickyTab>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ScrollResponsiveScaffold(
      initialLeading: const Icon(Icons.arrow_back),
      initialTrailing: const Icon(Icons.bookmark_border),
      scrolledTrailing: const Icon(Icons.bookmark),
      slivers: [
        // Smooth Collapsing Header
        ScrollCollapsingHeader(
          expandedHeight: 220.0,
          collapsedHeight: 64.0,
          pinned: true,
          builder: (context, progress) {
            return Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    theme.colorScheme.primary,
                    theme.colorScheme.tertiary,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Align(
                alignment: Alignment.lerp(
                  Alignment.bottomLeft,
                  Alignment.center,
                  progress,
                )!,
                child: Padding(
                  padding: EdgeInsets.only(bottom: (1.0 - progress) * 20.0),
                  child: Text(
                    'Collapsing Header',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.0 + (1.0 - progress) * 10.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            );
          },
        ),

        // Sticky Tab Bar
        ScrollStickyTabBar(
          pinned: true,
          elevation: 3.0,
          child: TabBar(
            controller: _tabController,
            tabs: const [
              Tab(text: 'Overview'),
              Tab(text: 'Features'),
              Tab(text: 'Reviews'),
            ],
          ),
        ),

        // Tab Content List
        SliverPadding(
          padding: const EdgeInsets.all(16.0),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => Card(
                elevation: 0,
                margin: const EdgeInsets.only(bottom: 12.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  side: BorderSide(
                    color: theme.colorScheme.outlineVariant.withValues(
                      alpha: 0.3,
                    ),
                  ),
                ),
                child: ListTile(
                  leading: Icon(
                    Icons.check_circle_outline,
                    color: theme.colorScheme.primary,
                  ),
                  title: Text('Specification Metric #${index + 1}'),
                  subtitle: Text(
                    'Verified 60/120 FPS high-refresh sliver performance',
                  ),
                ),
              ),
              childCount: 20,
            ),
          ),
        ),
      ],
    );
  }
}

// ============================================================================
// TAB 3: Pull to Expand Header with Rubber-Band Stretch
// ============================================================================

class PullToExpandTab extends StatelessWidget {
  const PullToExpandTab({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ScrollResponsiveScaffold(
      physics: const BouncingScrollPhysics(
        parent: AlwaysScrollableScrollPhysics(),
      ),
      initialLeading: const Icon(Icons.arrow_back),
      initialTrailing: const Icon(Icons.share),
      slivers: [
        // Rubber-Band Zoom & Pull-to-Expand Sliver Header
        ScrollPullToExpandHeader(
          expandedHeight: 240.0,
          stretchTriggerOffset: 120.0,
          content: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
              vertical: 16.0,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircleAvatar(
                  radius: 28.0,
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.person,
                    size: 36.0,
                    color: Color(0xFF2C3E50),
                  ),
                ),
                const SizedBox(height: 6.0),
                const Text(
                  'Eleanor Vance',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Senior Product Designer',
                  style: TextStyle(color: Colors.white.withValues(alpha: 0.8)),
                ),
              ],
            ),
          ),
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF2C3E50), Color(0xFF4CA1AF)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: const Center(
              child: Icon(Icons.landscape, size: 72, color: Colors.white38),
            ),
          ),
        ),

        // Profile content
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatColumn('Posts', '142', theme),
                    _buildStatColumn('Followers', '12.8k', theme),
                    _buildStatColumn('Following', '480', theme),
                  ],
                ),
                const SizedBox(height: 24.0),
                Text(
                  'User Feed',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8.0),
              ],
            ),
          ),
        ),

        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) => Card(
              elevation: 0,
              margin: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 6.0,
              ),
              child: ListTile(
                leading: const Icon(Icons.article_outlined),
                title: Text('Design Article #${index + 1}'),
                subtitle: const Text(
                  'Pull down at the very top to see rubber-band zoom!',
                ),
              ),
            ),
            childCount: 15,
          ),
        ),
      ],
    );
  }

  Widget _buildStatColumn(String label, String value, ThemeData theme) {
    return Column(
      children: [
        Text(
          value,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4.0),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey),
        ),
      ],
    );
  }
}

// ============================================================================
// TAB 4: Parallax Container & Animated Section Reveals
// ============================================================================

class ParallaxAndRevealsTab extends StatefulWidget {
  const ParallaxAndRevealsTab({super.key});

  @override
  State<ParallaxAndRevealsTab> createState() => _ParallaxAndRevealsTabState();
}

class _ParallaxAndRevealsTabState extends State<ParallaxAndRevealsTab> {
  final ScrollResponsiveController _controller = ScrollResponsiveController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ScrollResponsiveScaffold(
      controller: _controller,
      progressIndicator: ScrollProgressIndicator(
        type: ProgressIndicatorType.linear,
        color: theme.colorScheme.primary,
        height: 3.5,
      ),
      floatingActionButton: ScrollToTopButton(scrollController: _controller),
      scrollAwareFab: true,
      initialLeading: const Icon(Icons.arrow_back),
      initialTrailing: const Icon(Icons.share),
      slivers: [
        // Hero Parallax Layer
        SliverToBoxAdapter(
          child: SizedBox(
            height: 240.0,
            child: ScrollParallax(
              speedFactor: 0.5,
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF8E2DE2), Color(0xFF4A00E0)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.layers, size: 48.0, color: Colors.white70),
                      SizedBox(height: 8.0),
                      Text(
                        'Flow Parallax Container',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Repaints via FlowDelegate with ZERO rebuilds',
                        style: TextStyle(color: Colors.white70),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),

        // Animated Section Reveals
        SliverPadding(
          padding: const EdgeInsets.all(16.0),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => ScrollSectionReveal(
                slideOffset: const Offset(0.0, 30.0),
                child: Card(
                  elevation: 0,
                  margin: const EdgeInsets.only(bottom: 12.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    side: BorderSide(
                      color: theme.colorScheme.outlineVariant.withValues(
                        alpha: 0.3,
                      ),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Revealed Section #${index + 1}',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 6.0),
                        Text(
                          'This section smoothly animates into view as you scroll down.',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              childCount: 16,
            ),
          ),
        ),
      ],
    );
  }
}

// ============================================================================
// TAB 5: Presets Showcase (Quick Switcher + 20-Preset Interactive Gallery)
// ============================================================================

class PresetSwitcherTab extends StatefulWidget {
  const PresetSwitcherTab({super.key});

  @override
  State<PresetSwitcherTab> createState() => _PresetSwitcherTabState();
}

class _PresetSwitcherTabState extends State<PresetSwitcherTab> {
  String _selectedPreset = 'Material';

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          Material(
            color: Theme.of(context).colorScheme.surface,
            elevation: 1,
            child: const TabBar(
              tabs: [
                Tab(icon: Icon(Icons.swap_horiz), text: 'Quick Switcher'),
                Tab(
                  icon: Icon(Icons.grid_view_rounded),
                  text: '20 Presets Gallery',
                ),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              children: [
                _buildQuickSwitcherTab(context),
                const PresetGalleryView(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickSwitcherTab(BuildContext context) {
    return Column(
      children: [
        // Preset Selection Bar
        SafeArea(
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 8.0),
            child: DropdownButtonFormField<String>(
              key: const ValueKey('preset_dropdown'),
              initialValue: _selectedPreset,
              decoration: const InputDecoration(
                labelText: 'Choose Scaffold Preset',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 10.0,
                ),
              ),
              items: const [
                DropdownMenuItem(
                  value: 'Material',
                  child: Text('Material Preset'),
                ),
                DropdownMenuItem(
                  value: 'Minimal',
                  child: Text('Minimal Preset'),
                ),
                DropdownMenuItem(
                  value: 'iOS',
                  child: Text('iOS Inspired Preset'),
                ),
                DropdownMenuItem(
                  value: 'Dashboard',
                  child: Text('Dashboard Preset'),
                ),
                DropdownMenuItem(
                  value: 'Transparent',
                  child: Text('Transparent Floating Preset'),
                ),
              ],
              onChanged: (val) {
                if (val != null) setState(() => _selectedPreset = val);
              },
            ),
          ),
        ),
        const Divider(height: 1),

        // Live Selected Preset Scaffold
        Expanded(child: _buildSelectedPreset()),
      ],
    );
  }

  Widget _buildSelectedPreset() {
    switch (_selectedPreset) {
      case 'Minimal':
        return ScrollResponsiveScaffold.minimal(
          headerTitle: const Text('Minimal Preset'),
          headerSubtitle: const Text('Zero-clutter lightweight header'),
          initialLeading: const Icon(Icons.arrow_back),
          body: _buildPresetContent('Minimal Design Style'),
        );
      case 'iOS':
        return ScrollResponsiveScaffold.iosInspired(
          headerTitle: const Text('iOS Inspired'),
          headerSubtitle: const Text('Cupertino curve with smooth collapse'),
          initialLeading: const Icon(Icons.arrow_back_ios),
          body: _buildPresetContent('iOS Cupertino Design Style'),
        );
      case 'Dashboard':
        return ScrollResponsiveScaffold.dashboard(
          headerTitle: const Text('Dashboard Preset'),
          headerSubtitle: const Text('High-density metrics overview'),
          initialLeading: const Icon(Icons.menu),
          initialTrailing: const Icon(Icons.notifications_none),
          body: _buildPresetContent('Dashboard Design Style'),
        );
      case 'Transparent':
        return ScrollResponsiveScaffold.transparentFloating(
          headerTitle: const Text('Transparent Floating'),
          headerSubtitle: const Text('Floating overlay over content'),
          initialLeading: const Icon(Icons.arrow_back),
          body: _buildPresetContent('Transparent Floating Style'),
        );
      default:
        return ScrollResponsiveScaffold.material(
          headerTitle: const Text('Material Preset'),
          headerSubtitle: const Text('Standard Material Design 3 spec'),
          initialLeading: const Icon(Icons.menu),
          initialTrailing: const Icon(Icons.search),
          body: _buildPresetContent('Standard Material Style'),
        );
    }
  }

  Widget _buildPresetContent(String presetName) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            elevation: 0,
            color: Colors.blue.withValues(alpha: 0.1),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Demonstrating: $presetName\nConstructed cleanly via ScrollResponsiveScaffold.${_selectedPreset.toLowerCase()}()',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(height: 16.0),
          ...List.generate(
            15,
            (index) => ListTile(
              leading: CircleAvatar(child: Text('${index + 1}')),
              title: Text('$presetName Entry #${index + 1}'),
              subtitle: const Text(
                'Scroll up and down to observe preset-specific thresholds.',
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Interactive 20-Preset Showcase Gallery displaying all 20 presets in preview cards.
class PresetGalleryView extends StatelessWidget {
  const PresetGalleryView({super.key});

  String _getCategory(ScrollHeaderPreset preset) {
    switch (preset) {
      case ScrollHeaderPreset.minimal:
      case ScrollHeaderPreset.transparent:
      case ScrollHeaderPreset.floating:
      case ScrollHeaderPreset.material:
      case ScrollHeaderPreset.ios:
      case ScrollHeaderPreset.centerTitle:
        return 'Box Header';
      case ScrollHeaderPreset.largeTitle:
      case ScrollHeaderPreset.flexibleSpace:
      case ScrollHeaderPreset.collapsing:
      case ScrollHeaderPreset.parallax:
        return 'Collapsible Sliver';
      case ScrollHeaderPreset.gradient:
      case ScrollHeaderPreset.image:
        return 'Color & Media';
      case ScrollHeaderPreset.profile:
      case ScrollHeaderPreset.dashboard:
      case ScrollHeaderPreset.search:
      case ScrollHeaderPreset.segmented:
      case ScrollHeaderPreset.stickyTab:
        return 'Specialized Layout';
      case ScrollHeaderPreset.compactScroll:
      case ScrollHeaderPreset.sideActionTransition:
      case ScrollHeaderPreset.customBuilder:
        return 'Dynamic & Custom';
      case ScrollHeaderPreset.bottomAlignedTitle:
      case ScrollHeaderPreset.asymmetric:
      case ScrollHeaderPreset.split:
      case ScrollHeaderPreset.twoRow:
      case ScrollHeaderPreset.multiAction:
      case ScrollHeaderPreset.compactIcon:
      case ScrollHeaderPreset.breadcrumb:
      case ScrollHeaderPreset.backTitle:
      case ScrollHeaderPreset.contextualSelection:
      case ScrollHeaderPreset.adaptiveNavigation:
        return 'Navigation & Layout';
      case ScrollHeaderPreset.glass:
      case ScrollHeaderPreset.blurredBackground:
      case ScrollHeaderPreset.bordered:
      case ScrollHeaderPreset.shadowElevated:
      case ScrollHeaderPreset.layered:
      case ScrollHeaderPreset.shapeMorphing:
      case ScrollHeaderPreset.animatedGradient:
      case ScrollHeaderPreset.colorTransition:
      case ScrollHeaderPreset.illustrated:
      case ScrollHeaderPreset.edgeToEdge:
        return 'Visual & Creative';
      case ScrollHeaderPreset.mediaPlayer:
      case ScrollHeaderPreset.shopping:
      case ScrollHeaderPreset.chat:
      case ScrollHeaderPreset.detailPage:
      case ScrollHeaderPreset.reading:
      case ScrollHeaderPreset.map:
      case ScrollHeaderPreset.form:
      case ScrollHeaderPreset.wizard:
      case ScrollHeaderPreset.notificationCenter:
      case ScrollHeaderPreset.customScrollLayout:
        return 'Specialized Layout';
    }
  }

  IconData _getIcon(ScrollHeaderPreset preset) {
    switch (preset) {
      case ScrollHeaderPreset.minimal:
        return Icons.short_text;
      case ScrollHeaderPreset.transparent:
        return Icons.opacity;
      case ScrollHeaderPreset.floating:
        return Icons.layers_outlined;
      case ScrollHeaderPreset.material:
        return Icons.view_compact_alt;
      case ScrollHeaderPreset.ios:
        return Icons.phone_iphone;
      case ScrollHeaderPreset.centerTitle:
        return Icons.format_align_center;
      case ScrollHeaderPreset.largeTitle:
        return Icons.title;
      case ScrollHeaderPreset.flexibleSpace:
        return Icons.aspect_ratio;
      case ScrollHeaderPreset.collapsing:
        return Icons.vertical_align_center;
      case ScrollHeaderPreset.parallax:
        return Icons.auto_awesome_motion;
      case ScrollHeaderPreset.gradient:
        return Icons.gradient;
      case ScrollHeaderPreset.image:
        return Icons.image_outlined;
      case ScrollHeaderPreset.profile:
        return Icons.account_circle_outlined;
      case ScrollHeaderPreset.dashboard:
        return Icons.dashboard_outlined;
      case ScrollHeaderPreset.search:
        return Icons.search;
      case ScrollHeaderPreset.segmented:
        return Icons.view_week_outlined;
      case ScrollHeaderPreset.stickyTab:
        return Icons.tab;
      case ScrollHeaderPreset.compactScroll:
        return Icons.unfold_less;
      case ScrollHeaderPreset.sideActionTransition:
        return Icons.transform;
      case ScrollHeaderPreset.customBuilder:
        return Icons.code;
      case ScrollHeaderPreset.bottomAlignedTitle:
        return Icons.vertical_align_bottom;
      case ScrollHeaderPreset.asymmetric:
        return Icons.align_horizontal_left;
      case ScrollHeaderPreset.split:
        return Icons.call_split;
      case ScrollHeaderPreset.twoRow:
        return Icons.table_rows;
      case ScrollHeaderPreset.multiAction:
        return Icons.more_horiz;
      case ScrollHeaderPreset.compactIcon:
        return Icons.widgets_outlined;
      case ScrollHeaderPreset.breadcrumb:
        return Icons.linear_scale;
      case ScrollHeaderPreset.backTitle:
        return Icons.arrow_back_ios_new;
      case ScrollHeaderPreset.contextualSelection:
        return Icons.checklist;
      case ScrollHeaderPreset.adaptiveNavigation:
        return Icons.devices;
      case ScrollHeaderPreset.glass:
        return Icons.blur_on;
      case ScrollHeaderPreset.blurredBackground:
        return Icons.lens_blur;
      case ScrollHeaderPreset.bordered:
        return Icons.border_bottom;
      case ScrollHeaderPreset.shadowElevated:
        return Icons.layers;
      case ScrollHeaderPreset.layered:
        return Icons.view_carousel;
      case ScrollHeaderPreset.shapeMorphing:
        return Icons.rounded_corner;
      case ScrollHeaderPreset.animatedGradient:
        return Icons.animation;
      case ScrollHeaderPreset.colorTransition:
        return Icons.color_lens;
      case ScrollHeaderPreset.illustrated:
        return Icons.draw;
      case ScrollHeaderPreset.edgeToEdge:
        return Icons.fullscreen;
      case ScrollHeaderPreset.mediaPlayer:
        return Icons.play_circle_outline;
      case ScrollHeaderPreset.shopping:
        return Icons.shopping_bag_outlined;
      case ScrollHeaderPreset.chat:
        return Icons.chat_bubble_outline;
      case ScrollHeaderPreset.detailPage:
        return Icons.photo_size_select_actual_outlined;
      case ScrollHeaderPreset.reading:
        return Icons.menu_book;
      case ScrollHeaderPreset.map:
        return Icons.map_outlined;
      case ScrollHeaderPreset.form:
        return Icons.edit_note_outlined;
      case ScrollHeaderPreset.wizard:
        return Icons.linear_scale_outlined;
      case ScrollHeaderPreset.notificationCenter:
        return Icons.notifications_none_outlined;
      case ScrollHeaderPreset.customScrollLayout:
        return Icons.dashboard_customize_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: ScrollHeaderPreset.values.length,
      itemBuilder: (context, index) {
        final preset = ScrollHeaderPreset.values[index];
        final category = _getCategory(preset);
        final icon = _getIcon(preset);

        return Card(
          margin: const EdgeInsets.only(bottom: 12.0),
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(12.0),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (context) => PresetDetailScreen(preset: preset),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Container(
                    width: 48.0,
                    height: 48.0,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Icon(
                      icon,
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                  ),
                  const SizedBox(width: 16.0),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              '#${index + 1}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.primary,
                                fontSize: 12.0,
                              ),
                            ),
                            const SizedBox(width: 6.0),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6.0,
                                vertical: 2.0,
                              ),
                              decoration: BoxDecoration(
                                color: Theme.of(context)
                                    .colorScheme
                                    .surfaceContainerHighest,
                                borderRadius: BorderRadius.circular(4.0),
                              ),
                              child: Text(
                                category,
                                style: TextStyle(
                                  fontSize: 10.0,
                                  fontWeight: FontWeight.w600,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurfaceVariant,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4.0),
                        Text(
                          preset.label,
                          style: const TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 2.0),
                        Text(
                          preset.description,
                          style: TextStyle(
                            fontSize: 13.0,
                            color: Theme.of(context)
                                .colorScheme
                                .onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.arrow_forward_ios, size: 16.0),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Full-screen interactive demo for any of the 20 presets.
class PresetDetailScreen extends StatefulWidget {
  const PresetDetailScreen({super.key, required this.preset});

  final ScrollHeaderPreset preset;

  @override
  State<PresetDetailScreen> createState() => _PresetDetailScreenState();
}

class _PresetDetailScreenState extends State<PresetDetailScreen> {
  final ScrollResponsiveController _controller = ScrollResponsiveController();
  final TextEditingController _searchController = TextEditingController();
  int _selectedSegment = 0;

  @override
  void dispose() {
    _searchController.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final headerWidget = _buildHeader(widget.preset);

    final content = ScrollResponsiveScaffold(
      controller: _controller,
      header: headerWidget,
      body: _buildBody(context),
    );

    if (widget.preset == ScrollHeaderPreset.stickyTab) {
      return DefaultTabController(length: 3, child: Scaffold(body: content));
    }

    return Scaffold(body: content);
  }

  ScrollHeader _buildHeader(ScrollHeaderPreset preset) {
    switch (preset) {
      case ScrollHeaderPreset.minimal:
        return ScrollHeader.minimal(
          title: Text(preset.label),
          subtitle: const Text('Minimal & clean visual weight'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),
          actions: const [
            IconButton(icon: Icon(Icons.more_vert), onPressed: null),
          ],
        );

      case ScrollHeaderPreset.transparent:
        return ScrollHeader.transparent(
          title: Text(preset.label),
          subtitle: const Text('Overlaid above content'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),
          actions: const [IconButton(icon: Icon(Icons.share), onPressed: null)],
        );

      case ScrollHeaderPreset.floating:
        return ScrollHeader.floating(
          title: Text(preset.label),
          subtitle: const Text('Rounded floating island'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),
          actions: const [
            IconButton(icon: Icon(Icons.favorite_border), onPressed: null),
          ],
        );

      case ScrollHeaderPreset.material:
        return ScrollHeader.material(
          title: Text(preset.label),
          subtitle: const Text('Material 3 tonal surface'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),
          actions: const [
            IconButton(icon: Icon(Icons.search), onPressed: null),
          ],
        );

      case ScrollHeaderPreset.ios:
        return ScrollHeader.ios(
          title: Text(preset.label),
          leading: TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Back'),
          ),
          actions: const [
            IconButton(icon: Icon(Icons.edit_outlined), onPressed: null),
          ],
        );

      case ScrollHeaderPreset.centerTitle:
        return ScrollHeader.centerTitle(
          title: Text(preset.label),
          subtitle: const Text('Symmetrically centered'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),
          actions: const [
            IconButton(icon: Icon(Icons.info_outline), onPressed: null),
          ],
        );

      case ScrollHeaderPreset.largeTitle:
        return ScrollHeader.largeTitle(
          title: Text(preset.label),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),
          actions: const [
            IconButton(icon: Icon(Icons.more_horiz), onPressed: null),
          ],
        );

      case ScrollHeaderPreset.flexibleSpace:
        return ScrollHeader.flexibleSpace(
          title: Text(preset.label),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF1E3A8A), Color(0xFF3B82F6)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: const Center(
              child: Text(
                'Flexible Space Banner Area',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        );

      case ScrollHeaderPreset.collapsing:
        return ScrollHeader.collapsing(
          title: Text(preset.label),
          subtitle: const Text('Smooth hero collapse'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),
          actions: const [IconButton(icon: Icon(Icons.tune), onPressed: null)],
        );

      case ScrollHeaderPreset.parallax:
        return ScrollHeader.parallax(
          title: Text(preset.label),
          subtitle: const Text('0.5x Parallax background motion'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
          background: Container(
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                colors: [Color(0xFF7C3AED), Color(0xFF312E81)],
                radius: 1.2,
              ),
            ),
          ),
        );

      case ScrollHeaderPreset.gradient:
        return ScrollHeader.gradient(
          title: Text(preset.label),
          subtitle: const Text('Multi-stop vibrant gradient'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
          gradient: const LinearGradient(
            colors: [Color(0xFFEC4899), Color(0xFF8B5CF6)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        );

      case ScrollHeaderPreset.image:
        return ScrollHeader.image(
          title: Text(preset.label),
          subtitle: const Text('Image with contrast scrim'),
          image: const NetworkImage(
            'https://picsum.photos/seed/appbar/800/400',
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
          overlayGradient: LinearGradient(
            colors: [
              Colors.black.withValues(alpha: 0.7),
              Colors.black.withValues(alpha: 0.3),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          overlayColor: Colors.black45,
        );

      case ScrollHeaderPreset.profile:
        return ScrollHeader.profile(
          name: const Text('Sophia Rodriguez'),
          handleOrRole: const Text('@sophia • Staff Engineer'),
          avatar: const CircleAvatar(
            radius: 26.0,
            backgroundColor: Colors.teal,
            child: Text('SR', style: TextStyle(color: Colors.white)),
          ),
          stats: const Row(
            children: [
              Text(
                '14.2K Followers',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.0),
              ),
              SizedBox(width: 16.0),
              Text(
                '840 Following',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.0),
              ),
            ],
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),
          actions: const [
            IconButton(icon: Icon(Icons.person_add_alt_1), onPressed: null),
          ],
        );

      case ScrollHeaderPreset.dashboard:
        return ScrollHeader.dashboard(
          greeting: const Text('Good Morning,'),
          userName: const Text('Ethan Walker'),
          dateOrSubtitle: const Text('Nov 6, 2026 • Systems Healthy'),
          metricsRow: const Row(
            children: [
              Chip(avatar: Icon(Icons.bolt, size: 16), label: Text('99.99%')),
              SizedBox(width: 8.0),
              Chip(
                avatar: Icon(Icons.trending_up, size: 16),
                label: Text('\$42.5K'),
              ),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );

      case ScrollHeaderPreset.search:
        return ScrollHeader.search(
          title: Text(preset.label),
          searchController: _searchController,
          searchHint: 'Search documentation & presets...',
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),
          actions: const [IconButton(icon: Icon(Icons.tune), onPressed: null)],
        );

      case ScrollHeaderPreset.segmented:
        return ScrollHeader.segmented(
          title: Text(preset.label),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),
          segments: SegmentedButton<int>(
            segments: const [
              ButtonSegment(value: 0, label: Text('All')),
              ButtonSegment(value: 1, label: Text('Starred')),
              ButtonSegment(value: 2, label: Text('Recent')),
            ],
            selected: {_selectedSegment},
            onSelectionChanged: (set) =>
                setState(() => _selectedSegment = set.first),
          ),
        );

      case ScrollHeaderPreset.stickyTab:
        return ScrollHeader.stickyTab(
          title: Text(preset.label),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),
          tabBar: const TabBar(
            tabs: [
              Tab(text: 'General'),
              Tab(text: 'Metrics'),
              Tab(text: 'Settings'),
            ],
          ),
        );

      case ScrollHeaderPreset.compactScroll:
        return ScrollHeader.compactScroll(
          title: Text(preset.label),
          subtitle: const Text('Quickly collapses to 48px'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),
          actions: const [
            IconButton(icon: Icon(Icons.more_vert), onPressed: null),
          ],
        );

      case ScrollHeaderPreset.sideActionTransition:
        return ScrollHeader.sideActionTransition(
          title: Text(preset.label),
          subtitle: const Text('Transforms leading & trailing on scroll'),
          initialLeading: const Icon(Icons.menu),
          scrolledLeading: const Icon(Icons.arrow_back),
          initialTrailing: const Icon(Icons.notifications_none),
          scrolledTrailing: const Icon(Icons.check),
          onLeadingTap: () => Navigator.of(context).pop(),
        );

      case ScrollHeaderPreset.customBuilder:
        return ScrollHeader.customBuilder(
          expandedHeight: 200.0,
          collapsedHeight: kToolbarHeight,
          builder: (context, progress, overlaps) {
            final theme = Theme.of(context);
            return Container(
              color: Color.lerp(
                theme.colorScheme.primary,
                theme.colorScheme.tertiary,
                progress,
              ),
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: NavigationToolbar(
                    leading: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    middle: Text(
                      'Custom Builder (${(progress * 100).toInt()}%)',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: Opacity(
                      opacity: (1.0 - progress).clamp(0.0, 1.0),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8.0,
                          vertical: 4.0,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white24,
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: Text(
                          '${(progress * 100).toInt()}%',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        );

      case ScrollHeaderPreset.bottomAlignedTitle:
        return ScrollHeader.bottomAlignedTitle(
          title: Text(preset.label),
          subtitle: const Text('Title anchored at bottom edge'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),
          actions: const [
            IconButton(icon: Icon(Icons.bookmark_border), onPressed: null),
          ],
        );

      case ScrollHeaderPreset.asymmetric:
        return ScrollHeader.asymmetric(
          title: Text(preset.label),
          subtitle: const Text('Dynamic accented weighting'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),
          actions: const [
            IconButton(icon: Icon(Icons.tune), onPressed: null),
          ],
        );

      case ScrollHeaderPreset.split:
        return ScrollHeader.split(
          title: Text(preset.label),
          subtitle: const Text('Separate dual compartments'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),
          actions: const [
            IconButton(icon: Icon(Icons.filter_list), onPressed: null),
            IconButton(icon: Icon(Icons.search), onPressed: null),
          ],
        );

      case ScrollHeaderPreset.twoRow:
        return ScrollHeader.twoRow(
          title: Text(preset.label),
          subtitle: const Text('Two stacked control rows'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),
          actions: const [
            IconButton(icon: Icon(Icons.settings), onPressed: null),
          ],
          bottomRow: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                FilterChip(
                  label: const Text('All'),
                  selected: true,
                  onSelected: (_) {},
                ),
                const SizedBox(width: 8),
                FilterChip(
                  label: const Text('Popular'),
                  selected: false,
                  onSelected: (_) {},
                ),
                const SizedBox(width: 8),
                FilterChip(
                  label: const Text('Recent'),
                  selected: false,
                  onSelected: (_) {},
                ),
              ],
            ),
          ),
        );

      case ScrollHeaderPreset.multiAction:
        return ScrollHeader.multiAction(
          title: Text(preset.label),
          subtitle: const Text('Auto-overflow menu for 3+ actions'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),
          maxVisibleActions: 2,
          actions: const [
            IconButton(icon: Icon(Icons.share), onPressed: null),
            IconButton(icon: Icon(Icons.favorite_border), onPressed: null),
            IconButton(icon: Icon(Icons.download), onPressed: null),
            IconButton(icon: Icon(Icons.delete_outline), onPressed: null),
          ],
        );

      case ScrollHeaderPreset.compactIcon:
        return ScrollHeader.compactIcon(
          title: Text(preset.label),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),
          actions: const [
            IconButton(icon: Icon(Icons.search), onPressed: null),
            IconButton(icon: Icon(Icons.favorite_border), onPressed: null),
            IconButton(icon: Icon(Icons.share), onPressed: null),
          ],
        );

      case ScrollHeaderPreset.breadcrumb:
        return ScrollHeader.breadcrumb(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),
          breadcrumbs: const [
            Text('Home'),
            Text('Shop'),
            Text('Electronics'),
            Text('Audio'),
          ],
          actions: const [
            IconButton(icon: Icon(Icons.search), onPressed: null),
          ],
        );

      case ScrollHeaderPreset.backTitle:
        return ScrollHeader.backTitle(
          title: Text(preset.label),
          subtitle: const Text('Back navigation with quick actions'),
          onBackTap: () => Navigator.of(context).pop(),
          actions: const [
            IconButton(icon: Icon(Icons.bookmark_border), onPressed: null),
            IconButton(icon: Icon(Icons.more_vert), onPressed: null),
          ],
        );

      case ScrollHeaderPreset.contextualSelection:
        return ScrollHeader.contextualSelection(
          selectedCount: 4,
          onClearSelection: () => Navigator.of(context).pop(),
          selectionActions: const [
            IconButton(icon: Icon(Icons.select_all), onPressed: null),
            IconButton(icon: Icon(Icons.archive_outlined), onPressed: null),
            IconButton(icon: Icon(Icons.delete_outline), onPressed: null),
          ],
        );

      case ScrollHeaderPreset.adaptiveNavigation:
        return ScrollHeader.adaptiveNavigation(
          breakpoint: 600.0,
          compactHeader: ScrollHeader.minimal(
            title: const Text('Mobile Header (<600px)'),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.of(context).pop(),
            ),
            actions: const [
              IconButton(icon: Icon(Icons.menu), onPressed: null),
            ],
          ),
          expandedHeader: ScrollHeader.material(
            title: const Text('Tablet/Desktop Header (≥600px)'),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.of(context).pop(),
            ),
            actions: [
              TextButton.icon(
                icon: const Icon(Icons.file_download),
                label: const Text('Export'),
                onPressed: null,
              ),
              const IconButton(icon: Icon(Icons.settings), onPressed: null),
            ],
          ),
        );

      case ScrollHeaderPreset.glass:
        return ScrollHeader.glass(
          title: Text(preset.label),
          subtitle: const Text('Translucent frosted blur glass'),
          blurSigma: 12.0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),
          actions: const [
            IconButton(icon: Icon(Icons.tune), onPressed: null),
          ],
        );

      case ScrollHeaderPreset.blurredBackground:
        return ScrollHeader.blurredBackground(
          title: Text(preset.label),
          subtitle: const Text('Performance-isolated backdrop blur'),
          blurSigma: 10.0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),
          actions: const [
            IconButton(icon: Icon(Icons.refresh), onPressed: null),
          ],
        );

      case ScrollHeaderPreset.bordered:
        return ScrollHeader.bordered(
          title: Text(preset.label),
          subtitle: const Text('Clean elevation-free hairline border'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),
          actions: const [
            IconButton(icon: Icon(Icons.check), onPressed: null),
          ],
        );

      case ScrollHeaderPreset.shadowElevated:
        return ScrollHeader.shadowElevated(
          title: Text(preset.label),
          subtitle: const Text('Deep multi-layer drop shadow'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),
          actions: const [
            IconButton(icon: Icon(Icons.star_border), onPressed: null),
          ],
        );

      case ScrollHeaderPreset.layered:
        return ScrollHeader.layered(
          title: Text(preset.label),
          subtitle: const Text('Three-layer depth architecture'),
          backLayer: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).colorScheme.primary.withValues(alpha: 0.15),
                  Theme.of(context).colorScheme.tertiary.withValues(alpha: 0.15),
                ],
              ),
            ),
          ),
          middleLayer: Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.only(right: 16.0, bottom: 8.0),
              child: Chip(
                label: const Text('Layer 2'),
                backgroundColor:
                    Theme.of(context).colorScheme.secondaryContainer,
              ),
            ),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),
          actions: const [
            IconButton(icon: Icon(Icons.layers_outlined), onPressed: null),
          ],
        );

      case ScrollHeaderPreset.shapeMorphing:
        return ScrollHeader.shapeMorphing(
          title: Text(preset.label),
          subtitle: const Text('Shape & radius morph on scroll'),
          initialBorderRadius: BorderRadius.circular(24.0),
          scrolledBorderRadius: BorderRadius.zero,
          expandedHeight: 120.0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),
          actions: const [
            IconButton(icon: Icon(Icons.transform), onPressed: null),
          ],
        );

      case ScrollHeaderPreset.animatedGradient:
        return ScrollHeader.animatedGradient(
          title: Text(preset.label),
          subtitle: const Text('Ambient shifting gradient'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),
          actions: const [
            IconButton(icon: Icon(Icons.auto_awesome), onPressed: null),
          ],
        );

      case ScrollHeaderPreset.colorTransition:
        return ScrollHeader.colorTransition(
          title: Text(preset.label),
          subtitle: const Text('Continuous color transition'),
          startBackgroundColor: Theme.of(context).colorScheme.primary,
          endBackgroundColor: Theme.of(context).colorScheme.surface,
          startForegroundColor: Colors.white,
          endForegroundColor: Theme.of(context).colorScheme.onSurface,
          expandedHeight: 120.0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),
          actions: const [
            IconButton(icon: Icon(Icons.palette_outlined), onPressed: null),
          ],
        );

      case ScrollHeaderPreset.illustrated:
        return ScrollHeader.illustrated(
          title: Text(preset.label),
          subtitle: const Text('Collapsing illustration header'),
          illustration: Icon(
            Icons.rocket_launch,
            size: 72.0,
            color: Theme.of(context).colorScheme.primary,
          ),
          expandedHeight: 220.0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),
          actions: const [
            IconButton(icon: Icon(Icons.favorite_border), onPressed: null),
          ],
        );

      case ScrollHeaderPreset.edgeToEdge:
        return ScrollHeader.edgeToEdge(
          title: Text(preset.label),
          subtitle: const Text('Full-bleed edge-to-edge layout'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),
          actions: const [
            IconButton(icon: Icon(Icons.crop_free), onPressed: null),
          ],
        );

      case ScrollHeaderPreset.mediaPlayer:
        return ScrollHeader.mediaPlayer(
          nowPlayingTitle: const Text('Midnight Jazz Vibes'),
          artist: const Text('The Blue Note Quintet'),
          albumArt: Container(
            color: Colors.deepPurple,
            child: const Icon(Icons.music_note, color: Colors.white),
          ),
          isPlaying: true,
          onPlayPause: () {},
          onPrevious: () {},
          onNext: () {},
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),
          actions: const [
            IconButton(icon: Icon(Icons.playlist_play), onPressed: null),
          ],
        );

      case ScrollHeaderPreset.shopping:
        return ScrollHeader.shopping(
          title: const Text('MegaStore Express'),
          cartItemCount: 3,
          onCartTap: () {},
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),
          actions: const [
            IconButton(icon: Icon(Icons.search), onPressed: null),
          ],
        );

      case ScrollHeaderPreset.chat:
        return ScrollHeader.chat(
          chatUser: const Text('Sarah Jenkins'),
          onlineStatus: const Text('Online • Typing...'),
          avatar: const CircleAvatar(
            radius: 18.0,
            backgroundColor: Colors.teal,
            child: Text(
              'SJ',
              style: TextStyle(color: Colors.white, fontSize: 13.0),
            ),
          ),
          onCallTap: () {},
          onVideoTap: () {},
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),
          actions: const [
            IconButton(icon: Icon(Icons.more_vert), onPressed: null),
          ],
        );

      case ScrollHeaderPreset.detailPage:
        return ScrollHeader.detailPage(
          title: const Text('Yosemite National Park'),
          subtitle: const Text('Sierra Nevada Mountains, California'),
          heroTag: 'destination-banner',
          background: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.teal, Colors.blueGrey],
              ),
            ),
            child: const Center(
              child: Icon(Icons.landscape, size: 72.0, color: Colors.white70),
            ),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
          actions: const [
            IconButton(
              icon: Icon(Icons.share, color: Colors.white),
              onPressed: null,
            ),
            IconButton(
              icon: Icon(Icons.bookmark_border, color: Colors.white),
              onPressed: null,
            ),
          ],
        );

      case ScrollHeaderPreset.reading:
        return ScrollHeader.reading(
          title: const Text('Understanding Reactive Architecture'),
          estimatedReadTime: '5 min read',
          readingProgress: 0.35,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),
          actions: const [
            IconButton(icon: Icon(Icons.text_fields), onPressed: null),
            IconButton(icon: Icon(Icons.bookmark_border), onPressed: null),
          ],
        );

      case ScrollHeaderPreset.map:
        return ScrollHeader.map(
          title: const Text('Downtown San Francisco'),
          searchHint: 'Search nearby cafes, restaurants...',
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),
          actions: const [
            IconButton(icon: Icon(Icons.tune), onPressed: null),
          ],
        );

      case ScrollHeaderPreset.form:
        return ScrollHeader.form(
          title: const Text('Edit User Profile'),
          subtitle: const Text('Unsaved changes'),
          isDirty: true,
          onSave: () {},
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.of(context).pop(),
          ),
          actions: const [
            IconButton(icon: Icon(Icons.more_vert), onPressed: null),
          ],
        );

      case ScrollHeaderPreset.wizard:
        return ScrollHeader.wizard(
          currentStep: 2,
          totalSteps: 4,
          stepTitle: const Text('Shipping Address'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),
          actions: const [
            IconButton(icon: Icon(Icons.help_outline), onPressed: null),
          ],
        );

      case ScrollHeaderPreset.notificationCenter:
        return ScrollHeader.notificationCenter(
          title: const Text('Activity Feed'),
          unreadCount: 4,
          onMarkAllRead: () {},
          segments: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ActionChip(
                visualDensity: VisualDensity.compact,
                label: const Text('All'),
                onPressed: () {},
              ),
              const SizedBox(width: 8.0),
              ActionChip(
                visualDensity: VisualDensity.compact,
                label: const Text('Unread (4)'),
                onPressed: () {},
              ),
            ],
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),
          actions: const [
            IconButton(icon: Icon(Icons.settings_outlined), onPressed: null),
          ],
        );

      case ScrollHeaderPreset.customScrollLayout:
        return ScrollHeader.customScrollLayout(
          expandedHeight: 180.0,
          collapsedHeight: 64.0,
          builder: (context, progress, overlapsContent) {
            final theme = Theme.of(context);
            return Container(
              color: Color.lerp(
                theme.colorScheme.primaryContainer,
                theme.colorScheme.surface,
                progress,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              alignment: Alignment.center,
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  const SizedBox(width: 8.0),
                  Text(
                    'Custom Sliver Layout: ${(progress * 100).toInt()}%',
                    style: theme.textTheme.titleMedium!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            );
          },
        );
    }
  }

  Widget _buildBody(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            color: Theme.of(context).colorScheme.primaryContainer
                .withValues(alpha: 0.4),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.preset.label,
                    style: const TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4.0),
                  Text(widget.preset.description),
                  const SizedBox(height: 12.0),
                  AnimatedBuilder(
                    animation: _controller,
                    builder: (context, _) {
                      return Text(
                        'Live Scroll Offset: ${_controller.currentOffset.toStringAsFixed(1)} px',
                        style: const TextStyle(
                          fontFamily: 'monospace',
                          fontWeight: FontWeight.w600,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16.0),
          ...List.generate(
            30,
            (i) => ListTile(
              leading: CircleAvatar(child: Text('${i + 1}')),
              title: Text('Sample item #${i + 1}'),
              subtitle: Text(
                'Scroll up and down to observe "${widget.preset.label}" interactions.',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
