import 'package:flutter/material.dart';

/// Centralized theme definitions for the `app_bar_ui` Interactive Showcase App.
class AppTheme {
  const AppTheme._();

  static const Color primarySeed = Color(0xFF4F46E5); // Indigo 600
  static const Color secondarySeed = Color(0xFF06B6D4); // Cyan 500
  static const Color accentSeed = Color(0xFF10B981); // Emerald 500

  /// Crisp, clean Material 3 light theme.
  static ThemeData get lightTheme {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: primarySeed,
      brightness: Brightness.light,
      surface: const Color(0xFFF8FAFC),
      surfaceContainerLowest: Colors.white,
      surfaceContainerLow: const Color(0xFFF1F5F9),
      surfaceContainer: const Color(0xFFE2E8F0),
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: colorScheme.surface,
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14.0),
          side: BorderSide(
            color: colorScheme.outlineVariant.withValues(alpha: 0.5),
            width: 1.0,
          ),
        ),
      ),
      chipTheme: ChipThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        elevation: 2.0,
        indicatorColor: colorScheme.primaryContainer,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      ),
    );
  }

  /// Refined, high-contrast dark theme.
  static ThemeData get darkTheme {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: primarySeed,
      brightness: Brightness.dark,
      surface: const Color(0xFF0F172A), // Slate 900
      surfaceContainerLowest: const Color(0xFF020617), // Slate 950
      surfaceContainerLow: const Color(0xFF1E293B), // Slate 800
      surfaceContainer: const Color(0xFF334155), // Slate 700
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: colorScheme.surface,
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14.0),
          side: BorderSide(
            color: colorScheme.outlineVariant.withValues(alpha: 0.4),
            width: 1.0,
          ),
        ),
      ),
      chipTheme: ChipThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        elevation: 2.0,
        indicatorColor: colorScheme.primaryContainer,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      ),
    );
  }
}
