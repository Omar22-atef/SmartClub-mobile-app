import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../core/constants/app_constants.dart';
import '../data/admin_mock_data.dart';

/// Shared white card with a title/subtitle used by every chart.
class _ChartCard extends StatelessWidget {
  const _ChartCard({
    required this.title,
    required this.subtitle,
    required this.child,
    this.dark = false,
  });

  final String title;
  final String subtitle;
  final Widget child;
  final bool dark;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: dark ? AppColors.midnightBlack : AppColors.pureWhite,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: dark ? AppColors.pureWhite : AppColors.midnightBlack,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}

/// Animated gradient line chart: revenue per month.
class RevenueLineChart extends StatelessWidget {
  const RevenueLineChart({super.key});

  @override
  Widget build(BuildContext context) {
    return _ChartCard(
      dark: true,
      title: 'Revenue',
      subtitle: 'Last 6 months',
      child: SizedBox(
        height: 180,
        child: TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: 1),
          duration: const Duration(milliseconds: 1000),
          curve: Curves.easeOutCubic,
          builder: (context, t, _) => CustomPaint(
            size: Size.infinite,
            painter: _LinePainter(
              labels: AdminMockData.revenueMonths,
              values: AdminMockData.revenueValues,
              progress: t,
            ),
          ),
        ),
      ),
    );
  }
}

class _LinePainter extends CustomPainter {
  _LinePainter({
    required this.labels,
    required this.values,
    required this.progress,
  });

  final List<String> labels;
  final List<double> values;
  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    const bottomPad = 22.0;
    const topPad = 8.0;
    final chartH = size.height - bottomPad - topPad;
    final maxV = values.reduce(math.max) * 1.15;
    final minV = values.reduce(math.min) * 0.7;

    final grid = Paint()
      ..color = Colors.white.withValues(alpha: 0.08)
      ..strokeWidth = 1;
    for (var i = 0; i < 4; i++) {
      final y = topPad + chartH * i / 3;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), grid);
    }

    final stepX = size.width / (values.length - 1);
    final points = <Offset>[
      for (var i = 0; i < values.length; i++)
        Offset(
          i * stepX,
          topPad +
              chartH -
              ((values[i] - minV) / (maxV - minV)) * chartH * progress,
        ),
    ];

    // Smooth curve through the points
    final line = Path()..moveTo(points.first.dx, points.first.dy);
    for (var i = 0; i < points.length - 1; i++) {
      final p0 = points[i];
      final p1 = points[i + 1];
      final cx = (p0.dx + p1.dx) / 2;
      line.cubicTo(cx, p0.dy, cx, p1.dy, p1.dx, p1.dy);
    }

    final area = Path.from(line)
      ..lineTo(points.last.dx, topPad + chartH)
      ..lineTo(points.first.dx, topPad + chartH)
      ..close();

    canvas.drawPath(
      area,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.limeNeon.withValues(alpha: 0.35),
            AppColors.limeNeon.withValues(alpha: 0.0),
          ],
        ).createShader(Rect.fromLTWH(0, 0, size.width, size.height)),
    );

    canvas.drawPath(
      line,
      Paint()
        ..color = AppColors.limeNeon
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3
        ..strokeCap = StrokeCap.round,
    );

    for (final p in points) {
      canvas.drawCircle(p, 5, Paint()..color = AppColors.midnightBlack);
      canvas.drawCircle(
        p,
        5,
        Paint()
          ..color = AppColors.limeNeon
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.5,
      );
    }

    for (var i = 0; i < labels.length; i++) {
      final tp = TextPainter(
        text: TextSpan(
          text: labels[i],
          style: const TextStyle(color: AppColors.textMuted, fontSize: 11),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      final x = (i * stepX - tp.width / 2).clamp(0.0, size.width - tp.width);
      tp.paint(canvas, Offset(x, size.height - tp.height));
    }
  }

  @override
  bool shouldRepaint(covariant _LinePainter old) => old.progress != progress;
}

/// Rounded bar chart: bookings per weekday, busiest day highlighted in lime.
class BookingsBarChart extends StatelessWidget {
  const BookingsBarChart({super.key});

  @override
  Widget build(BuildContext context) {
    final values = AdminMockData.bookingValues;
    final labels = AdminMockData.bookingDays;
    final maxV = values.reduce(math.max);

    return _ChartCard(
      title: 'Bookings',
      subtitle: 'This week',
      child: SizedBox(
        height: 160,
        child: TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: 1),
          duration: const Duration(milliseconds: 900),
          curve: Curves.easeOutCubic,
          builder: (context, t, _) => Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              for (var i = 0; i < values.length; i++)
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          values[i].toInt().toString(),
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: AppColors.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          height: 100 * (values[i] / maxV) * t,
                          decoration: BoxDecoration(
                            color: values[i] == maxV
                                ? AppColors.limeNeon
                                : AppColors.midnightBlack,
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          labels[i],
                          style: const TextStyle(
                            fontSize: 11,
                            color: AppColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Donut chart: members per plan with a legend.
class MembershipDonutChart extends StatelessWidget {
  const MembershipDonutChart({super.key});

  static const List<Color> _colors = [
    Color(0xFFB08D57), // Bronze
    Color(0xFF9AA0A6), // Silver
    AppColors.limeNeon, // Gold
    AppColors.midnightBlack, // Platinum
  ];

  @override
  Widget build(BuildContext context) {
    final data = AdminMockData.planDistribution;
    final total = data.values.fold<double>(0, (a, b) => a + b);
    final names = data.keys.toList();

    return _ChartCard(
      title: 'Members by plan',
      subtitle: 'All active subscriptions',
      child: Row(
        children: [
          SizedBox(
            width: 130,
            height: 130,
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: 1),
              duration: const Duration(milliseconds: 1000),
              curve: Curves.easeOutCubic,
              builder: (context, t, _) => CustomPaint(
                painter: _DonutPainter(
                  values: data.values.toList(),
                  colors: _colors,
                  progress: t,
                ),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        total.toInt().toString(),
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const Text(
                        'members',
                        style: TextStyle(
                          fontSize: 11,
                          color: AppColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              children: [
                for (var i = 0; i < names.length; i++)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      children: [
                        Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            color: _colors[i],
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            names[i],
                            style: const TextStyle(fontSize: 13),
                          ),
                        ),
                        Text(
                          '${(data[names[i]]! / total * 100).round()}%',
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
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

class _DonutPainter extends CustomPainter {
  _DonutPainter({
    required this.values,
    required this.colors,
    required this.progress,
  });

  final List<double> values;
  final List<Color> colors;
  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    const stroke = 18.0;
    const gap = 0.04;
    final rect = Rect.fromLTWH(
      stroke / 2,
      stroke / 2,
      size.width - stroke,
      size.height - stroke,
    );
    final total = values.fold<double>(0, (a, b) => a + b);
    var start = -math.pi / 2;

    for (var i = 0; i < values.length; i++) {
      final sweep = (values[i] / total) * 2 * math.pi * progress;
      canvas.drawArc(
        rect,
        start + gap / 2,
        math.max(0.0, sweep - gap),
        false,
        Paint()
          ..color = colors[i]
          ..style = PaintingStyle.stroke
          ..strokeWidth = stroke
          ..strokeCap = StrokeCap.round,
      );
      start += sweep;
    }
  }

  @override
  bool shouldRepaint(covariant _DonutPainter old) => old.progress != progress;
}