import 'package:flutter/material.dart';
import 'package:app_bar_ui/app_bar_ui.dart';
import '../shared/widgets/code_snippet_viewer.dart';
import '../shared/widgets/telemetry_hud_badge.dart';

enum CustomizationLevel {
  preset('Preset Mode', 'Zero-config default preset model'),
  configured('Configured Mode', 'Fine-grained typed model configuration'),
  customBuilder('Custom Builder Mode', 'Complete custom widget & motion overrides');

  const CustomizationLevel(this.label, this.description);
  final String label;
  final String description;
}

/// Interactive Studio & Playground for live configuring and inspecting `AppBarEngine`.
class StudioScreen extends StatefulWidget {
  const StudioScreen({
    super.key,
    this.initialModel = AppBarModel.floatingIsland,
  });

  final AppBarModel initialModel;

  @override
  State<StudioScreen> createState() => _StudioScreenState();
}

class _StudioScreenState extends State<StudioScreen> {
  late AppBarController _controller;
  late AppBarModel _selectedModel;
  CustomizationLevel _selectedLevel = CustomizationLevel.configured;
  ModelTransitionType _transitionType = ModelTransitionType.fade;

  // --- Dynamic Model Configuration State ---
  String _orgName = 'Enterprise Cloud Nexus';
  final EnvironmentBadge _environment = EnvironmentBadge.production;
  double _m1ExpandedHeight = 170.0;
  final bool _stickyTabs = true;

  String _heroHeadline = 'Cinematic Odyssey';
  final String _heroTagline = 'An IMAX Original Documentary';
  double _heroViewportHeight = 380.0;

  String _islandTitle = 'Dynamic Flight Track';
  final String _islandSubtitle = 'Flight AG-204 • On Time';
  double _expandedMargin = 20.0;
  final double _islandRadius = 28.0;

  final String _spatialTitle = 'Spatial Reality Canvas';
  final String _spatialSubtitle = '3-Depth Differential Parallax Active';
  final double _spatialBgFactor = 0.25;

  final String _curtainLeftTitle = 'Enterprise Cloud';
  final String _curtainLeftSubtitle = 'Multi-Region Ingress';
  final double _curtainSplitGap = 36.0;

  final String _flipFrontTitle = 'Portfolio Vault';
  final String _flipFrontMetric = '\$142,850.00';

  final String _railTitle = 'Engineering Hub';
  int _railIndex = 0;

  final String _dialTitle = 'Radial Navigator';
  final double _dialRadius = 88.0;
  int _dialIndex = 0;

  String _editorialHeadline = 'The Architecture of Thought';
  final String _editorialCategory = 'Systems Engineering';
  bool _editorialSerif = true;
  final double _editorialExpandedHeight = 220.0;

  final String _deckTitle = 'Card Wallet';
  int _activeCardIndex = 0;

  final String _microBreadcrumb = 'packages / app_bar_ui / lib / engine.dart';
  final String _microEta = '4 min read';
  final bool _microMonospace = true;

  final String _profileName = 'Dr. Eleanor Vance';
  final String _profileHandle = '@eleanor_vance';
  final String _profileBio = 'Principal Systems Architect';
  final double _profileAvatarSize = 72.0;

  final String _hubTitle = 'Control Center Pro';
  final String _timelineTitle = 'Project Roadmap';
  int _activeMilestoneIndex = 2;

  final String _searchPrompt = 'Search repositories, commits, and packages...';
  final String _elasticCanvasTitle = 'Elastic Horizon';
  final String _elasticMetric = '99.98% Operational';

  final String _adaptiveTitle = 'Enterprise Command Center';
  int _focalDomainIndex = 0;
  final String _waveTitle = 'Fluid Organic Dynamics';
  final double _waveAmplitude = 20.0;

  final String _canvasName = 'Blueprint Space';
  final bool _showBlueprintGrid = true;

