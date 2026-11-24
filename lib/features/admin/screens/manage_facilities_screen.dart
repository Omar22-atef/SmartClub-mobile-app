import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../data/admin_mock_data.dart';
import '../widgets/admin_common_widgets.dart';

class ManageFacilitiesScreen extends StatefulWidget {
  const ManageFacilitiesScreen({super.key});

  @override
  State<ManageFacilitiesScreen> createState() => _ManageFacilitiesScreenState();
}

class _ManageFacilitiesScreenState extends State<ManageFacilitiesScreen> {
  final List<Map<String, dynamic>> _facilities = AdminMockData.facilities.map((m) => Map<String, dynamic>.from(m)).toList();

  Future<void> _edit([Map<String, dynamic>? f]) async {
    final r = await showAdminFormSheet(
      context,
      title: f == null ? 'Add Facility' : 'Edit Facility',
      submitLabel: f == null ? 'Add Facility' : 'Save Changes',
      fields: [
        FormFieldSpec('name', 'Facility name', initial: f?['name'] ?? ''),
        FormFieldSpec('type', 'Type (Court, Pool, Gym…)', initial: f?['type'] ?? ''),
        FormFieldSpec('price', 'Price per hour (\$)', initial: '${f?['price'] ?? ''}', keyboard: TextInputType.number),
        FormFieldSpec('capacity', 'Capacity', initial: '${f?['capacity'] ?? ''}', keyboard: TextInputType.number),
      ],
    );
    if (r == null || !mounted) return;
    setState(() {
      final data = {
        'name': r['name'],
        'type': r['type'],
        'price': int.tryParse(r['price']!) ?? 0,
        'capacity': int.tryParse(r['capacity']!) ?? 0,
      };
      if (f == null) {
        _facilities.add({...data, 'available': true});
      } else {
        f.addAll(data);
      }
    });
    showAdminSnack(context, f == null ? 'Facility added' : 'Facility updated');
  }

  Future<void> _delete(Map<String, dynamic> f) async {
    final ok = await showConfirmDialog(
      context,
      title: 'Remove facility?',
      message: '${f['name']} will no longer be bookable.',
      confirmLabel: 'Remove',
      danger: true,
    );
    if (ok != true || !mounted) return;
    setState(() => _facilities.remove(f));
    showAdminSnack(context, 'Facility removed');
  }

  @override
  Widget build(BuildContext context) {
    final open = _facilities.where((f) => f['available'] == true).length;
    return AdminScaffold(
      eyebrow: '$open of ${_facilities.length} available',
      title: 'Manage Facilities',
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _edit(),
        icon: const Icon(Icons.add),
        label: const Text('Add Facility', style: TextStyle(fontWeight: FontWeight.w700)),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 96),
        children: [
          if (_facilities.isEmpty) const AdminEmptyState(message: 'No facilities yet'),
          for (final f in _facilities)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: AdminCard(
                child: Column(
                  children: [
                    Row(
                      children: [
                        IconBox(iconForFacility('${f['name']} ${f['type']}'), lime: f['available'] == true),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(f['name'], style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
                              Text('${f['type']} • \$${f['price']}/hr • up to ${f['capacity']}',
                                  style: const TextStyle(color: AppColors.onSurfaceVariant, fontSize: 12)),
                            ],
                          ),
                        ),
                        StatusChip(f['available'] == true ? 'Available' : 'Maintenance'),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Switch(
                          value: f['available'] == true,
                          thumbColor: const WidgetStatePropertyAll(AppColors.midnightBlack),
                          activeTrackColor: AppColors.limeNeon,
                          inactiveTrackColor: AppColors.surfaceContainer,
                          trackOutlineColor: const WidgetStatePropertyAll(Colors.transparent),
                          onChanged: (v) => setState(() => f['available'] = v),
                        ),
                        const Text('Open for booking', style: TextStyle(fontSize: 12, color: AppColors.onSurfaceVariant)),
                        const Spacer(),
                        IconButton(
                          tooltip: 'Remove',
                          onPressed: () => _delete(f),
                          icon: const Icon(Icons.delete_outline, size: 20, color: AppColors.error),
                        ),
                        IconButton(
                          tooltip: 'Edit',
                          onPressed: () => _edit(f),
                          icon: const Icon(Icons.edit_outlined, size: 20),
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