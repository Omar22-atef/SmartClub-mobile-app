import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../data/admin_mock_data.dart';
import '../widgets/admin_common_widgets.dart';

class ManageMembersScreen extends StatefulWidget {
  const ManageMembersScreen({super.key});

  @override
  State<ManageMembersScreen> createState() => _ManageMembersScreenState();
}

class _ManageMembersScreenState extends State<ManageMembersScreen> {
  final List<Map<String, dynamic>> _members =
      AdminMockData.members.map((m) => Map<String, dynamic>.from(m)).toList();
  String _query = '';
  String _filter = 'All';

  List<Map<String, dynamic>> get _filtered {
    final q = _query.toLowerCase();
    return _members.where((m) {
      final matches = q.isEmpty ||
          m['name'].toString().toLowerCase().contains(q) ||
          m['id'].toString().toLowerCase().contains(q) ||
          m['email'].toString().toLowerCase().contains(q);
      return matches && (_filter == 'All' || m['status'] == _filter);
    }).toList();
  }

  Future<void> _toggle(Map<String, dynamic> m) async {
    final suspend = m['status'] == 'Active';
    final ok = await showConfirmDialog(
      context,
      title: suspend ? 'Suspend membership?' : 'Activate membership?',
      message: suspend
          ? '${m['name']} will lose access to club facilities.'
          : '${m['name']} will regain access to club facilities.',
      confirmLabel: suspend ? 'Suspend' : 'Activate',
      danger: suspend,
    );
    if (ok != true || !mounted) return;
    setState(() => m['status'] = suspend ? 'Suspended' : 'Active');
    showAdminSnack(context, '${m['name']} ${suspend ? 'suspended' : 'activated'}');
  }

  void _details(Map<String, dynamic> m) {
    final active = m['status'] == 'Active';
    showDetailsSheet(
      context,
      title: m['name'],
      status: m['status'],
      rows: {
        'Member ID': m['id'],
        'Email': m['email'],
        'Plan': m['plan'],
        'Expires': m['expiry'],
      },
      actions: [
        AdminPrimaryButton(
          label: active ? 'Suspend Membership' : 'Activate Membership',
          icon: active ? Icons.block : Icons.check_circle_outline,
          outlined: active,
          danger: active,
          onPressed: () {
            Navigator.pop(context);
            _toggle(m);
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final list = _filtered;
    return AdminScaffold(
      eyebrow: '${_members.length} members',
      title: 'Manage Members',
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
        children: [
          AdminSearchField(hint: 'Search by name, ID or email', onChanged: (v) => setState(() => _query = v)),
          const SizedBox(height: 12),
          FilterChipsRow(
            options: const ['All', 'Active', 'Suspended', 'Expired'],
            selected: _filter,
            onSelected: (v) => setState(() => _filter = v),
          ),
          const SizedBox(height: 12),
          if (list.isEmpty) const AdminEmptyState(message: 'No members match your search'),
          for (final m in list)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: AdminCard(
                onTap: () => _details(m),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 22,
                      backgroundColor: AppColors.midnightBlack,
                      child: Text(
                        (m['name'] as String).split(' ').map((p) => p[0]).take(2).join(),
                        style: const TextStyle(color: AppColors.limeNeon, fontWeight: FontWeight.w700),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(m['name'], style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
                          const SizedBox(height: 2),
                          Text('${m['id']} • ${m['plan']}', style: const TextStyle(color: AppColors.onSurfaceVariant, fontSize: 12)),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        StatusChip(m['status']),
                        const SizedBox(height: 6),
                        InkWell(
                          onTap: () => _toggle(m),
                          child: Text(
                            m['status'] == 'Active' ? 'Suspend' : 'Activate',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: m['status'] == 'Active' ? AppColors.error : AppColors.secondary,
                            ),
                          ),
                        ),
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