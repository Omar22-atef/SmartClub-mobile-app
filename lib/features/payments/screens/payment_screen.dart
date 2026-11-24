import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/utils/app_formatters.dart';
import '../../../core/utils/input_formatters.dart';
import '../../../shared/widgets/section_header.dart';
import '../../subscriptions/services/membership_controller.dart';
import '../models/payment_model.dart';
import '../models/payment_request_model.dart';
import '../services/payment_controller.dart';
import '../widgets/order_summary_card.dart';
import '../widgets/payment_method_tile.dart';

/// Checkout screen used by memberships, renewals and facility bookings.
class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key, required this.request});

  final PaymentRequest request;

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;
  final _cardController = TextEditingController();
  final _expiryController = TextEditingController();
  final _cvvController = TextEditingController();
  final _walletController = TextEditingController();

  PaymentMethod _method = PaymentMethod.creditCard;
  bool _isProcessing = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(
      text: MembershipController.instance.membership?.memberName ?? '',
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _cardController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    _walletController.dispose();
    super.dispose();
  }

  // ---------------------------------------------------------------------------
  // Actions
  // ---------------------------------------------------------------------------

  Future<void> _pay() async {
    FocusScope.of(context).unfocus();
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() {
      _isProcessing = true;
      _errorMessage = null;
    });

    final isCard = _method == PaymentMethod.creditCard;
    final result = await PaymentController.instance.processPayment(
      request: widget.request,
      method: _method,
      payerName: _nameController.text.trim(),
      card: isCard
          ? PaymentCardDetails(
              holderName: _nameController.text.trim(),
              number: _cardController.text,
              expiry: _expiryController.text,
              cvv: _cvvController.text,
            )
          : null,
      walletNumber: isCard ? null : _walletController.text,
    );

    if (!mounted) return;

    final payment = result.payment;
    if (result.isSuccess && payment != null) {
      Navigator.pushReplacementNamed(
        context,
        AppRoutes.paymentConfirmation,
        arguments: PaymentReceiptArgs(payment: payment, isNewPayment: true),
      );
    } else {
      setState(() {
        _isProcessing = false;
        _errorMessage = result.errorMessage;
      });
    }
  }

  void _fillTestCard(String number) {
    setState(() {
      _cardController.text = number;
      _expiryController.text = '12/30';
      _cvvController.text = '123';
      _errorMessage = null;
    });
  }

  void _selectMethod(PaymentMethod method) {
    if (_isProcessing || method == _method) return;
    setState(() {
      _method = method;
      _errorMessage = null;
    });
  }

  // ---------------------------------------------------------------------------
  // Validation
  // ---------------------------------------------------------------------------

  String? _validateName(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return 'Please enter your full name';
    if (text.length < 3) return 'Name is too short';
    return null;
  }

  String? _validateCardNumber(String? value) {
    final digits = (value ?? '').replaceAll(RegExp(r'\D'), '');
    if (digits.length != 16) return 'Card number must be 16 digits';
    if (!_passesLuhnCheck(digits)) return 'Invalid card number';
    return null;
  }

  String? _validateExpiry(String? value) {
    final match = RegExp(r'^(\d{2})/(\d{2})$').firstMatch(value ?? '');
    if (match == null) return 'Use MM/YY';
    final month = int.parse(match.group(1)!);
    final year = 2000 + int.parse(match.group(2)!);
    if (month < 1 || month > 12) return 'Invalid month';
    // A card is valid until the end of its expiry month.
    final firstDayAfterExpiry = DateTime(year, month + 1);
    if (!firstDayAfterExpiry.isAfter(DateTime.now())) return 'Card expired';
    return null;
  }

  String? _validateCvv(String? value) {
    final digits = (value ?? '').replaceAll(RegExp(r'\D'), '');
    if (digits.length < 3 || digits.length > 4) return '3–4 digits';
    return null;
  }

  String? _validateWallet(String? value) {
    final digits = (value ?? '').replaceAll(RegExp(r'\D'), '');
    if (digits.length != 11 || !digits.startsWith('01')) {
      return 'Enter an 11-digit number starting with 01';
    }
    return null;
  }

  /// Standard Luhn checksum used by all card networks.
  bool _passesLuhnCheck(String digits) {
    var sum = 0;
    var doubleIt = false;
    for (var i = digits.length - 1; i >= 0; i--) {
      var n = int.parse(digits[i]);
      if (doubleIt) {
        n *= 2;
        if (n > 9) n -= 9;
      }
      sum += n;
      doubleIt = !doubleIt;
    }
    return sum % 10 == 0;
  }

  // ---------------------------------------------------------------------------
  // UI
  // ---------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final isCard = _method == PaymentMethod.creditCard;

    return PopScope(
      canPop: !_isProcessing,
      child: Scaffold(
        appBar: AppBar(title: const Text('Payment')),
        body: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.gutter,
              AppSpacing.spaceSm,
              AppSpacing.gutter,
              AppSpacing.space2xl,
            ),
            children: [
              OrderSummaryCard(request: widget.request),
              const SizedBox(height: AppSpacing.sectionSpacing),
              const SectionHeader(title: 'Payment Method'),
              const SizedBox(height: AppSpacing.itemSpacing),
              PaymentMethodTile(
                method: PaymentMethod.creditCard,
                subtitle: 'Visa, Mastercard, Meeza',
                isSelected: isCard,
                onTap: () => _selectMethod(PaymentMethod.creditCard),
              ),
              const SizedBox(height: AppSpacing.itemSpacing),
              PaymentMethodTile(
                method: PaymentMethod.mobileWallet,
                subtitle: 'Vodafone Cash, Orange Cash, e& Cash',
                isSelected: !isCard,
                onTap: () => _selectMethod(PaymentMethod.mobileWallet),
              ),
              const SizedBox(height: AppSpacing.sectionSpacing),
              SectionHeader(title: isCard ? 'Card Details' : 'Wallet Details'),
              const SizedBox(height: AppSpacing.itemSpacing),
              TextFormField(
                controller: _nameController,
                enabled: !_isProcessing,
                textCapitalization: TextCapitalization.words,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  labelText: isCard ? 'Cardholder Name' : 'Full Name',
                  prefixIcon: const Icon(Icons.person_outline),
                ),
                validator: _validateName,
              ),
              const SizedBox(height: AppSpacing.itemSpacing),
              if (isCard) ..._buildCardFields() else _buildWalletField(),
              if (_errorMessage != null) ...[
                const SizedBox(height: AppSpacing.spaceMd),
                _ErrorBanner(message: _errorMessage!),
              ],
              const SizedBox(height: AppSpacing.spaceMd),
              if (isCard) ...[
                _DemoCardsNotice(
                  enabled: !_isProcessing,
                  onUseSuccessCard: () =>
                      _fillTestCard(PaymentController.successTestCard),
                  onUseDeclinedCard: () =>
                      _fillTestCard(PaymentController.declinedTestCard),
                ),
                const SizedBox(height: AppSpacing.spaceMd),
              ],
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.lock_outline,
                    size: 16,
                    color: AppColors.textMuted,
                  ),
                  const SizedBox(width: AppSpacing.spaceXs),
                  Text(
                    'Simulated payment — no real money is charged',
                    style: AppTextStyles.labelMedium.copyWith(
                      color: AppColors.textMuted,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        bottomNavigationBar: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.gutter),
            child: ElevatedButton(
              onPressed: _isProcessing ? null : _pay,
              child: _isProcessing
                  ? const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.2,
                            color: AppColors.midnightBlack,
                          ),
                        ),
                        SizedBox(width: AppSpacing.itemSpacing),
                        Text('Processing payment...'),
                      ],
                    )
                  : Text(
                      'Pay ${AppFormatters.currency(widget.request.amount)}',
                    ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildCardFields() {
    return [
      TextFormField(
        controller: _cardController,
        enabled: !_isProcessing,
        keyboardType: TextInputType.number,
        textInputAction: TextInputAction.next,
        inputFormatters: const [CardNumberInputFormatter()],
        decoration: const InputDecoration(
          labelText: 'Card Number',
          hintText: '0000 0000 0000 0000',
          prefixIcon: Icon(Icons.credit_card),
        ),
        validator: _validateCardNumber,
      ),
      const SizedBox(height: AppSpacing.itemSpacing),
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: TextFormField(
              controller: _expiryController,
              enabled: !_isProcessing,
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.next,
              inputFormatters: const [ExpiryDateInputFormatter()],
              decoration: const InputDecoration(
                labelText: 'Expiry',
                hintText: 'MM/YY',
                prefixIcon: Icon(Icons.calendar_month_outlined),
              ),
              validator: _validateExpiry,
            ),
          ),
          const SizedBox(width: AppSpacing.itemSpacing),
          Expanded(
            child: TextFormField(
              controller: _cvvController,
              enabled: !_isProcessing,
              keyboardType: TextInputType.number,
              obscureText: true,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(4),
              ],
              decoration: const InputDecoration(
                labelText: 'CVV',
                hintText: '•••',
                prefixIcon: Icon(Icons.password_outlined),
              ),
              validator: _validateCvv,
            ),
          ),
        ],
      ),
    ];
  }

  Widget _buildWalletField() {
    return TextFormField(
      controller: _walletController,
      enabled: !_isProcessing,
      keyboardType: TextInputType.phone,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(11),
      ],
      decoration: const InputDecoration(
        labelText: 'Wallet Number',
        hintText: '01XXXXXXXXX',
        prefixIcon: Icon(Icons.phone_android_outlined),
      ),
      validator: _validateWallet,
    );
  }
}

