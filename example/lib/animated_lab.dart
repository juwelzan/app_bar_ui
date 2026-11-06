import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:app_bar_ui/app_bar_ui.dart';

/// Interactive laboratory showcasing the 50 genuinely different animated
/// AppBar experiences across Batches 1, 2, 3, & 4 (Styles 1–20).
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
  ),

  // Batch 3 (Styles 11–15)
  autoHiding(
    id: 11,
    batch: 3,
    title: 'Auto-Hiding Velocity Header',
    description:
        'Velocity and scroll direction-sensitive auto-slide hide/reveal',
    icon: Icons.visibility_off_outlined,
  ),
  progressSync(
    id: 12,
    batch: 3,
    title: 'Scroll-Synchronized Progress',
    description:
        'Circular progress ring and linear track tied to reading percentage',
    icon: Icons.timelapse_outlined,
  ),
  stickyDualTier(
    id: 13,
    batch: 3,
    title: 'Sticky-Collapse Dual-Tier',
    description:
        'Tier 1 branding collapses away while Tier 2 navigation locks sticky',
    icon: Icons.table_rows_outlined,
  ),
  multiStage(
    id: 14,
    batch: 3,
    title: 'Multi-Stage Staged Reveal',
    description:
        '3 discrete architectural states triggered at scroll boundaries',
    icon: Icons.view_carousel_outlined,
  ),
  animatedDock(
    id: 15,
    batch: 3,
    title: 'Animated Dock Header',
    description:
        'Top header smoothly dissolves into a floating bottom navigation dock',
    icon: Icons.dock_outlined,
  ),

  // Batch 4 (Styles 16–20)
  radialOrbital(
    id: 16,
    batch: 4,
    title: 'Radial / Orbital Action Header',
    description:
        'Action buttons orbit around central anchor and converge to linear row',
    icon: Icons.pie_chart_outline,
  ),
  splitCurtain(
    id: 17,
    batch: 4,
    title: 'Split-Screen Lateral Reveal',
    description:
        'Curtain halves part laterally to reveal dramatic center showcase',
    icon: Icons.splitscreen_outlined,
  ),
  magneticSnap(
    id: 18,
    batch: 4,
    title: 'Magnetic Scroll-Snap Header',
    description:
        'Physical magnetic snap settling into discrete resting bounds',
    icon: Icons.gps_fixed_outlined,
  ),
  parallaxZoom(
    id: 19,
    batch: 4,
    title: 'Parallax Zoom Hero Header',
    description:
        'Non-linear zoom scaling with optical scrim darkening on scroll',
    icon: Icons.zoom_out_map_outlined,
  ),
  pullDisclosure(
    id: 20,
    batch: 4,
    title: 'Pull-Down Disclosure Canvas',
    description:
        'Downward pull overscroll gesture unlocks hidden utility drawer canvas',
    icon: Icons.unfold_more_double_outlined,
  ),

  // Batch 5 (Styles 21–25)
  tabTransform(
    id: 21,
    batch: 5,
    title: 'Animated Tab-Transform Header',
    description:
        'Full-sized tab cards compress into slim sticky pinned navigation strip',
    icon: Icons.tab_outlined,
  ),
  avatarToProfile(
    id: 22,
    batch: 5,
    title: 'Avatar-to-Profile Arc Header',
    description:
        'Large profile avatar glides along curved Bezier arc into leading toolbar slot',
    icon: Icons.account_circle_outlined,
  ),
  progressiveDisclosure(
    id: 23,
    batch: 5,
    title: 'Progressive Disclosure Header',
    description:
        'Stepwise cascade revealing Title -> Search Bar -> Sticky Pinned Filters',
    icon: Icons.filter_list_outlined,
  ),
  sidewaysCollapse(
    id: 24,
    batch: 5,
    title: 'Sideways-Collapse Header',
    description:
        'Horizontal width collapse shrinking into anchored compact navigation rail',
    icon: Icons.view_sidebar_outlined,
  ),
  expandingSearch(
    id: 25,
    batch: 5,
    title: 'Expanding Search Transformation',
    description:
        'Action search icon smoothly morphs into active full-bleed search bar',
    icon: Icons.search_outlined,
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
  int _selectedBatchFilter = 0; // 0 = All (1-20), 1 = Batch 1, 2 = Batch 2, 3 = Batch 3, 4 = Batch 4
  final ScrollController _scrollController = ScrollController();
  final GlobalKey<dynamic> _elasticKey = GlobalKey();
  final GlobalKey<AutoHidingVelocityHeaderWidgetState> _autoHideKey = GlobalKey();
  final GlobalKey<PullDownDisclosureCanvasHeaderWidgetState> _disclosureKey = GlobalKey();

  // Telemetry state
  double _currentOffset = 0.0;
  bool _simulateReducedMotion = false;

  // Style 1 params (Morphing Split)
  double _splitDistance = 60.0;
  double _splitMergeThreshold = 0.65;
  final double _splitExpandedHeight = 140.0;

  // Style 2 params (Elastic Floating)
  double _elasticHeight = 72.0;
  final double _elasticCompactHeight = 56.0;
  double _elasticDamping = 18.0;
  final double _elasticStiffness = 220.0;
  final double _elasticHorizontalMargin = 16.0;
  final double _elasticElevation = 4.0;

  // Style 3 params (Disappearing Actions)
  double _disappearingExpandedHeight = 160.0;
  final double _disappearingDetachOffset = 45.0;
  final double _disappearingFadeOffset = 80.0;
  final double _disappearingActionSpacing = 10.0;
  final double _disappearingElevation = 6.0;

  // Style 4 params (Circular Morph)
  double _circleTargetDiameter = 54.0;
  final double _circleExpandedHeight = 140.0;
  final Alignment _circleAnchorAlignment = Alignment.topRight;

  // Style 5 params (Flip 3D)
  double _flipPerspective = 0.0016;
  final double _flipFrontElevation = 2.0;
  final double _flipBackElevation = 4.0;
  final Axis _flipAxis = Axis.horizontal;

  // Style 6 params (Horizontal Sliding Panels)
  double _panel1SlideDistance = 100.0;
  final double _panel2SlideDistance = 80.0;
  final double _panelsFadeThreshold = 0.65;

  // Style 7 params (Vertical Folding Accordion)
  double _accordionFoldThreshold = 100.0;
  final double _accordionPerspective = 0.002;
  final double _accordionSeamShadow = 0.45;

  // Style 8 params (Layered Depth Parallax)
  double _parallaxBgFactor = 0.25;
  final double _parallaxMidFactor = 0.6;
  final double _parallaxMaxBlur = 8.0;

  // Style 9 params (Expanding Hero Card)
  double _cardHMargin = 16.0;
  final double _cardVMargin = 12.0;
  final double _cardRadius = 20.0;
  final double _cardExpandThreshold = 65.0;

  // Style 10 params (Liquid Wave Morph)
  double _waveAmplitude = 22.0;
  final double _waveFrequency = 1.4;
  final double _waveFlattenOffset = 85.0;

  // Style 11 params (Auto-Hiding Velocity)
  double _autoHideVelocityThreshold = 150.0;
  final double _autoRevealVelocityThreshold = -120.0;
  final double _autoHideElevation = 3.0;

  // Style 12 params (Scroll-Synchronized Progress)
  double _progressStrokeWidth = 3.5;
  final bool _progressShowBadge = true;

  // Style 13 params (Sticky-Collapse Dual-Tier)
  double _tier1Height = 85.0;
  final double _tier2Height = 56.0;
  final double _dualTierCollapseThreshold = 85.0;

  // Style 14 params (Multi-Stage Staged Reveal)
  double _stage1EndOffset = 70.0;
  final double _stage2EndOffset = 140.0;
  final double _multiStageExpandedHeight = 210.0;

  // Style 15 params (Animated Dock)
  double _dockTriggerOffset = 90.0;
  final double _dockBottomMargin = 16.0;
  final double _dockElevation = 8.0;

  // Style 16 params (Radial Orbital Action)
  double _orbitRadius = 65.0;
  double _orbitalCollapseThreshold = 95.0;

  // Style 17 params (Split-Screen Lateral Reveal)
  double _curtainPartingDistance = 110.0;
  double _curtainRevealThreshold = 85.0;

  // Style 18 params (Magnetic Scroll-Snap)
  double _snapExpandedHeight = 180.0;
  double _snapProximity = 32.0;

  // Style 19 params (Parallax Zoom Hero)
  double _zoomMaxOverscroll = 1.45;
  double _zoomMinCollapse = 0.85;

  // Style 20 params (Pull-Down Disclosure Canvas)
  double _disclosureRestingHeight = 110.0;
  double _disclosureCanvasHeight = 150.0;

  // Style 21 params (Tab-Transform)
  int _selectedTabTransformIndex = 0;
  double _tabExpandedHeight = 150.0;
  double _tabCompactHeight = 40.0;

  // Style 22 params (Avatar-to-Profile)
  double _avatarInitialDiameter = 76.0;
  double _avatarCompactDiameter = 36.0;
  double _avatarArcBias = 0.35;

  // Style 23 params (Progressive Disclosure)
  double _progressiveStage1 = 45.0;
  double _progressiveStage2 = 95.0;

  // Style 24 params (Sideways-Collapse)
  double _sidewaysCompactWidth = 85.0;
  double _sidewaysCollapseThreshold = 95.0;

  // Style 25 params (Expanding Search)
  final GlobalKey<ExpandingSearchHeaderWidgetState> _expandingSearchKey = GlobalKey();
  double _expandingSearchThreshold = 75.0;

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
    if (_selectedBatchFilter > 0) {
      return ExperienceStyle.values
          .where((s) => s.batch == _selectedBatchFilter)
          .toList();
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
              // Floating Bottom Dock Capsule (for Style 15)
              if (_selectedStyle == ExperienceStyle.animatedDock)
                FloatingBottomDockCapsule(
                  scrollOffset: _currentOffset,
                  config: AnimatedDockConfig(
                    dockTriggerOffset: _dockTriggerOffset,
                    dockBottomMargin: _dockBottomMargin,
                    dockElevation: _dockElevation,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.home),
                        tooltip: 'Home',
                        onPressed: _resetScroll,
                      ),
                      IconButton(
                        icon: const Icon(Icons.search),
                        tooltip: 'Search',
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: const Icon(Icons.bookmark),
                        tooltip: 'Saved',
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: const Icon(Icons.tune),
                        tooltip: 'Tune',
                        onPressed: () => _openParameterSheet(context),
                      ),
                    ],
                  ),
                ),
              // Sticky Live Telemetry HUD
              Positioned(
                right: 16.0,
                bottom: _selectedStyle == ExperienceStyle.animatedDock ? 88.0 : 16.0,
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
              IconButton(icon: const Icon(Icons.arrow_back), onPressed: () {}),
              const SizedBox(width: 4.0),
              Text('Projects', style: theme.textTheme.titleMedium!.copyWith(fontWeight: FontWeight.bold)),
            ],
          ),
          rightModule: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(icon: const Icon(Icons.filter_list), onPressed: () {}),
              IconButton(icon: const Icon(Icons.search), onPressed: () {}),
            ],
          ),
          compactPill: const Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.layers, size: 18.0),
              SizedBox(width: 6.0),
              Text('Projects', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13.0)),
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
                  child: Text('Elastic Floating Mode', style: theme.textTheme.titleSmall!.copyWith(fontWeight: FontWeight.bold)),
                ),
                IconButton(icon: const Icon(Icons.tune, size: 20.0), onPressed: () => _openParameterSheet(context)),
              ],
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              alignment: Alignment.center,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Elastic Dynamics Header', style: theme.textTheme.titleMedium!.copyWith(fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 2.0),
                  Text('Pull down to observe non-linear spring stretch', style: theme.textTheme.bodySmall, maxLines: 1, overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
          ),
        );

      // 3. Disappearing Floating Actions
      case ExperienceStyle.disappearingActions:
        return DisappearingFloatingActionsHeaderWidget(
          title: Text('Unpinned Header Canvas', style: theme.textTheme.titleMedium!.copyWith(fontWeight: FontWeight.bold)),
          subtitle: const Text('Scroll up: only floating action pills remain'),
          leading: IconButton(icon: const Icon(Icons.menu), onPressed: () {}),
          actions: [
            IconButton(icon: const Icon(Icons.bookmark_border), tooltip: 'Bookmark', onPressed: () {}),
            IconButton(icon: const Icon(Icons.share), tooltip: 'Share', onPressed: () {}),
            IconButton(icon: const Icon(Icons.code), tooltip: 'View Code', onPressed: () => _showCodeDialog(context)),
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
                const CircleAvatar(radius: 28.0, backgroundColor: Colors.indigo, child: Icon(Icons.person, size: 30.0, color: Colors.white)),
                const SizedBox(height: 4.0),
                Text('Sarah Connor', style: theme.textTheme.titleMedium!.copyWith(fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis),
                Text('Cybernetics Architect', style: theme.textTheme.bodySmall, maxLines: 1, overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
          circularChild: const CircleAvatar(backgroundColor: Colors.indigo, child: Icon(Icons.person, color: Colors.white, size: 24.0)),
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
                    decoration: BoxDecoration(color: theme.colorScheme.primary, borderRadius: BorderRadius.circular(12.0)),
                    child: const Icon(Icons.view_in_ar, color: Colors.white, size: 28.0),
                  ),
                  const SizedBox(width: 14.0),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('3D Flip Face A: Card', style: theme.textTheme.titleMedium!.copyWith(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 2.0),
                        Text('Scroll down to flip 180° into Face B', style: theme.textTheme.bodySmall),
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
                  child: Text('Face B: Compact Nav Bar', style: theme.textTheme.titleSmall!.copyWith(fontWeight: FontWeight.bold)),
                ),
                IconButton(icon: const Icon(Icons.refresh), onPressed: _resetScroll),
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
              Text('Explore Catalogs', style: theme.textTheme.titleMedium!.copyWith(fontWeight: FontWeight.bold)),
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
                FilterChip(selected: false, label: const Text('Sci-Fi'), onSelected: (_) {}),
              ],
            ),
          ),
          slidingPanelRight: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                const Icon(Icons.bolt, size: 16.0, color: Colors.amber),
                const SizedBox(width: 6.0),
                Text('48 new arrivals updated today', style: theme.textTheme.bodySmall),
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
              Text('Origami Accordion', style: theme.textTheme.titleMedium!.copyWith(fontWeight: FontWeight.bold)),
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
                      Text('Tier 2: Collapsible Details', style: theme.textTheme.titleSmall!.copyWith(fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis),
                      Text('Folds 90° along the top hinge with seam shading', style: theme.textTheme.bodySmall, maxLines: 1, overflow: TextOverflow.ellipsis),
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
            child: const Center(child: Icon(Icons.landscape, size: 100.0, color: Colors.white24)),
          ),
          midgroundLayer: Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 24.0, top: 40.0),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
                    decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.25), borderRadius: BorderRadius.circular(20.0)),
                    child: const Text('FEATURED DESTINATION', style: TextStyle(color: Colors.white, fontSize: 11.0, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
          ),
          foregroundLayer: Row(
            children: [
              IconButton(icon: const Icon(Icons.arrow_back, color: Colors.white), onPressed: () {}),
              const SizedBox(width: 8.0),
              const Text('Glacier National Park', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18.0)),
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
                const CircleAvatar(radius: 30.0, backgroundColor: Colors.teal, child: Icon(Icons.wallet, color: Colors.white, size: 28.0)),
                const SizedBox(width: 16.0),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Total Balance', style: theme.textTheme.bodySmall),
                      Text('\$24,580.00', style: theme.textTheme.headlineSmall!.copyWith(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 2.0),
                      Text('Scroll to expand card full-bleed', style: theme.textTheme.bodySmall),
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
              Text('Wallet: \$24,580.00', style: theme.textTheme.titleMedium!.copyWith(fontWeight: FontWeight.bold)),
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
          compactTitle: const Text('Liquid Horizon', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18.0)),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            alignment: Alignment.centerLeft,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Oceanic Flow Wave', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20.0)),
                const SizedBox(height: 4.0),
                Text('Sine wave bottom edge dynamically flattens into a straight bar', style: TextStyle(color: Colors.white.withValues(alpha: 0.85), fontSize: 13.0)),
              ],
            ),
          ),
        );

      // 11. Auto-Hiding Velocity Header
      case ExperienceStyle.autoHiding:
        return SliverToBoxAdapter(
          child: AutoHidingVelocityHeaderWidget(
            key: _autoHideKey,
            config: AutoHidingVelocityConfig(
              height: 64.0,
              hideVelocityThreshold: _autoHideVelocityThreshold,
              revealVelocityThreshold: _autoRevealVelocityThreshold,
              elevation: _autoHideElevation,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  IconButton(icon: const Icon(Icons.arrow_back), onPressed: () {}),
                  const SizedBox(width: 8.0),
                  Text('Auto-Hiding Velocity Bar', style: theme.textTheme.titleMedium!.copyWith(fontWeight: FontWeight.bold)),
                  const Spacer(),
                  IconButton(icon: const Icon(Icons.tune), onPressed: () => _openParameterSheet(context)),
                ],
              ),
            ),
          ),
        );

      // 12. Scroll-Synchronized Progress Header
      case ExperienceStyle.progressSync:
        return ScrollSynchronizedProgressHeaderWidget(
          title: const Text('Chapter 12: Quantum Computing'),
          subtitle: const Text('18 min read remaining'),
          leading: IconButton(icon: const Icon(Icons.menu_book), onPressed: () {}),
          actions: [
            IconButton(icon: const Icon(Icons.bookmark_border), onPressed: () {}),
          ],
          config: ScrollSynchronizedProgressConfig(
            expandedHeight: 140.0,
            collapsedHeight: 60.0,
            progressStrokeWidth: _progressStrokeWidth,
            showPercentageBadge: _progressShowBadge,
          ),
        );

      // 13. Sticky-Collapse Dual-Tier Header
      case ExperienceStyle.stickyDualTier:
        return StickyCollapseDualTierHeaderWidget(
          config: StickyCollapseDualTierConfig(
            tier1Height: _tier1Height,
            tier2Height: _tier2Height,
            collapseThreshold: _dualTierCollapseThreshold,
          ),
          tier1Content: Container(
            color: theme.colorScheme.primaryContainer,
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            alignment: Alignment.centerLeft,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Tier 1: Global Marketplace', style: theme.textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold)),
                Text('Collapses away completely as user scrolls', style: theme.textTheme.bodySmall),
              ],
            ),
          ),
          tier2Content: Container(
            color: theme.colorScheme.surface,
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                const Icon(Icons.category, size: 20.0),
                const SizedBox(width: 8.0),
                Expanded(
                  child: Text('Tier 2: Sticky Pinned Controls', style: theme.textTheme.titleSmall!.copyWith(fontWeight: FontWeight.bold)),
                ),
                FilledButton.tonal(
                  onPressed: () {},
                  child: const Text('Filter'),
                ),
              ],
            ),
          ),
        );

      // 14. Multi-Stage Staged Reveal Header
      case ExperienceStyle.multiStage:
        return MultiStageStagedRevealHeaderWidget(
          config: MultiStageStagedRevealConfig(
            expandedHeight: _multiStageExpandedHeight,
            collapsedHeight: 60.0,
            stage1EndOffset: _stage1EndOffset,
            stage2EndOffset: _stage2EndOffset,
          ),
          stage1Hero: Container(
            color: theme.colorScheme.tertiaryContainer,
            padding: const EdgeInsets.all(20.0),
            alignment: Alignment.center,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.rocket_launch, size: 48.0, color: Colors.deepOrange),
                const SizedBox(height: 8.0),
                Text('Stage 1: Hero Launchpad', style: theme.textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold)),
                Text('Scroll down into Stage 2', style: theme.textTheme.bodySmall),
              ],
            ),
          ),
          stage2Meta: Container(
            color: theme.colorScheme.surfaceContainerHighest,
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            alignment: Alignment.center,
            child: Row(
              children: [
                const Icon(Icons.tune, color: Colors.teal),
                const SizedBox(width: 8.0),
                Expanded(
                  child: Text('Stage 2: Contextual Meta Controls', style: theme.textTheme.titleSmall!.copyWith(fontWeight: FontWeight.bold)),
                ),
                const Chip(label: Text('Active Filters')),
              ],
            ),
          ),
          stage3Toolbar: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.green),
                const SizedBox(width: 8.0),
                Expanded(
                  child: Text('Stage 3: Docked Toolbar', style: theme.textTheme.titleMedium!.copyWith(fontWeight: FontWeight.bold)),
                ),
                IconButton(icon: const Icon(Icons.vertical_align_top), onPressed: _resetScroll),
              ],
            ),
          ),
        );

      // 15. Animated Dock Header
      case ExperienceStyle.animatedDock:
        return AnimatedDockHeaderWidget(
          config: AnimatedDockConfig(
            topHeaderHeight: 110.0,
            dockTriggerOffset: _dockTriggerOffset,
          ),
          topHeaderContent: Container(
            color: theme.colorScheme.primaryContainer,
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            alignment: Alignment.centerLeft,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Top Header Canvas', style: theme.textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 2.0),
                Text('Scroll down: header dissolves into floating bottom dock', style: theme.textTheme.bodySmall, maxLines: 1, overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
        );

      // 16. Radial Orbital Action Header
      case ExperienceStyle.radialOrbital:
        return RadialOrbitalActionHeaderWidget(
          config: RadialOrbitalActionConfig(
            expandedHeight: 180.0,
            collapsedHeight: 60.0,
            orbitRadius: _orbitRadius,
            collapseThreshold: _orbitalCollapseThreshold,
          ),
          centerAnchor: const CircleAvatar(
            radius: 30.0,
            backgroundColor: Colors.deepPurple,
            child: Icon(Icons.person, color: Colors.white, size: 28.0),
          ),
          title: const Text('Dr. Emmett Brown'),
          actions: [
            IconButton.filledTonal(
              icon: const Icon(Icons.call),
              tooltip: 'Call',
              onPressed: () {},
            ),
            IconButton.filledTonal(
              icon: const Icon(Icons.videocam),
              tooltip: 'Video',
              onPressed: () {},
            ),
            IconButton.filledTonal(
              icon: const Icon(Icons.email),
              tooltip: 'Message',
              onPressed: () {},
            ),
          ],
        );

      // 17. Split-Screen Lateral Reveal Header
      case ExperienceStyle.splitCurtain:
        return SplitScreenLateralRevealHeaderWidget(
          config: SplitScreenLateralRevealConfig(
            expandedHeight: 190.0,
            collapsedHeight: 60.0,
            partingDistance: _curtainPartingDistance,
            revealThreshold: _curtainRevealThreshold,
          ),
          centerShowcase: Container(
            width: 140.0,
            height: 140.0,
            decoration: BoxDecoration(
              color: Colors.amber.shade700,
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: const Center(
              child: Icon(Icons.movie_creation, size: 64.0, color: Colors.white),
            ),
          ),
          leftCurtain: Container(
            color: theme.colorScheme.primary,
            padding: const EdgeInsets.all(16.0),
            alignment: Alignment.centerLeft,
            child: const Text('WEST\nWING', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18.0)),
          ),
          rightCurtain: Container(
            color: theme.colorScheme.secondary,
            padding: const EdgeInsets.all(16.0),
            alignment: Alignment.centerRight,
            child: const Text('EAST\nWING', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18.0)),
          ),
          compactToolbar: Row(
            children: [
              IconButton(icon: const Icon(Icons.menu), onPressed: () {}),
              const SizedBox(width: 8.0),
              Text('Cinema Premiere Hall', style: theme.textTheme.titleMedium!.copyWith(fontWeight: FontWeight.bold)),
              const Spacer(),
              IconButton(icon: const Icon(Icons.search), onPressed: () {}),
            ],
          ),
        );

      // 18. Magnetic Scroll-Snap Header
      case ExperienceStyle.magneticSnap:
        return MagneticScrollSnapHeaderWidget(
          config: MagneticScrollSnapConfig(
            expandedHeight: _snapExpandedHeight,
            collapsedHeight: 60.0,
            snapProximity: _snapProximity,
          ),
          expandedContent: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.gps_fixed, size: 40.0, color: Colors.teal),
                const SizedBox(height: 6.0),
                Text('Magnetic Snap Header', style: theme.textTheme.titleMedium!.copyWith(fontWeight: FontWeight.bold)),
                Text('Scroll release snaps magnetically into discrete bounds', style: theme.textTheme.bodySmall),
              ],
            ),
          ),
          collapsedContent: Row(
            children: [
              IconButton(icon: const Icon(Icons.arrow_back), onPressed: () {}),
              const SizedBox(width: 8.0),
              Text('Magnetic Docked Toolbar', style: theme.textTheme.titleMedium!.copyWith(fontWeight: FontWeight.bold)),
              const Spacer(),
              IconButton(icon: const Icon(Icons.tune), onPressed: () => _openParameterSheet(context)),
            ],
          ),
        );

      // 19. Parallax Zoom Hero Header
      case ExperienceStyle.parallaxZoom:
        return ParallaxZoomHeroHeaderWidget(
          config: ParallaxZoomHeroConfig(
            expandedHeight: 220.0,
            collapsedHeight: 60.0,
            maxOverscrollZoom: _zoomMaxOverscroll,
            minCollapseZoom: _zoomMinCollapse,
          ),
          heroVisual: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF880E4F), Color(0xFFAD1457), Color(0xFFD81B60)],
              ),
            ),
            child: const Center(
              child: Icon(Icons.camera_alt, size: 80.0, color: Colors.white30),
            ),
          ),
          foregroundOverlay: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Yosemite Valley Peak', style: theme.textTheme.headlineSmall!.copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
                const Text('Pinch/pull down to observe elastic zoom magnification', style: TextStyle(color: Colors.white70, fontSize: 13.0)),
              ],
            ),
          ),
          compactTitle: const Text('Yosemite Valley Peak', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        );

      // 20. Pull-Down Disclosure Canvas
      case ExperienceStyle.pullDisclosure:
        return SliverToBoxAdapter(
          child: PullDownDisclosureCanvasHeaderWidget(
            key: _disclosureKey,
            config: PullDownDisclosureCanvasConfig(
              restingHeight: _disclosureRestingHeight,
              disclosureCanvasHeight: _disclosureCanvasHeight,
            ),
            disclosureCanvasContent: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Quick Utilities Canvas', style: theme.textTheme.titleSmall!.copyWith(fontWeight: FontWeight.bold)),
                      IconButton(
                        icon: const Icon(Icons.close, size: 18.0),
                        onPressed: () => _disclosureKey.currentState?.setDisclosed(false),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8.0),
                  Wrap(
                    spacing: 8.0,
                    children: [
                      ActionChip(avatar: const Icon(Icons.wifi, size: 16.0), label: const Text('Wi-Fi Hotspot'), onPressed: () {}),
                      ActionChip(avatar: const Icon(Icons.bluetooth, size: 16.0), label: const Text('Bluetooth'), onPressed: () {}),
                      ActionChip(avatar: const Icon(Icons.airplanemode_active, size: 16.0), label: const Text('Airplane'), onPressed: () {}),
                    ],
                  ),
                ],
              ),
            ),
            restingHeaderContent: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  IconButton(icon: const Icon(Icons.menu), onPressed: () {}),
                  const SizedBox(width: 8.0),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Pull-Down Disclosure Header', style: theme.textTheme.titleMedium!.copyWith(fontWeight: FontWeight.bold)),
                        Text('Pull down overscroll or tap to unlock utility drawer', style: theme.textTheme.bodySmall),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.expand_more),
                    tooltip: 'Toggle Disclosure',
                    onPressed: () => _disclosureKey.currentState?.toggleDisclosure(),
                  ),
                ],
              ),
            ),
          ),
        );

      // 21. Animated Tab-Transform Header
      case ExperienceStyle.tabTransform:
        return TabTransformHeaderWidget(
          title: Text(
            'Engineering Portal',
            style: theme.textTheme.titleMedium!.copyWith(fontWeight: FontWeight.bold),
          ),
          actions: [
            IconButton(icon: const Icon(Icons.notifications_none), onPressed: () {}),
            IconButton(icon: const Icon(Icons.tune), onPressed: () => _openParameterSheet(context)),
          ],
          tabs: const [
            TabTransformItem(label: 'Architecture', icon: Icons.architecture, subtitle: 'System blue-prints'),
            TabTransformItem(label: 'AI Models', icon: Icons.psychology, subtitle: 'Neural inference', badge: 'v2'),
            TabTransformItem(label: 'Frameworks', icon: Icons.layers, subtitle: 'Flutter & Dart'),
            TabTransformItem(label: 'Tooling', icon: Icons.build_circle, subtitle: 'DevOps & CI/CD'),
          ],
          selectedIndex: _selectedTabTransformIndex,
          onTabSelected: (idx) {
            setState(() {
              _selectedTabTransformIndex = idx;
            });
          },
          config: TabTransformConfig(
            expandedHeight: _tabExpandedHeight,
            compactTabHeight: _tabCompactHeight,
          ),
        );

      // 22. Avatar-to-Profile Arc Header
      case ExperienceStyle.avatarToProfile:
        return AvatarToProfileHeaderWidget(
          avatar: const CircleAvatar(
            radius: 38.0,
            backgroundColor: Colors.deepPurple,
            child: Icon(Icons.person, color: Colors.white, size: 40.0),
          ),
          name: Text(
            'Dr. Evelyn Cross',
            style: theme.textTheme.titleMedium!.copyWith(fontWeight: FontWeight.bold),
          ),
          handle: const Text('@evelyn_cross'),
          bio: const Text('Principal Neural Systems Engineer • 14.2k followers'),
          leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () {}),
          actions: [
            IconButton(icon: const Icon(Icons.share), onPressed: () {}),
            IconButton(icon: const Icon(Icons.tune), onPressed: () => _openParameterSheet(context)),
          ],
          config: AvatarToProfileConfig(
            initialAvatarDiameter: _avatarInitialDiameter,
            compactAvatarDiameter: _avatarCompactDiameter,
            arcControlPointBias: _avatarArcBias,
          ),
        );

      // 23. Progressive Disclosure Header
      case ExperienceStyle.progressiveDisclosure:
        return ProgressiveDisclosureHeaderWidget(
          title: const Text('Market Discovery'),
          actions: [
            IconButton(icon: const Icon(Icons.tune), onPressed: () => _openParameterSheet(context)),
          ],
          searchBar: Container(
            height: 42.0,
            padding: const EdgeInsets.symmetric(horizontal: 14.0),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(24.0),
            ),
            child: const Row(
              children: [
                Icon(Icons.search, size: 20.0),
                SizedBox(width: 8.0),
                Expanded(
                  child: Text(
                    'Search components, plugins, templates...',
                    style: TextStyle(fontSize: 13.0),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          filterRow: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                FilterChip(selected: true, label: const Text('All Items'), onSelected: (_) {}),
                const SizedBox(width: 6.0),
                FilterChip(selected: false, label: const Text('Verified'), onSelected: (_) {}),
                const SizedBox(width: 6.0),
                FilterChip(selected: false, label: const Text('Popular'), onSelected: (_) {}),
                const SizedBox(width: 6.0),
                FilterChip(selected: false, label: const Text('Open Source'), onSelected: (_) {}),
              ],
            ),
          ),
          config: ProgressiveDisclosureConfig(
            stage1Threshold: _progressiveStage1,
            stage2Threshold: _progressiveStage2,
          ),
        );

      // 24. Sideways-Collapse Header
      case ExperienceStyle.sidewaysCollapse:
        return SidewaysCollapseHeaderWidget(
          expandedContent: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                const Icon(Icons.hub, size: 36.0, color: Colors.indigoAccent),
                const SizedBox(width: 12.0),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Global Workspace Hub',
                        style: theme.textTheme.titleMedium!.copyWith(fontWeight: FontWeight.bold),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        '8 Active Repositories • 4 Teams Synchronized',
                        style: theme.textTheme.bodySmall,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                FilledButton.tonal(
                  onPressed: () => _openParameterSheet(context),
                  child: const Text('Config'),
                ),
              ],
            ),
          ),
          compactRailContent: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.hub, size: 22.0, color: Colors.indigoAccent),
              SizedBox(width: 6.0),
              Text('Hub', style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          config: SidewaysCollapseConfig(
            compactRailWidth: _sidewaysCompactWidth,
            collapseThreshold: _sidewaysCollapseThreshold,
          ),
        );

      // 25. Expanding Search Transformation Header
      case ExperienceStyle.expandingSearch:
        return ExpandingSearchHeaderWidget(
          key: _expandingSearchKey,
          title: const Text('Global Catalog Hub'),
          subtitle: const Text('Search among 40,000 components'),
          leading: IconButton(icon: const Icon(Icons.menu), onPressed: () {}),
          actions: [
            IconButton(icon: const Icon(Icons.favorite_border), onPressed: () {}),
            IconButton(icon: const Icon(Icons.tune), onPressed: () => _openParameterSheet(context)),
          ],
          config: ExpandingSearchConfig(
            expandThreshold: _expandingSearchThreshold,
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
            // Batch Indicator Banner with interactive switcher
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
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Batches 1–5 Active (Styles 1–25 of 50)',
                                style: theme.textTheme.labelLarge!.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                'Autonomous visual structures, motion physics & interaction mechanics.',
                                style: theme.textTheme.bodySmall,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
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
                          label: const Text('All (1–25)'),
                          selected: _selectedBatchFilter == 0,
                          onSelected: (_) => setState(() => _selectedBatchFilter = 0),
                        ),
                        FilterChip(
                          label: const Text('Batch 1 (1–5)'),
                          selected: _selectedBatchFilter == 1,
                          onSelected: (_) => setState(() => _selectedBatchFilter = 1),
                        ),
                        FilterChip(
                          label: const Text('Batch 2 (6–10)'),
                          selected: _selectedBatchFilter == 2,
                          onSelected: (_) => setState(() => _selectedBatchFilter = 2),
                        ),
                        FilterChip(
                          label: const Text('Batch 3 (11–15)'),
                          selected: _selectedBatchFilter == 3,
                          onSelected: (_) => setState(() => _selectedBatchFilter = 3),
                        ),
                        FilterChip(
                          label: const Text('Batch 4 (16–20)'),
                          selected: _selectedBatchFilter == 4,
                          onSelected: (_) => setState(() => _selectedBatchFilter = 4),
                        ),
                        FilterChip(
                          label: const Text('Batch 5 (21–25)'),
                          selected: _selectedBatchFilter == 5,
                          onSelected: (_) => setState(() => _selectedBatchFilter = 5),
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
              key: const ValueKey('styles_choice_scroll'),
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _filteredStyles.map((style) {
                  final isSelected = _selectedStyle == style;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: ChoiceChip(
                      key: ValueKey('style_chip_${style.id}'),
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
              leading: CircleAvatar(child: Text('${index + 1}')),
              title: Text('Scrollable Content Item #${index + 1}'),
              subtitle: Text('Observing "${_selectedStyle.title}" response at ${_currentOffset.toStringAsFixed(1)}px offset.'),
              trailing: const Icon(Icons.chevron_right),
            ),
          );
        },
        childCount: 30,
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
            Icon(Icons.analytics_outlined, size: 16.0, color: theme.colorScheme.onInverseSurface),
            const SizedBox(width: 8.0),
            Text(
              'Offset: ${_currentOffset.toStringAsFixed(1)}px',
              style: TextStyle(fontFamily: 'monospace', fontSize: 12.0, color: theme.colorScheme.onInverseSurface, fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 12.0),
            Text(
              _simulateReducedMotion ? 'A11Y Fallback' : '60 FPS Motion',
              style: TextStyle(fontSize: 11.0, color: theme.colorScheme.inversePrimary, fontWeight: FontWeight.w600),
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
                      Text('Tune: ${_selectedStyle.title}', style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
                      IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context)),
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
          Text('Split Divergence: ${_splitDistance.toStringAsFixed(0)} px'),
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
        ];

      case ExperienceStyle.layeredDepth:
        return [
          Text('Background Parallax: ${_parallaxBgFactor.toStringAsFixed(2)}x'),
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
        ];

      case ExperienceStyle.autoHiding:
        return [
          Text('Hide Velocity: ${_autoHideVelocityThreshold.toStringAsFixed(0)} px/s'),
          Slider(
            value: _autoHideVelocityThreshold,
            min: 50.0,
            max: 400.0,
            divisions: 14,
            onChanged: (val) {
              setSheetState(() => _autoHideVelocityThreshold = val);
              setState(() => _autoHideVelocityThreshold = val);
            },
          ),
        ];

      case ExperienceStyle.progressSync:
        return [
          Text('Stroke Width: ${_progressStrokeWidth.toStringAsFixed(1)} px'),
          Slider(
            value: _progressStrokeWidth,
            min: 2.0,
            max: 6.0,
            divisions: 8,
            onChanged: (val) {
              setSheetState(() => _progressStrokeWidth = val);
              setState(() => _progressStrokeWidth = val);
            },
          ),
        ];

      case ExperienceStyle.stickyDualTier:
        return [
          Text('Tier 1 Height: ${_tier1Height.toStringAsFixed(0)} px'),
          Slider(
            value: _tier1Height,
            min: 60.0,
            max: 130.0,
            divisions: 14,
            onChanged: (val) {
              setSheetState(() => _tier1Height = val);
              setState(() => _tier1Height = val);
            },
          ),
        ];

      case ExperienceStyle.multiStage:
        return [
          Text('Stage 1 End Offset: ${_stage1EndOffset.toStringAsFixed(0)} px'),
          Slider(
            value: _stage1EndOffset,
            min: 40.0,
            max: 100.0,
            divisions: 6,
            onChanged: (val) {
              setSheetState(() => _stage1EndOffset = val);
              setState(() => _stage1EndOffset = val);
            },
          ),
        ];

      case ExperienceStyle.animatedDock:
        return [
          Text('Dock Trigger Offset: ${_dockTriggerOffset.toStringAsFixed(0)} px'),
          Slider(
            value: _dockTriggerOffset,
            min: 40.0,
            max: 160.0,
            divisions: 12,
            onChanged: (val) {
              setSheetState(() => _dockTriggerOffset = val);
              setState(() => _dockTriggerOffset = val);
            },
          ),
        ];

      case ExperienceStyle.radialOrbital:
        return [
          Text('Orbit Radius: ${_orbitRadius.toStringAsFixed(0)} px'),
          Slider(
            value: _orbitRadius,
            min: 40.0,
            max: 100.0,
            divisions: 12,
            onChanged: (val) {
              setSheetState(() => _orbitRadius = val);
              setState(() => _orbitRadius = val);
            },
          ),
          Text('Collapse Threshold: ${_orbitalCollapseThreshold.toStringAsFixed(0)} px'),
          Slider(
            value: _orbitalCollapseThreshold,
            min: 60.0,
            max: 150.0,
            divisions: 9,
            onChanged: (val) {
              setSheetState(() => _orbitalCollapseThreshold = val);
              setState(() => _orbitalCollapseThreshold = val);
            },
          ),
        ];

      case ExperienceStyle.splitCurtain:
        return [
          Text('Parting Distance: ${_curtainPartingDistance.toStringAsFixed(0)} px'),
          Slider(
            value: _curtainPartingDistance,
            min: 50.0,
            max: 160.0,
            divisions: 11,
            onChanged: (val) {
              setSheetState(() => _curtainPartingDistance = val);
              setState(() => _curtainPartingDistance = val);
            },
          ),
          Text('Reveal Threshold: ${_curtainRevealThreshold.toStringAsFixed(0)} px'),
          Slider(
            value: _curtainRevealThreshold,
            min: 50.0,
            max: 140.0,
            divisions: 9,
            onChanged: (val) {
              setSheetState(() => _curtainRevealThreshold = val);
              setState(() => _curtainRevealThreshold = val);
            },
          ),
        ];

      case ExperienceStyle.magneticSnap:
        return [
          Text('Snap Proximity: ${_snapProximity.toStringAsFixed(0)} px'),
          Slider(
            value: _snapProximity,
            min: 16.0,
            max: 60.0,
            divisions: 11,
            onChanged: (val) {
              setSheetState(() => _snapProximity = val);
              setState(() => _snapProximity = val);
            },
          ),
          Text('Expanded Height: ${_snapExpandedHeight.toStringAsFixed(0)} px'),
          Slider(
            value: _snapExpandedHeight,
            min: 140.0,
            max: 240.0,
            divisions: 10,
            onChanged: (val) {
              setSheetState(() => _snapExpandedHeight = val);
              setState(() => _snapExpandedHeight = val);
            },
          ),
        ];

      case ExperienceStyle.parallaxZoom:
        return [
          Text('Max Zoom Overscroll: ${_zoomMaxOverscroll.toStringAsFixed(2)}x'),
          Slider(
            value: _zoomMaxOverscroll,
            min: 1.1,
            max: 1.8,
            divisions: 7,
            onChanged: (val) {
              setSheetState(() => _zoomMaxOverscroll = val);
              setState(() => _zoomMaxOverscroll = val);
            },
          ),
          Text('Min Collapse Zoom: ${_zoomMinCollapse.toStringAsFixed(2)}x'),
          Slider(
            value: _zoomMinCollapse,
            min: 0.6,
            max: 0.95,
            divisions: 7,
            onChanged: (val) {
              setSheetState(() => _zoomMinCollapse = val);
              setState(() => _zoomMinCollapse = val);
            },
          ),
        ];

      case ExperienceStyle.pullDisclosure:
        return [
          Text('Disclosure Height: ${_disclosureCanvasHeight.toStringAsFixed(0)} px'),
          Slider(
            value: _disclosureCanvasHeight,
            min: 100.0,
            max: 220.0,
            divisions: 12,
            onChanged: (val) {
              setSheetState(() => _disclosureCanvasHeight = val);
              setState(() => _disclosureCanvasHeight = val);
            },
          ),
          Text('Resting Height: ${_disclosureRestingHeight.toStringAsFixed(0)} px'),
          Slider(
            value: _disclosureRestingHeight,
            min: 80.0,
            max: 150.0,
            divisions: 7,
            onChanged: (val) {
              setSheetState(() => _disclosureRestingHeight = val);
              setState(() => _disclosureRestingHeight = val);
            },
          ),
        ];

      case ExperienceStyle.tabTransform:
        return [
          Text('Expanded Tab Height: ${_tabExpandedHeight.toStringAsFixed(0)} px'),
          Slider(
            value: _tabExpandedHeight,
            min: 120.0,
            max: 200.0,
            divisions: 8,
            onChanged: (val) {
              setSheetState(() => _tabExpandedHeight = val);
              setState(() => _tabExpandedHeight = val);
            },
          ),
          Text('Compact Tab Height: ${_tabCompactHeight.toStringAsFixed(0)} px'),
          Slider(
            value: _tabCompactHeight,
            min: 32.0,
            max: 56.0,
            divisions: 6,
            onChanged: (val) {
              setSheetState(() => _tabCompactHeight = val);
              setState(() => _tabCompactHeight = val);
            },
          ),
        ];

      case ExperienceStyle.avatarToProfile:
        return [
          Text('Initial Avatar Diameter: ${_avatarInitialDiameter.toStringAsFixed(0)} px'),
          Slider(
            value: _avatarInitialDiameter,
            min: 56.0,
            max: 96.0,
            divisions: 8,
            onChanged: (val) {
              setSheetState(() => _avatarInitialDiameter = val);
              setState(() => _avatarInitialDiameter = val);
            },
          ),
          Text('Compact Avatar Diameter: ${_avatarCompactDiameter.toStringAsFixed(0)} px'),
          Slider(
            value: _avatarCompactDiameter,
            min: 28.0,
            max: 48.0,
            divisions: 5,
            onChanged: (val) {
              setSheetState(() => _avatarCompactDiameter = val);
              setState(() => _avatarCompactDiameter = val);
            },
          ),
          Text('Arc Curvature Bias: ${_avatarArcBias.toStringAsFixed(2)}'),
          Slider(
            value: _avatarArcBias,
            min: 0.1,
            max: 0.7,
            divisions: 6,
            onChanged: (val) {
              setSheetState(() => _avatarArcBias = val);
              setState(() => _avatarArcBias = val);
            },
          ),
        ];

      case ExperienceStyle.progressiveDisclosure:
        return [
          Text('Stage 1 (Search Reveal): ${_progressiveStage1.toStringAsFixed(0)} px'),
          Slider(
            value: _progressiveStage1,
            min: 30.0,
            max: 80.0,
            divisions: 5,
            onChanged: (val) {
              setSheetState(() => _progressiveStage1 = val);
              setState(() => _progressiveStage1 = val);
            },
          ),
          Text('Stage 2 (Filter Pin): ${_progressiveStage2.toStringAsFixed(0)} px'),
          Slider(
            value: _progressiveStage2,
            min: 70.0,
            max: 140.0,
            divisions: 7,
            onChanged: (val) {
              setSheetState(() => _progressiveStage2 = val);
              setState(() => _progressiveStage2 = val);
            },
          ),
        ];

      case ExperienceStyle.sidewaysCollapse:
        return [
          Text('Compact Rail Width: ${_sidewaysCompactWidth.toStringAsFixed(0)} px'),
          Slider(
            value: _sidewaysCompactWidth,
            min: 60.0,
            max: 120.0,
            divisions: 6,
            onChanged: (val) {
              setSheetState(() => _sidewaysCompactWidth = val);
              setState(() => _sidewaysCompactWidth = val);
            },
          ),
          Text('Collapse Threshold: ${_sidewaysCollapseThreshold.toStringAsFixed(0)} px'),
          Slider(
            value: _sidewaysCollapseThreshold,
            min: 60.0,
            max: 150.0,
            divisions: 9,
            onChanged: (val) {
              setSheetState(() => _sidewaysCollapseThreshold = val);
              setState(() => _sidewaysCollapseThreshold = val);
            },
          ),
        ];

      case ExperienceStyle.expandingSearch:
        return [
          Text('Expand Threshold: ${_expandingSearchThreshold.toStringAsFixed(0)} px'),
          Slider(
            value: _expandingSearchThreshold,
            min: 40.0,
            max: 120.0,
            divisions: 8,
            onChanged: (val) {
              setSheetState(() => _expandingSearchThreshold = val);
              setState(() => _expandingSearchThreshold = val);
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
      leftModule: const Text('Projects', style: TextStyle(fontWeight: FontWeight.bold)),
      rightModule: const Icon(Icons.search),
      compactPill: const Text('Projects', style: TextStyle(fontWeight: FontWeight.bold)),
    ),
    // ... list slivers
  ],
)''';

      case ExperienceStyle.elasticFloating:
        return '''
import 'package:app_bar_ui/app_bar_ui.dart';

CustomScrollView(
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
        ),
        compactChild: const Text('Compact Capsule'),
        child: const Center(child: Text('Elastic Header', style: TextStyle(fontWeight: FontWeight.bold))),
      ),
    ),
    // ... list slivers
  ],
)''';

      case ExperienceStyle.disappearingActions:
        return '''
