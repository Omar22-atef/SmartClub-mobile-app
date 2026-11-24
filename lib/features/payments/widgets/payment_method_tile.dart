import 'package:flutter/material.dart';

import '../../../core/constants/app_constants.dart';
import '../models/payment_model.dart';

/// Selectable payment method row (card / mobile wallet).
class PaymentMethodTile extends StatelessWidget {
  const PaymentMethodTile({
    super.key,
    required this.method,
    required this.subtitle,
    required this.isSelected,
    required this.onTap,
  });

  final PaymentMethod method;
  final String subtitle;
  final bool isSelected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(AppSpacing.cardPadding),
        decoration: BoxDecoration(
          color: AppColors.pureWhite,
          borderRadius: AppRadius.large,
          border: Border.all(
            color: isSelected ? AppColors.midnightBlack : AppColors.borderLight,
            width: isSelected ? 1.5 : 1,
          ),
          boxShadow: isSelected ? AppEffects.limeActiveGlow : null,
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.midnightBlack
                    : AppColors.surfaceContainerHigh,
                borderRadius: AppRadius.medium,
              ),
              child: Icon(
                method.icon,
                color: isSelected
                    ? AppColors.limeNeon
                    : AppColors.onSurfaceVariant,
              ),
            ),
            const SizedBox(width: AppSpacing.itemSpacing),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    method.label,
                    style: AppTextStyles.labelLarge.copyWith(
                      color: AppColors.onSurface,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: AppTextStyles.labelMedium.copyWith(
                      color: AppColors.textMuted,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              isSelected
                  ? Icons.radio_button_checked
                  : Icons.radio_button_unchecked,
              color: isSelected
                  ? AppColors.midnightBlack
                  : AppColors.outlineVariant,
            ),
          ],
        ),
      ),
    );
  }
}
