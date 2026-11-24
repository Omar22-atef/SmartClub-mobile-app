import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../data/admin_mock_data.dart';
import '../widgets/admin_common_widgets.dart';

class ManageBookingsScreen extends StatefulWidget {
  const ManageBookingsScreen({super.key});

  @override
  State<ManageBookingsScreen> createState() => _ManageBookingsScreenState();
}

class _ManageBookingsScreenState extends State<ManageBookingsScreen> {
  final List<Map<String, dynamic>> _bookings =
      AdminMockData.bookings.map((m) => Map<String, dynamic>.from(m)).toList();
  String _query = '';
  String _filter = 'All';

  List<Map<String, dynamic>> get _filtered {
    final q = _query.toLowerCase();
    return _bookings.where((b) {
      final matches = q.isEmpty ||
          b['facility'].toString().toLowerCase().contains(q) ||
          b['member'].toString().toLowerCase().contains(q) ||
          b['id'].toString().toLowerCase().contains(q);
      return matches && (_filter == 'All' || b['status'] == _filter);
    }).toList();
  }

  Future<void> _cancel(Map<String, dynamic> b) async {
    final ok = await showConfirmDialog(
      context,
      title: 'Cancel booking?',
      message: '${b['id']} for ${b['member']} will be cancelled.',
      confirmLabel: 'Cancel booking',
      danger: true,
    );
    if (ok != true || !mounted) return;
    setState(() => b['status'] = 'Cancelled');
    showAdminSnack(context, 'Booking ${b['id']} cancelled');
  }

  void _details(Map<String, dynamic> b) {
    showDetailsSheet(
      context,
      title: b['facility'],
      status: b['status'],
      rows: {
        'Booking ID': b['id'],
        'Member': b['member'],
        'Date': b['date'],
        'Time slot': b['slot'],
        'Price': '\$${b['price']}',
      },
      actions: [
        if (b['status'] == 'Upcoming')
          AdminPrimaryButton(
            label: 'Cancel Booking',
            icon: Icons.event_busy_outlined,
            outlined: true,
            danger: true,
            onPressed: () {
              Navigator.pop(context);
              _cancel(b);
            },
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final list = _filtered;
    return AdminScaffold(
      eyebrow: '${_bookings.length} records',
      title: 'Manage Bookings',
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
        children: [
          AdminSearchField(hint: 'Search facility, member or ID', onChanged: (v) => setState(() => _query = v)),
          const SizedBox(height: 12),
          FilterChipsRow(
            options: const ['All', 'Upcoming', 'Completed', 'Cancelled'],
            selected: _filter,
            onSelected: (v) => setState(() => _filter = v),
          ),
          const SizedBox(height: 12),
          if (list.isEmpty) const AdminEmptyState(message: 'No bookings found'),
          for (final b in list)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: AdminCard(
                onTap: () => _details(b),
                child: Row(
                  children: [
                    IconBox(iconForFacility(b['facility']), dark: false),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(b['facility'], style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
                          const SizedBox(height: 2),
                          Text('${b['member']} • ${b['slot']}',
                              maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: AppColors.onSurfaceVariant, fontSize: 12)),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        StatusChip(b['status']),
                        const SizedBox(height: 6),
                        Text('\$${b['price']}', style: const TextStyle(fontWeight: FontWeight.w700)),
                      ],
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