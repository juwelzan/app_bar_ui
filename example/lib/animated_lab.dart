import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:app_bar_ui/app_bar_ui.dart';

/// Interactive laboratory showcasing the 50 genuinely different animated
/// AppBar experiences across Batches 1 & 2 (Styles 1–10).
class AnimatedExperiencesLabTab extends StatefulWidget {
  const AnimatedExperiencesLabTab({super.key});

  @override
  State<AnimatedExperiencesLabTab> createState() =>
      _AnimatedExperiencesLabTabState();
}

enum ExperienceStyle {
  // Batch 1 (Styles 1–5)
  morphingSplit(
    id: 1,
    batch: 1,
    title: 'Morphing Split',
    description:
        'Counter-directional divergence with centered pill consolidation',
    icon: Icons.call_split,
  ),
  elasticFloating(
    id: 2,
    batch: 1,
    title: 'Elastic Floating',
    description:
        'Overscroll spring resistance settling into floating capsule',
    icon: Icons.waves,
  ),
  disappearingActions(
    id: 3,
    batch: 1,
    title: 'Disappearing & Floating Actions',
    description:
        'Header scrolls away into content leaving detached action pills',
    icon: Icons.widgets_outlined,
  ),
  circularMorph(
    id: 4,
    batch: 1,
    title: 'Circular Morph',
    description:
        'Full-bleed rectangular header morphs into circular corner avatar',
    icon: Icons.account_circle_outlined,
  ),
  flip3D(
    id: 5,
    batch: 1,
    title: 'Flip 3D Header',
    description:
        '180° perspective projection flipping card to compact toolbar',
    icon: Icons.flip_camera_android_outlined,
  ),

  // Batch 2 (Styles 6–10)
  horizontalSliding(
    id: 6,
    batch: 2,
    title: 'Horizontal Sliding Panels',
    description:
        'Panels slide laterally at differential velocities upon scrolling',
    icon: Icons.view_column_outlined,
  ),
  verticalFolding(
    id: 7,
    batch: 2,
    title: 'Vertical Folding Accordion',
    description:
        '3D origami hinge folding with seam depth shading on scroll',
    icon: Icons.layers_outlined,
  ),
  layeredDepth(
    id: 8,
    batch: 2,
    title: 'Layered Depth Parallax',
    description:
        '3 distinct z-index layers with dynamic focal depth blur on collapse',
    icon: Icons.filter_none_outlined,
  ),
  expandingHero(
    id: 9,
    batch: 2,
    title: 'Expanding Hero Card',
    description:
        'Inset card dynamically expands full-bleed into docked toolbar',
    icon: Icons.aspect_ratio_outlined,
  ),
  liquidWave(
    id: 10,
    batch: 2,
    title: 'Liquid Wave Morph',
    description:
        'Mathematical sine wave ripples flattening into straight edge',
    icon: Icons.water_drop_outlined,
  );

  const ExperienceStyle({
    required this.id,
    required this.batch,
    required this.title,
    required this.description,
    required this.icon,
  });

  final int id;
  final int batch;
  final String title;
  final String description;
  final IconData icon;
}

class _AnimatedExperiencesLabTabState extends State<AnimatedExperiencesLabTab> {
  ExperienceStyle _selectedStyle = ExperienceStyle.morphingSplit;
  int _selectedBatchFilter = 0; // 0 = All active, 1 = Batch 1, 2 = Batch 2
  final ScrollController _scrollController = ScrollController();
  final GlobalKey<dynamic> _elasticKey = GlobalKey();

  // Telemetry state
  double _currentOffset = 0.0;
  bool _simulateReducedMotion = false;

  // Style 1 params (Morphing Split)
  double _splitDistance = 60.0;
  double _splitMergeThreshold = 0.65;
  double _splitExpandedHeight = 140.0;

  // Style 2 params (Elastic Floating)
  double _elasticHeight = 72.0;
  double _elasticCompactHeight = 56.0;
  double _elasticDamping = 18.0;
  double _elasticStiffness = 220.0;
  double _elasticHorizontalMargin = 16.0;
  double _elasticElevation = 4.0;

  // Style 3 params (Disappearing Actions)
  double _disappearingExpandedHeight = 160.0;
  double _disappearingDetachOffset = 45.0;
  double _disappearingFadeOffset = 80.0;
  double _disappearingActionSpacing = 10.0;
  double _disappearingElevation = 6.0;

  // Style 4 params (Circular Morph)
  double _circleTargetDiameter = 54.0;
  double _circleExpandedHeight = 140.0;
  Alignment _circleAnchorAlignment = Alignment.topRight;

  // Style 5 params (Flip 3D)
  double _flipPerspective = 0.0016;
  double _flipFrontElevation = 2.0;
  double _flipBackElevation = 4.0;
  Axis _flipAxis = Axis.horizontal;

  // Style 6 params (Horizontal Sliding Panels)
  double _panel1SlideDistance = 100.0;
  double _panel2SlideDistance = 80.0;
  double _panelsFadeThreshold = 0.65;

  // Style 7 params (Vertical Folding Accordion)
  double _accordionFoldThreshold = 100.0;
  double _accordionPerspective = 0.002;
  double _accordionSeamShadow = 0.45;

  // Style 8 params (Layered Depth Parallax)
  double _parallaxBgFactor = 0.25;
  double _parallaxMidFactor = 0.6;
  double _parallaxMaxBlur = 8.0;

  // Style 9 params (Expanding Hero Card)
  double _cardHMargin = 16.0;
  double _cardVMargin = 12.0;
  double _cardRadius = 20.0;
  double _cardExpandThreshold = 65.0;

  // Style 10 params (Liquid Wave Morph)
  double _waveAmplitude = 22.0;
  double _waveFrequency = 1.4;
  double _waveFlattenOffset = 85.0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_handleScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_handleScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _handleScroll() {
    if (mounted) {
      setState(() {
        _currentOffset = _scrollController.hasClients ? _scrollController.offset : 0.0;
      });
    }
  }