import 'package:app_bar_ui/app_bar_ui.dart';

CustomScrollView(
  slivers: [
    DisappearingFloatingActionsHeaderWidget(
      title: const Text('Article Title', style: TextStyle(fontWeight: FontWeight.bold)),
      actions: [IconButton(icon: const Icon(Icons.share), onPressed: () {})],
      config: DisappearingFloatingActionsConfig(expandedHeight: $_disappearingExpandedHeight),
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
      ),
      expandedChild: const Text('Sarah Connor'),
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
      config: Flip3DConfig(expandedHeight: 160.0, perspective: $_flipPerspective),
      frontCard: const Card(child: Text('Face A: Hero Card')),
      backToolbar: const Text('Face B: Toolbar'),
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
      config: HorizontalSlidingPanelsConfig(panel1SlideDistance: $_panel1SlideDistance),
      pinnedBar: const Text('Catalogs Bar'),
      slidingPanelLeft: const Chip(label: Text('Books')),
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
      config: VerticalFoldingAccordionConfig(foldThreshold: $_accordionFoldThreshold),
      pinnedToolbar: const Text('Accordion Pinned Bar'),
      foldingTier: const Text('Origami Tier'),
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
      config: LayeredDepthParallaxConfig(backgroundParallaxFactor: $_parallaxBgFactor),
      backgroundLayer: const Text('Ambient Background'),
      midgroundLayer: const Text('Floating Badge'),
      foregroundLayer: const Text('Interactive Bar'),
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
      config: ExpandingHeroCardConfig(cardHorizontalMargin: $_cardHMargin),
      heroCardContent: const Text('Card Presentation'),
      dockedToolbarContent: const Text('Wallet Toolbar'),
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
      config: LiquidWaveMorphConfig(waveAmplitude: $_waveAmplitude),
      compactTitle: const Text('Liquid Title'),
      child: const Center(child: Text('Ocean Wave Canvas')),
    ),
    // ... list slivers
  ],
)''';

      case ExperienceStyle.autoHiding:
        return '''
