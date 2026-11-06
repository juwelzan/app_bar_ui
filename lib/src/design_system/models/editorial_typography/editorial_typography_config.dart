import 'package:flutter/material.dart';
import '../../app_bar_model_configuration.dart';

/// Strongly-typed configuration for Model 9: Dynamic Editorial Typography Navigation.
///
/// Embodies a high-end editorial and publication aesthetic with dynamic headline
/// tracking, responsive typography scaling, metadata masthead, and integrated reading
/// progress indicator.
class EditorialTypographyConfig extends AppBarModelConfiguration {
  /// Creates an [EditorialTypographyConfig].
  const EditorialTypographyConfig({
    this.headline = 'The Architecture of Thought',
    this.editionNumber = 'Volume IV • Issue 12',
    this.publicationDate = 'November 2026',
    this.category = 'Systems Engineering',
    this.expandedFontSize = 38.0,
    this.collapsedFontSize = 17.0,
    this.expandedHeight = 220.0,
    this.collapsedHeight = 60.0,
    this.showReadingProgressBar = true,
    this.serifFont = true,
    this.accentColor,
    super.safeArea = true,
    super.backgroundColor,
    super.surfaceTint,
    super.physics,
    super.elevation = 1.0,
  });

  /// Primary publication headline.
  final String headline;

  /// Edition or issue identifier tag.
  final String editionNumber;

  /// Date string for the editorial issue.
  final String publicationDate;

  /// Topical publication section or category.
  final String category;

  /// Font size of the headline at rest in expanded state.
  final double expandedFontSize;

  /// Font size of the masthead headline when collapsed into pinned state.
  final double collapsedFontSize;

  /// Total expanded height.
  final double expandedHeight;

  /// Collapsed height of the pinned masthead.
  final double collapsedHeight;

  /// Whether to render a continuous scroll progress reading bar at the bottom edge.
  final bool showReadingProgressBar;

  /// Whether to format the headline in an elegant serif typeface.
  final bool serifFont;

  /// Optional custom accent color for the reading bar and category pill.
  final Color? accentColor;
}

