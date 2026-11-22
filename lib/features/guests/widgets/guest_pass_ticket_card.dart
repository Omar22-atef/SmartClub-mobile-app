import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';

class GuestPassTicketCard extends StatelessWidget {
  const GuestPassTicketCard({
    super.key,
    required this.guestName,
    required this.visitDate,
    this.passId = '#GP-9410-B',
    this.sponsorName = 'Alex Vance',
    this.sponsorId = '#SC-88294',
  });

  final String guestName;
  final String visitDate;
  final String passId;
  final String sponsorName;
  final String sponsorId;

  @override
  Widget build(BuildContext context) {
    final displayGuestName =
        guestName.trim().isEmpty ? 'Guest Name' : guestName.trim();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.spaceXs),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'LIVE INVITATION ARTIFACT',
                style: AppTextStyles.labelCaps.copyWith(
                  color: AppColors.textMuted,
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: AppSpacing.spaceSm,
                    height: AppSpacing.spaceSm,
                    decoration: const BoxDecoration(
                      color: AppColors.limeNeon,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.spaceXs),
                  Text(
                    'Encrypted Dynamic QR',
                    style: AppTextStyles.labelCaps.copyWith(
                      color: AppColors.secondaryFixedDim,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.itemSpacing),

        // Ticket Card
        Container(
          decoration: BoxDecoration(
            color: AppColors.surfaceDark,
            borderRadius: AppRadius.large,
            border: Border.fromBorderSide(AppEffects.darkHairline),
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: [
              // Lime Accent Top Rail
              Container(
                height: AppSpacing.spaceSm,
                width: double.infinity,
                color: AppColors.limeNeon,
              ),

              Padding(
                padding: const EdgeInsets.all(AppSpacing.spaceLg),
                child: Column(
                  children: [
                    // Pass Identity Row
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'SMART CLUB PROTOCOL',
                                style: AppTextStyles.labelCaps.copyWith(
                                  color: AppColors.limeNeon,
                                  letterSpacing: 1.2,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'ONE-DAY GUEST PASS',
                                style: AppTextStyles.headlineSmall.copyWith(
                                  color: AppColors.pureWhite,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: AppSpacing.spaceXs,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceDarkElevated,
                            borderRadius: AppRadius.pill,
                          ),
                          child: Text(
                            'TURNSTILE READY',
                            style: AppTextStyles.labelCaps.copyWith(
                              fontSize: 10,
                              color: AppColors.limeNeon,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.spaceMd),

                    // Credentials Matrix
                    Row(
                      children: [
                        Expanded(
                          child: _CredentialBox(
                            header: 'AUTHORIZED GUEST',
                            value: displayGuestName,
                            footer: 'ID: $passId',
                            footerColor: AppColors.textMuted,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.itemSpacing),
                        Expanded(
                          child: _CredentialBox(
                            header: 'CLUB SPONSOR',
                            value: sponsorName,
                            footer: sponsorId,
                            footerColor: AppColors.limeNeon,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.itemSpacing),

                    // Date Validity Row
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceDarkElevated.withValues(
                          alpha: 0.7,
                        ),
                        borderRadius: AppRadius.medium,
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.event_available,
                            color: AppColors.limeNeon,
                            size: 20,
                          ),
                          const SizedBox(width: AppSpacing.spaceSm),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'VALID ADMISSION DATE',
                                  style: AppTextStyles.labelCaps.copyWith(
                                    fontSize: 10,
                                    color: AppColors.textMuted,
                                  ),
                                ),
                                Text(
                                  visitDate,
                                  style: AppTextStyles.bodyMedium.copyWith(
                                    color: AppColors.pureWhite,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.spaceSm,
                              vertical: AppSpacing.spaceXs,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.limeNeon.withValues(alpha: 0.12),
                              borderRadius: AppRadius.small,
                            ),
                            child: Text(
                              'ALL DAY',
                              style: AppTextStyles.labelCaps.copyWith(
                                color: AppColors.limeNeon,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.spaceMd),

                    // Perforated Cut Visual Divider
                    SizedBox(
                      height: AppSpacing.spaceXl,
                      child: Stack(
                        clipBehavior: Clip.none,
                        alignment: Alignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.itemSpacing,
                            ),
                            child: CustomPaint(
                              size: const Size(double.infinity, 2),
                              painter: _DashedLinePainter(
                                color: AppColors.borderDarkHairline,
                              ),
                            ),
                          ),
                          Positioned(
                            left: -AppSpacing.spaceLg,
                            child: Container(
                              width: AppSpacing.spaceMd,
                              height: AppSpacing.spaceXl,
                              decoration: const BoxDecoration(
                                color: AppColors.surface,
                                borderRadius: BorderRadius.horizontal(
                                  right: Radius.circular(AppRadius.lg),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            right: -AppSpacing.spaceLg,
                            child: Container(
                              width: AppSpacing.spaceMd,
                              height: AppSpacing.spaceXl,
                              decoration: const BoxDecoration(
                                color: AppColors.surface,
                                borderRadius: BorderRadius.horizontal(
                                  left: Radius.circular(AppRadius.lg),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.spaceMd),

                    // Scannable High-Contrast QR Box
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(AppSpacing.spaceMd),
                      decoration: BoxDecoration(
                        color: AppColors.pureWhite,
                        borderRadius: AppRadius.medium,
                      ),
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(
                              AppDimensions.qrContainerPadding,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.surfaceLight,
                              borderRadius: AppRadius.standard,
                            ),
                            child: const SizedBox(
                              width: 176,
                              height: 176,
                              child: CustomPaint(
                                painter: _SmartClubQrPainter(),
                              ),
                            ),
                          ),
                          const SizedBox(height: AppSpacing.itemSpacing),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.itemSpacing,
                              vertical: AppSpacing.spaceXs,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.surfaceMuted,
                              borderRadius: AppRadius.pill,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.verified_user,
                                  size: 16,
                                  color: AppColors.secondary,
                                ),
                                const SizedBox(width: 6),
                                Flexible(
                                  child: Text(
                                    'Pass Verified • Ready for Turnstile',
                                    style: AppTextStyles.labelCaps.copyWith(
                                      color: AppColors.onSurface,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.spaceMd),

                    // Footer ID Requirement Note
                    Text(
                      'Guest must present valid government photo ID matching this pass name at the reception turnstile.',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.labelCaps.copyWith(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.2,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _CredentialBox extends StatelessWidget {
  const _CredentialBox({
    required this.header,
    required this.value,
    required this.footer,
    required this.footerColor,
  });

  final String header;
  final String value;
  final String footer;
  final Color footerColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.itemSpacing),
      decoration: BoxDecoration(
        color: AppColors.surfaceDarkElevated,
        borderRadius: AppRadius.medium,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            header,
            style: AppTextStyles.labelCaps.copyWith(
              color: AppColors.textMuted,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.labelLarge.copyWith(
              color: AppColors.pureWhite,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            footer,
            style: AppTextStyles.labelCaps.copyWith(
              fontSize: 10,
              color: footerColor,
            ),
          ),
        ],
      ),
    );
  }
}

class _DashedLinePainter extends CustomPainter {
  const _DashedLinePainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2;

    const dashWidth = 6.0;
    const dashSpace = 4.0;
    double startX = 0;
    while (startX < size.width) {
      canvas.drawLine(
        Offset(startX, size.height / 2),
        Offset(startX + dashWidth, size.height / 2),
        paint,
      );
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant _DashedLinePainter oldDelegate) =>
      oldDelegate.color != color;
}

class _SmartClubQrPainter extends CustomPainter {
  const _SmartClubQrPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final scale = size.width / 160.0;
    canvas.save();
    canvas.scale(scale, scale);

    final darkPaint = Paint()..color = AppColors.midnightBlack;
    final whitePaint = Paint()..color = AppColors.pureWhite;
    final limePaint = Paint()..color = AppColors.limeNeon;

    void drawFinder(double x, double y) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(x, y, 40, 40),
          const Radius.circular(4),
        ),
        darkPaint,
      );
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(x + 8, y + 8, 24, 24),
          const Radius.circular(2),
        ),
        whitePaint,
      );
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(x + 14, y + 14, 12, 12),
          const Radius.circular(1),
        ),
        darkPaint,
      );
    }

    drawFinder(10, 10);
    drawFinder(110, 10);
    drawFinder(10, 110);

    const modules = <List<double>>[
      [60, 12, 8, 8],
      [76, 12, 12, 8],
      [94, 24, 8, 14],
      [60, 28, 14, 8],
      [78, 32, 8, 16],
      [20, 60, 8, 12],
      [36, 66, 14, 8],
      [18, 84, 12, 8],
      [38, 80, 10, 16],
      [60, 58, 16, 16],
      [84, 58, 8, 8],
      [100, 62, 12, 8],
      [120, 60, 8, 14],
      [136, 70, 14, 8],
      [62, 82, 12, 14],
      [82, 76, 18, 8],
      [108, 80, 8, 18],
      [124, 88, 16, 10],
      [60, 104, 10, 10],
      [80, 100, 8, 16],
      [96, 112, 16, 8],
      [120, 110, 10, 10],
      [138, 106, 12, 8],
      [64, 128, 14, 8],
      [86, 126, 8, 14],
      [102, 132, 18, 8],
      [128, 128, 10, 12],
      [142, 124, 8, 16],
    ];

    for (final m in modules) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(m[0], m[1], m[2], m[3]),
          const Radius.circular(1),
        ),
        darkPaint,
      );
    }

    // Center Lime Brand Badge
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(68, 68, 24, 24),
        const Radius.circular(4),
      ),
      limePaint,
    );

    final checkPaint = Paint()
      ..color = AppColors.midnightBlack
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final path = Path()
      ..moveTo(75, 80)
      ..lineTo(79, 84)
      ..lineTo(85, 76);
    canvas.drawPath(path, checkPaint);

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}