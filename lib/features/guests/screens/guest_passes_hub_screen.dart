import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/routes/app_routes.dart';
import '../models/guest_pass_model.dart';
import '../services/guest_pass_controller.dart';
import '../widgets/pass_history_card.dart';

class GuestPassesHubScreen extends StatelessWidget {
  const GuestPassesHubScreen({super.key});

  void _openCreatePassForm(
    BuildContext context,
    GuestPassController controller,
  ) {
    if (!controller.canGenerate) return;

    Navigator.pushNamed(
      context,
      AppRoutes.createGuestPass,
      arguments: CreateGuestPassArgs(
        remainingPasses: controller.remainingPasses,
        nextSequence: controller.nextSequence,
      ),
    );
  }

  void _openTicketDetails(BuildContext context, GuestPassRecord record) {
    Navigator.pushNamed(
      context,
      AppRoutes.guestPassTicket,
      arguments: GuestPassTicketArgs(record: record),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = GuestPassController.instance;

    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        final historyPasses = controller.history;
        final remainingPasses = controller.remainingPasses;
        final canGenerate = controller.canGenerate;

        return Scaffold(
          backgroundColor: AppColors.surface,
          appBar: AppBar(
            backgroundColor: AppColors.surface.withValues(alpha: 0.92),
            leadingWidth: 56,
            leading: Padding(
              padding: const EdgeInsets.only(left: AppSpacing.spaceSm),
              child: IconButton(
                onPressed: () => Navigator.maybePop(context),
                style: IconButton.styleFrom(
                  minimumSize: const Size(
                    AppDimensions.minimumTouchTarget,
                    AppDimensions.minimumTouchTarget,
                  ),
                ),
                icon: const Icon(
                  Icons.arrow_back,
                  color: AppColors.onSurface,
                  size: 24,
                ),
              ),
            ),
            title: Text(
              'Guest Passes',
              style: AppTextStyles.headlineSmall.copyWith(
                color: AppColors.onSurface,
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: AppSpacing.marginMobile),
                child: Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.surfaceDark,
                    border: Border.all(
                      color: AppColors.surfaceDark,
                      width: 2,
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    'AV',
                    style: AppTextStyles.labelCaps.copyWith(
                      color: AppColors.limeNeon,
                    ),
                  ),
                ),
              ),
            ],
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.marginMobile,
                AppSpacing.spaceSm,
                AppSpacing.marginMobile,
                AppSpacing.space2xl,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // 1. Allocation Status Overview Banner (updates remaining count)
                  _buildAllocationBanner(remainingPasses),
                  const SizedBox(height: AppSpacing.spaceMd),

                  // 2. Primary CTA to Open Create Form
                  Container(
                    height: AppDimensions.primaryButtonHeight,
                    decoration: BoxDecoration(
                      borderRadius: AppRadius.pill,
                      boxShadow: canGenerate ? AppEffects.limeActiveGlow : null,
                    ),
                    child: ElevatedButton.icon(
                      onPressed: canGenerate
                          ? () => _openCreatePassForm(context, controller)
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.limeNeon,
                        foregroundColor: AppColors.surfaceDark,
                        disabledBackgroundColor: AppColors.disabledBackground,
                        disabledForegroundColor: AppColors.disabledForeground,
                        shape: RoundedRectangleBorder(
                          borderRadius: AppRadius.pill,
                        ),
                        elevation: 0,
                      ),
                      icon: const Icon(Icons.add, size: 22),
                      label: Text(
                        canGenerate
                            ? 'GENERATE GUEST PASS'
                            : 'NO PASSES REMAINING',
                        style: AppTextStyles.labelLarge.copyWith(
                          fontWeight: FontWeight.w700,
                          color: canGenerate
                              ? AppColors.surfaceDark
                              : AppColors.disabledForeground,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sectionSpacing),

                  // 3. History Tab Only
                  _buildHistoryHeader(historyPasses.length),
                  const SizedBox(height: AppSpacing.itemSpacing),

                  // 4. All Issued Passes Roster
                  if (historyPasses.isEmpty)
                    _buildEmptyState()
                  else
                    Column(
                      children: List.generate(historyPasses.length, (index) {
                        final record = historyPasses[index];
                        return Padding(
                          padding: EdgeInsets.only(
                            bottom: index == historyPasses.length - 1
                                ? 0
                                : AppSpacing.itemSpacing,
                          ),
                          child: PassHistoryCard(
                            record: record,
                            onTap: () => _openTicketDetails(context, record),
                          ),
                        );
                      }),
                    ),
                  const SizedBox(height: AppSpacing.sectionSpacing),

                  // 5. Club Guest Guidelines Micro-Card
                  _buildGuidelinesCard(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAllocationBanner(int remainingPasses) {
    const totalPasses = GuestPassController.totalPasses;
    final progressValue = (remainingPasses / totalPasses).clamp(0.0, 1.0);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.spaceMd),
      decoration: BoxDecoration(
        color: AppColors.surfaceDark,
        borderRadius: AppRadius.medium,
        border: Border.fromBorderSide(AppEffects.darkHairline),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Positioned(
            right: -24,
            bottom: -24,
            child: Container(
              width: 128,
              height: 128,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.limeNeon.withValues(alpha: 0.10),
              ),
            ),
          ),
          Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.spaceSm,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.limeNeon.withValues(alpha: 0.20),
                            borderRadius: AppRadius.pill,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: AppDimensions.statusDotSize,
                                height: AppDimensions.statusDotSize,
                                decoration: const BoxDecoration(
                                  color: AppColors.limeNeon,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                'ACTIVE TIER: FOUNDERS CLUB',
                                style: AppTextStyles.labelCaps.copyWith(
                                  color: AppColors.limeNeon,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: AppSpacing.spaceSm),
                        Text(
                          'Guest Allocation',
                          style: AppTextStyles.headlineSmall.copyWith(
                            color: AppColors.pureWhite,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '$remainingPasses of $totalPasses complimentary passes remaining this cycle',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: AppSpacing.itemSpacing),
                  Container(
                    width: AppDimensions.minimumTouchTarget,
                    height: AppDimensions.minimumTouchTarget,
                    decoration: BoxDecoration(
                      color: AppColors.surfaceDarkElevated,
                      borderRadius: AppRadius.medium,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '$remainingPasses',
                          style: AppTextStyles.headlineSmall.copyWith(
                            color: AppColors.limeNeon,
                            height: 1.0,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'LEFT',
                          style: AppTextStyles.labelCaps.copyWith(
                            fontSize: 9,
                            color: AppColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.spaceMd),
              Container(
                padding: const EdgeInsets.only(top: AppSpacing.itemSpacing),
                decoration: const BoxDecoration(
                  border: Border(
                    top: AppEffects.darkHairline,
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: AppRadius.pill,
                        child: LinearProgressIndicator(
                          value: progressValue,
                          minHeight: 6,
                          backgroundColor: AppColors.surfaceDarkElevated,
                          valueColor: const AlwaysStoppedAnimation<Color>(
                            AppColors.limeNeon,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.spaceMd),
                    Text(
                      'Renews Apr 1',
                      style: AppTextStyles.labelCaps.copyWith(
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryHeader(int count) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.spaceXs),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer,
        borderRadius: AppRadius.pill,
      ),
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          color: AppColors.surfaceDark,
          borderRadius: AppRadius.pill,
        ),
        alignment: Alignment.center,
        child: Text(
          'History ($count)',
          style: AppTextStyles.labelMedium.copyWith(
            color: AppColors.limeNeon,
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.spaceLg,
        vertical: AppSpacing.spaceXl,
      ),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: AppRadius.medium,
        border: Border.fromBorderSide(AppEffects.lightHairline),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.history_outlined,
            size: 32,
            color: AppColors.textMuted,
          ),
          const SizedBox(height: AppSpacing.spaceSm),
          Text(
            'No Pass History Yet',
            style: AppTextStyles.labelLarge.copyWith(
              color: AppColors.onSurface,
            ),
          ),
          const SizedBox(height: AppSpacing.spaceXs),
          Text(
            'Tap "Generate Guest Pass" above to issue a digital pass for your next visit.',
            textAlign: TextAlign.center,
            style: AppTextStyles.bodyMedium.copyWith(
              fontSize: 13,
              color: AppColors.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGuidelinesCard() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.spaceMd),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer,
        borderRadius: AppRadius.medium,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 2),
            child: Icon(
              Icons.info_outline,
              size: 22,
              color: AppColors.secondary,
            ),
          ),
          const SizedBox(width: AppSpacing.itemSpacing),
          Expanded(
            child: Text(
              'Tap any guest pass in history to view its turnstile QR code or share it. Members must accompany guests when utilizing court allocations.',
              style: AppTextStyles.bodyMedium.copyWith(
                fontSize: 13,
                color: AppColors.onSurfaceVariant,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}