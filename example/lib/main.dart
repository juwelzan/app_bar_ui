import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:app_bar_ui/app_bar_ui.dart';

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
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CircleAvatar(
                  radius: 32.0,
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.person,
                    size: 40.0,
                    color: Color(0xFF2C3E50),
                  ),
                ),
                const SizedBox(height: 8.0),
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
// TAB 5: Presets Showcase (Material, Minimal, iOS, Dashboard, Transparent)
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
