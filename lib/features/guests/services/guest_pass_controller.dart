import 'package:flutter/foundation.dart';
import '../models/guest_pass_model.dart';

class GuestPassController extends ChangeNotifier {
  GuestPassController._();

  static final GuestPassController instance = GuestPassController._();

  static const int totalPasses = 4;
  int _remainingPasses = 3;
  int _passSequence = 9410;

  final List<GuestPassRecord> _history = [
    const GuestPassRecord(
      id: '2',
      initials: 'KM',
      guestName: 'khaled mnohamed ',
      email: 'k.m@email.com',
      phoneNumber: '+20 100 555 0192',
      visitDate: 'Friday, Mar 28, 2025',
      subtitle: 'Valid Mar 28, 2025 • Full Club',
      status: GuestPassStatus.pending,
      passCode: '#GP-8831-C',
      clearedZones: [
        'Clubhouse & Locker Access',
        'Tennis / Padel Court Access',
        'Thermal Spa & Recovery',
      ],
    ),
    const GuestPassRecord(
      id: '1',
      initials: 'MR',
      guestName: 'Mohamed Rashed',
      email: 'm.rashed@email.com',
      phoneNumber: '+20 100 555 0193',
      visitDate: 'Monday, Mar 10, 2025',
      subtitle: 'Used Mar 10, 2025 • Padel Court 2',
      status: GuestPassStatus.completed,
      passCode: '#GP-8790-A',
      clearedZones: [
        'Clubhouse & Locker Access',
        'Tennis / Padel Court Access',
      ],
    ),
  ];

  int get remainingPasses => _remainingPasses;
  int get nextSequence => _passSequence + 1;
  bool get canGenerate => _remainingPasses > 0;
  List<GuestPassRecord> get history => List.unmodifiable(_history);

  GuestPassRecord issuePass({
    required String guestName,
    required String email,
    required String phoneNumber,
    required String visitDate,
    required String shortDate,
    required List<String> clearedZones,
    required int totalAvailableZones,
  }) {
    _passSequence += 1;
    if (_remainingPasses > 0) {
      _remainingPasses -= 1;
    }

    final zoneSummary = clearedZones.length == totalAvailableZones
        ? 'Full Club'
        : '${clearedZones.length} Zones Cleared';

    final newRecord = GuestPassRecord(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      initials: GuestPassRecord.extractInitials(guestName),
      guestName: guestName,
      email: email,
      phoneNumber: phoneNumber,
      visitDate: visitDate,
      subtitle: 'Valid $shortDate • $zoneSummary',
      status: GuestPassStatus.pending,
      passCode: '#GP-$_passSequence-B',
      clearedZones: clearedZones,
    );

    _history.insert(0, newRecord);
    notifyListeners();
    return newRecord;
  }
}