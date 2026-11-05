import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:app_bar_ui/app_bar_ui.dart';

/// Interactive laboratory showcasing the 50 genuinely different animated
/// AppBar experiences, beginning with Batch 1 (Styles 1–5).
class AnimatedExperiencesLabTab extends StatefulWidget {
  const AnimatedExperiencesLabTab({super.key});

  @override
  State<AnimatedExperiencesLabTab> createState() =>
      _AnimatedExperiencesLabTabState();
}

enum ExperienceStyle {
  morphingSplit(
    id: 1,
    title: 'Morphing Split',
    description:
        'Counter-directional divergence with centered pill consolidation',
    icon: Icons.call_split,
  ),
  elasticFloating(
    id: 2,
    title: 'Elastic Floating',
    description:
        'Overscroll spring resistance settling into floating capsule',
    icon: Icons.waves,
  ),
  disappearingActions(
    id: 3,
    title: 'Disappearing & Floating Actions',
    description:
        'Header scrolls away into content leaving detached action pills',
    icon: Icons.widgets_outlined,
  ),
  circularMorph(
    id: 4,
    title: 'Circular Morph',
    description:
        'Full-bleed rectangular header morphs into circular corner avatar',
    icon: Icons.account_circle_outlined,
  ),
  flip3D(
    id: 5,
    title: 'Flip 3D Header',
    description:
        '180° perspective projection flipping card to compact toolbar',
    icon: Icons.flip_camera_android_outlined,
  );

  const ExperienceStyle({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
  });

  final int id;
  final String title;
  final String description;
  final IconData icon;
}

class _AnimatedExperiencesLabTabState extends State<AnimatedExperiencesLabTab> {
  ExperienceStyle _selectedStyle = ExperienceStyle.morphingSplit;
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
            Card(
              color: theme.colorScheme.surfaceContainerHighest,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: [
                    const Icon(Icons.science, color: Colors.indigoAccent),
                    const SizedBox(width: 10.0),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Batch 1 / 10: Morphing & Physics (Styles 1–5)',
                            style: theme.textTheme.labelLarge!.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Genuinely different visual identity, layout structure & motion physics.',
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
              ),
            ),
            const SizedBox(height: 12.0),
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
                children: ExperienceStyle.values.map((style) {
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
// 1. Import the package
import 'package:app_bar_ui/app_bar_ui.dart';

// 2. Insert into CustomScrollView slivers:
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
// 1. Import the package
import 'package:app_bar_ui/app_bar_ui.dart';

// 2. Insert into your widget tree:
NotificationListener<ScrollNotification>(
  onNotification: (notification) {
    // Forward scroll metrics to ElasticFloatingHeaderWidget key
    return false;
  },
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
// 1. Import the package
import 'package:app_bar_ui/app_bar_ui.dart';

// 2. Insert into CustomScrollView slivers:
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
// 1. Import the package
import 'package:app_bar_ui/app_bar_ui.dart';

// 2. Insert into CustomScrollView slivers:
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
// 1. Import the package
import 'package:app_bar_ui/app_bar_ui.dart';

// 2. Insert into CustomScrollView slivers:
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
    }
  }
}
