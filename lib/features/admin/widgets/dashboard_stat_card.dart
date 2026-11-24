import 'package:flutter/material.dart';

import '../../../core/constants/app_constants.dart';

/// KPI card for the admin dashboard.
/// Light version: white card. Dark version ([dark] = true): Midnight Black
/// card with lime text, used for the highlighted metric (e.g. total payments).
class DashboardStatCard extends StatelessWidget {
  const DashboardStatCard({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    this.caption,
    this.captionIcon,
    this.dark = false,
    this.onTap,
  });

  final String label;
  final String value;
  final IconData icon;
  final String? caption;
  final IconData? captionIcon;
  final bool dark;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final Color background = dark ? AppColors.midnightBlack : AppColors.pureWhite;
    final Color labelColor = dark ? AppColors.textMuted : AppColors.onSurfaceVariant;
    final Color valueColor = dark ? AppColors.limeNeon : AppColors.midnightBlack;
    final Color captionColor = dark ? AppColors.limeNeon : AppColors.secondary;
    final Color iconBoxColor = dark ? AppColors.elevatedDark : AppColors.surfaceContainer;
    final Color iconColor = dark ? AppColors.limeNeon : AppColors.midnightBlack;

    return Material(
      color: background,
      borderRadius: BorderRadius.circular(12),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Stack(
          children: [
            // Soft lime glow in the corner of the dark card
            if (dark)
              Positioned(
                right: -20,
                top: -20,
                child: Container(
                  width: 72,
                  height: 72,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.limeGlow,
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          label,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: labelColor,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: iconBoxColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(icon, size: 18, color: iconColor),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        value,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.5,
                          color: valueColor,
                        ),
                      ),
                      if (caption != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Row(
                            children: [
                              if (captionIcon != null) ...[
                                Icon(captionIcon, size: 14, color: captionColor),
                                const SizedBox(width: 3),
                              ],
                              Flexible(
                                child: Text(
                                  caption!,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: captionColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
