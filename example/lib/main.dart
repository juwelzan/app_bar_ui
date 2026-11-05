import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:app_bar_ui/app_bar_ui.dart';

void main() {
  runApp(const ScrollResponsiveDemoApp());
}

/// The main demo application demonstrating the [ScrollResponsiveScaffold] system.
class ScrollResponsiveDemoApp extends StatelessWidget {
  const ScrollResponsiveDemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Scroll Responsive UI Demo',
      debugShowCheckedModeBanner: false,
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
      home: const DashboardScreen(),
    );
  }
}

/// A comprehensive dashboard screen demonstrating scroll-responsive transitions.
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  // Live telemetry notifier for high-performance zero-rebuild telemetry updates
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

  // Configurable options
  ScrollTransitionType _transitionType = ScrollTransitionType.scrollProgress;
  bool _enableFade = true;
  bool _enableScale = true;
  bool _enableSlide = true;
  bool _hideStatusBar = true;

  @override
  void dispose() {
    _telemetryNotifier.dispose();
    super.dispose();
  }

  void _showNotificationSheet() {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) => Padding(
        padding: const EdgeInsets.fromLTRB(20.0, 8.0, 20.0, 28.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.notifications_active, color: Colors.amber),
                const SizedBox(width: 8.0),
                Text(
                  'Notifications (3)',
                  style: Theme.of(context).textTheme.titleLarge
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const Divider(height: 24.0),
            const ListTile(
              contentPadding: EdgeInsets.zero,
              leading: CircleAvatar(
                backgroundColor: Colors.blueAccent,
                child: Icon(Icons.cloud_done, color: Colors.white, size: 20),
              ),
              title: Text('Database sync completed'),
              subtitle: Text('2 minutes ago'),
            ),
            const ListTile(
              contentPadding: EdgeInsets.zero,
              leading: CircleAvatar(
                backgroundColor: Colors.green,
                child: Icon(Icons.security, color: Colors.white, size: 20),
              ),
              title: Text('Security audit passed'),
              subtitle: Text('1 hour ago'),
            ),
            const ListTile(
              contentPadding: EdgeInsets.zero,
              leading: CircleAvatar(
                backgroundColor: Colors.orange,
                child: Icon(Icons.bolt, color: Colors.white, size: 20),
              ),
              title: Text('High performance mode active'),
              subtitle: Text('3 hours ago'),
            ),
          ],
        ),
      ),
    );
  }

  void _showProfileSheet() {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) => Padding(
        padding: const EdgeInsets.fromLTRB(20.0, 8.0, 20.0, 28.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircleAvatar(
              radius: 36,
              backgroundColor: Color(0xFF3F51B5),
              child: Text(
                'AR',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 12.0),
            Text(
              'Alex Rivera',
              style: Theme.of(context).textTheme.titleLarge
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            Text(
              'Lead Architect & Developer',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 20.0),
            ListTile(
              leading: const Icon(Icons.email_outlined),
              title: const Text('alex.rivera@example.com'),
              dense: true,
            ),
            ListTile(
              leading: const Icon(Icons.badge_outlined),
              title: const Text('Employee ID #94821'),
              dense: true,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final config = ScrollResponsiveConfig(
      pinSideActions: true,
      transparentActions: true,
      hideStatusBarOnScroll: _hideStatusBar,
      enableReverseAnimation: true,
      thresholds: const ScrollThresholdConfig(
        leadingStartOffset: 20.0,
        leadingEndOffset: 80.0,
        trailingStartOffset: 20.0,
        trailingEndOffset: 80.0,
        statusBarHideOffset: 90.0,
        statusBarShowOffset: 45.0,
      ),
      animation: ScrollAnimationConfig(
        transitionType: _transitionType,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOutCubic,
        minScale: 0.75,
        maxScale: 1.0,
        slideOffset: const Offset(0.0, 0.15),
        enableFade: _enableFade,
        enableScale: _enableScale,
        enableSlide: _enableSlide,
      ),
    );

    return ScrollResponsiveScaffold(
      config: config,
      // Left side action: Profile Avatar initially, Drawer icon when scrolled
      initialLeading: const Tooltip(
        message: 'View Profile',
        child: CircleAvatar(
          radius: 18,
          backgroundColor: Color(0xFF3F51B5),
          child: Text(
            'AR',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
      scrolledLeading: const Tooltip(
        message: 'Open Navigation Drawer',
        child: Icon(Icons.menu, size: 26),
      ),

      // Right side action: Notification initially, Profile Avatar when scrolled
      initialTrailing: Tooltip(
        message: 'View Notifications',
        child: Stack(
          alignment: Alignment.center,
          children: [
            const Icon(Icons.notifications_none, size: 26),
            Positioned(
              top: 8,
              right: 8,
              child: Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Colors.redAccent,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        ),
      ),
      scrolledTrailing: const Tooltip(
        message: 'Quick Profile Access',
        child: CircleAvatar(
          radius: 17,
          backgroundColor: Color(0xFF3F51B5),
          child: Text(
            'AR',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),

      // Callbacks
      onLeadingInitialTap: _showProfileSheet,
      // onLeadingScrolledTap will automatically open drawer since drawer is provided
      onTrailingInitialTap: _showNotificationSheet,
      onTrailingScrolledTap: _showProfileSheet,

      onScrollUpdate: (details) {
        _telemetryNotifier.value = details;
      },

      // Navigation Drawer
      drawer: NavigationDrawer(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(28, 20, 16, 10),
            child: Text(
              'Workspace Menu',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const NavigationDrawerDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard),
            label: Text('Dashboard'),
          ),
          const NavigationDrawerDestination(
            icon: Icon(Icons.insights_outlined),
            selectedIcon: Icon(Icons.insights),
            label: Text('Analytics'),
          ),
          const NavigationDrawerDestination(
            icon: Icon(Icons.task_alt_outlined),
            selectedIcon: Icon(Icons.task_alt),
            label: Text('Tasks'),
          ),
          const NavigationDrawerDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings),
            label: Text('Settings'),
          ),
        ],
      ),

      // Fully scrollable header
      header: ScrollResponsiveHeader(
        welcome: const Text('Welcome back, Alex 👋'),
        title: const Text('Project Overview'),
        subtitle: const Text('High-efficiency scroll responsive layout system'),
        content: Wrap(
          spacing: 8.0,
          runSpacing: 8.0,
          children: [
            Chip(
              avatar: const Icon(Icons.touch_app, size: 16),
              label: const Text('Independent Pins'),
              visualDensity: VisualDensity.compact,
            ),
            Chip(
              avatar: const Icon(Icons.animation, size: 16),
              label: const Text('Fluid 120 FPS'),
              visualDensity: VisualDensity.compact,
            ),
            Chip(
              avatar: const Icon(Icons.phone_android, size: 16),
              label: const Text('Status Bar Sync'),
              visualDensity: VisualDensity.compact,
            ),
          ],
        ),
      ),

      // Main scrollable body
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Telemetry Monitor Card
            Card(
              elevation: 0,
              color: theme.colorScheme.surfaceContainerHighest.withValues(
                alpha: 0.5,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
                side: BorderSide(
                  color: theme.colorScheme.outlineVariant.withValues(
                    alpha: 0.5,
                  ),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: ValueListenableBuilder<ScrollProgressDetails>(
                  valueListenable: _telemetryNotifier,
                  builder: (context, details, child) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.speed, size: 20),
                            const SizedBox(width: 8.0),
                            Text(
                              'Live Transition Telemetry',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12.0),
                        _buildTelemetryRow(
                          'Scroll Offset',
                          '${details.offset.toStringAsFixed(1)} px',
                        ),
                        const SizedBox(height: 6.0),
                        _buildTelemetryRow(
                          'Left Icon Progress (Avatar → Drawer)',
                          '${(details.leadingProgress * 100).toInt()}%',
                          progress: details.leadingProgress,
                        ),
                        const SizedBox(height: 6.0),
                        _buildTelemetryRow(
                          'Right Icon Progress (Bell → Avatar)',
                          '${(details.trailingProgress * 100).toInt()}%',
                          progress: details.trailingProgress,
                        ),
                        const SizedBox(height: 6.0),
                        _buildTelemetryRow(
                          'System Status Bar',
                          details.isStatusBarHidden
                              ? 'Hidden (Scrolled)'
                              : 'Visible (Restored)',
                        ),
                        const SizedBox(height: 6.0),
                        _buildTelemetryRow(
                          'Scroll Direction',
                          details.scrollDirection.name.toUpperCase(),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),

            const SizedBox(height: 16.0),

            // Live Settings Card
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
                side: BorderSide(
                  color: theme.colorScheme.outlineVariant.withValues(
                    alpha: 0.5,
                  ),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Interactive Config Controls',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    SwitchListTile.adaptive(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Hide Status Bar on Scroll'),
                      value: _hideStatusBar,
                      onChanged: (val) => setState(() => _hideStatusBar = val),
                    ),
                    SwitchListTile.adaptive(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Fade Animation'),
                      value: _enableFade,
                      onChanged: (val) => setState(() => _enableFade = val),
                    ),
                    SwitchListTile.adaptive(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Scale Animation'),
                      value: _enableScale,
                      onChanged: (val) => setState(() => _enableScale = val),
                    ),
                    SwitchListTile.adaptive(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Slide Animation'),
                      value: _enableSlide,
                      onChanged: (val) => setState(() => _enableSlide = val),
                    ),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Transition Mode'),
                      trailing: DropdownButton<ScrollTransitionType>(
                        value: _transitionType,
                        underline: const SizedBox(),
                        items: const [
                          DropdownMenuItem(
                            value: ScrollTransitionType.scrollProgress,
                            child: Text('Scroll Progress'),
                          ),
                          DropdownMenuItem(
                            value: ScrollTransitionType.thresholdTriggered,
                            child: Text('Triggered Animation'),
                          ),
                        ],
                        onChanged: (val) {
                          if (val != null) {
                            setState(() => _transitionType = val);
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16.0),

            // List of activity items demonstrating continuous scrolling
            ...List.generate(
              20,
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
                  title: Text('Activity Task #${index + 1}'),
                  subtitle: Text(
                    'Status update event logged at ${10 + index}:00 AM',
                  ),
                  trailing: const Icon(Icons.chevron_right, size: 20),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Tapped task #${index + 1}'),
                        duration: const Duration(seconds: 1),
                      ),
                    );
                  },
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
            Expanded(
              child: Text(
                label,
                style: const TextStyle(fontSize: 12.0, color: Colors.grey),
              ),
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
