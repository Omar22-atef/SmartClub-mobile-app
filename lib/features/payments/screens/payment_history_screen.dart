import 'package:flutter/material.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/utils/app_formatters.dart';
import '../../../shared/widgets/empty_state.dart';
import '../models/payment_model.dart';
import '../services/payment_controller.dart';
import '../widgets/payment_history_card.dart';

enum _HistoryFilter {
  all('All'),
  membership('Membership'),
  bookings('Bookings'),
  failed('Failed');

  const _HistoryFilter(this.label);
  final String label;

  bool matches(Payment p) {
    switch (this) {
      case _HistoryFilter.all:
        return true;
      case _HistoryFilter.membership:
        return p.purpose.isMembership;
      case _HistoryFilter.bookings:
        return p.purpose == PaymentPurpose.booking;
      case _HistoryFilter.failed:
        return p.status == PaymentStatus.failed;
    }
  }
}

class PaymentHistoryScreen extends StatefulWidget {
  const PaymentHistoryScreen({super.key});

  @override
  State<PaymentHistoryScreen> createState() => _PaymentHistoryScreenState();
}

class _PaymentHistoryScreenState extends State<PaymentHistoryScreen> {
  final PaymentController _controller = PaymentController.instance;
  _HistoryFilter _filter = _HistoryFilter.all;

  void _open(Payment payment) {
    if (!payment.hasReceipt) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(payment.failureReason ?? 'This payment failed.'),
        ),
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
    return ListenableBuilder(
      listenable: _controller,
      builder: (context, _) {
        final all = _controller.payments;
        final filtered = all.where(_filter.matches).toList();
        final successfulCount =
            all.where((p) => p.status == PaymentStatus.successful).length;

        return Scaffold(
          appBar: AppBar(title: const Text('Payment History')),
          body: ListView(
            padding: const EdgeInsets.fromLTRB(
              0,
              AppSpacing.spaceSm,
              0,
              AppSpacing.space2xl,
            ),
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.gutter,
                ),
                child: _TotalsCard(
                  totalPaid: _controller.totalPaid,
                  successfulCount: successfulCount,
                ),
              ),
              const SizedBox(height: AppSpacing.spaceMd),
              SizedBox(
                height: 44,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.gutter,
                  ),
                  children: _HistoryFilter.values
                      .map((f) => _buildFilterChip(f))
                      .toList(),
                ),
              ),
              const SizedBox(height: AppSpacing.spaceSm),
              if (filtered.isEmpty)
                const EmptyState(
                  icon: Icons.receipt_long_outlined,
                  title: 'No payments here',
                  message: 'Payments you make will be listed in this tab.',
                )
              else
                ...filtered.map(
                  (payment) => Padding(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.gutter,
                      0,
                      AppSpacing.gutter,
                      AppSpacing.itemSpacing,
                    ),
                    child: PaymentHistoryCard(
                      payment: payment,
                      onTap: () => _open(payment),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFilterChip(_HistoryFilter filter) {
    final isSelected = _filter == filter;
    return Padding(
      padding: const EdgeInsets.only(right: AppSpacing.spaceSm),
      child: FilterChip(
        selected: isSelected,
        label: Text(filter.label),
        labelStyle: AppTextStyles.labelMedium.copyWith(
          color: isSelected
              ? AppColors.midnightBlack
              : AppColors.onSurfaceVariant,
        ),
        backgroundColor: AppColors.surfaceMuted,
        selectedColor: AppColors.limeNeon,
        checkmarkColor: AppColors.midnightBlack,
        side: BorderSide(
          color: isSelected ? AppColors.limeNeon : AppColors.borderLight,
        ),
        shape: RoundedRectangleBorder(borderRadius: AppRadius.pill),
        onSelected: (_) => setState(() => _filter = filter),
      ),
    );
  }
}

class _TotalsCard extends StatelessWidget {
  const _TotalsCard({required this.totalPaid, required this.successfulCount});

  final double totalPaid;
  final int successfulCount;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.spaceLg - 4),
      decoration: BoxDecoration(
        color: AppColors.surfaceDark,
        borderRadius: AppRadius.large,
        border: const Border.fromBorderSide(AppEffects.darkHairline),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'TOTAL PAID',
                  style: AppTextStyles.labelCaps.copyWith(
                    color: AppColors.limeNeon,
                  ),
                ),
                const SizedBox(height: AppSpacing.spaceXs),
                Text(
                  AppFormatters.currency(totalPaid),
                  style: AppTextStyles.statDisplay.copyWith(
                    color: AppColors.pureWhite,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'PAYMENTS',
                style: AppTextStyles.labelCaps.copyWith(
                  color: AppColors.pureWhite.withValues(alpha: 0.5),
                ),
              ),
              const SizedBox(height: AppSpacing.spaceXs),
              Text(
                '$successfulCount',
                style: AppTextStyles.headlineSmall.copyWith(
                  color: AppColors.pureWhite,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
