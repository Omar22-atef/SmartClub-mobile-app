import 'package:flutter/material.dart';

import '../../core/constants/app_constants.dart';

/// Small rounded status label, e.g. "Active", "Refunded", "Renewal".
class StatusPill extends StatelessWidget {
  const StatusPill({
    super.key,
    required this.label,
    required this.color,
    this.backgroundColor,
    this.showDot = false,
  });

  final String label;
  final Color color;

  /// Defaults to [color] at 10% opacity.
  final Color? backgroundColor;
  final bool showDot;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppDimensions.statusPillHeight,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.spaceSm),
      decoration: BoxDecoration(
        color: backgroundColor ?? color.withValues(alpha: 0.1),
        borderRadius: AppRadius.pill,
      ),
      alignment: Alignment.center,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showDot) ...[
            Container(
              width: AppDimensions.statusDotSize,
              height: AppDimensions.statusDotSize,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
            const SizedBox(width: 6),
          ],
          Text(label, style: AppTextStyles.labelMedium.copyWith(color: color)),
        ],
      ),
    );
  }
}
