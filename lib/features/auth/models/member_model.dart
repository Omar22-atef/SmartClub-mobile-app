enum MembershipType {
  basic('Basic'),
  silver('Silver'),
  gold('Gold'),
  platinum('Platinum');

  const MembershipType(this.label);
  final String label;
}

enum MembershipStatus {
  active('Active'),
  expired('Expired');

  const MembershipStatus(this.label);
  final String label;
}

class Member {
  const Member({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.membershipNumber,
    required this.membershipType,
    required this.joinDate,
    required this.expiryDate,
  });

  final String id;
  final String fullName;
  final String email;
  final String phone;
  final String membershipNumber;
  final MembershipType membershipType;
  final DateTime joinDate;
  final DateTime expiryDate;

  /// Active until the expiry date passes.
  MembershipStatus get status => DateTime.now().isBefore(expiryDate)
      ? MembershipStatus.active
      : MembershipStatus.expired;

  bool get isActive => status == MembershipStatus.active;

  int get daysRemaining {
    final days = expiryDate.difference(DateTime.now()).inDays;
    return days < 0 ? 0 : days;
  }

  /// "Mahmoud Ali" -> "MA"
  String get initials {
    final parts = fullName
        .trim()
        .split(RegExp(r'\s+'))
        .where((p) => p.isNotEmpty)
        .toList();
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts.first[0].toUpperCase();
    return (parts.first[0] + parts.last[0]).toUpperCase();
  }

  Member copyWith({
    String? fullName,
    String? email,
    String? phone,
  }) {
    return Member(
      id: id,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      membershipNumber: membershipNumber,
      membershipType: membershipType,
      joinDate: joinDate,
      expiryDate: expiryDate,
    );
  }
}