import 'package:app_bar_ui/app_bar_ui.dart';

SliverToBoxAdapter(
  child: AutoHidingVelocityHeaderWidget(
    config: AutoHidingVelocityConfig(hideVelocityThreshold: $_autoHideVelocityThreshold),
    child: const Text('Auto-Hiding Toolbar'),
  ),
)''';

      case ExperienceStyle.progressSync:
        return '''
import 'package:app_bar_ui/app_bar_ui.dart';

CustomScrollView(
  slivers: [
    ScrollSynchronizedProgressHeaderWidget(
      title: const Text('Article Title'),
      config: ScrollSynchronizedProgressConfig(progressStrokeWidth: $_progressStrokeWidth),
    ),
    // ... list slivers
  ],
)''';

      case ExperienceStyle.stickyDualTier:
        return '''
import 'package:app_bar_ui/app_bar_ui.dart';

CustomScrollView(
  slivers: [
    StickyCollapseDualTierHeaderWidget(
      config: StickyCollapseDualTierConfig(tier1Height: $_tier1Height),
      tier1Content: const Text('Tier 1: Branding'),
      tier2Content: const Text('Tier 2: Sticky Pinned Search'),
    ),
    // ... list slivers
  ],
)''';

      case ExperienceStyle.multiStage:
        return '''