  void _resetScroll() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        0.0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
      );
    }
  }

  List<ExperienceStyle> get _filteredStyles {
    if (_selectedBatchFilter == 1) {
      return ExperienceStyle.values.where((s) => s.batch == 1).toList();
    } else if (_selectedBatchFilter == 2) {
      return ExperienceStyle.values.where((s) => s.batch == 2).toList();
    }
    return ExperienceStyle.values;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return MediaQuery(
      data: MediaQuery.of(context).copyWith(
        disableAnimations: _simulateReducedMotion,
      ),
      child: Scaffold(
        body: NotificationListener<ScrollNotification>(
          onNotification: (notification) {
            if (_selectedStyle == ExperienceStyle.elasticFloating) {
              final state = _elasticKey.currentState as dynamic;
              if (state != null) {
                if (notification is ScrollUpdateNotification) {
                  final overscrollDelta = notification.metrics.extentBefore == 0 &&
                          notification.scrollDelta != null &&
                          notification.scrollDelta! < 0
                      ? -notification.scrollDelta!
                      : 0.0;
                  state.updateScrollMetrics(
                    scrollOffset: notification.metrics.pixels,
                    overscrollDelta: overscrollDelta,
                  );
                } else if (notification is ScrollEndNotification) {
                  state.settleElasticSpring(0.0);
                }
              }
            }
            return false;
          },
          child: Stack(
            children: [
              CustomScrollView(
                controller: _scrollController,
                physics: const AlwaysScrollableScrollPhysics(
                  parent: BouncingScrollPhysics(),
                ),
                slivers: [
                  _buildActiveExperienceSliver(context),
                  _buildLaboratoryControlsSliver(context),
                  _buildDemoContentSliver(context),
                ],
              ),
              Positioned(
                right: 16.0,
                bottom: 16.0,
                child: _buildTelemetryHUD(theme),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActiveExperienceSliver(BuildContext context) {
    final theme = Theme.of(context);

    switch (_selectedStyle) {
      // 1. Morphing Split
      case ExperienceStyle.morphingSplit:
        return MorphingSplitHeaderWidget(
          config: MorphingSplitConfig(
            expandedHeight: _splitExpandedHeight,
            collapsedHeight: 60.0,
            splitDistance: _splitDistance,
            mergeThreshold: _splitMergeThreshold,
            collapsedElevation: 3.0,
          ),
          leftModule: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {},
              ),
              const SizedBox(width: 4.0),
              Text(
                'Projects',
                style: theme.textTheme.titleMedium!.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          rightModule: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.filter_list),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.search),
                onPressed: () {},
              ),
            ],
          ),
          compactPill: const Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.layers, size: 18.0),
              SizedBox(width: 6.0),
              Text(
                'Projects',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13.0),
              ),
            ],
          ),
        );

      // 2. Elastic Floating
      case ExperienceStyle.elasticFloating:
        return SliverToBoxAdapter(
          child: ElasticFloatingHeaderWidget(
            key: _elasticKey,
            config: ElasticFloatingConfig(
              height: _elasticHeight,
              compactHeight: _elasticCompactHeight,
              horizontalMargin: _elasticHorizontalMargin,
              damping: _elasticDamping,
              stiffness: _elasticStiffness,
              compactElevation: _elasticElevation,
            ),
            compactChild: Row(
              children: [
                const Icon(Icons.speed, size: 20.0),
                const SizedBox(width: 8.0),
                Expanded(
                  child: Text(
                    'Elastic Floating Mode',
                    style: theme.textTheme.titleSmall!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.tune, size: 20.0),
                  onPressed: () => _openParameterSheet(context),
                ),
              ],
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              alignment: Alignment.center,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Elastic Dynamics Header',
                    style: theme.textTheme.titleMedium!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2.0),
                  Text(
                    'Pull down to observe non-linear spring stretch',
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ),
        );

      // 3. Disappearing Floating Actions
      case ExperienceStyle.disappearingActions:
        return DisappearingFloatingActionsHeaderWidget(
          title: Text(
            'Unpinned Header Canvas',
            style: theme.textTheme.titleMedium!.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: const Text('Scroll up: only floating action pills remain'),
          leading: IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {},
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.bookmark_border),
              tooltip: 'Bookmark',
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.share),
              tooltip: 'Share',
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.code),
              tooltip: 'View Code',
              onPressed: () => _showCodeDialog(context),
            ),
          ],
          config: DisappearingFloatingActionsConfig(
            expandedHeight: _disappearingExpandedHeight,
            detachOffset: _disappearingDetachOffset,
            fadeOffset: _disappearingFadeOffset,
            actionSpacing: _disappearingActionSpacing,
            floatingActionElevation: _disappearingElevation,
          ),
        );

      // 4. Circular Morph
      case ExperienceStyle.circularMorph:
        return CircularMorphHeaderWidget(
          config: CircularMorphConfig(
            expandedHeight: _circleExpandedHeight,
            targetDiameter: _circleTargetDiameter,
            anchorAlignment: _circleAnchorAlignment,
          ),
          expandedChild: Container(
            color: theme.colorScheme.tertiaryContainer.withValues(alpha: 0.45),
            alignment: Alignment.center,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircleAvatar(
                  radius: 32.0,
                  backgroundColor: Colors.indigo,
                  child: Icon(Icons.person, size: 36.0, color: Colors.white),
                ),
                const SizedBox(height: 6.0),
                Text(
                  'Sarah Connor',
                  style: theme.textTheme.titleMedium!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Cybernetics Architect',
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
          ),
          circularChild: const CircleAvatar(
            backgroundColor: Colors.indigo,
            child: Icon(Icons.person, color: Colors.white, size: 24.0),
          ),
        );

      // 5. Flip 3D
      case ExperienceStyle.flip3D:
        return Flip3DHeaderWidget(
          config: Flip3DConfig(
            expandedHeight: 160.0,
            collapsedHeight: 60.0,
            perspective: _flipPerspective,
            flipAxis: _flipAxis,
            frontElevation: _flipFrontElevation,
            backElevation: _flipBackElevation,
          ),
          frontCard: Card(
            margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            color: theme.colorScheme.secondaryContainer,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Container(
                    width: 50.0,
                    height: 50.0,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary,
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: const Icon(Icons.view_in_ar, color: Colors.white, size: 28.0),
                  ),
                  const SizedBox(width: 14.0),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '3D Flip Face A: Card',
                          style: theme.textTheme.titleMedium!.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 2.0),
                        Text(
                          'Scroll down to flip 180° into Face B',
                          style: theme.textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          backToolbar: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            alignment: Alignment.center,
            child: Row(
              children: [
                const Icon(Icons.flip, color: Colors.teal),
                const SizedBox(width: 10.0),
                Expanded(
                  child: Text(
                    'Face B: Compact Nav Bar',
                    style: theme.textTheme.titleSmall!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: _resetScroll,
                ),
              ],
            ),
          ),
        );

      // 6. Horizontal Sliding Multi-Panel
      case ExperienceStyle.horizontalSliding:
        return HorizontalSlidingPanelsHeaderWidget(
          config: HorizontalSlidingPanelsConfig(
            expandedHeight: 155.0,
            collapsedHeight: 60.0,
            panel1SlideDistance: _panel1SlideDistance,
            panel2SlideDistance: _panel2SlideDistance,
            fadeThreshold: _panelsFadeThreshold,
          ),
          pinnedBar: Row(
            children: [
              IconButton(icon: const Icon(Icons.menu), onPressed: () {}),
              const SizedBox(width: 8.0),
              Text(
                'Explore Catalogs',
                style: theme.textTheme.titleMedium!.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              IconButton(icon: const Icon(Icons.search), onPressed: () {}),
            ],
          ),
          slidingPanelLeft: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                FilterChip(selected: true, label: const Text('All Books'), onSelected: (_) {}),
                const SizedBox(width: 8.0),
                FilterChip(selected: false, label: const Text('Technology'), onSelected: (_) {}),
                const SizedBox(width: 8.0),
                FilterChip(selected: false, label: const Text('Science Fiction'), onSelected: (_) {}),
              ],
            ),
          ),
          slidingPanelRight: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                const Icon(Icons.bolt, size: 16.0, color: Colors.amber),
                const SizedBox(width: 6.0),
                Text(
                  '48 new arrivals updated today',
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
          ),
        );

      // 7. Vertical Folding Accordion
      case ExperienceStyle.verticalFolding:
        return VerticalFoldingAccordionHeaderWidget(
          config: VerticalFoldingAccordionConfig(
            expandedHeight: 180.0,
            collapsedHeight: 60.0,
            foldThreshold: _accordionFoldThreshold,
            perspective: _accordionPerspective,
            seamShadowIntensity: _accordionSeamShadow,
          ),
          pinnedToolbar: Row(
            children: [
              IconButton(icon: const Icon(Icons.arrow_back), onPressed: () {}),
              const SizedBox(width: 8.0),
              Text(
                'Origami Accordion',
                style: theme.textTheme.titleMedium!.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              IconButton(icon: const Icon(Icons.more_vert), onPressed: () {}),
            ],
          ),
          foldingTier: Container(
            color: theme.colorScheme.secondaryContainer.withValues(alpha: 0.6),
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                const Icon(Icons.auto_stories, size: 36.0, color: Colors.deepPurple),
                const SizedBox(width: 12.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Tier 2: Collapsible Details',
                        style: theme.textTheme.titleSmall!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Folds 90° along the top hinge with seam shading',
                        style: theme.textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );

      // 8. Layered Depth Parallax
      case ExperienceStyle.layeredDepth:
        return LayeredDepthParallaxHeaderWidget(
          config: LayeredDepthParallaxConfig(
            expandedHeight: 200.0,
            collapsedHeight: 64.0,
            backgroundParallaxFactor: _parallaxBgFactor,
            midgroundParallaxFactor: _parallaxMidFactor,
            maxBlur: _parallaxMaxBlur,
          ),
          backgroundLayer: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF0D47A1), Color(0xFF1976D2), Color(0xFF42A5F5)],
              ),
            ),
            child: const Center(
              child: Icon(Icons.landscape, size: 100.0, color: Colors.white24),
            ),
          ),
          midgroundLayer: Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 24.0, top: 40.0),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.25),
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: const Text('FEATURED DESTINATION',
                        style: TextStyle(color: Colors.white, fontSize: 11.0, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
          ),
          foregroundLayer: Row(
            children: [
              IconButton(icon: const Icon(Icons.arrow_back, color: Colors.white), onPressed: () {}),
              const SizedBox(width: 8.0),
              const Text(
                'Glacier National Park',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18.0),
              ),
              const Spacer(),
              IconButton(icon: const Icon(Icons.favorite_border, color: Colors.white), onPressed: () {}),
            ],
          ),
        );

      // 9. Expanding Hero Card
      case ExperienceStyle.expandingHero:
        return ExpandingHeroCardHeaderWidget(
          config: ExpandingHeroCardConfig(
            expandedHeight: 180.0,
            collapsedHeight: 60.0,
            cardHorizontalMargin: _cardHMargin,
            cardVerticalMargin: _cardVMargin,
            cardBorderRadius: _cardRadius,
            expandThreshold: _cardExpandThreshold,
          ),
          heroCardContent: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 30.0,
                  backgroundColor: Colors.teal,
                  child: Icon(Icons.wallet, color: Colors.white, size: 28.0),
                ),
                const SizedBox(width: 16.0),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Total Balance',
                        style: theme.textTheme.bodySmall,
                      ),
                      Text(
                        '\$24,580.00',
                        style: theme.textTheme.headlineSmall!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 2.0),
                      Text(
                        'Scroll to expand card full-bleed',
                        style: theme.textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          dockedToolbarContent: Row(
            children: [
              IconButton(icon: const Icon(Icons.menu), onPressed: () {}),
              const SizedBox(width: 8.0),
              Text(
                'Wallet: \$24,580.00',
                style: theme.textTheme.titleMedium!.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              IconButton(icon: const Icon(Icons.add), onPressed: () {}),
            ],
          ),
        );

      // 10. Liquid Wave Morph
      case ExperienceStyle.liquidWave:
        return LiquidWaveMorphHeaderWidget(
          config: LiquidWaveMorphConfig(
            expandedHeight: 160.0,
            collapsedHeight: 60.0,
            waveAmplitude: _waveAmplitude,
            waveFrequency: _waveFrequency,
            flattenOffset: _waveFlattenOffset,
          ),
          compactTitle: const Text(
            'Liquid Horizon',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18.0),
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            alignment: Alignment.centerLeft,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Oceanic Flow Wave',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20.0),
                ),
                const SizedBox(height: 4.0),
                Text(
                  'Sine wave bottom edge dynamically flattens into a straight bar',
                  style: TextStyle(color: Colors.white.withValues(alpha: 0.85), fontSize: 13.0),
                ),
              ],
            ),
          ),
        );
    }
  }

  Widget _buildLaboratoryControlsSliver(BuildContext context) {
    final theme = Theme.of(context);

    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Batch Indicator Banner with interactive switch
            Card(
              color: theme.colorScheme.surfaceContainerHighest,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.science, color: Colors.indigoAccent),
                        const SizedBox(width: 10.0),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Batches 1 & 2 Active (Styles 1–10 of 50)',
                                style: theme.textTheme.labelLarge!.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Autonomous visual structure, motion physics & interaction models.',
                                style: theme.textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ),
                        FilledButton.tonal(
                          onPressed: () => _openParameterSheet(context),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.tune, size: 16.0),
                              SizedBox(width: 4.0),
                              Text('Tune'),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10.0),
                    // Batch filter pills
                    Wrap(
                      spacing: 6.0,
                      runSpacing: 6.0,
                      children: [
                        FilterChip(
                          label: const Text('All (1–10)'),
                          selected: _selectedBatchFilter == 0,
                          onSelected: (_) => setState(() => _selectedBatchFilter = 0),
                        ),
                        FilterChip(
                          label: const Text('Batch 1: Morphing & Physics (1–5)'),
                          selected: _selectedBatchFilter == 1,
                          onSelected: (_) => setState(() => _selectedBatchFilter = 1),
                        ),
                        FilterChip(
                          label: const Text('Batch 2: Layered & Geometric (6–10)'),
                          selected: _selectedBatchFilter == 2,
                          onSelected: (_) => setState(() => _selectedBatchFilter = 2),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12.0),

            // Style Selector Chips
            Text(
              'Select Animated Experience:',
              style: theme.textTheme.titleSmall!.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8.0),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _filteredStyles.map((style) {
                  final isSelected = _selectedStyle == style;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: ChoiceChip(
                      selected: isSelected,
                      avatar: Icon(style.icon, size: 18.0),
                      label: Text('${style.id}. ${style.title}'),
                      onSelected: (selected) {
                        if (selected) {
                          setState(() {
                            _selectedStyle = style;
                          });
                          _resetScroll();
                        }
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 12.0),

            // Quick Action Toolbar
            Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                OutlinedButton.icon(
                  onPressed: () => _showCodeDialog(context),
                  icon: const Icon(Icons.code, size: 18.0),
                  label: const Text('View Code'),
                ),
                OutlinedButton.icon(
                  onPressed: _resetScroll,
                  icon: const Icon(Icons.vertical_align_top, size: 18.0),
                  label: const Text('Reset Scroll'),
                ),
                FilterChip(
                  label: const Text('Simulate A11Y / Reduced Motion'),
                  selected: _simulateReducedMotion,
                  onSelected: (val) {
                    setState(() => _simulateReducedMotion = val);
                  },
                ),
              ],
            ),
            const Divider(height: 24.0),
          ],
        ),
      ),
    );
  }

  Widget _buildDemoContentSliver(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
            child: ListTile(
              leading: CircleAvatar(
                child: Text('${index + 1}'),
              ),
              title: Text('Scrollable Content Item #${index + 1}'),
              subtitle: Text(
                'Observing "${_selectedStyle.title}" response at ${_currentOffset.toStringAsFixed(1)}px offset.',
              ),
              trailing: const Icon(Icons.chevron_right),
            ),
          );
        },
        childCount: 25,
      ),
    );
  }

  Widget _buildTelemetryHUD(ThemeData theme) {
    return Card(
      elevation: 6.0,
      color: theme.colorScheme.inverseSurface.withValues(alpha: 0.92),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 8.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.analytics_outlined,
              size: 16.0,
              color: theme.colorScheme.onInverseSurface,
            ),
            const SizedBox(width: 8.0),
            Text(
              'Offset: ${_currentOffset.toStringAsFixed(1)}px',
              style: TextStyle(
                fontFamily: 'monospace',
                fontSize: 12.0,
                color: theme.colorScheme.onInverseSurface,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 12.0),
            Text(
              _simulateReducedMotion ? 'A11Y Fallback' : '60 FPS Motion',
              style: TextStyle(
                fontSize: 11.0,
                color: theme.colorScheme.inversePrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openParameterSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Tune: ${_selectedStyle.title}',
                        style: const TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  const Divider(),
                  ..._buildSlidersForStyle(setSheetState),
                  const SizedBox(height: 16.0),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Apply Parameters'),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  List<Widget> _buildSlidersForStyle(void Function(void Function()) setSheetState) {
    switch (_selectedStyle) {
      case ExperienceStyle.morphingSplit:
        return [
          Text('Split Divergence Distance: ${_splitDistance.toStringAsFixed(0)} px'),
          Slider(
            value: _splitDistance,
            min: 30.0,
            max: 120.0,
            divisions: 9,
            onChanged: (val) {
              setSheetState(() => _splitDistance = val);
              setState(() => _splitDistance = val);
            },
          ),
          Text('Merge Threshold: ${(_splitMergeThreshold * 100).toStringAsFixed(0)}%'),
          Slider(
            value: _splitMergeThreshold,
            min: 0.3,
            max: 0.9,
            divisions: 6,
            onChanged: (val) {
              setSheetState(() => _splitMergeThreshold = val);
              setState(() => _splitMergeThreshold = val);
            },
          ),
          Text('Expanded Height: ${_splitExpandedHeight.toStringAsFixed(0)} px'),
          Slider(
            value: _splitExpandedHeight,
            min: 110.0,
            max: 200.0,
            divisions: 9,
            onChanged: (val) {
              setSheetState(() => _splitExpandedHeight = val);
              setState(() => _splitExpandedHeight = val);
            },
          ),
        ];

      case ExperienceStyle.elasticFloating:
        return [
          Text('Resting Height: ${_elasticHeight.toStringAsFixed(0)} px'),
          Slider(
            value: _elasticHeight,
            min: 60.0,
            max: 100.0,
            divisions: 8,
            onChanged: (val) {
              setSheetState(() => _elasticHeight = val);
              setState(() => _elasticHeight = val);
            },
          ),
          Text('Compact Height: ${_elasticCompactHeight.toStringAsFixed(0)} px'),
          Slider(
            value: _elasticCompactHeight,
            min: 44.0,
            max: 68.0,
            divisions: 6,
            onChanged: (val) {
              setSheetState(() => _elasticCompactHeight = val);
              setState(() => _elasticCompactHeight = val);
            },
          ),
          Text('Spring Damping: ${_elasticDamping.toStringAsFixed(1)}'),
          Slider(
            value: _elasticDamping,
            min: 10.0,
            max: 40.0,
            divisions: 15,
            onChanged: (val) {
              setSheetState(() => _elasticDamping = val);
              setState(() => _elasticDamping = val);
            },
          ),
          Text('Spring Stiffness: ${_elasticStiffness.toStringAsFixed(0)}'),
          Slider(
            value: _elasticStiffness,
            min: 100.0,
            max: 400.0,
            divisions: 15,
            onChanged: (val) {
              setSheetState(() => _elasticStiffness = val);
              setState(() => _elasticStiffness = val);
            },
          ),
          Text('Horizontal Margin: ${_elasticHorizontalMargin.toStringAsFixed(0)} px'),
          Slider(
            value: _elasticHorizontalMargin,
            min: 4.0,
            max: 28.0,
            divisions: 6,
            onChanged: (val) {
              setSheetState(() => _elasticHorizontalMargin = val);
              setState(() => _elasticHorizontalMargin = val);
            },
          ),
          Text('Compact Elevation: ${_elasticElevation.toStringAsFixed(1)}'),
          Slider(
            value: _elasticElevation,
            min: 0.0,
            max: 12.0,
            divisions: 12,
            onChanged: (val) {
              setSheetState(() => _elasticElevation = val);
              setState(() => _elasticElevation = val);
            },
          ),
        ];

      case ExperienceStyle.disappearingActions:
        return [
          Text('Expanded Height: ${_disappearingExpandedHeight.toStringAsFixed(0)} px'),
          Slider(
            value: _disappearingExpandedHeight,
            min: 120.0,
            max: 220.0,
            divisions: 10,
            onChanged: (val) {
              setSheetState(() => _disappearingExpandedHeight = val);
              setState(() => _disappearingExpandedHeight = val);
            },
          ),
          Text('Detach Offset: ${_disappearingDetachOffset.toStringAsFixed(0)} px'),
          Slider(
            value: _disappearingDetachOffset,
            min: 20.0,
            max: 80.0,
            divisions: 6,
            onChanged: (val) {
              setSheetState(() => _disappearingDetachOffset = val);
              setState(() => _disappearingDetachOffset = val);
            },
          ),
          Text('Fade Offset: ${_disappearingFadeOffset.toStringAsFixed(0)} px'),
          Slider(
            value: _disappearingFadeOffset,
            min: 50.0,
            max: 120.0,
            divisions: 7,
            onChanged: (val) {
              setSheetState(() => _disappearingFadeOffset = val);
              setState(() => _disappearingFadeOffset = val);
            },
          ),
          Text('Action Spacing: ${_disappearingActionSpacing.toStringAsFixed(0)} px'),
          Slider(
            value: _disappearingActionSpacing,
            min: 4.0,
            max: 20.0,
            divisions: 8,
            onChanged: (val) {
              setSheetState(() => _disappearingActionSpacing = val);
              setState(() => _disappearingActionSpacing = val);
            },
          ),
          Text('Floating Elevation: ${_disappearingElevation.toStringAsFixed(1)}'),
          Slider(
            value: _disappearingElevation,
            min: 0.0,
            max: 10.0,
            divisions: 10,
            onChanged: (val) {
              setSheetState(() => _disappearingElevation = val);
              setState(() => _disappearingElevation = val);
            },
          ),
        ];

      case ExperienceStyle.circularMorph:
        return [
          Text('Target Circle Diameter: ${_circleTargetDiameter.toStringAsFixed(0)} px'),
          Slider(
            value: _circleTargetDiameter,
            min: 36.0,
            max: 72.0,
            divisions: 9,
            onChanged: (val) {
              setSheetState(() => _circleTargetDiameter = val);
              setState(() => _circleTargetDiameter = val);
            },
          ),
          Text('Expanded Height: ${_circleExpandedHeight.toStringAsFixed(0)} px'),
          Slider(
            value: _circleExpandedHeight,
            min: 110.0,
            max: 220.0,
            divisions: 11,
            onChanged: (val) {
              setSheetState(() => _circleExpandedHeight = val);
              setState(() => _circleExpandedHeight = val);
            },
          ),
          Row(
            children: [
              const Text('Anchor: '),
              SegmentedButton<Alignment>(
                segments: const [
                  ButtonSegment(value: Alignment.topRight, label: Text('Right')),
                  ButtonSegment(value: Alignment.topLeft, label: Text('Left')),
                ],
                selected: {_circleAnchorAlignment},
                onSelectionChanged: (set) {
                  setSheetState(() => _circleAnchorAlignment = set.first);
                  setState(() => _circleAnchorAlignment = set.first);
                },
              ),
            ],
          ),
        ];

      case ExperienceStyle.flip3D:
        return [
          Text('Perspective: ${_flipPerspective.toStringAsFixed(4)}'),
          Slider(
            value: _flipPerspective,
            min: 0.0005,
            max: 0.005,
            divisions: 9,
            onChanged: (val) {
              setSheetState(() => _flipPerspective = val);
              setState(() => _flipPerspective = val);
            },
          ),
          Text('Front Elevation: ${_flipFrontElevation.toStringAsFixed(1)}'),
          Slider(
            value: _flipFrontElevation,
            min: 0.0,
            max: 8.0,
            divisions: 8,
            onChanged: (val) {
              setSheetState(() => _flipFrontElevation = val);
              setState(() => _flipFrontElevation = val);
            },
          ),
          Text('Back Elevation: ${_flipBackElevation.toStringAsFixed(1)}'),
          Slider(
            value: _flipBackElevation,
            min: 0.0,
            max: 12.0,
            divisions: 12,
            onChanged: (val) {
              setSheetState(() => _flipBackElevation = val);
              setState(() => _flipBackElevation = val);
            },
          ),
          Row(
            children: [
              const Text('Flip Axis: '),
              SegmentedButton<Axis>(
                segments: const [
                  ButtonSegment(value: Axis.horizontal, label: Text('Horizontal')),
                  ButtonSegment(value: Axis.vertical, label: Text('Vertical')),
                ],
                selected: {_flipAxis},
                onSelectionChanged: (set) {
                  setSheetState(() => _flipAxis = set.first);
                  setState(() => _flipAxis = set.first);
                },
              ),
            ],
          ),
        ];

      case ExperienceStyle.horizontalSliding:
        return [
          Text('Panel 1 Slide Distance: ${_panel1SlideDistance.toStringAsFixed(0)} px'),
          Slider(
            value: _panel1SlideDistance,
            min: 40.0,
            max: 160.0,
            divisions: 12,
            onChanged: (val) {
              setSheetState(() => _panel1SlideDistance = val);
              setState(() => _panel1SlideDistance = val);
            },
          ),
          Text('Panel 2 Slide Distance: ${_panel2SlideDistance.toStringAsFixed(0)} px'),
          Slider(
            value: _panel2SlideDistance,
            min: 40.0,
            max: 140.0,
            divisions: 10,
            onChanged: (val) {
              setSheetState(() => _panel2SlideDistance = val);
              setState(() => _panel2SlideDistance = val);
            },
          ),
          Text('Fade Threshold: ${(_panelsFadeThreshold * 100).toStringAsFixed(0)}%'),
          Slider(
            value: _panelsFadeThreshold,
            min: 0.4,
            max: 0.95,
            divisions: 11,
            onChanged: (val) {
              setSheetState(() => _panelsFadeThreshold = val);
              setState(() => _panelsFadeThreshold = val);
            },
          ),
        ];

      case ExperienceStyle.verticalFolding:
        return [
          Text('Fold Threshold: ${_accordionFoldThreshold.toStringAsFixed(0)} px'),
          Slider(
            value: _accordionFoldThreshold,
            min: 60.0,
            max: 160.0,
            divisions: 10,
            onChanged: (val) {
              setSheetState(() => _accordionFoldThreshold = val);
              setState(() => _accordionFoldThreshold = val);
            },
          ),
          Text('Perspective: ${_accordionPerspective.toStringAsFixed(4)}'),
          Slider(
            value: _accordionPerspective,
            min: 0.0005,
            max: 0.004,
            divisions: 7,
            onChanged: (val) {
              setSheetState(() => _accordionPerspective = val);
              setState(() => _accordionPerspective = val);
            },
          ),
          Text('Seam Shadow Intensity: ${(_accordionSeamShadow * 100).toStringAsFixed(0)}%'),
          Slider(
            value: _accordionSeamShadow,
            min: 0.1,
            max: 0.9,
            divisions: 8,
            onChanged: (val) {
              setSheetState(() => _accordionSeamShadow = val);
              setState(() => _accordionSeamShadow = val);
            },
          ),
        ];

      case ExperienceStyle.layeredDepth:
        return [
          Text('Background Parallax Factor: ${_parallaxBgFactor.toStringAsFixed(2)}x'),
          Slider(
            value: _parallaxBgFactor,
            min: 0.1,
            max: 0.5,
            divisions: 8,
            onChanged: (val) {
              setSheetState(() => _parallaxBgFactor = val);
              setState(() => _parallaxBgFactor = val);
            },
          ),
          Text('Midground Parallax Factor: ${_parallaxMidFactor.toStringAsFixed(2)}x'),
          Slider(
            value: _parallaxMidFactor,
            min: 0.3,
            max: 0.85,
            divisions: 11,
            onChanged: (val) {
              setSheetState(() => _parallaxMidFactor = val);
              setState(() => _parallaxMidFactor = val);
            },
          ),
          Text('Max Focal Depth Blur: ${_parallaxMaxBlur.toStringAsFixed(1)} px'),
          Slider(
            value: _parallaxMaxBlur,
            min: 0.0,
            max: 16.0,
            divisions: 16,
            onChanged: (val) {
              setSheetState(() => _parallaxMaxBlur = val);
              setState(() => _parallaxMaxBlur = val);
            },
          ),
        ];

      case ExperienceStyle.expandingHero:
        return [
          Text('Card Horizontal Margin: ${_cardHMargin.toStringAsFixed(0)} px'),
          Slider(
            value: _cardHMargin,
            min: 8.0,
            max: 32.0,
            divisions: 12,
            onChanged: (val) {
              setSheetState(() => _cardHMargin = val);
              setState(() => _cardHMargin = val);
            },
          ),
          Text('Card Vertical Margin: ${_cardVMargin.toStringAsFixed(0)} px'),
          Slider(
            value: _cardVMargin,
            min: 4.0,
            max: 24.0,
            divisions: 10,
            onChanged: (val) {
              setSheetState(() => _cardVMargin = val);
              setState(() => _cardVMargin = val);
            },
          ),
          Text('Card Border Radius: ${_cardRadius.toStringAsFixed(0)} px'),
          Slider(
            value: _cardRadius,
            min: 8.0,
            max: 32.0,
            divisions: 12,
            onChanged: (val) {
              setSheetState(() => _cardRadius = val);
              setState(() => _cardRadius = val);
            },
          ),
          Text('Expand Threshold: ${_cardExpandThreshold.toStringAsFixed(0)} px'),
          Slider(
            value: _cardExpandThreshold,
            min: 30.0,
            max: 120.0,
            divisions: 9,
            onChanged: (val) {
              setSheetState(() => _cardExpandThreshold = val);
              setState(() => _cardExpandThreshold = val);
            },
          ),
        ];

      case ExperienceStyle.liquidWave:
        return [
          Text('Wave Amplitude: ${_waveAmplitude.toStringAsFixed(0)} px'),
          Slider(
            value: _waveAmplitude,
            min: 8.0,
            max: 40.0,
            divisions: 16,
            onChanged: (val) {
              setSheetState(() => _waveAmplitude = val);
              setState(() => _waveAmplitude = val);
            },
          ),
          Text('Wave Frequency: ${_waveFrequency.toStringAsFixed(2)} cycles'),
          Slider(
            value: _waveFrequency,
            min: 0.5,
            max: 3.0,
            divisions: 10,
            onChanged: (val) {
              setSheetState(() => _waveFrequency = val);
              setState(() => _waveFrequency = val);
            },
          ),
          Text('Wave Flatten Offset: ${_waveFlattenOffset.toStringAsFixed(0)} px'),
          Slider(
            value: _waveFlattenOffset,
            min: 40.0,
            max: 140.0,
            divisions: 10,
            onChanged: (val) {
              setSheetState(() => _waveFlattenOffset = val);
              setState(() => _waveFlattenOffset = val);
            },
          ),
        ];
    }
  }

  void _showCodeDialog(BuildContext context) {
    final snippet = _generateCodeSnippet();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text('${_selectedStyle.title} Integration Code'),
          content: SizedBox(
            width: double.maxFinite,
            child: SingleChildScrollView(
              child: SelectableText(
                snippet,
                style: const TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 12.0,
                ),
              ),
            ),
          ),
          actions: [
            TextButton.icon(
              onPressed: () {
                Clipboard.setData(ClipboardData(text: snippet));
                Navigator.pop(dialogContext);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Code snippet copied to clipboard!'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
              icon: const Icon(Icons.copy),
              label: const Text('Copy to Clipboard'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  String _generateCodeSnippet() {
    switch (_selectedStyle) {
      case ExperienceStyle.morphingSplit:
        return '''
import 'package:app_bar_ui/app_bar_ui.dart';

CustomScrollView(
  slivers: [
    MorphingSplitHeaderWidget(
      config: MorphingSplitConfig(
        expandedHeight: $_splitExpandedHeight,
        collapsedHeight: 60.0,
        splitDistance: $_splitDistance,
        mergeThreshold: $_splitMergeThreshold,
      ),
      leftModule: Row(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Icon(Icons.arrow_back),
          SizedBox(width: 8),
          Text('Projects', style: TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
      rightModule: Row(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Icon(Icons.filter_list),
          SizedBox(width: 8),
          Icon(Icons.search),
        ],
      ),
      compactPill: const Text('Projects', style: TextStyle(fontWeight: FontWeight.bold)),
    ),
    // ... list slivers
  ],
)''';

      case ExperienceStyle.elasticFloating:
        return '''
import 'package:app_bar_ui/app_bar_ui.dart';

NotificationListener<ScrollNotification>(
  onNotification: (notification) => false,
  child: CustomScrollView(
    physics: const BouncingScrollPhysics(),
    slivers: [
      SliverToBoxAdapter(
        child: ElasticFloatingHeaderWidget(
          config: ElasticFloatingConfig(
            height: $_elasticHeight,
            compactHeight: $_elasticCompactHeight,
            horizontalMargin: $_elasticHorizontalMargin,
            damping: $_elasticDamping,
            stiffness: $_elasticStiffness,
            compactElevation: $_elasticElevation,
          ),
          compactChild: const Text('Compact Capsule'),
          child: const Center(
            child: Text('Elastic Header', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ),
      ),
      // ... list slivers
    ],
  ),
)''';

      case ExperienceStyle.disappearingActions:
        return '''
import 'package:app_bar_ui/app_bar_ui.dart';

CustomScrollView(
  slivers: [
    DisappearingFloatingActionsHeaderWidget(
      title: const Text('Article Title', style: TextStyle(fontWeight: FontWeight.bold)),
      subtitle: const Text('Published 2 hours ago'),
      leading: const Icon(Icons.arrow_back),
      actions: [
        IconButton(icon: const Icon(Icons.share), onPressed: () {}),
      ],
      config: DisappearingFloatingActionsConfig(
        expandedHeight: $_disappearingExpandedHeight,
        detachOffset: $_disappearingDetachOffset,
        fadeOffset: $_disappearingFadeOffset,
        actionSpacing: $_disappearingActionSpacing,
        floatingActionElevation: $_disappearingElevation,
      ),
    ),
    // ... list slivers
  ],
)''';

      case ExperienceStyle.circularMorph:
        return '''
import 'package:app_bar_ui/app_bar_ui.dart';

CustomScrollView(
  slivers: [
    CircularMorphHeaderWidget(
      config: CircularMorphConfig(
        expandedHeight: $_circleExpandedHeight,
        targetDiameter: $_circleTargetDiameter,
        anchorAlignment: Alignment.${_circleAnchorAlignment == Alignment.topRight ? 'topRight' : 'topLeft'},
      ),
      expandedChild: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          CircleAvatar(radius: 32, child: Icon(Icons.person)),
          SizedBox(height: 6),
          Text('Sarah Connor', style: TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
      circularChild: const CircleAvatar(child: Icon(Icons.person)),
    ),
    // ... list slivers
  ],
)''';

      case ExperienceStyle.flip3D:
        return '''
import 'package:app_bar_ui/app_bar_ui.dart';

CustomScrollView(
  slivers: [
    Flip3DHeaderWidget(
      config: Flip3DConfig(
        expandedHeight: 160.0,
        collapsedHeight: 60.0,
        perspective: $_flipPerspective,
        flipAxis: Axis.${_flipAxis.name},
        frontElevation: $_flipFrontElevation,
        backElevation: $_flipBackElevation,
      ),
      frontCard: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text('Face A: Hero Card'),
        ),
      ),
      backToolbar: Row(
        children: const [
          Icon(Icons.flip),
          SizedBox(width: 8),
          Text('Face B: Toolbar'),
        ],
      ),
    ),
    // ... list slivers
  ],
)''';

      case ExperienceStyle.horizontalSliding:
        return '''
import 'package:app_bar_ui/app_bar_ui.dart';

CustomScrollView(
  slivers: [
    HorizontalSlidingPanelsHeaderWidget(
      config: HorizontalSlidingPanelsConfig(
        expandedHeight: 155.0,
        collapsedHeight: 60.0,
        panel1SlideDistance: $_panel1SlideDistance,
        panel2SlideDistance: $_panel2SlideDistance,
        fadeThreshold: $_panelsFadeThreshold,
      ),
      pinnedBar: Row(
        children: const [
          Icon(Icons.menu),
          SizedBox(width: 8),
          Text('Catalogs', style: TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
      slidingPanelLeft: Row(
        children: const [
          Chip(label: Text('All Books')),
          SizedBox(width: 8),
          Chip(label: Text('Technology')),
        ],
      ),
    ),
    // ... list slivers
  ],
)''';

      case ExperienceStyle.verticalFolding:
        return '''
import 'package:app_bar_ui/app_bar_ui.dart';

CustomScrollView(
  slivers: [
    VerticalFoldingAccordionHeaderWidget(
      config: VerticalFoldingAccordionConfig(
        expandedHeight: 180.0,
        collapsedHeight: 60.0,
        foldThreshold: $_accordionFoldThreshold,
        perspective: $_accordionPerspective,
        seamShadowIntensity: $_accordionSeamShadow,
      ),
      pinnedToolbar: Row(
        children: const [
          Icon(Icons.arrow_back),
          SizedBox(width: 8),
          Text('Accordion Title', style: TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
      foldingTier: Container(
        padding: const EdgeInsets.all(16),
        child: const Text('Origami folding tier content'),
      ),
    ),
    // ... list slivers
  ],
)''';

      case ExperienceStyle.layeredDepth:
        return '''
import 'package:app_bar_ui/app_bar_ui.dart';

CustomScrollView(
  slivers: [
    LayeredDepthParallaxHeaderWidget(
      config: LayeredDepthParallaxConfig(
        expandedHeight: 200.0,
        collapsedHeight: 64.0,
        backgroundParallaxFactor: $_parallaxBgFactor,
        midgroundParallaxFactor: $_parallaxMidFactor,
        maxBlur: $_parallaxMaxBlur,
      ),
      backgroundLayer: Image.network('https://example.com/mountain.jpg', fit: BoxFit.cover),
      midgroundLayer: const Text('Floating Badge', style: TextStyle(color: Colors.white)),
      foregroundLayer: Row(
        children: const [
          Icon(Icons.arrow_back, color: Colors.white),
          SizedBox(width: 8),
          Text('Glacier Park', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ],
      ),
    ),
    // ... list slivers
  ],
)''';

      case ExperienceStyle.expandingHero:
        return '''
import 'package:app_bar_ui/app_bar_ui.dart';

CustomScrollView(
  slivers: [
    ExpandingHeroCardHeaderWidget(
      config: ExpandingHeroCardConfig(
        expandedHeight: 180.0,
        collapsedHeight: 60.0,
        cardHorizontalMargin: $_cardHMargin,
        cardVerticalMargin: $_cardVMargin,
        cardBorderRadius: $_cardRadius,
        expandThreshold: $_cardExpandThreshold,
      ),
      heroCardContent: Padding(
        padding: const EdgeInsets.all(16),
        child: const Text('Card Presentation: Balance \$24,580'),
      ),
      dockedToolbarContent: Row(
        children: const [
          Icon(Icons.menu),
          SizedBox(width: 8),
          Text('Wallet Toolbar', style: TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    ),
    // ... list slivers
  ],
)''';

      case ExperienceStyle.liquidWave:
        return '''
import 'package:app_bar_ui/app_bar_ui.dart';

CustomScrollView(
  slivers: [
    LiquidWaveMorphHeaderWidget(
      config: LiquidWaveMorphConfig(
        expandedHeight: 160.0,
        collapsedHeight: 60.0,
        waveAmplitude: $_waveAmplitude,
        waveFrequency: $_waveFrequency,
        flattenOffset: $_waveFlattenOffset,
      ),
      compactTitle: const Text('Liquid Title', style: TextStyle(color: Colors.white)),
      child: const Center(
        child: Text('Ocean Wave Canvas', style: TextStyle(color: Colors.white, fontSize: 20)),
      ),
    ),
    // ... list slivers
  ],
)''';
    }
  }
}
