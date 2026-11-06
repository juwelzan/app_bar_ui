import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:app_bar_ui/app_bar_ui.dart';

enum DevicePreset {
  smallMobile('Small Mobile', Size(320, 568), Icons.phone_android, EdgeInsets.only(top: 24.0, bottom: 16.0)),
  standardMobile('Standard Mobile', Size(375, 812), Icons.smartphone, EdgeInsets.only(top: 44.0, bottom: 34.0)),
  largeMobile('Large Mobile', Size(414, 896), Icons.phone_iphone, EdgeInsets.only(top: 48.0, bottom: 34.0)),
  tablet('Tablet', Size(768, 1024), Icons.tablet_mac, EdgeInsets.only(top: 24.0, bottom: 20.0)),
  desktop('Desktop', Size(1024, 768), Icons.laptop_mac, EdgeInsets.only(top: 28.0)),
  ultrawide('Ultrawide', Size(1440, 900), Icons.desktop_windows, EdgeInsets.zero);

  const DevicePreset(this.label, this.size, this.icon, this.insets);
  final String label;
  final Size size;
  final IconData icon;
  final EdgeInsets insets;
}

enum SimulatedPlatform {
  android('Android (Edge-to-Edge)', Icons.android),
  ios('iOS (Dynamic Island)', Icons.apple),
  desktop('Desktop / Web Window', Icons.computer);

  const SimulatedPlatform(this.label, this.icon);
  final String label;
  final IconData icon;
}

/// The Responsive & Platform Lab screen allowing live constraint testing across devices and text scalers.
class ResponsivePlatformLabScreen extends StatefulWidget {
  const ResponsivePlatformLabScreen({
    super.key,
    this.initialModel = AppBarModel.floatingIsland,
  });

  final AppBarModel initialModel;

  @override
  State<ResponsivePlatformLabScreen> createState() => _ResponsivePlatformLabScreenState();
}

class _ResponsivePlatformLabScreenState extends State<ResponsivePlatformLabScreen> {
  late AppBarModel _selectedModel;
  DevicePreset _preset = DevicePreset.standardMobile;
  SimulatedPlatform _platform = SimulatedPlatform.ios;
  double _textScale = 1.0;
  bool _isLandscape = false;
  bool _showDeviceFrame = true;

  @override
  void initState() {
    super.initState();
    _selectedModel = widget.initialModel;
  }