import 'package:app_bar_ui/app_bar_ui.dart';

CustomScrollView(
  slivers: [
    MultiStageStagedRevealHeaderWidget(
      config: MultiStageStagedRevealConfig(stage1EndOffset: $_stage1EndOffset),
      stage1Hero: const Text('Stage 1: Hero'),
      stage2Meta: const Text('Stage 2: Meta'),
      stage3Toolbar: const Text('Stage 3: Dock'),
    ),
    // ... list slivers
  ],
)''';

      case ExperienceStyle.animatedDock:
        return '''
import 'package:app_bar_ui/app_bar_ui.dart';

Stack(
  children: [
    CustomScrollView(
      slivers: [
        AnimatedDockHeaderWidget(
          config: AnimatedDockConfig(dockTriggerOffset: $_dockTriggerOffset),
          topHeaderContent: const Text('Top Header Presentation'),
        ),
        // ... list slivers
      ],
    ),
    FloatingBottomDockCapsule(
      scrollOffset: currentOffset,
      config: AnimatedDockConfig(dockTriggerOffset: $_dockTriggerOffset),
      child: const Text('Floating Dock'),
    ),
  ],
)''';

      case ExperienceStyle.radialOrbital:
        return '''
import 'package:app_bar_ui/app_bar_ui.dart';

