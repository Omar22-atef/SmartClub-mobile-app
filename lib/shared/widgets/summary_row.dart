import 'package:flutter/material.dart';

import '../../core/constants/app_constants.dart';

/// A "label ........ value" row used in summaries and receipts.
class SummaryRow extends StatelessWidget {
  const SummaryRow({
    super.key,
    required this.label,
    required this.value,
    this.bold = false,
    this.valueColor,
  });

  final String label;
  final String value;
  final bool bold;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.spaceXs),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textMuted,
            ),
          ),
          const SizedBox(width: AppSpacing.spaceMd),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: bold
                  ? AppTextStyles.labelLarge.copyWith(
                      color: valueColor ?? AppColors.midnightBlack,
                    )
                  : AppTextStyles.bodyMedium.copyWith(
                      color: valueColor ?? AppColors.onSurface,
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
