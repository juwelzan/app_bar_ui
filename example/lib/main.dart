import 'package:flutter/material.dart';
import 'package:app_bar_ui/app_bar_ui.dart';
import 'src/dashboard/dashboard_screen.dart';
import 'src/gallery/model_gallery_screen.dart';
import 'src/studio/studio_screen.dart';
import 'src/lab/responsive_platform_lab_screen.dart';
import 'src/animations/animation_playground_screen.dart';
import 'src/shared/app_theme.dart';

/// Global theme mode notifier for interactive light and dark theme switching.
final ValueNotifier<ThemeMode> themeModeNotifier = ValueNotifier<ThemeMode>(
  ThemeMode.system,
);

void main() {
  runApp(const ScrollResponsiveDemoApp());
}

/// The main demo application demonstrating the `app_bar_ui` Universal Component System.
class ScrollResponsiveDemoApp extends StatelessWidget {
  const ScrollResponsiveDemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeModeNotifier,
      builder: (context, currentThemeMode, _) {
        return MaterialApp(
          title: 'app_bar_ui Studio',
          debugShowCheckedModeBanner: false,
          themeMode: currentThemeMode,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          home: const ShowcaseHomeScreen(),
        );
      },
    );
  }
}

/// Main container screen featuring an adaptive shell (NavigationBar on mobile, NavigationRail on desktop).
class ShowcaseHomeScreen extends StatefulWidget {
  const ShowcaseHomeScreen({super.key});

  @override
  State<ShowcaseHomeScreen> createState() => _ShowcaseHomeScreenState();
}

class _ShowcaseHomeScreenState extends State<ShowcaseHomeScreen> {
  int _currentTabIndex = 0;
  AppBarModel _targetStudioModel = AppBarModel.floatingIsland;
  AppBarModel _targetLabModel = AppBarModel.floatingIsland;

  void _onNavigateToTab(int index) {
    setState(() => _currentTabIndex = index);
  }

  void _onSelectModelInStudio(AppBarModel model) {
    setState(() {
      _targetStudioModel = model;
      _currentTabIndex = 2; // Jump to Studio
    });
  }

  void _onSelectModelInLab(AppBarModel model) {
    setState(() {
      _targetLabModel = model;
      _currentTabIndex = 3; // Jump to Lab
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.sizeOf(context);
    final isDesktop = size.width >= 768.0;

    final tabs = [
      DashboardScreen(onNavigateToTab: _onNavigateToTab),
      ModelGalleryScreen(
        onSelectModelInStudio: _onSelectModelInStudio,
        onSelectModelInLab: _onSelectModelInLab,
      ),
      StudioScreen(initialModel: _targetStudioModel),
      ResponsivePlatformLabScreen(initialModel: _targetLabModel),
      const AnimationPlaygroundScreen(),
    ];

    final destinations = const [
      NavigationDestination(
        icon: Icon(Icons.dashboard_outlined),
        selectedIcon: Icon(Icons.dashboard),
        label: 'Dashboard',
      ),
      NavigationDestination(
        icon: Icon(Icons.style_outlined),
        selectedIcon: Icon(Icons.style),
        label: 'Models (21)',
      ),
      NavigationDestination(
        icon: Icon(Icons.tune_outlined),
        selectedIcon: Icon(Icons.tune),
        label: 'Studio',
      ),
      NavigationDestination(
        icon: Icon(Icons.devices_outlined),
        selectedIcon: Icon(Icons.devices),
        label: 'Lab',
      ),
      NavigationDestination(
        icon: Icon(Icons.animation_outlined),
        selectedIcon: Icon(Icons.animation),
        label: 'Motion',
      ),
    ];

    if (isDesktop) {
      return Scaffold(
        body: Row(
          children: [
            NavigationRail(
              selectedIndex: _currentTabIndex,
              onDestinationSelected: (index) {
                setState(() => _currentTabIndex = index);
              },
              extended: size.width >= 1100.0,
              minExtendedWidth: 200.0,
              leading: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: const Icon(Icons.architecture, color: Colors.white, size: 20.0),
                    ),
                    if (size.width >= 1100.0) ...[
                      const SizedBox(width: 10.0),
                      Text(
                        'app_bar_ui',
                        style: theme.textTheme.titleMedium!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              trailing: Expanded(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: IconButton(
                      tooltip: themeModeNotifier.value == ThemeMode.dark ? 'Switch to Light Mode' : 'Switch to Dark Mode',
                      icon: Icon(
                        themeModeNotifier.value == ThemeMode.dark ? Icons.light_mode : Icons.dark_mode_outlined,
                      ),
                      onPressed: () {
                        themeModeNotifier.value = themeModeNotifier.value == ThemeMode.dark
                            ? ThemeMode.light
                            : ThemeMode.dark;
                      },
                    ),
                  ),
                ),
              ),
              destinations: const [
                NavigationRailDestination(
                  icon: Icon(Icons.dashboard_outlined),
                  selectedIcon: Icon(Icons.dashboard),
                  label: Text('Dashboard'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.style_outlined),
                  selectedIcon: Icon(Icons.style),
                  label: Text('Models (21)'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.tune_outlined),
                  selectedIcon: Icon(Icons.tune),
                  label: Text('Studio'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.devices_outlined),
                  selectedIcon: Icon(Icons.devices),
                  label: Text('Lab'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.animation_outlined),
                  selectedIcon: Icon(Icons.animation),
                  label: Text('Motion'),
                ),
              ],
            ),
            const VerticalDivider(thickness: 1, width: 1),
            Expanded(
              child: IndexedStack(
                index: _currentTabIndex,
                children: tabs,
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      body: IndexedStack(index: _currentTabIndex, children: tabs),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentTabIndex,
        onDestinationSelected: (index) {
          setState(() => _currentTabIndex = index);
        },
        destinations: destinations,
      ),
    );
  }
}