CustomScrollView(
  slivers: [
    RadialOrbitalActionHeaderWidget(
      centerAnchor: const CircleAvatar(child: Icon(Icons.person)),
      title: const Text('Dr. Emmett Brown'),
      actions: [
        IconButton(icon: const Icon(Icons.call), onPressed: () {}),
        IconButton(icon: const Icon(Icons.videocam), onPressed: () {}),
        IconButton(icon: const Icon(Icons.email), onPressed: () {}),
      ],
      config: RadialOrbitalActionConfig(
        orbitRadius: $_orbitRadius,
        collapseThreshold: $_orbitalCollapseThreshold,
      ),
    ),
    // ... list slivers
  ],
)''';

      case ExperienceStyle.splitCurtain:
        return '''
import 'package:app_bar_ui/app_bar_ui.dart';

CustomScrollView(
  slivers: [
    SplitScreenLateralRevealHeaderWidget(
      centerShowcase: Container(color: Colors.amber, child: const Icon(Icons.movie)),
      leftCurtain: const Text('West Wing'),
      rightCurtain: const Text('East Wing'),
      config: SplitScreenLateralRevealConfig(
        partingDistance: $_curtainPartingDistance,
        revealThreshold: $_curtainRevealThreshold,
      ),
    ),
    // ... list slivers
  ],
)''';

      case ExperienceStyle.magneticSnap:
        return '''
