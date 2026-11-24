import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/utils/app_formatters.dart';
import '../../subscriptions/services/membership_controller.dart';
import '../models/payment_model.dart';
import '../widgets/receipt_card.dart';

/// Success screen after paying (isNewPayment = true) and
/// receipt viewer from the payment history (isNewPayment = false).
class PaymentConfirmationScreen extends StatelessWidget {
  const PaymentConfirmationScreen({
    super.key,
    required this.payment,
    this.isNewPayment = false,
  });

  final Payment payment;
  final bool isNewPayment;

  /// Back to the main tabs (closes booking / payment screens behind us).
  void _finish(BuildContext context) {
    Navigator.popUntil(context, (route) => route.isFirst);
  }

  Future<void> _copyReceipt(BuildContext context) async {
    await Clipboard.setData(ClipboardData(text: payment.toReceiptText()));
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Receipt copied to clipboard')),
    );
  }

  void _openRelated(BuildContext context) {
    final route = payment.purpose.isMembership
        ? AppRoutes.subscriptionDetails
        : AppRoutes.myBookings;
    Navigator.pushNamedAndRemoveUntil(context, route, (r) => r.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    final screen = Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: !isNewPayment,
        title: Text(isNewPayment ? 'Payment Complete' : 'Receipt'),
        actions: [
          IconButton(
            tooltip: 'Copy receipt',
            onPressed: () => _copyReceipt(context),
            icon: const Icon(Icons.copy_outlined),
          ),
          const SizedBox(width: AppSpacing.spaceXs),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.gutter,
          AppSpacing.spaceSm,
          AppSpacing.gutter,
          AppSpacing.space2xl,
        ),
        children: [
          _Header(payment: payment, isNewPayment: isNewPayment),
          const SizedBox(height: AppSpacing.sectionSpacing),
          ReceiptCard(payment: payment),
          if (isNewPayment) ...[
            const SizedBox(height: AppSpacing.itemSpacing),
            _NextStepCard(payment: payment),
          ],
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.gutter),
          child: isNewPayment
              ? Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => _openRelated(context),
                        child: Text(
                          payment.purpose.isMembership
                              ? 'View My Subscription'
                              : 'View My Bookings',
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.spaceSm),
                    SizedBox(
                      width: double.infinity,
                      child: TextButton(
                        onPressed: () => _finish(context),
                        child: const Text('Done'),
                      ),
                    ),
                  ],
                )
              : ElevatedButton.icon(
                  onPressed: () => _copyReceipt(context),
                  icon: const Icon(Icons.copy_outlined, size: 20),
                  label: const Text('Copy Receipt'),
                ),
        ),
      ),
    );

    if (!isNewPayment) return screen;

    // After paying, "back" behaves like "Done" (never returns to checkout).
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _finish(context);
      },
      child: screen,
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.payment, required this.isNewPayment});

  final Payment payment;
  final bool isNewPayment;

  @override
  Widget build(BuildContext context) {
    final isRefunded = payment.status == PaymentStatus.refunded;
    final title = isRefunded
        ? 'Payment Refunded'
        : isNewPayment
            ? 'Payment Successful'
            : 'Payment Receipt';

    return Column(
      children: [
        const SizedBox(height: AppSpacing.spaceMd),
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isRefunded ? AppColors.warningContainer : AppColors.limeNeon,
            boxShadow: isRefunded ? null : AppEffects.limeActiveGlow,
          ),
          child: Icon(
            isRefunded ? Icons.undo_rounded : Icons.check_rounded,
            size: 44,
            color: isRefunded ? AppColors.warning : AppColors.midnightBlack,
          ),
        ),
        const SizedBox(height: AppSpacing.spaceMd),
        Text(
          title,
          style: AppTextStyles.headlineSmall.copyWith(
            color: AppColors.onSurface,
          ),
        ),
        const SizedBox(height: AppSpacing.spaceXs),
        Text(
          AppFormatters.currency(payment.amount),
          style: AppTextStyles.statDisplay.copyWith(
            color: AppColors.midnightBlack,
          ),
        ),
        const SizedBox(height: AppSpacing.spaceXs),
        Text(
          AppFormatters.dateTime(payment.createdAt),
          style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textMuted),
        ),
      ],
    );
  }
}

/// Explains what changed after the payment (membership / booking).
class _NextStepCard extends StatelessWidget {
  const _NextStepCard({required this.payment});

  final Payment payment;

  @override
  Widget build(BuildContext context) {
    final String title;
    final String body;
    final IconData icon;

    if (payment.purpose.isMembership) {
      final membership = MembershipController.instance.membership;
      icon = Icons.verified_outlined;
      title = 'Membership updated';
      body = membership == null
          ? 'Your membership has been updated.'
          : 'Status: ${membership.status.label} • valid until '
              '${AppFormatters.date(membership.expiryDate)}';
    } else {
      icon = Icons.event_available_outlined;
      title = 'Booking confirmed';
      body = 'Booking ${payment.referenceId ?? ''} is now in My Bookings.';
    }

    return Container(
      padding: const EdgeInsets.all(AppSpacing.cardPadding),
      decoration: BoxDecoration(
        color: AppColors.surfaceDark,
        borderRadius: AppRadius.large,
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.limeNeon),
          const SizedBox(width: AppSpacing.itemSpacing),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.labelLarge.copyWith(
                    color: AppColors.pureWhite,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  body,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.pureWhite.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
