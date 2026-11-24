import 'package:flutter/material.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/utils/app_formatters.dart';
import '../../../shared/widgets/section_header.dart';
import '../../notifications/widgets/notification_bell_button.dart';
import '../../payments/models/payment_request_model.dart';
import '../models/membership_plan_model.dart';
import '../models/subscription_model.dart';
import '../services/membership_controller.dart';
import '../widgets/membership_plan_card.dart';
import '../widgets/membership_status_card.dart';

/// Membership hub: current membership card + available plans.
class MembershipPlansScreen extends StatefulWidget {
  const MembershipPlansScreen({super.key});

  @override
  State<MembershipPlansScreen> createState() => _MembershipPlansScreenState();
}

class _MembershipPlansScreenState extends State<MembershipPlansScreen> {
  final MembershipController _controller = MembershipController.instance;
  String? _selectedPlanId;

  MembershipPlan? get _selectedPlan {
    for (final plan in _controller.plans) {
      if (plan.id == _selectedPlanId) return plan;
    }
    return null;
  }

  void _continueToPayment(MembershipPlan plan) {
    final request = PaymentRequest.membership(
      plan: plan,
      action: _controller.actionFor(plan),
      startDate: _controller.nextPeriodStart,
      newExpiry: _controller.calculateNewExpiry(plan),
    );
    Navigator.pushNamed(context, AppRoutes.payment, arguments: request).then((_) {
      if (mounted) setState(() => _selectedPlanId = null);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _controller,
      builder: (context, _) {
        final membership = _controller.membership;
        final plans = _controller.plans;
        final basePlan = plans.first;
        final selected = _selectedPlan;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Membership'),
            actions: [
              IconButton(
                tooltip: 'Payment history',
                onPressed: () =>
                    Navigator.pushNamed(context, AppRoutes.paymentHistory),
                icon: const Icon(Icons.receipt_long_outlined),
              ),
              const NotificationBellButton(),
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
              MembershipStatusCard(
                membership: membership,
                onTap: membership == null
                    ? null
                    : () => Navigator.pushNamed(
                          context,
                          AppRoutes.subscriptionDetails,
                        ),
                onRenew: () => Navigator.pushNamed(context, AppRoutes.renewal),
              ),
              const SizedBox(height: AppSpacing.itemSpacing),
              Row(
                children: [
                  Expanded(
                    child: _QuickLink(
                      icon: Icons.history,
                      label: 'Membership History',
                      onTap: () => Navigator.pushNamed(
                        context,
                        AppRoutes.membershipHistory,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.itemSpacing),
                  Expanded(
                    child: _QuickLink(
                      icon: Icons.receipt_long_outlined,
                      label: 'Payment History',
                      onTap: () => Navigator.pushNamed(
                        context,
                        AppRoutes.paymentHistory,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sectionSpacing),
              SectionHeader(
                title: membership == null ? 'Choose a Plan' : 'Membership Plans',
                subtitle: membership == null
                    ? 'Pick the plan that fits your routine'
                    : 'Renew or switch plans — unused days are never lost',
              ),
              const SizedBox(height: AppSpacing.itemSpacing),
              ...plans.map(
                (plan) => Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.itemSpacing),
                  child: MembershipPlanCard(
                    plan: plan,
                    isSelected: plan.id == _selectedPlanId,
                    isCurrent: membership?.plan.id == plan.id &&
                        membership?.status != MembershipStatus.expired,
                    savings: plan.savingsComparedTo(basePlan),
                    onTap: () => setState(() {
                      _selectedPlanId =
                          _selectedPlanId == plan.id ? null : plan.id;
                    }),
                  ),
                ),
              ),
            ],
          ),
          bottomNavigationBar: selected == null
              ? null
              : _CheckoutBar(
                  plan: selected,
                  action: _controller.actionFor(selected),
                  newExpiry: _controller.calculateNewExpiry(selected),
                  onContinue: () => _continueToPayment(selected),
                ),
        );
      },
    );
  }
}

class _CheckoutBar extends StatelessWidget {
  const _CheckoutBar({
    required this.plan,
    required this.action,
    required this.newExpiry,
    required this.onContinue,
  });

  final MembershipPlan plan;
  final SubscriptionAction action;
  final DateTime newExpiry;
  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.pureWhite,
        border: Border(top: BorderSide(color: AppColors.borderLight)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.gutter,
            AppSpacing.itemSpacing,
            AppSpacing.gutter,
            AppSpacing.gutter,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${plan.name} • ${action.label}',
                          style: AppTextStyles.labelLarge.copyWith(
                            color: AppColors.onSurface,
                          ),
                        ),
                        Text(
                          'Valid until ${AppFormatters.date(newExpiry)}',
                          style: AppTextStyles.labelMedium.copyWith(
                            color: AppColors.textMuted,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    AppFormatters.currency(plan.price),
                    style: AppTextStyles.headlineSmall.copyWith(
                      color: AppColors.midnightBlack,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.itemSpacing),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: onContinue,
                  child: const Text('Continue to Payment'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _QuickLink extends StatelessWidget {
  const _QuickLink({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.itemSpacing,
            vertical: AppSpacing.itemSpacing,
          ),
          child: Row(
            children: [
              Icon(icon, size: 20, color: AppColors.onSurfaceVariant),
              const SizedBox(width: AppSpacing.spaceSm),
              Expanded(
                child: Text(
                  label,
                  style: AppTextStyles.labelMedium.copyWith(
                    color: AppColors.onSurface,
                  ),
                ),
              ),
              const Icon(
                Icons.chevron_right,
                size: 18,
                color: AppColors.textMuted,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