import 'package:app_bar_ui/app_bar_ui.dart';

CustomScrollView(
  slivers: [
    MagneticScrollSnapHeaderWidget(
      expandedContent: const Text('Magnetic Expanded Hero'),
      collapsedContent: const Text('Docked Toolbar'),
      config: MagneticScrollSnapConfig(
        expandedHeight: $_snapExpandedHeight,
        snapProximity: $_snapProximity,
      ),
    ),
    // ... list slivers
  ],
)''';

      case ExperienceStyle.parallaxZoom:
        return '''
import 'package:app_bar_ui/app_bar_ui.dart';

CustomScrollView(
  slivers: [
    ParallaxZoomHeroHeaderWidget(
      heroVisual: Image.network('https://example.com/hero.jpg', fit: BoxFit.cover),
      foregroundOverlay: const Text('Featured Landmark'),
      compactTitle: const Text('Landmark Pinned'),
      config: ParallaxZoomHeroConfig(
        maxOverscrollZoom: $_zoomMaxOverscroll,
        minCollapseZoom: $_zoomMinCollapse,
      ),
    ),
    // ... list slivers
  ],
)''';

      case ExperienceStyle.pullDisclosure:
        return '''
import 'package:app_bar_ui/app_bar_ui.dart';

SliverToBoxAdapter(
  child: PullDownDisclosureCanvasHeaderWidget(
    restingHeaderContent: const Text('Resting Bar Content'),
    disclosureCanvasContent: const Text('Disclosed Utility Controls'),
    config: PullDownDisclosureCanvasConfig(
      disclosureCanvasHeight: $_disclosureCanvasHeight,
      restingHeight: $_disclosureRestingHeight,
    ),
  ),
)''';

      case ExperienceStyle.tabTransform:
        return '''
