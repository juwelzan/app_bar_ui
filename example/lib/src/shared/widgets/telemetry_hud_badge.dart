import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:app_bar_ui/app_bar_ui.dart';

/// Reusable responsive telemetry badge component.
class TelemetryHudBadge extends StatelessWidget {
  const TelemetryHudBadge({
    super.key,
    this.compact = false,
  });

  final bool compact;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final category = AppBarScreenCategory.of(context);
    final size = MediaQuery.sizeOf(context);
    final textScale = MediaQuery.textScalerOf(context).scale(1.0);
    final platformName = kIsWeb ? 'Web' : defaultTargetPlatform.name.toUpperCase();

    if (compact) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.6),
          borderRadius: BorderRadius.circular(20.0),
          border: Border.all(
            color: theme.colorScheme.outlineVariant.withValues(alpha: 0.4),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 7.0,
              height: 7.0,
              decoration: const BoxDecoration(
                color: Color(0xFF10B981), // Emerald green
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 6.0),
            Text(
              '${category.name.toUpperCase()} • ${size.width.toInt()}px',
              style: TextStyle(
                fontSize: 11.0,
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.4),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              const Icon(Icons.speed, size: 16.0, color: Color(0xFF10B981)),
              const SizedBox(width: 6.0),
              Text(
                'Universal Engine Telemetry',
                style: theme.textTheme.labelMedium!.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 2.0),
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(6.0),
                ),
                child: const Text(
                  'HEALTHY',
                  style: TextStyle(
                    fontSize: 9.5,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF10B981),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8.0),
          Wrap(
            spacing: 12.0,
            runSpacing: 4.0,
            children: [
              _buildMetricChip(theme, 'Category', category.name),
              _buildMetricChip(theme, 'Viewport', '${size.width.toInt()} × ${size.height.toInt()} pt'),
              _buildMetricChip(theme, 'Text Scale', '${textScale.toStringAsFixed(1)}x'),
              _buildMetricChip(theme, 'Platform', platformName),
              _buildMetricChip(theme, 'Optical Slot', 'Active'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetricChip(ThemeData theme, String label, String value) {
    return RichText(
      text: TextSpan(
        style: TextStyle(fontSize: 11.0, color: theme.colorScheme.onSurfaceVariant),
        children: [
          TextSpan(text: '$label: '),
          TextSpan(
            text: value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}

