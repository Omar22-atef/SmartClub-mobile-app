import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../data/admin_mock_data.dart';
import '../widgets/admin_common_widgets.dart';

const _months = ['JAN', 'FEB', 'MAR', 'APR', 'MAY', 'JUN', 'JUL', 'AUG', 'SEP', 'OCT', 'NOV', 'DEC'];

class ManageEventsScreen extends StatefulWidget {
  const ManageEventsScreen({super.key});

  @override
  State<ManageEventsScreen> createState() => _ManageEventsScreenState();
}

class _ManageEventsScreenState extends State<ManageEventsScreen> {
  final List<Map<String, dynamic>> _events = AdminMockData.events.map((m) => Map<String, dynamic>.from(m)).toList();

  Future<void> _edit([Map<String, dynamic>? e]) async {
    final r = await showAdminFormSheet(
      context,
      title: e == null ? 'Create Event' : 'Edit Event',
      submitLabel: e == null ? 'Create Event' : 'Save Changes',
      fields: [
        FormFieldSpec('title', 'Event title', initial: e?['title'] ?? ''),
        FormFieldSpec('location', 'Location', initial: e?['location'] ?? ''),
        FormFieldSpec('date', 'Date', initial: e?['date'] ?? '', isDate: true),
        FormFieldSpec('capacity', 'Capacity', initial: '${e?['capacity'] ?? ''}', keyboard: TextInputType.number),
        FormFieldSpec('description', 'Description', initial: e?['description'] ?? '', maxLines: 3),
      ],
    );
    if (r == null || !mounted) return;
    setState(() {
      final data = {
        'title': r['title'],
        'location': r['location'],
        'date': r['date'],
        'capacity': int.tryParse(r['capacity']!) ?? 0,
        'description': r['description'],
      };
      if (e == null) {
        _events.insert(0, {...data, 'registered': 0});
      } else {
        e.addAll(data);
      }
    });
    showAdminSnack(context, e == null ? 'Event created' : 'Event updated');
  }

  Future<void> _delete(Map<String, dynamic> e) async {
    final ok = await showConfirmDialog(
      context,
      title: 'Delete event?',
      message: '"${e['title']}" will be removed permanently.',
      confirmLabel: 'Delete',
      danger: true,
    );
    if (ok != true || !mounted) return;
    setState(() => _events.remove(e));
    showAdminSnack(context, 'Event deleted');
  }

  @override
  Widget build(BuildContext context) {
    return AdminScaffold(
      eyebrow: '${_events.length} events',
      title: 'Manage Events',
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _edit(),
        icon: const Icon(Icons.add),
        label: const Text('New Event', style: TextStyle(fontWeight: FontWeight.w700)),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 96),
        children: [
          if (_events.isEmpty) const AdminEmptyState(message: 'No events yet'),
          for (final e in _events)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: AdminCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 52,
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          decoration: BoxDecoration(color: AppColors.midnightBlack, borderRadius: BorderRadius.circular(10)),
                          child: Column(
                            children: [
                              Text(_months[int.parse((e['date'] as String).substring(5, 7)) - 1],
                                  style: const TextStyle(color: AppColors.limeNeon, fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 1)),
                              Text((e['date'] as String).substring(8, 10),
                                  style: const TextStyle(color: AppColors.pureWhite, fontSize: 20, fontWeight: FontWeight.w800)),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(e['title'], style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
                              Row(
                                children: [
                                  const Icon(Icons.place_outlined, size: 14, color: AppColors.onSurfaceVariant),
                                  const SizedBox(width: 3),
                                  Text(e['location'], style: const TextStyle(color: AppColors.onSurfaceVariant, fontSize: 12)),
                                ],
                              ),
                            ],
                          ),
                        ),
                        if (e['registered'] >= e['capacity']) const StatusChip('Full', tone: ChipTone.warning),
                      ],
                    ),
                    const SizedBox(height: 12),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: e['capacity'] == 0 ? 0 : (e['registered'] / e['capacity']).clamp(0.0, 1.0),
                        minHeight: 6,
                        backgroundColor: AppColors.surfaceContainer,
                        color: AppColors.limeNeon,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text('${e['registered']} / ${e['capacity']} registered',
                        style: const TextStyle(color: AppColors.onSurfaceVariant, fontSize: 12, fontWeight: FontWeight.w500)),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton.icon(
                          onPressed: () => _delete(e),
                          icon: const Icon(Icons.delete_outline, size: 16),
                          label: const Text('Delete'),
                          style: TextButton.styleFrom(foregroundColor: AppColors.error),
                        ),
                        TextButton.icon(
                          onPressed: () => _edit(e),
                          icon: const Icon(Icons.edit_outlined, size: 16),
                          label: const Text('Edit'),
                          style: TextButton.styleFrom(foregroundColor: AppColors.midnightBlack),
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