import 'package:app_bar_ui/app_bar_ui.dart';

CustomScrollView(
  slivers: [
    TabTransformHeaderWidget(
      title: const Text('Engineering Portal'),
      tabs: const [
        TabTransformItem(label: 'Architecture', icon: Icons.architecture),
        TabTransformItem(label: 'AI Models', icon: Icons.psychology, badge: 'v2'),
      ],
      selectedIndex: 0,
      onTabSelected: (index) {},
      config: TabTransformConfig(
        expandedHeight: $_tabExpandedHeight,
        compactTabHeight: $_tabCompactHeight,
      ),
    ),
    // ... list slivers
  ],
)''';

      case ExperienceStyle.avatarToProfile:
        return '''
import 'package:app_bar_ui/app_bar_ui.dart';

CustomScrollView(
  slivers: [
    AvatarToProfileHeaderWidget(
      avatar: const CircleAvatar(radius: 38.0, child: Icon(Icons.person)),
      name: const Text('Dr. Evelyn Cross'),
      handle: const Text('@evelyn_cross'),
      bio: const Text('Principal Neural Systems Engineer'),
      leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () {}),
      config: AvatarToProfileConfig(
        initialAvatarDiameter: $_avatarInitialDiameter,
        compactAvatarDiameter: $_avatarCompactDiameter,
        arcControlPointBias: $_avatarArcBias,
      ),
    ),
    // ... list slivers
  ],
)''';

      case ExperienceStyle.progressiveDisclosure:
        return '''
