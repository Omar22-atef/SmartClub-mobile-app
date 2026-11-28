import 'package:flutter/material.dart';

import '../../../core/constants/app_constants.dart';
import '../data/admin_mock_data.dart';
import '../widgets/admin_common_widgets.dart';
import '../widgets/admin_navigation.dart';
import '../widgets/dashboard_charts.dart';
import '../widgets/dashboard_stat_card.dart';
import 'manage_bookings_screen.dart';
import 'manage_events_screen.dart';
import 'manage_facilities_screen.dart';
import 'manage_guests_screen.dart';
import 'manage_members_screen.dart';
import 'manage_payments_screen.dart';
import 'manage_subscriptions_screen.dart';

/// Maps each admin section to its screen.
Widget _screenFor(AdminSection section) {
  switch (section) {
    case AdminSection.dashboard:
      return const AdminDashboardScreen();
    case AdminSection.members:
      return const ManageMembersScreen();
    case AdminSection.guests:
      return const ManageGuestsScreen();
    case AdminSection.bookings:
      return const ManageBookingsScreen();
    case AdminSection.subscriptions:
      return const ManageSubscriptionsScreen();
    case AdminSection.payments:
      return const ManagePaymentsScreen();
    case AdminSection.events:
      return const ManageEventsScreen();
    case AdminSection.facilities:
      return const ManageFacilitiesScreen();
  }
}

void _openSection(BuildContext context, AdminSection section) {
  if (section == AdminSection.dashboard) return;
  Navigator.of(context).push(
    MaterialPageRoute(builder: (_) => _screenFor(section)),
  );
}

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final stats = AdminMockData.stats;

    return AdminScaffold(
      eyebrow: 'Smart Club Operations',
      title: 'Admin Console',
      actions: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.midnightBlack,
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Row(
            children: [
              Icon(Icons.circle, size: 8, color: AppColors.limeNeon),
              SizedBox(width: 6),
              Text(
                'LIVE',
                style: TextStyle(
                  color: AppColors.limeNeon,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
      bottomNavigationBar: AdminNavigation(
        current: AdminSection.dashboard,
        onSelected: (section) => _openSection(context, section),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          GridView(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              mainAxisExtent: 124,
            ),
            children: [
              DashboardStatCard(
                label: 'Total Members',
                value: stats['totalMembers']!,
                icon: Icons.group_outlined,
                caption: '+12% this mo',
                captionIcon: Icons.trending_up,
                onTap: () => _openSection(context, AdminSection.members),
              ),
              DashboardStatCard(
                label: 'Active Members',
                value: stats['activeMembers']!,
                icon: Icons.badge_outlined,
                caption: '94.5% active rate',
                onTap: () => _openSection(context, AdminSection.members),
              ),
              DashboardStatCard(
                label: 'Expired',
                value: stats['expiredMemberships']!,
                icon: Icons.event_busy_outlined,
                caption: 'Memberships',
                onTap: () => _openSection(context, AdminSection.subscriptions),
              ),
              DashboardStatCard(
                label: 'Total Bookings',
                value: stats['totalBookings']!,
                icon: Icons.calendar_today_outlined,
                caption: '64 today',
                onTap: () => _openSection(context, AdminSection.bookings),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 124,
            child: DashboardStatCard(
              dark: true,
              label: 'Total Payments',
              value: stats['totalPayments']!,
              icon: Icons.payments_outlined,
              caption: 'On target',
              captionIcon: Icons.arrow_upward,
              onTap: () => _openSection(context, AdminSection.payments),
            ),
          ),
          const SizedBox(height: 24),
          const _SectionLabel('Analytics'),
          const SizedBox(height: 8),
          const RevenueLineChart(),
          const SizedBox(height: 12),
          const BookingsBarChart(),
          const SizedBox(height: 12),
          const MembershipDonutChart(),
          const SizedBox(height: 24),
          const _SectionLabel('Quick Management'),
          const SizedBox(height: 8),
          GridView(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              mainAxisExtent: 72,
            ),
            children: [
              for (final section in AdminSection.manageable)
                _QuickTile(
                  section: section,
                  lime: section == AdminSection.guests,
                  onTap: () => _openSection(context, section),
                ),
            ],
          ),
          const SizedBox(height: 24),
          const _SectionLabel('Recent Activity'),
          const SizedBox(height: 8),
          for (final item in AdminMockData.activity)
            Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: AdminCard(
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: item['tag'] == 'PAID'
                            ? AppColors.midnightBlack
                            : AppColors.surfaceContainer,
                      ),
                      child: Icon(
                        item['icon'] as IconData,
                        size: 20,
                        color: item['tag'] == 'PAID'
                            ? AppColors.limeNeon
                            : AppColors.midnightBlack,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item['title'] as String,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            item['sub'] as String,
                            style: const TextStyle(
                              color: AppColors.onSurfaceVariant,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    StatusChip(
                      item['tag'] as String,
                      tone: item['tag'] == 'PAID'
                          ? ChipTone.success
                          : ChipTone.neutral,
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text.toUpperCase(),
      style: const TextStyle(
        fontSize: 11,
        letterSpacing: 1.2,
        fontWeight: FontWeight.w700,
        color: AppColors.onSurfaceVariant,
      ),
    );
  }
}

class _QuickTile extends StatelessWidget {
  const _QuickTile({
    required this.section,
    required this.onTap,
    this.lime = false,
  });

  final AdminSection section;
  final VoidCallback onTap;
  final bool lime;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surfaceContainerLow,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            children: [
              IconBox(section.icon, lime: lime, size: 40),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      section.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                    Text(
                      section.subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColors.onSurfaceVariant,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}