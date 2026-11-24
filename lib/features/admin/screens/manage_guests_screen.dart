import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../data/admin_mock_data.dart';
import '../widgets/admin_common_widgets.dart';

class ManageGuestsScreen extends StatefulWidget {
  const ManageGuestsScreen({super.key});

  @override
  State<ManageGuestsScreen> createState() => _ManageGuestsScreenState();
}

class _ManageGuestsScreenState extends State<ManageGuestsScreen> {
  final List<Map<String, dynamic>> _guests =
      AdminMockData.guests.map((m) => Map<String, dynamic>.from(m)).toList();
  String _query = '';
  String _filter = 'All';

  List<Map<String, dynamic>> get _filtered {
    final q = _query.toLowerCase();
    return _guests.where((g) {
      final matches = q.isEmpty ||
          g['name'].toString().toLowerCase().contains(q) ||
          g['invitedBy'].toString().toLowerCase().contains(q);
      return matches && (_filter == 'All' || g['status'] == _filter);
    }).toList();
  }

  void _details(Map<String, dynamic> g) {
    final pending = g['status'] == 'Pending';
    showDetailsSheet(
      context,
      title: g['name'],
      status: g['status'],
      rows: {'Invited by': g['invitedBy'], 'Visit date': g['date']},
      actions: [
        if (pending)
          AdminPrimaryButton(
            label: 'Cancel Invitation',
            icon: Icons.cancel_outlined,
            outlined: true,
            danger: true,
            onPressed: () {
              Navigator.pop(context);
              setState(() => g['status'] = 'Cancelled');
              showAdminSnack(context, 'Invitation cancelled');
            },
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final list = _filtered;
    return AdminScaffold(
      eyebrow: '${_guests.length} invitations',
      title: 'Guest Invitations',
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
        children: [
          AdminSearchField(hint: 'Search guest or host', onChanged: (v) => setState(() => _query = v)),
          const SizedBox(height: 12),
          FilterChipsRow(
            options: const ['All', 'Pending', 'Checked In', 'Expired', 'Cancelled'],
            selected: _filter,
            onSelected: (v) => setState(() => _filter = v),
          ),
          const SizedBox(height: 12),
          if (list.isEmpty) const AdminEmptyState(message: 'No invitations found'),
          for (final g in list)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: AdminCard(
                onTap: () => _details(g),
                child: Row(
                  children: [
                    const IconBox(Icons.qr_code_2, lime: true),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(g['name'], style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
                          const SizedBox(height: 2),
                          Text('Invited by ${g['invitedBy']} • ${g['date']}',
                              maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: AppColors.onSurfaceVariant, fontSize: 12)),
                        ],
                      ),
                    ),
                    StatusChip(g['status']),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}