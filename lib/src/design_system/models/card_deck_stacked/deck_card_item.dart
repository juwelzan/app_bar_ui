import 'package:flutter/material.dart';

/// Individual physical card item in [CardDeckStackedConfig].
class DeckCardItem {
  /// Creates a [DeckCardItem].
  const DeckCardItem({
    required this.title,
    this.subtitle,
    this.icon,
    this.backgroundColor,
    this.foregroundColor,
    this.badge,
    this.onTap,
  });

  /// Primary headline for this card.
  final String title;

  /// Secondary descriptive text.
  final String? subtitle;

  /// Optional icon.
  final IconData? icon;

  /// Custom background card color.
  final Color? backgroundColor;

  /// Custom text and icon color.
  final Color? foregroundColor;

  /// Optional badge pill string (e.g. 'Active', 'Priority').
  final String? badge;

  /// Optional tap callback.
  final VoidCallback? onTap;
}

