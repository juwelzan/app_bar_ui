import 'package:flutter/material.dart';
import '../shared/model_meta.dart';
import '../shared/widgets/code_snippet_viewer.dart';
import '../shared/widgets/telemetry_hud_badge.dart';

/// The Main Dashboard providing an architectural overview, quick stats, and navigation shortcuts.
class DashboardScreen extends StatelessWidget {
  const DashboardScreen({
    super.key,
    required this.onNavigateToTab,
  });

  final ValueChanged<int> onNavigateToTab;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.sizeOf(context);
    final isCompact = size.width < 768.0;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 140.0,
            backgroundColor: theme.colorScheme.surface,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.only(left: 20.0, bottom: 16.0),
              title: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(6.0),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: const Icon(Icons.architecture, size: 18.0, color: Colors.white),
                  ),
                  const SizedBox(width: 10.0),
                  Text(
                    'app_bar_ui Studio',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
            ),
            actions: const [
              Padding(
                padding: EdgeInsets.only(right: 16.0),
                child: TelemetryHudBadge(compact: true),
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: isCompact ? 16.0 : 32.0,
                vertical: 16.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- Hero Introduction Banner ---
                  _buildHeroBanner(theme, isCompact),
                  const SizedBox(height: 24.0),

                  // --- Quick Stats Matrix ---
                  _buildStatsGrid(theme, isCompact),
                  const SizedBox(height: 28.0),

                  // --- Category Navigation Cards ---
                  Text(
                    'Explore Model Categories',
                    style: theme.textTheme.titleMedium!.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12.0),
                  _buildCategoryGrid(theme, isCompact),
                  const SizedBox(height: 28.0),

                  // --- Architectural Pillars ---
                  Text(
                    'Architectural Guarantees',
                    style: theme.textTheme.titleMedium!.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12.0),
                  _buildArchitectureHighlights(theme, isCompact),
                  const SizedBox(height: 28.0),

                  // --- Quick Code Snippet ---
                  Text(
                    'Canonical Single Public API Usage',
                    style: theme.textTheme.titleMedium!.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12.0),
                  const CodeSnippetViewer(
                    title: 'lib/main.dart • Universal Entrypoint',
                    code: '''// 1. Simple Canonical Mode
AppBarEngine(
  model: AppBarModel.floatingIsland,
  title: 'Dynamic Island Hub',
  subtitle: 'Adaptive telemetrics active',
  leading: const Icon(Icons.menu),
  actions: [
    IconButton(icon: const Icon(Icons.search), onPressed: () {}),
  ],
  body: const MyContentListView(),
)

// 2. Strongly-Typed Custom Configuration
AppBarEngine.custom(
  model: AppBarModel.editorialTypography,
  configuration: const EditorialTypographyConfig(
    headline: 'The Next Architecture in Mobile UI',
    category: 'Design Systems',
    serifFont: true,
    showReadingProgressBar: true,
  ),
  body: const MyArticleBody(),
)''',
                  ),
                  const SizedBox(height: 40.0),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroBanner(ThemeData theme, bool isCompact) {
    return Container(
      padding: EdgeInsets.all(isCompact ? 20.0 : 28.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.primaryContainer.withValues(alpha: 0.7),
            theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(
          color: theme.colorScheme.primary.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary,
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: const Text(
                  'v2.0.0 RELEASE',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10.0,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.8,
                  ),
                ),
              ),
              const SizedBox(width: 8.0),
              Text(
                'Production Component Engine',
                style: TextStyle(
                  fontSize: 12.0,
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12.0),
          Text(
            'The Ultimate Universal Flutter AppBar Design System',
            style: theme.textTheme.headlineSmall!.copyWith(
              fontWeight: FontWeight.w900,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 8.0),
          Text(
            '21 distinct autonomous header models, zero RenderFlex overflow guarantees, drift-free optical title centering, pure math scroll physics, and 100% web-safe platform adaptability.',
            style: theme.textTheme.bodyMedium!.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 20.0),
          Wrap(
            spacing: 12.0,
            runSpacing: 10.0,
            children: [
              FilledButton.icon(
                onPressed: () => onNavigateToTab(1), // Gallery
                icon: const Icon(Icons.style, size: 16.0),
                label: const Text('Browse 21 Models'),
              ),
              OutlinedButton.icon(
                onPressed: () => onNavigateToTab(2), // Studio
                icon: const Icon(Icons.tune, size: 16.0),
                label: const Text('Interactive Studio'),
              ),
              OutlinedButton.icon(
                onPressed: () => onNavigateToTab(3), // Lab
                icon: const Icon(Icons.devices, size: 16.0),
                label: const Text('Responsive Lab'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatsGrid(ThemeData theme, bool isCompact) {
    final stats = [
      ('21', 'Autonomous Models', 'Classic to spatial 3D', Icons.dashboard_customize, const Color(0xFF3B82F6)),
      ('0', 'RenderFlex Overflows', '320px to 1920px resilient', Icons.check_circle_outline, const Color(0xFF10B981)),
      ('1', 'Single Public API', 'AppBarEngine universal entry', Icons.hub_outlined, const Color(0xFF8B5CF6)),
      ('100%', 'Web & Desktop Safe', 'Zero dart:io restrictions', Icons.language, const Color(0xFF06B6D4)),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth < 600 ? 2 : 4;
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            crossAxisSpacing: 12.0,
            mainAxisSpacing: 12.0,
            childAspectRatio: isCompact ? 1.4 : 1.7,
          ),
          itemCount: stats.length,
          itemBuilder: (context, index) {
            final (val, title, sub, icon, col) = stats[index];
            return Card(
              child: Padding(
                padding: const EdgeInsets.all(14.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Icon(icon, size: 18.0, color: col),
                        const Spacer(),
                        Text(
                          val,
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.w900,
                            color: col,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6.0),
                    Text(
                      title,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12.0),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      sub,
                      style: TextStyle(color: theme.colorScheme.onSurfaceVariant, fontSize: 10.5),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildCategoryGrid(ThemeData theme, bool isCompact) {
    return Wrap(
      spacing: 12.0,
      runSpacing: 12.0,
      children: ModelCategory.values.map((cat) {
        final count = ModelMetadata.all.where((m) => m.category == cat).length;
        return InkWell(
          onTap: () => onNavigateToTab(1), // Jump to Gallery
          borderRadius: BorderRadius.circular(12.0),
          child: Container(
            width: isCompact ? 160.0 : 190.0,
            padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 12.0),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(12.0),
              border: Border.all(
                color: cat.color.withValues(alpha: 0.3),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(cat.icon, size: 20.0, color: cat.color),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 1.0),
                      decoration: BoxDecoration(
                        color: cat.color.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Text(
                        '$count',
                        style: TextStyle(
                          fontSize: 10.0,
                          fontWeight: FontWeight.bold,
                          color: cat.color,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8.0),
                Text(
                  cat.label,
                  style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildArchitectureHighlights(ThemeData theme, bool isCompact) {
    final pillars = [
      ('Pure Math Physics', 'Zero setState rebuild cascades during high-frequency scrolling interactions.', Icons.speed),
      ('Zero-Leak Lifecycle', 'Controllers and listeners automatically disposed upon switching models at runtime.', Icons.cleaning_services_outlined),
      ('Optical Slot Centering', 'Maintains true optical title centering regardless of asymmetric trailing action clusters.', Icons.center_focus_strong_outlined),
      ('Universal Responsive Engine', 'Categorizes viewports dynamically across 5 distinct classes from 320px to 1920px+.', Icons.devices),
    ];

    return Column(
      children: pillars.map((p) {
        final (title, desc, icon) = p;
        return Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: ListTile(
            tileColor: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
            leading: Icon(icon, color: theme.colorScheme.primary),
            title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13.0)),
            subtitle: Text(desc, style: TextStyle(color: theme.colorScheme.onSurfaceVariant, fontSize: 11.5)),
          ),
        );
      }).toList(),
    );
  }
}
