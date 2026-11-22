import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/routes/app_routes.dart';
import '../models/guest_pass_model.dart';
import '../services/guest_pass_controller.dart';

class CreateGuestPassScreen extends StatefulWidget {
  const CreateGuestPassScreen({
    super.key,
    this.remainingPasses = 3,
    this.nextSequence = 9411,
  });

  final int remainingPasses;
  final int nextSequence;

  @override
  State<CreateGuestPassScreen> createState() => _CreateGuestPassScreenState();
}

class _CreateGuestPassScreenState extends State<CreateGuestPassScreen> {
  final _formKey = GlobalKey<FormState>();
  final _guestNameController = TextEditingController();
  final _guestEmailController = TextEditingController();
  final _guestPhoneController = TextEditingController();
  late final TextEditingController _visitDateController;

  DateTime _selectedDate = DateTime.now().add(const Duration(days: 1));

  List<GuestPrivilegeOption> _privileges = const [
    GuestPrivilegeOption(
      id: 'clubhouse',
      title: 'Clubhouse & Locker Access',
      subtitle: 'Lounge, showers, dining pavilion',
      icon: Icons.meeting_room_outlined,
      isEnabled: true,
    ),
    GuestPrivilegeOption(
      id: 'court',
      title: 'Tennis / Padel Court Access',
      subtitle: 'Glass court play alongside host Alex Vance',
      icon: Icons.sports_tennis_outlined,
      isEnabled: true,
    ),
    GuestPrivilegeOption(
      id: 'spa',
      title: 'Thermal Spa & Recovery',
      subtitle: 'Sauna, cold plunge & hydro pools',
      icon: Icons.hot_tub_outlined,
      isEnabled: false,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _visitDateController = TextEditingController(
      text: _formatReadableDate(_selectedDate),
    );
  }

  @override
  void dispose() {
    _guestNameController.dispose();
    _guestEmailController.dispose();
    _guestPhoneController.dispose();
    _visitDateController.dispose();
    super.dispose();
  }

  String _formatReadableDate(DateTime date) {
    const weekdays = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${weekdays[date.weekday - 1]}, ${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  String _formatShortDate(DateTime date) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  Future<void> _pickVisitDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.midnightBlack,
              onPrimary: AppColors.limeNeon,
              surface: AppColors.pureWhite,
              onSurface: AppColors.onSurface,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _visitDateController.text = _formatReadableDate(picked);
      });
    }
  }

  void _togglePrivilege(int index) {
    setState(() {
      final updated = List<GuestPrivilegeOption>.from(_privileges);
      updated[index] = updated[index].copyWith(
        isEnabled: !updated[index].isEnabled,
      );
      _privileges = updated;
    });
  }
  String? _validateName(String? value) {
    final trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) {
      return 'Guest full name is required.';
    }
    if (trimmed.length < 3) {
      return 'Name must be at least 3 characters.';
    }
    if (!RegExp(r"^[a-zA-Z\u0600-\u06FF\s'-]+$").hasMatch(trimmed)) {
      return 'Name can only contain letters and spaces.';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    final trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) {
      return 'Email address is required.';
    }
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    if (!emailRegex.hasMatch(trimmed)) {
      return 'Enter a valid email (e.g. guest@example.com).';
    }
    return null;
  }

  String? _validatePhone(String? value) {
    final raw = value?.trim() ?? '';
    if (raw.isEmpty) {
      return 'Mobile number is required.';
    }
    final normalized = raw.replaceAll(RegExp(r'[\s\-\(\)]'), '');
    final isEgyptMobile =
        RegExp(r'^(?:\+20|0020|0)?1[0125]\d{8}$').hasMatch(normalized);
    final isInternational =
        RegExp(r'^\+?[1-9]\d{7,14}$').hasMatch(normalized);

    if (!isEgyptMobile && !isInternational) {
      return 'Enter a valid mobile number (e.g. +20 100 050 7000).';
    }
    return null;
  }

  void _submitForm() {
    final controller = GuestPassController.instance;
    if (!controller.canGenerate) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No complimentary guest passes remaining.'),
        ),
      );
      return;
    }
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }
    final enabledZones = _privileges
        .where((p) => p.isEnabled)
        .map((p) => p.title)
        .toList();

        if (enabledZones.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Select at least one club access privilege.'),
        ),
      );
      return;
    }


    final newRecord = controller.issuePass(
      guestName: _guestNameController.text.trim(),
      email: _guestEmailController.text.trim(),
      phoneNumber: _guestPhoneController.text.trim(),
      visitDate: _visitDateController.text,
      shortDate: _formatShortDate(_selectedDate),
      clearedZones: enabledZones,
      totalAvailableZones: _privileges.length,
    );

    FocusScope.of(context).unfocus();

    Navigator.pushReplacementNamed(
      context,
      AppRoutes.guestPassTicket,
      arguments: GuestPassTicketArgs(
        record: newRecord,
        isNewlyIssued: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final remaining = GuestPassController.instance.remainingPasses;

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: AppColors.surface.withValues(alpha: 0.92),
        leadingWidth: 56,
        leading: Padding(
          padding: const EdgeInsets.only(left: AppSpacing.spaceSm),
          child: IconButton(
            onPressed: () => Navigator.pop(context),
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
          'New Guest Pass',
          style: AppTextStyles.headlineSmall.copyWith(
            color: AppColors.onSurface,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: AppSpacing.marginMobile),
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: AppSpacing.spaceXs,
                ),
                decoration: BoxDecoration(
                  color: AppColors.surfaceDark,
                  borderRadius: AppRadius.pill,
                ),
                child: Text(
                  '$remaining LEFT',
                  style: AppTextStyles.labelCaps.copyWith(
                    color: AppColors.limeNeon,
                  ),
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
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Container(
              padding: const EdgeInsets.all(AppSpacing.cardPadding),
              decoration: BoxDecoration(
                color: AppColors.surfaceLight,
                borderRadius: AppRadius.medium,
                border: Border.fromBorderSide(AppEffects.lightHairline),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Guest Credentials',
                              style: AppTextStyles.headlineSmall.copyWith(
                                color: AppColors.onSurface,
                              ),
                            ),
                            Text(
                              'Issue digital club access for 1 complimentary visit',
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: AppColors.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(
                        Icons.badge_outlined,
                        color: AppColors.onSurfaceVariant,
                        size: 22,
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.spaceMd),

                  // 1. Guest Full Name
                  _buildInputField(
                    label: 'Guest Full Name',
                    controller: _guestNameController,
                    hintText: 'e.g. Mohamed Ahmed',
                    prefixIcon: Icons.person_outline,
                    textCapitalization: TextCapitalization.words,
                    textInputAction: TextInputAction.next,
                    validator: _validateName,
                  ),
                  const SizedBox(height: AppSpacing.spaceMd),

                  // 2. Guest Email Address
                  _buildInputField(
                    label: 'Email Address',
                    controller: _guestEmailController,
                    hintText: 'e.g. mohamed.ahmed@email.com',
                    prefixIcon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    validator: _validateEmail,
                  ),
                  const SizedBox(height: AppSpacing.spaceMd),

                  // 3. Guest Mobile Number
                  _buildInputField(
                    label: 'Mobile Number',
                    controller: _guestPhoneController,
                    hintText: '+20 100 050 7000',
                    prefixIcon: Icons.phone_outlined,
                    keyboardType: TextInputType.phone,
                    textInputAction: TextInputAction.done,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9+\-\s\(\)]')),
                    ],
                    validator: _validatePhone,
                  ),
                  const SizedBox(height: AppSpacing.spaceMd),

                  // 4. Visit Date
                  _buildInputField(
                    label: 'Visit Date',
                    controller: _visitDateController,
                    hintText: 'Select date',
                    prefixIcon: Icons.calendar_today_outlined,
                    suffixIcon: Icons.expand_more,
                    readOnly: true,
                    onTap: _pickVisitDate,
                  ),
                  const SizedBox(height: AppSpacing.spaceMd),

                  // Zone Clearance Toggles
                  Text(
                    'Privileges & Zone Clearance',
                    style: AppTextStyles.labelMedium.copyWith(
                      color: AppColors.onSurface,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.spaceSm),
                  Column(
                    children: List.generate(_privileges.length, (index) {
                      final item = _privileges[index];
                      return Padding(
                        padding: EdgeInsets.only(
                          bottom: index == _privileges.length - 1
                              ? 0
                              : AppSpacing.spaceSm,
                        ),
                        child: InkWell(
                          onTap: () => _togglePrivilege(index),
                          borderRadius: AppRadius.medium,
                          child: Container(
                            padding: const EdgeInsets.all(AppSpacing.itemSpacing),
                            decoration: BoxDecoration(
                              color: AppColors.surfaceMuted,
                              borderRadius: AppRadius.medium,
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 32,
                                  height: 32,
                                  decoration: BoxDecoration(
                                    color: AppColors.surfaceLight,
                                    borderRadius: AppRadius.standard,
                                  ),
                                  child: Icon(
                                    item.icon,
                                    size: 18,
                                    color: AppColors.onSurface,
                                  ),
                                ),
                                const SizedBox(width: AppSpacing.itemSpacing),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.title,
                                        style: AppTextStyles.labelLarge.copyWith(
                                          color: AppColors.onSurface,
                                        ),
                                      ),
                                      Text(
                                        item.subtitle,
                                        style: AppTextStyles.bodyMedium.copyWith(
                                          fontSize: 12,
                                          color: AppColors.onSurfaceVariant,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: AppSpacing.spaceSm),
                                SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: Checkbox(
                                    value: item.isEnabled,
                                    onChanged: (_) => _togglePrivilege(index),
                                    activeColor: AppColors.surfaceDark,
                                    checkColor: AppColors.pureWhite,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: AppRadius.small,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: AppSpacing.spaceLg),

                  // Generate Invitation CTA
                  Container(
                    width: double.infinity,
                    height: AppDimensions.primaryButtonHeight,
                    decoration: BoxDecoration(
                      borderRadius: AppRadius.pill,
                      boxShadow: AppEffects.limeActiveGlow,
                    ),
                    child: ElevatedButton.icon(
                      onPressed: _submitForm,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.limeNeon,
                        foregroundColor: AppColors.surfaceDark,
                        shape: RoundedRectangleBorder(
                          borderRadius: AppRadius.pill,
                        ),
                        elevation: 0,
                      ),
                      icon: const Icon(
                        Icons.confirmation_number_outlined,
                        size: 20,
                      ),
                      label: Text(
                        'GENERATE INVITATION',
                        style: AppTextStyles.labelLarge.copyWith(
                          fontWeight: FontWeight.w700,
                          color: AppColors.surfaceDark,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    required String hintText,
    required IconData prefixIcon,
    IconData? suffixIcon,
    bool readOnly = false,
    VoidCallback? onTap,
    TextInputAction? textInputAction,
    TextInputType? keyboardType,
    TextCapitalization textCapitalization = TextCapitalization.none,
    List<TextInputFormatter>? inputFormatters,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.labelMedium.copyWith(
            color: AppColors.onSurface,
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          readOnly: readOnly,
          onTap: onTap,
          textInputAction: textInputAction,
          keyboardType: keyboardType,
          textCapitalization: textCapitalization,
          inputFormatters: inputFormatters,
          validator: validator,
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.onSurface,
          ),
          decoration: InputDecoration(
            hintText: hintText,
            filled: true,
            fillColor: AppColors.surfaceMuted,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.spaceMd,
              vertical: 14,
            ),
            prefixIcon: Icon(
              prefixIcon,
              size: 18,
              color: AppColors.onSurfaceVariant,
            ),
            suffixIcon: suffixIcon != null
                ? Icon(
                    suffixIcon,
                    size: 18,
                    color: AppColors.onSurfaceVariant,
                  )
                : null,
            errorStyle: AppTextStyles.labelMedium.copyWith(
              fontSize: 11,
              color: AppColors.error,
            ),
            border: OutlineInputBorder(
              borderRadius: AppRadius.medium,
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: AppRadius.medium,
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: AppRadius.medium,
              borderSide: const BorderSide(
                color: AppColors.midnightBlack,
                width: AppDimensions.borderWidth,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: AppRadius.medium,
              borderSide: const BorderSide(
                color: AppColors.error,
                width: AppDimensions.borderWidth,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: AppRadius.medium,
              borderSide: const BorderSide(
                color: AppColors.error,
                width: AppDimensions.borderWidth,
              ),
            ),
          ),
        ),
      ],
    );
  }
}