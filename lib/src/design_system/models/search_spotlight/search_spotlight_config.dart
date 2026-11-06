import 'package:flutter/material.dart';
import '../../app_bar_model_configuration.dart';

/// Strongly-typed configuration for Model 15: Search Spotlight First Navigation.
///
/// Embodies a search-first user journey. At rest, renders an expansive search input
/// canvas with suggested query pills and category filter chips. On scroll, morphs
/// into a compact inline query bar with quick search icon and clear actions.
class SearchSpotlightConfig extends AppBarModelConfiguration {
  /// Creates a [SearchSpotlightConfig].
  const SearchSpotlightConfig({
    this.searchPrompt = 'Search repositories, commits, and packages...',
    this.initialQuery = '',
    this.suggestedPills = const ['Flutter', 'Engine', 'Sliver', 'Accessibility'],
    this.filterChips = const ['All', 'Repositories', 'Topics', 'Issues'],
    this.selectedFilterIndex = 0,
    this.expandedHeight = 180.0,
    this.collapsedHeight = 60.0,
    this.onQueryChanged,
    this.onSubmitted,
    this.onFilterSelected,
    super.safeArea = true,
    super.backgroundColor,
    super.surfaceTint,
    super.physics,
    super.elevation = 2.0,
  });

  /// Placeholder prompt text inside the search bar.
  final String searchPrompt;

  /// Initial or current query string.
  final String initialQuery;

  /// Quick suggestion pills shown below search bar.
  final List<String> suggestedPills;

  /// Category filter chips.
  final List<String> filterChips;

  /// Currently selected filter chip index.
  final int selectedFilterIndex;

  /// Total expanded height.
  final double expandedHeight;

  /// Collapsed pinned toolbar height.
  final double collapsedHeight;

  /// Callback when query changes.
  final ValueChanged<String>? onQueryChanged;

  /// Callback when search is submitted.
  final ValueChanged<String>? onSubmitted;

  /// Callback when a filter chip is tapped.
  final ValueChanged<int>? onFilterSelected;
}

