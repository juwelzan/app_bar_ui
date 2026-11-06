import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:app_bar_ui/app_bar_ui.dart';

/// Interactive Design System Gallery showcasing the 20 Independent AppBar Models.
///
/// Provides live model switching with zero-leak transitions, real-time parameter
/// tweaking across 3 customization levels, live telemetry, and instant code generation.
class DesignSystemGalleryTab extends StatefulWidget {
  const DesignSystemGalleryTab({super.key});

  @override
  State<DesignSystemGalleryTab> createState() => _DesignSystemGalleryTabState();
}

enum CustomizationLevel {
  level1Preset('Level 1: Preset Mode', 'Zero-config default preset model'),
  level2Configured('Level 2: Configurable Mode', 'Fine-grained typed model configuration'),
  level3CustomBuilder('Level 3: Custom Builder Mode', 'Complete custom widget & motion overrides');

  const CustomizationLevel(this.label, this.description);
  final String label;
  final String description;
}

class _DesignSystemGalleryTabState extends State<DesignSystemGalleryTab> {
  final AppBarController _appBarController = AppBarController(
    initialModel: AppBarModel.traditionalStructured,
  );

  AppBarModel _selectedModel = AppBarModel.traditionalStructured;
  CustomizationLevel _selectedLevel = CustomizationLevel.level2Configured;
  ModelTransitionType _transitionType = ModelTransitionType.fade;

  // --- Model 1: Traditional Structured Parameters ---
  String _orgName = 'Enterprise Cloud Nexus';
  EnvironmentBadge _environment = EnvironmentBadge.production;
  bool _stickyTabs = true;
  double _m1ExpandedHeight = 170.0;

  // --- Model 2: Full-Screen Hero Parameters ---
  String _heroHeadline = 'Cinematic Odyssey';
  String _heroTagline = 'An IMAX Original Documentary';
  double _heroViewportHeight = 380.0;
  double _heroCollapsedHeight = 64.0;

  // --- Model 3: Floating Dynamic Island Parameters ---
  String _islandTitle = 'Dynamic Flight Track';
  String _islandSubtitle = 'Flight AG-204 • On Time';
  double _expandedMargin = 20.0;
  double _compactMargin = 36.0;
  double _islandRadius = 28.0;

  // --- Model 4: Edge-to-Edge Immersive Spatial Parameters ---
  String _spatialTitle = 'Spatial Reality Canvas';
  String _spatialSubtitle = '3-Depth Differential Parallax Active';
  double _spatialBgFactor = 0.25;
  double _spatialMgFactor = 0.60;
  double _spatialFocalBlur = 8.0;

  // --- Model 5: Multi-Panel Split Curtain Parameters ---
  String _curtainLeftTitle = 'Enterprise Cloud';
  String _curtainLeftSubtitle = 'Multi-Region Ingress';
  double _curtainSplitGap = 36.0;

  // --- Model 6: 3D Spatial Perspective Flip Parameters ---
  String _flipFrontTitle = 'Portfolio Vault';
  String _flipFrontMetric = '\$142,850.00';
  String _flipBackTitle = 'Instant Quick Actions';

  // --- Model 7: Vertical Rail Transform Parameters ---
  String _railTitle = 'Engineering Hub';
  String _railSubtitle = 'Sprint 42 Active';
  int _railIndex = 0;

  // --- Model 8: Radial Polar Dial Parameters ---
  String _dialTitle = 'Radial Navigator';
  double _dialRadius = 88.0;
  int _dialIndex = 0;

  // --- Model 9: Editorial Typography Parameters ---
  String _editorialHeadline = 'The Architecture of Thought';
  String _editorialCategory = 'Systems Engineering';
  bool _editorialSerif = true;
  bool _editorialReadingBar = true;
  double _editorialExpandedHeight = 220.0;

  // --- Model 10: Card Deck Stacked Parameters ---
  String _deckTitle = 'Card Wallet';
  int _activeCardIndex = 0;
  double _cardOverlap = 18.0;

  // --- Model 11: Minimalist Micro-Bar Parameters ---
  String _microBreadcrumb = 'packages / app_bar_ui / lib / engine.dart';
  String _microEta = '4 min read';
  String _microStatus = 'v2.4.0 • clean';
  bool _microMonospace = true;
  bool _microProgressDot = true;

  // --- Model 12: Profile & Identity Centered Parameters ---
  String _profileName = 'Dr. Eleanor Vance';
  String _profileHandle = '@eleanor_vance';
  String _profileBio = 'Principal Systems Architect';
  bool _profileVerified = true;
  double _profileAvatarSize = 72.0;

  // Telemetry
  int _switchCount = 0;

  @override
  void dispose() {
    _appBarController.dispose();
    super.dispose();
  }

