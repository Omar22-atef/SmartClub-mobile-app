import 'package:flutter/material.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/utils/app_formatters.dart';
import '../../../shared/widgets/empty_state.dart';
import '../../../shared/widgets/section_header.dart';
import '../../../shared/widgets/summary_row.dart';
import '../models/subscription_model.dart';
import '../services/membership_controller.dart';
import '../widgets/membership_status_card.dart';

class SubscriptionDetailsScreen extends StatelessWidget {
  const SubscriptionDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = MembershipController.instance;

    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        final membership = controller.membership;

        return Scaffold(
          appBar: AppBar(title: const Text('My Subscription')),
          body: membership == null
              ? Center(
                  child: EmptyState(
                    icon: Icons.card_membership_outlined,
                    title: 'No active subscription',
                    message: 'Choose a membership plan to get started.',
                    actionLabel: 'View Plans',
                    onAction: () => Navigator.pushNamed(
                      context,
                      AppRoutes.membershipPlans,
                    ),
                  ),
                )
              : _buildDetails(context, membership),
          bottomNavigationBar: membership == null
              ? null
              : SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.gutter),
                    child: Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.pushNamed(
                              context,
                              AppRoutes.membershipPlans,
                            ),
                            style: OutlinedButton.styleFrom(
                              minimumSize: const Size(
                                0,
                                AppDimensions.primaryButtonHeight,
                              ),
                            ),
                            child: const Text('Change Plan'),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.itemSpacing),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () => Navigator.pushNamed(
                              context,
                              AppRoutes.renewal,
                            ),
                            child: const Text('Renew'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
        );
      },
    );
  }

  Widget _buildDetails(BuildContext context, Membership membership) {
    final status = membership.status;
    final plan = membership.plan;
    final daysLeft = membership.daysRemaining;

    return ListView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.gutter,
        AppSpacing.spaceSm,
        AppSpacing.gutter,
        AppSpacing.space2xl,
      ),
      children: [
        MembershipStatusCard(membership: membership),
        if (status == MembershipStatus.expiringSoon ||
            status == MembershipStatus.expired) ...[
          const SizedBox(height: AppSpacing.itemSpacing),
          _AlertBanner(
            color: membershipStatusColor(status),
            message: status == MembershipStatus.expired
                ? 'Your membership has expired. Renew to restore your access.'
                : 'Your membership expires in $daysLeft '
                    '${daysLeft == 1 ? 'day' : 'days'}. '
                    'Renew now — the new period starts after your current expiry.',
          ),
        ],
        const SizedBox(height: AppSpacing.sectionSpacing),
        const SectionHeader(title: 'Subscription Details'),
        const SizedBox(height: AppSpacing.itemSpacing),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.cardPadding),
            child: Column(
              children: [
                SummaryRow(label: 'Member ID', value: membership.memberCardNumber),
                SummaryRow(label: 'Plan', value: '${plan.name} Membership'),
                SummaryRow(
                  label: 'Price',
                  value: '${AppFormatters.currency(plan.price)} / '
                      '${plan.durationLabel}',
                ),
                SummaryRow(
                  label: 'Member since',
                  value: AppFormatters.date(membership.memberSince),
                ),
                SummaryRow(
                  label: 'Current period',
                  value: AppFormatters.date(membership.currentPeriodStart),
                ),
                SummaryRow(
                  label: 'Expiry date',
                  value: AppFormatters.date(membership.expiryDate),
                ),
                SummaryRow(
                  label: 'Days remaining',
                  value: daysLeft < 0 ? '0' : '$daysLeft',
                ),
                const Divider(height: AppSpacing.spaceLg),
                SummaryRow(
                  label: 'Status',
                  value: status.label,
                  bold: true,
                  valueColor: membershipStatusColor(status),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.sectionSpacing),
        SectionHeader(
          title: 'Plan Benefits',
          subtitle: '${plan.guestPassesPerMonth} guest '
              '${plan.guestPassesPerMonth == 1 ? 'pass' : 'passes'} per month '
              'included',
        ),
        const SizedBox(height: AppSpacing.itemSpacing),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.cardPadding),
            child: Column(
              children: plan.features
                  .map(
                    (feature) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.check_circle,
                            size: 18,
                            color: AppColors.secondary,
                          ),
                          const SizedBox(width: AppSpacing.spaceSm),
                          Expanded(
                            child: Text(
                              feature,
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: AppColors.onSurfaceVariant,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.sectionSpacing),
        Card(
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.history),
                title: const Text('Membership History'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () =>
                    Navigator.pushNamed(context, AppRoutes.membershipHistory),
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.receipt_long_outlined),
                title: const Text('Payment History'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () =>
                    Navigator.pushNamed(context, AppRoutes.paymentHistory),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _AlertBanner extends StatelessWidget {
  const _AlertBanner({required this.color, required this.message});

  final Color color;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.itemSpacing),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: AppRadius.medium,
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline, size: 20, color: color),
          const SizedBox(width: AppSpacing.spaceSm),
          Expanded(
            child: Text(
              message,
              style: AppTextStyles.bodyMedium.copyWith(color: color),
            ),
          ),
        ],
      ),
    );
  }
}