class _ErrorBanner extends StatelessWidget {
  const _ErrorBanner({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.itemSpacing),
      decoration: BoxDecoration(
        color: AppColors.errorContainer,
        borderRadius: AppRadius.medium,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.error_outline,
            size: 20,
            color: AppColors.onErrorContainer,
          ),
          const SizedBox(width: AppSpacing.spaceSm),
          Expanded(
            child: Text(
              message,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.onErrorContainer,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Helper for demos: fills the form with a test card.
class _DemoCardsNotice extends StatelessWidget {
  const _DemoCardsNotice({
    required this.enabled,
    required this.onUseSuccessCard,
    required this.onUseDeclinedCard,
  });

  final bool enabled;
  final VoidCallback onUseSuccessCard;
  final VoidCallback onUseDeclinedCard;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.itemSpacing),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: AppRadius.medium,
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'TEST CARDS',
            style: AppTextStyles.labelCaps.copyWith(color: AppColors.textMuted),
          ),
          const SizedBox(height: AppSpacing.spaceXs),
          Text(
            '${PaymentController.successTestCard} → approved\n'
            '${PaymentController.declinedTestCard} → declined',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppSpacing.spaceSm),
          Wrap(
            spacing: AppSpacing.spaceSm,
            children: [
              ActionChip(
                label: const Text('Use approved card'),
                onPressed: enabled ? onUseSuccessCard : null,
              ),
              ActionChip(
                label: const Text('Use declined card'),
                onPressed: enabled ? onUseDeclinedCard : null,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
