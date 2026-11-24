import 'package:flutter/material.dart';

import '../../../core/constants/app_constants.dart';

/// Every admin area. Screens are wired to these values later (dashboard step),
/// so this file does not import any screen.
enum AdminSection {
  dashboard('Dashboard', 'Club overview', Icons.dashboard_outlined),
  members('Manage Members', 'Directory & status', Icons.manage_accounts_outlined),
  guests('Guest Invitations', 'Invites & entries', Icons.qr_code_scanner),
  bookings('Manage Bookings', 'Courts & schedules', Icons.event_available_outlined),
  subscriptions('Subscriptions', 'Plans & renewals', Icons.card_membership_outlined),
  payments('Manage Payments', 'Transactions', Icons.payments_outlined),
  events('Manage Events', 'Create & edit', Icons.celebration_outlined),
  facilities('Manage Facilities', 'Clubhouse status', Icons.stadium_outlined);

  const AdminSection(this.title, this.subtitle, this.icon);

  final String title;
  final String subtitle;
  final IconData icon;

  /// Sections shown in the Quick Management grid on the dashboard.
  static const List<AdminSection> manageable = [
    members,
    guests,
    bookings,
    subscriptions,
    payments,
    events,
    facilities,
  ];

  /// Sections that live behind the "More" tab of the bottom bar.
  static const List<AdminSection> overflow = [
    guests,
    subscriptions,
    events,
    facilities,
  ];
}

/// Bottom bar for the admin area: Home, Members, Bookings, Payments, More.
/// Black bar with lime highlight, matching the app theme.
class AdminNavigation extends StatelessWidget {
  const AdminNavigation({
    super.key,
    required this.current,
    required this.onSelected,
  });

  final AdminSection current;
  final ValueChanged<AdminSection> onSelected;

  static const Color _unselected = Color(0xB3FFFFFF);

  Future<void> _openMore(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (final section in AdminSection.overflow)
                ListTile(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  selected: section == current,
                  selectedTileColor: AppColors.surfaceContainerLow,
                  leading: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.midnightBlack,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      section.icon,
                      size: 20,
                      color: AppColors.limeNeon,
                    ),
                  ),
                  title: Text(
                    section.title,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text(
                    section.subtitle,
                    style: const TextStyle(color: AppColors.textMuted),
                  ),
                  trailing: const Icon(
                    Icons.chevron_right,
                    color: AppColors.textMuted,
                  ),
                  onTap: () {
                    Navigator.pop(sheetContext);
                    onSelected(section);
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool moreSelected = AdminSection.overflow.contains(current);

    return Container(
      color: AppColors.midnightBlack,
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 64,
          child: Row(
            children: [
              _NavItem(
                icon: Icons.dashboard_outlined,
                label: 'Home',
                selected: current == AdminSection.dashboard,
                onTap: () => onSelected(AdminSection.dashboard),
              ),
              _NavItem(
                icon: Icons.group_outlined,
                label: 'Members',
                selected: current == AdminSection.members,
                onTap: () => onSelected(AdminSection.members),
              ),
              _NavItem(
                icon: Icons.event_available_outlined,
                label: 'Bookings',
                selected: current == AdminSection.bookings,
                onTap: () => onSelected(AdminSection.bookings),
              ),
              _NavItem(
                icon: Icons.payments_outlined,
                label: 'Payments',
                selected: current == AdminSection.payments,
                onTap: () => onSelected(AdminSection.payments),
              ),
              _NavItem(
                icon: Icons.grid_view_rounded,
                label: 'More',
                selected: moreSelected,
                onTap: () => _openMore(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final Color color =
        selected ? AppColors.limeNeon : AdminNavigation._unselected;

    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 24, color: color),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                color: color,
              ),
            ),
            const SizedBox(height: 2),
            // Small lime dot under the active item
            AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              width: selected ? 16 : 0,
              height: 3,
              decoration: BoxDecoration(
                color: AppColors.limeNeon,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
