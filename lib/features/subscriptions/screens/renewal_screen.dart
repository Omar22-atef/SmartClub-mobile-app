import 'package:flutter/material.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/utils/app_formatters.dart';
import '../../../shared/widgets/empty_state.dart';
import '../../../shared/widgets/section_header.dart';
import '../../payments/models/payment_request_model.dart';
import '../models/membership_plan_model.dart';
import '../models/subscription_model.dart';
import '../services/membership_controller.dart';
import '../widgets/membership_plan_card.dart';
import '../widgets/membership_status_card.dart';

class RenewalScreen extends StatefulWidget {
  const RenewalScreen({super.key});

  @override
  State<RenewalScreen> createState() => _RenewalScreenState();
}

class _RenewalScreenState extends State<RenewalScreen> {
  final MembershipController _controller = MembershipController.instance;
  late String _selectedPlanId;

  @override
  void initState() {
    super.initState();
    // Default to renewing the current plan.
    _selectedPlanId =
        _controller.membership?.plan.id ?? _controller.plans.first.id;
  }

  MembershipPlan get _selectedPlan => _controller.plans.firstWhere(
        (p) => p.id == _selectedPlanId,
        orElse: () => _controller.plans.first,
      );

  void _proceedToPayment() {
    final plan = _selectedPlan;
    final request = PaymentRequest.membership(
      plan: plan,
      action: _controller.actionFor(plan),
      startDate: _controller.nextPeriodStart,
      newExpiry: _controller.calculateNewExpiry(plan),
    );
    Navigator.pushNamed(context, AppRoutes.payment, arguments: request);
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _controller,
      builder: (context, _) {
        final membership = _controller.membership;

        if (membership == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Renew Membership')),
            body: Center(
              child: EmptyState(
                icon: Icons.autorenew,
                title: 'Nothing to renew yet',
                message: 'You don\'t have a membership. '
                    'Pick a plan to get started.',
                actionLabel: 'View Plans',
                onAction: () => Navigator.pushReplacementNamed(
                  context,
                  AppRoutes.membershipPlans,
                ),
              ),
            ),
          );
        }

        final plan = _selectedPlan;
        final action = _controller.actionFor(plan);
        final newExpiry = _controller.calculateNewExpiry(plan);
        final isExpired = membership.status == MembershipStatus.expired;

        return Scaffold(
          appBar: AppBar(title: const Text('Renew Membership')),
          body: ListView(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.gutter,
              AppSpacing.spaceSm,
              AppSpacing.gutter,
              AppSpacing.space2xl,
            ),
            children: [
              MembershipStatusCard(membership: membership),
              const SizedBox(height: AppSpacing.sectionSpacing),
              const SectionHeader(
                title: 'Renewal Period',
                subtitle: 'Keep your plan or switch while renewing',
              ),
              const SizedBox(height: AppSpacing.itemSpacing),
              ..._controller.plans.map(
                (p) => Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.itemSpacing),
                  child: MembershipPlanCard(
                    plan: p,
                    isSelected: p.id == _selectedPlanId,
                    isCurrent: p.id == membership.plan.id,
                    savings: p.savingsComparedTo(_controller.plans.first),
                    showFeatures: false,
                    onTap: () => setState(() => _selectedPlanId = p.id),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.itemSpacing),
              const SectionHeader(title: 'New Expiry Date'),
              const SizedBox(height: AppSpacing.itemSpacing),
              _ExpiryPreview(
                currentExpiry: membership.expiryDate,
                newExpiry: newExpiry,
                daysAdded: _controller.daysAddedBy(plan),
                isExpired: isExpired,
              ),
              if (action == SubscriptionAction.planChange) ...[
                const SizedBox(height: AppSpacing.itemSpacing),
                _InfoNote(
                  text: 'Your plan will change from ${membership.plan.name} '
                      'to ${plan.name} right after payment.',
                ),
              ],
              if (isExpired) ...[
                const SizedBox(height: AppSpacing.itemSpacing),
                const _InfoNote(
                  text: 'Your membership has expired, so the new period '
                      'starts today.',
                ),
              ],
            ],
          ),
          bottomNavigationBar: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.gutter),
              child: ElevatedButton(
                onPressed: _proceedToPayment,
                child: Text(
                  'Proceed to Payment • ${AppFormatters.currency(plan.price)}',
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _ExpiryPreview extends StatelessWidget {
  const _ExpiryPreview({
    required this.currentExpiry,
    required this.newExpiry,
    required this.daysAdded,
    required this.isExpired,
  });

  final DateTime currentExpiry;
  final DateTime newExpiry;
  final int daysAdded;
  final bool isExpired;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.cardPadding),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: _DateBlock(
                    label: isExpired ? 'EXPIRED ON' : 'CURRENT EXPIRY',
                    date: currentExpiry,
                    muted: true,
                  ),
                ),
                Container(
                  width: 36,
                  height: 36,
                  decoration: const BoxDecoration(
                    color: AppColors.midnightBlack,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.arrow_forward,
                    size: 18,
                    color: AppColors.limeNeon,
                  ),
                ),
                Expanded(
                  child: _DateBlock(
                    label: 'NEW EXPIRY',
                    date: newExpiry,
                    alignEnd: true,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.itemSpacing),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                vertical: AppSpacing.spaceSm,
              ),
              decoration: BoxDecoration(
                color: AppColors.limeNeon.withValues(alpha: 0.25),
                borderRadius: AppRadius.medium,
              ),
              alignment: Alignment.center,
              child: Text(
                '+$daysAdded days of access',
                style: AppTextStyles.labelLarge.copyWith(
                  color: AppColors.onSecondaryFixedVariant,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DateBlock extends StatelessWidget {
  const _DateBlock({
    required this.label,
    required this.date,
    this.alignEnd = false,
    this.muted = false,
  });

  final String label;
  final DateTime date;
  final bool alignEnd;
  final bool muted;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          alignEnd ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.labelCaps.copyWith(color: AppColors.textMuted),
        ),
        const SizedBox(height: AppSpacing.spaceXs),
        Text(
          AppFormatters.date(date),
          style: AppTextStyles.bodyLarge.copyWith(
            color: muted ? AppColors.onSurfaceVariant : AppColors.midnightBlack,
            fontWeight: muted ? FontWeight.w500 : FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _InfoNote extends StatelessWidget {
  const _InfoNote({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(Icons.info_outline, size: 18, color: AppColors.textMuted),
        const SizedBox(width: AppSpacing.spaceSm),
        Expanded(
          child: Text(
            text,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.onSurfaceVariant,
            ),
          ),
        ),
      ],
    );
  }
}
