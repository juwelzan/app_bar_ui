import 'package:flutter/material.dart';
import 'package:app_bar_ui/app_bar_ui.dart';
import '../shared/model_meta.dart';

/// Interactive visual catalog of all 21 autonomous AppBar models.
class ModelGalleryScreen extends StatefulWidget {
  const ModelGalleryScreen({
    super.key,
    required this.onSelectModelInStudio,
    required this.onSelectModelInLab,
  });

  final ValueChanged<AppBarModel> onSelectModelInStudio;
  final ValueChanged<AppBarModel> onSelectModelInLab;

  @override
  State<ModelGalleryScreen> createState() => _ModelGalleryScreenState();
}

class _ModelGalleryScreenState extends State<ModelGalleryScreen> {
  String _searchQuery = '';
  ModelCategory? _selectedCategory;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.sizeOf(context);
    final isCompact = size.width < 768.0;

    final filteredModels = ModelMetadata.all.where((meta) {
      if (_selectedCategory != null && meta.category != _selectedCategory) {
        return false;
      }
      if (_searchQuery.trim().isNotEmpty) {
        final q = _searchQuery.toLowerCase();
        final matchesName = meta.displayName.toLowerCase().contains(q);
        final matchesTag = meta.tagline.toLowerCase().contains(q);
        final matchesUseCase = meta.primaryUseCase.toLowerCase().contains(q);
        final matchesBehaviors = meta.supportedBehaviors.any((b) => b.toLowerCase().contains(q));
        if (!matchesName && !matchesTag && !matchesUseCase && !matchesBehaviors) {
          return false;
        }
      }
      return true;
    }).toList();

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 120.0,
            backgroundColor: theme.colorScheme.surface,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.only(left: 20.0, bottom: 16.0),
              title: Text(
                'Model Gallery (${filteredModels.length}/21)',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: isCompact ? 16.0 : 32.0,
                vertical: 12.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- Search Field ---
                  TextField(
                    onChanged: (val) => setState(() => _searchQuery = val),
                    decoration: InputDecoration(
                      hintText: 'Search by model name, behavior, or use case...',
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: _searchQuery.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () => setState(() => _searchQuery = ''),
                            )
                          : null,
                      filled: true,
                      fillColor: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12.0),

                  // --- Category Filter Chips ---
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        FilterChip(
                          label: const Text('All Categories (21)'),
                          selected: _selectedCategory == null,
                          onSelected: (selected) {
                            if (selected) setState(() => _selectedCategory = null);
                          },
                        ),
                        const SizedBox(width: 8.0),
                        ...ModelCategory.values.map((cat) {
                          final count = ModelMetadata.all.where((m) => m.category == cat).length;
                          final isSelected = _selectedCategory == cat;
                          return Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: FilterChip(
                              avatar: Icon(cat.icon, size: 14.0, color: isSelected ? theme.colorScheme.onPrimary : cat.color),
                              label: Text('${cat.label} ($count)'),
                              selected: isSelected,
                              selectedColor: cat.color.withValues(alpha: 0.8),
                              onSelected: (selected) {
                                setState(() => _selectedCategory = selected ? cat : null);
                              },
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16.0),
                ],
              ),
            ),
          ),

          // --- Model Grid ---
          SliverPadding(
            padding: EdgeInsets.symmetric(
              horizontal: isCompact ? 16.0 : 32.0,
              vertical: 8.0,
            ),
            sliver: SliverGrid(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: isCompact ? 1 : (size.width < 1200 ? 2 : 3),
                crossAxisSpacing: 16.0,
                mainAxisSpacing: 16.0,
                mainAxisExtent: 310.0,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final meta = filteredModels[index];
                  return _buildModelCard(theme, meta);
                },
                childCount: filteredModels.length,
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 40.0)),
        ],
      ),
    );
  }

  Widget _buildModelCard(ThemeData theme, ModelMetadata meta) {
    return Card(
      elevation: 0,
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Row: Model Index Badge & Category Tag
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                  decoration: BoxDecoration(
                    color: meta.category.color.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(6.0),
                    border: Border.all(color: meta.category.color.withValues(alpha: 0.3)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(meta.icon, size: 14.0, color: meta.category.color),
                      const SizedBox(width: 4.0),
                      Text(
                        meta.index == 0 ? 'M0' : 'M${meta.index}',
                        style: TextStyle(
                          fontSize: 11.0,
                          fontWeight: FontWeight.bold,
                          color: meta.category.color,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8.0),
                Expanded(
                  child: Text(
                    meta.category.label,
                    style: TextStyle(fontSize: 11.0, color: theme.colorScheme.onSurfaceVariant),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10.0),

            // Model Title
            Text(
              meta.displayName,
              style: theme.textTheme.titleMedium!.copyWith(
                fontWeight: FontWeight.bold,
                letterSpacing: -0.2,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4.0),

            // Tagline
            Text(
              meta.tagline,
              style: theme.textTheme.bodySmall!.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                height: 1.3,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 10.0),

            // Behavior & Motion Pills
            Wrap(
              spacing: 6.0,
              runSpacing: 4.0,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 2.0),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.secondaryContainer.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.animation, size: 11.0, color: theme.colorScheme.onSecondaryContainer),
                      const SizedBox(width: 3.0),
                      Flexible(
                        child: Text(
                          meta.motionStyle,
                          style: TextStyle(
                            fontSize: 9.5,
                            fontWeight: FontWeight.w600,
                            color: theme.colorScheme.onSecondaryContainer,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                ...meta.supportedBehaviors.map((b) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 2.0),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerLowest,
                      borderRadius: BorderRadius.circular(4.0),
                      border: Border.all(
                        color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
                      ),
                    ),
                    child: Text(
                      b,
                      style: TextStyle(fontSize: 10.0, color: theme.colorScheme.onSurface),
                    ),
                  );
                }),
              ],
            ),
            const Spacer(),

            // Actions row: Launch in Studio & Test in Lab
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => widget.onSelectModelInLab(meta.model),
                    icon: const Icon(Icons.devices, size: 14.0),
                    label: const Text('Lab View', style: TextStyle(fontSize: 11.5)),
                    style: OutlinedButton.styleFrom(visualDensity: VisualDensity.compact),
                  ),
                ),
                const SizedBox(width: 8.0),
                Expanded(
                  child: FilledButton.icon(
                    onPressed: () => widget.onSelectModelInStudio(meta.model),
                    icon: const Icon(Icons.play_arrow, size: 14.0),
                    label: const Text('Live Studio', style: TextStyle(fontSize: 11.5)),
                    style: FilledButton.styleFrom(visualDensity: VisualDensity.compact),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
