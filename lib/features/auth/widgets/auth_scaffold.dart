import 'package:flutter/material.dart';

import '../../../core/constants/app_constants.dart';

/// Shared layout for auth screens:
/// dark brand header + light rounded form sheet.
class AuthScaffold extends StatelessWidget {
  const AuthScaffold({
    super.key,
    required this.title,
    required this.subtitle,
    required this.child,
    this.showBackButton = false,
  });

  final String title;
  final String subtitle;
  final Widget child;
  final bool showBackButton;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.midnightBlack,
      body: SafeArea(
        bottom: false,
        child: CustomScrollView(
          physics: const ClampingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(child: _buildHeader(context)),
            SliverFillRemaining(
              hasScrollBody: false,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppSpacing.margin),
                decoration: const BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(AppRadius.xl),
                  ),
                ),
                child: child,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.margin,
        AppSpacing.spaceMd,
        AppSpacing.margin,
        AppSpacing.spaceXl,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (showBackButton)
            IconButton(
              onPressed: () => Navigator.of(context).maybePop(),
              icon: const Icon(Icons.arrow_back),
              color: AppColors.pureWhite,
              padding: EdgeInsets.zero,
              alignment: Alignment.centerLeft,
            )
          else
            const SizedBox(height: AppSpacing.spaceMd),
          const SizedBox(height: AppSpacing.spaceSm),
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: AppColors.limeNeon,
              borderRadius: AppRadius.large,
              boxShadow: AppEffects.limeActiveGlow,
            ),
            child: const Icon(
              Icons.bolt,
              color: AppColors.midnightBlack,
              size: 30,
            ),
          ),
          const SizedBox(height: AppSpacing.spaceLg),
          Text(
            'SMART CLUB',
            style: AppTextStyles.labelCaps.copyWith(
              color: AppColors.limeNeon,
            ),
          ),
          const SizedBox(height: AppSpacing.spaceSm),
          Text(
            title,
            style: AppTextStyles.headlineLarge.copyWith(
              color: AppColors.pureWhite,
            ),
          ),
          const SizedBox(height: AppSpacing.spaceSm),
          Text(
            subtitle,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }
}