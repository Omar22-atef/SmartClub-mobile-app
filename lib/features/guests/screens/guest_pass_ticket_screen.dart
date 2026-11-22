import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/constants/app_constants.dart';
import '../models/guest_pass_model.dart';
import '../widgets/guest_pass_ticket_card.dart';

class GuestPassTicketScreen extends StatefulWidget {
  const GuestPassTicketScreen({
    super.key,
    required this.record,
    this.isNewlyIssued = false,
  });

  final GuestPassRecord record;
  final bool isNewlyIssued;

  @override
  State<GuestPassTicketScreen> createState() => _GuestPassTicketScreenState();
}

class _GuestPassTicketScreenState extends State<GuestPassTicketScreen> {
  bool _isCopied = false;
  Timer? _copyResetTimer;

  @override
  void dispose() {
    _copyResetTimer?.cancel();
    super.dispose();
  }

  void _handleCopyLink() {
    final cleanId = widget.record.passCode.replaceAll('#', '');
    Clipboard.setData(
      ClipboardData(
        text:
            'https://smartclub.app/pass/$cleanId?guest=${Uri.encodeComponent(widget.record.guestName)}',
      ),
    );
    _copyResetTimer?.cancel();
    setState(() => _isCopied = true);
    _copyResetTimer = Timer(const Duration(milliseconds: 2200), () {
      if (mounted) setState(() => _isCopied = false);
    });
  }

  void _handleSharePass() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Prepared Smart Club One-Day Pass for ${widget.record.guestName} (${widget.record.visitDate}).',
        ),
      ),
    );
  }

  void _handleDownloadPdf() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Downloading encrypted Guest Pass PDF (${widget.record.passCode})...',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final record = widget.record;

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
          'Pass Details',
          style: AppTextStyles.headlineSmall.copyWith(
            color: AppColors.onSurface,
          ),
        ),
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
              if (widget.isNewlyIssued) ...[
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.spaceMd,
                    vertical: AppSpacing.itemSpacing,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.limeNeon.withValues(alpha: 0.22),
                    borderRadius: AppRadius.medium,
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.check_circle,
                        size: 20,
                        color: AppColors.secondary,
                      ),
                      const SizedBox(width: AppSpacing.spaceSm),
                      Expanded(
                        child: Text(
                          'Invitation generated. Share this QR pass with ${record.guestName}.',
                          style: AppTextStyles.labelMedium.copyWith(
                            color: AppColors.onSurface,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.spaceMd),
              ],

              // 1. Dynamic QR Pass Ticket Card
              GuestPassTicketCard(
                guestName: record.guestName,
                visitDate: record.visitDate,
                passId: record.passCode,
                sponsorName: record.sponsorName,
                sponsorId: record.sponsorId,
              ),
              const SizedBox(height: AppSpacing.spaceMd),

              // 2. Authorized Zones Summary Card
              Container(
                padding: const EdgeInsets.all(AppSpacing.cardPadding),
                decoration: BoxDecoration(
                  color: AppColors.surfaceLight,
                  borderRadius: AppRadius.medium,
                  border: Border.fromBorderSide(AppEffects.lightHairline),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'AUTHORIZED ZONES & CONTACT',
                      style: AppTextStyles.labelCaps.copyWith(
                        color: AppColors.textMuted,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.spaceSm),
                    Text(
                      record.contactInfo,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.onSurface,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.itemSpacing),
                    Wrap(
                      spacing: AppSpacing.spaceSm,
                      runSpacing: AppSpacing.spaceSm,
                      children: record.clearedZones.map((zone) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceMuted,
                            borderRadius: AppRadius.pill,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.check,
                                size: 14,
                                color: AppColors.secondary,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                zone,
                                style: AppTextStyles.labelMedium.copyWith(
                                  color: AppColors.onSurface,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.sectionSpacing),

              // 3. Primary & Secondary Share Actions
              Container(
                height: AppDimensions.primaryButtonHeight,
                decoration: BoxDecoration(
                  borderRadius: AppRadius.pill,
                  boxShadow: AppEffects.limeActiveGlow,
                ),
                child: ElevatedButton.icon(
                  onPressed: _handleSharePass,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.limeNeon,
                    foregroundColor: AppColors.surfaceDark,
                    shape: RoundedRectangleBorder(
                      borderRadius: AppRadius.pill,
                    ),
                    elevation: 0,
                  ),
                  icon: const Icon(Icons.share, size: 20),
                  label: Text(
                    'SHARE VIA WHATSAPP / MESSAGES',
                    style: AppTextStyles.labelLarge.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppColors.surfaceDark,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.itemSpacing),

              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: AppDimensions.inputHeight,
                      child: ElevatedButton.icon(
                        onPressed: _handleCopyLink,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.surfaceDark,
                          foregroundColor: AppColors.pureWhite,
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.itemSpacing,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: AppRadius.medium,
                          ),
                          elevation: 0,
                        ),
                        icon: const Icon(Icons.content_copy, size: 18),
                        label: Text(
                          _isCopied ? 'Copied!' : 'Copy Link',
                          style: AppTextStyles.labelLarge.copyWith(
                            color: AppColors.pureWhite,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.itemSpacing),
                  Expanded(
                    child: SizedBox(
                      height: AppDimensions.inputHeight,
                      child: ElevatedButton.icon(
                        onPressed: _handleDownloadPdf,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.surfaceLight,
                          foregroundColor: AppColors.onSurface,
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.itemSpacing,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: AppRadius.medium,
                            side: AppEffects.lightHairline,
                          ),
                          elevation: 0,
                        ),
                        icon: const Icon(Icons.download, size: 18),
                        label: Text(
                          'Download PDF',
                          style: AppTextStyles.labelLarge.copyWith(
                            color: AppColors.onSurface,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}