  void _onModelSelected(AppBarModel model) {
    if (_selectedModel == model) return;
    setState(() {
      _selectedModel = model;
      _switchCount++;
    });
    _appBarController.changeModel(
      model,
      transition: ModelTransitionSpec(
        type: _transitionType,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOutCubic,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Row(
        children: [
          // Left Canvas: Active AppBar Experience
          Expanded(
            flex: 6,
            child: Container(
              color: theme.colorScheme.surfaceContainerLowest,
              child: _buildActiveAppBarView(context),
            ),
          ),

          // Right Inspector: Controls, Sliders & Code Generator
          Expanded(
            flex: 5,
            child: Container(
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                border: Border(
                  left: BorderSide(
                    color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
                  ),
                ),
              ),
              child: _buildInspector(context, theme),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActiveAppBarView(BuildContext context) {
    switch (_selectedLevel) {
      case CustomizationLevel.level1Preset:
        return AppBarEngine(
          key: ValueKey('preset_$_selectedModel'),
          controller: _appBarController,
          model: _selectedModel,
          body: _buildScrollableBody(context),
        );

      case CustomizationLevel.level2Configured:
        return _buildLevel2ConfiguredEngine(context);

      case CustomizationLevel.level3CustomBuilder:
        return _buildLevel3CustomEngine(context);
    }
  }

  Widget _buildLevel2ConfiguredEngine(BuildContext context) {
    switch (_selectedModel) {
      case AppBarModel.traditionalStructured:
        return AppBarEngine.custom(
          key: ValueKey('l2_trad_${_orgName}_$_environment'),
          controller: _appBarController,
          model: AppBarModel.traditionalStructured,
          configuration: TraditionalStructuredConfig(
            organizationName: _orgName,
            environment: _environment,
            stickyTabStrip: _stickyTabs,
            expandedHeight: _m1ExpandedHeight,
            breadcrumbs: const [
              StructuredBreadcrumbNode(label: 'Home', icon: Icons.home_outlined),
              StructuredBreadcrumbNode(label: 'Infrastructure'),
              StructuredBreadcrumbNode(label: 'Edge Clusters'),
            ],
            tabs: const [
              Tab(text: 'Overview'),
              Tab(text: 'Nodes'),
              Tab(text: 'Network'),
              Tab(text: 'Security'),
            ],
          ),
          body: _buildScrollableBody(context),
        );

      case AppBarModel.fullScreenHero:
        return AppBarEngine.custom(
          key: ValueKey('l2_hero_${_heroHeadline}_$_heroViewportHeight'),
          controller: _appBarController,
          model: AppBarModel.fullScreenHero,
          configuration: FullScreenHeroConfig(
            headline: _heroHeadline,
            tagline: _heroTagline,
            customViewportHeight: _heroViewportHeight,
            collapsedHeight: _heroCollapsedHeight,
          ),
          body: _buildScrollableBody(context),
        );

      case AppBarModel.floatingIsland:
        return AppBarEngine.custom(
          key: ValueKey('l2_island_${_islandTitle}_$_expandedMargin'),
          controller: _appBarController,
          model: AppBarModel.floatingIsland,
          configuration: FloatingIslandConfig(
            islandTitle: _islandTitle,
            islandSubtitle: _islandSubtitle,
            expandedHorizontalMargin: _expandedMargin,
            compactHorizontalMargin: _compactMargin,
            borderRadius: _islandRadius,
          ),
          body: _buildScrollableBody(context),
        );

      case AppBarModel.immersiveSpatial:
        return AppBarEngine.custom(
          key: ValueKey('l2_spatial_${_spatialTitle}_$_spatialBgFactor'),
          controller: _appBarController,
          model: AppBarModel.immersiveSpatial,
          configuration: ImmersiveSpatialConfig(
            titleText: _spatialTitle,
            subtitleText: _spatialSubtitle,
            backgroundParallaxFactor: _spatialBgFactor,
            midgroundParallaxFactor: _spatialMgFactor,
            focalDepthBlur: _spatialFocalBlur,
          ),
          body: _buildScrollableBody(context),
        );

      case AppBarModel.multiPanelSplitCurtain:
        return AppBarEngine.custom(
          key: ValueKey('l2_curtain_${_curtainLeftTitle}_$_curtainSplitGap'),
          controller: _appBarController,
          model: AppBarModel.multiPanelSplitCurtain,
          configuration: MultiPanelSplitCurtainConfig(
            leftPanelTitle: _curtainLeftTitle,
            leftPanelSubtitle: _curtainLeftSubtitle,
            splitGap: _curtainSplitGap,
          ),
          body: _buildScrollableBody(context),
        );

      case AppBarModel.spatial3DFlip:
        return AppBarEngine.custom(
          key: ValueKey('l2_flip_${_flipFrontTitle}_$_flipFrontMetric'),
          controller: _appBarController,
          model: AppBarModel.spatial3DFlip,
          configuration: Spatial3DFlipConfig(
            frontTitle: _flipFrontTitle,
            frontMetricValue: _flipFrontMetric,
            backTitle: _flipBackTitle,
          ),
          body: _buildScrollableBody(context),
        );

      case AppBarModel.verticalRailTransform:
        return AppBarEngine.custom(
          key: ValueKey('l2_rail_${_railTitle}_$_railIndex'),
          controller: _appBarController,
          model: AppBarModel.verticalRailTransform,
          configuration: VerticalRailTransformConfig(
            expandedTitle: _railTitle,
            expandedSubtitle: _railSubtitle,
            selectedIndex: _railIndex,
            onDestinationSelected: (idx) => setState(() => _railIndex = idx),
          ),
          body: _buildScrollableBody(context),
        );

      case AppBarModel.radialDial:
        return AppBarEngine.custom(
          key: ValueKey('l2_dial_${_dialTitle}_${_dialRadius}_$_dialIndex'),
          controller: _appBarController,
          model: AppBarModel.radialDial,
          configuration: RadialDialConfig(
            dialCenterTitle: _dialTitle,
            arcRadius: _dialRadius,
            selectedDialIndex: _dialIndex,
            onDialItemSelected: (idx) => setState(() => _dialIndex = idx),
          ),
          body: _buildScrollableBody(context),
        );

      case AppBarModel.editorialTypography:
        return AppBarEngine.custom(
          key: ValueKey('l2_editorial_${_editorialHeadline}_${_editorialCategory}_$_editorialSerif'),
          controller: _appBarController,
          model: AppBarModel.editorialTypography,
          configuration: EditorialTypographyConfig(
            headline: _editorialHeadline,
            category: _editorialCategory,
            serifFont: _editorialSerif,
            showReadingProgressBar: _editorialReadingBar,
            expandedHeight: _editorialExpandedHeight,
          ),
          body: _buildScrollableBody(context),
        );

      case AppBarModel.cardDeckStacked:
        return AppBarEngine.custom(
          key: ValueKey('l2_deck_${_deckTitle}_${_activeCardIndex}_$_cardOverlap'),
          controller: _appBarController,
          model: AppBarModel.cardDeckStacked,
          configuration: CardDeckStackedConfig(
            deckTitle: _deckTitle,
            activeCardIndex: _activeCardIndex,
            cardOverlap: _cardOverlap,
            onCardSwiped: (idx) => setState(() => _activeCardIndex = idx),
          ),
          body: _buildScrollableBody(context),
        );

      case AppBarModel.minimalistMicroBar:
        return AppBarEngine.custom(
          key: ValueKey('l2_micro_${_microBreadcrumb}_${_microEta}_$_microMonospace'),
          controller: _appBarController,
          model: AppBarModel.minimalistMicroBar,
          configuration: MinimalistMicroBarConfig(
            pathBreadcrumb: _microBreadcrumb,
            readingEta: _microEta,
            documentStatus: _microStatus,
            monospace: _microMonospace,
            showProgressDot: _microProgressDot,
          ),
          body: _buildScrollableBody(context),
        );

      case AppBarModel.profileIdentity:
        return AppBarEngine.custom(
          key: ValueKey('l2_profile_${_profileName}_${_profileVerified}_$_profileAvatarSize'),
          controller: _appBarController,
          model: AppBarModel.profileIdentity,
          configuration: ProfileIdentityConfig(
            userName: _profileName,
            userHandle: _profileHandle,
            bio: _profileBio,
            verified: _profileVerified,
            expandedAvatarSize: _profileAvatarSize,
          ),
          body: _buildScrollableBody(context),
        );

      default:
        return AppBarEngine(
          controller: _appBarController,
          model: _selectedModel,
          body: _buildScrollableBody(context),
        );
    }
  }

  Widget _buildLevel3CustomEngine(BuildContext context) {
    return AppBarEngine(
      key: ValueKey('l3_custom_$_selectedModel'),
      controller: _appBarController,
      model: _selectedModel,
      configuration: AppBarConfiguration(
        layout: LayoutConfiguration(
          expandedHeight: 180.0,
          collapsedHeight: 64.0,
          customLayoutBuilder: (context, constraints, configuration) {
            final p = constraints.maxHeight <= 64.0
                ? 1.0
                : (1.0 - (constraints.maxHeight - 64.0) / (180.0 - 64.0)).clamp(0.0, 1.0);
            return Material(
              color: Color.lerp(Colors.indigo.shade900, Colors.black, p),
              elevation: p > 0.8 ? 8.0 : 0.0,
              child: SafeArea(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.code, color: Colors.cyanAccent),
                            const SizedBox(width: 8.0),
                            Text(
                              'Level 3 Custom Override (${_selectedModel.displayName})',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 6.0),
                      Text(
                        'Height: ${constraints.maxHeight.toStringAsFixed(1)}px | Progress: ${(p * 100).toStringAsFixed(1)}%',
                        style: const TextStyle(color: Colors.white70, fontSize: 12.0),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
      body: _buildScrollableBody(context),
    );
  }

  Widget _buildScrollableBody(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Column(
        children: List.generate(25, (index) {
          return Card(
            margin: const EdgeInsets.only(bottom: 10.0),
            elevation: 0.5,
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: theme.colorScheme.primaryContainer,
                child: Text('${index + 1}'),
              ),
              title: Text('Telemetry Item #${index + 1}'),
              subtitle: Text(
                'Active Model: ${_selectedModel.displayName} • Level: ${_selectedLevel.label}',
              ),
              trailing: const Icon(Icons.arrow_forward_ios, size: 14.0),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildInspector(BuildContext context, ThemeData theme) {
    return ListView(
      padding: const EdgeInsets.all(20.0),
      children: [
        // Header
        Row(
          children: [
            const Icon(Icons.design_services, color: Color(0xFF3F51B5)),
            const SizedBox(width: 10.0),
            Expanded(
              child: Text(
                'Design System Studio',
                style: theme.textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4.0),
        Text(
          '20 Independent AppBar Models • 3 Customization Levels • Zero-Leak Transitions',
          style: theme.textTheme.bodySmall!.copyWith(color: theme.colorScheme.outline),
        ),
        const Divider(height: 28.0),

        // Section 1: Model Selection Grid
        Text('1. Independent Design Model', style: theme.textTheme.titleSmall),
        const SizedBox(height: 8.0),
        _buildModelGrid(theme),
        const SizedBox(height: 16.0),

        // Section 2: Customization Level
        Text('2. Customization Level', style: theme.textTheme.titleSmall),
        const SizedBox(height: 8.0),
        Wrap(
          spacing: 8.0,
          runSpacing: 6.0,
          children: CustomizationLevel.values.map((level) {
            final isSelected = _selectedLevel == level;
            return ChoiceChip(
              label: Text(level == CustomizationLevel.level1Preset
                  ? 'Preset'
                  : level == CustomizationLevel.level2Configured
                      ? 'Configured'
                      : 'Custom'),
              selected: isSelected,
              onSelected: (selected) {
                if (selected) setState(() => _selectedLevel = level);
              },
            );
          }).toList(),
        ),
        const SizedBox(height: 16.0),

        // Section 3: Transition Spec
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 8.0,
          children: [
            Text('Transition Style:', style: theme.textTheme.bodyMedium),
            DropdownButton<ModelTransitionType>(
              value: _transitionType,
              underline: const SizedBox.shrink(),
              items: ModelTransitionType.values.map((t) {
                return DropdownMenuItem(value: t, child: Text(t.name.toUpperCase()));
              }).toList(),
              onChanged: (val) {
                if (val != null) setState(() => _transitionType = val);
              },
            ),
          ],
        ),
        const Divider(height: 24.0),

        // Section 4: Live Parameter Playground
        if (_selectedLevel == CustomizationLevel.level2Configured) ...[
          Text('3. Live Parameters (${_selectedModel.displayName})', style: theme.textTheme.titleSmall),
          const SizedBox(height: 12.0),
          _buildParametersForModel(theme),
          const Divider(height: 24.0),
        ],

        // Section 5: Telemetry HUD
        _buildTelemetryHUD(theme),
        const SizedBox(height: 16.0),

        // Section 6: Live Code Generator
        _buildCodeGenerator(context, theme),
      ],
    );
  }

  Widget _buildModelGrid(ThemeData theme) {
    final allModels = [
      // Batch A (Models 1–4)
      (AppBarModel.traditionalStructured, 'M1: Traditional Structured', Icons.business_outlined),
      (AppBarModel.fullScreenHero, 'M2: Full-Screen Hero', Icons.movie_outlined),
      (AppBarModel.floatingIsland, 'M3: Floating Dynamic Island', Icons.bubble_chart_outlined),
      (AppBarModel.immersiveSpatial, 'M4: Immersive Spatial Parallax', Icons.view_in_ar_outlined),
      // Batch B (Models 5–8)
      (AppBarModel.multiPanelSplitCurtain, 'M5: Multi-Panel Split Curtain', Icons.splitscreen_outlined),
      (AppBarModel.spatial3DFlip, 'M6: 3D Perspective Flip', Icons.flip_camera_android_outlined),
      (AppBarModel.verticalRailTransform, 'M7: Vertical Rail Transform', Icons.view_sidebar_outlined),
      (AppBarModel.radialDial, 'M8: Radial Polar Dial', Icons.explore_outlined),
      // Batch C (Models 9–12)
      (AppBarModel.editorialTypography, 'M9: Editorial Typography', Icons.menu_book_outlined),
      (AppBarModel.cardDeckStacked, 'M10: Card Deck Stacked', Icons.style_outlined),
      (AppBarModel.minimalistMicroBar, 'M11: Minimalist Micro-Bar', Icons.code_outlined),
      (AppBarModel.profileIdentity, 'M12: Profile & Identity Centered', Icons.account_circle_outlined),
    ];

    return Column(
      children: [
        for (final item in allModels)
          Padding(
            padding: const EdgeInsets.only(bottom: 6.0),
            child: InkWell(
              onTap: () => _onModelSelected(item.$1),
              borderRadius: BorderRadius.circular(10.0),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
                decoration: BoxDecoration(
                  color: _selectedModel == item.$1
                      ? theme.colorScheme.primaryContainer
                      : theme.colorScheme.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(10.0),
                  border: Border.all(
                    color: _selectedModel == item.$1
                        ? theme.colorScheme.primary
                        : theme.colorScheme.outlineVariant.withValues(alpha: 0.3),
                    width: _selectedModel == item.$1 ? 1.5 : 1.0,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      item.$3,
                      size: 20.0,
                      color: _selectedModel == item.$1
                          ? theme.colorScheme.onPrimaryContainer
                          : theme.colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: 10.0),
                    Expanded(
                      child: Text(
                        item.$2,
                        style: TextStyle(
                          fontWeight: _selectedModel == item.$1 ? FontWeight.bold : FontWeight.w500,
                          color: _selectedModel == item.$1
                              ? theme.colorScheme.onPrimaryContainer
                              : theme.colorScheme.onSurface,
                        ),
                      ),
                    ),
                    if (_selectedModel == item.$1)
                      Icon(Icons.check_circle, size: 18.0, color: theme.colorScheme.primary),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildParametersForModel(ThemeData theme) {
    switch (_selectedModel) {
      case AppBarModel.traditionalStructured:
        return Column(
          children: [
            TextField(
              decoration: const InputDecoration(labelText: 'Organization Name', isDense: true),
              controller: TextEditingController(text: _orgName)
                ..selection = TextSelection.collapsed(offset: _orgName.length),
              onChanged: (val) => setState(() => _orgName = val),
            ),
            const SizedBox(height: 10.0),
            Row(
              children: [
                const Text('Environment:'),
                const SizedBox(width: 10.0),
                DropdownButton<EnvironmentBadge>(
                  value: _environment,
                  underline: const SizedBox.shrink(),
                  items: EnvironmentBadge.values.map((e) {
                    return DropdownMenuItem(value: e, child: Text(e.label));
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) setState(() => _environment = val);
                  },
                ),
                const Spacer(),
                const Text('Sticky Tabs:'),
                Switch(
                  value: _stickyTabs,
                  onChanged: (val) => setState(() => _stickyTabs = val),
                ),
              ],
            ),
            _buildSliderRow('Expanded Height', _m1ExpandedHeight, 140.0, 240.0, (val) {
              setState(() => _m1ExpandedHeight = val);
            }),
          ],
        );

      case AppBarModel.fullScreenHero:
        return Column(
          children: [
            TextField(
              decoration: const InputDecoration(labelText: 'Headline', isDense: true),
              controller: TextEditingController(text: _heroHeadline)
                ..selection = TextSelection.collapsed(offset: _heroHeadline.length),
              onChanged: (val) => setState(() => _heroHeadline = val),
            ),
            const SizedBox(height: 10.0),
            TextField(
              decoration: const InputDecoration(labelText: 'Tagline', isDense: true),
              controller: TextEditingController(text: _heroTagline)
                ..selection = TextSelection.collapsed(offset: _heroTagline.length),
              onChanged: (val) => setState(() => _heroTagline = val),
            ),
            _buildSliderRow('Viewport Height', _heroViewportHeight, 260.0, 600.0, (val) {
              setState(() => _heroViewportHeight = val);
            }),
            _buildSliderRow('Collapsed Height', _heroCollapsedHeight, 48.0, 84.0, (val) {
              setState(() => _heroCollapsedHeight = val);
            }),
          ],
        );

      case AppBarModel.floatingIsland:
        return Column(
          children: [
            TextField(
              decoration: const InputDecoration(labelText: 'Island Title', isDense: true),
              controller: TextEditingController(text: _islandTitle)
                ..selection = TextSelection.collapsed(offset: _islandTitle.length),
              onChanged: (val) => setState(() => _islandTitle = val),
            ),
            const SizedBox(height: 10.0),
            TextField(
              decoration: const InputDecoration(labelText: 'Subtitle', isDense: true),
              controller: TextEditingController(text: _islandSubtitle)
                ..selection = TextSelection.collapsed(offset: _islandSubtitle.length),
              onChanged: (val) => setState(() => _islandSubtitle = val),
            ),
            _buildSliderRow('Expanded Margin', _expandedMargin, 12.0, 32.0, (val) {
              setState(() => _expandedMargin = val);
            }),
            _buildSliderRow('Compact Margin', _compactMargin, 24.0, 56.0, (val) {
              setState(() => _compactMargin = val);
            }),
            _buildSliderRow('Corner Radius', _islandRadius, 14.0, 36.0, (val) {
              setState(() => _islandRadius = val);
            }),
          ],
        );

      case AppBarModel.immersiveSpatial:
        return Column(
          children: [
            TextField(
              decoration: const InputDecoration(labelText: 'Title Text', isDense: true),
              controller: TextEditingController(text: _spatialTitle)
                ..selection = TextSelection.collapsed(offset: _spatialTitle.length),
              onChanged: (val) => setState(() => _spatialTitle = val),
            ),
            const SizedBox(height: 10.0),
            TextField(
              decoration: const InputDecoration(labelText: 'Subtitle Text', isDense: true),
              controller: TextEditingController(text: _spatialSubtitle)
                ..selection = TextSelection.collapsed(offset: _spatialSubtitle.length),
              onChanged: (val) => setState(() => _spatialSubtitle = val),
            ),
            _buildSliderRow('Background Parallax Factor', _spatialBgFactor, 0.1, 0.6, (val) {
              setState(() => _spatialBgFactor = val);
            }),
            _buildSliderRow('Midground Parallax Factor', _spatialMgFactor, 0.2, 1.2, (val) {
              setState(() => _spatialMgFactor = val);
            }),
            _buildSliderRow('Focal Depth Blur', _spatialFocalBlur, 0.0, 16.0, (val) {
              setState(() => _spatialFocalBlur = val);
            }),
          ],
        );

      case AppBarModel.multiPanelSplitCurtain:
        return Column(
          children: [
            TextField(
              decoration: const InputDecoration(labelText: 'Left Panel Title', isDense: true),
              controller: TextEditingController(text: _curtainLeftTitle)
                ..selection = TextSelection.collapsed(offset: _curtainLeftTitle.length),
              onChanged: (val) => setState(() => _curtainLeftTitle = val),
            ),
            const SizedBox(height: 10.0),
            TextField(
              decoration: const InputDecoration(labelText: 'Left Subtitle', isDense: true),
              controller: TextEditingController(text: _curtainLeftSubtitle)
                ..selection = TextSelection.collapsed(offset: _curtainLeftSubtitle.length),
              onChanged: (val) => setState(() => _curtainLeftSubtitle = val),
            ),
            _buildSliderRow('Split Gap', _curtainSplitGap, 16.0, 64.0, (val) {
              setState(() => _curtainSplitGap = val);
            }),
          ],
        );

      case AppBarModel.spatial3DFlip:
        return Column(
          children: [
            TextField(
              decoration: const InputDecoration(labelText: 'Front Card Title', isDense: true),
              controller: TextEditingController(text: _flipFrontTitle)
                ..selection = TextSelection.collapsed(offset: _flipFrontTitle.length),
              onChanged: (val) => setState(() => _flipFrontTitle = val),
            ),
            const SizedBox(height: 10.0),
            TextField(
              decoration: const InputDecoration(labelText: 'Front Metric', isDense: true),
              controller: TextEditingController(text: _flipFrontMetric)
                ..selection = TextSelection.collapsed(offset: _flipFrontMetric.length),
              onChanged: (val) => setState(() => _flipFrontMetric = val),
            ),
            const SizedBox(height: 10.0),
            TextField(
              decoration: const InputDecoration(labelText: 'Reverse Toolbar Title', isDense: true),
              controller: TextEditingController(text: _flipBackTitle)
                ..selection = TextSelection.collapsed(offset: _flipBackTitle.length),
              onChanged: (val) => setState(() => _flipBackTitle = val),
            ),
          ],
        );

      case AppBarModel.verticalRailTransform:
        return Column(
          children: [
            TextField(
              decoration: const InputDecoration(labelText: 'Rail Title', isDense: true),
              controller: TextEditingController(text: _railTitle)
                ..selection = TextSelection.collapsed(offset: _railTitle.length),
              onChanged: (val) => setState(() => _railTitle = val),
            ),
            const SizedBox(height: 10.0),
            TextField(
              decoration: const InputDecoration(labelText: 'Subtitle', isDense: true),
              controller: TextEditingController(text: _railSubtitle)
                ..selection = TextSelection.collapsed(offset: _railSubtitle.length),
              onChanged: (val) => setState(() => _railSubtitle = val),
            ),
          ],
        );

      case AppBarModel.radialDial:
        return Column(
          children: [
            TextField(
              decoration: const InputDecoration(labelText: 'Dial Center Title', isDense: true),
              controller: TextEditingController(text: _dialTitle)
                ..selection = TextSelection.collapsed(offset: _dialTitle.length),
              onChanged: (val) => setState(() => _dialTitle = val),
            ),
            _buildSliderRow('Arc Radius', _dialRadius, 60.0, 120.0, (val) {
              setState(() => _dialRadius = val);
            }),
          ],
        );

      case AppBarModel.editorialTypography:
        return Column(
          children: [
            TextField(
              decoration: const InputDecoration(labelText: 'Display Headline', isDense: true),
              controller: TextEditingController(text: _editorialHeadline)
                ..selection = TextSelection.collapsed(offset: _editorialHeadline.length),
              onChanged: (val) => setState(() => _editorialHeadline = val),
            ),
            const SizedBox(height: 10.0),
            TextField(
              decoration: const InputDecoration(labelText: 'Category Pill', isDense: true),
              controller: TextEditingController(text: _editorialCategory)
                ..selection = TextSelection.collapsed(offset: _editorialCategory.length),
              onChanged: (val) => setState(() => _editorialCategory = val),
            ),
            const SizedBox(height: 10.0),
            Row(
              children: [
                const Text('Serif Font:'),
                Switch(
                  value: _editorialSerif,
                  onChanged: (val) => setState(() => _editorialSerif = val),
                ),
                const Spacer(),
                const Text('Reading Bar:'),
                Switch(
                  value: _editorialReadingBar,
                  onChanged: (val) => setState(() => _editorialReadingBar = val),
                ),
              ],
            ),
            _buildSliderRow('Expanded Height', _editorialExpandedHeight, 160.0, 300.0, (val) {
              setState(() => _editorialExpandedHeight = val);
            }),
          ],
        );

      case AppBarModel.cardDeckStacked:
        return Column(
          children: [
            TextField(
              decoration: const InputDecoration(labelText: 'Deck Title', isDense: true),
              controller: TextEditingController(text: _deckTitle)
                ..selection = TextSelection.collapsed(offset: _deckTitle.length),
              onChanged: (val) => setState(() => _deckTitle = val),
            ),
            const SizedBox(height: 10.0),
            _buildSliderRow('Card Overlap', _cardOverlap, 10.0, 32.0, (val) {
              setState(() => _cardOverlap = val);
            }),
          ],
        );

      case AppBarModel.minimalistMicroBar:
        return Column(
          children: [
            TextField(
              decoration: const InputDecoration(labelText: 'Breadcrumb Path', isDense: true),
              controller: TextEditingController(text: _microBreadcrumb)
                ..selection = TextSelection.collapsed(offset: _microBreadcrumb.length),
              onChanged: (val) => setState(() => _microBreadcrumb = val),
            ),
            const SizedBox(height: 10.0),
            TextField(
              decoration: const InputDecoration(labelText: 'Reading ETA', isDense: true),
              controller: TextEditingController(text: _microEta)
                ..selection = TextSelection.collapsed(offset: _microEta.length),
              onChanged: (val) => setState(() => _microEta = val),
            ),
            const SizedBox(height: 10.0),
            TextField(
              decoration: const InputDecoration(labelText: 'Document Status', isDense: true),
              controller: TextEditingController(text: _microStatus)
                ..selection = TextSelection.collapsed(offset: _microStatus.length),
              onChanged: (val) => setState(() => _microStatus = val),
            ),
            const SizedBox(height: 10.0),
            Row(
              children: [
                const Text('Monospace:'),
                Switch(
                  value: _microMonospace,
                  onChanged: (val) => setState(() => _microMonospace = val),
                ),
                const Spacer(),
                const Text('Progress Dot:'),
                Switch(
                  value: _microProgressDot,
                  onChanged: (val) => setState(() => _microProgressDot = val),
                ),
              ],
            ),
          ],
        );

      case AppBarModel.profileIdentity:
        return Column(
          children: [
            TextField(
              decoration: const InputDecoration(labelText: 'User Full Name', isDense: true),
              controller: TextEditingController(text: _profileName)
                ..selection = TextSelection.collapsed(offset: _profileName.length),
              onChanged: (val) => setState(() => _profileName = val),
            ),
            const SizedBox(height: 10.0),
            TextField(
              decoration: const InputDecoration(labelText: 'User Handle', isDense: true),
              controller: TextEditingController(text: _profileHandle)
                ..selection = TextSelection.collapsed(offset: _profileHandle.length),
              onChanged: (val) => setState(() => _profileHandle = val),
            ),
            const SizedBox(height: 10.0),
            TextField(
              decoration: const InputDecoration(labelText: 'Short Bio', isDense: true),
              controller: TextEditingController(text: _profileBio)
                ..selection = TextSelection.collapsed(offset: _profileBio.length),
              onChanged: (val) => setState(() => _profileBio = val),
            ),
            const SizedBox(height: 10.0),
            Row(
              children: [
                const Text('Verified Check:'),
                Switch(
                  value: _profileVerified,
                  onChanged: (val) => setState(() => _profileVerified = val),
                ),
              ],
            ),
            _buildSliderRow('Avatar Size', _profileAvatarSize, 48.0, 96.0, (val) {
              setState(() => _profileAvatarSize = val);
            }),
          ],
        );

      default:
        return const Text('Configure parameters in Level 2 mode.');
    }
  }

  Widget _buildSliderRow(
    String label,
    double value,
    double min,
    double max,
    ValueChanged<double> onChanged,
  ) {
    return Row(
      children: [
        Expanded(
          flex: 4,
          child: Text('$label (${value.toStringAsFixed(1)})', style: const TextStyle(fontSize: 12.0)),
        ),
        Expanded(
          flex: 6,
          child: Slider(
            value: value,
            min: min,
            max: max,
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }

  Widget _buildTelemetryHUD(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 6.0,
            children: [
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.memory, size: 16.0, color: Colors.green),
                    const SizedBox(width: 6.0),
                    Text(
                      'Zero-Leak Telemetry HUD',
                      style: theme.textTheme.labelMedium!.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              Text(
                'Status: Healthy',
                style: TextStyle(color: Colors.green.shade700, fontSize: 11.0, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 6.0),
          Text('Model: ${_selectedModel.name} (${_selectedModel.displayName})', style: const TextStyle(fontSize: 11.0)),
          Text('Switch Count: $_switchCount • Transition: ${_transitionType.name}', style: const TextStyle(fontSize: 11.0)),
          Text('Level: ${_selectedLevel.label}', style: const TextStyle(fontSize: 11.0)),
        ],
      ),
    );
  }

  Widget _buildCodeGenerator(BuildContext context, ThemeData theme) {
    final code = _generateDartCode();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.terminal, size: 18.0),
            const SizedBox(width: 6.0),
            Text('Generated Code', style: theme.textTheme.titleSmall),
            const Spacer(),
            IconButton(
              icon: const Icon(Icons.copy, size: 16.0),
              tooltip: 'Copy Code',
              onPressed: () {
                Clipboard.setData(ClipboardData(text: code));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Code copied to clipboard!')),
                );
              },
            ),
          ],
        ),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            color: const Color(0xFF1E1E1E),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SelectableText(
              code,
              style: const TextStyle(
                fontFamily: 'monospace',
                fontSize: 11.0,
                color: Color(0xFFD4D4D4),
              ),
            ),
          ),
        ),
      ],
    );
  }

  String _generateDartCode() {
    switch (_selectedLevel) {
      case CustomizationLevel.level1Preset:
        return '''
// Level 1: Preset Mode
AppBarEngine(
  model: AppBarModel.${_selectedModel.name},
  body: const MyContentWidget(),
)''';

      case CustomizationLevel.level2Configured:
        if (_selectedModel == AppBarModel.traditionalStructured) {
          return '''
// Level 2: Configurable Mode (Model 1)
AppBarEngine.custom(
  model: AppBarModel.traditionalStructured,
  configuration: TraditionalStructuredConfig(
    organizationName: '$_orgName',
    environment: EnvironmentBadge.${_environment.name},
    stickyTabStrip: $_stickyTabs,
    expandedHeight: ${_m1ExpandedHeight.toStringAsFixed(1)},
    breadcrumbs: const [
      StructuredBreadcrumbNode(label: 'Home', icon: Icons.home),
      StructuredBreadcrumbNode(label: 'Infrastructure'),
      StructuredBreadcrumbNode(label: 'Edge Clusters'),
    ],
    tabs: const [
      Tab(text: 'Overview'),
      Tab(text: 'Nodes'),
      Tab(text: 'Security'),
    ],
  ),
  body: const MyContentWidget(),
)''';
        } else if (_selectedModel == AppBarModel.fullScreenHero) {
          return '''
// Level 2: Configurable Mode (Model 2)
AppBarEngine.custom(
  model: AppBarModel.fullScreenHero,
  configuration: FullScreenHeroConfig(
    headline: '$_heroHeadline',
    tagline: '$_heroTagline',
    customViewportHeight: ${_heroViewportHeight.toStringAsFixed(1)},
    collapsedHeight: ${_heroCollapsedHeight.toStringAsFixed(1)},
  ),
  body: const MyContentWidget(),
)''';
        } else if (_selectedModel == AppBarModel.floatingIsland) {
          return '''
// Level 2: Configurable Mode (Model 3)
AppBarEngine.custom(
  model: AppBarModel.floatingIsland,
  configuration: FloatingIslandConfig(
    islandTitle: '$_islandTitle',
    islandSubtitle: '$_islandSubtitle',
    expandedHorizontalMargin: ${_expandedMargin.toStringAsFixed(1)},
    compactHorizontalMargin: ${_compactMargin.toStringAsFixed(1)},
    borderRadius: ${_islandRadius.toStringAsFixed(1)},
  ),
  body: const MyContentWidget(),
)''';
        } else if (_selectedModel == AppBarModel.immersiveSpatial) {
          return '''
// Level 2: Configurable Mode (Model 4)
AppBarEngine.custom(
  model: AppBarModel.immersiveSpatial,
  configuration: ImmersiveSpatialConfig(
    titleText: '$_spatialTitle',
    subtitleText: '$_spatialSubtitle',
    backgroundParallaxFactor: ${_spatialBgFactor.toStringAsFixed(2)},
    midgroundParallaxFactor: ${_spatialMgFactor.toStringAsFixed(2)},
    focalDepthBlur: ${_spatialFocalBlur.toStringAsFixed(1)},
  ),
  body: const MyContentWidget(),
)''';
        } else if (_selectedModel == AppBarModel.multiPanelSplitCurtain) {
          return '''
// Level 2: Configurable Mode (Model 5)
AppBarEngine.custom(
  model: AppBarModel.multiPanelSplitCurtain,
  configuration: MultiPanelSplitCurtainConfig(
    leftPanelTitle: '$_curtainLeftTitle',
    leftPanelSubtitle: '$_curtainLeftSubtitle',
    splitGap: ${_curtainSplitGap.toStringAsFixed(1)},
  ),
  body: const MyContentWidget(),
)''';
        } else if (_selectedModel == AppBarModel.spatial3DFlip) {
          return '''
// Level 2: Configurable Mode (Model 6)
AppBarEngine.custom(
  model: AppBarModel.spatial3DFlip,
  configuration: Spatial3DFlipConfig(
    frontTitle: '$_flipFrontTitle',
    frontMetricValue: '$_flipFrontMetric',
    backTitle: '$_flipBackTitle',
  ),
  body: const MyContentWidget(),
)''';
        } else if (_selectedModel == AppBarModel.verticalRailTransform) {
          return '''
// Level 2: Configurable Mode (Model 7)
AppBarEngine.custom(
  model: AppBarModel.verticalRailTransform,
  configuration: VerticalRailTransformConfig(
    expandedTitle: '$_railTitle',
    expandedSubtitle: '$_railSubtitle',
    selectedIndex: $_railIndex,
  ),
  body: const MyContentWidget(),
)''';
        } else if (_selectedModel == AppBarModel.radialDial) {
          return '''
// Level 2: Configurable Mode (Model 8)
AppBarEngine.custom(
  model: AppBarModel.radialDial,
  configuration: RadialDialConfig(
    dialCenterTitle: '$_dialTitle',
    arcRadius: ${_dialRadius.toStringAsFixed(1)},
    selectedDialIndex: $_dialIndex,
  ),
  body: const MyContentWidget(),
)''';
        } else if (_selectedModel == AppBarModel.editorialTypography) {
          return '''
// Level 2: Configurable Mode (Model 9)
AppBarEngine.custom(
  model: AppBarModel.editorialTypography,
  configuration: EditorialTypographyConfig(
    headline: '$_editorialHeadline',
    category: '$_editorialCategory',
    serifFont: $_editorialSerif,
    showReadingProgressBar: $_editorialReadingBar,
    expandedHeight: ${_editorialExpandedHeight.toStringAsFixed(1)},
  ),
  body: const MyContentWidget(),
)''';
        } else if (_selectedModel == AppBarModel.cardDeckStacked) {
          return '''
// Level 2: Configurable Mode (Model 10)
AppBarEngine.custom(
  model: AppBarModel.cardDeckStacked,
  configuration: CardDeckStackedConfig(
    deckTitle: '$_deckTitle',
    activeCardIndex: $_activeCardIndex,
    cardOverlap: ${_cardOverlap.toStringAsFixed(1)},
  ),
  body: const MyContentWidget(),
)''';
        } else if (_selectedModel == AppBarModel.minimalistMicroBar) {
          return '''
// Level 2: Configurable Mode (Model 11)
AppBarEngine.custom(
  model: AppBarModel.minimalistMicroBar,
  configuration: MinimalistMicroBarConfig(
    pathBreadcrumb: '$_microBreadcrumb',
    readingEta: '$_microEta',
    documentStatus: '$_microStatus',
    monospace: $_microMonospace,
    showProgressDot: $_microProgressDot,
  ),
  body: const MyContentWidget(),
)''';
        } else if (_selectedModel == AppBarModel.profileIdentity) {
          return '''
// Level 2: Configurable Mode (Model 12)
AppBarEngine.custom(
  model: AppBarModel.profileIdentity,
  configuration: ProfileIdentityConfig(
    userName: '$_profileName',
    userHandle: '$_profileHandle',
    bio: '$_profileBio',
    verified: $_profileVerified,
    expandedAvatarSize: ${_profileAvatarSize.toStringAsFixed(1)},
  ),
  body: const MyContentWidget(),
)''';
        } else {
          return '''
// Level 1 / Default Mode
AppBarEngine(
  model: AppBarModel.${_selectedModel.name},
  body: const MyContentWidget(),
)''';
        }

      case CustomizationLevel.level3CustomBuilder:
        return '''
// Level 3: Custom Builder Mode
AppBarEngine(
  model: AppBarModel.${_selectedModel.name},
  configuration: AppBarConfiguration(
    layout: LayoutConfiguration(
      expandedHeight: 180.0,
      collapsedHeight: 64.0,
      customLayoutBuilder: (context, constraints, configuration) {
        return Material(
          color: Colors.indigo,
          child: Center(
            child: Text('Custom Header (\${constraints.maxHeight}px)'),
          ),
        );
      },
    ),
  ),
  body: const MyContentWidget(),
)''';
    }
  }
}