import 'package:app_bar_ui/app_bar_ui.dart';

CustomScrollView(
  slivers: [
    ProgressiveDisclosureHeaderWidget(
      title: const Text('Market Discovery'),
      searchBar: const TextField(decoration: InputDecoration(hintText: 'Search...')),
      filterRow: const Row(children: [Chip(label: Text('All')), Chip(label: Text('Verified'))]),
      config: ProgressiveDisclosureConfig(
        stage1Threshold: $_progressiveStage1,
        stage2Threshold: $_progressiveStage2,
      ),
    ),
    // ... list slivers
  ],
)''';

      case ExperienceStyle.sidewaysCollapse:
        return '''
import 'package:app_bar_ui/app_bar_ui.dart';

CustomScrollView(
  slivers: [
    SidewaysCollapseHeaderWidget(
      expandedContent: const Text('Global Workspace Hub (Full Width)'),
      compactRailContent: const Row(children: [Icon(Icons.hub), Text('Hub')]),
      config: SidewaysCollapseConfig(
        compactRailWidth: $_sidewaysCompactWidth,
        collapseThreshold: $_sidewaysCollapseThreshold,
      ),
    ),
    // ... list slivers
  ],
)''';

      case ExperienceStyle.expandingSearch:
        return '''
import 'package:app_bar_ui/app_bar_ui.dart';

CustomScrollView(
  slivers: [
    ExpandingSearchHeaderWidget(
      title: const Text('Global Catalog Hub'),
      subtitle: const Text('Search among 40,000 components'),
      hintText: 'Search...',
      config: ExpandingSearchConfig(
        expandThreshold: $_expandingSearchThreshold,
      ),
    ),
    // ... list slivers
  ],
)''';
    }
  }
}
