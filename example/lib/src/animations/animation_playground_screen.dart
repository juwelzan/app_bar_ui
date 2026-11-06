import 'package:flutter/material.dart';
import 'package:app_bar_ui/app_bar_ui.dart';

/// Animation Playground allowing developers to scrub progress and test transition physics.
class AnimationPlaygroundScreen extends StatefulWidget {
  const AnimationPlaygroundScreen({super.key});

  @override
  State<AnimationPlaygroundScreen> createState() => _AnimationPlaygroundScreenState();
}

class _AnimationPlaygroundScreenState extends State<AnimationPlaygroundScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  AppBarModel _model = AppBarModel.floatingIsland;
  ModelTransitionType _transitionType = ModelTransitionType.fade;
  Curve _selectedCurve = Curves.easeInOutCubic;
  double _manualProgress = 0.0;
  bool _isManualScrubbing = false;

  final Map<String, Curve> _availableCurves = {
    'Ease In Out Cubic': Curves.easeInOutCubic,
    'Fast Out Slow In': Curves.fastOutSlowIn,
    'Elastic Out': Curves.elasticOut,
    'Bounce Out': Curves.bounceOut,
    'Decelerate': Curves.decelerate,
    'Linear': Curves.linear,
  };

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..addListener(() {
        if (!_isManualScrubbing) {
          setState(() {
            _manualProgress = _animController.value;
          });
        }
      });
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _onPlay() {
    _isManualScrubbing = false;
    _animController.forward(from: _manualProgress);
  }

  void _onReverse() {
    _isManualScrubbing = false;
    _animController.reverse(from: _manualProgress);
  }

  void _onReset() {
    _isManualScrubbing = false;
    _animController.reset();
    setState(() => _manualProgress = 0.0);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.sizeOf(context);
    final isCompact = size.width < 768.0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Animation Playground', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0)),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: isCompact ? 16.0 : 32.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Intro Card ---
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer.withValues(alpha: 0.35),
                borderRadius: BorderRadius.circular(14.0),
                border: Border.all(color: theme.colorScheme.primary.withValues(alpha: 0.2)),
              ),
              child: Row(
                children: [
                  Icon(Icons.animation, size: 28.0, color: theme.colorScheme.primary),
                  const SizedBox(width: 14.0),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Frame-by-Frame Motion Diagnostics',
                          style: theme.textTheme.titleSmall!.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4.0),
                        Text(
                          'Scrub progress from 0.0 (fully expanded) to 1.0 (fully collapsed) to inspect intermediate geometry.',
                          style: theme.textTheme.bodySmall!.copyWith(color: theme.colorScheme.onSurfaceVariant),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20.0),

            // --- Interactive Motion Scrubber Card ---
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.tune, size: 18.0),
                        const SizedBox(width: 8.0),
                        Expanded(
                          child: Text(
                            'Scrub Progress: ${(_manualProgress * 100).toStringAsFixed(1)}%',
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8.0),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 3.0),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(6.0),
                          ),
                          child: Text(
                            _manualProgress < 0.2
                                ? 'EXPANDED'
                                : _manualProgress > 0.8
                                    ? 'COLLAPSED'
                                    : 'INTERMEDIATE',
                            style: TextStyle(
                              fontSize: 10.0,
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12.0),
                    Slider(
                      value: _manualProgress,
                      min: 0.0,
                      max: 1.0,
                      divisions: 100,
                      onChanged: (val) {
                        setState(() {
                          _isManualScrubbing = true;
                          _manualProgress = val;
                          _animController.value = val;
                        });
                      },
                    ),
                    const SizedBox(height: 8.0),
                    // Transport playback controls
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton.filledTonal(
                          tooltip: 'Reverse Transition',
                          icon: const Icon(Icons.fast_rewind),
                          onPressed: _onReverse,
                        ),
                        const SizedBox(width: 12.0),
                        IconButton.filled(
                          tooltip: 'Play Forward',
                          icon: const Icon(Icons.play_arrow),
                          onPressed: _onPlay,
                        ),
                        const SizedBox(width: 12.0),
                        IconButton.filledTonal(
                          tooltip: 'Reset to Expanded',
                          icon: const Icon(Icons.replay),
                          onPressed: _onReset,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20.0),

            // --- Configuration Controls: Model, Curve, Duration ---
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Motion Parameters', style: theme.textTheme.titleSmall),
                    const SizedBox(height: 14.0),

                    // Model Picker
                    Row(
                      children: [
                        const Text('Target Model: ', style: TextStyle(fontWeight: FontWeight.w600)),
                        const SizedBox(width: 8.0),
                        Expanded(
                          child: DropdownButton<AppBarModel>(
                            isExpanded: true,
                            value: _model,
                            underline: const SizedBox.shrink(),
                            items: AppBarModel.values.map((m) {
                              return DropdownMenuItem(
                                value: m,
                                child: Text(
                                  m.displayName,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(fontSize: 13.0),
                                ),
                              );
                            }).toList(),
                            onChanged: (val) {
                              if (val != null) setState(() => _model = val);
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12.0),

                    // Curve Picker
                    Row(
                      children: [
                        const Text('Physics Curve: ', style: TextStyle(fontWeight: FontWeight.w600)),
                        const SizedBox(width: 8.0),
                        Expanded(
                          child: DropdownButton<Curve>(
                            isExpanded: true,
                            value: _selectedCurve,
                            underline: const SizedBox.shrink(),
                            items: _availableCurves.entries.map((entry) {
                              return DropdownMenuItem(
                                value: entry.value,
                                child: Text(
                                  entry.key,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(fontSize: 13.0),
                                ),
                              );
                            }).toList(),
                            onChanged: (val) {
                              if (val != null) setState(() => _selectedCurve = val);
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12.0),

                    // Model Transition Spec Picker
                    Row(
                      children: [
                        const Text('Transition Type: ', style: TextStyle(fontWeight: FontWeight.w600)),
                        const SizedBox(width: 8.0),
                        Expanded(
                          child: DropdownButton<ModelTransitionType>(
                            isExpanded: true,
                            value: _transitionType,
                            underline: const SizedBox.shrink(),
                            items: ModelTransitionType.values.map((t) {
                              return DropdownMenuItem(
                                value: t,
                                child: Text(
                                  t.name.toUpperCase(),
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(fontSize: 13.0),
                                ),
                              );
                            }).toList(),
                            onChanged: (val) {
                              if (val != null) setState(() => _transitionType = val);
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20.0),

            // --- Live Frozen Frame Preview Canvas ---
            Text('Simulated Scroll Header at ${_manualProgress.toStringAsFixed(2)} Offset', style: theme.textTheme.titleSmall),
            const SizedBox(height: 10.0),
            Container(
              height: 260.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.0),
                border: Border.all(color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5)),
              ),
              clipBehavior: Clip.antiAlias,
              child: Scaffold(
                body: CustomScrollView(
                  controller: ScrollController(
                    initialScrollOffset: _manualProgress * 200.0,
                  ),
                  slivers: [
                    AppBarEngine.sliver(
                      key: ValueKey('anim_preview_${_model.name}_$_manualProgress'),
                      model: _model,
                      title: '${_model.displayName} Progress ${_manualProgress.toStringAsFixed(2)}',
                      subtitle: 'Interpolating geometry frame at ${(_manualProgress * 100).toInt()}%',
                      leading: const Icon(Icons.arrow_back),
                      actions: const [
                        Icon(Icons.tune),
                      ],
                    ),
                    SliverToBoxAdapter(
                      child: Container(
                        height: 500.0,
                        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.2),
                        child: const Center(
                          child: Text('Simulated content viewport for scrubbed header physics'),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 40.0),
          ],
        ),
      ),
    );
  }
}
