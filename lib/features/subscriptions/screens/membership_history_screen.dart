import 'package:flutter/material.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/utils/app_formatters.dart';
import '../../../shared/widgets/empty_state.dart';
import '../../payments/services/payment_controller.dart';
import '../models/subscription_model.dart';
import '../services/membership_controller.dart';
import '../widgets/subscription_history_card.dart';

class MembershipHistoryScreen extends StatelessWidget {
  const MembershipHistoryScreen({super.key});

  void _openReceipt(BuildContext context, SubscriptionRecord record) {
    final payment = PaymentController.instance.findById(record.paymentId);
    if (payment == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Receipt not found for this period.')),
      );
      return;
    }
    Navigator.pushNamed(
      context,
      AppRoutes.paymentConfirmation,
      arguments: PaymentReceiptArgs(payment: payment),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = MembershipController.instance;

    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        final history = controller.history;
        final membership = controller.membership;
        final totalSpent =
            history.fold<double>(0, (sum, record) => sum + record.amount);

        return Scaffold(
          appBar: AppBar(title: const Text('Membership History')),
          body: history.isEmpty
              ? const Center(
                  child: EmptyState(
                    icon: Icons.history,
                    title: 'No membership history',
                    message: 'Your subscriptions and renewals will appear here.',
                  ),
                )
              : ListView(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.gutter,
                    AppSpacing.spaceSm,
                    AppSpacing.gutter,
                    AppSpacing.space2xl,
                  ),
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: _StatTile(
                            label: 'MEMBER SINCE',
                            value: membership != null
                                ? AppFormatters.date(membership.memberSince)
                                : '-',
                            dark: true,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.itemSpacing),
                        Expanded(
                          child: _StatTile(
                            label: 'PERIODS',
                            value: '${history.length}',
                          ),
                        ),
                        const SizedBox(width: AppSpacing.itemSpacing),
                        Expanded(
                          child: _StatTile(
                            label: 'TOTAL',
                            value: AppFormatters.currency(totalSpent),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.sectionSpacing),
                    ...history.map(
                      (record) => Padding(
                        padding: const EdgeInsets.only(
                          bottom: AppSpacing.itemSpacing,
                        ),
                        child: SubscriptionHistoryCard(
                          record: record,
                          onTap: () => _openReceipt(context, record),
                        ),
                      ),
                    ),
                  ],
                ),
        );
      },
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({
    required this.label,
    required this.value,
    this.dark = false,
  });

  final String label;
  final String value;
  final bool dark;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 76,
      padding: const EdgeInsets.all(AppSpacing.itemSpacing),
      decoration: BoxDecoration(
        color: dark ? AppColors.surfaceDark : AppColors.pureWhite,
        borderRadius: AppRadius.medium,
        border: Border.all(
          color: dark ? AppColors.surfaceDark : AppColors.borderLight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppTextStyles.labelCaps.copyWith(
              color: dark ? AppColors.limeNeon : AppColors.textMuted,
            ),
          ),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              value,
              style: AppTextStyles.bodyLarge.copyWith(
                color: dark ? AppColors.pureWhite : AppColors.midnightBlack,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
