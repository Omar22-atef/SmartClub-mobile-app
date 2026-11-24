import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../data/admin_mock_data.dart';
import '../widgets/admin_common_widgets.dart';

class ManageSubscriptionsScreen extends StatefulWidget {
  const ManageSubscriptionsScreen({super.key});

  @override
  State<ManageSubscriptionsScreen> createState() => _ManageSubscriptionsScreenState();
}

class _ManageSubscriptionsScreenState extends State<ManageSubscriptionsScreen> with SingleTickerProviderStateMixin {
  late final TabController _tabs = TabController(length: 2, vsync: this)..addListener(() => setState(() {}));
  final List<Map<String, dynamic>> _plans = AdminMockData.plans.map((m) => Map<String, dynamic>.from(m)).toList();
  final List<Map<String, dynamic>> _subs = AdminMockData.members.map((m) => Map<String, dynamic>.from(m)).toList();

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  List<FormFieldSpec> _planFields([Map<String, dynamic>? p]) => [
        FormFieldSpec('name', 'Plan name', initial: p?['name'] ?? ''),
        FormFieldSpec('price', 'Price (\$)', initial: '${p?['price'] ?? ''}', keyboard: TextInputType.number),
        FormFieldSpec('duration', 'Duration (e.g. 3 months)', initial: p?['duration'] ?? ''),
        FormFieldSpec('perks', 'Benefits', initial: p?['perks'] ?? '', maxLines: 2),
      ];

  Future<void> _editPlan([Map<String, dynamic>? plan]) async {
    final r = await showAdminFormSheet(
      context,
      title: plan == null ? 'New Membership Plan' : 'Edit ${plan['name']}',
      fields: _planFields(plan),
      submitLabel: plan == null ? 'Create Plan' : 'Save Changes',
    );
    if (r == null || !mounted) return;
    setState(() {
      final data = {
        'name': r['name'],
        'price': int.tryParse(r['price']!) ?? 0,
        'duration': r['duration'],
        'perks': r['perks'],
      };
      if (plan == null) {
        _plans.add({...data, 'active': true});
      } else {
        plan.addAll(data);
      }
    });
    showAdminSnack(context, plan == null ? 'Plan created' : 'Plan updated');
  }

  @override
  Widget build(BuildContext context) {
    return AdminScaffold(
      eyebrow: 'Plans & renewals',
      title: 'Subscriptions',
      floatingActionButton: _tabs.index == 0
          ? FloatingActionButton.extended(
              onPressed: () => _editPlan(),
              icon: const Icon(Icons.add),
              label: const Text('New Plan', style: TextStyle(fontWeight: FontWeight.w700)),
            )
          : null,
      body: Column(
        children: [
          TabBar(
            controller: _tabs,
            labelColor: AppColors.midnightBlack,
            unselectedLabelColor: AppColors.textMuted,
            indicatorColor: AppColors.midnightBlack,
            labelStyle: const TextStyle(fontWeight: FontWeight.w700),
            tabs: const [Tab(text: 'Membership Plans'), Tab(text: 'Subscriptions')],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabs,
              children: [_plansTab(), _subsTab()],
            ),
          ),
        ],
      ),
    );
  }

  Widget _plansTab() {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
      children: [
        for (final p in _plans)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: AdminCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const IconBox(Icons.card_membership_outlined),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(p['name'], style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
                            Text('${p['duration']}', style: const TextStyle(color: AppColors.onSurfaceVariant, fontSize: 12)),
                          ],
                        ),
                      ),
                      Text('\$${p['price']}', style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 20)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(p['perks'], style: const TextStyle(color: AppColors.onSurfaceVariant, fontSize: 13)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      StatusChip(p['active'] ? 'Active' : 'Suspended', tone: p['active'] ? ChipTone.success : ChipTone.neutral),
                      const Spacer(),
                      TextButton.icon(
                        onPressed: () => _editPlan(p),
                        icon: const Icon(Icons.edit_outlined, size: 16),
                        label: const Text('Edit'),
                        style: TextButton.styleFrom(foregroundColor: AppColors.midnightBlack),
                      ),
                      Switch(
                        value: p['active'],
                        thumbColor: const WidgetStatePropertyAll(AppColors.midnightBlack),
                        activeTrackColor: AppColors.limeNeon,
                        inactiveTrackColor: AppColors.surfaceContainer,
                        trackOutlineColor: const WidgetStatePropertyAll(Colors.transparent),
                        onChanged: (v) => setState(() => p['active'] = v),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget _subsTab() {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      children: [
        for (final s in _subs)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: AdminCard(
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 22,
                    backgroundColor: AppColors.surfaceContainer,
                    child: Text((s['name'] as String)[0], style: const TextStyle(fontWeight: FontWeight.w700)),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(s['name'], style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
                        Text('${s['plan']} • ends ${s['expiry']}', style: const TextStyle(color: AppColors.onSurfaceVariant, fontSize: 12)),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      StatusChip(s['status']),
                      if (s['status'] == 'Expired') ...[
                        const SizedBox(height: 6),
                        InkWell(
                          onTap: () {
                            setState(() => s['status'] = 'Active');
                            showAdminSnack(context, '${s['name']} renewed');
                          },
                          child: const Text('Renew', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.secondary)),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}