  @override
  void didUpdateWidget(covariant ResponsivePlatformLabScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialModel != widget.initialModel) {
      setState(() => _selectedModel = widget.initialModel);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hostPlatform = kIsWeb ? 'Web' : defaultTargetPlatform.name.toUpperCase();

    // Calculate effective simulated dimensions based on orientation
    final baseWidth = _preset.size.width;
    final baseHeight = _preset.size.height;
    final targetWidth = _isLandscape ? baseHeight : baseWidth;
    final targetHeight = _isLandscape ? baseWidth : baseHeight;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Responsive & Platform Lab', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0)),
        actions: [
          IconButton(
            tooltip: _isLandscape ? 'Switch to Portrait' : 'Switch to Landscape',
            icon: Icon(_isLandscape ? Icons.screen_lock_landscape : Icons.screen_lock_portrait),
            onPressed: () => setState(() => _isLandscape = !_isLandscape),
          ),
          IconButton(
            tooltip: _showDeviceFrame ? 'Hide Bezel Frame' : 'Show Bezel Frame',
            icon: Icon(_showDeviceFrame ? Icons.phone_android : Icons.crop_free),
            onPressed: () => setState(() => _showDeviceFrame = !_showDeviceFrame),
          ),
          const SizedBox(width: 8.0),
        ],
      ),
      body: Column(
        children: [
          // Top Control Toolbar: Model, Device Preset, Platform, & Text Scaler
          _buildControlsToolbar(theme, hostPlatform),

          // Main Viewport Canvas Container
          Expanded(
            child: Container(
              color: theme.colorScheme.surfaceContainerLowest,
              child: Center(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: _buildDeviceViewport(theme, targetWidth, targetHeight),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildControlsToolbar(ThemeData theme, String hostPlatform) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
      color: theme.colorScheme.surface,
      child: Column(
        children: [
          // Row 1: Model Dropdown & Device Preset Chips
          Row(
            children: [
              // Model Dropdown
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: DropdownButton<AppBarModel>(
                  value: _selectedModel,
                  underline: const SizedBox.shrink(),
                  items: AppBarModel.values.map((m) {
                    return DropdownMenuItem(value: m, child: Text(m.displayName, style: const TextStyle(fontSize: 12.0)));
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) setState(() => _selectedModel = val);
                  },
                ),
              ),
              const SizedBox(width: 12.0),

              // Device Preset selector
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: DevicePreset.values.map((p) {
                      final isSelected = _preset == p;
                      return Padding(
                        padding: const EdgeInsets.only(right: 6.0),
                        child: ChoiceChip(
                          avatar: Icon(p.icon, size: 14.0),
                          label: Text(p.label, style: const TextStyle(fontSize: 11.0)),
                          selected: isSelected,
                          onSelected: (selected) {
                            if (selected) setState(() => _preset = p);
                          },
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8.0),

          // Row 2: Text Scaler Slider, Platform Selector & Telemetry Information
          LayoutBuilder(
            builder: (context, constraints) {
              final isNarrow = constraints.maxWidth < 600.0;
              if (isNarrow) {
                return Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: DropdownButton<SimulatedPlatform>(
                            value: _platform,
                            underline: const SizedBox.shrink(),
                            items: SimulatedPlatform.values.map((sp) {
                              return DropdownMenuItem(value: sp, child: Text(sp.label, style: const TextStyle(fontSize: 11.5)));
                            }).toList(),
                            onChanged: (val) {
                              if (val != null) setState(() => _platform = val);
                            },
                          ),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 3.0),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(6.0),
                          ),
                          child: Text(
                            'Host: $hostPlatform (Verified)',
                            style: TextStyle(
                              fontSize: 10.5,
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6.0),
                    Row(
                      children: [
                        Text('Scale: ${_textScale.toStringAsFixed(1)}x', style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold)),
                        Expanded(
                          child: Slider(
                            value: _textScale,
                            min: 0.8,
                            max: 2.0,
                            divisions: 6,
                            onChanged: (val) => setState(() => _textScale = val),
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              }
              return Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: DropdownButton<SimulatedPlatform>(
                      value: _platform,
                      underline: const SizedBox.shrink(),
                      items: SimulatedPlatform.values.map((sp) {
                        return DropdownMenuItem(value: sp, child: Text(sp.label, style: const TextStyle(fontSize: 11.5)));
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) setState(() => _platform = val);
                      },
                    ),
                  ),
                  const SizedBox(width: 10.0),
                  Text('Scale: ${_textScale.toStringAsFixed(1)}x', style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold)),
                  Expanded(
                    child: Slider(
                      value: _textScale,
                      min: 0.8,
                      max: 2.0,
                      divisions: 6,
                      onChanged: (val) => setState(() => _textScale = val),
                    ),
                  ),
                  const SizedBox(width: 10.0),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 3.0),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(6.0),
                    ),
                    child: Text(
                      'Host: $hostPlatform (Verified)',
                      style: TextStyle(
                        fontSize: 10.5,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDeviceViewport(ThemeData theme, double targetWidth, double targetHeight) {
    final effectiveInsets = _platform == SimulatedPlatform.android
        ? const EdgeInsets.only(top: 28.0, bottom: 24.0)
        : _platform == SimulatedPlatform.ios
            ? _preset.insets
            : EdgeInsets.zero;

    final innerAppContent = MediaQuery(
      data: MediaQueryData(
        size: Size(targetWidth, targetHeight),
        padding: effectiveInsets,
        textScaler: TextScaler.linear(_textScale),
      ),
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            AppBarEngine.sliver(
              key: ValueKey('lab_${_selectedModel}_${_preset.name}_$_textScale'),
              model: _selectedModel,
              title: '${_selectedModel.displayName} on ${_preset.label}',
              subtitle: 'Simulated Viewport: ${targetWidth.toInt()}×${targetHeight.toInt()} pt',
              leading: const Icon(Icons.arrow_back),
              actions: [
                IconButton(icon: const Icon(Icons.search), onPressed: () {}),
                IconButton(icon: const Icon(Icons.tune), onPressed: () {}),
              ],
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12.0),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primaryContainer.withValues(alpha: 0.4),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.verified, size: 16.0, color: Color(0xFF10B981)),
                              const SizedBox(width: 6.0),
                              Expanded(
                                child: Text(
                                  'Responsive Constraint Diagnostics',
                                  style: theme.textTheme.labelMedium!.copyWith(fontWeight: FontWeight.bold),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6.0),
                          Text(
                            'Width: ${targetWidth.toInt()}px • Height: ${targetHeight.toInt()}px • TextScaler: ${_textScale.toStringAsFixed(1)}x',
                            style: const TextStyle(fontSize: 11.0),
                          ),
                          Text(
                            'Category: ${AppBarScreenCategory.fromWidth(targetWidth).name.toUpperCase()}',
                            style: const TextStyle(fontSize: 11.0, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4.0),
                          const Text(
                            'No RenderFlex overflow detected under current constraints.',
                            style: TextStyle(fontSize: 10.5, color: Color(0xFF10B981), fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    ...List.generate(15, (index) {
                      return Card(
                        margin: const EdgeInsets.only(bottom: 8.0),
                        child: ListTile(
                          leading: CircleAvatar(child: Text('${index + 1}')),
                          title: Text('Scrollable Content #${index + 1}'),
                          subtitle: Text('Testing scroll transition for ${_selectedModel.displayName}'),
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );

    if (!_showDeviceFrame) {
      return Container(
        width: targetWidth,
        height: targetHeight,
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 20.0,
              spreadRadius: 2.0,
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: innerAppContent,
      );
    }

    // Cosmetic outer bezel frame
    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B), // Dark chassis
        borderRadius: BorderRadius.circular(32.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.25),
            blurRadius: 30.0,
            spreadRadius: 4.0,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Speaker / punch-hole cutout indicator
          Container(
            width: 70.0,
            height: 5.0,
            margin: const EdgeInsets.only(bottom: 8.0),
            decoration: BoxDecoration(
              color: const Color(0xFF334155),
              borderRadius: BorderRadius.circular(3.0),
            ),
          ),

          // Inner Screen
          Container(
            width: targetWidth,
            height: targetHeight,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(22.0),
            ),
            child: innerAppContent,
          ),
        ],
      ),
    );
  }
}
