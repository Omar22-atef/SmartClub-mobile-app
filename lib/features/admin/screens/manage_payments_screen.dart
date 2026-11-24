import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../data/admin_mock_data.dart';
import '../widgets/admin_common_widgets.dart';

class ManagePaymentsScreen extends StatefulWidget {
  const ManagePaymentsScreen({super.key});

  @override
  State<ManagePaymentsScreen> createState() => _ManagePaymentsScreenState();
}

class _ManagePaymentsScreenState extends State<ManagePaymentsScreen> {
  final List<Map<String, dynamic>> _payments = AdminMockData.payments.map((m) => Map<String, dynamic>.from(m)).toList();
  String _query = '';
  String _filter = 'All';

  num _sum(String status) => _payments.where((p) => p['status'] == status).fold<num>(0, (a, p) => a + (p['amount'] as num));

  List<Map<String, dynamic>> get _filtered {
    final q = _query.toLowerCase();
    return _payments.where((p) {
      final matches = q.isEmpty || p['member'].toString().toLowerCase().contains(q) || p['id'].toString().toLowerCase().contains(q);
      return matches && (_filter == 'All' || p['status'] == _filter);
    }).toList();
  }

  void _details(Map<String, dynamic> p) {
    showDetailsSheet(
      context,
      title: '\$${p['amount']}',
      status: p['status'],
      rows: {'Payment ID': p['id'], 'Member': p['member'], 'Type': p['type'], 'Date': p['date']},
    );
  }

  @override
  Widget build(BuildContext context) {
    final list = _filtered;
    return AdminScaffold(
      eyebrow: '${_payments.length} transactions',
      title: 'Manage Payments',
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
        children: [
          Row(
            children: [
              Expanded(
                child: AdminCard(
                  dark: true,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Collected', style: TextStyle(color: AppColors.textMuted, fontSize: 12, fontWeight: FontWeight.w600)),
                      const SizedBox(height: 6),
                      Text('\$${_sum('Paid')}', style: const TextStyle(color: AppColors.limeNeon, fontSize: 24, fontWeight: FontWeight.w700)),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: AdminCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Pending', style: TextStyle(color: AppColors.onSurfaceVariant, fontSize: 12, fontWeight: FontWeight.w600)),
                      const SizedBox(height: 6),
                      Text('\$${_sum('Pending')}', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700)),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          AdminSearchField(hint: 'Search member or payment ID', onChanged: (v) => setState(() => _query = v)),
          const SizedBox(height: 12),
          FilterChipsRow(
            options: const ['All', 'Paid', 'Pending', 'Refunded'],
            selected: _filter,
            onSelected: (v) => setState(() => _filter = v),
          ),
          const SizedBox(height: 12),
          if (list.isEmpty) const AdminEmptyState(message: 'No payments found'),
          for (final p in list)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: AdminCard(
                onTap: () => _details(p),
                child: Row(
                  children: [
                    IconBox(p['status'] == 'Refunded' ? Icons.undo : Icons.receipt_long_outlined, dark: false),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(p['member'], style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
                          Text('${p['type']} • ${p['date']}',
                              maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: AppColors.onSurfaceVariant, fontSize: 12)),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('\$${p['amount']}', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
                        const SizedBox(height: 4),
                        StatusChip(p['status'], tone: p['status'] == 'Refunded' ? ChipTone.neutral : null),
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