  @override
  void initState() {
    super.initState();
    _selectedModel = widget.initialModel;
    _controller = AppBarController(initialModel: _selectedModel);
  }

  @override
  void didUpdateWidget(covariant StudioScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialModel != widget.initialModel) {
      _onModelSelected(widget.initialModel);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onModelSelected(AppBarModel model) {
    if (_selectedModel == model) return;
    setState(() {
      _selectedModel = model;
    });
    _controller.changeModel(
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
    final size = MediaQuery.sizeOf(context);
    final isCompact = size.width < 900.0;

    if (isCompact) {
      return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: Text(_selectedModel.displayName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0)),
            bottom: const TabBar(
              tabs: [
                Tab(icon: Icon(Icons.preview), text: 'Live Canvas'),
                Tab(icon: Icon(Icons.tune), text: 'Inspector & Code'),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              _buildCanvasArea(context),
              _buildInspectorArea(context, theme),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      body: Row(
        children: [
          // Left Canvas: Live AppBarEngine experience
          Expanded(
            flex: 6,
            child: Container(
              color: theme.colorScheme.surfaceContainerLowest,
              child: _buildCanvasArea(context),
            ),
          ),

          // Right Inspector: Parameters, controls & live code
          Expanded(
            flex: 5,
            child: Material(
              color: theme.colorScheme.surface,
              child: Container(
                decoration: BoxDecoration(
                  border: Border(
                    left: BorderSide(
                      color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
                    ),
                  ),
                ),
                child: _buildInspectorArea(context, theme),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCanvasArea(BuildContext context) {
    switch (_selectedLevel) {
      case CustomizationLevel.preset:
        return AppBarEngine(
          key: ValueKey('preset_$_selectedModel'),
          controller: _controller,
          model: _selectedModel,
          body: _buildScrollableBody(context),
        );

      case CustomizationLevel.configured:
        return _buildConfiguredEngine(context);

      case CustomizationLevel.customBuilder:
        return _buildCustomBuilderEngine(context);
    }
  }

  Widget _buildConfiguredEngine(BuildContext context) {
    switch (_selectedModel) {
      case AppBarModel.traditionalStructured:
        return AppBarEngine.custom(
          key: ValueKey('l2_trad_${_orgName}_$_environment'),
          controller: _controller,
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
          controller: _controller,
          model: AppBarModel.fullScreenHero,
          configuration: FullScreenHeroConfig(
            headline: _heroHeadline,
            tagline: _heroTagline,
            customViewportHeight: _heroViewportHeight,
          ),
          body: _buildScrollableBody(context),
        );

      case AppBarModel.floatingIsland:
        return AppBarEngine.custom(
          key: ValueKey('l2_island_${_islandTitle}_$_expandedMargin'),
          controller: _controller,
          model: AppBarModel.floatingIsland,
          configuration: FloatingIslandConfig(
            islandTitle: _islandTitle,
            islandSubtitle: _islandSubtitle,
            expandedHorizontalMargin: _expandedMargin,
            borderRadius: _islandRadius,
          ),
          body: _buildScrollableBody(context),
        );

      case AppBarModel.immersiveSpatial:
        return AppBarEngine.custom(
          key: ValueKey('l2_spatial_${_spatialTitle}_$_spatialBgFactor'),
          controller: _controller,
          model: AppBarModel.immersiveSpatial,
          configuration: ImmersiveSpatialConfig(
            titleText: _spatialTitle,
            subtitleText: _spatialSubtitle,
            backgroundParallaxFactor: _spatialBgFactor,
          ),
          body: _buildScrollableBody(context),
        );

      case AppBarModel.multiPanelSplitCurtain:
        return AppBarEngine.custom(
          key: ValueKey('l2_curtain_${_curtainLeftTitle}_$_curtainSplitGap'),
          controller: _controller,
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
          controller: _controller,
          model: AppBarModel.spatial3DFlip,
          configuration: Spatial3DFlipConfig(
            frontTitle: _flipFrontTitle,
            frontMetricValue: _flipFrontMetric,
          ),
          body: _buildScrollableBody(context),
        );

      case AppBarModel.verticalRailTransform:
        return AppBarEngine.custom(
          key: ValueKey('l2_rail_${_railTitle}_$_railIndex'),
          controller: _controller,
          model: AppBarModel.verticalRailTransform,
          configuration: VerticalRailTransformConfig(
            expandedTitle: _railTitle,
            selectedIndex: _railIndex,
            onDestinationSelected: (idx) => setState(() => _railIndex = idx),
          ),
          body: _buildScrollableBody(context),
        );

      case AppBarModel.radialDial:
        return AppBarEngine.custom(
          key: ValueKey('l2_dial_${_dialTitle}_${_dialRadius}_$_dialIndex'),
          controller: _controller,
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
          key: ValueKey('l2_editorial_${_editorialHeadline}_$_editorialSerif'),
          controller: _controller,
          model: AppBarModel.editorialTypography,
          configuration: EditorialTypographyConfig(
            headline: _editorialHeadline,
            category: _editorialCategory,
            serifFont: _editorialSerif,
            expandedHeight: _editorialExpandedHeight,
          ),
          body: _buildScrollableBody(context),
        );

      case AppBarModel.cardDeckStacked:
        return AppBarEngine.custom(
          key: ValueKey('l2_deck_${_deckTitle}_$_activeCardIndex'),
          controller: _controller,
          model: AppBarModel.cardDeckStacked,
          configuration: CardDeckStackedConfig(
            deckTitle: _deckTitle,
            activeCardIndex: _activeCardIndex,
            onCardSwiped: (idx) => setState(() => _activeCardIndex = idx),
          ),
          body: _buildScrollableBody(context),
        );

      case AppBarModel.minimalistMicroBar:
        return AppBarEngine.custom(
          key: ValueKey('l2_micro_${_microBreadcrumb}_$_microMonospace'),
          controller: _controller,
          model: AppBarModel.minimalistMicroBar,
          configuration: MinimalistMicroBarConfig(
            pathBreadcrumb: _microBreadcrumb,
            readingEta: _microEta,
            monospace: _microMonospace,
          ),
          body: _buildScrollableBody(context),
        );

      case AppBarModel.profileIdentity:
        return AppBarEngine.custom(
          key: ValueKey('l2_profile_${_profileName}_$_profileAvatarSize'),
          controller: _controller,
          model: AppBarModel.profileIdentity,
          configuration: ProfileIdentityConfig(
            userName: _profileName,
            userHandle: _profileHandle,
            bio: _profileBio,
            expandedAvatarSize: _profileAvatarSize,
          ),
          body: _buildScrollableBody(context),
        );

      case AppBarModel.expandableControlCenter:
        return AppBarEngine.custom(
          key: ValueKey('l2_hub_$_hubTitle'),
          controller: _controller,
          model: AppBarModel.expandableControlCenter,
          configuration: ExpandableControlCenterConfig(hubTitle: _hubTitle),
          body: _buildScrollableBody(context),
        );

      case AppBarModel.timelineScrubberNav:
        return AppBarEngine.custom(
          key: ValueKey('l2_timeline_${_timelineTitle}_$_activeMilestoneIndex'),
          controller: _controller,
          model: AppBarModel.timelineScrubberNav,
          configuration: TimelineScrubberNavConfig(
            timelineTitle: _timelineTitle,
            activeNodeIndex: _activeMilestoneIndex,
            onNodeSelected: (idx) => setState(() => _activeMilestoneIndex = idx),
          ),
          body: _buildScrollableBody(context),
        );

      case AppBarModel.searchSpotlight:
        return AppBarEngine.custom(
          key: ValueKey('l2_spotlight_$_searchPrompt'),
          controller: _controller,
          model: AppBarModel.searchSpotlight,
          configuration: SearchSpotlightConfig(searchPrompt: _searchPrompt),
          body: _buildScrollableBody(context),
        );

      case AppBarModel.gestureElasticCanvas:
        return AppBarEngine.custom(
          key: ValueKey('l2_elastic_${_elasticCanvasTitle}_$_elasticMetric'),
          controller: _controller,
          model: AppBarModel.gestureElasticCanvas,
          configuration: GestureElasticCanvasConfig(
            canvasTitle: _elasticCanvasTitle,
            statusMetric: _elasticMetric,
          ),
          body: _buildScrollableBody(context),
        );

      case AppBarModel.adaptiveBreakpointNav:
        return AppBarEngine.custom(
          key: ValueKey('l2_adapt_$_adaptiveTitle'),
          controller: _controller,
          model: AppBarModel.adaptiveBreakpointNav,
          configuration: AdaptiveBreakpointNavConfig(title: _adaptiveTitle),
          body: _buildScrollableBody(context),
        );

      case AppBarModel.contextFocalSwapNav:
        return AppBarEngine.custom(
          key: ValueKey('l2_focal_$_focalDomainIndex'),
          controller: _controller,
          model: AppBarModel.contextFocalSwapNav,
          configuration: ContextFocalSwapNavConfig(
            activeDomainIndex: _focalDomainIndex,
            onDomainSwapped: (idx) => setState(() => _focalDomainIndex = idx),
          ),
          body: _buildScrollableBody(context),
        );

      case AppBarModel.liquidWaveMorphNav:
        return AppBarEngine.custom(
          key: ValueKey('l2_wave_${_waveTitle}_$_waveAmplitude'),
          controller: _controller,
          model: AppBarModel.liquidWaveMorphNav,
          configuration: LiquidWaveMorphNavConfig(
            title: _waveTitle,
            waveAmplitude: _waveAmplitude,
          ),
          body: _buildScrollableBody(context),
        );

      case AppBarModel.developerCustomCanvas:
        return AppBarEngine.custom(
          key: ValueKey('l2_canvas_${_canvasName}_$_showBlueprintGrid'),
          controller: _controller,
          model: AppBarModel.developerCustomCanvas,
          configuration: DeveloperCustomCanvasConfig(
            canvasName: _canvasName,
            showBlueprintGrid: _showBlueprintGrid,
          ),
          body: _buildScrollableBody(context),
        );

      default:
        return AppBarEngine(
          controller: _controller,
          model: _selectedModel,
          body: _buildScrollableBody(context),
        );
    }
  }

  Widget _buildCustomBuilderEngine(BuildContext context) {
    return AppBarEngine(
      key: ValueKey('l3_builder_$_selectedModel'),
      controller: _controller,
      model: _selectedModel,
      expandedHeight: 200.0,
      collapsedHeight: 64.0,
      title: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
        decoration: BoxDecoration(
          color: Colors.indigo.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: const Text(
          'Level 3 Custom Title Override',
          style: TextStyle(
            fontSize: 14.0,
            fontWeight: FontWeight.w900,
            color: Colors.indigo,
          ),
        ),
      ),
      body: _buildScrollableBody(context),
    );
  }

  Widget _buildScrollableBody(BuildContext context) {
    final theme = Theme.of(context);
    final category = AppBarScreenCategory.of(context);
    final size = MediaQuery.sizeOf(context);
    final textScale = MediaQuery.textScalerOf(context).scale(1.0);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Column(
        children: [
          // Live Responsive Telemetry Banner Card
          Card(
            margin: const EdgeInsets.only(bottom: 12.0),
            color: theme.colorScheme.primaryContainer.withValues(alpha: 0.35),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
              side: BorderSide(color: theme.colorScheme.primary.withValues(alpha: 0.3)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.devices, size: 18.0, color: theme.colorScheme.primary),
                      const SizedBox(width: 8.0),
                      Expanded(
                        child: Text(
                          'Universal Responsive Engine',
                          style: theme.textTheme.titleSmall!.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.primary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8.0),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Text(
                          category.name.toUpperCase(),
                          style: TextStyle(
                            fontSize: 10.0,
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.onPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6.0),
                  Text(
                    'Viewport: ${size.width.toInt()} × ${size.height.toInt()} pt • Scale: ${textScale.toStringAsFixed(1)}x • Optical Centering: Active',
                    style: theme.textTheme.bodySmall!.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ),
          ...List.generate(20, (index) {
            return Card(
              margin: const EdgeInsets.only(bottom: 10.0),
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
        ],
      ),
    );
  }

  Widget _buildInspectorArea(BuildContext context, ThemeData theme) {
    return ListView(
      padding: const EdgeInsets.all(20.0),
      children: [
        // Studio Header
        Row(
          children: [
            const Icon(Icons.tune, color: Color(0xFF4F46E5)),
            const SizedBox(width: 10.0),
            Expanded(
              child: Text(
                'Playground Inspector',
                style: theme.textTheme.titleMedium!.copyWith(fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4.0),
        Text(
          'Live model parameters, transition styles, and real-time code generation.',
          style: theme.textTheme.bodySmall!.copyWith(color: theme.colorScheme.outline),
        ),
        const Divider(height: 24.0),

        // Section 1: Customization Level
        Text('1. Customization Level', style: theme.textTheme.titleSmall),
        const SizedBox(height: 8.0),
        Wrap(
          spacing: 8.0,
          children: CustomizationLevel.values.map((level) {
            final isSelected = _selectedLevel == level;
            return ChoiceChip(
              label: Text(level == CustomizationLevel.preset
                  ? 'Preset'
                  : level == CustomizationLevel.configured
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

        // Section 2: Model Selection Chips
        Text('2. Active Model (${_selectedModel.displayName})', style: theme.textTheme.titleSmall),
        const SizedBox(height: 8.0),
        Wrap(
          spacing: 6.0,
          runSpacing: 6.0,
          children: AppBarModel.values.map((model) {
            final isSelected = _selectedModel == model;
            return ChoiceChip(
              avatar: isSelected ? const Icon(Icons.check, size: 14.0) : null,
              label: Text(model.displayName),
              selected: isSelected,
              onSelected: (selected) {
                if (selected) _onModelSelected(model);
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
        if (_selectedLevel == CustomizationLevel.configured) ...[
          Text('3. Live Parameters', style: theme.textTheme.titleSmall),
          const SizedBox(height: 10.0),
          _buildModelSpecificControls(theme),
          const Divider(height: 24.0),
        ],

        // Section 5: Telemetry HUD
        TelemetryHudBadge(compact: false),
        const SizedBox(height: 16.0),

        // Section 6: Live Code Generator
        Text('Generated Canonical Code', style: theme.textTheme.titleSmall),
        const SizedBox(height: 8.0),
        CodeSnippetViewer(
          title: 'code_snippet.dart',
          code: _generateCodeSnippet(),
        ),
      ],
    );
  }

  Widget _buildModelSpecificControls(ThemeData theme) {
    if (_selectedModel == AppBarModel.traditionalStructured) {
      return Column(
        children: [
          TextField(
            decoration: const InputDecoration(labelText: 'Organization Name', border: OutlineInputBorder()),
            controller: TextEditingController(text: _orgName),
            onSubmitted: (val) => setState(() => _orgName = val),
          ),
          const SizedBox(height: 10.0),
          Row(
            children: [
              const Text('Expanded Height:'),
              Expanded(
                child: Slider(
                  value: _m1ExpandedHeight,
                  min: 120.0,
                  max: 240.0,
                  onChanged: (val) => setState(() => _m1ExpandedHeight = val),
                ),
              ),
              Text('${_m1ExpandedHeight.toInt()}px'),
            ],
          ),
        ],
      );
    } else if (_selectedModel == AppBarModel.fullScreenHero) {
      return Column(
        children: [
          TextField(
            decoration: const InputDecoration(labelText: 'Headline', border: OutlineInputBorder()),
            controller: TextEditingController(text: _heroHeadline),
            onSubmitted: (val) => setState(() => _heroHeadline = val),
          ),
          const SizedBox(height: 10.0),
          Row(
            children: [
              const Text('Viewport Height:'),
              Expanded(
                child: Slider(
                  value: _heroViewportHeight,
                  min: 250.0,
                  max: 500.0,
                  onChanged: (val) => setState(() => _heroViewportHeight = val),
                ),
              ),
              Text('${_heroViewportHeight.toInt()}px'),
            ],
          ),
        ],
      );
    } else if (_selectedModel == AppBarModel.floatingIsland) {
      return Column(
        children: [
          TextField(
            decoration: const InputDecoration(labelText: 'Island Title', border: OutlineInputBorder()),
            controller: TextEditingController(text: _islandTitle),
            onSubmitted: (val) => setState(() => _islandTitle = val),
          ),
          const SizedBox(height: 10.0),
          Row(
            children: [
              const Text('Expanded Margin:'),
              Expanded(
                child: Slider(
                  value: _expandedMargin,
                  min: 8.0,
                  max: 48.0,
                  onChanged: (val) => setState(() => _expandedMargin = val),
                ),
              ),
              Text('${_expandedMargin.toInt()}px'),
            ],
          ),
        ],
      );
    } else if (_selectedModel == AppBarModel.editorialTypography) {
      return Column(
        children: [
          TextField(
            decoration: const InputDecoration(labelText: 'Editorial Headline', border: OutlineInputBorder()),
            controller: TextEditingController(text: _editorialHeadline),
            onSubmitted: (val) => setState(() => _editorialHeadline = val),
          ),
          const SizedBox(height: 10.0),
          SwitchListTile(
            title: const Text('Serif Typography'),
            value: _editorialSerif,
            onChanged: (val) => setState(() => _editorialSerif = val),
          ),
        ],
      );
    }

    return Text(
      'Preset parameters configured for ${_selectedModel.displayName}. Tweak via code or switch models.',
      style: TextStyle(color: theme.colorScheme.onSurfaceVariant, fontSize: 12.0),
    );
  }

  String _generateCodeSnippet() {
    if (_selectedLevel == CustomizationLevel.preset) {
      return '''// Level 1: Preset Mode
AppBarEngine(
  model: AppBarModel.${_selectedModel.name},
  body: const MyContentWidget(),
)''';
    } else if (_selectedLevel == CustomizationLevel.customBuilder) {
      return '''// Level 3: Custom Builder Mode
AppBarEngine.custom(
  model: AppBarModel.${_selectedModel.name},
  configuration: AppBarConfiguration(
    layout: const LayoutConfiguration(expandedHeight: 200.0, collapsedHeight: 64.0),
    elements: ElementConfiguration(
      title: ElementOverride(
        builder: (context, progress) {
          return Text(
            'Custom Title (\${(progress * 100).toInt()}%)',
            style: TextStyle(fontSize: 14.0 + (1.0 - progress) * 6.0),
          );
        },
      ),
    ),
  ),
  body: const MyContentWidget(),
)''';
    }

    return '''// Level 2: Configured Mode (${_selectedModel.displayName})
AppBarEngine.custom(
  model: AppBarModel.${_selectedModel.name},
  configuration: const ${_selectedModel == AppBarModel.floatingIsland ? "FloatingIslandConfig(\n    islandTitle: '$_islandTitle',\n    expandedHorizontalMargin: ${_expandedMargin.toStringAsFixed(1)},\n  )" : "${_selectedModel.displayName.replaceAll(' ', '')}Config()"},
  body: const MyContentWidget(),
)''';
  }
}
